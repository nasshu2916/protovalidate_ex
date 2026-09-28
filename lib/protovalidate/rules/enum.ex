defmodule Protovalidate.Rules.Enum do
  @moduledoc false

  @type compiled ::
          {:const, integer()} | {:in | :not_in, [integer()]} | {:defined_only, [integer()] | nil}

  import Protovalidate.Rules.Compilation
  import Protovalidate.Rules.Violations

  @spec enum_rules(Protovalidate.DescriptorAdapter.Field.t(), map()) :: [
          Protovalidate.Rules.compiled()
        ]
  def enum_rules(field, rules) do
    known = [:const, :defined_only, :in, :not_in]
    reject_unknown_rule_fields!(rules, known, "enum")

    defined_only = rule_value(rules, :defined_only)

    if defined_only not in [nil, false, true],
      do: compilation_error!("enum.defined_only must be a boolean", ["enum", "defined_only"])

    append_scalar_rules([], rules, [:const, :in, :not_in])
    |> add_if(defined_only == true, {:defined_only, Map.get(field, :enum_values)})
  end

  @spec evaluate(
          Protovalidate.Rules.compiled(),
          Protovalidate.Rules.value(),
          Protovalidate.DescriptorAdapter.Field.t(),
          Protovalidate.Rules.context()
        ) :: Protovalidate.Rules.result()
  def evaluate({:defined_only, values}, value, field, context) when is_list(values),
    do:
      check(
        context,
        value in values,
        field,
        "enum.defined_only",
        "value must be a defined enum value"
      )

  def evaluate({:defined_only, nil}, _value, _field, _context),
    do: compilation_error!("cannot retrieve defined enum values", ["enum", "defined_only"])

  def evaluate(rule, value, field, context),
    do: Protovalidate.Rules.Common.evaluate(rule, value, field, context)
end
