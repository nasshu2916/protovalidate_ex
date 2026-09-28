defmodule Protovalidate.CEL.CelixirAccess do
  @moduledoc false
  alias Celixir.AST
  alias Protovalidate.CEL.CelixirTypes
  alias Protovalidate.DescriptorAdapter, as: Descriptor

  def rewrite(%AST.Call{function: "has", target: nil, args: [%AST.Select{} = select]}),
    do: access(select, "_pv_has")

  def rewrite(%AST.Select{test_only: true} = select), do: access(select, "_pv_has")
  def rewrite(%AST.Select{} = select), do: access(select, "_pv_get")

  def rewrite(%module{} = ast),
    do:
      struct!(
        module,
        Enum.map(Map.from_struct(ast), fn {key, value} -> {key, rewrite(value)} end)
      )

  def rewrite(values) when is_list(values), do: Enum.map(values, &rewrite/1)

  def rewrite(value) when is_tuple(value),
    do: value |> Tuple.to_list() |> rewrite() |> List.to_tuple()

  def rewrite(value), do: value

  defp access(select, function),
    do: %AST.Call{
      function: function,
      args: [rewrite(select.operand), %AST.StringLit{value: select.field}]
    }

  def get(message, name), do: get(message, name, nil)

  def get(%module{} = message, name, resolver) do
    field = field(module, name, resolver)

    if is_nil(field), do: raise(ArgumentError, "unknown protobuf field: #{name}")
    raw = Descriptor.field_value(message, field)
    raw = if is_nil(raw), do: default(field), else: raw
    CelixirTypes.field_value(raw, field)
  end

  def get(target, name, _resolver) when is_map(target), do: Map.fetch!(target, name)

  def has?(message, name), do: has?(message, name, nil)

  def has?(%module{} = message, name, resolver) do
    field = field(module, name, resolver)

    not is_nil(field) and
      Descriptor.field_presence(message, String.to_existing_atom(name)) == :present
  end

  def has?(target, name, _resolver) when is_map(target), do: Map.has_key?(target, name)
  def has?(_target, _name, _resolver), do: false

  defp default(field), do: Descriptor.default_value(field)

  # validator 経由の CEL 評価では、同じ検証中に descriptor を再正規化しない。
  # 単独の Plan.evaluate/3 は従来どおり adapter から取得する。
  defp field(module, name, resolver) do
    resolve_cached(resolver, module, name) ||
      module |> Descriptor.describe() |> Map.fetch!(:fields) |> Enum.find(&(&1.name == name))
  end

  defp resolve_cached(%Protovalidate.CEL.DescriptorResolver{} = resolver, module, name),
    do: Protovalidate.CEL.DescriptorResolver.field(resolver, module, name)

  defp resolve_cached(_resolver, _module, _name), do: nil
end
