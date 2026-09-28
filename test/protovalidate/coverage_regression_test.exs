defmodule Protovalidate.CoverageRegistry do
  @behaviour Protovalidate.PredefinedRuleRegistry

  @impl true
  def resolve(7, true, :rules), do: {:ok, [%{id: "delegated"}]}
  def resolve(_, _, _), do: :unknown
end

defmodule Protovalidate.CoverageRegressionTest do
  use ExUnit.Case, async: true

  alias Protovalidate.CEL.{CelixirAccess, TypeEnvironment}
  alias Protovalidate.PredefinedRuleRegistry, as: Registry

  test "registry は登録形式、値型、delegate を検証する" do
    entry = %{rule_type: :rules, cel: [%{id: "rule"}], value_type: :integer, descriptor: %{id: 1}}
    registry = Registry.new(%{1 => entry, {:rules, 2} => %{entry | value_type: :binary}})

    assert {:ok, [%{id: "rule"}]} = Registry.resolve(registry, 1, 10, :rules)

    assert {:error, "predefined rule extension value type does not match"} =
             Registry.resolve(registry, 1, "10", :rules)

    assert {:error, "extension target Rules message type does not match"} =
             Registry.resolve(registry, 1, 10, :other_rules)

    assert {:ok, [%{id: "rule"}]} = Registry.resolve(registry, 2, "value", :rules)
    assert :unknown = Registry.resolve(registry, 3, true, :rules)
    assert %{id: 1} = Registry.descriptor(registry, 1, :rules)
    assert nil == Registry.descriptor(registry, 3, :rules)
    assert nil == Registry.descriptor(:invalid, 1, :rules)

    assert {:ok, [%{id: "delegated"}]} =
             Registry.resolve(Protovalidate.CoverageRegistry, 7, true, :rules)

    assert {:error, message} = Registry.resolve(String, 1, true, :rules)
    assert message =~ "resolve/3"
    assert {:error, "invalid :registry configuration"} = Registry.resolve(123, 1, true, :rules)
  end

  test "CEL の型環境は指定値を保持し、遅延して message descriptor を解決する" do
    environment = TypeEnvironment.new(cel_message_descriptor: %{full_name: "example.Input"})
    assert environment.message == %{full_name: "example.Input"}
    assert environment.field == nil

    assert %{full_name: "acme.descriptor.v1.Child"} =
             TypeEnvironment.resolve_message(%{reference: Acme.Descriptor.V1.Child})
  end

  test "CEL field access は protobuf のデフォルト値と map を扱う" do
    message = %Acme.Descriptor.V1.Probe{}

    assert "" == CelixirAccess.get(message, "implicit_string")
    assert 0 == CelixirAccess.get(message, "status")
    assert %Acme.Descriptor.V1.Child{} = CelixirAccess.get(message, "child")

    assert_raise ArgumentError, ~r/unknown protobuf field/, fn ->
      CelixirAccess.get(message, "missing")
    end

    assert "value" == CelixirAccess.get(%{"key" => "value"}, "key")
    assert true == CelixirAccess.has?(%{"key" => "value"}, "key")
    assert false == CelixirAccess.has?(%{"key" => "value"}, "missing")
    assert false == CelixirAccess.has?(:not_a_map, "key")
  end

  test "CEL field access の AST 書き換えは select、has、tuple を再帰走査する" do
    alias Celixir.AST

    select = %AST.Select{operand: %AST.Ident{name: "this"}, field: "implicit_string"}

    assert %AST.Call{function: "_pv_get", args: [%AST.Ident{name: "this"}, %AST.StringLit{}]} =
             CelixirAccess.rewrite(select)

    assert %AST.Call{function: "_pv_has"} =
             CelixirAccess.rewrite(%AST.Call{function: "has", target: nil, args: [select]})

    assert {%AST.Call{function: "_pv_get"}, :value} = CelixirAccess.rewrite({select, :value})
  end

  test "CEL 値への変換は WKT、collection、enum を正規化する" do
    alias Protovalidate.CEL.CelixirTypes
    alias Protovalidate.DescriptorAdapter

    descriptor = DescriptorAdapter.describe(Acme.Descriptor.V1.Probe)
    labels = Enum.find(descriptor.fields, &(&1.name == "labels"))
    scores = Enum.find(descriptor.fields, &(&1.name == "scores"))
    status = Enum.find(descriptor.fields, &(&1.name == "status"))

    assert ["one", "two"] == CelixirTypes.field_value(["one", "two"], labels)
    assert %{"one" => 1} == CelixirTypes.field_value(%{"one" => 1}, scores)
    assert 1 == CelixirTypes.field_value(1, status)
    assert "text" == CelixirTypes.value("text")
    assert [1, true] == CelixirTypes.value([1, true])
    assert %{value: "text"} == CelixirTypes.value(%{value: "text"})
    assert "wrapped" == CelixirTypes.value(%Google.Protobuf.StringValue{value: "wrapped"})

    assert %Celixir.Types.Timestamp{} =
             CelixirTypes.timestamp(%{seconds: 0, nanos: 1})

    assert_raise Protovalidate.RuntimeError, "invalid protobuf timestamp", fn ->
      CelixirTypes.timestamp(%{seconds: 253_402_300_800, nanos: 0})
    end

    assert %Celixir.Types.Duration{} =
             CelixirTypes.value(%Google.Protobuf.Duration{seconds: 1, nanos: 0})

    assert_raise Protovalidate.RuntimeError, "invalid protobuf duration", fn ->
      CelixirTypes.value(%Google.Protobuf.Duration{seconds: 1, nanos: -1})
    end
  end

  test "field path は全ての map key 型を区別する" do
    path =
      Protovalidate.FieldPath.new([])
      |> Protovalidate.FieldPath.field("items")
      |> Protovalidate.FieldPath.index(0)

    assert [
             {:field, "items"},
             {:index, 0},
             {:map_key, :string, "name"},
             {:map_key, :bool, true},
             {:map_key, :int, -1},
             {:map_key, :uint, 1}
           ] =
             path
             |> Protovalidate.FieldPath.map_key("name")
             |> Protovalidate.FieldPath.map_key(true)
             |> Protovalidate.FieldPath.map_key(-1)
             |> Protovalidate.FieldPath.map_key(1)
             |> Map.fetch!(:segments)
  end
end
