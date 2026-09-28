defmodule Protovalidate.ViolationCodecTest do
  use ExUnit.Case, async: true

  import Protovalidate.TestRules

  alias Acme.Descriptor.V1.{Probe, RecursiveNode}
  alias Protovalidate.{DescriptorAdapter, Plan, ViolationCodec}

  defmodule SourceRegistry do
    @behaviour Protovalidate.PredefinedRuleRegistry

    @impl true
    def resolve_with_source(1001, true, :map) do
      {:ok,
       %{
         rules: [%{id: "message.oneof", expression: "false", message: "invalid"}],
         descriptor: %Google.Protobuf.FieldDescriptorProto{
           name: "acme.custom",
           number: 1001,
           type: :TYPE_BOOL
         }
       }}
    end

    def resolve_with_source(_, _, _), do: :unknown
  end

  defmodule LegacyRegistry do
    @behaviour Protovalidate.PredefinedRuleRegistry

    @impl true
    def resolve(1001, true, :map),
      do: {:ok, [%{id: "legacy", expression: "false", message: "invalid"}]}

    def resolve(7, true, :rules), do: {:ok, [%{id: "delegated"}]}
    def resolve(_, _, _), do: :unknown
  end

  test "ユーザー定義 ID が組み込み ID と同じでも field CEL の出典を使う" do
    compiled =
      plan(
        field(:TYPE_STRING),
        %{cel: [%{id: "message.oneof", expression: "false", message: "invalid"}]},
        cel: Protovalidate.TestCEL
      )

    assert {:ok, [violation]} =
             Plan.evaluate(compiled, %Probe{implicit_string: "x"}, fail_fast: false)

    assert violation.origin.constraint == :field_cel
    assert [%{field_number: 1}] = violation.origin.field.elements

    assert [
             %{
               field_name: "cel",
               field_number: 23,
               field_type: :TYPE_MESSAGE,
               subscript: {:index, 0}
             }
           ] = violation.origin.rule.elements

    assert [
             %{
               field: %{elements: [%{field_number: 1, field_type: :TYPE_STRING}]},
               rule: %{elements: [_]}
             }
           ] =
             ViolationCodec.encode([violation], nil).violations
  end

  test "message CEL と message oneof は異なる制約として wire に出す" do
    user = %Acme.User.V1.User{
      id: "00000000-0000-0000-0000-000000000000",
      email: "ada@example.com",
      first_name: "Ada"
    }

    assert {:error, %{violations: [cel]}} = Protovalidate.validate(user)
    assert cel.origin.constraint == :message_cel
    assert [%{field: nil, rule: nil}] = ViolationCodec.encode([cel], nil).violations

    descriptor = DescriptorAdapter.describe(Probe)

    plan =
      Plan.compile(
        %{
          descriptor
          | validation: %{
              message: %{
                oneof: [%{fields: ["implicit_string", "optional_string"], required: true}]
              }
            }
        },
        []
      )

    assert {:ok, [oneof]} = Plan.evaluate(plan, %Probe{}, fail_fast: true)
    assert oneof.origin.constraint == :message_oneof
    assert oneof.origin.index == 0
    assert [%{field: nil, rule: nil}] = ViolationCodec.encode([oneof], nil).violations
  end

  test "oneof required は番号なしの field と空の rule を保持する" do
    descriptor = DescriptorAdapter.describe(Probe)
    oneof = Enum.find(descriptor.oneofs, &(&1.name == "contact"))

    plan =
      Plan.compile(
        %{descriptor | oneofs: [%{oneof | validation: %{oneof: %{required: true}}}]},
        []
      )

    assert {:ok, [violation]} = Plan.evaluate(plan, %Probe{}, fail_fast: true)
    assert violation.origin.constraint == :oneof_required

    assert [%{field: %{elements: [%{field_name: "contact", field_number: nil}]}, rule: nil}] =
             ViolationCodec.encode([violation], nil).violations
  end

  test "再帰 message の repeated と map に field 番号、添字、rule 出典を保持する" do
    message = %RecursiveNode{
      code: "ok",
      children: [%RecursiveNode{code: "x"}],
      signed_children: %{7 => %RecursiveNode{code: "x"}}
    }

    assert {:error, %{violations: [repeated, mapped]}} = Protovalidate.validate(message)
    assert repeated.origin.constraint == :field
    assert mapped.origin.constraint == :field

    assert [%{field_number: 3, subscript: {:index, 0}}, %{field_number: 1}] =
             repeated.origin.field.elements

    assert [%{field_number: 4, subscript: {:int_key, 7}}, %{field_number: 1}] =
             mapped.origin.field.elements

    assert [
             %{field_name: "string", field_number: 14, field_type: :TYPE_MESSAGE},
             %{field_name: "min_len", field_number: 2, field_type: :TYPE_UINT64}
           ] = repeated.origin.rule.elements

    wire = ViolationCodec.encode([repeated, mapped], nil)
    assert wire == Protovalidate.Conformance.ViolationCodec.encode([repeated, mapped], nil)

    assert Enum.all?(
             wire.violations,
             &(&1.rule.elements |> List.last() |> Map.get(:field_name) == "min_len")
           )
  end

  test "module registry は descriptor 付き応答と従来の resolve/3 を使える" do
    compiled =
      plan(
        field(:TYPE_STRING),
        %{type: {:string, %{__pb_extensions__: %{1001 => true}}}},
        cel: Protovalidate.TestCEL,
        registry: SourceRegistry
      )

    assert {:ok, [violation]} =
             Plan.evaluate(compiled, %Probe{implicit_string: "x"}, fail_fast: false)

    assert violation.origin.constraint == :predefined

    assert [%{field_name: "[acme.custom]", field_number: 1001, field_type: :TYPE_BOOL}] =
             violation.origin.rule.elements |> Enum.take(-1)

    assert [%{rule: %{elements: [_, extension]}}] =
             ViolationCodec.encode([violation], nil).violations

    assert extension.field_number == 1001
    assert [%{field_number: 14}, %{field_number: 1001}] = violation.origin.rule.elements

    assert {:ok, [%{id: "message.oneof"}]} =
             Protovalidate.PredefinedRuleRegistry.resolve(SourceRegistry, 1001, true, :map)

    legacy =
      plan(
        field(:TYPE_STRING),
        %{type: {:string, %{__pb_extensions__: %{1001 => true}}}},
        cel: Protovalidate.TestCEL,
        registry: LegacyRegistry
      )

    assert {:ok, [legacy_violation]} =
             Plan.evaluate(legacy, %Probe{implicit_string: "x"}, fail_fast: false)

    assert [%{rule: %{elements: [_, %{field_number: 1001}]}}] =
             ViolationCodec.encode([legacy_violation], nil).violations

    assert {:ok, %{rules: [%{id: "delegated"}], descriptor: nil}} =
             Protovalidate.PredefinedRuleRegistry.resolve_with_source(
               LegacyRegistry,
               7,
               true,
               :rules
             )
  end
end
