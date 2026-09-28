defmodule Protovalidate.RuleSource do
  @moduledoc "Descriptor and index identifying the source of a validation rule, independent of the violation ID."
  @enforce_keys [:root, :segments]
  defstruct [:root, :segments, :extension, :kind, :wire_path]

  @type t :: %__MODULE__{
          root: module(),
          segments: [Protovalidate.FieldPath.segment()],
          extension: map() | nil,
          kind: :field | :field_cel | :message_cel | :predefined | :oneof_required,
          wire_path: Buf.Validate.FieldPath.t() | nil
        }

  def standard(rules, nil), do: rules

  def standard(rules, {kind, _config}) do
    Enum.map(rules, fn rule ->
      {:sourced, rule,
       build(
         Buf.Validate.FieldRules,
         [{:field, Atom.to_string(kind)}, {:field, standard_field(rule)}],
         :field
       )}
    end)
  end

  defp standard_field({:range, %{lower: {key, _}}}), do: Atom.to_string(key)
  defp standard_field({key, _}), do: Atom.to_string(key)
  defp standard_field(key), do: key |> Atom.to_string() |> String.replace_prefix("bytes_", "")

  def cel(scope, kind, index) do
    root = if scope == :message, do: Buf.Validate.MessageRules, else: Buf.Validate.FieldRules
    rule_kind = if scope == :message, do: :message_cel, else: :field_cel
    build(root, [{:field, kind}, {:index, index}], rule_kind)
  end

  def required(prefix \\ []) do
    build(Buf.Validate.FieldRules, Enum.map(prefix ++ ["required"], &{:field, &1}), :field)
  end

  def oneof_required do
    build(Buf.Validate.OneofRules, [{:field, "required"}], :oneof_required)
  end

  def predefined(kind, descriptor, number \\ nil) do
    extension =
      case descriptor do
        %Google.Protobuf.FieldDescriptorProto{} = field ->
          %Buf.Validate.FieldPathElement{
            field_name: "[" <> field.name <> "]",
            field_number: field.number,
            field_type: field.type
          }

        nil ->
          %Buf.Validate.FieldPathElement{field_number: number}
      end

    source = build(Buf.Validate.FieldRules, [{:field, kind}], :predefined)
    %{source | extension: extension, wire_path: append(source.wire_path, extension)}
  end

  def prefix(%__MODULE__{kind: :message_cel} = source, _names), do: source
  def prefix(%__MODULE__{} = source, []), do: source

  def prefix(%__MODULE__{} = source, names) do
    segments = Enum.map(names, &{:field, &1}) ++ source.segments
    wire_path = Protovalidate.ViolationPath.field_path(segments, source.root)
    wire_path = if source.extension, do: append(wire_path, source.extension), else: wire_path
    %{source | segments: segments, wire_path: wire_path}
  end

  defp build(root, segments, kind) do
    wire_path =
      if kind == :message_cel,
        do: nil,
        else: Protovalidate.ViolationPath.field_path(segments, root)

    %__MODULE__{root: root, segments: segments, kind: kind, wire_path: wire_path}
  end

  defp append(path, extension), do: %{path | elements: path.elements ++ [extension]}
end
