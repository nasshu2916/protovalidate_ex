defmodule Protovalidate.PredefinedRuleRegistry do
  @moduledoc """
  Registry that resolves predefined rule extensions to CEL rules.

  The registry validates the extension number, extension value, and target `Rules`
  message type. The extension value itself is passed to CEL as `rule` during evaluation.
  """

  import Protobuf.Wire.Varint, only: [defdecoderp: 2]

  @type rule :: Protovalidate.CEL.rule()
  @type value_type :: :any | :boolean | :integer | :binary | module() | (term() -> boolean())
  @type entry :: %{
          required(:rule_type) => module() | :map,
          required(:cel) => [rule()],
          optional(:value_type) => value_type(),
          optional(:descriptor) => map()
        }
  @type t :: %__MODULE__{
          entries: %{(non_neg_integer() | {module(), non_neg_integer()}) => entry()}
        }

  @callback resolve(non_neg_integer(), term(), module() | :map) ::
              {:ok, [rule()]} | :unknown | {:error, term()}

  @callback resolve_with_source(non_neg_integer(), term(), module() | :map) ::
              {:ok,
               %{rules: [rule()], descriptor: Google.Protobuf.FieldDescriptorProto.t() | nil}}
              | :unknown
              | {:error, term()}
  @optional_callbacks resolve: 3, resolve_with_source: 3

  @enforce_keys [:entries]
  defstruct [:entries]

  @spec new(%{(non_neg_integer() | {module(), non_neg_integer()}) => entry()}) :: t()
  def new(entries \\ %{}) when is_map(entries), do: %__MODULE__{entries: entries}

  @spec resolve(t() | module(), non_neg_integer(), term(), module() | :map) ::
          {:ok, [rule()]} | :unknown | {:error, term()}
  def resolve(%__MODULE__{entries: entries}, number, value, rule_type) do
    case Map.fetch(entries, {rule_type, number}) |> fallback_entry(entries, number) do
      :error -> :unknown
      {:ok, entry} -> resolve_entry(entry, value, rule_type)
    end
  end

  def resolve(module, number, value, rule_type) when is_atom(module) do
    cond do
      Code.ensure_loaded?(module) and function_exported?(module, :resolve, 3) ->
        callback(module, number, value, rule_type)

      Code.ensure_loaded?(module) and function_exported?(module, :resolve_with_source, 3) ->
        case source_callback(module, number, value, rule_type) do
          {:ok, %{rules: rules}} -> {:ok, rules}
          result -> result
        end

      true ->
        {:error,
         ":registry must be a Protovalidate.PredefinedRuleRegistry or implement resolve/3 or resolve_with_source/3"}
    end
  end

  def resolve(_registry, _number, _value, _rule_type),
    do: {:error, "invalid :registry configuration"}

  @doc "ルールと拡張 descriptor をまとめて解決する。従来の resolve/3 registry も利用できる。"
  def resolve_with_source(%__MODULE__{} = registry, number, value, rule_type) do
    source = descriptor(registry, number, rule_type)
    value = decode_packed_value(value, source)

    case resolve(registry, number, value, rule_type) do
      {:ok, rules} -> {:ok, %{rules: rules, descriptor: source, value: value}}
      result -> result
    end
  end

  def resolve_with_source(module, number, value, rule_type) when is_atom(module) do
    if Code.ensure_loaded?(module) and function_exported?(module, :resolve_with_source, 3) do
      source_callback(module, number, value, rule_type)
    else
      case resolve(module, number, value, rule_type) do
        {:ok, rules} -> {:ok, %{rules: rules, descriptor: nil}}
        result -> result
      end
    end
  end

  def resolve_with_source(_registry, _number, _value, _rule_type),
    do: {:error, "invalid :registry configuration"}

  # 外部 callback の失敗情報や入力値を公開境界へ漏らさず、戻り値もここで固定する。
  defp callback(module, number, value, rule_type) do
    case module.resolve(number, value, rule_type) do
      {:ok, rules} when is_list(rules) -> {:ok, rules}
      :unknown -> :unknown
      {:error, _reason} -> {:error, "registry callback failed"}
      _other -> {:error, "registry callback returned an invalid result"}
    end
  rescue
    _error -> {:error, "registry callback raised an exception"}
  catch
    :throw, _reason -> {:error, "registry callback threw a value"}
    :exit, _reason -> {:error, "registry callback exited"}
  end

  defp source_callback(module, number, value, rule_type) do
    case module.resolve_with_source(number, value, rule_type) do
      {:ok, %{rules: rules, descriptor: descriptor}}
      when is_list(rules) and
             (is_nil(descriptor) or is_struct(descriptor, Google.Protobuf.FieldDescriptorProto)) ->
        {:ok, %{rules: rules, descriptor: descriptor}}

      :unknown ->
        :unknown

      {:error, _reason} ->
        {:error, "registry callback failed"}

      _other ->
        {:error, "registry callback returned an invalid result"}
    end
  rescue
    _error -> {:error, "registry callback raised an exception"}
  catch
    :throw, _reason -> {:error, "registry callback threw a value"}
    :exit, _reason -> {:error, "registry callback exited"}
  end

  defp fallback_entry(:error, entries, number), do: Map.fetch(entries, number)
  defp fallback_entry(result, _entries, _number), do: result

  @doc "Extension source descriptor. Specify the fully qualified name, number, and type when registering manually."
  def descriptor(%__MODULE__{entries: entries}, number, rule_type) do
    case Map.fetch(entries, {rule_type, number}) |> fallback_entry(entries, number) do
      {:ok, entry} -> Map.get(entry, :descriptor)
      :error -> nil
    end
  end

  def descriptor(_registry, _number, _rule_type), do: nil

  # protobuf decoder は packed extension を配列として復号しないため、wire 値をここで復元する。
  defp decode_packed_value(value, %{label: :LABEL_REPEATED, type: type})
       when is_binary(value) do
    case type do
      kind when kind in [:TYPE_FLOAT, :TYPE_FIXED32, :TYPE_SFIXED32] ->
        decode_fixed(value, 32, scalar_type(kind))

      kind when kind in [:TYPE_DOUBLE, :TYPE_FIXED64, :TYPE_SFIXED64] ->
        decode_fixed(value, 64, scalar_type(kind))

      kind ->
        decode_varints(value, scalar_type(kind), []) |> Enum.reverse()
    end
  end

  defp decode_packed_value(value, _descriptor), do: value

  defp scalar_type(type) do
    type
    |> Atom.to_string()
    |> String.trim_leading("TYPE_")
    |> String.downcase()
    |> String.to_atom()
  end

  defp decode_fixed(<<>>, _bits, _type), do: []

  defp decode_fixed(binary, 32, type) do
    for <<value::binary-size(4) <- binary>>, do: Protobuf.Wire.decode(type, value)
  end

  defp decode_fixed(binary, 64, type) do
    for <<value::binary-size(8) <- binary>>, do: Protobuf.Wire.decode(type, value)
  end

  defp decode_varints(<<>>, _type, acc), do: acc

  defdecoderp decode_varints(type, acc) do
    decode_varints(rest, type, [Protobuf.Wire.decode(type, value) | acc])
  end

  defp resolve_entry(%{rule_type: expected_type, cel: rules} = entry, value, rule_type)
       when is_list(rules) do
    cond do
      expected_type != rule_type ->
        {:error, "extension target Rules message type does not match"}

      not valid_value?(value, Map.get(entry, :value_type, :any)) ->
        {:error, "predefined rule extension value type does not match"}

      true ->
        {:ok, rules}
    end
  end

  defp resolve_entry(_entry, _value, _rule_type),
    do: {:error, "invalid registry entry definition"}

  defp valid_value?(_value, :any), do: true
  defp valid_value?(value, :boolean), do: is_boolean(value)
  defp valid_value?(value, :integer), do: is_integer(value)
  defp valid_value?(value, :binary), do: is_binary(value)
  defp valid_value?(%module{}, module), do: true
  defp valid_value?(value, validator) when is_function(validator, 1), do: validator.(value)
  defp valid_value?(_value, _type), do: false
end
