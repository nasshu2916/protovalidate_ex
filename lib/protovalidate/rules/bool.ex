defmodule Protovalidate.Rules.Bool do
  @moduledoc false

  @type compiled :: {:const, boolean()}

  import Protovalidate.Rules.Compilation

  @spec bool_rules(map()) :: [Protovalidate.Rules.compiled()]
  def bool_rules(rules) do
    reject_unknown_rule_fields!(rules, [:const], "bool")

    case rule_value(rules, :const) do
      nil -> []
      value when is_boolean(value) -> [{:const, value}]
      _ -> compilation_error!("bool.const must be a boolean", ["bool", "const"])
    end
  end

  @spec evaluate(
          compiled(),
          boolean(),
          Protovalidate.DescriptorAdapter.Field.t(),
          Protovalidate.Rules.context()
        ) :: Protovalidate.Rules.result()
  defdelegate evaluate(rule, value, field, context), to: Protovalidate.Rules.Common
end
