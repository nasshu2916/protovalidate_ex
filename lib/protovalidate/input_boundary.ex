defmodule Protovalidate.InputBoundary do
  @moduledoc false

  alias Protovalidate.DescriptorAdapter.Field

  @integer_types [
    :TYPE_INT32,
    :TYPE_INT64,
    :TYPE_UINT32,
    :TYPE_UINT64,
    :TYPE_SINT32,
    :TYPE_SINT64,
    :TYPE_FIXED32,
    :TYPE_FIXED64,
    :TYPE_SFIXED32,
    :TYPE_SFIXED64
  ]

  @spec validate!(Field.t(), term()) :: :ok
  def validate!(%Field{map?: true}, value) do
    unless is_map(value), do: invalid!()
    :ok
  end

  def validate!(%Field{repeated?: true}, value) do
    unless is_list(value), do: invalid!()
    :ok
  end

  def validate!(%Field{} = field, value), do: validate_scalar!(field, value)

  defp validate_scalar!(_field, nil), do: :ok

  defp validate_scalar!(%{type: type}, value) when type in [:TYPE_STRING, :TYPE_BYTES] do
    unless is_binary(value), do: invalid!()
  end

  defp validate_scalar!(%{type: :TYPE_BOOL}, value) do
    unless is_boolean(value), do: invalid!()
  end

  defp validate_scalar!(%{type: type}, value) when type in @integer_types do
    unless is_integer(value), do: invalid!()
  end

  defp validate_scalar!(%{type: type}, value) when type in [:TYPE_FLOAT, :TYPE_DOUBLE] do
    unless is_float(value) or value in [:nan, :infinity, :negative_infinity], do: invalid!()
  end

  defp validate_scalar!(%{type: :TYPE_ENUM, reference: module}, value) do
    valid? =
      is_integer(value) or
        (is_atom(value) and is_atom(module) and valid_enum_atom?(module, value))

    unless valid?, do: invalid!()
  end

  defp validate_scalar!(%{type: :TYPE_MESSAGE, reference: expected}, value) do
    unless is_atom(expected) and is_struct(value, expected) do
      raise Protovalidate.RuntimeError,
        message: "declared and actual child message types do not match",
        code: :invalid_input_type,
        stage: :input
    end
  end

  defp validate_scalar!(_field, _value), do: :ok

  defp valid_enum_atom?(module, value) do
    is_integer(module.value(value))
  rescue
    _error -> false
  catch
    _kind, _reason -> false
  end

  defp invalid! do
    raise Protovalidate.RuntimeError,
      message: "input value does not match its Protobuf field type",
      code: :invalid_input_type,
      stage: :input
  end
end
