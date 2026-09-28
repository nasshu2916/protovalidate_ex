defmodule Protovalidate.Rules.Numeric do
  @moduledoc false

  @type numeric_value :: number() | :nan | :infinity | :negative_infinity
  @type compiled ::
          {:const | :lt | :lte | :gt | :gte, numeric_value()}
          | {:in | :not_in, [numeric_value()]}
          | {:finite, boolean()}

  import Protovalidate.Rules.Compilation
  import Protovalidate.Rules.Violations

  @spec compile(Protovalidate.DescriptorAdapter.Field.t(), map(), atom()) :: [
          Protovalidate.Rules.compiled()
        ]
  def compile(field, rules, kind) do
    if numeric_kind(field.type) == kind do
      numeric_rules(rules, Atom.to_string(kind))
    else
      compilation_error!(
        "rule #{inspect(kind)} cannot be applied to field #{field.name} of type #{inspect(field.type)}",
        [field.name, Atom.to_string(kind)]
      )
    end
  end

  @spec numeric_rules(map(), String.t()) :: [Protovalidate.Rules.compiled()]
  def numeric_rules(rules, kind) do
    known = [:const, :lt, :lte, :gt, :gte, :in, :not_in, :finite]
    reject_unknown_rule_fields!(rules, known, kind)
    reject_conflicting_bounds!(rules, kind)

    Enum.flat_map(known, &numeric_rule(rules, kind, &1))
    |> Protovalidate.Rules.Range.compile()
  end

  defp numeric_rule(rules, kind, key) do
    value = rule_value(rules, key)

    cond do
      value in [nil, []] ->
        []

      key in [:in, :not_in] and is_list(value) ->
        validate_numeric_list!(value, kind, key)

      key == :finite and is_boolean(value) ->
        [{key, value}]

      numeric_value?(value, kind) ->
        [{key, value}]

      true ->
        compilation_error!("#{kind}.#{key} must be a number", [kind, Atom.to_string(key)])
    end
  end

  defp validate_numeric_list!(values, kind, key) do
    if Enum.all?(values, &numeric_value?(&1, kind)),
      do: [{key, values}],
      else:
        compilation_error!("#{kind}.#{key} must be a list of numbers", [kind, Atom.to_string(key)])
  end

  defp numeric_value?(value, kind),
    do:
      is_number(value) or
        (kind in ["float", "double"] and value in [:nan, :infinity, :negative_infinity])

  # protobuf の特殊値は atom なので、BEAM の項順序ではなく数値の意味論で比較する。
  def compare(:nan, _), do: :unordered
  def compare(_, :nan), do: :unordered
  def compare(value, value), do: :eq
  def compare(:negative_infinity, _), do: :lt
  def compare(_, :infinity), do: :lt
  def compare(:infinity, _), do: :gt
  def compare(_, :negative_infinity), do: :gt
  def compare(left, right) when left < right, do: :lt
  def compare(left, right) when left > right, do: :gt
  def compare(_, _), do: :eq

  defp numeric_kind(type) when is_atom(type) do
    case Atom.to_string(type) do
      "TYPE_" <> name -> name |> String.downcase() |> String.to_existing_atom()
      _ -> nil
    end
  end

  defp numeric_kind(_type), do: nil

  @spec evaluate(
          Protovalidate.Rules.compiled(),
          Protovalidate.Rules.value(),
          Protovalidate.DescriptorAdapter.Field.t(),
          Protovalidate.Rules.context()
        ) :: Protovalidate.Rules.result()
  def evaluate({:range, range}, value, field, context),
    do: Protovalidate.Rules.Range.evaluate(range, value, field, context)

  def evaluate({:lt, limit}, value, field, context),
    do:
      check(
        context,
        compare(value, limit) == :lt,
        field,
        rule_id(field, "lt"),
        Protovalidate.Rules.Messages.comparison(:lt, limit)
      )

  def evaluate({:lte, limit}, value, field, context),
    do:
      check(
        context,
        compare(value, limit) in [:lt, :eq],
        field,
        rule_id(field, "lte"),
        Protovalidate.Rules.Messages.comparison(:lte, limit),
        %{
          lte: limit
        }
      )

  def evaluate({:gt, limit}, value, field, context),
    do:
      check(
        context,
        compare(value, limit) == :gt,
        field,
        rule_id(field, "gt"),
        Protovalidate.Rules.Messages.comparison(:gt, limit)
      )

  def evaluate({:gte, limit}, value, field, context),
    do:
      check(
        context,
        compare(value, limit) in [:gt, :eq],
        field,
        rule_id(field, "gte"),
        Protovalidate.Rules.Messages.comparison(:gte, limit)
      )

  def evaluate({:finite, true}, value, field, context),
    do:
      check(
        context,
        is_number(value),
        field,
        rule_id(field, "finite"),
        "value must be finite"
      )

  def evaluate({:finite, false}, _value, _field, context), do: {:cont, context}

  def evaluate({:const, expected}, value, field, context),
    do:
      check(
        context,
        compare(value, expected) == :eq,
        field,
        rule_id(field, "const"),
        Protovalidate.Rules.Messages.constant(expected, field)
      )

  def evaluate({kind, expected}, value, field, context) when kind in [:in, :not_in] do
    member? = Enum.any?(expected, &(compare(value, &1) == :eq))

    check(
      context,
      member? == (kind == :in),
      field,
      rule_id(field, Atom.to_string(kind)),
      Protovalidate.Rules.Messages.membership(kind, expected)
    )
  end

  def evaluate(rule, value, field, context),
    do: Protovalidate.Rules.Common.evaluate(rule, value, field, context)
end
