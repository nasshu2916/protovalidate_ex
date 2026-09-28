defmodule Protovalidate.Rules.Custom do
  @moduledoc false

  import Protovalidate.Rules.Compilation
  import Protovalidate.Rules.Violations

  alias Protovalidate.{CEL, FieldPath, PredefinedRuleRegistry, Violation}

  @type compiled :: %{
          rule: Protovalidate.CEL.rule(),
          message_type: String.t(),
          type_environment: Protovalidate.CEL.TypeEnvironment.t(),
          source: Protovalidate.RuleSource.t() | nil,
          compiled: %{
            module: module(),
            options: keyword(),
            expression: term(),
            limits: %{
              compile_timeout: pos_integer(),
              timeout: pos_integer(),
              max_heap_size: pos_integer()
            }
          }
        }
  @type predefined :: %{
          rule: Protovalidate.CEL.rule(),
          message_type: String.t(),
          type_environment: Protovalidate.CEL.TypeEnvironment.t(),
          source: Protovalidate.RuleSource.t() | nil,
          compiled: %{
            module: module(),
            options: keyword(),
            expression: term(),
            limits: %{
              compile_timeout: pos_integer(),
              timeout: pos_integer(),
              max_heap_size: pos_integer()
            }
          },
          extension_number: pos_integer(),
          extension_value: Protovalidate.Rules.value()
        }

  @spec evaluate_cel_rule(compiled(), struct(), Protovalidate.Rules.context()) ::
          Protovalidate.Rules.result()
  def evaluate_cel_rule(rule, message, context) do
    environment = %{
      this: message,
      rule: rule.rule,
      scope: :message,
      message_type: rule.message_type,
      type_environment: rule.type_environment,
      now: context.now
    }

    result =
      CEL.evaluate!(rule.compiled, environment, Protovalidate.Plan.Context.remaining(context))

    if result in [true, ""] do
      {:cont, context}
    else
      add(context, cel_violation(FieldPath.new([]), with_result_message(rule, result)))
    end
  end

  defp with_result_message(rule, result) when is_binary(result),
    do: put_in(rule, [:rule, :message], result)

  defp with_result_message(rule, _result), do: rule

  defp cel_violation(path, %{rule: rule, source: source}) do
    Violation.new(path, rule.id, rule.message,
      rule_path: ["cel", rule.id],
      rule_source: source,
      details: %{constraint: :cel}
    )
  end

  defp predefined_violation(path, %{rule: rule, extension_number: number, source: source}) do
    Violation.new(path, rule.id, rule.message,
      rule_path: ["predefined", Integer.to_string(number), rule.id],
      rule_source: source,
      details: %{constraint: :cel, predefined: true}
    )
  end

  @spec compile_cel_rules!(map() | nil, :field | :message, String.t(), keyword()) :: [
          Protovalidate.Rules.compiled()
        ]
  def compile_cel_rules!(rules, scope, message_type, options) do
    explicit_count = length(rule_value(rules, :cel) || [])

    compiled =
      rules
      |> cel_rules!()
      |> Enum.with_index()
      |> Enum.map(fn {rule, index} ->
        rule = normalize_cel_rule!(rule, index, scope)

        type_environment = Protovalidate.CEL.TypeEnvironment.new(options)

        environment = %{
          this: nil,
          rule: rule,
          scope: scope,
          message_type: message_type,
          type_environment: type_environment
        }

        %{
          rule: rule,
          message_type: message_type,
          type_environment: type_environment,
          source:
            if(index < explicit_count,
              do: Protovalidate.RuleSource.cel(scope, "cel", index),
              else: Protovalidate.RuleSource.cel(scope, "cel_expression", index - explicit_count)
            ),
          compiled:
            CEL.compile!(
              cel_executor!(options, scope),
              rule,
              environment,
              compile_budget(options)
            )
        }
        |> then(&{:cel, &1})
      end)

    validate_cel_rule_namespace!(compiled, message_type)
    compiled
  end

  @spec compile_predefined_rules!(
          {atom(), map()} | nil,
          Protovalidate.DescriptorAdapter.Field.t(),
          keyword()
        ) :: [Protovalidate.Rules.compiled()]
  def compile_predefined_rules!(nil, _field, _options), do: []

  def compile_predefined_rules!({_, rules}, field, options) do
    rules
    |> rule_map()
    |> Map.get(:__pb_extensions__, %{})
    |> normalize_predefined_extensions!(rules, field)
    |> Enum.flat_map(fn {number, value} ->
      compile_predefined_extension!(number, value, rules, field, options)
    end)
  end

  defp normalize_predefined_extensions!(extensions, rules, field) when is_map(extensions) do
    extensions
    |> Enum.map(fn {key, value} -> {predefined_extension_number!(key, rules, field), value} end)
    |> Enum.sort_by(fn {number, _value} -> number end)
  end

  defp normalize_predefined_extensions!(_extensions, _rules, field),
    do: compilation_error!("invalid predefined rule extensions", [field.name, "predefined"])

  # protobuf ライブラリは extension の値を {extension module, field name} で保持するため、
  # registry の安定したキーにする extension number へここで正規化する。
  defp predefined_extension_number!(number, _rules, _field) when is_integer(number), do: number

  defp predefined_extension_number!({extension_module, extension_field}, rules, field)
       when is_atom(extension_module) and is_atom(extension_field) and is_struct(rules) do
    rule_type = rules.__struct__

    with true <- Code.ensure_loaded?(extension_module),
         %{name_to_tag: names} <- extension_module.__protobuf_info__(:extension_props),
         {:ok, {^rule_type, number}} <- Map.fetch(names, {rule_type, extension_field}) do
      number
    else
      _ ->
        compilation_error!("cannot resolve predefined rule extension", [field.name, "predefined"])
    end
  end

  defp predefined_extension_number!(_key, _rules, field),
    do: compilation_error!("invalid predefined rule extension key", [field.name, "predefined"])

  defp compile_predefined_extension!(number, value, rules, field, options)
       when is_integer(number) and number >= 1_000 do
    registry =
      case Keyword.get(options, :registry) do
        nil -> unsupported!("predefined rules require :registry", [field.name, "predefined"])
        registry -> registry
      end

    rule_type = if(is_struct(rules), do: rules.__struct__, else: :map)

    case PredefinedRuleRegistry.resolve_with_source(registry, number, value, rule_type) do
      {:ok, %{rules: cel_rules, descriptor: descriptor} = source} ->
        value = Map.get(source, :value, value)

        cel_rules
        |> Enum.with_index()
        |> Enum.map(fn {rule, index} ->
          rule = normalize_cel_rule!(rule, index, :field)
          type_environment = Protovalidate.CEL.TypeEnvironment.new(options)

          message_type =
            if type_environment.message, do: type_environment.message.full_name, else: field.name

          environment = %{
            this: nil,
            rule: value,
            scope: :field,
            message_type: message_type,
            type_environment: type_environment
          }

          {:predefined,
           %{
             rule: rule,
             extension_number: number,
             extension_value: value,
             message_type: message_type,
             type_environment: type_environment,
             source:
               Protovalidate.RuleSource.predefined(
                 predefined_kind(field),
                 descriptor,
                 number
               ),
             compiled:
               CEL.compile!(
                 cel_executor!(options, :field),
                 rule,
                 environment,
                 compile_budget(options)
               )
           }}
        end)

      :unknown ->
        unsupported!("unknown predefined rule extension: #{number}", [field.name, "predefined"])

      {:error, reason} ->
        compilation_error!(
          "cannot resolve predefined rule extension #{number}: #{reason}",
          [
            field.name,
            "predefined"
          ]
        )
    end
  end

  defp compile_predefined_extension!(number, _value, _rules, field, _options),
    do:
      compilation_error!("invalid predefined rule extension number: #{inspect(number)}", [
        field.name,
        "predefined"
      ])

  defp predefined_kind(%{map?: true}), do: "map"
  defp predefined_kind(%{repeated?: true}), do: "repeated"

  defp predefined_kind(%{well_known_type: type}) when type in [:duration, :timestamp],
    do: Atom.to_string(type)

  defp predefined_kind(field),
    do: field |> Protovalidate.Rules.Violations.rule_id("") |> String.trim_trailing(".")

  def validate_cel_rule_namespace!(rules, field_name) do
    ids = Enum.map(rules, fn {_kind, %{rule: rule}} -> rule.id end)

    if length(ids) != length(Enum.uniq(ids)) do
      compilation_error!("duplicate CEL rule ID for #{field_name}", [field_name, "cel"])
    end
  end

  defp cel_rules!(nil), do: []

  defp cel_rules!(rules) do
    explicit = rule_value(rules, :cel) || []
    legacy = rule_value(rules, :cel_expression) || []

    unless is_list(explicit) and is_list(legacy),
      do: compilation_error!("CEL rules must be specified as a list", ["cel"])

    explicit ++ Enum.map(legacy, &%{id: &1, expression: &1, message: "\"#{&1}\" returned false"})
  end

  defp normalize_cel_rule!(rule, index, _scope) when is_map(rule) do
    reject_unknown_rule_fields!(rule, [:id, :message, :expression], "cel")
    reject_extensions!(rule, ["cel"])
    expression = Map.get(rule, :expression)
    id = Map.get(rule, :id) || expression
    message = Map.get(rule, :message) || "CEL rule failed"

    unless is_binary(expression) and expression != "",
      do:
        compilation_error!("CEL expression must be a non-empty string", [
          "cel",
          Integer.to_string(index)
        ])

    unless is_binary(id) and id != "",
      do:
        compilation_error!("CEL rule ID must be a non-empty string", [
          "cel",
          Integer.to_string(index)
        ])

    unless is_binary(message),
      do:
        compilation_error!("CEL rule message must be a string", ["cel", Integer.to_string(index)])

    %{id: id, expression: expression, message: message}
  end

  defp normalize_cel_rule!(_rule, index, _scope),
    do: compilation_error!("invalid CEL rule", ["cel", Integer.to_string(index)])

  defp cel_executor!(options, _scope) do
    Keyword.get(options, :cel, Protovalidate.CEL.Celixir)
  end

  defp compile_budget(options) do
    case Keyword.get(options, :validation_budget) do
      nil -> :infinity
      budget -> Protovalidate.ValidationBudget.remaining(budget)
    end
  end

  @spec evaluate(
          Protovalidate.Rules.compiled(),
          Protovalidate.Rules.value(),
          Protovalidate.DescriptorAdapter.Field.t(),
          Protovalidate.Rules.context()
        ) :: Protovalidate.Rules.result()
  def evaluate({:cel, rule}, value, field, context) do
    environment = %{
      this: value,
      rule: rule.rule,
      scope: :field,
      message_type: rule.message_type,
      type_environment: rule.type_environment,
      now: context.now
    }

    result =
      CEL.evaluate!(rule.compiled, environment, Protovalidate.Plan.Context.remaining(context))

    if result in [true, ""] do
      {:cont, context}
    else
      add(context, cel_violation(path(field), with_result_message(rule, result)))
    end
  end

  def evaluate({:predefined, rule}, value, field, context) do
    environment = %{
      this: value,
      rule: rule.extension_value,
      scope: :field,
      message_type: rule.message_type,
      type_environment: rule.type_environment,
      now: context.now
    }

    result =
      CEL.evaluate!(rule.compiled, environment, Protovalidate.Plan.Context.remaining(context))

    if result in [true, ""] do
      {:cont, context}
    else
      add(context, predefined_violation(path(field), with_result_message(rule, result)))
    end
  end
end
