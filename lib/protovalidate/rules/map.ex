defmodule Protovalidate.Rules.Map do
  @moduledoc false

  @type compiled ::
          {:min_pairs | :max_pairs, non_neg_integer()}
          | {:keys | :values, [Protovalidate.Rules.compiled()]}

  import Protovalidate.Rules.Compilation
  import Protovalidate.Rules.Violations

  @spec map_rules(
          Protovalidate.DescriptorAdapter.Field.t(),
          map(),
          keyword(),
          Protovalidate.Rules.compiler()
        ) :: [Protovalidate.Rules.compiled()]
  def map_rules(field, rules, options, compile_rules) do
    known = [:min_pairs, :max_pairs, :keys, :values]
    reject_unknown_rule_fields!(rules, known, "map")

    key_rules =
      compile_map_rules!(field, rule_value(rules, :keys), :map_key, options, compile_rules)

    value_rules =
      compile_map_rules!(field, rule_value(rules, :values), :map_value, options, compile_rules)

    append_scalar_rules([], rules, [:min_pairs, :max_pairs])
    |> add_if(key_rules != [], {:keys, key_rules})
    |> add_if(value_rules != [], {:values, value_rules})
  end

  defp compile_map_rules!(_field, nil, _type_key, _options, _compile_rules), do: []

  defp compile_map_rules!(field, nested_rules, type_key, options, compile_rules) do
    case Map.get(field, type_key) do
      nil ->
        compilation_error!("cannot retrieve map #{type_key} type", [
          "map",
          Atom.to_string(type_key)
        ])

      _type ->
        kind = if type_key == :map_key, do: :keys, else: :values
        virtual_field = Protovalidate.DescriptorAdapter.collection_field(field, kind)

        compile_rules.(virtual_field, nested_rules, options)
    end
  end

  @spec evaluate(
          Protovalidate.Rules.compiled(),
          Protovalidate.Rules.value(),
          Protovalidate.DescriptorAdapter.Field.t(),
          Protovalidate.Rules.context()
        ) :: Protovalidate.Rules.result()
  def evaluate({:min_pairs, limit}, value, field, context),
    do:
      check(
        context,
        map_size(value) >= limit,
        field,
        "map.min_pairs",
        "fewer than the minimum number of items"
      )

  def evaluate({:max_pairs, limit}, value, field, context),
    do:
      check(
        context,
        map_size(value) <= limit,
        field,
        "map.max_pairs",
        "more than the maximum number of items"
      )
end
