defmodule PhoenixSampleWeb.UserControllerTest do
  use PhoenixSampleWeb.ConnCase, async: true

  describe "POST /api/users" do
    test "有効なパラメータの場合は 201 Created を返す", %{conn: conn} do
      params = %{
        "id" => "550e8400-e29b-41d4-a716-446655440000",
        "email" => "alice@example.com",
        "age" => 28,
        "first_name" => "Alice",
        "last_name" => "Smith"
      }

      conn = post(conn, ~p"/api/users", params)
      response = json_response(conn, 201)

      assert response["status"] == "ok"
      assert response["user"]["email"] == "alice@example.com"
      assert response["user"]["age"] == 28
    end

    test "バリデーション違反時は 422 Unprocessable Entity を返す", %{conn: conn} do
      params = %{
        "id" => "bad-uuid",
        "email" => "invalid-email",
        "age" => 200
      }

      conn = post(conn, ~p"/api/users", params)
      response = json_response(conn, 422)

      assert response["status"] == "error"
      rule_ids = Enum.map(response["errors"], & &1["rule_id"])

      assert "string.uuid" in rule_ids
      assert "string.email" in rule_ids
      assert "uint32.lte" in rule_ids
    end

    test "CEL カスタムルール違反時 (名のみで姓未指定) に 422 を返す", %{conn: conn} do
      params = %{
        "id" => "550e8400-e29b-41d4-a716-446655440000",
        "email" => "bob@example.com",
        "age" => 30,
        "first_name" => "Bob",
        "last_name" => ""
      }

      conn = post(conn, ~p"/api/users", params)
      response = json_response(conn, 422)

      assert response["status"] == "error"

      cel_error =
        Enum.find(response["errors"], &(&1["rule_id"] == "first_name_requires_last_name"))

      assert cel_error != nil
      assert cel_error["message"] =~ "last_name must be present if first_name is present"
      assert cel_error["field"] == "message"
    end

    test "型が不正な JSON パラメータの場合は 400 Bad Request を返す", %{conn: conn} do
      params = %{
        "id" => "550e8400-e29b-41d4-a716-446655440000",
        "age" => "not-a-number"
      }

      conn = post(conn, ~p"/api/users", params)
      response = json_response(conn, 400)

      assert response["status"] == "error"
      assert response["message"] =~ "age"
    end
  end
end
