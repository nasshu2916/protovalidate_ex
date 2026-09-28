defmodule Protovalidate.Conformance.RuntimeDescriptorAdapter do
  @moduledoc false

  alias Google.Protobuf.{
    EnumDescriptorProto,
    FieldDescriptorProto,
    FileDescriptorSet
  }

  alias Protovalidate.PredefinedRuleRegistry

  import Bitwise, only: [band: 2, bor: 2, bsl: 2, bsr: 2]

  @max_wire_nesting_depth 100
  @wire_presence_key :__protovalidate_wire_presence__

  @scalar_types %{
    TYPE_DOUBLE: :double,
    TYPE_FLOAT: :float,
    TYPE_INT64: :int64,
    TYPE_UINT64: :uint64,
    TYPE_INT32: :int32,
    TYPE_FIXED64: :fixed64,
    TYPE_FIXED32: :fixed32,
    TYPE_BOOL: :bool,
    TYPE_STRING: :string,
    TYPE_BYTES: :bytes,
    TYPE_UINT32: :uint32,
    TYPE_SFIXED32: :sfixed32,
    TYPE_SFIXED64: :sfixed64,
    TYPE_SINT32: :sint32,
    TYPE_SINT64: :sint64
  }

  @spec decode(FileDescriptorSet.t(), Google.Protobuf.Any.t()) :: struct()
  def decode(%FileDescriptorSet{} = fdset, %Google.Protobuf.Any{} = any) do
    {message, _registry} = decode_with_registry(fdset, any)
    message
  end

  @spec decode_with_registry(FileDescriptorSet.t(), Google.Protobuf.Any.t()) ::
          {struct(), PredefinedRuleRegistry.t()}
  def decode_with_registry(%FileDescriptorSet{} = fdset, %Google.Protobuf.Any{} = any) do
    Protobuf.load_extensions()
    {modules, registry} = :global.trans({__MODULE__, self()}, fn -> build_modules(fdset) end)
    type_name = any.type_url |> String.split("/") |> List.last() |> then(&("." <> &1))
    module = Map.fetch!(modules, type_name)
    wire_value = normalize_message_wire(any.value, module, modules)
    message = module.decode(wire_value)
    {preserve_wire_presence(message, [any.value], module, modules), registry}
  end

  defp build_modules(%FileDescriptorSet{file: files}) do
    schema_id = :crypto.hash(:sha256, :erlang.term_to_binary(files))
    definitions = Enum.flat_map(files, &(message_definitions(&1) ++ enum_definitions(&1)))

    modules =
      Map.new(definitions, fn {_kind, name, _descriptor, _syntax, _context} ->
        {name, runtime_module(name, schema_id)}
      end)

    registry = register_extensions(files, modules, schema_id)

    definitions
    |> Enum.sort_by(fn {kind, name, _, _, _} ->
      {kind != :enum, -length(String.split(name, "."))}
    end)
    |> Enum.each(fn
      {:message, name, descriptor, syntax, context} ->
        create_message_module!(
          Map.fetch!(modules, name),
          name,
          descriptor,
          syntax,
          context,
          modules
        )

      {:enum, name, descriptor, syntax, _context} ->
        create_enum_module!(Map.fetch!(modules, name), name, descriptor, syntax)
    end)

    {modules, registry}
  end

  defp register_extensions(files, modules, schema_id) do
    extensions =
      files
      |> Enum.flat_map(&file_extensions/1)
      |> Enum.filter(fn {field, _syntax} ->
        String.starts_with?(field.extendee, ".buf.validate.")
      end)

    extension_module = runtime_module(".extensions", schema_id)

    unless extensions == [] or Code.ensure_loaded?(extension_module) do
      fields =
        Enum.map(extensions, fn {field, syntax} ->
          extendee = extension_type(field.extendee, modules)
          packed? = packed_extension?(field, syntax)

          # protobuf の extension decoder は packed 値を展開しないので raw bytes として受ける。
          type =
            if packed?,
              do: :bytes,
              else: Map.get(@scalar_types, field.type) || extension_type(field.type_name, modules)

          options = [
            type: type,
            optional: field.label != :LABEL_REPEATED or packed?,
            repeated: field.label == :LABEL_REPEATED and not packed?,
            enum: field.type == :TYPE_ENUM and not packed?
          ]

          quote do
            Protobuf.DSL.extend(
              unquote(extendee),
              unquote(field.name |> String.split(".") |> List.last() |> String.to_atom()),
              unquote(field.number),
              unquote(options)
            )
          end
        end)

      Module.create(
        extension_module,
        quote do
          use Protobuf, syntax: :proto2
          unquote_splicing(fields)
        end,
        Macro.Env.location(__ENV__)
      )
    end

    if extensions != [] do
      for {{extendee, number}, _props} <-
            extension_module.__protobuf_info__(:extension_props).extensions do
        :persistent_term.put({Protobuf.Extension, extendee, number}, extension_module)
      end
    end

    entries =
      extensions
      |> Enum.flat_map(fn {field, _syntax} ->
        rule_type = extension_type(field.extendee, modules)

        case predefined_rules(field.options) do
          [] ->
            []

          rules ->
            [{{rule_type, field.number}, %{rule_type: rule_type, cel: rules, descriptor: field}}]
        end
      end)
      |> Map.new()

    PredefinedRuleRegistry.new(entries)
  end

  defp file_extensions(file) do
    prefix = if file.package in [nil, ""], do: "", else: file.package <> "."

    qualify_extensions(file.extension, prefix, file.syntax) ++
      Enum.flat_map(file.message_type, &message_extensions(&1, prefix, file.syntax))
  end

  defp message_extensions(message, prefix, syntax) do
    prefix = prefix <> message.name <> "."

    qualify_extensions(message.extension, prefix, syntax) ++
      Enum.flat_map(message.nested_type, &message_extensions(&1, prefix, syntax))
  end

  defp qualify_extensions(fields, prefix, syntax),
    do: Enum.map(fields, &{%{&1 | name: prefix <> &1.name}, syntax})

  defp packed_extension?(%{label: :LABEL_REPEATED, type: type, options: options}, syntax)
       when type not in [:TYPE_STRING, :TYPE_BYTES, :TYPE_MESSAGE, :TYPE_GROUP] do
    case options && options.packed do
      nil -> syntax in ["proto3", "editions"]
      packed -> packed
    end
  end

  defp packed_extension?(_field, _syntax), do: false

  defp extension_type(name, modules) do
    generated =
      name
      |> String.trim_leading(".")
      |> String.split(".")
      |> Enum.map(&Macro.camelize/1)
      |> Module.concat()

    if Code.ensure_loaded?(generated) and function_exported?(generated, :descriptor, 0),
      do: generated,
      else: Map.get(modules, name, generated)
  end

  defp predefined_rules(nil), do: []

  defp predefined_rules(options) do
    options = options |> Protobuf.encode() |> Google.Protobuf.FieldOptions.decode()

    case Google.Protobuf.FieldOptions.get_extension(
           options,
           Buf.Validate.PbExtension,
           :predefined
         ) do
      %Buf.Validate.PredefinedRules{cel: rules} -> rules
      _ -> []
    end
  end

  defp package_prefix(package) when package in [nil, ""], do: ""
  defp package_prefix(package), do: "." <> package
  defp syntax(value) when value in [nil, ""], do: "proto2"
  defp syntax(value), do: value

  defp message_definitions(file) do
    context = file_context(file)

    Enum.flat_map(
      file.message_type,
      &message_definitions(&1, package_prefix(file.package), syntax(file.syntax), context)
    )
  end

  defp message_definitions(descriptor, parent, syntax, inherited_context) do
    name = parent <> "." <> descriptor.name
    context = inherit_context(inherited_context, descriptor.options)

    [
      {:message, name, descriptor, syntax, context}
      | Enum.flat_map(descriptor.nested_type, &message_definitions(&1, name, syntax, context))
    ]
  end

  defp enum_definitions(file) do
    parent = package_prefix(file.package)
    syntax = syntax(file.syntax)

    context = file_context(file)

    enum_definitions(file.enum_type, parent, syntax, context) ++
      Enum.flat_map(file.message_type, &nested_enum_definitions(&1, parent, syntax, context))
  end

  defp nested_enum_definitions(descriptor, parent, syntax, inherited_context) do
    name = parent <> "." <> descriptor.name
    context = inherit_context(inherited_context, descriptor.options)

    enum_definitions(descriptor.enum_type, name, syntax, context) ++
      Enum.flat_map(descriptor.nested_type, &nested_enum_definitions(&1, name, syntax, context))
  end

  defp enum_definitions(descriptors, parent, syntax, context) do
    Enum.map(descriptors, fn descriptor ->
      {:enum, parent <> "." <> descriptor.name, descriptor, syntax, context}
    end)
  end

  defp file_context(file) do
    %{
      syntax: String.to_atom(syntax(file.syntax)),
      edition: file.edition,
      features:
        edition_feature_defaults(file.edition)
        |> Map.merge(feature_map(file.options && file.options.features))
    }
  end

  defp edition_feature_defaults(:EDITION_2023),
    do: %{field_presence: :EXPLICIT, message_encoding: :LENGTH_PREFIXED}

  defp edition_feature_defaults(_edition), do: %{}

  defp inherit_context(context, options) do
    %{context | features: Map.merge(context.features, feature_map(options && options.features))}
  end

  defp feature_map(nil), do: %{}

  defp feature_map(features) do
    features
    |> Map.from_struct()
    |> Map.drop([:__unknown_fields__, :__protobuf__])
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Map.new()
  end

  defp runtime_module(name, schema_id) do
    hash =
      :crypto.hash(:sha256, :erlang.term_to_binary({name, schema_id}))
      |> Base.encode16(case: :lower)

    Module.concat([Protovalidate, Conformance, Runtime, "M#{hash}"])
  end

  defp create_message_module!(module, full_name, descriptor, syntax, context, modules) do
    unless Code.ensure_loaded?(module) do
      fields =
        Enum.map(
          descriptor.field,
          &field_ast(&1, modules, full_name, descriptor, syntax, context)
        )

      oneofs =
        descriptor.oneof_decl
        |> Enum.with_index()
        |> Enum.reject(fn {_oneof, index} ->
          Enum.any?(descriptor.field, &(&1.oneof_index == index and &1.proto3_optional == true))
        end)
        |> Enum.map(fn {oneof, index} ->
          quote(do: Protobuf.DSL.oneof(unquote(String.to_atom(oneof.name)), unquote(index)))
        end)

      Module.create(
        module,
        quote do
          require Protobuf.DSL

          use Protobuf,
            full_name: unquote(String.trim_leading(full_name, ".")),
            syntax: unquote(runtime_syntax(syntax)),
            map:
              unquote(
                descriptor.options != nil and
                  Map.get(descriptor.options, :map_entry, false) == true
              )

          def descriptor, do: unquote(Macro.escape(descriptor))
          def __protovalidate_descriptor_context__, do: unquote(Macro.escape(context))
          unquote_splicing(oneofs)
          unquote_splicing(fields)
        end,
        Macro.Env.location(__ENV__)
      )
    end
  end

  defp create_enum_module!(module, full_name, %EnumDescriptorProto{} = descriptor, syntax) do
    unless Code.ensure_loaded?(module) do
      values =
        Enum.map(descriptor.value, fn value ->
          quote do
            Protobuf.DSL.field(unquote(String.to_atom(value.name)), unquote(value.number))
          end
        end)

      Module.create(
        module,
        quote do
          require Protobuf.DSL

          use Protobuf,
            enum: true,
            full_name: unquote(String.trim_leading(full_name, ".")),
            syntax: unquote(runtime_syntax(syntax))

          def descriptor, do: unquote(Macro.escape(descriptor))
          unquote_splicing(values)
        end,
        Macro.Env.location(__ENV__)
      )
    end
  end

  defp field_ast(field, modules, full_name, descriptor, syntax, context) do
    type = Map.get(@scalar_types, field.type) || Map.fetch!(modules, field.type_name)
    label = if(field.label == :LABEL_REPEATED, do: [repeated: true], else: [])

    optional =
      case field.label do
        :LABEL_REQUIRED -> [required: true]
        :LABEL_OPTIONAL -> [optional: true]
        _ -> []
      end

    oneof =
      if(is_integer(field.oneof_index) and field.proto3_optional != true,
        do: [oneof: field.oneof_index],
        else: []
      )

    map = if(map_entry?(field, full_name, descriptor), do: [map: true], else: [])
    default = if(syntax == "editions", do: [], else: default_option(field))

    flags = [
      enum: field.type == :TYPE_ENUM,
      proto3_optional:
        field.proto3_optional == true or edition_tracked_presence?(field, syntax, context)
    ]

    options =
      label ++
        optional ++ [type: type, json_name: field.json_name] ++ oneof ++ map ++ default ++ flags

    quote do
      Protobuf.DSL.field(
        unquote(String.to_atom(field.name)),
        unquote(field.number),
        unquote(options)
      )
    end
  end

  defp edition_tracked_presence?(field, "editions", context) do
    local = feature_map(field.options && field.options.features)
    features = Map.merge(context.features, local)

    field.label == :LABEL_OPTIONAL and not is_integer(field.oneof_index) and
      Map.get(features, :field_presence) in [:EXPLICIT, :LEGACY_REQUIRED]
  end

  defp edition_tracked_presence?(_field, _syntax, _context), do: false

  defp runtime_syntax("editions"), do: :proto3
  defp runtime_syntax(syntax), do: String.to_atom(syntax)

  # protobuf 0.17 は group wire を値として decode しないため、edition の DELIMITED
  # message を同じ message 値を表す length-prefixed wire に正規化してから渡す。
  defp normalize_message_wire(binary, module, modules, depth \\ 0)

  defp normalize_message_wire(_binary, _module, _modules, depth)
       when depth > @max_wire_nesting_depth do
    raise Protobuf.DecodeError,
      message: "embedded message nesting depth exceeds the maximum of #{@max_wire_nesting_depth}"
  end

  defp normalize_message_wire(binary, module, modules, depth) do
    descriptor = module.descriptor()
    context = module.__protovalidate_descriptor_context__()
    fields = Map.new(descriptor.field, &{&1.number, &1})

    normalize_wire_fields(binary, fields, context.features, modules, depth)
  end

  defp normalize_wire_fields(binary, fields, features, modules, depth),
    do: normalize_wire_fields(binary, fields, features, modules, depth, [])

  defp normalize_wire_fields(<<>>, _fields, _features, _modules, _depth, parts),
    do: parts |> Enum.reverse() |> IO.iodata_to_binary()

  defp normalize_wire_fields(binary, fields, features, modules, depth, parts) do
    {number, wire_type, tag, value, original_value, rest} = read_wire_field(binary)
    field = Map.get(fields, number)

    normalized =
      normalize_wire_value(field, wire_type, value, features, modules, depth)

    field_wire =
      case normalized do
        {:delimited, nested} ->
          [encode_varint(bor(bsl(number, 3), 2)), encode_varint(byte_size(nested)), nested]

        {:group, nested} ->
          [encode_varint(bor(bsl(number, 3), 2)), encode_varint(byte_size(nested)), nested]

        {:length_prefixed, nested} when nested != value ->
          [tag, encode_varint(byte_size(nested)), nested]

        _ ->
          [tag, original_value]
      end

    normalize_wire_fields(rest, fields, features, modules, depth, [field_wire | parts])
  end

  defp normalize_wire_value(
         %FieldDescriptorProto{type: :TYPE_MESSAGE, type_name: type_name} = field,
         3,
         value,
         features,
         modules,
         depth
       ) do
    if field_message_encoding(field, features) == :DELIMITED do
      child = Map.fetch!(modules, type_name)
      {:delimited, normalize_message_wire(value, child, modules, depth + 1)}
    end
  end

  defp normalize_wire_value(
         %FieldDescriptorProto{type: :TYPE_GROUP, type_name: type_name},
         3,
         value,
         _features,
         modules,
         depth
       ) do
    child = Map.fetch!(modules, type_name)
    {:group, normalize_message_wire(value, child, modules, depth + 1)}
  end

  defp normalize_wire_value(
         %FieldDescriptorProto{type: :TYPE_MESSAGE, type_name: type_name} = field,
         2,
         value,
         features,
         modules,
         depth
       ) do
    if field_message_encoding(field, features) == :LENGTH_PREFIXED do
      child = Map.fetch!(modules, type_name)
      {:length_prefixed, normalize_message_wire(value, child, modules, depth + 1)}
    end
  end

  defp normalize_wire_value(_field, _wire_type, _value, _features, _modules, _depth),
    do: :unchanged

  defp field_message_encoding(field, inherited) do
    local = feature_map(field.options && field.options.features)
    Map.get(local, :message_encoding, Map.get(inherited, :message_encoding, :LENGTH_PREFIXED))
  end

  defp read_wire_field(binary) do
    {tag_value, tag, rest} = read_varint(binary)
    number = bsr(tag_value, 3)
    wire_type = band(tag_value, 7)

    if number == 0 do
      raise Protobuf.DecodeError, message: "invalid field number 0 when decoding binary data"
    end

    {value, original_value, rest} = read_wire_value(wire_type, number, rest)
    {number, wire_type, tag, value, original_value, rest}
  end

  defp read_wire_value(0, _number, binary) do
    {_value, encoded, rest} = read_varint(binary)
    {nil, encoded, rest}
  end

  defp read_wire_value(1, _number, <<value::binary-size(8), rest::binary>>),
    do: {value, value, rest}

  defp read_wire_value(2, _number, binary) do
    {size, encoded_size, rest} = read_varint(binary)

    case rest do
      <<value::binary-size(^size), rest::binary>> ->
        {value, [encoded_size, value], rest}

      _ ->
        raise Protobuf.DecodeError, message: "cannot decode binary data: truncated field"
    end
  end

  defp read_wire_value(3, number, binary) do
    {value, encoded, rest} = read_group_value(binary, number, [])
    {value, encoded, rest}
  end

  defp read_wire_value(4, _number, _binary),
    do: raise(Protobuf.DecodeError, message: "closing group but no groups are open")

  defp read_wire_value(5, _number, <<value::binary-size(4), rest::binary>>),
    do: {value, value, rest}

  defp read_wire_value(_wire_type, _number, _binary),
    do: raise(Protobuf.DecodeError, message: "cannot decode binary data: truncated field")

  defp read_group_value(binary, group_number, values) do
    {tag_value, tag, rest} = read_varint(binary)
    number = bsr(tag_value, 3)
    wire_type = band(tag_value, 7)

    case {number, wire_type} do
      {^group_number, 4} ->
        {IO.iodata_to_binary(Enum.reverse(values)), [Enum.reverse(values), tag], rest}

      {_number, 4} ->
        raise Protobuf.DecodeError, message: "mismatched closing group when decoding binary data"

      {number, wire_type} ->
        {_value, encoded, rest} = read_wire_value(wire_type, number, rest)
        read_group_value(rest, group_number, [[tag, encoded] | values])
    end
  end

  defp read_varint(binary), do: read_varint(binary, 0, 0, [])

  defp read_varint(<<byte, rest::binary>>, shift, value, encoded) when shift < 70 do
    encoded = [byte | encoded]
    value = value + bsl(band(byte, 127), shift)

    if band(byte, 128) == 0 do
      {value, encoded |> Enum.reverse() |> :erlang.list_to_binary(), rest}
    else
      read_varint(rest, shift + 7, value, encoded)
    end
  end

  defp read_varint(_binary, _shift, _value, _encoded),
    do: raise(Protobuf.DecodeError, message: "cannot decode binary data: invalid varint")

  defp encode_varint(value) when value < 128, do: <<value>>

  defp encode_varint(value),
    do: <<bor(band(value, 127), 128)>> <> encode_varint(bsr(value, 7))

  defp map_entry?(%FieldDescriptorProto{type_name: type_name}, full_name, descriptor) do
    Enum.any?(descriptor.nested_type, fn nested ->
      full_name <> "." <> nested.name == type_name and
        nested.options != nil and nested.options.map_entry == true
    end)
  end

  defp preserve_wire_presence(message, binaries, module, modules, depth \\ 0)

  defp preserve_wire_presence(_message, _binaries, _module, _modules, depth)
       when depth > @max_wire_nesting_depth,
       do:
         raise(Protobuf.DecodeError,
           message:
             "embedded message nesting depth exceeds the maximum of #{@max_wire_nesting_depth}"
         )

  defp preserve_wire_presence(message, binaries, module, modules, depth) do
    descriptor = module.descriptor()
    message_props = module.__message_props__()
    occurrences = Enum.flat_map(binaries, &wire_occurrences/1)

    # proto2 の構造体は custom default の未設定と明示設定を区別できないため wire 状態を補う。
    presence =
      if message_props.syntax == :proto2 do
        Enum.reduce(descriptor.field, %{}, fn field, presence ->
          props = Map.fetch!(message_props.field_props, field.number)
          atom = String.to_atom(field.name)

          if not is_nil(props.default) and is_nil(props.oneof) and
               decoded_field_value(message, field, descriptor) == props.default do
            present? = field_wire_present?(field, occurrences)
            Map.put(presence, atom, {props.default, present?})
          else
            presence
          end
        end)
      else
        %{}
      end

    message =
      if map_size(presence) == 0,
        do: message,
        else: Map.put(message, @wire_presence_key, presence)

    full_name = "." <> String.trim_leading(module.full_name(), ".")

    Enum.reduce(descriptor.field, message, fn field, message ->
      preserve_nested_message_presence(
        message,
        field,
        descriptor,
        occurrences,
        modules,
        full_name,
        depth
      )
    end)
  end

  defp preserve_nested_message_presence(
         message,
         field,
         descriptor,
         occurrences,
         modules,
         full_name,
         depth
       )
       when field.type in [:TYPE_MESSAGE, :TYPE_GROUP] do
    if map_entry?(field, full_name, descriptor) do
      message
    else
      values =
        occurrences
        |> Enum.filter(fn {number, wire_type, _value} ->
          number == field.number and message_wire_type?(field.type, wire_type)
        end)
        |> Enum.map(fn {_number, _wire_type, value} -> value end)

      child_module = Map.get(modules, field.type_name)
      atom = String.to_atom(field.name)

      cond do
        is_nil(child_module) or values == [] ->
          message

        field.label == :LABEL_REPEATED ->
          children = Map.fetch!(message, atom)

          decorated =
            Enum.zip(children, values)
            |> Enum.map(fn {child, binary} ->
              preserve_wire_presence(child, [binary], child_module, modules, depth + 1)
            end)

          Map.put(message, atom, decorated)

        true ->
          case decoded_field_value(message, field, descriptor) do
            %{__struct__: ^child_module} = child ->
              decorated = preserve_wire_presence(child, values, child_module, modules, depth + 1)
              put_decoded_field_value(message, field, descriptor, decorated)

            _other ->
              message
          end
      end
    end
  end

  defp preserve_nested_message_presence(
         message,
         _field,
         _descriptor,
         _occurrences,
         _modules,
         _full_name,
         _depth
       ),
       do: message

  defp decoded_field_value(message, field, descriptor) do
    atom = String.to_atom(field.name)

    if is_integer(field.oneof_index) and field.proto3_optional != true do
      oneof = Enum.at(descriptor.oneof_decl, field.oneof_index)

      case Map.fetch!(message, String.to_atom(oneof.name)) do
        {^atom, value} -> value
        _other -> nil
      end
    else
      Map.fetch!(message, atom)
    end
  end

  defp put_decoded_field_value(message, field, descriptor, value) do
    atom = String.to_atom(field.name)

    if is_integer(field.oneof_index) and field.proto3_optional != true do
      oneof = Enum.at(descriptor.oneof_decl, field.oneof_index)
      Map.put(message, String.to_atom(oneof.name), {atom, value})
    else
      Map.put(message, atom, value)
    end
  end

  defp field_wire_present?(field, occurrences) do
    Enum.any?(occurrences, fn {number, wire_type, _value} ->
      number == field.number and
        (wire_type == scalar_wire_type(field.type) or
           (field.label == :LABEL_REPEATED and packable?(field.type) and wire_type == 2))
    end)
  end

  defp scalar_wire_type(type)
       when type in [:TYPE_DOUBLE, :TYPE_FIXED64, :TYPE_SFIXED64],
       do: 1

  defp scalar_wire_type(type) when type in [:TYPE_FLOAT, :TYPE_FIXED32, :TYPE_SFIXED32], do: 5
  defp scalar_wire_type(:TYPE_GROUP), do: 3

  defp scalar_wire_type(type)
       when type in [:TYPE_STRING, :TYPE_BYTES, :TYPE_MESSAGE],
       do: 2

  defp scalar_wire_type(_type), do: 0

  defp message_wire_type?(:TYPE_GROUP, 3), do: true
  defp message_wire_type?(:TYPE_MESSAGE, wire_type), do: wire_type in [2, 3]
  defp message_wire_type?(_type, _wire_type), do: false

  defp packable?(type),
    do: type not in [:TYPE_STRING, :TYPE_BYTES, :TYPE_MESSAGE, :TYPE_GROUP]

  defp wire_occurrences(binary), do: wire_occurrences(binary, [])

  defp wire_occurrences(<<>>, occurrences), do: Enum.reverse(occurrences)

  defp wire_occurrences(binary, occurrences) do
    {number, wire_type, _tag, value, _original_value, rest} = read_wire_field(binary)
    wire_occurrences(rest, [{number, wire_type, value} | occurrences])
  end

  defp default_option(%FieldDescriptorProto{default_value: nil}), do: []

  defp default_option(%FieldDescriptorProto{type: type, default_value: value}) do
    [default: default_value(type, value)]
  end

  defp default_value(:TYPE_BOOL, "true"), do: true
  defp default_value(:TYPE_BOOL, "false"), do: false
  defp default_value(:TYPE_ENUM, value), do: String.to_atom(value)
  defp default_value(type, value) when type in [:TYPE_STRING, :TYPE_BYTES], do: value

  defp default_value(type, value)
       when type in [
              :TYPE_INT64,
              :TYPE_UINT64,
              :TYPE_INT32,
              :TYPE_FIXED64,
              :TYPE_FIXED32,
              :TYPE_UINT32,
              :TYPE_SFIXED32,
              :TYPE_SFIXED64,
              :TYPE_SINT32,
              :TYPE_SINT64
            ],
       do: String.to_integer(value)

  defp default_value(type, value) when type in [:TYPE_DOUBLE, :TYPE_FLOAT] do
    case Float.parse(value) do
      {number, ""} -> number
      :error -> value
    end
  end
end
