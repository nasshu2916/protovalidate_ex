defmodule Protovalidate.PredefinedGenerationTest do
  use ExUnit.Case, async: true

  alias Protovalidate.{PredefinedRuleRegistry, ValidationError}

  test "公式スキーマから生成した拡張を registry・CEL・wire 違反まで通す" do
    descriptor = %Google.Protobuf.FieldDescriptorProto{
      name: "acme.predefined.v1.even",
      number: 1001,
      type: :TYPE_BOOL,
      extendee: ".buf.validate.Int64Rules",
      label: :LABEL_OPTIONAL
    }

    registry =
      PredefinedRuleRegistry.new(%{
        {Buf.Validate.Int64Rules, 1001} => %{
          rule_type: Buf.Validate.Int64Rules,
          value_type: :boolean,
          descriptor: descriptor,
          cel: [
            %{id: "int64.even", expression: "!rule || this % 2 == 0", message: "must be even"}
          ]
        }
      })

    options = [cel: Protovalidate.CEL.Celixir, registry: registry]
    message = %Acme.Predefined.V1.Input{value: 4}
    assert {:ok, ^message} = Protovalidate.validate(message, options)

    assert {:error, %ValidationError{violations: [violation]}} =
             Protovalidate.validate(%{message | value: 3}, options)

    assert violation.rule_id == "int64.even"
    assert violation.message == "must be even"
    wire = Protovalidate.Conformance.ViolationCodec.encode([violation], message.__struct__)
    assert [%{rule: %{elements: [_, extension]}}] = wire.violations
    assert extension.field_name == "[" <> descriptor.name <> "]"
    assert extension.field_number == 1001
    assert extension.field_type == :TYPE_BOOL
  end

  test "packed の repeated extension を負の int32 配列へ復号する" do
    descriptor = %Google.Protobuf.FieldDescriptorProto{
      name: "acme.predefined.v1.allowed",
      number: 1002,
      type: :TYPE_INT32,
      extendee: ".buf.validate.Int32Rules",
      label: :LABEL_REPEATED
    }

    registry =
      PredefinedRuleRegistry.new(%{
        {Buf.Validate.Int32Rules, 1002} => %{
          rule_type: Buf.Validate.Int32Rules,
          descriptor: descriptor,
          cel: [%{id: "int32.allowed", expression: "this in rule", message: "not allowed"}]
        }
      })

    packed = IO.iodata_to_binary(Protobuf.Wire.Varint.encode(-2))

    assert {:ok, %{value: [-2], descriptor: ^descriptor}} =
             PredefinedRuleRegistry.resolve_with_source(
               registry,
               1002,
               packed,
               Buf.Validate.Int32Rules
             )
  end
end
