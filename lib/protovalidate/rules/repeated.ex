defmodule Protovalidate.Rules.Repeated do
  @moduledoc false

  @type compiled ::
          {:min_items | :max_items, non_neg_integer()}
          | {:unique, boolean()}
          | {:items, [Protovalidate.Rules.compiled()]}

  import Protovalidate.Rules.Compilation
  import Protovalidate.Rules.Violations

  @spec repeated_rules(
          Protovalidate.DescriptorAdapter.Field.t(),
          map(),
          keyword(),
          Protovalidate.Rules.compiler()
        ) :: [Protovalidate.Rules.compiled()]
  def repeated_rules(field, rules, options, compile_rules) do
    known = [:min_items, :max_items, :unique, :items]
    reject_unknown_rule_fields!(rules, known, "repeated")

    item_rules =
      case rule_value(rules, :items) do
        nil ->
          []

        nested_rules ->
          compile_collection_item_rules!(field, nested_rules, options, compile_rules)
      end

    append_scalar_rules([], rules, [:min_items, :max_items, :unique])
    |> add_if(item_rules != [], {:items, item_rules})
  end

  defp compile_collection_item_rules!(field, nested_rules, options, compile_rules) do
    virtual_field = Protovalidate.DescriptorAdapter.collection_field(field, :items)

    compile_rules.(virtual_field, nested_rules, options)
  end

  @spec evaluate(
          Protovalidate.Rules.compiled(),
          Protovalidate.Rules.value(),
          Protovalidate.DescriptorAdapter.Field.t(),
          Protovalidate.Rules.context()
        ) :: Protovalidate.Rules.result()
  def evaluate({:min_items, limit}, value, field, context),
    do:
      check(
        context,
        length(value) >= limit,
        field,
        "repeated.min_items",
        "fewer than the minimum number of items"
      )

  def evaluate({:max_items, limit}, value, field, context),
    do:
      check(
        context,
        length(value) <= limit,
        field,
        "repeated.max_items",
        "more than the maximum number of items"
      )

  def evaluate({:unique, true}, value, field, context),
    do:
      check(
        context,
        length(value) == length(Enum.uniq(value)),
        field,
        "repeated.unique",
        "items must be unique"
      )

  def evaluate({:unique, false}, _value, _field, context), do: {:cont, context}
end
