defmodule Protovalidate.CEL.CelixirTypes do
  @moduledoc false

  alias Celixir.AST
  alias Protovalidate.CEL.CelixirVariables
  alias Protovalidate.DescriptorAdapter, as: Descriptor

  def check(ast, environment) do
    root =
      if environment.scope == :message,
        do: environment.type_environment.message,
        else: environment.type_environment.field

    declarations = %{
      "this" => type(root),
      "rule" => value_type(environment.rule),
      "now" => :timestamp
    }

    with :ok <- CelixirVariables.check(ast, MapSet.new(Map.keys(declarations))) do
      {typed_ast, declarations} = annotate(ast, root, declarations)

      case Celixir.Checker.infer(typed_ast, declarations) do
        result when result in [:bool, :string, :dyn] -> :ok
        {:error, _} = error -> error
        result -> {:error, "CEL rule must return bool or string, got #{inspect(result)}"}
      end
    end
  rescue
    error in Protovalidate.CompilationError -> {:error, error.message}
  end

  # 型検査用 AST だけを置換する。評価用 AST の field access と has() は維持する。
  defp annotate(%AST.Select{} = ast, root, declarations) do
    case selected_field(ast, root) do
      nil ->
        annotate_struct(ast, root, declarations)

      field ->
        name = "__field_#{map_size(declarations)}"
        field_type = if ast.test_only, do: :bool, else: type(field)
        {%AST.Ident{name: name}, Map.put(declarations, name, field_type)}
    end
  end

  defp annotate(%_{} = ast, root, declarations), do: annotate_struct(ast, root, declarations)

  defp annotate(values, root, declarations) when is_list(values),
    do: Enum.map_reduce(values, declarations, &annotate(&1, root, &2))

  defp annotate(value, root, declarations) when is_tuple(value) do
    {values, declarations} = annotate(Tuple.to_list(value), root, declarations)
    {List.to_tuple(values), declarations}
  end

  defp annotate(value, _root, declarations), do: {value, declarations}

  defp annotate_struct(ast, root, declarations) do
    {entries, declarations} =
      Enum.map_reduce(Map.from_struct(ast), declarations, fn {key, value}, acc ->
        {value, acc} = annotate(value, root, acc)
        {{key, value}, acc}
      end)

    {struct!(ast.__struct__, entries), declarations}
  end

  defp selected_field(%AST.Select{operand: %AST.Ident{name: "this"}, field: name}, root),
    do: find_field(root, name)

  defp selected_field(%AST.Select{operand: %AST.Select{} = parent, field: name}, root),
    do: parent |> selected_field(root) |> find_field(name)

  defp selected_field(_ast, _root), do: nil

  defp find_field(%Descriptor.Message{fields: fields}, name) do
    Enum.find(fields, &(&1.name == name)) ||
      raise(Protovalidate.CompilationError, message: "unknown CEL field: #{name}")
  end

  defp find_field(%Descriptor.Field{type: :TYPE_MESSAGE, reference: module}, name)
       when not is_nil(module),
       do: module |> Descriptor.describe() |> find_field(name)

  defp find_field(_root, _name), do: nil

  defp type(nil), do: :dyn
  defp type(%Descriptor.Message{full_name: name}), do: {:message, name}

  defp type(%{map?: true} = field),
    do: {:map, type(field.map_key_field), type(field.map_value_field)}

  defp type(%{repeated?: true} = field), do: {:list, type(%{field | repeated?: false})}
  defp type(%{well_known_type: {:wrapper, scalar}}), do: scalar_type(scalar)
  defp type(%{well_known_type: kind}) when kind in [:timestamp, :duration], do: kind
  defp type(%{type: :TYPE_MESSAGE, type_name: name}), do: {:message, name}
  defp type(%{type: scalar}), do: scalar_type(scalar)

  defp scalar_type(type) when type in [:TYPE_FLOAT, :TYPE_DOUBLE], do: :double
  defp scalar_type(:TYPE_STRING), do: :string
  defp scalar_type(:TYPE_BYTES), do: :bytes
  defp scalar_type(:TYPE_BOOL), do: :bool

  defp scalar_type(type)
       when type in [:TYPE_UINT32, :TYPE_UINT64, :TYPE_FIXED32, :TYPE_FIXED64], do: :uint

  defp scalar_type(_), do: :int

  defp value_type(value) when is_boolean(value), do: :bool
  defp value_type(value) when is_integer(value), do: :int
  defp value_type(value) when is_binary(value), do: :string
  defp value_type(_), do: :dyn

  def field_value(values, %{map?: true} = field),
    do:
      Map.new(values, fn {key, value} ->
        {field_value(key, field.map_key_field), field_value(value, field.map_value_field)}
      end)

  def field_value(values, %{repeated?: true} = field),
    do: Enum.map(values, &field_value(&1, %{field | repeated?: false}))

  def field_value(value, %Descriptor.Field{} = field),
    do: field |> Descriptor.enum_value(value) |> value()

  def field_value(raw, nil), do: value(raw)

  def value(value)
      when is_binary(value) or is_number(value) or is_boolean(value) or is_nil(value),
      do: value

  def value(%module{} = message) do
    if function_exported?(module, :full_name, 0),
      do: protobuf_value(message, module.full_name()),
      else: message
  end

  def value(values) when is_list(values), do: Enum.map(values, &value/1)

  def value(values) when is_map(values),
    do: Map.new(values, fn {key, entry} -> {key, value(entry)} end)

  def value(value), do: value

  defp protobuf_value(message, "google.protobuf.Timestamp"), do: timestamp(message)

  defp protobuf_value(message, "google.protobuf.Duration") do
    if abs(message.seconds) > 315_576_000_000 or abs(message.nanos) > 999_999_999 or
         (message.seconds > 0 and message.nanos < 0) or
         (message.seconds < 0 and message.nanos > 0),
       do: raise(Protovalidate.RuntimeError, message: "invalid protobuf duration")

    Celixir.Types.Duration.from_seconds(message.seconds, message.nanos)
  end

  defp protobuf_value(message, "google.protobuf." <> name)
       when name in [
              "BoolValue",
              "BytesValue",
              "DoubleValue",
              "FloatValue",
              "Int32Value",
              "Int64Value",
              "StringValue",
              "UInt32Value",
              "UInt64Value"
            ],
       do: message.value

  defp protobuf_value(message, _name), do: message

  def timestamp(%{seconds: seconds, nanos: nanos}) do
    unless seconds in -62_135_596_800..253_402_300_799 and nanos in 0..999_999_999,
      do: raise(Protovalidate.RuntimeError, message: "invalid protobuf timestamp")

    datetime = DateTime.from_unix!(seconds * 1_000_000 + div(nanos, 1000), :microsecond)
    %Celixir.Types.Timestamp{datetime: datetime, nanos_remainder: rem(nanos, 1000)}
  end
end
