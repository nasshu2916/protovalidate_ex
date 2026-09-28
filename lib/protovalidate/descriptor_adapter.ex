defmodule Protovalidate.DescriptorAdapter do
  @moduledoc """
  Converts generated `protobuf` descriptors into a stable representation for validation.

  This module relies only on `protobuf`'s `descriptor/0` and `__message_props__/0`
  as its integration boundary. Set `gen_descriptors=true` when generating messages.
  """

  alias Google.Protobuf.{DescriptorProto, FieldDescriptorProto}
  alias Protovalidate.CompilationError

  defmodule Message do
    @moduledoc false

    @enforce_keys [:module, :full_name, :fields, :oneofs, :validation]
    defstruct [:module, :full_name, :fields, :oneofs, :validation]

    @type t :: %__MODULE__{
            module: module(),
            full_name: String.t(),
            fields: [Protovalidate.DescriptorAdapter.Field.t()],
            oneofs: [Protovalidate.DescriptorAdapter.Oneof.t()],
            validation: map()
          }
  end

  defmodule Field do
    @moduledoc false

    @enforce_keys [
      :name,
      :json_name,
      :number,
      :type,
      :repeated?,
      :map?,
      :oneof,
      :presence,
      :well_known_type,
      :validation
    ]
    defstruct [
      :name,
      :json_name,
      :number,
      :type,
      :repeated?,
      :map?,
      :type_name,
      :reference,
      :map_key_field,
      :map_value_field,
      :item_type,
      :map_key,
      :map_value,
      :enum_values,
      :oneof,
      :presence,
      :well_known_type,
      :validation,
      :semantic_type,
      :access_key,
      :default,
      :features
    ]

    @type presence() :: :implicit | :required | :oneof | :explicit | :collection
    @type semantic_type() ::
            {:scalar, atom()}
            | {:enum, String.t() | nil, [integer()]}
            | {:message, String.t() | nil, well_known_type()}
            | {:list, semantic_type()}
            | {:map, semantic_type(), semantic_type()}
    @type well_known_type() ::
            :any | :duration | :timestamp | :field_mask | {:wrapper, atom()} | nil
    @type t :: %__MODULE__{
            name: String.t(),
            json_name: String.t(),
            number: pos_integer(),
            type: atom(),
            type_name: String.t() | nil,
            reference: module() | nil,
            map_key_field: t() | nil,
            map_value_field: t() | nil,
            repeated?: boolean(),
            map?: boolean(),
            item_type: atom() | nil,
            map_key: atom() | nil,
            map_value: atom() | nil,
            enum_values: [integer()] | nil,
            oneof: String.t() | nil,
            presence: presence(),
            well_known_type: well_known_type(),
            validation: map(),
            semantic_type: semantic_type(),
            access_key: atom(),
            default: any(),
            features: map()
          }
  end

  defmodule Oneof do
    @moduledoc false

    @enforce_keys [:name, :fields, :validation]
    defstruct [:name, :fields, :validation]

    @type t :: %__MODULE__{name: String.t(), fields: [String.t()], validation: map()}
  end

  @type extension() :: {atom(), module(), atom()}

  @doc """
  Normalizes a generated message module.

  Pass `{name, extension_module, field_name}` tuples in `:extensions`. For example,
  `{:field, Buf.Validate.PbExtension, :field}` restores the value from the matching
  option and stores it in `validation`.
  """
  @spec describe(module(), keyword()) :: map()
  def describe(module, opts \\ []) when is_atom(module) do
    extensions = Keyword.get(opts, :extensions, [])
    descriptor = descriptor!(module)
    message_props = message_props!(module)
    context = descriptor_context(module, message_props)
    oneofs = build_oneofs(descriptor, extensions)

    %Message{
      module: module,
      full_name: full_name!(module),
      fields:
        Enum.map(descriptor.field, fn field ->
          build_field(field, descriptor, message_props, oneofs, extensions, context)
        end),
      oneofs: oneofs,
      validation: extensions_for(descriptor.options, extensions)
    }
  rescue
    _error in [
      ArgumentError,
      BadMapError,
      FunctionClauseError,
      KeyError,
      MatchError,
      Protocol.UndefinedError,
      UndefinedFunctionError
    ] ->
      # 生成済みモジュールの不整合を呼び出し側が扱えるコンパイルエラーに正規化する。
      # credo:disable-for-next-line Credo.Check.Warning.RaiseInsideRescue
      raise CompilationError, message: descriptor_error_message()
  end

  @doc """
  Returns the actual field presence in a message value.
  """
  @spec field_presence(struct(), atom()) :: Protobuf.field_presence()
  def field_presence(message, field) when is_atom(field) do
    case Protobuf.field_presence(message, field) do
      :maybe -> wire_presence(message, field)
      presence -> presence
    end
  end

  # protobuf の :maybe は custom default が wire に含まれたか判断できない状態を表す。
  defp wire_presence(message, field) do
    case Map.get(message, :__protovalidate_wire_presence__, %{}) do
      %{^field => {value, present?}} ->
        if Map.get(message, field) == value do
          if present?, do: :present, else: :not_present
        else
          :maybe
        end

      _presence ->
        :maybe
    end
  end

  @doc false
  @spec field_value(struct(), Field.t()) :: any()
  def field_value(message, field) do
    atom = field.access_key || String.to_existing_atom(field.name)

    if field.oneof do
      case Map.fetch!(message, String.to_existing_atom(field.oneof)) do
        {^atom, value} -> value
        _ -> nil
      end
    else
      Map.fetch!(message, atom)
    end
  end

  @doc false
  @spec enum_value(Field.t(), any()) :: any()
  def enum_value(%{type: :TYPE_ENUM, reference: module}, value)
      when not is_nil(module) and is_atom(value) and not is_nil(value),
      do: module.value(value)

  def enum_value(_field, value), do: value

  @doc false
  @spec collection_field(Field.t(), :items | :keys | :values) :: Field.t()
  def collection_field(field, kind) do
    source =
      case kind do
        :items -> %{field | type: field.item_type || field.type}
        :keys -> field.map_key_field || %{field | type: field.map_key}
        :values -> field.map_value_field || %{field | type: field.map_value}
      end

    semantic_type =
      case {kind, field.semantic_type} do
        {:items, {:list, item}} -> item
        {:keys, {:map, key, _value}} -> key
        {:values, {:map, _key, value}} -> value
        _ -> source.semantic_type
      end

    # collection の要素は常に実在する値であり、未設定 scalar とは意味が異なる。
    %{
      source
      | name: field.name,
        repeated?: false,
        map?: false,
        presence: :collection,
        semantic_type: semantic_type,
        access_key: field.access_key
    }
  end

  @doc false
  def default_value(%Field{
        default: nil,
        semantic_type: {:message, _name, nil},
        reference: module
      })
      when not is_nil(module),
      do: struct!(module)

  def default_value(%Field{default: default}), do: default

  @doc false
  @spec map_key_type(atom()) :: :string | :bool | :int | :uint
  def map_key_type(:TYPE_STRING), do: :string
  def map_key_type(:TYPE_BOOL), do: :bool

  def map_key_type(type)
      when type in [
             :TYPE_INT32,
             :TYPE_INT64,
             :TYPE_SINT32,
             :TYPE_SINT64,
             :TYPE_SFIXED32,
             :TYPE_SFIXED64
           ],
      do: :int

  def map_key_type(type) when type in [:TYPE_UINT32, :TYPE_UINT64, :TYPE_FIXED32, :TYPE_FIXED64],
    do: :uint

  defp reference(%{type: {:enum, module}}), do: module
  defp reference(%{embedded?: true, type: module}), do: module
  defp reference(_props), do: nil

  defp entry_fields(%{map?: true, type: module}) do
    fields = describe(module).fields
    {Enum.find(fields, &(&1.name == "key")), Enum.find(fields, &(&1.name == "value"))}
  end

  defp entry_fields(_props), do: {nil, nil}

  defp descriptor!(module) do
    Code.ensure_loaded!(module)

    unless function_exported?(module, :descriptor, 0) do
      raise ArgumentError,
            "#{inspect(module)} does not define descriptor/0; pass gen_descriptors=true to protoc"
    end

    case callback!(module, :descriptor) do
      %DescriptorProto{} = descriptor ->
        descriptor

      _descriptor ->
        raise ArgumentError, descriptor_error_message()
    end
  end

  defp message_props!(module) do
    Code.ensure_loaded!(module)

    unless function_exported?(module, :__message_props__, 0) do
      raise ArgumentError, "#{inspect(module)} does not define a protobuf message"
    end

    case callback!(module, :__message_props__) do
      %{field_props: field_props, syntax: _syntax} = message_props when is_map(field_props) ->
        message_props

      _message_props ->
        raise ArgumentError, descriptor_error_message()
    end
  end

  defp full_name!(module) do
    Code.ensure_loaded!(module)

    unless function_exported?(module, :full_name, 0) do
      raise ArgumentError, descriptor_error_message()
    end

    case callback!(module, :full_name) do
      full_name when is_binary(full_name) and byte_size(full_name) > 0 -> full_name
      _full_name -> raise ArgumentError, descriptor_error_message()
    end
  end

  # 生成済みモジュールの callback は外部境界なので、実装依存の例外値を公開しない。
  defp callback!(module, function) do
    apply(module, function, [])
  rescue
    _error -> raise CompilationError, message: descriptor_error_message()
  catch
    _kind, _value -> raise CompilationError, message: descriptor_error_message()
  end

  defp descriptor_error_message, do: "invalid Protobuf message descriptor"

  defp build_field(field, descriptor, message_props, oneofs, extensions, context) do
    props = Map.fetch!(message_props.field_props, field.number)
    {key, value} = entry_fields(props)

    base_type = semantic_leaf(type(field), field.type_name, reference(props), enum_values(props))
    semantic_type = collection_type(props, base_type, key, value)
    features = resolved_features(context, field)

    %Field{
      name: field.name,
      json_name: field.json_name,
      number: field.number,
      type: type(field),
      type_name: field.type_name,
      reference: reference(props),
      map_key_field: key,
      map_value_field: value,
      repeated?: props.repeated?,
      map?: props.map?,
      item_type: if(props.repeated? and not props.map?, do: type(field)),
      map_key: key && key.type,
      map_value: value && value.type,
      enum_values: enum_values(props),
      oneof: oneof_name(field, descriptor, oneofs),
      presence: presence(props, message_props.syntax, features),
      well_known_type: well_known_type(field.type_name),
      validation: extensions_for(field.options, extensions),
      semantic_type: semantic_type,
      access_key: props.name_atom,
      default: semantic_default(props, semantic_type),
      features: features
    }
  end

  defp collection_type(%{map?: true}, _base, key, value),
    do: {:map, key.semantic_type, value.semantic_type}

  defp collection_type(%{repeated?: true}, base, _key, _value), do: {:list, base}
  defp collection_type(_props, base, _key, _value), do: base

  defp semantic_leaf(:TYPE_ENUM, name, _reference, values),
    do: {:enum, name, values || []}

  defp semantic_leaf(type, name, _reference, _values)
       when type in [:TYPE_MESSAGE, :TYPE_GROUP],
       do: {:message, name, well_known_type(name)}

  defp semantic_leaf(type, _name, _reference, _values), do: {:scalar, type}

  defp semantic_default(%{map?: true}, _type), do: %{}
  defp semantic_default(%{repeated?: true}, _type), do: []
  defp semantic_default(%{default: default}, _type) when not is_nil(default), do: default
  defp semantic_default(_props, {:message, _, _}), do: nil

  defp semantic_default(_props, {:scalar, type}) when type in [:TYPE_FLOAT, :TYPE_DOUBLE], do: 0.0
  defp semantic_default(_props, {:scalar, type}) when type in [:TYPE_STRING, :TYPE_BYTES], do: ""
  defp semantic_default(_props, {:scalar, :TYPE_BOOL}), do: false
  defp semantic_default(_props, {:enum, _, _}), do: 0
  defp semantic_default(_props, _type), do: 0

  defp descriptor_context(module, message_props) do
    default = %{syntax: Map.get(message_props, :syntax), edition: nil, features: %{}}

    if function_exported?(module, :__protovalidate_descriptor_context__, 0) do
      Map.merge(default, callback!(module, :__protovalidate_descriptor_context__))
    else
      default
    end
  end

  defp resolved_features(context, field) do
    inherited = Map.get(context, :features, %{})
    local = field.options && Map.get(field.options, :features)

    inherited
    |> Map.merge(feature_map(local))
    |> Map.put_new(:field_presence, syntax_presence(Map.get(context, :syntax)))
    |> Map.put(:edition, Map.get(context, :edition))
    |> Map.put(:message_encoding, message_encoding(field, local, inherited))
  end

  defp feature_map(nil), do: %{}

  defp feature_map(features) do
    features
    |> Map.from_struct()
    |> Map.drop([:__unknown_fields__, :__protobuf__])
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Map.new()
  end

  defp syntax_presence(:proto2), do: :EXPLICIT
  defp syntax_presence(_syntax), do: :IMPLICIT

  defp message_encoding(%{type: :TYPE_GROUP}, _local, _inherited), do: :DELIMITED

  defp message_encoding(_field, local, inherited),
    do:
      Map.get(
        feature_map(local),
        :message_encoding,
        Map.get(inherited, :message_encoding, :LENGTH_PREFIXED)
      )

  defp build_oneofs(descriptor, extensions) do
    descriptor.oneof_decl
    |> Enum.with_index()
    |> Enum.map(fn {oneof, index} ->
      %Oneof{
        name: oneof.name,
        fields:
          for(
            %FieldDescriptorProto{name: name, oneof_index: ^index} <- descriptor.field,
            do: name
          ),
        validation: extensions_for(oneof.options, extensions)
      }
    end)
  end

  defp type(%FieldDescriptorProto{type: type}), do: type

  defp enum_values(%{enum?: true, type: {:enum, module}}) do
    Code.ensure_loaded!(module)

    module.descriptor()
    |> Map.fetch!(:value)
    |> Enum.map(& &1.number)
  end

  defp enum_values(_props), do: nil

  # proto3 optional は synthetic oneof で表現されるため、通常の oneof として評価しない。
  defp oneof_name(%FieldDescriptorProto{proto3_optional: true}, _descriptor, _oneofs), do: nil

  defp oneof_name(%FieldDescriptorProto{oneof_index: nil}, _descriptor, _oneofs), do: nil

  defp oneof_name(%FieldDescriptorProto{oneof_index: index}, _descriptor, oneofs) do
    oneofs |> Enum.at(index) |> Map.fetch!(:name)
  end

  defp presence(%{repeated?: true}, _syntax, _features), do: :implicit
  defp presence(%{map?: true}, _syntax, _features), do: :implicit
  defp presence(%{required?: true}, _syntax, _features), do: :required
  defp presence(%{proto3_optional?: true}, _syntax, _features), do: :explicit
  defp presence(%{oneof: oneof}, _syntax, _features) when not is_nil(oneof), do: :oneof
  defp presence(%{embedded?: true}, _syntax, _features), do: :explicit
  defp presence(_props, _syntax, %{field_presence: :LEGACY_REQUIRED}), do: :required
  defp presence(_props, _syntax, %{field_presence: :EXPLICIT}), do: :explicit
  defp presence(%{optional?: true}, :proto2, _features), do: :explicit
  defp presence(_props, _syntax, _features), do: :implicit

  defp well_known_type(".google.protobuf.Any"), do: :any
  defp well_known_type(".google.protobuf.Timestamp"), do: :timestamp
  defp well_known_type(".google.protobuf.Duration"), do: :duration
  defp well_known_type(".google.protobuf.FieldMask"), do: :field_mask
  defp well_known_type(".google.protobuf.DoubleValue"), do: {:wrapper, :TYPE_DOUBLE}
  defp well_known_type(".google.protobuf.FloatValue"), do: {:wrapper, :TYPE_FLOAT}
  defp well_known_type(".google.protobuf.Int64Value"), do: {:wrapper, :TYPE_INT64}
  defp well_known_type(".google.protobuf.UInt64Value"), do: {:wrapper, :TYPE_UINT64}
  defp well_known_type(".google.protobuf.Int32Value"), do: {:wrapper, :TYPE_INT32}
  defp well_known_type(".google.protobuf.UInt32Value"), do: {:wrapper, :TYPE_UINT32}
  defp well_known_type(".google.protobuf.BoolValue"), do: {:wrapper, :TYPE_BOOL}
  defp well_known_type(".google.protobuf.StringValue"), do: {:wrapper, :TYPE_STRING}
  defp well_known_type(".google.protobuf.BytesValue"), do: {:wrapper, :TYPE_BYTES}
  defp well_known_type(_type_name), do: nil

  defp extensions_for(nil, _extensions), do: %{}
  defp extensions_for(_options, []), do: %{}

  defp extensions_for(options, extensions) do
    Protobuf.load_extensions()
    encoded_options = Protobuf.encode(options)
    decoded_options = options.__struct__.decode(encoded_options)

    Map.new(extensions, fn {name, extension_module, field} ->
      {name, options.__struct__.get_extension(decoded_options, extension_module, field)}
    end)
  end
end
