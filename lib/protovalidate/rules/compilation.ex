defmodule Protovalidate.Rules.Compilation do
  @moduledoc false

  alias Protovalidate.{CompilationError, UnsupportedRuleError}

  def add_if(list, true, value), do: list ++ [value]
  def add_if(list, false, _value), do: list
  def rule_value(nil, _key), do: nil
  def rule_value(rules, key), do: rules |> rule_map() |> Map.get(key)

  def append_scalar_rules(compiled, rules, keys) do
    Enum.reduce(keys, compiled, fn key, acc ->
      case rule_value(rules, key) do
        nil -> acc
        [] -> acc
        value -> acc ++ [{key, value}]
      end
    end)
  end

  def reject_unknown_rule_fields!(rules, known, prefix) do
    reject_unknown_wire_fields!(rules, [prefix])

    rules
    |> rule_map()
    |> Map.drop([:__struct__, :__protobuf__, :__unknown_fields__, :__pb_extensions__])
    |> Enum.each(fn {key, value} ->
      # example は schema documentation 用 metadata であり、検証結果に影響しない。
      if key not in [:example | known] and not is_nil(value),
        do: unsupported!("unsupported #{prefix}.#{key} rule", [prefix, Atom.to_string(key)])
    end)
  end

  def reject_unknown_wire_fields!(value, path) when is_map(value) do
    if Map.get(value, :__unknown_fields__, []) not in [nil, []],
      do: unsupported!("unknown validation wire field", path)

    value
    |> Map.drop([:__struct__, :__protobuf__, :__unknown_fields__, :__pb_extensions__])
    |> Enum.each(fn {key, nested} ->
      reject_unknown_wire_fields!(nested, path ++ [to_string(key)])
    end)
  end

  def reject_unknown_wire_fields!(values, path) when is_list(values),
    do: Enum.each(values, &reject_unknown_wire_fields!(&1, path))

  def reject_unknown_wire_fields!({_kind, value}, path),
    do: reject_unknown_wire_fields!(value, path)

  def reject_unknown_wire_fields!(_value, _path), do: :ok

  def reject_extensions!(nil, _path), do: :ok

  def reject_extensions!(rules, path) do
    if Map.get(rules, :__pb_extensions__, %{}) not in [nil, %{}],
      do: unsupported!("unknown validation extension", path)
  end

  def rule_map(%_{} = rules), do: rules |> Map.from_struct() |> normalize_rule_oneofs()
  def rule_map(rules) when is_map(rules), do: rules

  # validate.proto 1.2 以降は string の well-known format を oneof にまとめている。
  # 内部 evaluator は従来どおり個別キーで扱い、両スキーマ版の descriptor を受け入れる。
  defp normalize_rule_oneofs(rules) do
    [:well_known, :less_than, :greater_than]
    |> Enum.reduce(rules, fn key, acc ->
      case Map.get(acc, key) do
        {name, value} -> acc |> Map.delete(key) |> Map.put(name, value)
        _ -> acc
      end
    end)
  end

  def reject_conflicting_bounds!(rules, kind) do
    if not is_nil(rule_value(rules, :lt)) and not is_nil(rule_value(rules, :lte)),
      do: compilation_error!("#{kind}.lt and #{kind}.lte cannot both be specified", [kind])

    if not is_nil(rule_value(rules, :gt)) and not is_nil(rule_value(rules, :gte)),
      do: compilation_error!("#{kind}.gt and #{kind}.gte cannot both be specified", [kind])
  end

  def compilation_error!(message, path),
    do: raise(CompilationError, message: message, rule_path: path)

  def unsupported!(message, path),
    do: raise(UnsupportedRuleError, message: message, rule_path: path)
end
