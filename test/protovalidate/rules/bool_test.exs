defmodule Protovalidate.Rules.BoolTest do
  use ExUnit.Case, async: true

  import Protovalidate.TestRules

  alias Protovalidate.Rules.Bool

  test "false の const を省略せず、boolean 以外を拒否する" do
    assert [{:const, false}] = Bool.bool_rules(%{const: false})

    assert {:cont, %{violations: [violation]}} =
             Bool.evaluate({:const, false}, true, field(:TYPE_BOOL), context())

    assert violation.rule_id == "bool.const"
    error = assert_raise Protovalidate.CompilationError, fn -> Bool.bool_rules(%{const: 0}) end
    assert error.rule_path == ["bool", "const"]
  end
end
