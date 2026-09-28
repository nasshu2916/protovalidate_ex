defmodule Protovalidate.ViolationTest do
  use ExUnit.Case, async: true

  alias Protovalidate.{FieldPath, Violation}

  test "違反の必須情報と任意情報を保持する" do
    path = FieldPath.new([{:field, "email"}])

    violation =
      Violation.new(path, "string.email", "有効なメールアドレスである必要があります", details: %{constraint: :email})

    assert violation.field_path == path
    assert violation.rule_id == "string.email"
    assert violation.for_key == false
    assert violation.details == %{constraint: :email}
  end
end
