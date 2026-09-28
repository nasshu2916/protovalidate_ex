defmodule Protovalidate.Rules.Common do
  @moduledoc false

  @type compiled :: :required | {:ignore, atom()}

  import Protovalidate.Rules.Compilation
  import Protovalidate.Rules.Violations

  @spec common_rules(Protovalidate.DescriptorAdapter.Field.t(), map(), keyword()) :: [
          Protovalidate.Rules.compiled()
        ]
  def common_rules(field, rules, options) do
    validate_required!(rule_value(rules, :required))

    []
    |> add_if(
      rule_value(rules, :required) == true or
        (field.presence == :required and Keyword.get(options, :legacy_required, false)),
      :required
    )
    |> add_if(ignore_rule?(rule_value(rules, :ignore)), {:ignore, rule_value(rules, :ignore)})
  end

  def always_ignored?(rules), do: Keyword.get(rules, :ignore) == :IGNORE_ALWAYS

  def skipped?(rules, field, present?, value) do
    absent? = field.presence != :implicit and not present?

    ignore_zero? =
      Keyword.get(rules, :ignore) in [:IGNORE_IF_ZERO_VALUE, :IGNORE_IF_DEFAULT_VALUE]

    absent? or
      (ignore_zero? and field.presence in [:implicit, :collection] and zero?(field, value))
  end

  defp zero?(field, value),
    do:
      Protovalidate.DescriptorAdapter.enum_value(field, value) in [
        nil,
        false,
        0,
        0.0,
        "",
        [],
        %{}
      ]

  def required_missing?(%{presence: :implicit} = field, _presence, value), do: zero?(field, value)
  def required_missing?(_field, presence, _value), do: presence != :present
  defp ignore_rule?(nil), do: false
  defp ignore_rule?(:IGNORE_UNSPECIFIED), do: false
  defp ignore_rule?(:IGNORE_ALWAYS), do: true
  defp ignore_rule?(:IGNORE_IF_ZERO_VALUE), do: true
  defp ignore_rule?(:IGNORE_IF_DEFAULT_VALUE), do: true

  defp ignore_rule?(value),
    do: compilation_error!("Invalid ignore value: #{inspect(value)}", ["field", "ignore"])

  defp validate_required!(nil), do: :ok
  defp validate_required!(value) when is_boolean(value), do: :ok

  defp validate_required!(_value),
    do: compilation_error!("required must be a boolean", ["field", "required"])

  @spec evaluate(
          Protovalidate.Rules.compiled(),
          Protovalidate.Rules.value(),
          Protovalidate.DescriptorAdapter.Field.t(),
          Protovalidate.Rules.context()
        ) :: Protovalidate.Rules.result()
  def evaluate(:required, _value, _field, context), do: {:cont, context}
  def evaluate({:ignore, _}, _value, _field, context), do: {:cont, context}

  def evaluate({:in, expected}, value, field, context),
    do: check(context, value in expected, field, rule_id(field, "in"), "Value is not allowed")

  def evaluate({:not_in, expected}, value, field, context),
    do:
      check(
        context,
        value not in expected,
        field,
        rule_id(field, "not_in"),
        "Value is disallowed"
      )

  def evaluate({:const, expected}, value, field, context),
    do:
      check(
        context,
        value == expected,
        field,
        rule_id(field, "const"),
        Protovalidate.Rules.Messages.constant(expected, field)
      )
end
