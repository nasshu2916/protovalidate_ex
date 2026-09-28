defmodule Protovalidate.ViolationPath do
  @moduledoc false

  alias Buf.Validate.{FieldPath, FieldPathElement}
  alias Protovalidate.DescriptorAdapter

  @spec field_path([Protovalidate.FieldPath.segment()], module()) :: FieldPath.t()
  def field_path(segments, module), do: %FieldPath{elements: walk(segments, module)}

  @spec field_element(DescriptorAdapter.Field.t()) :: FieldPathElement.t()
  def field_element(field) do
    %FieldPathElement{
      field_name: field.name,
      field_number: field.number,
      field_type: wire_field_type(field)
    }
  end

  defp wire_field_type(%{type: :TYPE_MESSAGE, features: %{message_encoding: :DELIMITED}}),
    do: :TYPE_GROUP

  defp wire_field_type(field), do: field.type

  @spec subscript(
          FieldPathElement.t(),
          Protovalidate.FieldPath.segment(),
          DescriptorAdapter.Field.t()
        ) ::
          FieldPathElement.t()
  def subscript(element, {:index, index}, %{repeated?: true, map?: false})
      when is_integer(index) and index >= 0,
      do: %{element | subscript: {:index, index}}

  def subscript(element, {:map_key, kind, key}, %{map?: true} = field) do
    if kind != DescriptorAdapter.map_key_type(field.map_key),
      do: invalid_path!({field.name, kind})

    tag = %{string: :string_key, bool: :bool_key, int: :int_key, uint: :uint_key}

    %{
      element
      | subscript: {Map.fetch!(tag, kind), key},
        key_type: field.map_key,
        value_type: field.map_value
    }
  end

  def subscript(_element, segment, field), do: invalid_path!({field.name, segment})

  defp walk([], _module), do: []

  defp walk([{:field, name} | rest], module) when not is_binary(name) do
    invalid_path!({module, name, rest})
  end

  defp walk([{:field, name} | rest], module) when not is_nil(module) do
    field = find_field!(module, name)
    {element, rest} = take_subscript(field_element(field), rest, field)
    target = if field.map?, do: field.map_value_field, else: field
    next = if target.type == :TYPE_MESSAGE, do: target.reference
    [element | walk(rest, next)]
  end

  defp walk(segments, module), do: invalid_path!({module, segments})

  defp take_subscript(element, [{:index, _} = segment | rest], field),
    do: {subscript(element, segment, field), rest}

  defp take_subscript(element, [{:map_key, _, _} = segment | rest], field),
    do: {subscript(element, segment, field), rest}

  defp take_subscript(element, rest, _field), do: {element, rest}

  defp find_field!(module, name) do
    module
    |> DescriptorAdapter.describe()
    |> Map.fetch!(:fields)
    |> Enum.find(&(&1.name == name))
    |> case do
      nil -> invalid_path!({module, name})
      field -> field
    end
  end

  defp invalid_path!(path),
    do:
      raise(Protovalidate.RuntimeError,
        message: "cannot resolve violation path from descriptor: #{inspect(path)}"
      )
end
