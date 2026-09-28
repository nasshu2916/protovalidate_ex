defmodule Buf.Validate.Ignore do
  @moduledoc false

  use Protobuf,
    enum: true,
    full_name: "buf.validate.Ignore",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.EnumDescriptorProto{
      name: "Ignore",
      value: [
        %Google.Protobuf.EnumValueDescriptorProto{
          name: "IGNORE_UNSPECIFIED",
          number: 0,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.EnumValueDescriptorProto{
          name: "IGNORE_IF_ZERO_VALUE",
          number: 1,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.EnumValueDescriptorProto{
          name: "IGNORE_ALWAYS",
          number: 3,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      options: nil,
      reserved_range: [
        %Google.Protobuf.EnumDescriptorProto.EnumReservedRange{
          start: 2,
          end: 2,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_name: [
        "IGNORE_EMPTY",
        "IGNORE_DEFAULT",
        "IGNORE_IF_DEFAULT_VALUE",
        "IGNORE_IF_UNPOPULATED"
      ],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  field(:IGNORE_UNSPECIFIED, 0)
  field(:IGNORE_IF_ZERO_VALUE, 1)
  field(:IGNORE_ALWAYS, 3)
end

defmodule Buf.Validate.KnownRegex do
  @moduledoc false

  use Protobuf,
    enum: true,
    full_name: "buf.validate.KnownRegex",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.EnumDescriptorProto{
      name: "KnownRegex",
      value: [
        %Google.Protobuf.EnumValueDescriptorProto{
          name: "KNOWN_REGEX_UNSPECIFIED",
          number: 0,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.EnumValueDescriptorProto{
          name: "KNOWN_REGEX_HTTP_HEADER_NAME",
          number: 1,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.EnumValueDescriptorProto{
          name: "KNOWN_REGEX_HTTP_HEADER_VALUE",
          number: 2,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      options: nil,
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  field(:KNOWN_REGEX_UNSPECIFIED, 0)
  field(:KNOWN_REGEX_HTTP_HEADER_NAME, 1)
  field(:KNOWN_REGEX_HTTP_HEADER_VALUE, 2)
end

defmodule Buf.Validate.Rule do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.Rule",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "Rule",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "id",
          extendee: nil,
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_STRING,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "id",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "message",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_STRING,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "message",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "expression",
          extendee: nil,
          number: 3,
          label: :LABEL_OPTIONAL,
          type: :TYPE_STRING,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "expression",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [],
      extension: [],
      options: nil,
      oneof_decl: [],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  field(:id, 1, optional: true, type: :string)
  field(:message, 2, optional: true, type: :string)
  field(:expression, 3, optional: true, type: :string)
end

defmodule Buf.Validate.MessageRules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.MessageRules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "MessageRules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "cel_expression",
          extendee: nil,
          number: 5,
          label: :LABEL_REPEATED,
          type: :TYPE_STRING,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "celExpression",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "cel",
          extendee: nil,
          number: 3,
          label: :LABEL_REPEATED,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.Rule",
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "cel",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "oneof",
          extendee: nil,
          number: 4,
          label: :LABEL_REPEATED,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.MessageOneofRule",
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "oneof",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [],
      extension: [],
      options: nil,
      oneof_decl: [],
      reserved_range: [
        %Google.Protobuf.DescriptorProto.ReservedRange{
          start: 1,
          end: 2,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_name: ["disabled"],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  field(:cel_expression, 5, repeated: true, type: :string, json_name: "celExpression")
  field(:cel, 3, repeated: true, type: Buf.Validate.Rule)
  field(:oneof, 4, repeated: true, type: Buf.Validate.MessageOneofRule)
end

defmodule Buf.Validate.MessageOneofRule do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.MessageOneofRule",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "MessageOneofRule",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "fields",
          extendee: nil,
          number: 1,
          label: :LABEL_REPEATED,
          type: :TYPE_STRING,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "fields",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "required",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "required",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [],
      extension: [],
      options: nil,
      oneof_decl: [],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  field(:fields, 1, repeated: true, type: :string)
  field(:required, 2, optional: true, type: :bool)
end

defmodule Buf.Validate.OneofRules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.OneofRules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "OneofRules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "required",
          extendee: nil,
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "required",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [],
      extension: [],
      options: nil,
      oneof_decl: [],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  field(:required, 1, optional: true, type: :bool)
end

defmodule Buf.Validate.FieldRules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.FieldRules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "FieldRules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "cel_expression",
          extendee: nil,
          number: 29,
          label: :LABEL_REPEATED,
          type: :TYPE_STRING,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "celExpression",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "cel",
          extendee: nil,
          number: 23,
          label: :LABEL_REPEATED,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.Rule",
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "cel",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "required",
          extendee: nil,
          number: 25,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "required",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "ignore",
          extendee: nil,
          number: 27,
          label: :LABEL_OPTIONAL,
          type: :TYPE_ENUM,
          type_name: ".buf.validate.Ignore",
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "ignore",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "float",
          extendee: nil,
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.FloatRules",
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "float",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "double",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.DoubleRules",
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "double",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "int32",
          extendee: nil,
          number: 3,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.Int32Rules",
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "int32",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "int64",
          extendee: nil,
          number: 4,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.Int64Rules",
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "int64",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "uint32",
          extendee: nil,
          number: 5,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.UInt32Rules",
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "uint32",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "uint64",
          extendee: nil,
          number: 6,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.UInt64Rules",
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "uint64",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "sint32",
          extendee: nil,
          number: 7,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.SInt32Rules",
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "sint32",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "sint64",
          extendee: nil,
          number: 8,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.SInt64Rules",
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "sint64",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "fixed32",
          extendee: nil,
          number: 9,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.Fixed32Rules",
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "fixed32",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "fixed64",
          extendee: nil,
          number: 10,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.Fixed64Rules",
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "fixed64",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "sfixed32",
          extendee: nil,
          number: 11,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.SFixed32Rules",
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "sfixed32",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "sfixed64",
          extendee: nil,
          number: 12,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.SFixed64Rules",
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "sfixed64",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "bool",
          extendee: nil,
          number: 13,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.BoolRules",
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "bool",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "string",
          extendee: nil,
          number: 14,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.StringRules",
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "string",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "bytes",
          extendee: nil,
          number: 15,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.BytesRules",
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "bytes",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "enum",
          extendee: nil,
          number: 16,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.EnumRules",
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "enum",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "repeated",
          extendee: nil,
          number: 18,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.RepeatedRules",
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "repeated",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "map",
          extendee: nil,
          number: 19,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.MapRules",
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "map",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "any",
          extendee: nil,
          number: 20,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.AnyRules",
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "any",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "duration",
          extendee: nil,
          number: 21,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.DurationRules",
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "duration",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "field_mask",
          extendee: nil,
          number: 28,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.FieldMaskRules",
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "fieldMask",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "timestamp",
          extendee: nil,
          number: 22,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.TimestampRules",
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "timestamp",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [],
      extension: [],
      options: nil,
      oneof_decl: [
        %Google.Protobuf.OneofDescriptorProto{
          name: "type",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_range: [
        %Google.Protobuf.DescriptorProto.ReservedRange{
          start: 24,
          end: 25,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.DescriptorProto.ReservedRange{
          start: 26,
          end: 27,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_name: ["skipped", "ignore_empty"],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  oneof(:type, 0)

  field(:cel_expression, 29, repeated: true, type: :string, json_name: "celExpression")
  field(:cel, 23, repeated: true, type: Buf.Validate.Rule)
  field(:required, 25, optional: true, type: :bool)
  field(:ignore, 27, optional: true, type: Buf.Validate.Ignore, enum: true)
  field(:float, 1, optional: true, type: Buf.Validate.FloatRules, oneof: 0)
  field(:double, 2, optional: true, type: Buf.Validate.DoubleRules, oneof: 0)
  field(:int32, 3, optional: true, type: Buf.Validate.Int32Rules, oneof: 0)
  field(:int64, 4, optional: true, type: Buf.Validate.Int64Rules, oneof: 0)
  field(:uint32, 5, optional: true, type: Buf.Validate.UInt32Rules, oneof: 0)
  field(:uint64, 6, optional: true, type: Buf.Validate.UInt64Rules, oneof: 0)
  field(:sint32, 7, optional: true, type: Buf.Validate.SInt32Rules, oneof: 0)
  field(:sint64, 8, optional: true, type: Buf.Validate.SInt64Rules, oneof: 0)
  field(:fixed32, 9, optional: true, type: Buf.Validate.Fixed32Rules, oneof: 0)
  field(:fixed64, 10, optional: true, type: Buf.Validate.Fixed64Rules, oneof: 0)
  field(:sfixed32, 11, optional: true, type: Buf.Validate.SFixed32Rules, oneof: 0)
  field(:sfixed64, 12, optional: true, type: Buf.Validate.SFixed64Rules, oneof: 0)
  field(:bool, 13, optional: true, type: Buf.Validate.BoolRules, oneof: 0)
  field(:string, 14, optional: true, type: Buf.Validate.StringRules, oneof: 0)
  field(:bytes, 15, optional: true, type: Buf.Validate.BytesRules, oneof: 0)
  field(:enum, 16, optional: true, type: Buf.Validate.EnumRules, oneof: 0)
  field(:repeated, 18, optional: true, type: Buf.Validate.RepeatedRules, oneof: 0)
  field(:map, 19, optional: true, type: Buf.Validate.MapRules, oneof: 0)
  field(:any, 20, optional: true, type: Buf.Validate.AnyRules, oneof: 0)
  field(:duration, 21, optional: true, type: Buf.Validate.DurationRules, oneof: 0)

  field(:field_mask, 28,
    optional: true,
    type: Buf.Validate.FieldMaskRules,
    json_name: "fieldMask",
    oneof: 0
  )

  field(:timestamp, 22, optional: true, type: Buf.Validate.TimestampRules, oneof: 0)
end

defmodule Buf.Validate.PredefinedRules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.PredefinedRules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "PredefinedRules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "cel",
          extendee: nil,
          number: 1,
          label: :LABEL_REPEATED,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.Rule",
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "cel",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [],
      extension: [],
      options: nil,
      oneof_decl: [],
      reserved_range: [
        %Google.Protobuf.DescriptorProto.ReservedRange{
          start: 24,
          end: 25,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.DescriptorProto.ReservedRange{
          start: 26,
          end: 27,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_name: ["skipped", "ignore_empty"],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  field(:cel, 1, repeated: true, type: Buf.Validate.Rule)
end

defmodule Buf.Validate.FloatRules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.FloatRules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "FloatRules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "const",
          extendee: nil,
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_FLOAT,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 105, 10, 11, 102, 108, 111, 97, 116, 46, 99, 111, 110, 115, 116, 26, 90, 116,
                 104, 105, 115, 32, 33, 61, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114,
                 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 32, 63, 32, 39,
                 109, 117, 115, 116, 32, 101, 113, 117, 97, 108, 32, 37, 115, 39, 46, 102, 111,
                 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114, 117,
                 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 93, 41, 32, 58, 32,
                 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "const",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lt",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_FLOAT,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 131, 1, 10, 8, 102, 108, 111, 97, 116, 46, 108, 116, 26, 119, 33, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38, 32, 33, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38, 32, 40, 116,
                 104, 105, 115, 46, 105, 115, 78, 97, 110, 40, 41, 32, 124, 124, 32, 116, 104,
                 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108, 116, 41, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110,
                 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101,
                 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lte",
          extendee: nil,
          number: 3,
          label: :LABEL_OPTIONAL,
          type: :TYPE_FLOAT,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 146, 1, 10, 9, 102, 108, 111, 97, 116, 46, 108, 116, 101, 26, 132, 1, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38, 32,
                 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38, 32,
                 40, 116, 104, 105, 115, 46, 105, 115, 78, 97, 110, 40, 41, 32, 124, 124, 32, 116,
                 104, 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 63,
                 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116, 104,
                 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39,
                 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 108, 116,
                 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gt",
          extendee: nil,
          number: 4,
          label: :LABEL_OPTIONAL,
          type: :TYPE_FLOAT,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 134, 1, 10, 8, 102, 108, 111, 97, 116, 46, 103, 116, 26, 122, 33, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 33, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 40, 116,
                 104, 105, 115, 46, 105, 115, 78, 97, 110, 40, 41, 32, 124, 124, 32, 116, 104,
                 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116,
                 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 103, 116, 93, 41, 32, 58, 32, 39, 39, 10, 189, 1, 10, 11, 102,
                 108, 111, 97, 116, 46, 103, 116, 95, 108, 116, 26, 173, 1, 104, 97, 115, 40, 114,
                 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115,
                 46, 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 32, 38, 38,
                 32, 40, 116, 104, 105, 115, 46, 105, 115, 78, 97, 110, 40, 41, 32, 124, 124, 32,
                 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108, 116, 32,
                 124, 124, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46,
                 103, 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97,
                 116, 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 97, 110, 100, 32, 108,
                 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109,
                 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32, 114, 117, 108,
                 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 199, 1, 10, 21, 102, 108,
                 111, 97, 116, 46, 103, 116, 95, 108, 116, 95, 101, 120, 99, 108, 117, 115, 105,
                 118, 101, 26, 173, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116,
                 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 32, 114, 117,
                 108, 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 116, 104, 105, 115, 46, 105,
                 115, 78, 97, 110, 40, 41, 32, 124, 124, 32, 40, 114, 117, 108, 101, 115, 46, 108,
                 116, 32, 60, 61, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32,
                 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 41, 63, 32, 39, 109, 117,
                 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97,
                 110, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110,
                 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101,
                 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58,
                 32, 39, 39, 10, 205, 1, 10, 12, 102, 108, 111, 97, 116, 46, 103, 116, 95, 108,
                 116, 101, 26, 188, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116,
                 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 62, 61,
                 32, 114, 117, 108, 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 116, 104, 105,
                 115, 46, 105, 115, 78, 97, 110, 40, 41, 32, 124, 124, 32, 116, 104, 105, 115, 32,
                 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 124, 124, 32, 116, 104,
                 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116,
                 104, 97, 110, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101, 115, 115, 32, 116,
                 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37,
                 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46,
                 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32,
                 39, 39, 10, 215, 1, 10, 22, 102, 108, 111, 97, 116, 46, 103, 116, 95, 108, 116,
                 101, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26, 188, 1, 104, 97, 115,
                 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 32, 38, 38, 32, 40, 116, 104, 105, 115, 46, 105, 115, 78, 97, 110, 40, 41,
                 32, 124, 124, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32,
                 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117,
                 108, 101, 115, 46, 103, 116, 41, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101,
                 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32,
                 111, 114, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101,
                 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97,
                 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101,
                 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gte",
          extendee: nil,
          number: 5,
          label: :LABEL_OPTIONAL,
          type: :TYPE_FLOAT,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 149, 1, 10, 9, 102, 108, 111, 97, 116, 46, 103, 116, 101, 26, 135, 1, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32,
                 40, 116, 104, 105, 115, 46, 105, 115, 78, 97, 110, 40, 41, 32, 124, 124, 32, 116,
                 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 63,
                 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114,
                 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111,
                 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101,
                 115, 46, 103, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 204, 1, 10, 12, 102, 108,
                 111, 97, 116, 46, 103, 116, 101, 95, 108, 116, 26, 187, 1, 104, 97, 115, 40, 114,
                 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115,
                 46, 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 32, 38,
                 38, 32, 40, 116, 104, 105, 115, 46, 105, 115, 78, 97, 110, 40, 41, 32, 124, 124,
                 32, 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108, 116,
                 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46,
                 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114,
                 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117,
                 97, 108, 32, 116, 111, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101, 115, 115, 32,
                 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114,
                 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 93, 41, 32, 58, 32, 39, 39, 10, 214, 1, 10, 22, 102, 108, 111, 97, 116, 46,
                 103, 116, 101, 95, 108, 116, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26,
                 187, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38,
                 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 32, 114, 117, 108, 101, 115,
                 46, 103, 116, 101, 32, 38, 38, 32, 40, 116, 104, 105, 115, 46, 105, 115, 78, 97,
                 110, 40, 41, 32, 124, 124, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60,
                 61, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 32, 114,
                 117, 108, 101, 115, 46, 103, 116, 101, 41, 41, 63, 32, 39, 109, 117, 115, 116,
                 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32,
                 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 111, 114,
                 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111,
                 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32,
                 114, 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 220, 1,
                 10, 13, 102, 108, 111, 97, 116, 46, 103, 116, 101, 95, 108, 116, 101, 26, 202, 1,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32,
                 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 62, 61, 32, 114, 117, 108, 101,
                 115, 46, 103, 116, 101, 32, 38, 38, 32, 40, 116, 104, 105, 115, 46, 105, 115, 78,
                 97, 110, 40, 41, 32, 124, 124, 32, 116, 104, 105, 115, 32, 62, 32, 114, 117, 108,
                 101, 115, 46, 108, 116, 101, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 32,
                 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116,
                 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32,
                 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 97, 110,
                 100, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113,
                 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40,
                 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108, 101, 115,
                 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 230, 1, 10, 23, 102, 108, 111,
                 97, 116, 46, 103, 116, 101, 95, 108, 116, 101, 95, 101, 120, 99, 108, 117, 115,
                 105, 118, 101, 26, 202, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108,
                 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60,
                 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 32, 38, 38, 32, 40, 116, 104,
                 105, 115, 46, 105, 115, 78, 97, 110, 40, 41, 32, 124, 124, 32, 40, 114, 117, 108,
                 101, 115, 46, 108, 116, 101, 32, 60, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116,
                 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 41,
                 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101,
                 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116,
                 111, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110,
                 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44,
                 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "in",
          extendee: nil,
          number: 6,
          label: :LABEL_REPEATED,
          type: :TYPE_FLOAT,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 104, 10, 8, 102, 108, 111, 97, 116, 46, 105, 110, 26, 92, 33, 40, 116, 104,
                 105, 115, 32, 105, 110, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114, 117,
                 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 41, 32, 63, 32, 39, 109, 117, 115,
                 116, 32, 98, 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114,
                 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "in",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "not_in",
          extendee: nil,
          number: 7,
          label: :LABEL_REPEATED,
          type: :TYPE_FLOAT,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 91, 10, 12, 102, 108, 111, 97, 116, 46, 110, 111, 116, 95, 105, 110, 26, 75,
                 116, 104, 105, 115, 32, 105, 110, 32, 114, 117, 108, 101, 115, 46, 110, 111, 116,
                 95, 105, 110, 32, 63, 32, 39, 109, 117, 115, 116, 32, 110, 111, 116, 32, 98, 101,
                 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46, 102, 111, 114, 109,
                 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 110, 111, 116, 95, 105, 110, 93,
                 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "notIn",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "finite",
          extendee: nil,
          number: 8,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 90, 10, 12, 102, 108, 111, 97, 116, 46, 102, 105, 110, 105, 116, 101, 26, 74,
                 114, 117, 108, 101, 115, 46, 102, 105, 110, 105, 116, 101, 32, 63, 32, 40, 116,
                 104, 105, 115, 46, 105, 115, 78, 97, 110, 40, 41, 32, 124, 124, 32, 116, 104,
                 105, 115, 46, 105, 115, 73, 110, 102, 40, 41, 32, 63, 32, 39, 109, 117, 115, 116,
                 32, 98, 101, 32, 102, 105, 110, 105, 116, 101, 39, 32, 58, 32, 39, 39, 41, 32,
                 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "finite",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "example",
          extendee: nil,
          number: 9,
          label: :LABEL_REPEATED,
          type: :TYPE_FLOAT,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 21, 10, 13, 102, 108, 111, 97, 116, 46, 101, 120, 97, 109, 112, 108, 101, 26,
                 4, 116, 114, 117, 101>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "example",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [
        %Google.Protobuf.DescriptorProto.ExtensionRange{
          start: 1000,
          end: 536_870_912,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      extension: [],
      options: nil,
      oneof_decl: [
        %Google.Protobuf.OneofDescriptorProto{
          name: "less_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.OneofDescriptorProto{
          name: "greater_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  oneof(:less_than, 0)

  oneof(:greater_than, 1)

  field(:const, 1, optional: true, type: :float, deprecated: false)
  field(:lt, 2, optional: true, type: :float, oneof: 0, deprecated: false)
  field(:lte, 3, optional: true, type: :float, oneof: 0, deprecated: false)
  field(:gt, 4, optional: true, type: :float, oneof: 1, deprecated: false)
  field(:gte, 5, optional: true, type: :float, oneof: 1, deprecated: false)
  field(:in, 6, repeated: true, type: :float, deprecated: false)
  field(:not_in, 7, repeated: true, type: :float, json_name: "notIn", deprecated: false)
  field(:finite, 8, optional: true, type: :bool, deprecated: false)
  field(:example, 9, repeated: true, type: :float, deprecated: false)

  extensions([{1000, Protobuf.Extension.max()}])
end

defmodule Buf.Validate.DoubleRules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.DoubleRules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "DoubleRules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "const",
          extendee: nil,
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_DOUBLE,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 106, 10, 12, 100, 111, 117, 98, 108, 101, 46, 99, 111, 110, 115, 116, 26, 90,
                 116, 104, 105, 115, 32, 33, 61, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40,
                 114, 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 32, 63, 32,
                 39, 109, 117, 115, 116, 32, 101, 113, 117, 97, 108, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114,
                 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 93, 41, 32, 58,
                 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "const",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lt",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_DOUBLE,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 132, 1, 10, 9, 100, 111, 117, 98, 108, 101, 46, 108, 116, 26, 119, 33, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38, 32, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38, 32, 40,
                 116, 104, 105, 115, 46, 105, 115, 78, 97, 110, 40, 41, 32, 124, 124, 32, 116,
                 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108, 116, 41, 63, 32,
                 39, 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116, 104, 97,
                 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lte",
          extendee: nil,
          number: 3,
          label: :LABEL_OPTIONAL,
          type: :TYPE_DOUBLE,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 147, 1, 10, 10, 100, 111, 117, 98, 108, 101, 46, 108, 116, 101, 26, 132, 1,
                 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38,
                 32, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38,
                 32, 40, 116, 104, 105, 115, 46, 105, 115, 78, 97, 110, 40, 41, 32, 124, 124, 32,
                 116, 104, 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41,
                 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116,
                 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37,
                 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46,
                 108, 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gt",
          extendee: nil,
          number: 4,
          label: :LABEL_OPTIONAL,
          type: :TYPE_DOUBLE,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 135, 1, 10, 9, 100, 111, 117, 98, 108, 101, 46, 103, 116, 26, 122, 33, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 33, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 40,
                 116, 104, 105, 115, 46, 105, 115, 78, 97, 110, 40, 41, 32, 124, 124, 32, 116,
                 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32,
                 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32,
                 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114,
                 117, 108, 101, 115, 46, 103, 116, 93, 41, 32, 58, 32, 39, 39, 10, 190, 1, 10, 12,
                 100, 111, 117, 98, 108, 101, 46, 103, 116, 95, 108, 116, 26, 173, 1, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 32, 38, 38, 32, 40, 116, 104, 105, 115, 46, 105, 115, 78, 97, 110, 40, 41,
                 32, 124, 124, 32, 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115,
                 46, 108, 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117,
                 108, 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32,
                 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 97,
                 110, 100, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46,
                 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44,
                 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 200,
                 1, 10, 22, 100, 111, 117, 98, 108, 101, 46, 103, 116, 95, 108, 116, 95, 101, 120,
                 99, 108, 117, 115, 105, 118, 101, 26, 173, 1, 104, 97, 115, 40, 114, 117, 108,
                 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 116,
                 104, 105, 115, 46, 105, 115, 78, 97, 110, 40, 41, 32, 124, 124, 32, 40, 114, 117,
                 108, 101, 115, 46, 108, 116, 32, 60, 61, 32, 116, 104, 105, 115, 32, 38, 38, 32,
                 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41,
                 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101,
                 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115,
                 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91,
                 114, 117, 108, 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 93, 41, 32, 58, 32, 39, 39, 10, 206, 1, 10, 13, 100, 111, 117, 98, 108, 101,
                 46, 103, 116, 95, 108, 116, 101, 26, 188, 1, 104, 97, 115, 40, 114, 117, 108,
                 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46,
                 108, 116, 101, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 32, 38, 38,
                 32, 40, 116, 104, 105, 115, 46, 105, 115, 78, 97, 110, 40, 41, 32, 124, 124, 32,
                 116, 104, 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32,
                 124, 124, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46,
                 103, 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97,
                 116, 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 97, 110, 100, 32, 108,
                 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108,
                 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101,
                 93, 41, 32, 58, 32, 39, 39, 10, 216, 1, 10, 23, 100, 111, 117, 98, 108, 101, 46,
                 103, 116, 95, 108, 116, 101, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26,
                 188, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38,
                 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 114, 117, 108,
                 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 116, 104, 105, 115, 46, 105, 115, 78,
                 97, 110, 40, 41, 32, 124, 124, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116,
                 101, 32, 60, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60,
                 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 41, 63, 32, 39, 109, 117, 115,
                 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110,
                 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32,
                 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32,
                 114, 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gte",
          extendee: nil,
          number: 5,
          label: :LABEL_OPTIONAL,
          type: :TYPE_DOUBLE,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 150, 1, 10, 10, 100, 111, 117, 98, 108, 101, 46, 103, 116, 101, 26, 135, 1,
                 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32,
                 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38,
                 32, 40, 116, 104, 105, 115, 46, 105, 115, 78, 97, 110, 40, 41, 32, 124, 124, 32,
                 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41,
                 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101,
                 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116,
                 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 103, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 205, 1, 10, 13, 100,
                 111, 117, 98, 108, 101, 46, 103, 116, 101, 95, 108, 116, 26, 187, 1, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 101, 32, 38, 38, 32, 40, 116, 104, 105, 115, 46, 105, 115, 78, 97, 110, 40,
                 41, 32, 124, 124, 32, 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101,
                 115, 46, 108, 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117,
                 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98,
                 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114,
                 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 97, 110, 100, 32, 108,
                 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109,
                 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 215, 1, 10, 23, 100,
                 111, 117, 98, 108, 101, 46, 103, 116, 101, 95, 108, 116, 95, 101, 120, 99, 108,
                 117, 115, 105, 118, 101, 26, 187, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115,
                 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60,
                 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 32, 38, 38, 32, 40, 116, 104,
                 105, 115, 46, 105, 115, 78, 97, 110, 40, 41, 32, 124, 124, 32, 40, 114, 117, 108,
                 101, 115, 46, 108, 116, 32, 60, 61, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116,
                 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 41,
                 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101,
                 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116,
                 111, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110,
                 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101,
                 115, 46, 103, 116, 101, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41,
                 32, 58, 32, 39, 39, 10, 221, 1, 10, 14, 100, 111, 117, 98, 108, 101, 46, 103,
                 116, 101, 95, 108, 116, 101, 26, 202, 1, 104, 97, 115, 40, 114, 117, 108, 101,
                 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 101, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 32, 38, 38,
                 32, 40, 116, 104, 105, 115, 46, 105, 115, 78, 97, 110, 40, 41, 32, 124, 124, 32,
                 116, 104, 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32,
                 124, 124, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97,
                 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108,
                 32, 116, 111, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101, 115, 115, 32, 116,
                 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37,
                 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46,
                 103, 116, 101, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32,
                 58, 32, 39, 39, 10, 231, 1, 10, 24, 100, 111, 117, 98, 108, 101, 46, 103, 116,
                 101, 95, 108, 116, 101, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26, 202,
                 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38,
                 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 114, 117, 108, 101,
                 115, 46, 103, 116, 101, 32, 38, 38, 32, 40, 116, 104, 105, 115, 46, 105, 115, 78,
                 97, 110, 40, 41, 32, 124, 124, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116,
                 101, 32, 60, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60,
                 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 41, 63, 32, 39, 109, 117,
                 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97,
                 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32,
                 111, 114, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101,
                 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97,
                 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108,
                 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "in",
          extendee: nil,
          number: 6,
          label: :LABEL_REPEATED,
          type: :TYPE_DOUBLE,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 105, 10, 9, 100, 111, 117, 98, 108, 101, 46, 105, 110, 26, 92, 33, 40, 116,
                 104, 105, 115, 32, 105, 110, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114,
                 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 41, 32, 63, 32, 39, 109, 117,
                 115, 116, 32, 98, 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46,
                 102, 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40,
                 114, 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 93, 41, 32, 58, 32, 39,
                 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "in",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "not_in",
          extendee: nil,
          number: 7,
          label: :LABEL_REPEATED,
          type: :TYPE_DOUBLE,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 92, 10, 13, 100, 111, 117, 98, 108, 101, 46, 110, 111, 116, 95, 105, 110, 26,
                 75, 116, 104, 105, 115, 32, 105, 110, 32, 114, 117, 108, 101, 115, 46, 110, 111,
                 116, 95, 105, 110, 32, 63, 32, 39, 109, 117, 115, 116, 32, 110, 111, 116, 32, 98,
                 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46, 102, 111, 114,
                 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 110, 111, 116, 95, 105, 110,
                 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "notIn",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "finite",
          extendee: nil,
          number: 8,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 91, 10, 13, 100, 111, 117, 98, 108, 101, 46, 102, 105, 110, 105, 116, 101,
                 26, 74, 114, 117, 108, 101, 115, 46, 102, 105, 110, 105, 116, 101, 32, 63, 32,
                 40, 116, 104, 105, 115, 46, 105, 115, 78, 97, 110, 40, 41, 32, 124, 124, 32, 116,
                 104, 105, 115, 46, 105, 115, 73, 110, 102, 40, 41, 32, 63, 32, 39, 109, 117, 115,
                 116, 32, 98, 101, 32, 102, 105, 110, 105, 116, 101, 39, 32, 58, 32, 39, 39, 41,
                 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "finite",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "example",
          extendee: nil,
          number: 9,
          label: :LABEL_REPEATED,
          type: :TYPE_DOUBLE,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 22, 10, 14, 100, 111, 117, 98, 108, 101, 46, 101, 120, 97, 109, 112, 108,
                 101, 26, 4, 116, 114, 117, 101>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "example",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [
        %Google.Protobuf.DescriptorProto.ExtensionRange{
          start: 1000,
          end: 536_870_912,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      extension: [],
      options: nil,
      oneof_decl: [
        %Google.Protobuf.OneofDescriptorProto{
          name: "less_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.OneofDescriptorProto{
          name: "greater_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  oneof(:less_than, 0)

  oneof(:greater_than, 1)

  field(:const, 1, optional: true, type: :double, deprecated: false)
  field(:lt, 2, optional: true, type: :double, oneof: 0, deprecated: false)
  field(:lte, 3, optional: true, type: :double, oneof: 0, deprecated: false)
  field(:gt, 4, optional: true, type: :double, oneof: 1, deprecated: false)
  field(:gte, 5, optional: true, type: :double, oneof: 1, deprecated: false)
  field(:in, 6, repeated: true, type: :double, deprecated: false)
  field(:not_in, 7, repeated: true, type: :double, json_name: "notIn", deprecated: false)
  field(:finite, 8, optional: true, type: :bool, deprecated: false)
  field(:example, 9, repeated: true, type: :double, deprecated: false)

  extensions([{1000, Protobuf.Extension.max()}])
end

defmodule Buf.Validate.Int32Rules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.Int32Rules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "Int32Rules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "const",
          extendee: nil,
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_INT32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 105, 10, 11, 105, 110, 116, 51, 50, 46, 99, 111, 110, 115, 116, 26, 90, 116,
                 104, 105, 115, 32, 33, 61, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114,
                 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 32, 63, 32, 39,
                 109, 117, 115, 116, 32, 101, 113, 117, 97, 108, 32, 37, 115, 39, 46, 102, 111,
                 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114, 117,
                 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 93, 41, 32, 58, 32,
                 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "const",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lt",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_INT32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 113, 10, 8, 105, 110, 116, 51, 50, 46, 108, 116, 26, 101, 33, 104, 97, 115,
                 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38, 32, 33, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38, 32, 116, 104,
                 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108, 116, 63, 32, 39, 109,
                 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32,
                 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115,
                 46, 108, 116, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lte",
          extendee: nil,
          number: 3,
          label: :LABEL_OPTIONAL,
          type: :TYPE_INT32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 127, 10, 9, 105, 110, 116, 51, 50, 46, 108, 116, 101, 26, 114, 33, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38, 32, 33, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38, 32, 116, 104,
                 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110,
                 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 108, 116, 101, 93,
                 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gt",
          extendee: nil,
          number: 4,
          label: :LABEL_OPTIONAL,
          type: :TYPE_INT32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 116, 10, 8, 105, 110, 116, 51, 50, 46, 103, 116, 26, 104, 33, 104, 97, 115,
                 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 33, 104, 97, 115,
                 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 116, 104,
                 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 63, 32, 39, 109,
                 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104,
                 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 103, 116, 93, 41, 32, 58, 32, 39, 39, 10, 173, 1, 10, 11, 105, 110,
                 116, 51, 50, 46, 103, 116, 95, 108, 116, 26, 157, 1, 104, 97, 115, 40, 114, 117,
                 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46,
                 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 32, 38, 38, 32,
                 40, 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108, 116,
                 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115,
                 46, 103, 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101,
                 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 97, 110, 100, 32, 108,
                 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109,
                 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32, 114, 117, 108,
                 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 181, 1, 10, 21, 105, 110,
                 116, 51, 50, 46, 103, 116, 95, 108, 116, 95, 101, 120, 99, 108, 117, 115, 105,
                 118, 101, 26, 155, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116,
                 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 32, 114, 117,
                 108, 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46,
                 108, 116, 32, 60, 61, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115,
                 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117,
                 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97,
                 110, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110,
                 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101,
                 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58,
                 32, 39, 39, 10, 189, 1, 10, 12, 105, 110, 116, 51, 50, 46, 103, 116, 95, 108,
                 116, 101, 26, 172, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116,
                 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 62, 61,
                 32, 114, 117, 108, 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 116, 104, 105,
                 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 124, 124, 32,
                 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41,
                 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101,
                 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101, 115,
                 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116,
                 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 93,
                 41, 32, 58, 32, 39, 39, 10, 197, 1, 10, 22, 105, 110, 116, 51, 50, 46, 103, 116,
                 95, 108, 116, 101, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26, 170, 1,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32,
                 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 114, 117, 108, 101, 115,
                 46, 103, 116, 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32,
                 60, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 61, 32,
                 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115, 116, 32,
                 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 37,
                 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114,
                 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114,
                 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gte",
          extendee: nil,
          number: 5,
          label: :LABEL_OPTIONAL,
          type: :TYPE_INT32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 130, 1, 10, 9, 105, 110, 116, 51, 50, 46, 103, 116, 101, 26, 117, 33, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 33, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 116,
                 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 63, 32,
                 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32,
                 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32,
                 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115,
                 46, 103, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 188, 1, 10, 12, 105, 110, 116,
                 51, 50, 46, 103, 116, 101, 95, 108, 116, 26, 171, 1, 104, 97, 115, 40, 114, 117,
                 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46,
                 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 32, 38, 38,
                 32, 40, 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115,
                 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114,
                 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117,
                 97, 108, 32, 116, 111, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101, 115, 115, 32,
                 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114,
                 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 93, 41, 32, 58, 32, 39, 39, 10, 196, 1, 10, 22, 105, 110, 116, 51, 50, 46,
                 103, 116, 101, 95, 108, 116, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26,
                 169, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38,
                 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 32, 114, 117, 108, 101, 115,
                 46, 103, 116, 101, 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116, 32,
                 60, 61, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 32,
                 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116,
                 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32,
                 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 111, 114,
                 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111,
                 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32,
                 114, 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 204, 1,
                 10, 13, 105, 110, 116, 51, 50, 46, 103, 116, 101, 95, 108, 116, 101, 26, 186, 1,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32,
                 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 62, 61, 32, 114, 117, 108, 101,
                 115, 46, 103, 116, 101, 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 32, 114,
                 117, 108, 101, 115, 46, 108, 116, 101, 32, 124, 124, 32, 116, 104, 105, 115, 32,
                 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117,
                 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97,
                 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 97,
                 110, 100, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101,
                 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97,
                 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108,
                 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 212, 1, 10, 23, 105,
                 110, 116, 51, 50, 46, 103, 116, 101, 95, 108, 116, 101, 95, 101, 120, 99, 108,
                 117, 115, 105, 118, 101, 26, 184, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115,
                 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116,
                 101, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 32, 38, 38, 32, 40,
                 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 116, 104, 105, 115, 32,
                 38, 38, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97,
                 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108,
                 32, 116, 111, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104,
                 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39,
                 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116,
                 101, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39,
                 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "in",
          extendee: nil,
          number: 6,
          label: :LABEL_REPEATED,
          type: :TYPE_INT32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 104, 10, 8, 105, 110, 116, 51, 50, 46, 105, 110, 26, 92, 33, 40, 116, 104,
                 105, 115, 32, 105, 110, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114, 117,
                 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 41, 32, 63, 32, 39, 109, 117, 115,
                 116, 32, 98, 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114,
                 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "in",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "not_in",
          extendee: nil,
          number: 7,
          label: :LABEL_REPEATED,
          type: :TYPE_INT32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 91, 10, 12, 105, 110, 116, 51, 50, 46, 110, 111, 116, 95, 105, 110, 26, 75,
                 116, 104, 105, 115, 32, 105, 110, 32, 114, 117, 108, 101, 115, 46, 110, 111, 116,
                 95, 105, 110, 32, 63, 32, 39, 109, 117, 115, 116, 32, 110, 111, 116, 32, 98, 101,
                 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46, 102, 111, 114, 109,
                 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 110, 111, 116, 95, 105, 110, 93,
                 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "notIn",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "example",
          extendee: nil,
          number: 8,
          label: :LABEL_REPEATED,
          type: :TYPE_INT32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 21, 10, 13, 105, 110, 116, 51, 50, 46, 101, 120, 97, 109, 112, 108, 101, 26,
                 4, 116, 114, 117, 101>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "example",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [
        %Google.Protobuf.DescriptorProto.ExtensionRange{
          start: 1000,
          end: 536_870_912,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      extension: [],
      options: nil,
      oneof_decl: [
        %Google.Protobuf.OneofDescriptorProto{
          name: "less_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.OneofDescriptorProto{
          name: "greater_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  oneof(:less_than, 0)

  oneof(:greater_than, 1)

  field(:const, 1, optional: true, type: :int32, deprecated: false)
  field(:lt, 2, optional: true, type: :int32, oneof: 0, deprecated: false)
  field(:lte, 3, optional: true, type: :int32, oneof: 0, deprecated: false)
  field(:gt, 4, optional: true, type: :int32, oneof: 1, deprecated: false)
  field(:gte, 5, optional: true, type: :int32, oneof: 1, deprecated: false)
  field(:in, 6, repeated: true, type: :int32, deprecated: false)
  field(:not_in, 7, repeated: true, type: :int32, json_name: "notIn", deprecated: false)
  field(:example, 8, repeated: true, type: :int32, deprecated: false)

  extensions([{1000, Protobuf.Extension.max()}])
end

defmodule Buf.Validate.Int64Rules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.Int64Rules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "Int64Rules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "const",
          extendee: nil,
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_INT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 105, 10, 11, 105, 110, 116, 54, 52, 46, 99, 111, 110, 115, 116, 26, 90, 116,
                 104, 105, 115, 32, 33, 61, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114,
                 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 32, 63, 32, 39,
                 109, 117, 115, 116, 32, 101, 113, 117, 97, 108, 32, 37, 115, 39, 46, 102, 111,
                 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114, 117,
                 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 93, 41, 32, 58, 32,
                 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "const",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lt",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_INT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 113, 10, 8, 105, 110, 116, 54, 52, 46, 108, 116, 26, 101, 33, 104, 97, 115,
                 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38, 32, 33, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38, 32, 116, 104,
                 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108, 116, 63, 32, 39, 109,
                 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32,
                 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115,
                 46, 108, 116, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lte",
          extendee: nil,
          number: 3,
          label: :LABEL_OPTIONAL,
          type: :TYPE_INT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 127, 10, 9, 105, 110, 116, 54, 52, 46, 108, 116, 101, 26, 114, 33, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38, 32, 33, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38, 32, 116, 104,
                 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110,
                 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 108, 116, 101, 93,
                 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gt",
          extendee: nil,
          number: 4,
          label: :LABEL_OPTIONAL,
          type: :TYPE_INT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 116, 10, 8, 105, 110, 116, 54, 52, 46, 103, 116, 26, 104, 33, 104, 97, 115,
                 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 33, 104, 97, 115,
                 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 116, 104,
                 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 63, 32, 39, 109,
                 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104,
                 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 103, 116, 93, 41, 32, 58, 32, 39, 39, 10, 173, 1, 10, 11, 105, 110,
                 116, 54, 52, 46, 103, 116, 95, 108, 116, 26, 157, 1, 104, 97, 115, 40, 114, 117,
                 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46,
                 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 32, 38, 38, 32,
                 40, 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108, 116,
                 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115,
                 46, 103, 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101,
                 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 97, 110, 100, 32, 108,
                 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109,
                 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32, 114, 117, 108,
                 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 181, 1, 10, 21, 105, 110,
                 116, 54, 52, 46, 103, 116, 95, 108, 116, 95, 101, 120, 99, 108, 117, 115, 105,
                 118, 101, 26, 155, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116,
                 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 32, 114, 117,
                 108, 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46,
                 108, 116, 32, 60, 61, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115,
                 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117,
                 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97,
                 110, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110,
                 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101,
                 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58,
                 32, 39, 39, 10, 189, 1, 10, 12, 105, 110, 116, 54, 52, 46, 103, 116, 95, 108,
                 116, 101, 26, 172, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116,
                 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 62, 61,
                 32, 114, 117, 108, 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 116, 104, 105,
                 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 124, 124, 32,
                 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41,
                 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101,
                 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101, 115,
                 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116,
                 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 93,
                 41, 32, 58, 32, 39, 39, 10, 197, 1, 10, 22, 105, 110, 116, 54, 52, 46, 103, 116,
                 95, 108, 116, 101, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26, 170, 1,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32,
                 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 114, 117, 108, 101, 115,
                 46, 103, 116, 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32,
                 60, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 61, 32,
                 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115, 116, 32,
                 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 37,
                 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114,
                 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114,
                 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gte",
          extendee: nil,
          number: 5,
          label: :LABEL_OPTIONAL,
          type: :TYPE_INT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 130, 1, 10, 9, 105, 110, 116, 54, 52, 46, 103, 116, 101, 26, 117, 33, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 33, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 116,
                 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 63, 32,
                 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32,
                 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32,
                 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115,
                 46, 103, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 188, 1, 10, 12, 105, 110, 116,
                 54, 52, 46, 103, 116, 101, 95, 108, 116, 26, 171, 1, 104, 97, 115, 40, 114, 117,
                 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46,
                 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 32, 38, 38,
                 32, 40, 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115,
                 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114,
                 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117,
                 97, 108, 32, 116, 111, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101, 115, 115, 32,
                 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114,
                 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 93, 41, 32, 58, 32, 39, 39, 10, 196, 1, 10, 22, 105, 110, 116, 54, 52, 46,
                 103, 116, 101, 95, 108, 116, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26,
                 169, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38,
                 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 32, 114, 117, 108, 101, 115,
                 46, 103, 116, 101, 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116, 32,
                 60, 61, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 32,
                 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116,
                 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32,
                 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 111, 114,
                 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111,
                 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32,
                 114, 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 204, 1,
                 10, 13, 105, 110, 116, 54, 52, 46, 103, 116, 101, 95, 108, 116, 101, 26, 186, 1,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32,
                 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 62, 61, 32, 114, 117, 108, 101,
                 115, 46, 103, 116, 101, 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 32, 114,
                 117, 108, 101, 115, 46, 108, 116, 101, 32, 124, 124, 32, 116, 104, 105, 115, 32,
                 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117,
                 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97,
                 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 97,
                 110, 100, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101,
                 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97,
                 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108,
                 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 212, 1, 10, 23, 105,
                 110, 116, 54, 52, 46, 103, 116, 101, 95, 108, 116, 101, 95, 101, 120, 99, 108,
                 117, 115, 105, 118, 101, 26, 184, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115,
                 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116,
                 101, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 32, 38, 38, 32, 40,
                 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 116, 104, 105, 115, 32,
                 38, 38, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97,
                 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108,
                 32, 116, 111, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104,
                 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39,
                 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116,
                 101, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39,
                 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "in",
          extendee: nil,
          number: 6,
          label: :LABEL_REPEATED,
          type: :TYPE_INT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 104, 10, 8, 105, 110, 116, 54, 52, 46, 105, 110, 26, 92, 33, 40, 116, 104,
                 105, 115, 32, 105, 110, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114, 117,
                 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 41, 32, 63, 32, 39, 109, 117, 115,
                 116, 32, 98, 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114,
                 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "in",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "not_in",
          extendee: nil,
          number: 7,
          label: :LABEL_REPEATED,
          type: :TYPE_INT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 91, 10, 12, 105, 110, 116, 54, 52, 46, 110, 111, 116, 95, 105, 110, 26, 75,
                 116, 104, 105, 115, 32, 105, 110, 32, 114, 117, 108, 101, 115, 46, 110, 111, 116,
                 95, 105, 110, 32, 63, 32, 39, 109, 117, 115, 116, 32, 110, 111, 116, 32, 98, 101,
                 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46, 102, 111, 114, 109,
                 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 110, 111, 116, 95, 105, 110, 93,
                 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "notIn",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "example",
          extendee: nil,
          number: 9,
          label: :LABEL_REPEATED,
          type: :TYPE_INT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 21, 10, 13, 105, 110, 116, 54, 52, 46, 101, 120, 97, 109, 112, 108, 101, 26,
                 4, 116, 114, 117, 101>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "example",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [
        %Google.Protobuf.DescriptorProto.ExtensionRange{
          start: 1000,
          end: 536_870_912,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      extension: [],
      options: nil,
      oneof_decl: [
        %Google.Protobuf.OneofDescriptorProto{
          name: "less_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.OneofDescriptorProto{
          name: "greater_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  oneof(:less_than, 0)

  oneof(:greater_than, 1)

  field(:const, 1, optional: true, type: :int64, deprecated: false)
  field(:lt, 2, optional: true, type: :int64, oneof: 0, deprecated: false)
  field(:lte, 3, optional: true, type: :int64, oneof: 0, deprecated: false)
  field(:gt, 4, optional: true, type: :int64, oneof: 1, deprecated: false)
  field(:gte, 5, optional: true, type: :int64, oneof: 1, deprecated: false)
  field(:in, 6, repeated: true, type: :int64, deprecated: false)
  field(:not_in, 7, repeated: true, type: :int64, json_name: "notIn", deprecated: false)
  field(:example, 9, repeated: true, type: :int64, deprecated: false)

  extensions([{1000, Protobuf.Extension.max()}])
end

defmodule Buf.Validate.UInt32Rules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.UInt32Rules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "UInt32Rules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "const",
          extendee: nil,
          number: 1,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 106, 10, 12, 117, 105, 110, 116, 51, 50, 46, 99, 111, 110, 115, 116, 26, 90,
                 116, 104, 105, 115, 32, 33, 61, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40,
                 114, 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 32, 63, 32,
                 39, 109, 117, 115, 116, 32, 101, 113, 117, 97, 108, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114,
                 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 93, 41, 32, 58,
                 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "const",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lt",
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 114, 10, 9, 117, 105, 110, 116, 51, 50, 46, 108, 116, 26, 101, 33, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38, 32, 33, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38, 32, 116, 104,
                 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108, 116, 63, 32, 39, 109,
                 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32,
                 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115,
                 46, 108, 116, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lte",
          extendee: nil,
          number: 3,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 128, 1, 10, 10, 117, 105, 110, 116, 51, 50, 46, 108, 116, 101, 26, 114, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38, 32,
                 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38, 32,
                 116, 104, 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 63,
                 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116, 104,
                 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39,
                 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 108, 116,
                 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gt",
          extendee: nil,
          number: 4,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 117, 10, 9, 117, 105, 110, 116, 51, 50, 46, 103, 116, 26, 104, 33, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 33, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 116,
                 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116,
                 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 103, 116, 93, 41, 32, 58, 32, 39, 39, 10, 174, 1, 10, 12, 117,
                 105, 110, 116, 51, 50, 46, 103, 116, 95, 108, 116, 26, 157, 1, 104, 97, 115, 40,
                 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101,
                 115, 46, 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 32, 38,
                 38, 32, 40, 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101,
                 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114,
                 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 97, 110, 100, 32,
                 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114,
                 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 182, 1, 10, 22, 117,
                 105, 110, 116, 51, 50, 46, 103, 116, 95, 108, 116, 95, 101, 120, 99, 108, 117,
                 115, 105, 118, 101, 26, 155, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46,
                 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 32,
                 114, 117, 108, 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 114, 117, 108, 101,
                 115, 46, 108, 116, 32, 60, 61, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104,
                 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116,
                 104, 97, 110, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104,
                 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41,
                 32, 58, 32, 39, 39, 10, 190, 1, 10, 13, 117, 105, 110, 116, 51, 50, 46, 103, 116,
                 95, 108, 116, 101, 26, 172, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46,
                 108, 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101,
                 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 116,
                 104, 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 124,
                 124, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116,
                 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101,
                 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32,
                 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101,
                 93, 41, 32, 58, 32, 39, 39, 10, 198, 1, 10, 23, 117, 105, 110, 116, 51, 50, 46,
                 103, 116, 95, 108, 116, 101, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26,
                 170, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38,
                 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 114, 117, 108,
                 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108,
                 116, 101, 32, 60, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32,
                 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115,
                 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110,
                 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32,
                 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32,
                 114, 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gte",
          extendee: nil,
          number: 5,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 131, 1, 10, 10, 117, 105, 110, 116, 51, 50, 46, 103, 116, 101, 26, 117, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32,
                 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 63,
                 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114,
                 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111,
                 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101,
                 115, 46, 103, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 189, 1, 10, 13, 117, 105,
                 110, 116, 51, 50, 46, 103, 116, 101, 95, 108, 116, 26, 171, 1, 104, 97, 115, 40,
                 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101,
                 115, 46, 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101,
                 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115,
                 46, 108, 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108,
                 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32,
                 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101,
                 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101,
                 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97,
                 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108,
                 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 197, 1, 10, 23, 117, 105,
                 110, 116, 51, 50, 46, 103, 116, 101, 95, 108, 116, 95, 101, 120, 99, 108, 117,
                 115, 105, 118, 101, 26, 169, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46,
                 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 32,
                 114, 117, 108, 101, 115, 46, 103, 116, 101, 32, 38, 38, 32, 40, 114, 117, 108,
                 101, 115, 46, 108, 116, 32, 60, 61, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116,
                 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 63,
                 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114,
                 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111,
                 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37,
                 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46,
                 103, 116, 101, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32,
                 39, 39, 10, 205, 1, 10, 14, 117, 105, 110, 116, 51, 50, 46, 103, 116, 101, 95,
                 108, 116, 101, 26, 186, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108,
                 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 62,
                 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 32, 38, 38, 32, 40, 116, 104,
                 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 124, 124,
                 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101,
                 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101,
                 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116,
                 111, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101, 115, 115, 32, 116, 104, 97,
                 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46,
                 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101,
                 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39,
                 10, 213, 1, 10, 24, 117, 105, 110, 116, 51, 50, 46, 103, 116, 101, 95, 108, 116,
                 101, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26, 184, 1, 104, 97, 115,
                 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 101, 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60,
                 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117,
                 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98,
                 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114,
                 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 111, 114, 32, 108,
                 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108,
                 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116,
                 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "in",
          extendee: nil,
          number: 6,
          label: :LABEL_REPEATED,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 105, 10, 9, 117, 105, 110, 116, 51, 50, 46, 105, 110, 26, 92, 33, 40, 116,
                 104, 105, 115, 32, 105, 110, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114,
                 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 41, 32, 63, 32, 39, 109, 117,
                 115, 116, 32, 98, 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46,
                 102, 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40,
                 114, 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 93, 41, 32, 58, 32, 39,
                 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "in",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "not_in",
          extendee: nil,
          number: 7,
          label: :LABEL_REPEATED,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 92, 10, 13, 117, 105, 110, 116, 51, 50, 46, 110, 111, 116, 95, 105, 110, 26,
                 75, 116, 104, 105, 115, 32, 105, 110, 32, 114, 117, 108, 101, 115, 46, 110, 111,
                 116, 95, 105, 110, 32, 63, 32, 39, 109, 117, 115, 116, 32, 110, 111, 116, 32, 98,
                 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46, 102, 111, 114,
                 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 110, 111, 116, 95, 105, 110,
                 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "notIn",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "example",
          extendee: nil,
          number: 8,
          label: :LABEL_REPEATED,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 22, 10, 14, 117, 105, 110, 116, 51, 50, 46, 101, 120, 97, 109, 112, 108, 101,
                 26, 4, 116, 114, 117, 101>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "example",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [
        %Google.Protobuf.DescriptorProto.ExtensionRange{
          start: 1000,
          end: 536_870_912,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      extension: [],
      options: nil,
      oneof_decl: [
        %Google.Protobuf.OneofDescriptorProto{
          name: "less_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.OneofDescriptorProto{
          name: "greater_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  oneof(:less_than, 0)

  oneof(:greater_than, 1)

  field(:const, 1, optional: true, type: :uint32, deprecated: false)
  field(:lt, 2, optional: true, type: :uint32, oneof: 0, deprecated: false)
  field(:lte, 3, optional: true, type: :uint32, oneof: 0, deprecated: false)
  field(:gt, 4, optional: true, type: :uint32, oneof: 1, deprecated: false)
  field(:gte, 5, optional: true, type: :uint32, oneof: 1, deprecated: false)
  field(:in, 6, repeated: true, type: :uint32, deprecated: false)
  field(:not_in, 7, repeated: true, type: :uint32, json_name: "notIn", deprecated: false)
  field(:example, 8, repeated: true, type: :uint32, deprecated: false)

  extensions([{1000, Protobuf.Extension.max()}])
end

defmodule Buf.Validate.UInt64Rules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.UInt64Rules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "UInt64Rules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "const",
          extendee: nil,
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_UINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 106, 10, 12, 117, 105, 110, 116, 54, 52, 46, 99, 111, 110, 115, 116, 26, 90,
                 116, 104, 105, 115, 32, 33, 61, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40,
                 114, 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 32, 63, 32,
                 39, 109, 117, 115, 116, 32, 101, 113, 117, 97, 108, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114,
                 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 93, 41, 32, 58,
                 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "const",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lt",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_UINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 114, 10, 9, 117, 105, 110, 116, 54, 52, 46, 108, 116, 26, 101, 33, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38, 32, 33, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38, 32, 116, 104,
                 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108, 116, 63, 32, 39, 109,
                 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32,
                 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115,
                 46, 108, 116, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lte",
          extendee: nil,
          number: 3,
          label: :LABEL_OPTIONAL,
          type: :TYPE_UINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 128, 1, 10, 10, 117, 105, 110, 116, 54, 52, 46, 108, 116, 101, 26, 114, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38, 32,
                 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38, 32,
                 116, 104, 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 63,
                 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116, 104,
                 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39,
                 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 108, 116,
                 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gt",
          extendee: nil,
          number: 4,
          label: :LABEL_OPTIONAL,
          type: :TYPE_UINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 117, 10, 9, 117, 105, 110, 116, 54, 52, 46, 103, 116, 26, 104, 33, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 33, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 116,
                 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116,
                 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 103, 116, 93, 41, 32, 58, 32, 39, 39, 10, 174, 1, 10, 12, 117,
                 105, 110, 116, 54, 52, 46, 103, 116, 95, 108, 116, 26, 157, 1, 104, 97, 115, 40,
                 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101,
                 115, 46, 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 32, 38,
                 38, 32, 40, 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101,
                 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114,
                 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 97, 110, 100, 32,
                 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114,
                 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 182, 1, 10, 22, 117,
                 105, 110, 116, 54, 52, 46, 103, 116, 95, 108, 116, 95, 101, 120, 99, 108, 117,
                 115, 105, 118, 101, 26, 155, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46,
                 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 32,
                 114, 117, 108, 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 114, 117, 108, 101,
                 115, 46, 108, 116, 32, 60, 61, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104,
                 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116,
                 104, 97, 110, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104,
                 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41,
                 32, 58, 32, 39, 39, 10, 190, 1, 10, 13, 117, 105, 110, 116, 54, 52, 46, 103, 116,
                 95, 108, 116, 101, 26, 172, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46,
                 108, 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101,
                 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 116,
                 104, 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 124,
                 124, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116,
                 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101,
                 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32,
                 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101,
                 93, 41, 32, 58, 32, 39, 39, 10, 198, 1, 10, 23, 117, 105, 110, 116, 54, 52, 46,
                 103, 116, 95, 108, 116, 101, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26,
                 170, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38,
                 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 114, 117, 108,
                 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108,
                 116, 101, 32, 60, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32,
                 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115,
                 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110,
                 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32,
                 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32,
                 114, 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gte",
          extendee: nil,
          number: 5,
          label: :LABEL_OPTIONAL,
          type: :TYPE_UINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 131, 1, 10, 10, 117, 105, 110, 116, 54, 52, 46, 103, 116, 101, 26, 117, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32,
                 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 63,
                 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114,
                 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111,
                 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101,
                 115, 46, 103, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 189, 1, 10, 13, 117, 105,
                 110, 116, 54, 52, 46, 103, 116, 101, 95, 108, 116, 26, 171, 1, 104, 97, 115, 40,
                 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101,
                 115, 46, 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101,
                 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115,
                 46, 108, 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108,
                 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32,
                 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101,
                 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101,
                 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97,
                 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108,
                 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 197, 1, 10, 23, 117, 105,
                 110, 116, 54, 52, 46, 103, 116, 101, 95, 108, 116, 95, 101, 120, 99, 108, 117,
                 115, 105, 118, 101, 26, 169, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46,
                 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 32,
                 114, 117, 108, 101, 115, 46, 103, 116, 101, 32, 38, 38, 32, 40, 114, 117, 108,
                 101, 115, 46, 108, 116, 32, 60, 61, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116,
                 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 63,
                 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114,
                 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111,
                 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37,
                 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46,
                 103, 116, 101, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32,
                 39, 39, 10, 205, 1, 10, 14, 117, 105, 110, 116, 54, 52, 46, 103, 116, 101, 95,
                 108, 116, 101, 26, 186, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108,
                 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 62,
                 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 32, 38, 38, 32, 40, 116, 104,
                 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 124, 124,
                 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101,
                 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101,
                 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116,
                 111, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101, 115, 115, 32, 116, 104, 97,
                 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46,
                 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101,
                 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39,
                 10, 213, 1, 10, 24, 117, 105, 110, 116, 54, 52, 46, 103, 116, 101, 95, 108, 116,
                 101, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26, 184, 1, 104, 97, 115,
                 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 101, 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60,
                 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117,
                 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98,
                 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114,
                 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 111, 114, 32, 108,
                 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108,
                 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116,
                 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "in",
          extendee: nil,
          number: 6,
          label: :LABEL_REPEATED,
          type: :TYPE_UINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 105, 10, 9, 117, 105, 110, 116, 54, 52, 46, 105, 110, 26, 92, 33, 40, 116,
                 104, 105, 115, 32, 105, 110, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114,
                 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 41, 32, 63, 32, 39, 109, 117,
                 115, 116, 32, 98, 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46,
                 102, 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40,
                 114, 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 93, 41, 32, 58, 32, 39,
                 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "in",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "not_in",
          extendee: nil,
          number: 7,
          label: :LABEL_REPEATED,
          type: :TYPE_UINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 92, 10, 13, 117, 105, 110, 116, 54, 52, 46, 110, 111, 116, 95, 105, 110, 26,
                 75, 116, 104, 105, 115, 32, 105, 110, 32, 114, 117, 108, 101, 115, 46, 110, 111,
                 116, 95, 105, 110, 32, 63, 32, 39, 109, 117, 115, 116, 32, 110, 111, 116, 32, 98,
                 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46, 102, 111, 114,
                 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 110, 111, 116, 95, 105, 110,
                 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "notIn",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "example",
          extendee: nil,
          number: 8,
          label: :LABEL_REPEATED,
          type: :TYPE_UINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 22, 10, 14, 117, 105, 110, 116, 54, 52, 46, 101, 120, 97, 109, 112, 108, 101,
                 26, 4, 116, 114, 117, 101>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "example",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [
        %Google.Protobuf.DescriptorProto.ExtensionRange{
          start: 1000,
          end: 536_870_912,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      extension: [],
      options: nil,
      oneof_decl: [
        %Google.Protobuf.OneofDescriptorProto{
          name: "less_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.OneofDescriptorProto{
          name: "greater_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  oneof(:less_than, 0)

  oneof(:greater_than, 1)

  field(:const, 1, optional: true, type: :uint64, deprecated: false)
  field(:lt, 2, optional: true, type: :uint64, oneof: 0, deprecated: false)
  field(:lte, 3, optional: true, type: :uint64, oneof: 0, deprecated: false)
  field(:gt, 4, optional: true, type: :uint64, oneof: 1, deprecated: false)
  field(:gte, 5, optional: true, type: :uint64, oneof: 1, deprecated: false)
  field(:in, 6, repeated: true, type: :uint64, deprecated: false)
  field(:not_in, 7, repeated: true, type: :uint64, json_name: "notIn", deprecated: false)
  field(:example, 8, repeated: true, type: :uint64, deprecated: false)

  extensions([{1000, Protobuf.Extension.max()}])
end

defmodule Buf.Validate.SInt32Rules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.SInt32Rules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "SInt32Rules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "const",
          extendee: nil,
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_SINT32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 106, 10, 12, 115, 105, 110, 116, 51, 50, 46, 99, 111, 110, 115, 116, 26, 90,
                 116, 104, 105, 115, 32, 33, 61, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40,
                 114, 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 32, 63, 32,
                 39, 109, 117, 115, 116, 32, 101, 113, 117, 97, 108, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114,
                 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 93, 41, 32, 58,
                 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "const",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lt",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_SINT32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 114, 10, 9, 115, 105, 110, 116, 51, 50, 46, 108, 116, 26, 101, 33, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38, 32, 33, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38, 32, 116, 104,
                 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108, 116, 63, 32, 39, 109,
                 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32,
                 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115,
                 46, 108, 116, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lte",
          extendee: nil,
          number: 3,
          label: :LABEL_OPTIONAL,
          type: :TYPE_SINT32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 128, 1, 10, 10, 115, 105, 110, 116, 51, 50, 46, 108, 116, 101, 26, 114, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38, 32,
                 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38, 32,
                 116, 104, 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 63,
                 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116, 104,
                 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39,
                 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 108, 116,
                 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gt",
          extendee: nil,
          number: 4,
          label: :LABEL_OPTIONAL,
          type: :TYPE_SINT32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 117, 10, 9, 115, 105, 110, 116, 51, 50, 46, 103, 116, 26, 104, 33, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 33, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 116,
                 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116,
                 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 103, 116, 93, 41, 32, 58, 32, 39, 39, 10, 174, 1, 10, 12, 115,
                 105, 110, 116, 51, 50, 46, 103, 116, 95, 108, 116, 26, 157, 1, 104, 97, 115, 40,
                 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101,
                 115, 46, 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 32, 38,
                 38, 32, 40, 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101,
                 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114,
                 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 97, 110, 100, 32,
                 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114,
                 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 182, 1, 10, 22, 115,
                 105, 110, 116, 51, 50, 46, 103, 116, 95, 108, 116, 95, 101, 120, 99, 108, 117,
                 115, 105, 118, 101, 26, 155, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46,
                 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 32,
                 114, 117, 108, 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 114, 117, 108, 101,
                 115, 46, 108, 116, 32, 60, 61, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104,
                 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116,
                 104, 97, 110, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104,
                 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41,
                 32, 58, 32, 39, 39, 10, 190, 1, 10, 13, 115, 105, 110, 116, 51, 50, 46, 103, 116,
                 95, 108, 116, 101, 26, 172, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46,
                 108, 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101,
                 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 116,
                 104, 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 124,
                 124, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116,
                 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101,
                 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32,
                 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101,
                 93, 41, 32, 58, 32, 39, 39, 10, 198, 1, 10, 23, 115, 105, 110, 116, 51, 50, 46,
                 103, 116, 95, 108, 116, 101, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26,
                 170, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38,
                 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 114, 117, 108,
                 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108,
                 116, 101, 32, 60, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32,
                 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115,
                 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110,
                 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32,
                 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32,
                 114, 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gte",
          extendee: nil,
          number: 5,
          label: :LABEL_OPTIONAL,
          type: :TYPE_SINT32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 131, 1, 10, 10, 115, 105, 110, 116, 51, 50, 46, 103, 116, 101, 26, 117, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32,
                 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 63,
                 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114,
                 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111,
                 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101,
                 115, 46, 103, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 189, 1, 10, 13, 115, 105,
                 110, 116, 51, 50, 46, 103, 116, 101, 95, 108, 116, 26, 171, 1, 104, 97, 115, 40,
                 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101,
                 115, 46, 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101,
                 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115,
                 46, 108, 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108,
                 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32,
                 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101,
                 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101,
                 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97,
                 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108,
                 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 197, 1, 10, 23, 115, 105,
                 110, 116, 51, 50, 46, 103, 116, 101, 95, 108, 116, 95, 101, 120, 99, 108, 117,
                 115, 105, 118, 101, 26, 169, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46,
                 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 32,
                 114, 117, 108, 101, 115, 46, 103, 116, 101, 32, 38, 38, 32, 40, 114, 117, 108,
                 101, 115, 46, 108, 116, 32, 60, 61, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116,
                 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 63,
                 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114,
                 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111,
                 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37,
                 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46,
                 103, 116, 101, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32,
                 39, 39, 10, 205, 1, 10, 14, 115, 105, 110, 116, 51, 50, 46, 103, 116, 101, 95,
                 108, 116, 101, 26, 186, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108,
                 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 62,
                 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 32, 38, 38, 32, 40, 116, 104,
                 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 124, 124,
                 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101,
                 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101,
                 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116,
                 111, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101, 115, 115, 32, 116, 104, 97,
                 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46,
                 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101,
                 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39,
                 10, 213, 1, 10, 24, 115, 105, 110, 116, 51, 50, 46, 103, 116, 101, 95, 108, 116,
                 101, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26, 184, 1, 104, 97, 115,
                 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 101, 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60,
                 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117,
                 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98,
                 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114,
                 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 111, 114, 32, 108,
                 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108,
                 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116,
                 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "in",
          extendee: nil,
          number: 6,
          label: :LABEL_REPEATED,
          type: :TYPE_SINT32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 105, 10, 9, 115, 105, 110, 116, 51, 50, 46, 105, 110, 26, 92, 33, 40, 116,
                 104, 105, 115, 32, 105, 110, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114,
                 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 41, 32, 63, 32, 39, 109, 117,
                 115, 116, 32, 98, 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46,
                 102, 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40,
                 114, 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 93, 41, 32, 58, 32, 39,
                 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "in",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "not_in",
          extendee: nil,
          number: 7,
          label: :LABEL_REPEATED,
          type: :TYPE_SINT32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 92, 10, 13, 115, 105, 110, 116, 51, 50, 46, 110, 111, 116, 95, 105, 110, 26,
                 75, 116, 104, 105, 115, 32, 105, 110, 32, 114, 117, 108, 101, 115, 46, 110, 111,
                 116, 95, 105, 110, 32, 63, 32, 39, 109, 117, 115, 116, 32, 110, 111, 116, 32, 98,
                 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46, 102, 111, 114,
                 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 110, 111, 116, 95, 105, 110,
                 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "notIn",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "example",
          extendee: nil,
          number: 8,
          label: :LABEL_REPEATED,
          type: :TYPE_SINT32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 22, 10, 14, 115, 105, 110, 116, 51, 50, 46, 101, 120, 97, 109, 112, 108, 101,
                 26, 4, 116, 114, 117, 101>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "example",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [
        %Google.Protobuf.DescriptorProto.ExtensionRange{
          start: 1000,
          end: 536_870_912,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      extension: [],
      options: nil,
      oneof_decl: [
        %Google.Protobuf.OneofDescriptorProto{
          name: "less_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.OneofDescriptorProto{
          name: "greater_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  oneof(:less_than, 0)

  oneof(:greater_than, 1)

  field(:const, 1, optional: true, type: :sint32, deprecated: false)
  field(:lt, 2, optional: true, type: :sint32, oneof: 0, deprecated: false)
  field(:lte, 3, optional: true, type: :sint32, oneof: 0, deprecated: false)
  field(:gt, 4, optional: true, type: :sint32, oneof: 1, deprecated: false)
  field(:gte, 5, optional: true, type: :sint32, oneof: 1, deprecated: false)
  field(:in, 6, repeated: true, type: :sint32, deprecated: false)
  field(:not_in, 7, repeated: true, type: :sint32, json_name: "notIn", deprecated: false)
  field(:example, 8, repeated: true, type: :sint32, deprecated: false)

  extensions([{1000, Protobuf.Extension.max()}])
end

defmodule Buf.Validate.SInt64Rules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.SInt64Rules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "SInt64Rules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "const",
          extendee: nil,
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_SINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 106, 10, 12, 115, 105, 110, 116, 54, 52, 46, 99, 111, 110, 115, 116, 26, 90,
                 116, 104, 105, 115, 32, 33, 61, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40,
                 114, 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 32, 63, 32,
                 39, 109, 117, 115, 116, 32, 101, 113, 117, 97, 108, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114,
                 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 93, 41, 32, 58,
                 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "const",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lt",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_SINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 114, 10, 9, 115, 105, 110, 116, 54, 52, 46, 108, 116, 26, 101, 33, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38, 32, 33, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38, 32, 116, 104,
                 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108, 116, 63, 32, 39, 109,
                 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32,
                 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115,
                 46, 108, 116, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lte",
          extendee: nil,
          number: 3,
          label: :LABEL_OPTIONAL,
          type: :TYPE_SINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 128, 1, 10, 10, 115, 105, 110, 116, 54, 52, 46, 108, 116, 101, 26, 114, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38, 32,
                 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38, 32,
                 116, 104, 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 63,
                 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116, 104,
                 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39,
                 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 108, 116,
                 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gt",
          extendee: nil,
          number: 4,
          label: :LABEL_OPTIONAL,
          type: :TYPE_SINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 117, 10, 9, 115, 105, 110, 116, 54, 52, 46, 103, 116, 26, 104, 33, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 33, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 116,
                 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116,
                 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 103, 116, 93, 41, 32, 58, 32, 39, 39, 10, 174, 1, 10, 12, 115,
                 105, 110, 116, 54, 52, 46, 103, 116, 95, 108, 116, 26, 157, 1, 104, 97, 115, 40,
                 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101,
                 115, 46, 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 32, 38,
                 38, 32, 40, 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101,
                 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114,
                 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 97, 110, 100, 32,
                 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114,
                 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 182, 1, 10, 22, 115,
                 105, 110, 116, 54, 52, 46, 103, 116, 95, 108, 116, 95, 101, 120, 99, 108, 117,
                 115, 105, 118, 101, 26, 155, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46,
                 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 32,
                 114, 117, 108, 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 114, 117, 108, 101,
                 115, 46, 108, 116, 32, 60, 61, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104,
                 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116,
                 104, 97, 110, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104,
                 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41,
                 32, 58, 32, 39, 39, 10, 190, 1, 10, 13, 115, 105, 110, 116, 54, 52, 46, 103, 116,
                 95, 108, 116, 101, 26, 172, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46,
                 108, 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101,
                 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 116,
                 104, 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 124,
                 124, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116,
                 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101,
                 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32,
                 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101,
                 93, 41, 32, 58, 32, 39, 39, 10, 198, 1, 10, 23, 115, 105, 110, 116, 54, 52, 46,
                 103, 116, 95, 108, 116, 101, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26,
                 170, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38,
                 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 114, 117, 108,
                 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108,
                 116, 101, 32, 60, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32,
                 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115,
                 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110,
                 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32,
                 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32,
                 114, 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gte",
          extendee: nil,
          number: 5,
          label: :LABEL_OPTIONAL,
          type: :TYPE_SINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 131, 1, 10, 10, 115, 105, 110, 116, 54, 52, 46, 103, 116, 101, 26, 117, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32,
                 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 63,
                 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114,
                 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111,
                 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101,
                 115, 46, 103, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 189, 1, 10, 13, 115, 105,
                 110, 116, 54, 52, 46, 103, 116, 101, 95, 108, 116, 26, 171, 1, 104, 97, 115, 40,
                 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101,
                 115, 46, 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101,
                 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115,
                 46, 108, 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108,
                 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32,
                 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101,
                 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101,
                 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97,
                 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108,
                 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 197, 1, 10, 23, 115, 105,
                 110, 116, 54, 52, 46, 103, 116, 101, 95, 108, 116, 95, 101, 120, 99, 108, 117,
                 115, 105, 118, 101, 26, 169, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46,
                 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 32,
                 114, 117, 108, 101, 115, 46, 103, 116, 101, 32, 38, 38, 32, 40, 114, 117, 108,
                 101, 115, 46, 108, 116, 32, 60, 61, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116,
                 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 63,
                 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114,
                 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111,
                 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37,
                 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46,
                 103, 116, 101, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32,
                 39, 39, 10, 205, 1, 10, 14, 115, 105, 110, 116, 54, 52, 46, 103, 116, 101, 95,
                 108, 116, 101, 26, 186, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108,
                 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 62,
                 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 32, 38, 38, 32, 40, 116, 104,
                 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 124, 124,
                 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101,
                 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101,
                 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116,
                 111, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101, 115, 115, 32, 116, 104, 97,
                 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46,
                 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101,
                 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39,
                 10, 213, 1, 10, 24, 115, 105, 110, 116, 54, 52, 46, 103, 116, 101, 95, 108, 116,
                 101, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26, 184, 1, 104, 97, 115,
                 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 101, 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60,
                 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117,
                 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98,
                 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114,
                 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 111, 114, 32, 108,
                 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108,
                 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116,
                 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "in",
          extendee: nil,
          number: 6,
          label: :LABEL_REPEATED,
          type: :TYPE_SINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 105, 10, 9, 115, 105, 110, 116, 54, 52, 46, 105, 110, 26, 92, 33, 40, 116,
                 104, 105, 115, 32, 105, 110, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114,
                 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 41, 32, 63, 32, 39, 109, 117,
                 115, 116, 32, 98, 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46,
                 102, 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40,
                 114, 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 93, 41, 32, 58, 32, 39,
                 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "in",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "not_in",
          extendee: nil,
          number: 7,
          label: :LABEL_REPEATED,
          type: :TYPE_SINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 92, 10, 13, 115, 105, 110, 116, 54, 52, 46, 110, 111, 116, 95, 105, 110, 26,
                 75, 116, 104, 105, 115, 32, 105, 110, 32, 114, 117, 108, 101, 115, 46, 110, 111,
                 116, 95, 105, 110, 32, 63, 32, 39, 109, 117, 115, 116, 32, 110, 111, 116, 32, 98,
                 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46, 102, 111, 114,
                 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 110, 111, 116, 95, 105, 110,
                 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "notIn",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "example",
          extendee: nil,
          number: 8,
          label: :LABEL_REPEATED,
          type: :TYPE_SINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 22, 10, 14, 115, 105, 110, 116, 54, 52, 46, 101, 120, 97, 109, 112, 108, 101,
                 26, 4, 116, 114, 117, 101>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "example",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [
        %Google.Protobuf.DescriptorProto.ExtensionRange{
          start: 1000,
          end: 536_870_912,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      extension: [],
      options: nil,
      oneof_decl: [
        %Google.Protobuf.OneofDescriptorProto{
          name: "less_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.OneofDescriptorProto{
          name: "greater_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  oneof(:less_than, 0)

  oneof(:greater_than, 1)

  field(:const, 1, optional: true, type: :sint64, deprecated: false)
  field(:lt, 2, optional: true, type: :sint64, oneof: 0, deprecated: false)
  field(:lte, 3, optional: true, type: :sint64, oneof: 0, deprecated: false)
  field(:gt, 4, optional: true, type: :sint64, oneof: 1, deprecated: false)
  field(:gte, 5, optional: true, type: :sint64, oneof: 1, deprecated: false)
  field(:in, 6, repeated: true, type: :sint64, deprecated: false)
  field(:not_in, 7, repeated: true, type: :sint64, json_name: "notIn", deprecated: false)
  field(:example, 8, repeated: true, type: :sint64, deprecated: false)

  extensions([{1000, Protobuf.Extension.max()}])
end

defmodule Buf.Validate.Fixed32Rules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.Fixed32Rules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "Fixed32Rules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "const",
          extendee: nil,
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_FIXED32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 107, 10, 13, 102, 105, 120, 101, 100, 51, 50, 46, 99, 111, 110, 115, 116, 26,
                 90, 116, 104, 105, 115, 32, 33, 61, 32, 103, 101, 116, 70, 105, 101, 108, 100,
                 40, 114, 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 32, 63,
                 32, 39, 109, 117, 115, 116, 32, 101, 113, 117, 97, 108, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114,
                 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 93, 41, 32, 58,
                 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "const",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lt",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_FIXED32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 115, 10, 10, 102, 105, 120, 101, 100, 51, 50, 46, 108, 116, 26, 101, 33, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38, 32, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38, 32, 116,
                 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108, 116, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110,
                 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101,
                 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lte",
          extendee: nil,
          number: 3,
          label: :LABEL_OPTIONAL,
          type: :TYPE_FIXED32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 129, 1, 10, 11, 102, 105, 120, 101, 100, 51, 50, 46, 108, 116, 101, 26, 114,
                 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38,
                 32, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38,
                 32, 116, 104, 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101,
                 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116,
                 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37,
                 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46,
                 108, 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gt",
          extendee: nil,
          number: 4,
          label: :LABEL_OPTIONAL,
          type: :TYPE_FIXED32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 118, 10, 10, 102, 105, 120, 101, 100, 51, 50, 46, 103, 116, 26, 104, 33, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 33, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 116,
                 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116,
                 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 103, 116, 93, 41, 32, 58, 32, 39, 39, 10, 175, 1, 10, 13, 102,
                 105, 120, 101, 100, 51, 50, 46, 103, 116, 95, 108, 116, 26, 157, 1, 104, 97, 115,
                 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108,
                 101, 115, 46, 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116,
                 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115,
                 46, 108, 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117,
                 108, 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32,
                 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 97,
                 110, 100, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46,
                 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44,
                 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 183,
                 1, 10, 23, 102, 105, 120, 101, 100, 51, 50, 46, 103, 116, 95, 108, 116, 95, 101,
                 120, 99, 108, 117, 115, 105, 118, 101, 26, 155, 1, 104, 97, 115, 40, 114, 117,
                 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46,
                 108, 116, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 32, 38, 38, 32, 40,
                 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 61, 32, 116, 104, 105, 115, 32,
                 38, 38, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116,
                 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115,
                 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40,
                 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46,
                 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 191, 1, 10, 14, 102, 105, 120, 101,
                 100, 51, 50, 46, 103, 116, 95, 108, 116, 101, 26, 172, 1, 104, 97, 115, 40, 114,
                 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101,
                 115, 46, 108, 116, 101, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116,
                 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46,
                 108, 116, 101, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117,
                 108, 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32,
                 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 97,
                 110, 100, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101,
                 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97,
                 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101,
                 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 199, 1, 10, 24, 102, 105,
                 120, 101, 100, 51, 50, 46, 103, 116, 95, 108, 116, 101, 95, 101, 120, 99, 108,
                 117, 115, 105, 118, 101, 26, 170, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115,
                 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116,
                 101, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 114,
                 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 116, 104, 105, 115, 32, 38,
                 38, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116,
                 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115,
                 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116,
                 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 93,
                 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gte",
          extendee: nil,
          number: 5,
          label: :LABEL_OPTIONAL,
          type: :TYPE_FIXED32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 132, 1, 10, 11, 102, 105, 120, 101, 100, 51, 50, 46, 103, 116, 101, 26, 117,
                 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32,
                 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38,
                 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101,
                 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101,
                 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116,
                 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 103, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 190, 1, 10, 14, 102,
                 105, 120, 101, 100, 51, 50, 46, 103, 116, 101, 95, 108, 116, 26, 171, 1, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 101, 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108,
                 101, 115, 46, 108, 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 32, 114,
                 117, 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32,
                 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 111,
                 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 97, 110, 100, 32,
                 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114,
                 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114,
                 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 198, 1, 10, 24,
                 102, 105, 120, 101, 100, 51, 50, 46, 103, 116, 101, 95, 108, 116, 95, 101, 120,
                 99, 108, 117, 115, 105, 118, 101, 26, 169, 1, 104, 97, 115, 40, 114, 117, 108,
                 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 32, 38, 38, 32, 40,
                 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 61, 32, 116, 104, 105, 115, 32,
                 38, 38, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97,
                 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108,
                 32, 116, 111, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104,
                 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 93,
                 41, 32, 58, 32, 39, 39, 10, 206, 1, 10, 15, 102, 105, 120, 101, 100, 51, 50, 46,
                 103, 116, 101, 95, 108, 116, 101, 26, 186, 1, 104, 97, 115, 40, 114, 117, 108,
                 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46,
                 108, 116, 101, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 32,
                 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 101, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101,
                 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103,
                 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113,
                 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101, 115,
                 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116,
                 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101,
                 93, 41, 32, 58, 32, 39, 39, 10, 214, 1, 10, 25, 102, 105, 120, 101, 100, 51, 50,
                 46, 103, 116, 101, 95, 108, 116, 101, 95, 101, 120, 99, 108, 117, 115, 105, 118,
                 101, 26, 184, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101,
                 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 114,
                 117, 108, 101, 115, 46, 103, 116, 101, 32, 38, 38, 32, 40, 114, 117, 108, 101,
                 115, 46, 108, 116, 101, 32, 60, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104,
                 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116,
                 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37,
                 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114,
                 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114,
                 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114,
                 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "in",
          extendee: nil,
          number: 6,
          label: :LABEL_REPEATED,
          type: :TYPE_FIXED32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 106, 10, 10, 102, 105, 120, 101, 100, 51, 50, 46, 105, 110, 26, 92, 33, 40,
                 116, 104, 105, 115, 32, 105, 110, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40,
                 114, 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 41, 32, 63, 32, 39, 109,
                 117, 115, 116, 32, 98, 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115,
                 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108,
                 100, 40, 114, 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 93, 41, 32, 58,
                 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "in",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "not_in",
          extendee: nil,
          number: 7,
          label: :LABEL_REPEATED,
          type: :TYPE_FIXED32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 93, 10, 14, 102, 105, 120, 101, 100, 51, 50, 46, 110, 111, 116, 95, 105, 110,
                 26, 75, 116, 104, 105, 115, 32, 105, 110, 32, 114, 117, 108, 101, 115, 46, 110,
                 111, 116, 95, 105, 110, 32, 63, 32, 39, 109, 117, 115, 116, 32, 110, 111, 116,
                 32, 98, 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46, 102, 111,
                 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 110, 111, 116, 95, 105,
                 110, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "notIn",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "example",
          extendee: nil,
          number: 8,
          label: :LABEL_REPEATED,
          type: :TYPE_FIXED32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 23, 10, 15, 102, 105, 120, 101, 100, 51, 50, 46, 101, 120, 97, 109, 112, 108,
                 101, 26, 4, 116, 114, 117, 101>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "example",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [
        %Google.Protobuf.DescriptorProto.ExtensionRange{
          start: 1000,
          end: 536_870_912,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      extension: [],
      options: nil,
      oneof_decl: [
        %Google.Protobuf.OneofDescriptorProto{
          name: "less_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.OneofDescriptorProto{
          name: "greater_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  oneof(:less_than, 0)

  oneof(:greater_than, 1)

  field(:const, 1, optional: true, type: :fixed32, deprecated: false)
  field(:lt, 2, optional: true, type: :fixed32, oneof: 0, deprecated: false)
  field(:lte, 3, optional: true, type: :fixed32, oneof: 0, deprecated: false)
  field(:gt, 4, optional: true, type: :fixed32, oneof: 1, deprecated: false)
  field(:gte, 5, optional: true, type: :fixed32, oneof: 1, deprecated: false)
  field(:in, 6, repeated: true, type: :fixed32, deprecated: false)
  field(:not_in, 7, repeated: true, type: :fixed32, json_name: "notIn", deprecated: false)
  field(:example, 8, repeated: true, type: :fixed32, deprecated: false)

  extensions([{1000, Protobuf.Extension.max()}])
end

defmodule Buf.Validate.Fixed64Rules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.Fixed64Rules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "Fixed64Rules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "const",
          extendee: nil,
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_FIXED64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 107, 10, 13, 102, 105, 120, 101, 100, 54, 52, 46, 99, 111, 110, 115, 116, 26,
                 90, 116, 104, 105, 115, 32, 33, 61, 32, 103, 101, 116, 70, 105, 101, 108, 100,
                 40, 114, 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 32, 63,
                 32, 39, 109, 117, 115, 116, 32, 101, 113, 117, 97, 108, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114,
                 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 93, 41, 32, 58,
                 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "const",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lt",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_FIXED64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 115, 10, 10, 102, 105, 120, 101, 100, 54, 52, 46, 108, 116, 26, 101, 33, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38, 32, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38, 32, 116,
                 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108, 116, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110,
                 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101,
                 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lte",
          extendee: nil,
          number: 3,
          label: :LABEL_OPTIONAL,
          type: :TYPE_FIXED64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 129, 1, 10, 11, 102, 105, 120, 101, 100, 54, 52, 46, 108, 116, 101, 26, 114,
                 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38,
                 32, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38,
                 32, 116, 104, 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101,
                 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116,
                 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37,
                 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46,
                 108, 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gt",
          extendee: nil,
          number: 4,
          label: :LABEL_OPTIONAL,
          type: :TYPE_FIXED64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 118, 10, 10, 102, 105, 120, 101, 100, 54, 52, 46, 103, 116, 26, 104, 33, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 33, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 116,
                 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116,
                 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 103, 116, 93, 41, 32, 58, 32, 39, 39, 10, 175, 1, 10, 13, 102,
                 105, 120, 101, 100, 54, 52, 46, 103, 116, 95, 108, 116, 26, 157, 1, 104, 97, 115,
                 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108,
                 101, 115, 46, 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116,
                 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115,
                 46, 108, 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117,
                 108, 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32,
                 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 97,
                 110, 100, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46,
                 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44,
                 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 183,
                 1, 10, 23, 102, 105, 120, 101, 100, 54, 52, 46, 103, 116, 95, 108, 116, 95, 101,
                 120, 99, 108, 117, 115, 105, 118, 101, 26, 155, 1, 104, 97, 115, 40, 114, 117,
                 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46,
                 108, 116, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 32, 38, 38, 32, 40,
                 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 61, 32, 116, 104, 105, 115, 32,
                 38, 38, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116,
                 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115,
                 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40,
                 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46,
                 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 191, 1, 10, 14, 102, 105, 120, 101,
                 100, 54, 52, 46, 103, 116, 95, 108, 116, 101, 26, 172, 1, 104, 97, 115, 40, 114,
                 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101,
                 115, 46, 108, 116, 101, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116,
                 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46,
                 108, 116, 101, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117,
                 108, 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32,
                 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 97,
                 110, 100, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101,
                 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97,
                 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101,
                 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 199, 1, 10, 24, 102, 105,
                 120, 101, 100, 54, 52, 46, 103, 116, 95, 108, 116, 101, 95, 101, 120, 99, 108,
                 117, 115, 105, 118, 101, 26, 170, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115,
                 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116,
                 101, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 114,
                 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 116, 104, 105, 115, 32, 38,
                 38, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116,
                 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115,
                 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116,
                 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 93,
                 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gte",
          extendee: nil,
          number: 5,
          label: :LABEL_OPTIONAL,
          type: :TYPE_FIXED64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 132, 1, 10, 11, 102, 105, 120, 101, 100, 54, 52, 46, 103, 116, 101, 26, 117,
                 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32,
                 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38,
                 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101,
                 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101,
                 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116,
                 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 103, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 190, 1, 10, 14, 102,
                 105, 120, 101, 100, 54, 52, 46, 103, 116, 101, 95, 108, 116, 26, 171, 1, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 101, 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108,
                 101, 115, 46, 108, 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 32, 114,
                 117, 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32,
                 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 111,
                 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 97, 110, 100, 32,
                 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114,
                 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114,
                 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 198, 1, 10, 24,
                 102, 105, 120, 101, 100, 54, 52, 46, 103, 116, 101, 95, 108, 116, 95, 101, 120,
                 99, 108, 117, 115, 105, 118, 101, 26, 169, 1, 104, 97, 115, 40, 114, 117, 108,
                 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 32, 38, 38, 32, 40,
                 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 61, 32, 116, 104, 105, 115, 32,
                 38, 38, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97,
                 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108,
                 32, 116, 111, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104,
                 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 93,
                 41, 32, 58, 32, 39, 39, 10, 206, 1, 10, 15, 102, 105, 120, 101, 100, 54, 52, 46,
                 103, 116, 101, 95, 108, 116, 101, 26, 186, 1, 104, 97, 115, 40, 114, 117, 108,
                 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46,
                 108, 116, 101, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 32,
                 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 101, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101,
                 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103,
                 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113,
                 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101, 115,
                 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116,
                 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101,
                 93, 41, 32, 58, 32, 39, 39, 10, 214, 1, 10, 25, 102, 105, 120, 101, 100, 54, 52,
                 46, 103, 116, 101, 95, 108, 116, 101, 95, 101, 120, 99, 108, 117, 115, 105, 118,
                 101, 26, 184, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101,
                 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 114,
                 117, 108, 101, 115, 46, 103, 116, 101, 32, 38, 38, 32, 40, 114, 117, 108, 101,
                 115, 46, 108, 116, 101, 32, 60, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104,
                 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116,
                 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37,
                 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114,
                 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114,
                 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114,
                 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "in",
          extendee: nil,
          number: 6,
          label: :LABEL_REPEATED,
          type: :TYPE_FIXED64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 106, 10, 10, 102, 105, 120, 101, 100, 54, 52, 46, 105, 110, 26, 92, 33, 40,
                 116, 104, 105, 115, 32, 105, 110, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40,
                 114, 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 41, 32, 63, 32, 39, 109,
                 117, 115, 116, 32, 98, 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115,
                 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108,
                 100, 40, 114, 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 93, 41, 32, 58,
                 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "in",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "not_in",
          extendee: nil,
          number: 7,
          label: :LABEL_REPEATED,
          type: :TYPE_FIXED64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 93, 10, 14, 102, 105, 120, 101, 100, 54, 52, 46, 110, 111, 116, 95, 105, 110,
                 26, 75, 116, 104, 105, 115, 32, 105, 110, 32, 114, 117, 108, 101, 115, 46, 110,
                 111, 116, 95, 105, 110, 32, 63, 32, 39, 109, 117, 115, 116, 32, 110, 111, 116,
                 32, 98, 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46, 102, 111,
                 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 110, 111, 116, 95, 105,
                 110, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "notIn",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "example",
          extendee: nil,
          number: 8,
          label: :LABEL_REPEATED,
          type: :TYPE_FIXED64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 23, 10, 15, 102, 105, 120, 101, 100, 54, 52, 46, 101, 120, 97, 109, 112, 108,
                 101, 26, 4, 116, 114, 117, 101>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "example",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [
        %Google.Protobuf.DescriptorProto.ExtensionRange{
          start: 1000,
          end: 536_870_912,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      extension: [],
      options: nil,
      oneof_decl: [
        %Google.Protobuf.OneofDescriptorProto{
          name: "less_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.OneofDescriptorProto{
          name: "greater_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  oneof(:less_than, 0)

  oneof(:greater_than, 1)

  field(:const, 1, optional: true, type: :fixed64, deprecated: false)
  field(:lt, 2, optional: true, type: :fixed64, oneof: 0, deprecated: false)
  field(:lte, 3, optional: true, type: :fixed64, oneof: 0, deprecated: false)
  field(:gt, 4, optional: true, type: :fixed64, oneof: 1, deprecated: false)
  field(:gte, 5, optional: true, type: :fixed64, oneof: 1, deprecated: false)
  field(:in, 6, repeated: true, type: :fixed64, deprecated: false)
  field(:not_in, 7, repeated: true, type: :fixed64, json_name: "notIn", deprecated: false)
  field(:example, 8, repeated: true, type: :fixed64, deprecated: false)

  extensions([{1000, Protobuf.Extension.max()}])
end

defmodule Buf.Validate.SFixed32Rules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.SFixed32Rules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "SFixed32Rules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "const",
          extendee: nil,
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_SFIXED32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 108, 10, 14, 115, 102, 105, 120, 101, 100, 51, 50, 46, 99, 111, 110, 115,
                 116, 26, 90, 116, 104, 105, 115, 32, 33, 61, 32, 103, 101, 116, 70, 105, 101,
                 108, 100, 40, 114, 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39,
                 41, 32, 63, 32, 39, 109, 117, 115, 116, 32, 101, 113, 117, 97, 108, 32, 37, 115,
                 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108,
                 100, 40, 114, 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 93,
                 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "const",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lt",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_SFIXED32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 116, 10, 11, 115, 102, 105, 120, 101, 100, 51, 50, 46, 108, 116, 26, 101, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38, 32,
                 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38, 32,
                 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108, 116, 63,
                 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116, 104,
                 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lte",
          extendee: nil,
          number: 3,
          label: :LABEL_OPTIONAL,
          type: :TYPE_SFIXED32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 130, 1, 10, 12, 115, 102, 105, 120, 101, 100, 51, 50, 46, 108, 116, 101, 26,
                 114, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32,
                 38, 38, 32, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32,
                 38, 38, 32, 116, 104, 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 101, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115,
                 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111,
                 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101,
                 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gt",
          extendee: nil,
          number: 4,
          label: :LABEL_OPTIONAL,
          type: :TYPE_SFIXED32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 119, 10, 11, 115, 102, 105, 120, 101, 100, 51, 50, 46, 103, 116, 26, 104, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32,
                 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 63,
                 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114,
                 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91,
                 114, 117, 108, 101, 115, 46, 103, 116, 93, 41, 32, 58, 32, 39, 39, 10, 176, 1,
                 10, 14, 115, 102, 105, 120, 101, 100, 51, 50, 46, 103, 116, 95, 108, 116, 26,
                 157, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38,
                 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 62, 61, 32, 114, 117, 108, 101,
                 115, 46, 103, 116, 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 61, 32, 114,
                 117, 108, 101, 115, 46, 108, 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60,
                 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115,
                 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110,
                 32, 37, 115, 32, 97, 110, 100, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32,
                 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115,
                 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32,
                 39, 39, 10, 184, 1, 10, 24, 115, 102, 105, 120, 101, 100, 51, 50, 46, 103, 116,
                 95, 108, 116, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26, 155, 1, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116,
                 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 61, 32, 116,
                 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108,
                 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103,
                 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 111, 114,
                 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111,
                 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32, 114,
                 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 192, 1, 10, 15,
                 115, 102, 105, 120, 101, 100, 51, 50, 46, 103, 116, 95, 108, 116, 101, 26, 172,
                 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38,
                 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 62, 61, 32, 114, 117, 108,
                 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 32, 114,
                 117, 108, 101, 115, 46, 108, 116, 101, 32, 124, 124, 32, 116, 104, 105, 115, 32,
                 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115,
                 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110,
                 32, 37, 115, 32, 97, 110, 100, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32,
                 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32,
                 114, 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 200,
                 1, 10, 25, 115, 102, 105, 120, 101, 100, 51, 50, 46, 103, 116, 95, 108, 116, 101,
                 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26, 170, 1, 104, 97, 115, 40,
                 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117, 108,
                 101, 115, 46, 108, 116, 101, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116,
                 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 116,
                 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108,
                 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103,
                 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 111, 114,
                 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117,
                 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91,
                 114, 117, 108, 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gte",
          extendee: nil,
          number: 5,
          label: :LABEL_OPTIONAL,
          type: :TYPE_SFIXED32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 133, 1, 10, 12, 115, 102, 105, 120, 101, 100, 51, 50, 46, 103, 116, 101, 26,
                 117, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38,
                 32, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38,
                 38, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116,
                 101, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116,
                 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32,
                 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 103, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 191, 1, 10, 15,
                 115, 102, 105, 120, 101, 100, 51, 50, 46, 103, 116, 101, 95, 108, 116, 26, 171,
                 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32,
                 114, 117, 108, 101, 115, 46, 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115,
                 46, 103, 116, 101, 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 61, 32, 114,
                 117, 108, 101, 115, 46, 108, 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60,
                 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115,
                 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110,
                 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 97, 110,
                 100, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44,
                 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 199,
                 1, 10, 25, 115, 102, 105, 120, 101, 100, 51, 50, 46, 103, 116, 101, 95, 108, 116,
                 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26, 169, 1, 104, 97, 115, 40,
                 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101,
                 115, 46, 108, 116, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 32,
                 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 61, 32, 116, 104,
                 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101,
                 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103,
                 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113,
                 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115,
                 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91,
                 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108, 101, 115, 46,
                 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 207, 1, 10, 16, 115, 102, 105, 120,
                 101, 100, 51, 50, 46, 103, 116, 101, 95, 108, 116, 101, 26, 186, 1, 104, 97, 115,
                 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 101, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46,
                 103, 116, 101, 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 32, 114, 117, 108,
                 101, 115, 46, 108, 116, 101, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 32,
                 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116,
                 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32,
                 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 97, 110,
                 100, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113,
                 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40,
                 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108, 101, 115,
                 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 215, 1, 10, 26, 115, 102, 105,
                 120, 101, 100, 51, 50, 46, 103, 116, 101, 95, 108, 116, 101, 95, 101, 120, 99,
                 108, 117, 115, 105, 118, 101, 26, 184, 1, 104, 97, 115, 40, 114, 117, 108, 101,
                 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 101, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 32, 38, 38, 32,
                 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 116, 104, 105, 115,
                 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97,
                 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108,
                 32, 116, 111, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104,
                 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39,
                 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116,
                 101, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39,
                 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "in",
          extendee: nil,
          number: 6,
          label: :LABEL_REPEATED,
          type: :TYPE_SFIXED32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 107, 10, 11, 115, 102, 105, 120, 101, 100, 51, 50, 46, 105, 110, 26, 92, 33,
                 40, 116, 104, 105, 115, 32, 105, 110, 32, 103, 101, 116, 70, 105, 101, 108, 100,
                 40, 114, 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 41, 32, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37,
                 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101,
                 108, 100, 40, 114, 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 93, 41, 32,
                 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "in",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "not_in",
          extendee: nil,
          number: 7,
          label: :LABEL_REPEATED,
          type: :TYPE_SFIXED32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 94, 10, 15, 115, 102, 105, 120, 101, 100, 51, 50, 46, 110, 111, 116, 95, 105,
                 110, 26, 75, 116, 104, 105, 115, 32, 105, 110, 32, 114, 117, 108, 101, 115, 46,
                 110, 111, 116, 95, 105, 110, 32, 63, 32, 39, 109, 117, 115, 116, 32, 110, 111,
                 116, 32, 98, 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 110, 111, 116, 95,
                 105, 110, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "notIn",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "example",
          extendee: nil,
          number: 8,
          label: :LABEL_REPEATED,
          type: :TYPE_SFIXED32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 24, 10, 16, 115, 102, 105, 120, 101, 100, 51, 50, 46, 101, 120, 97, 109, 112,
                 108, 101, 26, 4, 116, 114, 117, 101>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "example",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [
        %Google.Protobuf.DescriptorProto.ExtensionRange{
          start: 1000,
          end: 536_870_912,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      extension: [],
      options: nil,
      oneof_decl: [
        %Google.Protobuf.OneofDescriptorProto{
          name: "less_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.OneofDescriptorProto{
          name: "greater_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  oneof(:less_than, 0)

  oneof(:greater_than, 1)

  field(:const, 1, optional: true, type: :sfixed32, deprecated: false)
  field(:lt, 2, optional: true, type: :sfixed32, oneof: 0, deprecated: false)
  field(:lte, 3, optional: true, type: :sfixed32, oneof: 0, deprecated: false)
  field(:gt, 4, optional: true, type: :sfixed32, oneof: 1, deprecated: false)
  field(:gte, 5, optional: true, type: :sfixed32, oneof: 1, deprecated: false)
  field(:in, 6, repeated: true, type: :sfixed32, deprecated: false)
  field(:not_in, 7, repeated: true, type: :sfixed32, json_name: "notIn", deprecated: false)
  field(:example, 8, repeated: true, type: :sfixed32, deprecated: false)

  extensions([{1000, Protobuf.Extension.max()}])
end

defmodule Buf.Validate.SFixed64Rules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.SFixed64Rules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "SFixed64Rules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "const",
          extendee: nil,
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_SFIXED64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 108, 10, 14, 115, 102, 105, 120, 101, 100, 54, 52, 46, 99, 111, 110, 115,
                 116, 26, 90, 116, 104, 105, 115, 32, 33, 61, 32, 103, 101, 116, 70, 105, 101,
                 108, 100, 40, 114, 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39,
                 41, 32, 63, 32, 39, 109, 117, 115, 116, 32, 101, 113, 117, 97, 108, 32, 37, 115,
                 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108,
                 100, 40, 114, 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 93,
                 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "const",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lt",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_SFIXED64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 116, 10, 11, 115, 102, 105, 120, 101, 100, 54, 52, 46, 108, 116, 26, 101, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38, 32,
                 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38, 32,
                 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108, 116, 63,
                 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116, 104,
                 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lte",
          extendee: nil,
          number: 3,
          label: :LABEL_OPTIONAL,
          type: :TYPE_SFIXED64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 130, 1, 10, 12, 115, 102, 105, 120, 101, 100, 54, 52, 46, 108, 116, 101, 26,
                 114, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32,
                 38, 38, 32, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32,
                 38, 38, 32, 116, 104, 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 101, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115,
                 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111,
                 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101,
                 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gt",
          extendee: nil,
          number: 4,
          label: :LABEL_OPTIONAL,
          type: :TYPE_SFIXED64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 119, 10, 11, 115, 102, 105, 120, 101, 100, 54, 52, 46, 103, 116, 26, 104, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 33,
                 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32,
                 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 63,
                 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114,
                 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91,
                 114, 117, 108, 101, 115, 46, 103, 116, 93, 41, 32, 58, 32, 39, 39, 10, 176, 1,
                 10, 14, 115, 102, 105, 120, 101, 100, 54, 52, 46, 103, 116, 95, 108, 116, 26,
                 157, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38,
                 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 62, 61, 32, 114, 117, 108, 101,
                 115, 46, 103, 116, 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 61, 32, 114,
                 117, 108, 101, 115, 46, 108, 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60,
                 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115,
                 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110,
                 32, 37, 115, 32, 97, 110, 100, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32,
                 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115,
                 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32,
                 39, 39, 10, 184, 1, 10, 24, 115, 102, 105, 120, 101, 100, 54, 52, 46, 103, 116,
                 95, 108, 116, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26, 155, 1, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116,
                 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 61, 32, 116,
                 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108,
                 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103,
                 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 111, 114,
                 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111,
                 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32, 114,
                 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 192, 1, 10, 15,
                 115, 102, 105, 120, 101, 100, 54, 52, 46, 103, 116, 95, 108, 116, 101, 26, 172,
                 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38,
                 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 62, 61, 32, 114, 117, 108,
                 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 32, 114,
                 117, 108, 101, 115, 46, 108, 116, 101, 32, 124, 124, 32, 116, 104, 105, 115, 32,
                 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115,
                 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110,
                 32, 37, 115, 32, 97, 110, 100, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32,
                 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32,
                 114, 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 200,
                 1, 10, 25, 115, 102, 105, 120, 101, 100, 54, 52, 46, 103, 116, 95, 108, 116, 101,
                 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26, 170, 1, 104, 97, 115, 40,
                 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117, 108,
                 101, 115, 46, 108, 116, 101, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116,
                 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 116,
                 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108,
                 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103,
                 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 111, 114,
                 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117,
                 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91,
                 114, 117, 108, 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gte",
          extendee: nil,
          number: 5,
          label: :LABEL_OPTIONAL,
          type: :TYPE_SFIXED64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 133, 1, 10, 12, 115, 102, 105, 120, 101, 100, 54, 52, 46, 103, 116, 101, 26,
                 117, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38,
                 32, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38,
                 38, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116,
                 101, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116,
                 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32,
                 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 103, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 191, 1, 10, 15,
                 115, 102, 105, 120, 101, 100, 54, 52, 46, 103, 116, 101, 95, 108, 116, 26, 171,
                 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32,
                 114, 117, 108, 101, 115, 46, 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115,
                 46, 103, 116, 101, 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 61, 32, 114,
                 117, 108, 101, 115, 46, 108, 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60,
                 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115,
                 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110,
                 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 97, 110,
                 100, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44,
                 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 199,
                 1, 10, 25, 115, 102, 105, 120, 101, 100, 54, 52, 46, 103, 116, 101, 95, 108, 116,
                 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26, 169, 1, 104, 97, 115, 40,
                 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108, 101,
                 115, 46, 108, 116, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 32,
                 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 61, 32, 116, 104,
                 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101,
                 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103,
                 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113,
                 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115,
                 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91,
                 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108, 101, 115, 46,
                 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 207, 1, 10, 16, 115, 102, 105, 120,
                 101, 100, 54, 52, 46, 103, 116, 101, 95, 108, 116, 101, 26, 186, 1, 104, 97, 115,
                 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 101, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46,
                 103, 116, 101, 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 32, 114, 117, 108,
                 101, 115, 46, 108, 116, 101, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60, 32,
                 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116,
                 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32,
                 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 97, 110,
                 100, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113,
                 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40,
                 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108, 101, 115,
                 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 215, 1, 10, 26, 115, 102, 105,
                 120, 101, 100, 54, 52, 46, 103, 116, 101, 95, 108, 116, 101, 95, 101, 120, 99,
                 108, 117, 115, 105, 118, 101, 26, 184, 1, 104, 97, 115, 40, 114, 117, 108, 101,
                 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 101, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 32, 38, 38, 32,
                 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 116, 104, 105, 115,
                 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97,
                 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108,
                 32, 116, 111, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104,
                 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39,
                 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116,
                 101, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39,
                 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "in",
          extendee: nil,
          number: 6,
          label: :LABEL_REPEATED,
          type: :TYPE_SFIXED64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 107, 10, 11, 115, 102, 105, 120, 101, 100, 54, 52, 46, 105, 110, 26, 92, 33,
                 40, 116, 104, 105, 115, 32, 105, 110, 32, 103, 101, 116, 70, 105, 101, 108, 100,
                 40, 114, 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 41, 32, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37,
                 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101,
                 108, 100, 40, 114, 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 93, 41, 32,
                 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "in",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "not_in",
          extendee: nil,
          number: 7,
          label: :LABEL_REPEATED,
          type: :TYPE_SFIXED64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 94, 10, 15, 115, 102, 105, 120, 101, 100, 54, 52, 46, 110, 111, 116, 95, 105,
                 110, 26, 75, 116, 104, 105, 115, 32, 105, 110, 32, 114, 117, 108, 101, 115, 46,
                 110, 111, 116, 95, 105, 110, 32, 63, 32, 39, 109, 117, 115, 116, 32, 110, 111,
                 116, 32, 98, 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 110, 111, 116, 95,
                 105, 110, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "notIn",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "example",
          extendee: nil,
          number: 8,
          label: :LABEL_REPEATED,
          type: :TYPE_SFIXED64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 24, 10, 16, 115, 102, 105, 120, 101, 100, 54, 52, 46, 101, 120, 97, 109, 112,
                 108, 101, 26, 4, 116, 114, 117, 101>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "example",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [
        %Google.Protobuf.DescriptorProto.ExtensionRange{
          start: 1000,
          end: 536_870_912,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      extension: [],
      options: nil,
      oneof_decl: [
        %Google.Protobuf.OneofDescriptorProto{
          name: "less_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.OneofDescriptorProto{
          name: "greater_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  oneof(:less_than, 0)

  oneof(:greater_than, 1)

  field(:const, 1, optional: true, type: :sfixed64, deprecated: false)
  field(:lt, 2, optional: true, type: :sfixed64, oneof: 0, deprecated: false)
  field(:lte, 3, optional: true, type: :sfixed64, oneof: 0, deprecated: false)
  field(:gt, 4, optional: true, type: :sfixed64, oneof: 1, deprecated: false)
  field(:gte, 5, optional: true, type: :sfixed64, oneof: 1, deprecated: false)
  field(:in, 6, repeated: true, type: :sfixed64, deprecated: false)
  field(:not_in, 7, repeated: true, type: :sfixed64, json_name: "notIn", deprecated: false)
  field(:example, 8, repeated: true, type: :sfixed64, deprecated: false)

  extensions([{1000, Protobuf.Extension.max()}])
end

defmodule Buf.Validate.BoolRules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.BoolRules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "BoolRules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "const",
          extendee: nil,
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 104, 10, 10, 98, 111, 111, 108, 46, 99, 111, 110, 115, 116, 26, 90, 116, 104,
                 105, 115, 32, 33, 61, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114, 117,
                 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 32, 63, 32, 39, 109,
                 117, 115, 116, 32, 101, 113, 117, 97, 108, 32, 37, 115, 39, 46, 102, 111, 114,
                 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114, 117, 108,
                 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 93, 41, 32, 58, 32, 39,
                 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "const",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "example",
          extendee: nil,
          number: 2,
          label: :LABEL_REPEATED,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 20, 10, 12, 98, 111, 111, 108, 46, 101, 120, 97, 109, 112, 108, 101, 26, 4,
                 116, 114, 117, 101>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "example",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [
        %Google.Protobuf.DescriptorProto.ExtensionRange{
          start: 1000,
          end: 536_870_912,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      extension: [],
      options: nil,
      oneof_decl: [],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  field(:const, 1, optional: true, type: :bool, deprecated: false)
  field(:example, 2, repeated: true, type: :bool, deprecated: false)

  extensions([{1000, Protobuf.Extension.max()}])
end

defmodule Buf.Validate.StringRules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.StringRules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "StringRules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "const",
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 108, 10, 12, 115, 116, 114, 105, 110, 103, 46, 99, 111, 110, 115, 116, 26,
                 92, 116, 104, 105, 115, 32, 33, 61, 32, 103, 101, 116, 70, 105, 101, 108, 100,
                 40, 114, 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 32, 63,
                 32, 39, 109, 117, 115, 116, 32, 101, 113, 117, 97, 108, 32, 96, 37, 115, 96, 39,
                 46, 102, 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100,
                 40, 114, 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 93, 41,
                 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "const",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "len",
          extendee: nil,
          number: 19,
          label: :LABEL_OPTIONAL,
          type: :TYPE_UINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 95, 10, 10, 115, 116, 114, 105, 110, 103, 46, 108, 101, 110, 26, 81, 117,
                 105, 110, 116, 40, 116, 104, 105, 115, 46, 115, 105, 122, 101, 40, 41, 41, 32,
                 33, 61, 32, 114, 117, 108, 101, 115, 46, 108, 101, 110, 32, 63, 32, 39, 109, 117,
                 115, 116, 32, 98, 101, 32, 37, 115, 32, 99, 104, 97, 114, 97, 99, 116, 101, 114,
                 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46,
                 108, 101, 110, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "len",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "min_len",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_UINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 115, 10, 14, 115, 116, 114, 105, 110, 103, 46, 109, 105, 110, 95, 108, 101,
                 110, 26, 97, 117, 105, 110, 116, 40, 116, 104, 105, 115, 46, 115, 105, 122, 101,
                 40, 41, 41, 32, 60, 32, 114, 117, 108, 101, 115, 46, 109, 105, 110, 95, 108, 101,
                 110, 32, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 97, 116, 32, 108, 101,
                 97, 115, 116, 32, 37, 115, 32, 99, 104, 97, 114, 97, 99, 116, 101, 114, 115, 39,
                 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 109, 105,
                 110, 95, 108, 101, 110, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "minLen",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "max_len",
          extendee: nil,
          number: 3,
          label: :LABEL_OPTIONAL,
          type: :TYPE_UINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 114, 10, 14, 115, 116, 114, 105, 110, 103, 46, 109, 97, 120, 95, 108, 101,
                 110, 26, 96, 117, 105, 110, 116, 40, 116, 104, 105, 115, 46, 115, 105, 122, 101,
                 40, 41, 41, 32, 62, 32, 114, 117, 108, 101, 115, 46, 109, 97, 120, 95, 108, 101,
                 110, 32, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 97, 116, 32, 109, 111,
                 115, 116, 32, 37, 115, 32, 99, 104, 97, 114, 97, 99, 116, 101, 114, 115, 39, 46,
                 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 109, 97, 120,
                 95, 108, 101, 110, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "maxLen",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "len_bytes",
          extendee: nil,
          number: 20,
          label: :LABEL_OPTIONAL,
          type: :TYPE_UINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 115, 10, 16, 115, 116, 114, 105, 110, 103, 46, 108, 101, 110, 95, 98, 121,
                 116, 101, 115, 26, 95, 117, 105, 110, 116, 40, 98, 121, 116, 101, 115, 40, 116,
                 104, 105, 115, 41, 46, 115, 105, 122, 101, 40, 41, 41, 32, 33, 61, 32, 114, 117,
                 108, 101, 115, 46, 108, 101, 110, 95, 98, 121, 116, 101, 115, 32, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 37, 115, 32, 98, 121, 116, 101, 115, 39, 46,
                 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 108, 101, 110,
                 95, 98, 121, 116, 101, 115, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "lenBytes",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "min_bytes",
          extendee: nil,
          number: 4,
          label: :LABEL_OPTIONAL,
          type: :TYPE_UINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 123, 10, 16, 115, 116, 114, 105, 110, 103, 46, 109, 105, 110, 95, 98, 121,
                 116, 101, 115, 26, 103, 117, 105, 110, 116, 40, 98, 121, 116, 101, 115, 40, 116,
                 104, 105, 115, 41, 46, 115, 105, 122, 101, 40, 41, 41, 32, 60, 32, 114, 117, 108,
                 101, 115, 46, 109, 105, 110, 95, 98, 121, 116, 101, 115, 32, 63, 32, 39, 109,
                 117, 115, 116, 32, 98, 101, 32, 97, 116, 32, 108, 101, 97, 115, 116, 32, 37, 115,
                 32, 98, 121, 116, 101, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114,
                 117, 108, 101, 115, 46, 109, 105, 110, 95, 98, 121, 116, 101, 115, 93, 41, 32,
                 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "minBytes",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "max_bytes",
          extendee: nil,
          number: 5,
          label: :LABEL_OPTIONAL,
          type: :TYPE_UINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 122, 10, 16, 115, 116, 114, 105, 110, 103, 46, 109, 97, 120, 95, 98, 121,
                 116, 101, 115, 26, 102, 117, 105, 110, 116, 40, 98, 121, 116, 101, 115, 40, 116,
                 104, 105, 115, 41, 46, 115, 105, 122, 101, 40, 41, 41, 32, 62, 32, 114, 117, 108,
                 101, 115, 46, 109, 97, 120, 95, 98, 121, 116, 101, 115, 32, 63, 32, 39, 109, 117,
                 115, 116, 32, 98, 101, 32, 97, 116, 32, 109, 111, 115, 116, 32, 37, 115, 32, 98,
                 121, 116, 101, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 109, 97, 120, 95, 98, 121, 116, 101, 115, 93, 41, 32, 58, 32, 39,
                 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "maxBytes",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "pattern",
          extendee: nil,
          number: 6,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 113, 10, 14, 115, 116, 114, 105, 110, 103, 46, 112, 97, 116, 116, 101, 114,
                 110, 26, 95, 33, 116, 104, 105, 115, 46, 109, 97, 116, 99, 104, 101, 115, 40,
                 114, 117, 108, 101, 115, 46, 112, 97, 116, 116, 101, 114, 110, 41, 32, 63, 32,
                 39, 100, 111, 101, 115, 32, 110, 111, 116, 32, 109, 97, 116, 99, 104, 32, 114,
                 101, 103, 101, 120, 32, 112, 97, 116, 116, 101, 114, 110, 32, 96, 37, 115, 96,
                 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 112,
                 97, 116, 116, 101, 114, 110, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "pattern",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "prefix",
          extendee: nil,
          number: 7,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 105, 10, 13, 115, 116, 114, 105, 110, 103, 46, 112, 114, 101, 102, 105, 120,
                 26, 88, 33, 116, 104, 105, 115, 46, 115, 116, 97, 114, 116, 115, 87, 105, 116,
                 104, 40, 114, 117, 108, 101, 115, 46, 112, 114, 101, 102, 105, 120, 41, 32, 63,
                 32, 39, 100, 111, 101, 115, 32, 110, 111, 116, 32, 104, 97, 118, 101, 32, 112,
                 114, 101, 102, 105, 120, 32, 96, 37, 115, 96, 39, 46, 102, 111, 114, 109, 97,
                 116, 40, 91, 114, 117, 108, 101, 115, 46, 112, 114, 101, 102, 105, 120, 93, 41,
                 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "prefix",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "suffix",
          extendee: nil,
          number: 8,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 103, 10, 13, 115, 116, 114, 105, 110, 103, 46, 115, 117, 102, 102, 105, 120,
                 26, 86, 33, 116, 104, 105, 115, 46, 101, 110, 100, 115, 87, 105, 116, 104, 40,
                 114, 117, 108, 101, 115, 46, 115, 117, 102, 102, 105, 120, 41, 32, 63, 32, 39,
                 100, 111, 101, 115, 32, 110, 111, 116, 32, 104, 97, 118, 101, 32, 115, 117, 102,
                 102, 105, 120, 32, 96, 37, 115, 96, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91,
                 114, 117, 108, 101, 115, 46, 115, 117, 102, 102, 105, 120, 93, 41, 32, 58, 32,
                 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "suffix",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "contains",
          extendee: nil,
          number: 9,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 115, 10, 15, 115, 116, 114, 105, 110, 103, 46, 99, 111, 110, 116, 97, 105,
                 110, 115, 26, 96, 33, 116, 104, 105, 115, 46, 99, 111, 110, 116, 97, 105, 110,
                 115, 40, 114, 117, 108, 101, 115, 46, 99, 111, 110, 116, 97, 105, 110, 115, 41,
                 32, 63, 32, 39, 100, 111, 101, 115, 32, 110, 111, 116, 32, 99, 111, 110, 116, 97,
                 105, 110, 32, 115, 117, 98, 115, 116, 114, 105, 110, 103, 32, 96, 37, 115, 96,
                 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 99,
                 111, 110, 116, 97, 105, 110, 115, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "contains",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "not_contains",
          extendee: nil,
          number: 23,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 118, 10, 19, 115, 116, 114, 105, 110, 103, 46, 110, 111, 116, 95, 99, 111,
                 110, 116, 97, 105, 110, 115, 26, 95, 116, 104, 105, 115, 46, 99, 111, 110, 116,
                 97, 105, 110, 115, 40, 114, 117, 108, 101, 115, 46, 110, 111, 116, 95, 99, 111,
                 110, 116, 97, 105, 110, 115, 41, 32, 63, 32, 39, 99, 111, 110, 116, 97, 105, 110,
                 115, 32, 115, 117, 98, 115, 116, 114, 105, 110, 103, 32, 96, 37, 115, 96, 39, 46,
                 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 110, 111, 116,
                 95, 99, 111, 110, 116, 97, 105, 110, 115, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "notContains",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "in",
          extendee: nil,
          number: 10,
          label: :LABEL_REPEATED,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 105, 10, 9, 115, 116, 114, 105, 110, 103, 46, 105, 110, 26, 92, 33, 40, 116,
                 104, 105, 115, 32, 105, 110, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114,
                 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 41, 32, 63, 32, 39, 109, 117,
                 115, 116, 32, 98, 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46,
                 102, 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40,
                 114, 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 93, 41, 32, 58, 32, 39,
                 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "in",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "not_in",
          extendee: nil,
          number: 11,
          label: :LABEL_REPEATED,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 92, 10, 13, 115, 116, 114, 105, 110, 103, 46, 110, 111, 116, 95, 105, 110,
                 26, 75, 116, 104, 105, 115, 32, 105, 110, 32, 114, 117, 108, 101, 115, 46, 110,
                 111, 116, 95, 105, 110, 32, 63, 32, 39, 109, 117, 115, 116, 32, 110, 111, 116,
                 32, 98, 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46, 102, 111,
                 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 110, 111, 116, 95, 105,
                 110, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "notIn",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "email",
          extendee: nil,
          number: 12,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 91, 10, 12, 115, 116, 114, 105, 110, 103, 46, 101, 109, 97, 105, 108, 18, 29,
                 109, 117, 115, 116, 32, 98, 101, 32, 97, 32, 118, 97, 108, 105, 100, 32, 101,
                 109, 97, 105, 108, 32, 97, 100, 100, 114, 101, 115, 115, 26, 44, 33, 114, 117,
                 108, 101, 115, 46, 101, 109, 97, 105, 108, 32, 124, 124, 32, 116, 104, 105, 115,
                 32, 61, 61, 32, 39, 39, 32, 124, 124, 32, 116, 104, 105, 115, 46, 105, 115, 69,
                 109, 97, 105, 108, 40, 41, 10, 100, 10, 18, 115, 116, 114, 105, 110, 103, 46,
                 101, 109, 97, 105, 108, 95, 101, 109, 112, 116, 121, 18, 50, 118, 97, 108, 117,
                 101, 32, 105, 115, 32, 101, 109, 112, 116, 121, 44, 32, 119, 104, 105, 99, 104,
                 32, 105, 115, 32, 110, 111, 116, 32, 97, 32, 118, 97, 108, 105, 100, 32, 101,
                 109, 97, 105, 108, 32, 97, 100, 100, 114, 101, 115, 115, 26, 26, 33, 114, 117,
                 108, 101, 115, 46, 101, 109, 97, 105, 108, 32, 124, 124, 32, 116, 104, 105, 115,
                 32, 33, 61, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "email",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "hostname",
          extendee: nil,
          number: 13,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 95, 10, 15, 115, 116, 114, 105, 110, 103, 46, 104, 111, 115, 116, 110, 97,
                 109, 101, 18, 24, 109, 117, 115, 116, 32, 98, 101, 32, 97, 32, 118, 97, 108, 105,
                 100, 32, 104, 111, 115, 116, 110, 97, 109, 101, 26, 50, 33, 114, 117, 108, 101,
                 115, 46, 104, 111, 115, 116, 110, 97, 109, 101, 32, 124, 124, 32, 116, 104, 105,
                 115, 32, 61, 61, 32, 39, 39, 32, 124, 124, 32, 116, 104, 105, 115, 46, 105, 115,
                 72, 111, 115, 116, 110, 97, 109, 101, 40, 41, 10, 101, 10, 21, 115, 116, 114,
                 105, 110, 103, 46, 104, 111, 115, 116, 110, 97, 109, 101, 95, 101, 109, 112, 116,
                 121, 18, 45, 118, 97, 108, 117, 101, 32, 105, 115, 32, 101, 109, 112, 116, 121,
                 44, 32, 119, 104, 105, 99, 104, 32, 105, 115, 32, 110, 111, 116, 32, 97, 32, 118,
                 97, 108, 105, 100, 32, 104, 111, 115, 116, 110, 97, 109, 101, 26, 29, 33, 114,
                 117, 108, 101, 115, 46, 104, 111, 115, 116, 110, 97, 109, 101, 32, 124, 124, 32,
                 116, 104, 105, 115, 32, 33, 61, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "hostname",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "ip",
          extendee: nil,
          number: 14,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 79, 10, 9, 115, 116, 114, 105, 110, 103, 46, 105, 112, 18, 26, 109, 117, 115,
                 116, 32, 98, 101, 32, 97, 32, 118, 97, 108, 105, 100, 32, 73, 80, 32, 97, 100,
                 100, 114, 101, 115, 115, 26, 38, 33, 114, 117, 108, 101, 115, 46, 105, 112, 32,
                 124, 124, 32, 116, 104, 105, 115, 32, 61, 61, 32, 39, 39, 32, 124, 124, 32, 116,
                 104, 105, 115, 46, 105, 115, 73, 112, 40, 41, 10, 91, 10, 15, 115, 116, 114, 105,
                 110, 103, 46, 105, 112, 95, 101, 109, 112, 116, 121, 18, 47, 118, 97, 108, 117,
                 101, 32, 105, 115, 32, 101, 109, 112, 116, 121, 44, 32, 119, 104, 105, 99, 104,
                 32, 105, 115, 32, 110, 111, 116, 32, 97, 32, 118, 97, 108, 105, 100, 32, 73, 80,
                 32, 97, 100, 100, 114, 101, 115, 115, 26, 23, 33, 114, 117, 108, 101, 115, 46,
                 105, 112, 32, 124, 124, 32, 116, 104, 105, 115, 32, 33, 61, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "ip",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "ipv4",
          extendee: nil,
          number: 15,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 86, 10, 11, 115, 116, 114, 105, 110, 103, 46, 105, 112, 118, 52, 18, 28, 109,
                 117, 115, 116, 32, 98, 101, 32, 97, 32, 118, 97, 108, 105, 100, 32, 73, 80, 118,
                 52, 32, 97, 100, 100, 114, 101, 115, 115, 26, 41, 33, 114, 117, 108, 101, 115,
                 46, 105, 112, 118, 52, 32, 124, 124, 32, 116, 104, 105, 115, 32, 61, 61, 32, 39,
                 39, 32, 124, 124, 32, 116, 104, 105, 115, 46, 105, 115, 73, 112, 40, 52, 41, 10,
                 97, 10, 17, 115, 116, 114, 105, 110, 103, 46, 105, 112, 118, 52, 95, 101, 109,
                 112, 116, 121, 18, 49, 118, 97, 108, 117, 101, 32, 105, 115, 32, 101, 109, 112,
                 116, 121, 44, 32, 119, 104, 105, 99, 104, 32, 105, 115, 32, 110, 111, 116, 32,
                 97, 32, 118, 97, 108, 105, 100, 32, 73, 80, 118, 52, 32, 97, 100, 100, 114, 101,
                 115, 115, 26, 25, 33, 114, 117, 108, 101, 115, 46, 105, 112, 118, 52, 32, 124,
                 124, 32, 116, 104, 105, 115, 32, 33, 61, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "ipv4",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "ipv6",
          extendee: nil,
          number: 16,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 86, 10, 11, 115, 116, 114, 105, 110, 103, 46, 105, 112, 118, 54, 18, 28, 109,
                 117, 115, 116, 32, 98, 101, 32, 97, 32, 118, 97, 108, 105, 100, 32, 73, 80, 118,
                 54, 32, 97, 100, 100, 114, 101, 115, 115, 26, 41, 33, 114, 117, 108, 101, 115,
                 46, 105, 112, 118, 54, 32, 124, 124, 32, 116, 104, 105, 115, 32, 61, 61, 32, 39,
                 39, 32, 124, 124, 32, 116, 104, 105, 115, 46, 105, 115, 73, 112, 40, 54, 41, 10,
                 97, 10, 17, 115, 116, 114, 105, 110, 103, 46, 105, 112, 118, 54, 95, 101, 109,
                 112, 116, 121, 18, 49, 118, 97, 108, 117, 101, 32, 105, 115, 32, 101, 109, 112,
                 116, 121, 44, 32, 119, 104, 105, 99, 104, 32, 105, 115, 32, 110, 111, 116, 32,
                 97, 32, 118, 97, 108, 105, 100, 32, 73, 80, 118, 54, 32, 97, 100, 100, 114, 101,
                 115, 115, 26, 25, 33, 114, 117, 108, 101, 115, 46, 105, 112, 118, 54, 32, 124,
                 124, 32, 116, 104, 105, 115, 32, 33, 61, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "ipv6",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "uri",
          extendee: nil,
          number: 17,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 75, 10, 10, 115, 116, 114, 105, 110, 103, 46, 117, 114, 105, 18, 19, 109,
                 117, 115, 116, 32, 98, 101, 32, 97, 32, 118, 97, 108, 105, 100, 32, 85, 82, 73,
                 26, 40, 33, 114, 117, 108, 101, 115, 46, 117, 114, 105, 32, 124, 124, 32, 116,
                 104, 105, 115, 32, 61, 61, 32, 39, 39, 32, 124, 124, 32, 116, 104, 105, 115, 46,
                 105, 115, 85, 114, 105, 40, 41, 10, 86, 10, 16, 115, 116, 114, 105, 110, 103, 46,
                 117, 114, 105, 95, 101, 109, 112, 116, 121, 18, 40, 118, 97, 108, 117, 101, 32,
                 105, 115, 32, 101, 109, 112, 116, 121, 44, 32, 119, 104, 105, 99, 104, 32, 105,
                 115, 32, 110, 111, 116, 32, 97, 32, 118, 97, 108, 105, 100, 32, 85, 82, 73, 26,
                 24, 33, 114, 117, 108, 101, 115, 46, 117, 114, 105, 32, 124, 124, 32, 116, 104,
                 105, 115, 32, 33, 61, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "uri",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "uri_ref",
          extendee: nil,
          number: 18,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 82, 10, 14, 115, 116, 114, 105, 110, 103, 46, 117, 114, 105, 95, 114, 101,
                 102, 18, 29, 109, 117, 115, 116, 32, 98, 101, 32, 97, 32, 118, 97, 108, 105, 100,
                 32, 85, 82, 73, 32, 82, 101, 102, 101, 114, 101, 110, 99, 101, 26, 33, 33, 114,
                 117, 108, 101, 115, 46, 117, 114, 105, 95, 114, 101, 102, 32, 124, 124, 32, 116,
                 104, 105, 115, 46, 105, 115, 85, 114, 105, 82, 101, 102, 40, 41>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "uriRef",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "address",
          extendee: nil,
          number: 21,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 123, 10, 14, 115, 116, 114, 105, 110, 103, 46, 97, 100, 100, 114, 101, 115,
                 115, 18, 39, 109, 117, 115, 116, 32, 98, 101, 32, 97, 32, 118, 97, 108, 105, 100,
                 32, 104, 111, 115, 116, 110, 97, 109, 101, 44, 32, 111, 114, 32, 105, 112, 32,
                 97, 100, 100, 114, 101, 115, 115, 26, 64, 33, 114, 117, 108, 101, 115, 46, 97,
                 100, 100, 114, 101, 115, 115, 32, 124, 124, 32, 116, 104, 105, 115, 32, 61, 61,
                 32, 39, 39, 32, 124, 124, 32, 116, 104, 105, 115, 46, 105, 115, 72, 111, 115,
                 116, 110, 97, 109, 101, 40, 41, 32, 124, 124, 32, 116, 104, 105, 115, 46, 105,
                 115, 73, 112, 40, 41, 10, 114, 10, 20, 115, 116, 114, 105, 110, 103, 46, 97, 100,
                 100, 114, 101, 115, 115, 95, 101, 109, 112, 116, 121, 18, 60, 118, 97, 108, 117,
                 101, 32, 105, 115, 32, 101, 109, 112, 116, 121, 44, 32, 119, 104, 105, 99, 104,
                 32, 105, 115, 32, 110, 111, 116, 32, 97, 32, 118, 97, 108, 105, 100, 32, 104,
                 111, 115, 116, 110, 97, 109, 101, 44, 32, 111, 114, 32, 105, 112, 32, 97, 100,
                 100, 114, 101, 115, 115, 26, 28, 33, 114, 117, 108, 101, 115, 46, 97, 100, 100,
                 114, 101, 115, 115, 32, 124, 124, 32, 116, 104, 105, 115, 32, 33, 61, 32, 39,
                 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "address",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "uuid",
          extendee: nil,
          number: 22,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 159, 1, 10, 11, 115, 116, 114, 105, 110, 103, 46, 117, 117, 105, 100, 18, 20,
                 109, 117, 115, 116, 32, 98, 101, 32, 97, 32, 118, 97, 108, 105, 100, 32, 85, 85,
                 73, 68, 26, 122, 33, 114, 117, 108, 101, 115, 46, 117, 117, 105, 100, 32, 124,
                 124, 32, 116, 104, 105, 115, 32, 61, 61, 32, 39, 39, 32, 124, 124, 32, 116, 104,
                 105, 115, 46, 109, 97, 116, 99, 104, 101, 115, 40, 39, 94, 91, 48, 45, 57, 97,
                 45, 102, 65, 45, 70, 93, 123, 56, 125, 45, 91, 48, 45, 57, 97, 45, 102, 65, 45,
                 70, 93, 123, 52, 125, 45, 91, 48, 45, 57, 97, 45, 102, 65, 45, 70, 93, 123, 52,
                 125, 45, 91, 48, 45, 57, 97, 45, 102, 65, 45, 70, 93, 123, 52, 125, 45, 91, 48,
                 45, 57, 97, 45, 102, 65, 45, 70, 93, 123, 49, 50, 125, 36, 39, 41, 10, 89, 10,
                 17, 115, 116, 114, 105, 110, 103, 46, 117, 117, 105, 100, 95, 101, 109, 112, 116,
                 121, 18, 41, 118, 97, 108, 117, 101, 32, 105, 115, 32, 101, 109, 112, 116, 121,
                 44, 32, 119, 104, 105, 99, 104, 32, 105, 115, 32, 110, 111, 116, 32, 97, 32, 118,
                 97, 108, 105, 100, 32, 85, 85, 73, 68, 26, 25, 33, 114, 117, 108, 101, 115, 46,
                 117, 117, 105, 100, 32, 124, 124, 32, 116, 104, 105, 115, 32, 33, 61, 32, 39,
                 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "uuid",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "tuuid",
          extendee: nil,
          number: 33,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 109, 10, 12, 115, 116, 114, 105, 110, 103, 46, 116, 117, 117, 105, 100, 18,
                 28, 109, 117, 115, 116, 32, 98, 101, 32, 97, 32, 118, 97, 108, 105, 100, 32, 116,
                 114, 105, 109, 109, 101, 100, 32, 85, 85, 73, 68, 26, 63, 33, 114, 117, 108, 101,
                 115, 46, 116, 117, 117, 105, 100, 32, 124, 124, 32, 116, 104, 105, 115, 32, 61,
                 61, 32, 39, 39, 32, 124, 124, 32, 116, 104, 105, 115, 46, 109, 97, 116, 99, 104,
                 101, 115, 40, 39, 94, 91, 48, 45, 57, 97, 45, 102, 65, 45, 70, 93, 123, 51, 50,
                 125, 36, 39, 41, 10, 99, 10, 18, 115, 116, 114, 105, 110, 103, 46, 116, 117, 117,
                 105, 100, 95, 101, 109, 112, 116, 121, 18, 49, 118, 97, 108, 117, 101, 32, 105,
                 115, 32, 101, 109, 112, 116, 121, 44, 32, 119, 104, 105, 99, 104, 32, 105, 115,
                 32, 110, 111, 116, 32, 97, 32, 118, 97, 108, 105, 100, 32, 116, 114, 105, 109,
                 109, 101, 100, 32, 85, 85, 73, 68, 26, 26, 33, 114, 117, 108, 101, 115, 46, 116,
                 117, 117, 105, 100, 32, 124, 124, 32, 116, 104, 105, 115, 32, 33, 61, 32, 39,
                 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "tuuid",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "ip_with_prefixlen",
          extendee: nil,
          number: 26,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 114, 10, 24, 115, 116, 114, 105, 110, 103, 46, 105, 112, 95, 119, 105, 116,
                 104, 95, 112, 114, 101, 102, 105, 120, 108, 101, 110, 18, 25, 109, 117, 115, 116,
                 32, 98, 101, 32, 97, 32, 118, 97, 108, 105, 100, 32, 73, 80, 32, 112, 114, 101,
                 102, 105, 120, 26, 59, 33, 114, 117, 108, 101, 115, 46, 105, 112, 95, 119, 105,
                 116, 104, 95, 112, 114, 101, 102, 105, 120, 108, 101, 110, 32, 124, 124, 32, 116,
                 104, 105, 115, 32, 61, 61, 32, 39, 39, 32, 124, 124, 32, 116, 104, 105, 115, 46,
                 105, 115, 73, 112, 80, 114, 101, 102, 105, 120, 40, 41, 10, 120, 10, 30, 115,
                 116, 114, 105, 110, 103, 46, 105, 112, 95, 119, 105, 116, 104, 95, 112, 114, 101,
                 102, 105, 120, 108, 101, 110, 95, 101, 109, 112, 116, 121, 18, 46, 118, 97, 108,
                 117, 101, 32, 105, 115, 32, 101, 109, 112, 116, 121, 44, 32, 119, 104, 105, 99,
                 104, 32, 105, 115, 32, 110, 111, 116, 32, 97, 32, 118, 97, 108, 105, 100, 32, 73,
                 80, 32, 112, 114, 101, 102, 105, 120, 26, 38, 33, 114, 117, 108, 101, 115, 46,
                 105, 112, 95, 119, 105, 116, 104, 95, 112, 114, 101, 102, 105, 120, 108, 101,
                 110, 32, 124, 124, 32, 116, 104, 105, 115, 32, 33, 61, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "ipWithPrefixlen",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "ipv4_with_prefixlen",
          extendee: nil,
          number: 27,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 141, 1, 10, 26, 115, 116, 114, 105, 110, 103, 46, 105, 112, 118, 52, 95, 119,
                 105, 116, 104, 95, 112, 114, 101, 102, 105, 120, 108, 101, 110, 18, 47, 109, 117,
                 115, 116, 32, 98, 101, 32, 97, 32, 118, 97, 108, 105, 100, 32, 73, 80, 118, 52,
                 32, 97, 100, 100, 114, 101, 115, 115, 32, 119, 105, 116, 104, 32, 112, 114, 101,
                 102, 105, 120, 32, 108, 101, 110, 103, 116, 104, 26, 62, 33, 114, 117, 108, 101,
                 115, 46, 105, 112, 118, 52, 95, 119, 105, 116, 104, 95, 112, 114, 101, 102, 105,
                 120, 108, 101, 110, 32, 124, 124, 32, 116, 104, 105, 115, 32, 61, 61, 32, 39, 39,
                 32, 124, 124, 32, 116, 104, 105, 115, 46, 105, 115, 73, 112, 80, 114, 101, 102,
                 105, 120, 40, 52, 41, 10, 146, 1, 10, 32, 115, 116, 114, 105, 110, 103, 46, 105,
                 112, 118, 52, 95, 119, 105, 116, 104, 95, 112, 114, 101, 102, 105, 120, 108, 101,
                 110, 95, 101, 109, 112, 116, 121, 18, 68, 118, 97, 108, 117, 101, 32, 105, 115,
                 32, 101, 109, 112, 116, 121, 44, 32, 119, 104, 105, 99, 104, 32, 105, 115, 32,
                 110, 111, 116, 32, 97, 32, 118, 97, 108, 105, 100, 32, 73, 80, 118, 52, 32, 97,
                 100, 100, 114, 101, 115, 115, 32, 119, 105, 116, 104, 32, 112, 114, 101, 102,
                 105, 120, 32, 108, 101, 110, 103, 116, 104, 26, 40, 33, 114, 117, 108, 101, 115,
                 46, 105, 112, 118, 52, 95, 119, 105, 116, 104, 95, 112, 114, 101, 102, 105, 120,
                 108, 101, 110, 32, 124, 124, 32, 116, 104, 105, 115, 32, 33, 61, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "ipv4WithPrefixlen",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "ipv6_with_prefixlen",
          extendee: nil,
          number: 28,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 141, 1, 10, 26, 115, 116, 114, 105, 110, 103, 46, 105, 112, 118, 54, 95, 119,
                 105, 116, 104, 95, 112, 114, 101, 102, 105, 120, 108, 101, 110, 18, 47, 109, 117,
                 115, 116, 32, 98, 101, 32, 97, 32, 118, 97, 108, 105, 100, 32, 73, 80, 118, 54,
                 32, 97, 100, 100, 114, 101, 115, 115, 32, 119, 105, 116, 104, 32, 112, 114, 101,
                 102, 105, 120, 32, 108, 101, 110, 103, 116, 104, 26, 62, 33, 114, 117, 108, 101,
                 115, 46, 105, 112, 118, 54, 95, 119, 105, 116, 104, 95, 112, 114, 101, 102, 105,
                 120, 108, 101, 110, 32, 124, 124, 32, 116, 104, 105, 115, 32, 61, 61, 32, 39, 39,
                 32, 124, 124, 32, 116, 104, 105, 115, 46, 105, 115, 73, 112, 80, 114, 101, 102,
                 105, 120, 40, 54, 41, 10, 146, 1, 10, 32, 115, 116, 114, 105, 110, 103, 46, 105,
                 112, 118, 54, 95, 119, 105, 116, 104, 95, 112, 114, 101, 102, 105, 120, 108, 101,
                 110, 95, 101, 109, 112, 116, 121, 18, 68, 118, 97, 108, 117, 101, 32, 105, 115,
                 32, 101, 109, 112, 116, 121, 44, 32, 119, 104, 105, 99, 104, 32, 105, 115, 32,
                 110, 111, 116, 32, 97, 32, 118, 97, 108, 105, 100, 32, 73, 80, 118, 54, 32, 97,
                 100, 100, 114, 101, 115, 115, 32, 119, 105, 116, 104, 32, 112, 114, 101, 102,
                 105, 120, 32, 108, 101, 110, 103, 116, 104, 26, 40, 33, 114, 117, 108, 101, 115,
                 46, 105, 112, 118, 54, 95, 119, 105, 116, 104, 95, 112, 114, 101, 102, 105, 120,
                 108, 101, 110, 32, 124, 124, 32, 116, 104, 105, 115, 32, 33, 61, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "ipv6WithPrefixlen",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "ip_prefix",
          extendee: nil,
          number: 29,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 102, 10, 16, 115, 116, 114, 105, 110, 103, 46, 105, 112, 95, 112, 114, 101,
                 102, 105, 120, 18, 25, 109, 117, 115, 116, 32, 98, 101, 32, 97, 32, 118, 97, 108,
                 105, 100, 32, 73, 80, 32, 112, 114, 101, 102, 105, 120, 26, 55, 33, 114, 117,
                 108, 101, 115, 46, 105, 112, 95, 112, 114, 101, 102, 105, 120, 32, 124, 124, 32,
                 116, 104, 105, 115, 32, 61, 61, 32, 39, 39, 32, 124, 124, 32, 116, 104, 105, 115,
                 46, 105, 115, 73, 112, 80, 114, 101, 102, 105, 120, 40, 116, 114, 117, 101, 41,
                 10, 104, 10, 22, 115, 116, 114, 105, 110, 103, 46, 105, 112, 95, 112, 114, 101,
                 102, 105, 120, 95, 101, 109, 112, 116, 121, 18, 46, 118, 97, 108, 117, 101, 32,
                 105, 115, 32, 101, 109, 112, 116, 121, 44, 32, 119, 104, 105, 99, 104, 32, 105,
                 115, 32, 110, 111, 116, 32, 97, 32, 118, 97, 108, 105, 100, 32, 73, 80, 32, 112,
                 114, 101, 102, 105, 120, 26, 30, 33, 114, 117, 108, 101, 115, 46, 105, 112, 95,
                 112, 114, 101, 102, 105, 120, 32, 124, 124, 32, 116, 104, 105, 115, 32, 33, 61,
                 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "ipPrefix",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "ipv4_prefix",
          extendee: nil,
          number: 30,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 111, 10, 18, 115, 116, 114, 105, 110, 103, 46, 105, 112, 118, 52, 95, 112,
                 114, 101, 102, 105, 120, 18, 27, 109, 117, 115, 116, 32, 98, 101, 32, 97, 32,
                 118, 97, 108, 105, 100, 32, 73, 80, 118, 52, 32, 112, 114, 101, 102, 105, 120,
                 26, 60, 33, 114, 117, 108, 101, 115, 46, 105, 112, 118, 52, 95, 112, 114, 101,
                 102, 105, 120, 32, 124, 124, 32, 116, 104, 105, 115, 32, 61, 61, 32, 39, 39, 32,
                 124, 124, 32, 116, 104, 105, 115, 46, 105, 115, 73, 112, 80, 114, 101, 102, 105,
                 120, 40, 52, 44, 32, 116, 114, 117, 101, 41, 10, 110, 10, 24, 115, 116, 114, 105,
                 110, 103, 46, 105, 112, 118, 52, 95, 112, 114, 101, 102, 105, 120, 95, 101, 109,
                 112, 116, 121, 18, 48, 118, 97, 108, 117, 101, 32, 105, 115, 32, 101, 109, 112,
                 116, 121, 44, 32, 119, 104, 105, 99, 104, 32, 105, 115, 32, 110, 111, 116, 32,
                 97, 32, 118, 97, 108, 105, 100, 32, 73, 80, 118, 52, 32, 112, 114, 101, 102, 105,
                 120, 26, 32, 33, 114, 117, 108, 101, 115, 46, 105, 112, 118, 52, 95, 112, 114,
                 101, 102, 105, 120, 32, 124, 124, 32, 116, 104, 105, 115, 32, 33, 61, 32, 39,
                 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "ipv4Prefix",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "ipv6_prefix",
          extendee: nil,
          number: 31,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 111, 10, 18, 115, 116, 114, 105, 110, 103, 46, 105, 112, 118, 54, 95, 112,
                 114, 101, 102, 105, 120, 18, 27, 109, 117, 115, 116, 32, 98, 101, 32, 97, 32,
                 118, 97, 108, 105, 100, 32, 73, 80, 118, 54, 32, 112, 114, 101, 102, 105, 120,
                 26, 60, 33, 114, 117, 108, 101, 115, 46, 105, 112, 118, 54, 95, 112, 114, 101,
                 102, 105, 120, 32, 124, 124, 32, 116, 104, 105, 115, 32, 61, 61, 32, 39, 39, 32,
                 124, 124, 32, 116, 104, 105, 115, 46, 105, 115, 73, 112, 80, 114, 101, 102, 105,
                 120, 40, 54, 44, 32, 116, 114, 117, 101, 41, 10, 110, 10, 24, 115, 116, 114, 105,
                 110, 103, 46, 105, 112, 118, 54, 95, 112, 114, 101, 102, 105, 120, 95, 101, 109,
                 112, 116, 121, 18, 48, 118, 97, 108, 117, 101, 32, 105, 115, 32, 101, 109, 112,
                 116, 121, 44, 32, 119, 104, 105, 99, 104, 32, 105, 115, 32, 110, 111, 116, 32,
                 97, 32, 118, 97, 108, 105, 100, 32, 73, 80, 118, 54, 32, 112, 114, 101, 102, 105,
                 120, 26, 32, 33, 114, 117, 108, 101, 115, 46, 105, 112, 118, 54, 95, 112, 114,
                 101, 102, 105, 120, 32, 124, 124, 32, 116, 104, 105, 115, 32, 33, 61, 32, 39,
                 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "ipv6Prefix",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "host_and_port",
          extendee: nil,
          number: 32,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 147, 1, 10, 20, 115, 116, 114, 105, 110, 103, 46, 104, 111, 115, 116, 95, 97,
                 110, 100, 95, 112, 111, 114, 116, 18, 59, 109, 117, 115, 116, 32, 98, 101, 32,
                 97, 32, 118, 97, 108, 105, 100, 32, 104, 111, 115, 116, 32, 40, 104, 111, 115,
                 116, 110, 97, 109, 101, 32, 111, 114, 32, 73, 80, 32, 97, 100, 100, 114, 101,
                 115, 115, 41, 32, 97, 110, 100, 32, 112, 111, 114, 116, 32, 112, 97, 105, 114,
                 26, 62, 33, 114, 117, 108, 101, 115, 46, 104, 111, 115, 116, 95, 97, 110, 100,
                 95, 112, 111, 114, 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 61, 61, 32, 39,
                 39, 32, 124, 124, 32, 116, 104, 105, 115, 46, 105, 115, 72, 111, 115, 116, 65,
                 110, 100, 80, 111, 114, 116, 40, 116, 114, 117, 101, 41, 10, 121, 10, 26, 115,
                 116, 114, 105, 110, 103, 46, 104, 111, 115, 116, 95, 97, 110, 100, 95, 112, 111,
                 114, 116, 95, 101, 109, 112, 116, 121, 18, 55, 118, 97, 108, 117, 101, 32, 105,
                 115, 32, 101, 109, 112, 116, 121, 44, 32, 119, 104, 105, 99, 104, 32, 105, 115,
                 32, 110, 111, 116, 32, 97, 32, 118, 97, 108, 105, 100, 32, 104, 111, 115, 116,
                 32, 97, 110, 100, 32, 112, 111, 114, 116, 32, 112, 97, 105, 114, 26, 34, 33, 114,
                 117, 108, 101, 115, 46, 104, 111, 115, 116, 95, 97, 110, 100, 95, 112, 111, 114,
                 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 33, 61, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "hostAndPort",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "ulid",
          extendee: nil,
          number: 35,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 124, 10, 11, 115, 116, 114, 105, 110, 103, 46, 117, 108, 105, 100, 18, 20,
                 109, 117, 115, 116, 32, 98, 101, 32, 97, 32, 118, 97, 108, 105, 100, 32, 85, 76,
                 73, 68, 26, 87, 33, 114, 117, 108, 101, 115, 46, 117, 108, 105, 100, 32, 124,
                 124, 32, 116, 104, 105, 115, 32, 61, 61, 32, 39, 39, 32, 124, 124, 32, 116, 104,
                 105, 115, 46, 109, 97, 116, 99, 104, 101, 115, 40, 39, 94, 91, 48, 45, 55, 93,
                 91, 48, 45, 57, 65, 45, 72, 74, 75, 77, 78, 80, 45, 84, 86, 45, 90, 97, 45, 104,
                 106, 107, 109, 110, 112, 45, 116, 118, 45, 122, 93, 123, 50, 53, 125, 36, 39, 41,
                 10, 89, 10, 17, 115, 116, 114, 105, 110, 103, 46, 117, 108, 105, 100, 95, 101,
                 109, 112, 116, 121, 18, 41, 118, 97, 108, 117, 101, 32, 105, 115, 32, 101, 109,
                 112, 116, 121, 44, 32, 119, 104, 105, 99, 104, 32, 105, 115, 32, 110, 111, 116,
                 32, 97, 32, 118, 97, 108, 105, 100, 32, 85, 76, 73, 68, 26, 25, 33, 114, 117,
                 108, 101, 115, 46, 117, 108, 105, 100, 32, 124, 124, 32, 116, 104, 105, 115, 32,
                 33, 61, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "ulid",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "protobuf_fqn",
          extendee: nil,
          number: 37,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 175, 1, 10, 19, 115, 116, 114, 105, 110, 103, 46, 112, 114, 111, 116, 111,
                 98, 117, 102, 95, 102, 113, 110, 18, 45, 109, 117, 115, 116, 32, 98, 101, 32, 97,
                 32, 118, 97, 108, 105, 100, 32, 102, 117, 108, 108, 121, 45, 113, 117, 97, 108,
                 105, 102, 105, 101, 100, 32, 80, 114, 111, 116, 111, 98, 117, 102, 32, 110, 97,
                 109, 101, 26, 105, 33, 114, 117, 108, 101, 115, 46, 112, 114, 111, 116, 111, 98,
                 117, 102, 95, 102, 113, 110, 32, 124, 124, 32, 116, 104, 105, 115, 32, 61, 61,
                 32, 39, 39, 32, 124, 124, 32, 116, 104, 105, 115, 46, 109, 97, 116, 99, 104, 101,
                 115, 40, 39, 94, 91, 65, 45, 90, 97, 45, 122, 95, 93, 91, 65, 45, 90, 97, 45,
                 122, 95, 48, 45, 57, 93, 42, 40, 92, 92, 46, 91, 65, 45, 90, 97, 45, 122, 95, 93,
                 91, 65, 45, 90, 97, 45, 122, 95, 48, 45, 57, 93, 42, 41, 42, 36, 39, 41, 10, 130,
                 1, 10, 25, 115, 116, 114, 105, 110, 103, 46, 112, 114, 111, 116, 111, 98, 117,
                 102, 95, 102, 113, 110, 95, 101, 109, 112, 116, 121, 18, 66, 118, 97, 108, 117,
                 101, 32, 105, 115, 32, 101, 109, 112, 116, 121, 44, 32, 119, 104, 105, 99, 104,
                 32, 105, 115, 32, 110, 111, 116, 32, 97, 32, 118, 97, 108, 105, 100, 32, 102,
                 117, 108, 108, 121, 45, 113, 117, 97, 108, 105, 102, 105, 101, 100, 32, 80, 114,
                 111, 116, 111, 98, 117, 102, 32, 110, 97, 109, 101, 26, 33, 33, 114, 117, 108,
                 101, 115, 46, 112, 114, 111, 116, 111, 98, 117, 102, 95, 102, 113, 110, 32, 124,
                 124, 32, 116, 104, 105, 115, 32, 33, 61, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "protobufFqn",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "protobuf_dot_fqn",
          extendee: nil,
          number: 38,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 205, 1, 10, 23, 115, 116, 114, 105, 110, 103, 46, 112, 114, 111, 116, 111,
                 98, 117, 102, 95, 100, 111, 116, 95, 102, 113, 110, 18, 64, 109, 117, 115, 116,
                 32, 98, 101, 32, 97, 32, 118, 97, 108, 105, 100, 32, 102, 117, 108, 108, 121, 45,
                 113, 117, 97, 108, 105, 102, 105, 101, 100, 32, 80, 114, 111, 116, 111, 98, 117,
                 102, 32, 110, 97, 109, 101, 32, 119, 105, 116, 104, 32, 97, 32, 108, 101, 97,
                 100, 105, 110, 103, 32, 100, 111, 116, 26, 112, 33, 114, 117, 108, 101, 115, 46,
                 112, 114, 111, 116, 111, 98, 117, 102, 95, 100, 111, 116, 95, 102, 113, 110, 32,
                 124, 124, 32, 116, 104, 105, 115, 32, 61, 61, 32, 39, 39, 32, 124, 124, 32, 116,
                 104, 105, 115, 46, 109, 97, 116, 99, 104, 101, 115, 40, 39, 94, 92, 92, 46, 91,
                 65, 45, 90, 97, 45, 122, 95, 93, 91, 65, 45, 90, 97, 45, 122, 95, 48, 45, 57, 93,
                 42, 40, 92, 92, 46, 91, 65, 45, 90, 97, 45, 122, 95, 93, 91, 65, 45, 90, 97, 45,
                 122, 95, 48, 45, 57, 93, 42, 41, 42, 36, 39, 41, 10, 157, 1, 10, 29, 115, 116,
                 114, 105, 110, 103, 46, 112, 114, 111, 116, 111, 98, 117, 102, 95, 100, 111, 116,
                 95, 102, 113, 110, 95, 101, 109, 112, 116, 121, 18, 85, 118, 97, 108, 117, 101,
                 32, 105, 115, 32, 101, 109, 112, 116, 121, 44, 32, 119, 104, 105, 99, 104, 32,
                 105, 115, 32, 110, 111, 116, 32, 97, 32, 118, 97, 108, 105, 100, 32, 102, 117,
                 108, 108, 121, 45, 113, 117, 97, 108, 105, 102, 105, 101, 100, 32, 80, 114, 111,
                 116, 111, 98, 117, 102, 32, 110, 97, 109, 101, 32, 119, 105, 116, 104, 32, 97,
                 32, 108, 101, 97, 100, 105, 110, 103, 32, 100, 111, 116, 26, 37, 33, 114, 117,
                 108, 101, 115, 46, 112, 114, 111, 116, 111, 98, 117, 102, 95, 100, 111, 116, 95,
                 102, 113, 110, 32, 124, 124, 32, 116, 104, 105, 115, 32, 33, 61, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "protobufDotFqn",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "well_known_regex",
          extendee: nil,
          number: 24,
          label: :LABEL_OPTIONAL,
          type: :TYPE_ENUM,
          type_name: ".buf.validate.KnownRegex",
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 234, 1, 10, 35, 115, 116, 114, 105, 110, 103, 46, 119, 101, 108, 108, 95,
                 107, 110, 111, 119, 110, 95, 114, 101, 103, 101, 120, 46, 104, 101, 97, 100, 101,
                 114, 95, 110, 97, 109, 101, 18, 32, 109, 117, 115, 116, 32, 98, 101, 32, 97, 32,
                 118, 97, 108, 105, 100, 32, 72, 84, 84, 80, 32, 104, 101, 97, 100, 101, 114, 32,
                 110, 97, 109, 101, 26, 160, 1, 114, 117, 108, 101, 115, 46, 119, 101, 108, 108,
                 95, 107, 110, 111, 119, 110, 95, 114, 101, 103, 101, 120, 32, 33, 61, 32, 49, 32,
                 124, 124, 32, 116, 104, 105, 115, 32, 61, 61, 32, 39, 39, 32, 124, 124, 32, 116,
                 104, 105, 115, 46, 109, 97, 116, 99, 104, 101, 115, 40, 33, 104, 97, 115, 40,
                 114, 117, 108, 101, 115, 46, 115, 116, 114, 105, 99, 116, 41, 32, 124, 124, 32,
                 114, 117, 108, 101, 115, 46, 115, 116, 114, 105, 99, 116, 32, 63, 39, 94, 58, 63,
                 91, 48, 45, 57, 97, 45, 122, 65, 45, 90, 33, 35, 36, 37, 38, 92, 39, 42, 43, 45,
                 46, 94, 95, 124, 126, 92, 120, 54, 48, 93, 43, 36, 39, 32, 58, 39, 94, 91, 94,
                 92, 117, 48, 48, 48, 48, 92, 117, 48, 48, 48, 65, 92, 117, 48, 48, 48, 68, 93,
                 43, 36, 39, 41, 10, 141, 1, 10, 41, 115, 116, 114, 105, 110, 103, 46, 119, 101,
                 108, 108, 95, 107, 110, 111, 119, 110, 95, 114, 101, 103, 101, 120, 46, 104, 101,
                 97, 100, 101, 114, 95, 110, 97, 109, 101, 95, 101, 109, 112, 116, 121, 18, 53,
                 118, 97, 108, 117, 101, 32, 105, 115, 32, 101, 109, 112, 116, 121, 44, 32, 119,
                 104, 105, 99, 104, 32, 105, 115, 32, 110, 111, 116, 32, 97, 32, 118, 97, 108,
                 105, 100, 32, 72, 84, 84, 80, 32, 104, 101, 97, 100, 101, 114, 32, 110, 97, 109,
                 101, 26, 41, 114, 117, 108, 101, 115, 46, 119, 101, 108, 108, 95, 107, 110, 111,
                 119, 110, 95, 114, 101, 103, 101, 120, 32, 33, 61, 32, 49, 32, 124, 124, 32, 116,
                 104, 105, 115, 32, 33, 61, 32, 39, 39, 10, 225, 1, 10, 36, 115, 116, 114, 105,
                 110, 103, 46, 119, 101, 108, 108, 95, 107, 110, 111, 119, 110, 95, 114, 101, 103,
                 101, 120, 46, 104, 101, 97, 100, 101, 114, 95, 118, 97, 108, 117, 101, 18, 33,
                 109, 117, 115, 116, 32, 98, 101, 32, 97, 32, 118, 97, 108, 105, 100, 32, 72, 84,
                 84, 80, 32, 104, 101, 97, 100, 101, 114, 32, 118, 97, 108, 117, 101, 26, 149, 1,
                 114, 117, 108, 101, 115, 46, 119, 101, 108, 108, 95, 107, 110, 111, 119, 110, 95,
                 114, 101, 103, 101, 120, 32, 33, 61, 32, 50, 32, 124, 124, 32, 116, 104, 105,
                 115, 46, 109, 97, 116, 99, 104, 101, 115, 40, 33, 104, 97, 115, 40, 114, 117,
                 108, 101, 115, 46, 115, 116, 114, 105, 99, 116, 41, 32, 124, 124, 32, 114, 117,
                 108, 101, 115, 46, 115, 116, 114, 105, 99, 116, 32, 63, 39, 94, 91, 94, 92, 117,
                 48, 48, 48, 48, 45, 92, 117, 48, 48, 48, 56, 92, 117, 48, 48, 48, 65, 45, 92,
                 117, 48, 48, 49, 70, 92, 117, 48, 48, 55, 70, 93, 42, 36, 39, 32, 58, 39, 94, 91,
                 94, 92, 117, 48, 48, 48, 48, 92, 117, 48, 48, 48, 65, 92, 117, 48, 48, 48, 68,
                 93, 42, 36, 39, 41>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "wellKnownRegex",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "strict",
          extendee: nil,
          number: 25,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "strict",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "example",
          extendee: nil,
          number: 34,
          label: :LABEL_REPEATED,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 22, 10, 14, 115, 116, 114, 105, 110, 103, 46, 101, 120, 97, 109, 112, 108,
                 101, 26, 4, 116, 114, 117, 101>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "example",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [
        %Google.Protobuf.DescriptorProto.ExtensionRange{
          start: 1000,
          end: 536_870_912,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      extension: [],
      options: nil,
      oneof_decl: [
        %Google.Protobuf.OneofDescriptorProto{
          name: "well_known",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  oneof(:well_known, 0)

  field(:const, 1, optional: true, type: :string, deprecated: false)
  field(:len, 19, optional: true, type: :uint64, deprecated: false)
  field(:min_len, 2, optional: true, type: :uint64, json_name: "minLen", deprecated: false)
  field(:max_len, 3, optional: true, type: :uint64, json_name: "maxLen", deprecated: false)
  field(:len_bytes, 20, optional: true, type: :uint64, json_name: "lenBytes", deprecated: false)
  field(:min_bytes, 4, optional: true, type: :uint64, json_name: "minBytes", deprecated: false)
  field(:max_bytes, 5, optional: true, type: :uint64, json_name: "maxBytes", deprecated: false)
  field(:pattern, 6, optional: true, type: :string, deprecated: false)
  field(:prefix, 7, optional: true, type: :string, deprecated: false)
  field(:suffix, 8, optional: true, type: :string, deprecated: false)
  field(:contains, 9, optional: true, type: :string, deprecated: false)

  field(:not_contains, 23,
    optional: true,
    type: :string,
    json_name: "notContains",
    deprecated: false
  )

  field(:in, 10, repeated: true, type: :string, deprecated: false)
  field(:not_in, 11, repeated: true, type: :string, json_name: "notIn", deprecated: false)
  field(:email, 12, optional: true, type: :bool, oneof: 0, deprecated: false)
  field(:hostname, 13, optional: true, type: :bool, oneof: 0, deprecated: false)
  field(:ip, 14, optional: true, type: :bool, oneof: 0, deprecated: false)
  field(:ipv4, 15, optional: true, type: :bool, oneof: 0, deprecated: false)
  field(:ipv6, 16, optional: true, type: :bool, oneof: 0, deprecated: false)
  field(:uri, 17, optional: true, type: :bool, oneof: 0, deprecated: false)

  field(:uri_ref, 18,
    optional: true,
    type: :bool,
    json_name: "uriRef",
    oneof: 0,
    deprecated: false
  )

  field(:address, 21, optional: true, type: :bool, oneof: 0, deprecated: false)
  field(:uuid, 22, optional: true, type: :bool, oneof: 0, deprecated: false)
  field(:tuuid, 33, optional: true, type: :bool, oneof: 0, deprecated: false)

  field(:ip_with_prefixlen, 26,
    optional: true,
    type: :bool,
    json_name: "ipWithPrefixlen",
    oneof: 0,
    deprecated: false
  )

  field(:ipv4_with_prefixlen, 27,
    optional: true,
    type: :bool,
    json_name: "ipv4WithPrefixlen",
    oneof: 0,
    deprecated: false
  )

  field(:ipv6_with_prefixlen, 28,
    optional: true,
    type: :bool,
    json_name: "ipv6WithPrefixlen",
    oneof: 0,
    deprecated: false
  )

  field(:ip_prefix, 29,
    optional: true,
    type: :bool,
    json_name: "ipPrefix",
    oneof: 0,
    deprecated: false
  )

  field(:ipv4_prefix, 30,
    optional: true,
    type: :bool,
    json_name: "ipv4Prefix",
    oneof: 0,
    deprecated: false
  )

  field(:ipv6_prefix, 31,
    optional: true,
    type: :bool,
    json_name: "ipv6Prefix",
    oneof: 0,
    deprecated: false
  )

  field(:host_and_port, 32,
    optional: true,
    type: :bool,
    json_name: "hostAndPort",
    oneof: 0,
    deprecated: false
  )

  field(:ulid, 35, optional: true, type: :bool, oneof: 0, deprecated: false)

  field(:protobuf_fqn, 37,
    optional: true,
    type: :bool,
    json_name: "protobufFqn",
    oneof: 0,
    deprecated: false
  )

  field(:protobuf_dot_fqn, 38,
    optional: true,
    type: :bool,
    json_name: "protobufDotFqn",
    oneof: 0,
    deprecated: false
  )

  field(:well_known_regex, 24,
    optional: true,
    type: Buf.Validate.KnownRegex,
    json_name: "wellKnownRegex",
    enum: true,
    oneof: 0,
    deprecated: false
  )

  field(:strict, 25, optional: true, type: :bool)
  field(:example, 34, repeated: true, type: :string, deprecated: false)

  extensions([{1000, Protobuf.Extension.max()}])
end

defmodule Buf.Validate.BytesRules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.BytesRules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "BytesRules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "const",
          extendee: nil,
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BYTES,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 102, 10, 11, 98, 121, 116, 101, 115, 46, 99, 111, 110, 115, 116, 26, 87, 116,
                 104, 105, 115, 32, 33, 61, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114,
                 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 32, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 37, 120, 39, 46, 102, 111, 114, 109, 97,
                 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114, 117, 108, 101, 115,
                 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "const",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "len",
          extendee: nil,
          number: 13,
          label: :LABEL_OPTIONAL,
          type: :TYPE_UINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 89, 10, 9, 98, 121, 116, 101, 115, 46, 108, 101, 110, 26, 76, 117, 105, 110,
                 116, 40, 116, 104, 105, 115, 46, 115, 105, 122, 101, 40, 41, 41, 32, 33, 61, 32,
                 114, 117, 108, 101, 115, 46, 108, 101, 110, 32, 63, 32, 39, 109, 117, 115, 116,
                 32, 98, 101, 32, 37, 115, 32, 98, 121, 116, 101, 115, 39, 46, 102, 111, 114, 109,
                 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 108, 101, 110, 93, 41, 32, 58, 32,
                 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "len",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "min_len",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_UINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 109, 10, 13, 98, 121, 116, 101, 115, 46, 109, 105, 110, 95, 108, 101, 110,
                 26, 92, 117, 105, 110, 116, 40, 116, 104, 105, 115, 46, 115, 105, 122, 101, 40,
                 41, 41, 32, 60, 32, 114, 117, 108, 101, 115, 46, 109, 105, 110, 95, 108, 101,
                 110, 32, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 97, 116, 32, 108, 101,
                 97, 115, 116, 32, 37, 115, 32, 98, 121, 116, 101, 115, 39, 46, 102, 111, 114,
                 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 109, 105, 110, 95, 108, 101,
                 110, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "minLen",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "max_len",
          extendee: nil,
          number: 3,
          label: :LABEL_OPTIONAL,
          type: :TYPE_UINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 108, 10, 13, 98, 121, 116, 101, 115, 46, 109, 97, 120, 95, 108, 101, 110, 26,
                 91, 117, 105, 110, 116, 40, 116, 104, 105, 115, 46, 115, 105, 122, 101, 40, 41,
                 41, 32, 62, 32, 114, 117, 108, 101, 115, 46, 109, 97, 120, 95, 108, 101, 110, 32,
                 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 97, 116, 32, 109, 111, 115, 116,
                 32, 37, 115, 32, 98, 121, 116, 101, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40,
                 91, 114, 117, 108, 101, 115, 46, 109, 97, 120, 95, 108, 101, 110, 93, 41, 32, 58,
                 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "maxLen",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "pattern",
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 116, 10, 13, 98, 121, 116, 101, 115, 46, 112, 97, 116, 116, 101, 114, 110,
                 26, 99, 33, 115, 116, 114, 105, 110, 103, 40, 116, 104, 105, 115, 41, 46, 109,
                 97, 116, 99, 104, 101, 115, 40, 114, 117, 108, 101, 115, 46, 112, 97, 116, 116,
                 101, 114, 110, 41, 32, 63, 32, 39, 109, 117, 115, 116, 32, 109, 97, 116, 99, 104,
                 32, 114, 101, 103, 101, 120, 32, 112, 97, 116, 116, 101, 114, 110, 32, 96, 37,
                 115, 96, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115,
                 46, 112, 97, 116, 116, 101, 114, 110, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "pattern",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "prefix",
          extendee: nil,
          number: 5,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BYTES,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 102, 10, 12, 98, 121, 116, 101, 115, 46, 112, 114, 101, 102, 105, 120, 26,
                 86, 33, 116, 104, 105, 115, 46, 115, 116, 97, 114, 116, 115, 87, 105, 116, 104,
                 40, 114, 117, 108, 101, 115, 46, 112, 114, 101, 102, 105, 120, 41, 32, 63, 32,
                 39, 100, 111, 101, 115, 32, 110, 111, 116, 32, 104, 97, 118, 101, 32, 112, 114,
                 101, 102, 105, 120, 32, 37, 120, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91,
                 114, 117, 108, 101, 115, 46, 112, 114, 101, 102, 105, 120, 93, 41, 32, 58, 32,
                 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "prefix",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "suffix",
          extendee: nil,
          number: 6,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BYTES,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 100, 10, 12, 98, 121, 116, 101, 115, 46, 115, 117, 102, 102, 105, 120, 26,
                 84, 33, 116, 104, 105, 115, 46, 101, 110, 100, 115, 87, 105, 116, 104, 40, 114,
                 117, 108, 101, 115, 46, 115, 117, 102, 102, 105, 120, 41, 32, 63, 32, 39, 100,
                 111, 101, 115, 32, 110, 111, 116, 32, 104, 97, 118, 101, 32, 115, 117, 102, 102,
                 105, 120, 32, 37, 120, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 115, 117, 102, 102, 105, 120, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "suffix",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "contains",
          extendee: nil,
          number: 7,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BYTES,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 102, 10, 14, 98, 121, 116, 101, 115, 46, 99, 111, 110, 116, 97, 105, 110,
                 115, 26, 84, 33, 116, 104, 105, 115, 46, 99, 111, 110, 116, 97, 105, 110, 115,
                 40, 114, 117, 108, 101, 115, 46, 99, 111, 110, 116, 97, 105, 110, 115, 41, 32,
                 63, 32, 39, 100, 111, 101, 115, 32, 110, 111, 116, 32, 99, 111, 110, 116, 97,
                 105, 110, 32, 37, 120, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 99, 111, 110, 116, 97, 105, 110, 115, 93, 41, 32, 58, 32, 39,
                 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "contains",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "in",
          extendee: nil,
          number: 8,
          label: :LABEL_REPEATED,
          type: :TYPE_BYTES,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 141, 1, 10, 8, 98, 121, 116, 101, 115, 46, 105, 110, 26, 128, 1, 103, 101,
                 116, 70, 105, 101, 108, 100, 40, 114, 117, 108, 101, 115, 44, 32, 39, 105, 110,
                 39, 41, 46, 115, 105, 122, 101, 40, 41, 32, 62, 32, 48, 32, 38, 38, 32, 33, 40,
                 116, 104, 105, 115, 32, 105, 110, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40,
                 114, 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 41, 32, 63, 32, 39, 109,
                 117, 115, 116, 32, 98, 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115,
                 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108,
                 100, 40, 114, 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 93, 41, 32, 58,
                 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "in",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "not_in",
          extendee: nil,
          number: 9,
          label: :LABEL_REPEATED,
          type: :TYPE_BYTES,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 91, 10, 12, 98, 121, 116, 101, 115, 46, 110, 111, 116, 95, 105, 110, 26, 75,
                 116, 104, 105, 115, 32, 105, 110, 32, 114, 117, 108, 101, 115, 46, 110, 111, 116,
                 95, 105, 110, 32, 63, 32, 39, 109, 117, 115, 116, 32, 110, 111, 116, 32, 98, 101,
                 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46, 102, 111, 114, 109,
                 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 110, 111, 116, 95, 105, 110, 93,
                 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "notIn",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "ip",
          extendee: nil,
          number: 10,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 110, 10, 8, 98, 121, 116, 101, 115, 46, 105, 112, 18, 26, 109, 117, 115, 116,
                 32, 98, 101, 32, 97, 32, 118, 97, 108, 105, 100, 32, 73, 80, 32, 97, 100, 100,
                 114, 101, 115, 115, 26, 70, 33, 114, 117, 108, 101, 115, 46, 105, 112, 32, 124,
                 124, 32, 116, 104, 105, 115, 46, 115, 105, 122, 101, 40, 41, 32, 61, 61, 32, 48,
                 32, 124, 124, 32, 116, 104, 105, 115, 46, 115, 105, 122, 101, 40, 41, 32, 61, 61,
                 32, 52, 32, 124, 124, 32, 116, 104, 105, 115, 46, 115, 105, 122, 101, 40, 41, 32,
                 61, 61, 32, 49, 54, 10, 96, 10, 14, 98, 121, 116, 101, 115, 46, 105, 112, 95,
                 101, 109, 112, 116, 121, 18, 47, 118, 97, 108, 117, 101, 32, 105, 115, 32, 101,
                 109, 112, 116, 121, 44, 32, 119, 104, 105, 99, 104, 32, 105, 115, 32, 110, 111,
                 116, 32, 97, 32, 118, 97, 108, 105, 100, 32, 73, 80, 32, 97, 100, 100, 114, 101,
                 115, 115, 26, 29, 33, 114, 117, 108, 101, 115, 46, 105, 112, 32, 124, 124, 32,
                 116, 104, 105, 115, 46, 115, 105, 122, 101, 40, 41, 32, 33, 61, 32, 48>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "ip",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "ipv4",
          extendee: nil,
          number: 11,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 95, 10, 10, 98, 121, 116, 101, 115, 46, 105, 112, 118, 52, 18, 28, 109, 117,
                 115, 116, 32, 98, 101, 32, 97, 32, 118, 97, 108, 105, 100, 32, 73, 80, 118, 52,
                 32, 97, 100, 100, 114, 101, 115, 115, 26, 51, 33, 114, 117, 108, 101, 115, 46,
                 105, 112, 118, 52, 32, 124, 124, 32, 116, 104, 105, 115, 46, 115, 105, 122, 101,
                 40, 41, 32, 61, 61, 32, 48, 32, 124, 124, 32, 116, 104, 105, 115, 46, 115, 105,
                 122, 101, 40, 41, 32, 61, 61, 32, 52, 10, 102, 10, 16, 98, 121, 116, 101, 115,
                 46, 105, 112, 118, 52, 95, 101, 109, 112, 116, 121, 18, 49, 118, 97, 108, 117,
                 101, 32, 105, 115, 32, 101, 109, 112, 116, 121, 44, 32, 119, 104, 105, 99, 104,
                 32, 105, 115, 32, 110, 111, 116, 32, 97, 32, 118, 97, 108, 105, 100, 32, 73, 80,
                 118, 52, 32, 97, 100, 100, 114, 101, 115, 115, 26, 31, 33, 114, 117, 108, 101,
                 115, 46, 105, 112, 118, 52, 32, 124, 124, 32, 116, 104, 105, 115, 46, 115, 105,
                 122, 101, 40, 41, 32, 33, 61, 32, 48>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "ipv4",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "ipv6",
          extendee: nil,
          number: 12,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 96, 10, 10, 98, 121, 116, 101, 115, 46, 105, 112, 118, 54, 18, 28, 109, 117,
                 115, 116, 32, 98, 101, 32, 97, 32, 118, 97, 108, 105, 100, 32, 73, 80, 118, 54,
                 32, 97, 100, 100, 114, 101, 115, 115, 26, 52, 33, 114, 117, 108, 101, 115, 46,
                 105, 112, 118, 54, 32, 124, 124, 32, 116, 104, 105, 115, 46, 115, 105, 122, 101,
                 40, 41, 32, 61, 61, 32, 48, 32, 124, 124, 32, 116, 104, 105, 115, 46, 115, 105,
                 122, 101, 40, 41, 32, 61, 61, 32, 49, 54, 10, 102, 10, 16, 98, 121, 116, 101,
                 115, 46, 105, 112, 118, 54, 95, 101, 109, 112, 116, 121, 18, 49, 118, 97, 108,
                 117, 101, 32, 105, 115, 32, 101, 109, 112, 116, 121, 44, 32, 119, 104, 105, 99,
                 104, 32, 105, 115, 32, 110, 111, 116, 32, 97, 32, 118, 97, 108, 105, 100, 32, 73,
                 80, 118, 54, 32, 97, 100, 100, 114, 101, 115, 115, 26, 31, 33, 114, 117, 108,
                 101, 115, 46, 105, 112, 118, 54, 32, 124, 124, 32, 116, 104, 105, 115, 46, 115,
                 105, 122, 101, 40, 41, 32, 33, 61, 32, 48>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "ipv6",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "uuid",
          extendee: nil,
          number: 15,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 88, 10, 10, 98, 121, 116, 101, 115, 46, 117, 117, 105, 100, 18, 20, 109, 117,
                 115, 116, 32, 98, 101, 32, 97, 32, 118, 97, 108, 105, 100, 32, 85, 85, 73, 68,
                 26, 52, 33, 114, 117, 108, 101, 115, 46, 117, 117, 105, 100, 32, 124, 124, 32,
                 116, 104, 105, 115, 46, 115, 105, 122, 101, 40, 41, 32, 61, 61, 32, 48, 32, 124,
                 124, 32, 116, 104, 105, 115, 46, 115, 105, 122, 101, 40, 41, 32, 61, 61, 32, 49,
                 54, 10, 94, 10, 16, 98, 121, 116, 101, 115, 46, 117, 117, 105, 100, 95, 101, 109,
                 112, 116, 121, 18, 41, 118, 97, 108, 117, 101, 32, 105, 115, 32, 101, 109, 112,
                 116, 121, 44, 32, 119, 104, 105, 99, 104, 32, 105, 115, 32, 110, 111, 116, 32,
                 97, 32, 118, 97, 108, 105, 100, 32, 85, 85, 73, 68, 26, 31, 33, 114, 117, 108,
                 101, 115, 46, 117, 117, 105, 100, 32, 124, 124, 32, 116, 104, 105, 115, 46, 115,
                 105, 122, 101, 40, 41, 32, 33, 61, 32, 48>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "uuid",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "example",
          extendee: nil,
          number: 14,
          label: :LABEL_REPEATED,
          type: :TYPE_BYTES,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 21, 10, 13, 98, 121, 116, 101, 115, 46, 101, 120, 97, 109, 112, 108, 101, 26,
                 4, 116, 114, 117, 101>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "example",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [
        %Google.Protobuf.DescriptorProto.ExtensionRange{
          start: 1000,
          end: 536_870_912,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      extension: [],
      options: nil,
      oneof_decl: [
        %Google.Protobuf.OneofDescriptorProto{
          name: "well_known",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  oneof(:well_known, 0)

  field(:const, 1, optional: true, type: :bytes, deprecated: false)
  field(:len, 13, optional: true, type: :uint64, deprecated: false)
  field(:min_len, 2, optional: true, type: :uint64, json_name: "minLen", deprecated: false)
  field(:max_len, 3, optional: true, type: :uint64, json_name: "maxLen", deprecated: false)
  field(:pattern, 4, optional: true, type: :string, deprecated: false)
  field(:prefix, 5, optional: true, type: :bytes, deprecated: false)
  field(:suffix, 6, optional: true, type: :bytes, deprecated: false)
  field(:contains, 7, optional: true, type: :bytes, deprecated: false)
  field(:in, 8, repeated: true, type: :bytes, deprecated: false)
  field(:not_in, 9, repeated: true, type: :bytes, json_name: "notIn", deprecated: false)
  field(:ip, 10, optional: true, type: :bool, oneof: 0, deprecated: false)
  field(:ipv4, 11, optional: true, type: :bool, oneof: 0, deprecated: false)
  field(:ipv6, 12, optional: true, type: :bool, oneof: 0, deprecated: false)
  field(:uuid, 15, optional: true, type: :bool, oneof: 0, deprecated: false)
  field(:example, 14, repeated: true, type: :bytes, deprecated: false)

  extensions([{1000, Protobuf.Extension.max()}])
end

defmodule Buf.Validate.EnumRules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.EnumRules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "EnumRules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "const",
          extendee: nil,
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_INT32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 104, 10, 10, 101, 110, 117, 109, 46, 99, 111, 110, 115, 116, 26, 90, 116,
                 104, 105, 115, 32, 33, 61, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114,
                 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 32, 63, 32, 39,
                 109, 117, 115, 116, 32, 101, 113, 117, 97, 108, 32, 37, 115, 39, 46, 102, 111,
                 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114, 117,
                 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 93, 41, 32, 58, 32,
                 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "const",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "defined_only",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "definedOnly",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "in",
          extendee: nil,
          number: 3,
          label: :LABEL_REPEATED,
          type: :TYPE_INT32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 103, 10, 7, 101, 110, 117, 109, 46, 105, 110, 26, 92, 33, 40, 116, 104, 105,
                 115, 32, 105, 110, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114, 117, 108,
                 101, 115, 44, 32, 39, 105, 110, 39, 41, 41, 32, 63, 32, 39, 109, 117, 115, 116,
                 32, 98, 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46, 102, 111,
                 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114, 117,
                 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "in",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "not_in",
          extendee: nil,
          number: 4,
          label: :LABEL_REPEATED,
          type: :TYPE_INT32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 90, 10, 11, 101, 110, 117, 109, 46, 110, 111, 116, 95, 105, 110, 26, 75, 116,
                 104, 105, 115, 32, 105, 110, 32, 114, 117, 108, 101, 115, 46, 110, 111, 116, 95,
                 105, 110, 32, 63, 32, 39, 109, 117, 115, 116, 32, 110, 111, 116, 32, 98, 101, 32,
                 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97,
                 116, 40, 91, 114, 117, 108, 101, 115, 46, 110, 111, 116, 95, 105, 110, 93, 41,
                 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "notIn",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "example",
          extendee: nil,
          number: 5,
          label: :LABEL_REPEATED,
          type: :TYPE_INT32,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 20, 10, 12, 101, 110, 117, 109, 46, 101, 120, 97, 109, 112, 108, 101, 26, 4,
                 116, 114, 117, 101>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "example",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [
        %Google.Protobuf.DescriptorProto.ExtensionRange{
          start: 1000,
          end: 536_870_912,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      extension: [],
      options: nil,
      oneof_decl: [],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  field(:const, 1, optional: true, type: :int32, deprecated: false)
  field(:defined_only, 2, optional: true, type: :bool, json_name: "definedOnly")
  field(:in, 3, repeated: true, type: :int32, deprecated: false)
  field(:not_in, 4, repeated: true, type: :int32, json_name: "notIn", deprecated: false)
  field(:example, 5, repeated: true, type: :int32, deprecated: false)

  extensions([{1000, Protobuf.Extension.max()}])
end

defmodule Buf.Validate.RepeatedRules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.RepeatedRules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "RepeatedRules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "min_items",
          extendee: nil,
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_UINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 125, 10, 18, 114, 101, 112, 101, 97, 116, 101, 100, 46, 109, 105, 110, 95,
                 105, 116, 101, 109, 115, 26, 103, 117, 105, 110, 116, 40, 116, 104, 105, 115, 46,
                 115, 105, 122, 101, 40, 41, 41, 32, 60, 32, 114, 117, 108, 101, 115, 46, 109,
                 105, 110, 95, 105, 116, 101, 109, 115, 32, 63, 32, 39, 109, 117, 115, 116, 32,
                 99, 111, 110, 116, 97, 105, 110, 32, 97, 116, 32, 108, 101, 97, 115, 116, 32, 37,
                 100, 32, 105, 116, 101, 109, 40, 115, 41, 39, 46, 102, 111, 114, 109, 97, 116,
                 40, 91, 114, 117, 108, 101, 115, 46, 109, 105, 110, 95, 105, 116, 101, 109, 115,
                 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "minItems",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "max_items",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_UINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 129, 1, 10, 18, 114, 101, 112, 101, 97, 116, 101, 100, 46, 109, 97, 120, 95,
                 105, 116, 101, 109, 115, 26, 107, 117, 105, 110, 116, 40, 116, 104, 105, 115, 46,
                 115, 105, 122, 101, 40, 41, 41, 32, 62, 32, 114, 117, 108, 101, 115, 46, 109, 97,
                 120, 95, 105, 116, 101, 109, 115, 32, 63, 32, 39, 109, 117, 115, 116, 32, 99,
                 111, 110, 116, 97, 105, 110, 32, 110, 111, 32, 109, 111, 114, 101, 32, 116, 104,
                 97, 110, 32, 37, 115, 32, 105, 116, 101, 109, 40, 115, 41, 39, 46, 102, 111, 114,
                 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 109, 97, 120, 95, 105, 116,
                 101, 109, 115, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "maxItems",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "unique",
          extendee: nil,
          number: 3,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 91, 10, 15, 114, 101, 112, 101, 97, 116, 101, 100, 46, 117, 110, 105, 113,
                 117, 101, 18, 40, 114, 101, 112, 101, 97, 116, 101, 100, 32, 118, 97, 108, 117,
                 101, 32, 109, 117, 115, 116, 32, 99, 111, 110, 116, 97, 105, 110, 32, 117, 110,
                 105, 113, 117, 101, 32, 105, 116, 101, 109, 115, 26, 30, 33, 114, 117, 108, 101,
                 115, 46, 117, 110, 105, 113, 117, 101, 32, 124, 124, 32, 116, 104, 105, 115, 46,
                 117, 110, 105, 113, 117, 101, 40, 41>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "unique",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "items",
          extendee: nil,
          number: 4,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.FieldRules",
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "items",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [
        %Google.Protobuf.DescriptorProto.ExtensionRange{
          start: 1000,
          end: 536_870_912,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      extension: [],
      options: nil,
      oneof_decl: [],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  field(:min_items, 1, optional: true, type: :uint64, json_name: "minItems", deprecated: false)
  field(:max_items, 2, optional: true, type: :uint64, json_name: "maxItems", deprecated: false)
  field(:unique, 3, optional: true, type: :bool, deprecated: false)
  field(:items, 4, optional: true, type: Buf.Validate.FieldRules)

  extensions([{1000, Protobuf.Extension.max()}])
end

defmodule Buf.Validate.MapRules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.MapRules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "MapRules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "min_pairs",
          extendee: nil,
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_UINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 119, 10, 13, 109, 97, 112, 46, 109, 105, 110, 95, 112, 97, 105, 114, 115, 26,
                 102, 117, 105, 110, 116, 40, 116, 104, 105, 115, 46, 115, 105, 122, 101, 40, 41,
                 41, 32, 60, 32, 114, 117, 108, 101, 115, 46, 109, 105, 110, 95, 112, 97, 105,
                 114, 115, 32, 63, 32, 39, 109, 97, 112, 32, 109, 117, 115, 116, 32, 98, 101, 32,
                 97, 116, 32, 108, 101, 97, 115, 116, 32, 37, 100, 32, 101, 110, 116, 114, 105,
                 101, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115,
                 46, 109, 105, 110, 95, 112, 97, 105, 114, 115, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "minPairs",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "max_pairs",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_UINT64,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 118, 10, 13, 109, 97, 112, 46, 109, 97, 120, 95, 112, 97, 105, 114, 115, 26,
                 101, 117, 105, 110, 116, 40, 116, 104, 105, 115, 46, 115, 105, 122, 101, 40, 41,
                 41, 32, 62, 32, 114, 117, 108, 101, 115, 46, 109, 97, 120, 95, 112, 97, 105, 114,
                 115, 32, 63, 32, 39, 109, 97, 112, 32, 109, 117, 115, 116, 32, 98, 101, 32, 97,
                 116, 32, 109, 111, 115, 116, 32, 37, 100, 32, 101, 110, 116, 114, 105, 101, 115,
                 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 109,
                 97, 120, 95, 112, 97, 105, 114, 115, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "maxPairs",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "keys",
          extendee: nil,
          number: 4,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.FieldRules",
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "keys",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "values",
          extendee: nil,
          number: 5,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.FieldRules",
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "values",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [
        %Google.Protobuf.DescriptorProto.ExtensionRange{
          start: 1000,
          end: 536_870_912,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      extension: [],
      options: nil,
      oneof_decl: [],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  field(:min_pairs, 1, optional: true, type: :uint64, json_name: "minPairs", deprecated: false)
  field(:max_pairs, 2, optional: true, type: :uint64, json_name: "maxPairs", deprecated: false)
  field(:keys, 4, optional: true, type: Buf.Validate.FieldRules)
  field(:values, 5, optional: true, type: Buf.Validate.FieldRules)

  extensions([{1000, Protobuf.Extension.max()}])
end

defmodule Buf.Validate.AnyRules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.AnyRules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "AnyRules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "in",
          extendee: nil,
          number: 2,
          label: :LABEL_REPEATED,
          type: :TYPE_STRING,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "in",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "not_in",
          extendee: nil,
          number: 3,
          label: :LABEL_REPEATED,
          type: :TYPE_STRING,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "notIn",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [],
      extension: [],
      options: nil,
      oneof_decl: [],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  field(:in, 2, repeated: true, type: :string)
  field(:not_in, 3, repeated: true, type: :string, json_name: "notIn")
end

defmodule Buf.Validate.DurationRules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.DurationRules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "DurationRules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "const",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".google.protobuf.Duration",
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 108, 10, 14, 100, 117, 114, 97, 116, 105, 111, 110, 46, 99, 111, 110, 115,
                 116, 26, 90, 116, 104, 105, 115, 32, 33, 61, 32, 103, 101, 116, 70, 105, 101,
                 108, 100, 40, 114, 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39,
                 41, 32, 63, 32, 39, 109, 117, 115, 116, 32, 101, 113, 117, 97, 108, 32, 37, 115,
                 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108,
                 100, 40, 114, 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39, 41, 93,
                 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "const",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lt",
          extendee: nil,
          number: 3,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".google.protobuf.Duration",
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 116, 10, 11, 100, 117, 114, 97, 116, 105, 111, 110, 46, 108, 116, 26, 101,
                 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32, 38, 38,
                 32, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32, 38, 38,
                 32, 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108, 116,
                 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116,
                 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lte",
          extendee: nil,
          number: 4,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".google.protobuf.Duration",
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 130, 1, 10, 12, 100, 117, 114, 97, 116, 105, 111, 110, 46, 108, 116, 101, 26,
                 114, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32,
                 38, 38, 32, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32,
                 38, 38, 32, 116, 104, 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 101, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115,
                 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111,
                 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101,
                 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gt",
          extendee: nil,
          number: 5,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".google.protobuf.Duration",
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 119, 10, 11, 100, 117, 114, 97, 116, 105, 111, 110, 46, 103, 116, 26, 104,
                 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32,
                 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38,
                 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116,
                 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101,
                 114, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40,
                 91, 114, 117, 108, 101, 115, 46, 103, 116, 93, 41, 32, 58, 32, 39, 39, 10, 176,
                 1, 10, 14, 100, 117, 114, 97, 116, 105, 111, 110, 46, 103, 116, 95, 108, 116, 26,
                 157, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38,
                 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 62, 61, 32, 114, 117, 108, 101,
                 115, 46, 103, 116, 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 61, 32, 114,
                 117, 108, 101, 115, 46, 108, 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60,
                 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115,
                 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110,
                 32, 37, 115, 32, 97, 110, 100, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32,
                 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115,
                 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32,
                 39, 39, 10, 184, 1, 10, 24, 100, 117, 114, 97, 116, 105, 111, 110, 46, 103, 116,
                 95, 108, 116, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26, 155, 1, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116,
                 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 61, 32, 116,
                 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108,
                 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103,
                 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 111, 114,
                 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111,
                 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32, 114,
                 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 192, 1, 10, 15,
                 100, 117, 114, 97, 116, 105, 111, 110, 46, 103, 116, 95, 108, 116, 101, 26, 172,
                 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38,
                 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 62, 61, 32, 114, 117, 108,
                 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 32, 114,
                 117, 108, 101, 115, 46, 108, 116, 101, 32, 124, 124, 32, 116, 104, 105, 115, 32,
                 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115,
                 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110,
                 32, 37, 115, 32, 97, 110, 100, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32,
                 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32,
                 114, 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 200,
                 1, 10, 25, 100, 117, 114, 97, 116, 105, 111, 110, 46, 103, 116, 95, 108, 116,
                 101, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26, 170, 1, 104, 97, 115,
                 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32,
                 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117,
                 108, 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32,
                 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 111,
                 114, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113,
                 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40,
                 91, 114, 117, 108, 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46,
                 108, 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gte",
          extendee: nil,
          number: 6,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".google.protobuf.Duration",
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 133, 1, 10, 12, 100, 117, 114, 97, 116, 105, 111, 110, 46, 103, 116, 101, 26,
                 117, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38,
                 32, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38,
                 38, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116,
                 101, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116,
                 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32,
                 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 103, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 191, 1, 10, 15,
                 100, 117, 114, 97, 116, 105, 111, 110, 46, 103, 116, 101, 95, 108, 116, 26, 171,
                 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32,
                 114, 117, 108, 101, 115, 46, 108, 116, 32, 62, 61, 32, 114, 117, 108, 101, 115,
                 46, 103, 116, 101, 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 61, 32, 114,
                 117, 108, 101, 115, 46, 108, 116, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60,
                 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115,
                 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110,
                 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 97, 110,
                 100, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102,
                 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44,
                 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 199,
                 1, 10, 25, 100, 117, 114, 97, 116, 105, 111, 110, 46, 103, 116, 101, 95, 108,
                 116, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26, 169, 1, 104, 97, 115,
                 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117, 108,
                 101, 115, 46, 108, 116, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101,
                 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 61, 32, 116,
                 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108,
                 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32,
                 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101,
                 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115,
                 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40,
                 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108, 101, 115,
                 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 207, 1, 10, 16, 100, 117, 114, 97,
                 116, 105, 111, 110, 46, 103, 116, 101, 95, 108, 116, 101, 26, 186, 1, 104, 97,
                 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 114,
                 117, 108, 101, 115, 46, 108, 116, 101, 32, 62, 61, 32, 114, 117, 108, 101, 115,
                 46, 103, 116, 101, 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 101, 32, 124, 124, 32, 116, 104, 105, 115, 32, 60,
                 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115,
                 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110,
                 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 97, 110,
                 100, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113,
                 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40,
                 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108, 101, 115,
                 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 215, 1, 10, 26, 100, 117, 114,
                 97, 116, 105, 111, 110, 46, 103, 116, 101, 95, 108, 116, 101, 95, 101, 120, 99,
                 108, 117, 115, 105, 118, 101, 26, 184, 1, 104, 97, 115, 40, 114, 117, 108, 101,
                 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 101, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 32, 38, 38, 32,
                 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32, 116, 104, 105, 115,
                 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97,
                 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108,
                 32, 116, 111, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104,
                 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39,
                 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116,
                 101, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39,
                 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "in",
          extendee: nil,
          number: 7,
          label: :LABEL_REPEATED,
          type: :TYPE_MESSAGE,
          type_name: ".google.protobuf.Duration",
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 107, 10, 11, 100, 117, 114, 97, 116, 105, 111, 110, 46, 105, 110, 26, 92, 33,
                 40, 116, 104, 105, 115, 32, 105, 110, 32, 103, 101, 116, 70, 105, 101, 108, 100,
                 40, 114, 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 41, 32, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37,
                 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101,
                 108, 100, 40, 114, 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 93, 41, 32,
                 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "in",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "not_in",
          extendee: nil,
          number: 8,
          label: :LABEL_REPEATED,
          type: :TYPE_MESSAGE,
          type_name: ".google.protobuf.Duration",
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 94, 10, 15, 100, 117, 114, 97, 116, 105, 111, 110, 46, 110, 111, 116, 95,
                 105, 110, 26, 75, 116, 104, 105, 115, 32, 105, 110, 32, 114, 117, 108, 101, 115,
                 46, 110, 111, 116, 95, 105, 110, 32, 63, 32, 39, 109, 117, 115, 116, 32, 110,
                 111, 116, 32, 98, 101, 32, 105, 110, 32, 108, 105, 115, 116, 32, 37, 115, 39, 46,
                 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 110, 111, 116,
                 95, 105, 110, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "notIn",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "example",
          extendee: nil,
          number: 9,
          label: :LABEL_REPEATED,
          type: :TYPE_MESSAGE,
          type_name: ".google.protobuf.Duration",
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 24, 10, 16, 100, 117, 114, 97, 116, 105, 111, 110, 46, 101, 120, 97, 109,
                 112, 108, 101, 26, 4, 116, 114, 117, 101>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "example",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [
        %Google.Protobuf.DescriptorProto.ExtensionRange{
          start: 1000,
          end: 536_870_912,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      extension: [],
      options: nil,
      oneof_decl: [
        %Google.Protobuf.OneofDescriptorProto{
          name: "less_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.OneofDescriptorProto{
          name: "greater_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  oneof(:less_than, 0)

  oneof(:greater_than, 1)

  field(:const, 2, optional: true, type: Google.Protobuf.Duration, deprecated: false)
  field(:lt, 3, optional: true, type: Google.Protobuf.Duration, oneof: 0, deprecated: false)
  field(:lte, 4, optional: true, type: Google.Protobuf.Duration, oneof: 0, deprecated: false)
  field(:gt, 5, optional: true, type: Google.Protobuf.Duration, oneof: 1, deprecated: false)
  field(:gte, 6, optional: true, type: Google.Protobuf.Duration, oneof: 1, deprecated: false)
  field(:in, 7, repeated: true, type: Google.Protobuf.Duration, deprecated: false)

  field(:not_in, 8,
    repeated: true,
    type: Google.Protobuf.Duration,
    json_name: "notIn",
    deprecated: false
  )

  field(:example, 9, repeated: true, type: Google.Protobuf.Duration, deprecated: false)

  extensions([{1000, Protobuf.Extension.max()}])
end

defmodule Buf.Validate.FieldMaskRules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.FieldMaskRules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "FieldMaskRules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "const",
          extendee: nil,
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".google.protobuf.FieldMask",
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 134, 1, 10, 16, 102, 105, 101, 108, 100, 95, 109, 97, 115, 107, 46, 99, 111,
                 110, 115, 116, 26, 114, 116, 104, 105, 115, 46, 112, 97, 116, 104, 115, 32, 33,
                 61, 32, 103, 101, 116, 70, 105, 101, 108, 100, 40, 114, 117, 108, 101, 115, 44,
                 32, 39, 99, 111, 110, 115, 116, 39, 41, 46, 112, 97, 116, 104, 115, 32, 63, 32,
                 39, 109, 117, 115, 116, 32, 101, 113, 117, 97, 108, 32, 112, 97, 116, 104, 115,
                 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105,
                 101, 108, 100, 40, 114, 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116,
                 39, 41, 46, 112, 97, 116, 104, 115, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "const",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "in",
          extendee: nil,
          number: 2,
          label: :LABEL_REPEATED,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 191, 1, 10, 13, 102, 105, 101, 108, 100, 95, 109, 97, 115, 107, 46, 105, 110,
                 26, 173, 1, 33, 116, 104, 105, 115, 46, 112, 97, 116, 104, 115, 46, 97, 108, 108,
                 40, 112, 44, 32, 112, 32, 105, 110, 32, 103, 101, 116, 70, 105, 101, 108, 100,
                 40, 114, 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 32, 124, 124, 32, 103,
                 101, 116, 70, 105, 101, 108, 100, 40, 114, 117, 108, 101, 115, 44, 32, 39, 105,
                 110, 39, 41, 46, 101, 120, 105, 115, 116, 115, 40, 102, 44, 32, 112, 46, 115,
                 116, 97, 114, 116, 115, 87, 105, 116, 104, 40, 102, 43, 39, 46, 39, 41, 41, 41,
                 32, 63, 32, 39, 109, 117, 115, 116, 32, 111, 110, 108, 121, 32, 99, 111, 110,
                 116, 97, 105, 110, 32, 112, 97, 116, 104, 115, 32, 105, 110, 32, 37, 115, 39, 46,
                 102, 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101, 108, 100, 40,
                 114, 117, 108, 101, 115, 44, 32, 39, 105, 110, 39, 41, 93, 41, 32, 58, 32, 39,
                 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "in",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "not_in",
          extendee: nil,
          number: 3,
          label: :LABEL_REPEATED,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 213, 1, 10, 17, 102, 105, 101, 108, 100, 95, 109, 97, 115, 107, 46, 110, 111,
                 116, 95, 105, 110, 26, 191, 1, 33, 116, 104, 105, 115, 46, 112, 97, 116, 104,
                 115, 46, 97, 108, 108, 40, 112, 44, 32, 33, 40, 112, 32, 105, 110, 32, 103, 101,
                 116, 70, 105, 101, 108, 100, 40, 114, 117, 108, 101, 115, 44, 32, 39, 110, 111,
                 116, 95, 105, 110, 39, 41, 32, 124, 124, 32, 103, 101, 116, 70, 105, 101, 108,
                 100, 40, 114, 117, 108, 101, 115, 44, 32, 39, 110, 111, 116, 95, 105, 110, 39,
                 41, 46, 101, 120, 105, 115, 116, 115, 40, 102, 44, 32, 112, 46, 115, 116, 97,
                 114, 116, 115, 87, 105, 116, 104, 40, 102, 43, 39, 46, 39, 41, 41, 41, 41, 32,
                 63, 32, 39, 109, 117, 115, 116, 32, 110, 111, 116, 32, 99, 111, 110, 116, 97,
                 105, 110, 32, 97, 110, 121, 32, 112, 97, 116, 104, 115, 32, 105, 110, 32, 37,
                 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101,
                 108, 100, 40, 114, 117, 108, 101, 115, 44, 32, 39, 110, 111, 116, 95, 105, 110,
                 39, 41, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "notIn",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "example",
          extendee: nil,
          number: 4,
          label: :LABEL_REPEATED,
          type: :TYPE_MESSAGE,
          type_name: ".google.protobuf.FieldMask",
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 26, 10, 18, 102, 105, 101, 108, 100, 95, 109, 97, 115, 107, 46, 101, 120, 97,
                 109, 112, 108, 101, 26, 4, 116, 114, 117, 101>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "example",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [
        %Google.Protobuf.DescriptorProto.ExtensionRange{
          start: 1000,
          end: 536_870_912,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      extension: [],
      options: nil,
      oneof_decl: [],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  field(:const, 1, optional: true, type: Google.Protobuf.FieldMask, deprecated: false)
  field(:in, 2, repeated: true, type: :string, deprecated: false)
  field(:not_in, 3, repeated: true, type: :string, json_name: "notIn", deprecated: false)
  field(:example, 4, repeated: true, type: Google.Protobuf.FieldMask, deprecated: false)

  extensions([{1000, Protobuf.Extension.max()}])
end

defmodule Buf.Validate.TimestampRules do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.TimestampRules",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "TimestampRules",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "const",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".google.protobuf.Timestamp",
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 109, 10, 15, 116, 105, 109, 101, 115, 116, 97, 109, 112, 46, 99, 111, 110,
                 115, 116, 26, 90, 116, 104, 105, 115, 32, 33, 61, 32, 103, 101, 116, 70, 105,
                 101, 108, 100, 40, 114, 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116,
                 39, 41, 32, 63, 32, 39, 109, 117, 115, 116, 32, 101, 113, 117, 97, 108, 32, 37,
                 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 103, 101, 116, 70, 105, 101,
                 108, 100, 40, 114, 117, 108, 101, 115, 44, 32, 39, 99, 111, 110, 115, 116, 39,
                 41, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "const",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lt",
          extendee: nil,
          number: 3,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".google.protobuf.Timestamp",
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 117, 10, 12, 116, 105, 109, 101, 115, 116, 97, 109, 112, 46, 108, 116, 26,
                 101, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 32,
                 38, 38, 32, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 41, 32,
                 38, 38, 32, 116, 104, 105, 115, 32, 62, 61, 32, 114, 117, 108, 101, 115, 46, 108,
                 116, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32,
                 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114,
                 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lte",
          extendee: nil,
          number: 4,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".google.protobuf.Timestamp",
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 131, 1, 10, 13, 116, 105, 109, 101, 115, 116, 97, 109, 112, 46, 108, 116,
                 101, 26, 114, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116, 101,
                 41, 32, 38, 38, 32, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 103, 116,
                 41, 32, 38, 38, 32, 116, 104, 105, 115, 32, 62, 32, 114, 117, 108, 101, 115, 46,
                 108, 116, 101, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115,
                 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116,
                 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "lte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "lt_now",
          extendee: nil,
          number: 7,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 79, 10, 16, 116, 105, 109, 101, 115, 116, 97, 109, 112, 46, 108, 116, 95,
                 110, 111, 119, 26, 59, 40, 114, 117, 108, 101, 115, 46, 108, 116, 95, 110, 111,
                 119, 32, 38, 38, 32, 116, 104, 105, 115, 32, 62, 32, 110, 111, 119, 41, 32, 63,
                 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 108, 101, 115, 115, 32, 116, 104,
                 97, 110, 32, 110, 111, 119, 39, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 0,
          json_name: "ltNow",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gt",
          extendee: nil,
          number: 5,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".google.protobuf.Timestamp",
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 120, 10, 12, 116, 105, 109, 101, 115, 116, 97, 109, 112, 46, 103, 116, 26,
                 104, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38,
                 32, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38,
                 38, 32, 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103,
                 116, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116,
                 101, 114, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97,
                 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 93, 41, 32, 58, 32, 39, 39,
                 10, 177, 1, 10, 15, 116, 105, 109, 101, 115, 116, 97, 109, 112, 46, 103, 116, 95,
                 108, 116, 26, 157, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116,
                 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 62, 61, 32, 114,
                 117, 108, 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62,
                 61, 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 124, 124, 32, 116, 104, 105,
                 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39, 109,
                 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104,
                 97, 110, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101, 115, 115, 32, 116, 104, 97,
                 110, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41,
                 32, 58, 32, 39, 39, 10, 185, 1, 10, 25, 116, 105, 109, 101, 115, 116, 97, 109,
                 112, 46, 103, 116, 95, 108, 116, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101,
                 26, 155, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38,
                 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 32, 114, 117, 108, 101,
                 115, 46, 103, 116, 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116, 32,
                 60, 61, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 61,
                 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39, 109, 117, 115, 116,
                 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 37,
                 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115,
                 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103,
                 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39,
                 10, 193, 1, 10, 16, 116, 105, 109, 101, 115, 116, 97, 109, 112, 46, 103, 116, 95,
                 108, 116, 101, 26, 172, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108,
                 116, 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 62,
                 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 116, 104, 105,
                 115, 32, 62, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 124, 124, 32,
                 116, 104, 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41,
                 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101,
                 114, 32, 116, 104, 97, 110, 32, 37, 115, 32, 97, 110, 100, 32, 108, 101, 115,
                 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116,
                 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108,
                 101, 115, 46, 103, 116, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 93,
                 41, 32, 58, 32, 39, 39, 10, 201, 1, 10, 26, 116, 105, 109, 101, 115, 116, 97,
                 109, 112, 46, 103, 116, 95, 108, 116, 101, 95, 101, 120, 99, 108, 117, 115, 105,
                 118, 101, 26, 170, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116,
                 101, 41, 32, 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32,
                 114, 117, 108, 101, 115, 46, 103, 116, 32, 38, 38, 32, 40, 114, 117, 108, 101,
                 115, 46, 108, 116, 101, 32, 60, 32, 116, 104, 105, 115, 32, 38, 38, 32, 116, 104,
                 105, 115, 32, 60, 61, 32, 114, 117, 108, 101, 115, 46, 103, 116, 41, 63, 32, 39,
                 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116,
                 104, 97, 110, 32, 37, 115, 32, 111, 114, 32, 108, 101, 115, 115, 32, 116, 104,
                 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39,
                 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116,
                 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gt",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gte",
          extendee: nil,
          number: 6,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".google.protobuf.Timestamp",
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 134, 1, 10, 13, 116, 105, 109, 101, 115, 116, 97, 109, 112, 46, 103, 116,
                 101, 26, 117, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41,
                 32, 38, 38, 32, 33, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101,
                 41, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117, 108, 101, 115, 46,
                 103, 116, 101, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101,
                 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97,
                 108, 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114,
                 117, 108, 101, 115, 46, 103, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 192, 1,
                 10, 16, 116, 105, 109, 101, 115, 116, 97, 109, 112, 46, 103, 116, 101, 95, 108,
                 116, 26, 171, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32,
                 38, 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 62, 61, 32, 114, 117, 108,
                 101, 115, 46, 103, 116, 101, 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62, 61,
                 32, 114, 117, 108, 101, 115, 46, 108, 116, 32, 124, 124, 32, 116, 104, 105, 115,
                 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117,
                 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97,
                 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 97,
                 110, 100, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46,
                 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101,
                 44, 32, 114, 117, 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10,
                 200, 1, 10, 26, 116, 105, 109, 101, 115, 116, 97, 109, 112, 46, 103, 116, 101,
                 95, 108, 116, 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26, 169, 1, 104,
                 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 41, 32, 38, 38, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116,
                 101, 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116, 32, 60, 61, 32,
                 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117,
                 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98,
                 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114,
                 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 111, 114, 32, 108,
                 101, 115, 115, 32, 116, 104, 97, 110, 32, 37, 115, 39, 46, 102, 111, 114, 109,
                 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 93, 41, 32, 58, 32, 39, 39, 10, 208, 1, 10, 17, 116,
                 105, 109, 101, 115, 116, 97, 109, 112, 46, 103, 116, 101, 95, 108, 116, 101, 26,
                 186, 1, 104, 97, 115, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38,
                 38, 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 62, 61, 32, 114, 117,
                 108, 101, 115, 46, 103, 116, 101, 32, 38, 38, 32, 40, 116, 104, 105, 115, 32, 62,
                 32, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 124, 124, 32, 116, 104, 105,
                 115, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109,
                 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104,
                 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32,
                 97, 110, 100, 32, 108, 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32,
                 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109,
                 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117,
                 108, 101, 115, 46, 108, 116, 101, 93, 41, 32, 58, 32, 39, 39, 10, 216, 1, 10, 27,
                 116, 105, 109, 101, 115, 116, 97, 109, 112, 46, 103, 116, 101, 95, 108, 116, 101,
                 95, 101, 120, 99, 108, 117, 115, 105, 118, 101, 26, 184, 1, 104, 97, 115, 40,
                 114, 117, 108, 101, 115, 46, 108, 116, 101, 41, 32, 38, 38, 32, 114, 117, 108,
                 101, 115, 46, 108, 116, 101, 32, 60, 32, 114, 117, 108, 101, 115, 46, 103, 116,
                 101, 32, 38, 38, 32, 40, 114, 117, 108, 101, 115, 46, 108, 116, 101, 32, 60, 32,
                 116, 104, 105, 115, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 32, 114, 117,
                 108, 101, 115, 46, 103, 116, 101, 41, 63, 32, 39, 109, 117, 115, 116, 32, 98,
                 101, 32, 103, 114, 101, 97, 116, 101, 114, 32, 116, 104, 97, 110, 32, 111, 114,
                 32, 101, 113, 117, 97, 108, 32, 116, 111, 32, 37, 115, 32, 111, 114, 32, 108,
                 101, 115, 115, 32, 116, 104, 97, 110, 32, 111, 114, 32, 101, 113, 117, 97, 108,
                 32, 116, 111, 32, 37, 115, 39, 46, 102, 111, 114, 109, 97, 116, 40, 91, 114, 117,
                 108, 101, 115, 46, 103, 116, 101, 44, 32, 114, 117, 108, 101, 115, 46, 108, 116,
                 101, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gte",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "gt_now",
          extendee: nil,
          number: 8,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 82, 10, 16, 116, 105, 109, 101, 115, 116, 97, 109, 112, 46, 103, 116, 95,
                 110, 111, 119, 26, 62, 40, 114, 117, 108, 101, 115, 46, 103, 116, 95, 110, 111,
                 119, 32, 38, 38, 32, 116, 104, 105, 115, 32, 60, 32, 110, 111, 119, 41, 32, 63,
                 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 103, 114, 101, 97, 116, 101, 114,
                 32, 116, 104, 97, 110, 32, 110, 111, 119, 39, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: 1,
          json_name: "gtNow",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "within",
          extendee: nil,
          number: 9,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".google.protobuf.Duration",
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 127, 10, 16, 116, 105, 109, 101, 115, 116, 97, 109, 112, 46, 119, 105, 116,
                 104, 105, 110, 26, 107, 116, 104, 105, 115, 32, 60, 32, 110, 111, 119, 45, 114,
                 117, 108, 101, 115, 46, 119, 105, 116, 104, 105, 110, 32, 124, 124, 32, 116, 104,
                 105, 115, 32, 62, 32, 110, 111, 119, 43, 114, 117, 108, 101, 115, 46, 119, 105,
                 116, 104, 105, 110, 32, 63, 32, 39, 109, 117, 115, 116, 32, 98, 101, 32, 119,
                 105, 116, 104, 105, 110, 32, 37, 115, 32, 111, 102, 32, 110, 111, 119, 39, 46,
                 102, 111, 114, 109, 97, 116, 40, 91, 114, 117, 108, 101, 115, 46, 119, 105, 116,
                 104, 105, 110, 93, 41, 32, 58, 32, 39, 39>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "within",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "example",
          extendee: nil,
          number: 10,
          label: :LABEL_REPEATED,
          type: :TYPE_MESSAGE,
          type_name: ".google.protobuf.Timestamp",
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
            __unknown_fields__: [
              {1160, 2,
               <<10, 25, 10, 17, 116, 105, 109, 101, 115, 116, 97, 109, 112, 46, 101, 120, 97,
                 109, 112, 108, 101, 26, 4, 116, 114, 117, 101>>}
            ],
            __protobuf__: true
          },
          oneof_index: nil,
          json_name: "example",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [
        %Google.Protobuf.DescriptorProto.ExtensionRange{
          start: 1000,
          end: 536_870_912,
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      extension: [],
      options: nil,
      oneof_decl: [
        %Google.Protobuf.OneofDescriptorProto{
          name: "less_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.OneofDescriptorProto{
          name: "greater_than",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  oneof(:less_than, 0)

  oneof(:greater_than, 1)

  field(:const, 2, optional: true, type: Google.Protobuf.Timestamp, deprecated: false)
  field(:lt, 3, optional: true, type: Google.Protobuf.Timestamp, oneof: 0, deprecated: false)
  field(:lte, 4, optional: true, type: Google.Protobuf.Timestamp, oneof: 0, deprecated: false)
  field(:lt_now, 7, optional: true, type: :bool, json_name: "ltNow", oneof: 0, deprecated: false)
  field(:gt, 5, optional: true, type: Google.Protobuf.Timestamp, oneof: 1, deprecated: false)
  field(:gte, 6, optional: true, type: Google.Protobuf.Timestamp, oneof: 1, deprecated: false)
  field(:gt_now, 8, optional: true, type: :bool, json_name: "gtNow", oneof: 1, deprecated: false)
  field(:within, 9, optional: true, type: Google.Protobuf.Duration, deprecated: false)
  field(:example, 10, repeated: true, type: Google.Protobuf.Timestamp, deprecated: false)

  extensions([{1000, Protobuf.Extension.max()}])
end

defmodule Buf.Validate.Violations do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.Violations",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "Violations",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "violations",
          extendee: nil,
          number: 1,
          label: :LABEL_REPEATED,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.Violation",
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "violations",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [],
      extension: [],
      options: nil,
      oneof_decl: [],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  field(:violations, 1, repeated: true, type: Buf.Validate.Violation)
end

defmodule Buf.Validate.Violation do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.Violation",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "Violation",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "field",
          extendee: nil,
          number: 5,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.FieldPath",
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "field",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "rule",
          extendee: nil,
          number: 6,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.FieldPath",
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "rule",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "rule_id",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_STRING,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "ruleId",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "message",
          extendee: nil,
          number: 3,
          label: :LABEL_OPTIONAL,
          type: :TYPE_STRING,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "message",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "for_key",
          extendee: nil,
          number: 4,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "forKey",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [],
      extension: [],
      options: nil,
      oneof_decl: [],
      reserved_range: [
        %Google.Protobuf.DescriptorProto.ReservedRange{
          start: 1,
          end: 2,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_name: ["field_path"],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  field(:field, 5, optional: true, type: Buf.Validate.FieldPath)
  field(:rule, 6, optional: true, type: Buf.Validate.FieldPath)
  field(:rule_id, 2, optional: true, type: :string, json_name: "ruleId")
  field(:message, 3, optional: true, type: :string)
  field(:for_key, 4, optional: true, type: :bool, json_name: "forKey")
end

defmodule Buf.Validate.FieldPath do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.FieldPath",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "FieldPath",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "elements",
          extendee: nil,
          number: 1,
          label: :LABEL_REPEATED,
          type: :TYPE_MESSAGE,
          type_name: ".buf.validate.FieldPathElement",
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "elements",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [],
      extension: [],
      options: nil,
      oneof_decl: [],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  field(:elements, 1, repeated: true, type: Buf.Validate.FieldPathElement)
end

defmodule Buf.Validate.FieldPathElement do
  @moduledoc false

  use Protobuf,
    full_name: "buf.validate.FieldPathElement",
    protoc_gen_elixir_version: "0.17.0",
    syntax: :proto2

  def descriptor do
    # credo:disable-for-next-line
    %Google.Protobuf.DescriptorProto{
      name: "FieldPathElement",
      field: [
        %Google.Protobuf.FieldDescriptorProto{
          name: "field_number",
          extendee: nil,
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_INT32,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "fieldNumber",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "field_name",
          extendee: nil,
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_STRING,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "fieldName",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "field_type",
          extendee: nil,
          number: 3,
          label: :LABEL_OPTIONAL,
          type: :TYPE_ENUM,
          type_name: ".google.protobuf.FieldDescriptorProto.Type",
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "fieldType",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "key_type",
          extendee: nil,
          number: 4,
          label: :LABEL_OPTIONAL,
          type: :TYPE_ENUM,
          type_name: ".google.protobuf.FieldDescriptorProto.Type",
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "keyType",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "value_type",
          extendee: nil,
          number: 5,
          label: :LABEL_OPTIONAL,
          type: :TYPE_ENUM,
          type_name: ".google.protobuf.FieldDescriptorProto.Type",
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "valueType",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "index",
          extendee: nil,
          number: 6,
          label: :LABEL_OPTIONAL,
          type: :TYPE_UINT64,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "index",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "bool_key",
          extendee: nil,
          number: 7,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "boolKey",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "int_key",
          extendee: nil,
          number: 8,
          label: :LABEL_OPTIONAL,
          type: :TYPE_INT64,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "intKey",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "uint_key",
          extendee: nil,
          number: 9,
          label: :LABEL_OPTIONAL,
          type: :TYPE_UINT64,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "uintKey",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "string_key",
          extendee: nil,
          number: 10,
          label: :LABEL_OPTIONAL,
          type: :TYPE_STRING,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: 0,
          json_name: "stringKey",
          proto3_optional: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      nested_type: [],
      enum_type: [],
      extension_range: [],
      extension: [],
      options: nil,
      oneof_decl: [
        %Google.Protobuf.OneofDescriptorProto{
          name: "subscript",
          options: nil,
          __unknown_fields__: [],
          __protobuf__: true
        }
      ],
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  oneof(:subscript, 0)

  field(:field_number, 1, optional: true, type: :int32, json_name: "fieldNumber")
  field(:field_name, 2, optional: true, type: :string, json_name: "fieldName")

  field(:field_type, 3,
    optional: true,
    type: Google.Protobuf.FieldDescriptorProto.Type,
    json_name: "fieldType",
    enum: true
  )

  field(:key_type, 4,
    optional: true,
    type: Google.Protobuf.FieldDescriptorProto.Type,
    json_name: "keyType",
    enum: true
  )

  field(:value_type, 5,
    optional: true,
    type: Google.Protobuf.FieldDescriptorProto.Type,
    json_name: "valueType",
    enum: true
  )

  field(:index, 6, optional: true, type: :uint64, oneof: 0)
  field(:bool_key, 7, optional: true, type: :bool, json_name: "boolKey", oneof: 0)
  field(:int_key, 8, optional: true, type: :int64, json_name: "intKey", oneof: 0)
  field(:uint_key, 9, optional: true, type: :uint64, json_name: "uintKey", oneof: 0)
  field(:string_key, 10, optional: true, type: :string, json_name: "stringKey", oneof: 0)
end
