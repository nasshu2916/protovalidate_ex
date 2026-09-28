defmodule Protovalidate.Rules.EnumTest do
  use ExUnit.Case, async: true

  import Protovalidate.TestRules

  alias Protovalidate.Rules.Enum, as: EnumRules

  test "enum 固有ルールと集合ルールを同じ型モジュールから評価する" do
    field = field(:TYPE_ENUM, enum_values: [0, 1])

    assert [{:in, [1]}, {:defined_only, [0, 1]}] =
             EnumRules.enum_rules(field, %{in: [1], defined_only: true})

    for {rule, id} <- [{{:in, [1]}, "enum.in"}, {{:defined_only, [0, 1]}, "enum.defined_only"}] do
      assert {:cont, %{violations: [violation]}} = EnumRules.evaluate(rule, 2, field, context())
      assert violation.rule_id == id
    end
  end
end
