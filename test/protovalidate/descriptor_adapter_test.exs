defmodule Protovalidate.DescriptorAdapterTest do
  use ExUnit.Case, async: true

  alias Protovalidate.DescriptorAdapter

  @validation_extensions [
    {:field, Buf.Validate.PbExtension, :field},
    {:message, Buf.Validate.PbExtension, :message},
    {:oneof, Buf.Validate.PbExtension, :oneof}
  ]

  test "生成済み message と buf.validate 拡張を正規化する" do
    descriptor =
      DescriptorAdapter.describe(Acme.User.V1.User, extensions: @validation_extensions)

    assert descriptor.module == Acme.User.V1.User
    assert descriptor.full_name == "acme.user.v1.User"

    assert %{field: %{type: {:string, %{well_known: {:uuid, true}}}}} =
             field(descriptor, "id").validation

    assert %{field: %{type: {:uint32, %{less_than: {:lte, 150}}}}} =
             field(descriptor, "age").validation

    assert %{field: %{type: {:string, %{well_known: {:email, true}}}}} =
             field(descriptor, "email").validation

    assert %{message: %{cel: [%{id: "first_name_requires_last_name"}]}} =
             descriptor.validation
  end

  test "proto3 の presence、oneof、repeated、map と WKT を区別する" do
    descriptor =
      DescriptorAdapter.describe(Acme.Descriptor.V1.Probe, extensions: @validation_extensions)

    assert %{presence: :implicit} = field(descriptor, "implicit_string")
    assert %{presence: :explicit} = field(descriptor, "optional_string")

    assert %{repeated?: true, item_type: :TYPE_STRING, presence: :implicit} =
             field(descriptor, "labels")

    assert %{map?: true, map_key: :TYPE_STRING, map_value: :TYPE_UINT32, presence: :implicit} =
             field(descriptor, "scores")

    assert %{presence: :oneof, oneof: "contact"} = field(descriptor, "email")

    assert %{well_known_type: :any} = field(descriptor, "payload")
    assert %{well_known_type: :timestamp} = field(descriptor, "created_at")
    assert %{well_known_type: :duration} = field(descriptor, "timeout")
    assert %{well_known_type: :field_mask} = field(descriptor, "update_mask")
    assert %{enum_values: [0, 1]} = field(descriptor, "status")

    assert %{type: :TYPE_MESSAGE, type_name: ".acme.descriptor.v1.Child", presence: :explicit} =
             field(descriptor, "child")

    assert %{repeated?: true, item_type: :TYPE_MESSAGE, type_name: ".acme.descriptor.v1.Child"} =
             field(descriptor, "children")

    assert %{map?: true, map_key: :TYPE_STRING, map_value: :TYPE_MESSAGE} =
             field(descriptor, "children_by_name")

    assert %{name: "contact", fields: ["email", "phone"], validation: %{oneof: %{required: true}}} =
             hd(descriptor.oneofs)
  end

  test "proto2 required とメッセージ値の presence を取得する" do
    descriptor = DescriptorAdapter.describe(Acme.Descriptor.V1.Legacy)

    assert %{presence: :required} = field(descriptor, "id")
    assert %{presence: :explicit} = field(descriptor, "nickname")

    assert DescriptorAdapter.field_presence(%Acme.Descriptor.V1.Probe{}, :implicit_string) ==
             :maybe

    assert DescriptorAdapter.field_presence(%Acme.Descriptor.V1.Probe{}, :optional_string) ==
             :not_present

    assert DescriptorAdapter.field_presence(
             %Acme.Descriptor.V1.Probe{optional_string: "set"},
             :optional_string
           ) ==
             :present
  end

  defp field(descriptor, name), do: Enum.find(descriptor.fields, &(&1.name == name))
end
