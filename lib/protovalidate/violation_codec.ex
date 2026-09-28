defmodule Protovalidate.ViolationCodec do
  @moduledoc "Encodes validation violations as buf.validate wire messages."

  alias Buf.Validate.{FieldPath, FieldPathElement}
  alias Protovalidate.{RuleSource, Violation, ViolationPath}

  @spec encode([Violation.t()], module() | nil) :: Buf.Validate.Violations.t()
  def encode(violations, module) do
    %Buf.Validate.Violations{violations: Enum.map(violations, &encode_violation(&1, module))}
  end

  defp encode_violation(violation, module) do
    {field, rule} = paths(violation, module)

    %Buf.Validate.Violation{
      field: field,
      rule: rule,
      rule_id: violation.rule_id,
      message: violation.message,
      for_key: if(violation.for_key, do: true, else: nil)
    }
  end

  # plan から来た違反は番号・型・出典が確定済みで、ここでは descriptor を参照しない。
  defp paths(%Violation{origin: %Violation.Origin{field: field, rule: rule}}, _module),
    do: {field, rule}

  # 手動で作った Violation に限り、従来の descriptor 解決を維持する。
  defp paths(%Violation{details: %{constraint: :oneof_required}} = violation, module) do
    {parent, [{:field, name}]} = Enum.split(violation.field_path.segments, -1)
    field = ViolationPath.field_path(parent, module)
    {%{field | elements: field.elements ++ [%FieldPathElement{field_name: name}]}, nil}
  end

  defp paths(%Violation{details: %{constraint: :message_oneof}} = violation, module) do
    if violation.field_path.segments == [],
      do: {nil, nil},
      else: {ViolationPath.field_path(violation.field_path.segments, module), nil}
  end

  defp paths(violation, module) do
    field = ViolationPath.field_path(violation.field_path.segments, module)

    rule =
      case violation.rule_source do
        %RuleSource{kind: kind} when kind in [:message_cel, :message_oneof] -> nil
        %RuleSource{wire_path: %FieldPath{} = path} -> path
        _ -> legacy_rule_path(violation.rule_path)
      end

    {field, rule}
  end

  defp legacy_rule_path(["oneof", "required"]),
    do: ViolationPath.field_path([{:field, "required"}], Buf.Validate.OneofRules)

  defp legacy_rule_path(names),
    do: ViolationPath.field_path(Enum.map(names, &{:field, &1}), Buf.Validate.FieldRules)
end
