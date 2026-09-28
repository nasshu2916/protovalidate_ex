defmodule Protovalidate.FieldPath do
  @moduledoc """
  Represents a location within a message where a validation violation occurred.

  Stores fields, indexes, and map keys as segments instead of eagerly formatting them as a string.
  """

  @enforce_keys [:segments]
  defstruct [:segments]

  @type field :: {:field, String.t()}
  @type index :: {:index, non_neg_integer()}
  @type map_key_type :: :string | :bool | :int | :uint
  @type map_key :: {:map_key, map_key_type(), String.t() | boolean() | integer()}
  @type segment :: field() | index() | map_key()
  @type t :: %__MODULE__{segments: [segment()]}

  @spec new([segment()]) :: t()
  def new(segments) when is_list(segments), do: %__MODULE__{segments: segments}

  @spec field(t(), String.t()) :: t()
  def field(%__MODULE__{segments: segments}, name) when is_binary(name),
    do: new(segments ++ [{:field, name}])

  @spec index(t(), non_neg_integer()) :: t()
  def index(%__MODULE__{segments: segments}, index) when is_integer(index) and index >= 0,
    do: new(segments ++ [{:index, index}])

  @spec map_key(t(), String.t() | boolean() | integer()) :: t()
  def map_key(%__MODULE__{segments: segments}, key),
    do: new(segments ++ [{:map_key, map_key_type(key), key}])

  defp map_key_type(key) when is_binary(key), do: :string
  defp map_key_type(key) when is_boolean(key), do: :bool
  defp map_key_type(key) when is_integer(key) and key < 0, do: :int
  defp map_key_type(key) when is_integer(key), do: :uint
end
