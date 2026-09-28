defmodule PhoenixSample.Proto.User do
  @moduledoc false

  use Protobuf,
    full_name: "phoenix_sample.proto.User",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto3

  def descriptor do
    %Google.Protobuf.DescriptorProto{
      name: "User",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "id",
          extendee: nil,
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_STRING,
          type_name: nil,
          default_value: nil,
          options: %Google.Protobuf.FieldOptions{
            ctype: :STRING,
            packed: nil,
            deprecated: false,
            lazy: false,
            jstype: :JS_NORMAL,
            weak: false,
            unverified_lazy: false,
            debug_redact: false,
            retention: nil,
            targets: [],
            edition_defaults: [],
            features: nil,
            feature_support: nil,
            uninterpreted_option: [],
            __pb_extensions__: %{},
            __unknown_fields__: [{1159, 2, <<114, 3, 176, 1, 1>>}],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "id",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "age",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_UINT32,
          type_name: nil,
          default_value: nil,
          options: %Google.Protobuf.FieldOptions{
            ctype: :STRING,
            packed: nil,
            deprecated: false,
            lazy: false,
            jstype: :JS_NORMAL,
            weak: false,
            unverified_lazy: false,
            debug_redact: false,
            retention: nil,
            targets: [],
            edition_defaults: [],
            features: nil,
            feature_support: nil,
            uninterpreted_option: [],
            __pb_extensions__: %{},
            __unknown_fields__: [{1159, 2, <<42, 3, 24, 150, 1>>}],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "age",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "email",
          extendee: nil,
          number: 3,
          label: :LABEL_OPTIONAL,
          type: :TYPE_STRING,
          type_name: nil,
          default_value: nil,
          options: %Google.Protobuf.FieldOptions{
            ctype: :STRING,
            packed: nil,
            deprecated: false,
            lazy: false,
            jstype: :JS_NORMAL,
            weak: false,
            unverified_lazy: false,
            debug_redact: false,
            retention: nil,
            targets: [],
            edition_defaults: [],
            features: nil,
            feature_support: nil,
            uninterpreted_option: [],
            __pb_extensions__: %{},
            __unknown_fields__: [{1159, 2, <<114, 2, 96, 1>>}],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "email",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "first_name",
          extendee: nil,
          number: 4,
          label: :LABEL_OPTIONAL,
          type: :TYPE_STRING,
          type_name: nil,
          default_value: nil,
          options: %Google.Protobuf.FieldOptions{
            ctype: :STRING,
            packed: nil,
            deprecated: false,
            lazy: false,
            jstype: :JS_NORMAL,
            weak: false,
            unverified_lazy: false,
            debug_redact: false,
            retention: nil,
            targets: [],
            edition_defaults: [],
            features: nil,
            feature_support: nil,
            uninterpreted_option: [],
            __pb_extensions__: %{},
            __unknown_fields__: [{1159, 2, <<114, 2, 24, 64>>}],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "firstName",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "last_name",
          extendee: nil,
          number: 5,
          label: :LABEL_OPTIONAL,
          type: :TYPE_STRING,
          type_name: nil,
          default_value: nil,
          options: %Google.Protobuf.FieldOptions{
            ctype: :STRING,
            packed: nil,
            deprecated: false,
            lazy: false,
            jstype: :JS_NORMAL,
            weak: false,
            unverified_lazy: false,
            debug_redact: false,
            retention: nil,
            targets: [],
            edition_defaults: [],
            features: nil,
            feature_support: nil,
            uninterpreted_option: [],
            __pb_extensions__: %{},
            __unknown_fields__: [{1159, 2, <<114, 2, 24, 64>>}],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "lastName",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [],
      extension: [],
      options: %Google.Protobuf.MessageOptions{
        message_set_wire_format: false,
        no_standard_descriptor_accessor: false,
        deprecated: false,
        map_entry: nil,
        deprecated_legacy_json_field_conflicts: nil,
        features: nil,
        uninterpreted_option: [],
        __pb_extensions__: %{},
        __unknown_fields__: [
          {1159, 2,
           <<26, 129, 1, 10, 29, 102, 105, 114, 115, 116, 95, 110, 97, 109, 101, 95, 114, 101,
             113, 117, 105, 114, 101, 115, 95, 108, 97, 115, 116, 95, 110, 97, 109, 101, 18, 50,
             108, 97, 115, 116, 95, 110, 97, 109, 101, 32, 109, 117, 115, 116, 32, 98, 101, 32,
             112, 114, 101, 115, 101, 110, 116, 32, 105, 102, 32, 102, 105, 114, 115, 116, 95,
             110, 97, 109, 101, 32, 105, 115, 32, 112, 114, 101, 115, 101, 110, 116, 26, 44, 33,
             104, 97, 115, 40, 116, 104, 105, 115, 46, 102, 105, 114, 115, 116, 95, 110, 97, 109,
             101, 41, 32, 124, 124, 32, 104, 97, 115, 40, 116, 104, 105, 115, 46, 108, 97, 115,
             116, 95, 110, 97, 109, 101, 41>>}
        ],
        __protobuf__: true
      },
      oneof_decl: [],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  field(:id, 1, type: :string, deprecated: false)
  field(:age, 2, type: :uint32, deprecated: false)
  field(:email, 3, type: :string, deprecated: false)
  field(:first_name, 4, type: :string, json_name: "firstName", deprecated: false)
  field(:last_name, 5, type: :string, json_name: "lastName", deprecated: false)
end
