defmodule Protovalidate.Rules do
  @moduledoc false

  import Protovalidate.Rules.Compilation

  alias Protovalidate.DescriptorAdapter
  alias Protovalidate.Rules.{Bool, Bytes, Common, Custom, Numeric, Repeated, WellKnown}
  alias Protovalidate.Rules.Enum, as: EnumRules
  alias Protovalidate.Rules.Map, as: MapRules
  alias Protovalidate.Rules.String, as: StringRules

  @type value ::
          nil
          | boolean()
          | number()
          | atom()
          | binary()
          | [value()]
          | map()
          | {integer(), integer()}
  @type compiled ::
          Protovalidate.Rules.Range.compiled()
          | Common.compiled()
          | Numeric.compiled()
          | Bool.compiled()
          | EnumRules.compiled()
          | StringRules.compiled()
          | Bytes.compiled()
          | WellKnown.compiled()
          | Repeated.compiled()
          | MapRules.compiled()
          | {:sourced, compiled(), Protovalidate.RuleSource.t()}
          | {:cel, Custom.compiled()}
          | {:predefined, Custom.predefined()}
  @type context :: Protovalidate.Plan.Context.t()
  @type result :: {:cont | :halt, context()}
  @type compiler :: (DescriptorAdapter.Field.t(), map() | nil, keyword() -> [compiled()])

  @spec compile(DescriptorAdapter.Field.t(), {atom(), map()} | nil, keyword(), compiler()) :: [
          compiled()
        ]

  def compile(_field, nil, _options, _compile_rules), do: []

  def compile(%{repeated?: true} = field, {:repeated, rules}, options, compile_rules),
    do:
      Protovalidate.Rules.Repeated.repeated_rules(
        field,
        rules,
        options,
        compile_rules
      )

  def compile(%{map?: true} = field, {:map, rules}, options, compile_rules),
    do:
      Protovalidate.Rules.Map.map_rules(
        field,
        rules,
        options,
        compile_rules
      )

  def compile(%{well_known_type: :any}, {:any, rules}, _options, _compile_rules),
    do: Protovalidate.Rules.WellKnown.any_rules(rules)

  def compile(%{well_known_type: :duration}, {:duration, rules}, _options, _compile_rules),
    do: Protovalidate.Rules.WellKnown.temporal_rules(rules, "duration")

  def compile(%{well_known_type: :timestamp}, {:timestamp, rules}, _options, _compile_rules),
    do: Protovalidate.Rules.WellKnown.temporal_rules(rules, "timestamp")

  def compile(%{well_known_type: :field_mask}, {:field_mask, rules}, _options, _compile_rules),
    do: Protovalidate.Rules.WellKnown.field_mask_rules(rules)

  def compile(%{well_known_type: {:wrapper, type}} = field, {kind, rules}, options, compile_rules) do
    wrapper_field = %{field | type: type, well_known_type: nil}
    compile(wrapper_field, {kind, rules}, options, compile_rules)
  end

  def compile(%{type: :TYPE_STRING}, {:string, rules}, _options, _compile_rules),
    do: Protovalidate.Rules.String.string_rules(rules)

  def compile(%{type: :TYPE_BYTES}, {:bytes, rules}, _options, _compile_rules),
    do: Protovalidate.Rules.Bytes.bytes_rules(rules)

  def compile(%{type: _type} = field, {kind, rules}, _options, _compile_rules)
      when kind in [
             :float,
             :double,
             :int32,
             :int64,
             :uint32,
             :uint64,
             :sint32,
             :sint64,
             :fixed32,
             :fixed64,
             :sfixed32,
             :sfixed64
           ],
      do: Numeric.compile(field, rules, kind)

  def compile(%{type: :TYPE_BOOL}, {:bool, rules}, _options, _compile_rules),
    do: Protovalidate.Rules.Bool.bool_rules(rules)

  def compile(%{type: :TYPE_ENUM} = field, {:enum, rules}, _options, _compile_rules),
    do: Protovalidate.Rules.Enum.enum_rules(field, rules)

  def compile(field, {type, _rules}, _options, _compile_rules),
    do:
      compilation_error!(
        "rule #{inspect(type)} cannot be applied to field #{field.name} of type #{inspect(field.type)}",
        [field.name, Atom.to_string(type)]
      )

  def compile(_field, type, _options, _compile_rules),
    do: unsupported!("unsupported field rule: #{inspect(type)}", ["field"])

  @spec evaluate(compiled(), value(), DescriptorAdapter.Field.t(), context()) :: result()
  def evaluate({:sourced, rule, source}, value, field, context) do
    {status, result} = evaluate(rule, value, field, %{context | active_source: source})
    {status, %{result | active_source: context.active_source}}
  end

  def evaluate(:required = rule, value, field, context),
    do: Common.evaluate(rule, value, field, context)

  def evaluate({:ignore, _} = rule, value, field, context),
    do: Common.evaluate(rule, value, field, context)

  def evaluate({kind, _} = rule, value, field, context) when kind in [:cel, :predefined],
    do: Custom.evaluate(rule, value, field, context)

  def evaluate({kind, _} = rule, value, field, context)
      when kind in [:min_items, :max_items, :unique],
      do: Repeated.evaluate(rule, value, field, context)

  def evaluate({kind, _} = rule, value, field, context)
      when kind in [:min_pairs, :max_pairs],
      do: MapRules.evaluate(rule, value, field, context)

  def evaluate(rule, value, field, context),
    do:
      evaluator(field).evaluate(rule, DescriptorAdapter.enum_value(field, value), field, context)

  defp evaluator(%{well_known_type: {:wrapper, type}}), do: evaluator(%{type: type})

  defp evaluator(%{well_known_type: type})
       when type in [:any, :duration, :timestamp, :field_mask],
       do: WellKnown

  defp evaluator(%{type: :TYPE_STRING}), do: StringRules
  defp evaluator(%{type: :TYPE_BYTES}), do: Bytes
  defp evaluator(%{type: :TYPE_BOOL}), do: Bool
  defp evaluator(%{type: :TYPE_ENUM}), do: EnumRules
  defp evaluator(_field), do: Numeric
end
