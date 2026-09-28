defmodule Protovalidate.FieldPathTest do
  use ExUnit.Case, async: true

  alias Protovalidate.FieldPath

  test "フィールドパスのセグメントを保持する" do
    path = FieldPath.new([{:field, "users"}, {:index, 0}, {:field, "email"}])

    assert path.segments == [{:field, "users"}, {:index, 0}, {:field, "email"}]
  end

  test "map key の型を値とともに保持する" do
    path = FieldPath.new([]) |> FieldPath.map_key("primary") |> FieldPath.map_key(-1)

    assert path.segments == [{:map_key, :string, "primary"}, {:map_key, :int, -1}]
  end
end
