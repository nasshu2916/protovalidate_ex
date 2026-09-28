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

  field :id, 1, optional: true, type: :string
  field :message, 2, optional: true, type: :string
  field :expression, 3, optional: true, type: :string
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
          options: nil,
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
          options: nil,
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
          options: nil,
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
          options: nil,
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
          options: nil,
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
          options: nil,
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
          options: nil,
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
          options: nil,
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
          options: nil,
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
          options: nil,
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
          options: nil,
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
          options: nil,
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
          number: 11,
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
        },
        %Google.Protobuf.FieldDescriptorProto{
          name: "uuid",
          extendee: nil,
          number: 22,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "uuid",
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
          options: nil,
          oneof_index: nil,
          json_name: "email",
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

  field :const, 1, optional: true, type: :string
  field :len, 19, optional: true, type: :uint64
  field :min_len, 2, optional: true, type: :uint64, json_name: "minLen"
  field :max_len, 3, optional: true, type: :uint64, json_name: "maxLen"
  field :len_bytes, 20, optional: true, type: :uint64, json_name: "lenBytes"
  field :min_bytes, 4, optional: true, type: :uint64, json_name: "minBytes"
  field :max_bytes, 5, optional: true, type: :uint64, json_name: "maxBytes"
  field :pattern, 6, optional: true, type: :string
  field :prefix, 7, optional: true, type: :string
  field :suffix, 8, optional: true, type: :string
  field :contains, 9, optional: true, type: :string
  field :not_contains, 23, optional: true, type: :string, json_name: "notContains"
  field :in, 10, repeated: true, type: :string
  field :not_in, 11, repeated: true, type: :string, json_name: "notIn"
  field :uuid, 22, optional: true, type: :bool
  field :email, 12, optional: true, type: :bool
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
          options: nil,
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
          options: nil,
          oneof_index: nil,
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
          options: nil,
          oneof_index: nil,
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
          options: nil,
          oneof_index: nil,
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
          options: nil,
          oneof_index: nil,
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
          number: 7,
          label: :LABEL_REPEATED,
          type: :TYPE_UINT32,
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

  field :const, 1, optional: true, type: :uint32
  field :lt, 2, optional: true, type: :uint32
  field :lte, 3, optional: true, type: :uint32
  field :gt, 4, optional: true, type: :uint32
  field :gte, 5, optional: true, type: :uint32
  field :in, 6, repeated: true, type: :uint32
  field :not_in, 7, repeated: true, type: :uint32, json_name: "notIn"
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
          options: nil,
          oneof_index: nil,
          json_name: "const",
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

  field :const, 1, optional: true, type: :bool
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
          options: nil,
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
          number: 4,
          label: :LABEL_REPEATED,
          type: :TYPE_INT32,
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

  field :const, 1, optional: true, type: :int32
  field :defined_only, 2, optional: true, type: :bool, json_name: "definedOnly"
  field :in, 3, repeated: true, type: :int32
  field :not_in, 4, repeated: true, type: :int32, json_name: "notIn"
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
          name: "gt_now",
          extendee: nil,
          number: 8,
          label: :LABEL_OPTIONAL,
          type: :TYPE_BOOL,
          type_name: nil,
          default_value: nil,
          options: nil,
          oneof_index: nil,
          json_name: "gtNow",
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

  field :gt_now, 8, optional: true, type: :bool, json_name: "gtNow"
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
      reserved_range: [],
      reserved_name: [],
      __unknown_fields__: [],
      __protobuf__: true
    }
  end

  oneof :type, 0

  field :uint32, 5, optional: true, type: Buf.Validate.UInt32Rules, oneof: 0
  field :bool, 13, optional: true, type: Buf.Validate.BoolRules, oneof: 0
  field :string, 14, optional: true, type: Buf.Validate.StringRules, oneof: 0
  field :enum, 16, optional: true, type: Buf.Validate.EnumRules, oneof: 0
  field :timestamp, 22, optional: true, type: Buf.Validate.TimestampRules, oneof: 0
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

  field :cel, 3, repeated: true, type: Buf.Validate.Rule
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

  field :required, 1, optional: true, type: :bool
end
