defmodule Protovalidate.Rules.WellKnown do
  @moduledoc false

  @type compiled ::
          {:const | :lt | :lte | :gt | :gte | :within, map() | {integer(), integer()}}
          | {:in | :not_in, [map() | binary() | {integer(), integer()}]}
          | {:lt_now | :gt_now, true}
          | {:example, [binary()]}

  import Protovalidate.Rules.Compilation
  import Protovalidate.Rules.Violations

  @spec any_rules(map()) :: [Protovalidate.Rules.compiled()]
  def any_rules(rules) do
    known = [:in, :not_in]
    reject_unknown_rule_fields!(rules, known, "any")
    append_scalar_rules([], rules, known)
  end

  @spec temporal_rules(map(), String.t()) :: [Protovalidate.Rules.compiled()]
  def temporal_rules(rules, kind) do
    known = [:const, :lt, :lte, :gt, :gte, :in, :not_in] ++ timestamp_rule_keys(kind)
    reject_unknown_rule_fields!(rules, known, kind)
    reject_conflicting_bounds!(rules, kind)

    append_scalar_rules([], rules, known -- [:lt_now, :gt_now, :within])
    |> Protovalidate.Rules.Range.compile()
    |> append_timestamp_rules(rules, kind)
  end

  @spec field_mask_rules(map()) :: [Protovalidate.Rules.compiled()]
  def field_mask_rules(rules) do
    known = [:const, :in, :not_in, :example]
    reject_unknown_rule_fields!(rules, known, "field_mask")
    append_scalar_rules([], rules, known -- [:example])
  end

  def unwrap_wrapper(%{well_known_type: {:wrapper, _}}, %{value: value}), do: value
  def unwrap_wrapper(_field, value), do: value

  defp evaluate_wkt_comparison(rule, value, limit, field, type, context) do
    valid? =
      case {wkt_value(value), wkt_value(limit), rule} do
        {{seconds, nanos}, {limit_seconds, limit_nanos}, :lt} ->
          {seconds, nanos} < {limit_seconds, limit_nanos}

        {{seconds, nanos}, {limit_seconds, limit_nanos}, :lte} ->
          {seconds, nanos} <= {limit_seconds, limit_nanos}

        {{seconds, nanos}, {limit_seconds, limit_nanos}, :gt} ->
          {seconds, nanos} > {limit_seconds, limit_nanos}

        {{seconds, nanos}, {limit_seconds, limit_nanos}, :gte} ->
          {seconds, nanos} >= {limit_seconds, limit_nanos}

        _ ->
          false
      end

    check(
      context,
      valid?,
      field,
      "#{type}.#{rule}",
      Protovalidate.Rules.Messages.comparison(rule, limit, type)
    )
  end

  defp evaluate_wkt_membership(
         operation,
         expected,
         value,
         %{well_known_type: :field_mask} = field,
         context
       ) do
    paths = wkt_value(value)

    valid? =
      case operation do
        :in -> Enum.all?(paths, &field_mask_path_allowed?(&1, expected))
        :not_in -> Enum.all?(paths, &(not field_mask_path_allowed?(&1, expected)))
      end

    check(context, valid?, field, "field_mask.#{operation}", "field mask path is not allowed")
  end

  defp evaluate_wkt_membership(
         operation,
         expected,
         value,
         %{well_known_type: type} = field,
         context
       ) do
    member? = wkt_value(value) in Enum.map(expected, &wkt_value/1)
    valid? = if operation == :in, do: member?, else: not member?
    check(context, valid?, field, "#{type}.#{operation}", "value is not allowed")
  end

  defp field_mask_path_allowed?(path, allowed_paths) do
    path in allowed_paths or Enum.any?(allowed_paths, &String.starts_with?(path, &1 <> "."))
  end

  defp wkt_value(%{seconds: seconds, nanos: nanos}), do: {seconds, nanos}
  defp wkt_value(%{paths: paths}), do: paths
  defp wkt_value(value), do: value

  def timestamp_now do
    nanoseconds = System.system_time(:nanosecond)
    %{seconds: div(nanoseconds, 1_000_000_000), nanos: rem(nanoseconds, 1_000_000_000)}
  end

  defp timestamp_tuple(value), do: wkt_value(value)
  defp duration_nanos(%{seconds: seconds, nanos: nanos}), do: seconds * 1_000_000_000 + nanos
  defp duration_nanos({seconds, nanos}), do: seconds * 1_000_000_000 + nanos

  defp timestamp_rule_keys("timestamp"), do: [:lt_now, :gt_now, :within]
  defp timestamp_rule_keys(_kind), do: []

  defp append_timestamp_rules(compiled, _rules, kind) when kind != "timestamp", do: compiled

  defp append_timestamp_rules(compiled, rules, "timestamp") do
    compiled
    |> add_if(rule_value(rules, :lt_now) == true, {:lt_now, true})
    |> add_if(rule_value(rules, :gt_now) == true, {:gt_now, true})
    |> add_if(not is_nil(rule_value(rules, :within)), {:within, rule_value(rules, :within)})
  end

  @spec evaluate(
          Protovalidate.Rules.compiled(),
          Protovalidate.Rules.value(),
          Protovalidate.DescriptorAdapter.Field.t(),
          Protovalidate.Rules.context()
        ) :: Protovalidate.Rules.result()
  def evaluate({:range, range}, value, field, context),
    do: Protovalidate.Rules.Range.evaluate(range, value, field, context)

  def evaluate({:in, expected}, value, %{well_known_type: :any} = field, context),
    do:
      check(
        context,
        Map.get(value, :type_url) in expected,
        field,
        "any.in",
        "type URL must be in the allow list"
      )

  def evaluate({:not_in, expected}, value, %{well_known_type: :any} = field, context),
    do:
      check(
        context,
        Map.get(value, :type_url) not in expected,
        field,
        "any.not_in",
        "type is not allowed"
      )

  def evaluate({:in, expected}, value, %{well_known_type: type} = field, context)
      when type in [:duration, :timestamp, :field_mask],
      do: evaluate_wkt_membership(:in, expected, value, field, context)

  def evaluate({:not_in, expected}, value, %{well_known_type: type} = field, context)
      when type in [:duration, :timestamp, :field_mask],
      do: evaluate_wkt_membership(:not_in, expected, value, field, context)

  def evaluate({:const, expected}, value, %{well_known_type: type} = field, context)
      when type in [:duration, :timestamp, :field_mask],
      do:
        check(
          context,
          wkt_value(value) == wkt_value(expected),
          field,
          "#{type}.const",
          "value must match the constant"
        )

  def evaluate({rule, limit}, value, %{well_known_type: type} = field, context)
      when type in [:duration, :timestamp] and rule in [:lt, :lte, :gt, :gte],
      do: evaluate_wkt_comparison(rule, value, limit, field, type, context)

  def evaluate({:lt_now, true}, value, %{well_known_type: :timestamp} = field, context),
    do:
      check(
        context,
        timestamp_tuple(value) < timestamp_tuple(context.now),
        field,
        "timestamp.lt_now",
        "must be earlier than the current time"
      )

  def evaluate({:gt_now, true}, value, %{well_known_type: :timestamp} = field, context),
    do:
      check(
        context,
        timestamp_tuple(value) > timestamp_tuple(context.now),
        field,
        "timestamp.gt_now",
        "must be later than the current time"
      )

  def evaluate({:within, duration}, value, %{well_known_type: :timestamp} = field, context) do
    {seconds, nanos} = timestamp_tuple(value)
    {now_seconds, now_nanos} = timestamp_tuple(context.now)

    valid? =
      abs(seconds * 1_000_000_000 + nanos - (now_seconds * 1_000_000_000 + now_nanos)) <=
        duration_nanos(duration)

    check(
      context,
      valid?,
      field,
      "timestamp.within",
      "must be within the specified range of the current time"
    )
  end

  def evaluate(rule, value, field, context),
    do: Protovalidate.Rules.Common.evaluate(rule, value, field, context)
end
