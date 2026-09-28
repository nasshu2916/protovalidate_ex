defmodule Protovalidate.Plan.Evaluator do
  @moduledoc false
  import Protovalidate.Rules.Violations

  alias Protovalidate.{DescriptorAdapter, FieldPath, InputBoundary, Plan}
  alias Protovalidate.Plan.{CollectionPlan, Context, FieldPlan}
  alias Protovalidate.Validator.PlanCache

  @spec evaluate(Plan.t(), struct(), keyword()) ::
          {:ok, [Protovalidate.Violation.t()]} | {:error, Protovalidate.RuntimeError.t()}
  def evaluate(%Plan{} = plan, %module{} = message, options) when module == plan.module do
    context = Context.new(options)

    context =
      if Keyword.has_key?(options, :validator),
        do: run(plan, message, context),
        else: evaluate_message(plan, message, context)

    Context.remaining(context)
    {:ok, Enum.reverse(context.violations)}
  end

  def evaluate(%Plan{}, _message, _options),
    do:
      {:error,
       %Protovalidate.RuntimeError{
         message: "validation plan does not match the message type",
         code: :message_type_mismatch,
         stage: :input
       }}

  defp run(plan, message, context) do
    started_at = System.monotonic_time()
    before = context.count
    scope = if context.path == [], do: :root, else: :child

    :telemetry.execute(
      [:protovalidate, :message, :start],
      %{},
      %{message_module: plan.module, scope: scope}
    )

    try do
      result = evaluate_message(plan, message, context)
      emit(started_at, plan.module, :ok, result.count - before)
      emit_message(started_at, plan.module, scope, :ok, result.count - before)
      result
    rescue
      error ->
        emit(started_at, plan.module, :error, 0)

        emit_message(
          started_at,
          plan.module,
          scope,
          Protovalidate.Validator.Telemetry.classify_error(error),
          0
        )

        reraise error, __STACKTRACE__
    end
  end

  defp evaluate_message(plan, message, context) do
    context = Context.for_plan(context, plan)
    Context.remaining(context)
    context = Enum.reduce_while(plan.oneofs, context, &evaluate_oneof(&1, message, &2))

    context =
      if context.stopped,
        do: context,
        else:
          Enum.reduce_while(
            plan.message_oneofs,
            context,
            &evaluate_message_oneof(&1, message, &2)
          )

    context = evaluate_fields(plan.fields, message, context, context.options)
    evaluate_message_cel_rules(plan.cel_rules, message, context)
  end

  defp emit(started_at, module, outcome, violations) do
    :telemetry.execute(
      [:protovalidate, :validation, :stop],
      %{duration: System.monotonic_time() - started_at, violations: violations},
      %{message_module: module, outcome: outcome}
    )
  end

  defp emit_message(started_at, module, scope, outcome, violations) do
    :telemetry.execute(
      [:protovalidate, :message, :stop],
      %{duration: System.monotonic_time() - started_at, violations: violations},
      %{message_module: module, scope: scope, outcome: outcome}
    )
  end

  defp evaluate_fields(
         _fields,
         _message,
         %{stopped: true} = context,
         _options
       ),
       do: context

  defp evaluate_fields(fields, message, context, options),
    do: Enum.reduce_while(fields, context, &evaluate_field(&1, message, &2, options))

  defp evaluate_message_cel_rules(
         _rules,
         _message,
         %{stopped: true} = context
       ),
       do: context

  defp evaluate_message_cel_rules(rules, message, context),
    do:
      Enum.reduce_while(
        rules,
        context,
        &Protovalidate.Rules.Custom.evaluate_cel_rule(&1, message, &2)
      )

  defp evaluate_message_oneof(rule, message, context) do
    Context.remaining(context)

    count =
      Enum.count(rule.fields, fn field ->
        value = DescriptorAdapter.field_value(message, field)
        presence = input_presence(message, String.to_existing_atom(field.name))

        not Protovalidate.Rules.Common.required_missing?(
          field,
          presence,
          DescriptorAdapter.enum_value(field, value)
        )
      end)

    if count == 1 or (count == 0 and not rule.required) do
      {:cont, context}
    else
      add(
        context,
        Protovalidate.Violation.new(
          FieldPath.new([]),
          "message.oneof",
          message_oneof_message(rule.fields, count),
          rule_path: ["oneof", to_string(rule.index)],
          details: %{constraint: :message_oneof},
          origin: rule.origin
        )
      )
    end
  end

  defp message_oneof_message(fields, count) do
    names = Enum.map_join(fields, ", ", & &1.name)
    if count == 0, do: "one of #{names} must be set", else: "only one of #{names} can be set"
  end

  defp evaluate_oneof(%{required: false}, _message, context), do: {:cont, context}

  defp evaluate_oneof(%{oneof: oneof, source: source, origin: origin}, message, context) do
    Context.remaining(context)

    selected? =
      Enum.any?(
        oneof.fields,
        &(input_presence(message, String.to_atom(&1)) == :present)
      )

    if selected? do
      {:cont, context}
    else
      add(
        context,
        Protovalidate.Violation.new(
          FieldPath.new([{:field, oneof.name}]),
          "required",
          "exactly one field is required in oneof",
          rule_path: [],
          rule_source: source,
          details: %{constraint: :oneof_required},
          origin: origin
        )
      )
    end
  end

  # ルールがない message も子 message のルールを評価するため、scalar だけをスキップする。
  defp evaluate_field(
         %FieldPlan{
           field: %{type: type},
           checks: [],
           presence: :optional,
           ignore: nil,
           collection: nil,
           child: nil
         },
         _message,
         context,
         _options
       )
       when type not in [:TYPE_MESSAGE, :TYPE_GROUP],
       do: {:cont, context}

  defp evaluate_field(%FieldPlan{field: field} = field_plan, message, context, options) do
    Context.remaining(context)
    atom = String.to_atom(field.name)
    value = DescriptorAdapter.field_value(message, field)
    presence = input_presence(message, atom)
    present? = presence == :present

    evaluate_field_plan(field_plan, value, presence, present?, context, options)
  end

  defp evaluate_field_plan(%FieldPlan{} = plan, value, presence, present?, context, options) do
    if plan.ignore == :IGNORE_ALWAYS do
      {:cont, context}
    else
      context = evaluate_required(plan, presence, value, context)

      cond do
        halted?(context) ->
          {:halt, context}

        plan.presence == :required and
            Protovalidate.Rules.Common.required_missing?(plan.field, presence, value) ->
          {:cont, context}

        skipped?(plan, present?, value) ->
          {:cont, context}

        true ->
          evaluate_field_checks(plan, value, context, options)
      end
    end
  end

  defp evaluate_required(plan, presence, value, context) do
    if plan.presence == :required and
         Protovalidate.Rules.Common.required_missing?(plan.field, presence, value),
       do:
         add(
           context,
           Protovalidate.Violation.new(path(plan.field), "required", "value is required",
             rule_source: plan.required_source
           )
         )
         |> unwrap(),
       else: context
  end

  defp skipped?(plan, present?, value) do
    rules = if plan.ignore, do: [{:ignore, plan.ignore}], else: []
    Protovalidate.Rules.Common.skipped?(rules, plan.field, present?, value)
  end

  defp evaluate_field_checks(plan, value, context, options) do
    InputBoundary.validate!(plan.field, value)
    rule_value = Protovalidate.Rules.WellKnown.unwrap_wrapper(plan.field, value)

    context =
      Enum.reduce_while(
        plan.checks,
        context,
        &Protovalidate.Rules.evaluate(&1, rule_value, plan.field, &2)
      )

    evaluate_collection(plan.collection, plan.field, value, context, options)
    |> then(fn
      {:halt, result} -> {:halt, result}
      {:cont, result} -> evaluate_child(plan, value, result, options)
    end)
  end

  defp evaluate_collection(nil, _field, _value, context, _options), do: Context.result(context)

  defp evaluate_collection(%CollectionPlan{items: item}, field, values, context, options)
       when not is_nil(item),
       do: traverse_collection(:items, item, field, values, context, options)

  defp evaluate_collection(%CollectionPlan{} = plan, field, values, context, options) do
    context = traverse_optional(:keys, plan.keys, field, values, context, options)

    case context do
      {:halt, _} = halted -> halted
      {:cont, result} -> traverse_optional(:values, plan.values, field, values, result, options)
    end
  end

  defp traverse_optional(_kind, nil, _field, _values, context, _options),
    do: Context.result(context)

  defp traverse_optional(kind, plan, field, values, context, options),
    do: traverse_collection(kind, plan, field, values, context, options)

  defp evaluate_child(%FieldPlan{child: nil}, _value, context, _options),
    do: Context.result(context)

  defp evaluate_child(%FieldPlan{field: field}, value, context, options),
    do: evaluate_nested(field, value, context, options)

  defp evaluate_nested(_field, _value, %{stopped: true} = context, _options), do: {:halt, context}

  # 子 plan は値が存在するときだけ取得し、再帰型を事前展開しない。
  defp evaluate_nested(field, %module{} = value, context, options) do
    validate_message_type!(field, value)
    plan = PlanCache.for_module(module, options)
    element = if field.name == "", do: nil, else: Context.wire_field(context, field)
    child = %{Context.scope(context, path(field).segments, false, element) | rule_prefix: []}
    result = run(plan, value, child) |> Context.restore(context)
    Context.result(result)
  end

  defp evaluate_nested(field, value, context, _options) do
    validate_message_type!(field, value)
    Context.result(context)
  end

  # absence と ignore による終了後、値をルールや子 plan に渡す前に照合する。
  defp validate_message_type!(field, value), do: InputBoundary.validate!(field, value)

  @doc false
  def collection(kind, %FieldPlan{} = item_plan, values, field, context) do
    traverse_collection(kind, item_plan, field, values, context, context.options)
  end

  # presence 実装も enum 値を参照するため、手動構築値による例外を入力エラーへ揃える。
  defp input_presence(message, atom) do
    DescriptorAdapter.field_presence(message, atom)
  rescue
    _error ->
      raise Protovalidate.RuntimeError,
        message: "input value does not match its Protobuf field type",
        code: :invalid_input_type,
        stage: :input
  catch
    _kind, _reason ->
      raise Protovalidate.RuntimeError,
        message: "input value does not match its Protobuf field type",
        code: :invalid_input_type,
        stage: :input
  end

  defp traverse_collection(kind, item_plan, collection_field, values, context, options) do
    entries = if kind == :items, do: Stream.with_index(values), else: values

    result =
      Enum.reduce_while(entries, context, fn entry, acc ->
        Context.remaining(acc)
        {value, segment} = collection_target(kind, entry, collection_field)

        element = Context.collection_wire_field(acc, collection_field, segment)

        child =
          Context.scope(
            acc,
            path(collection_field).segments ++ [segment],
            kind == :keys,
            element
          )

        prefix = if kind == :items, do: ["repeated", "items"], else: ["map", Atom.to_string(kind)]
        child = %{child | rule_prefix: acc.rule_prefix ++ prefix}

        presence = if is_nil(value), do: :absent, else: :present

        {_, result} =
          evaluate_field_plan(
            item_plan,
            value,
            presence,
            not is_nil(value),
            child,
            options
          )

        result |> Context.restore(acc) |> Context.result()
      end)

    Context.result(result)
  end

  defp collection_target(:items, {value, index}, _field),
    do: {value, {:index, index}}

  defp collection_target(kind, {key, value}, field) do
    {if(kind == :keys, do: key, else: value),
     {:map_key, Context.map_key_type(field.map_key), key}}
  end
end
