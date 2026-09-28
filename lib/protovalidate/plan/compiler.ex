defmodule Protovalidate.Plan.Compiler do
  @moduledoc false

  import Protovalidate.Rules.Compilation

  alias Protovalidate.DescriptorAdapter
  alias Protovalidate.Plan.{CollectionPlan, FieldPlan}

  @spec compile(DescriptorAdapter.Message.t(), keyword()) :: Protovalidate.Plan.t()
  def compile(%DescriptorAdapter.Message{} = descriptor, options) do
    options = Keyword.put(options, :cel_message_descriptor, descriptor)
    message_rules = Map.get(descriptor.validation, :message)

    if message_rules do
      reject_unknown_rule_fields!(message_rules, [:cel, :cel_expression, :oneof], "message")
      reject_extensions!(message_rules, ["message"])
    end

    message_oneofs = compile_message_oneofs(message_rules, descriptor.fields)
    fields = apply_oneof_ignore(descriptor.fields, message_oneofs)

    %Protovalidate.Plan{
      module: descriptor.module,
      fields: Enum.map(fields, &compile_field(&1, options)),
      wire_fields:
        Map.new(descriptor.fields, &{&1.name, Protovalidate.ViolationPath.field_element(&1)}),
      oneofs: Enum.map(descriptor.oneofs, &compile_oneof/1),
      message_oneofs: message_oneofs,
      cel_rules:
        descriptor.validation
        |> Map.get(:message)
        |> Protovalidate.Rules.Custom.compile_cel_rules!(:message, descriptor.full_name, options)
        |> Enum.map(fn {:cel, rule} -> rule end)
    }
  end

  defp compile_message_oneofs(rules, fields) do
    (rule_value(rules, :oneof) || [])
    |> Enum.with_index()
    |> Enum.map(fn {rule, index} ->
      reject_unknown_rule_fields!(rule, [:fields, :required], "message.oneof")
      reject_extensions!(rule, ["message", "oneof"])
      names = rule_value(rule, :fields)
      required = rule_value(rule, :required)

      unless is_list(names) and names != [] and length(names) == length(Enum.uniq(names)) and
               Enum.all?(names, fn name -> Enum.any?(fields, &(&1.name == name)) end) and
               required in [nil, false, true],
             do:
               compilation_error!("invalid message.oneof fields or required value", [
                 "message",
                 "oneof",
                 to_string(index)
               ])

      %{
        fields: Enum.map(names, fn name -> Enum.find(fields, &(&1.name == name)) end),
        required: required == true,
        index: index,
        origin: %Protovalidate.Violation.Origin{
          constraint: :message_oneof,
          field: nil,
          rule: nil,
          index: index
        }
      }
    end)
  end

  defp apply_oneof_ignore(fields, oneofs) do
    names = Enum.flat_map(oneofs, &Enum.map(&1.fields, fn field -> field.name end))

    Enum.map(fields, fn field ->
      rules = get_in(field.validation, [:field]) || %{}

      if field.name in names and rule_value(rules, :ignore) == nil do
        %{
          field
          | validation:
              Map.put(field.validation, :field, Map.put(rules, :ignore, :IGNORE_IF_ZERO_VALUE))
        }
      else
        field
      end
    end)
  end

  defp compile_field(%DescriptorAdapter.Field{} = field, options) do
    rules = get_in(field.validation, [:field])
    field_plan(field, compile_rules!(field, rules, options), [])
  end

  defp field_plan(field, rules, prefix) do
    {presence, rules} = take_presence(rules)
    {ignore, rules} = take_ignore(rules)
    rules = Enum.map(rules, &prefix_rule(&1, prefix))
    {collections, checks} = Enum.split_with(rules, &collection_rule?/1)

    %FieldPlan{
      field: field,
      checks: checks,
      presence: presence,
      required_source: if(presence == :required, do: Protovalidate.RuleSource.required(prefix)),
      ignore: ignore,
      collection: collection_plan(field, collections, prefix),
      child: child_reference(field)
    }
  end

  defp collection_plan(%{repeated?: true, map?: false} = field, rules, prefix) do
    nested = Keyword.get(rules, :items, [])
    item = %{DescriptorAdapter.collection_field(field, :items) | name: ""}
    %CollectionPlan{items: field_plan(item, nested, prefix ++ ["repeated", "items"])}
  end

  defp collection_plan(%{map?: true} = field, rules, prefix) do
    key = %{DescriptorAdapter.collection_field(field, :keys) | name: ""}
    value = %{DescriptorAdapter.collection_field(field, :values) | name: ""}

    %CollectionPlan{
      keys: optional_collection_field(key, Keyword.get(rules, :keys), prefix ++ ["map", "keys"]),
      values: field_plan(value, Keyword.get(rules, :values, []), prefix ++ ["map", "values"])
    }
  end

  defp collection_plan(_field, [], _prefix), do: nil

  defp optional_collection_field(_field, nil, _prefix), do: nil
  defp optional_collection_field(field, rules, prefix), do: field_plan(field, rules, prefix)

  defp prefix_rule({:sourced, rule, source}, prefix),
    do: {:sourced, rule, Protovalidate.RuleSource.prefix(source, prefix)}

  defp prefix_rule({kind, %{source: source} = rule}, prefix)
       when kind in [:cel, :predefined] and not is_nil(source),
       do: {kind, %{rule | source: Protovalidate.RuleSource.prefix(source, prefix)}}

  defp prefix_rule(rule, _prefix), do: rule

  defp child_reference(%{
         type: type,
         repeated?: false,
         map?: false,
         reference: module
       })
       when type in [:TYPE_MESSAGE, :TYPE_GROUP] and is_atom(module),
       do: module

  defp child_reference(_field), do: nil

  defp take_presence(rules) do
    if :required in rules,
      do: {:required, List.delete(rules, :required)},
      else: {:optional, rules}
  end

  defp take_ignore(rules) do
    case List.keytake(rules, :ignore, 0) do
      {{:ignore, policy}, rest} -> {policy, rest}
      nil -> {nil, rules}
    end
  end

  defp collection_rule?({kind, _rules}) when kind in [:items, :keys, :values], do: true
  defp collection_rule?(_rule), do: false

  defp compile_oneof(%DescriptorAdapter.Oneof{} = oneof) do
    rules = get_in(oneof.validation, [:oneof])

    if rules do
      reject_unknown_rule_fields!(rules, [:required], "oneof")
      reject_extensions!(rules, ["oneof"])
    end

    required = rule_value(rules, :required)

    if required not in [nil, false, true],
      do: compilation_error!("oneof.required must be a boolean", [oneof.name, "required"])

    %{
      oneof: oneof,
      required: required == true,
      source: Protovalidate.RuleSource.oneof_required(),
      origin: %Protovalidate.Violation.Origin{
        constraint: :oneof_required,
        field: %Buf.Validate.FieldPath{
          elements: [%Buf.Validate.FieldPathElement{field_name: oneof.name}]
        },
        rule: nil
      }
    }
  end

  @spec compile_rules!(DescriptorAdapter.Field.t(), map() | nil, keyword()) :: [
          Protovalidate.Rules.compiled()
        ]
  defp compile_rules!(field, nil, options) do
    if field.presence == :required and Keyword.get(options, :legacy_required, false),
      do: [:required],
      else: []
  end

  defp compile_rules!(field, rules, options) do
    reject_unknown_wire_fields!(rules, [field.name])
    reject_extensions!(rules, [field.name])
    reject_unknown_field_rule_fields!(rules)
    type = rule_value(rules, :type)
    common = Protovalidate.Rules.Common.common_rules(field, rules, options)

    type_rules =
      field
      |> Protovalidate.Rules.compile(type, options, &compile_rules!/3)
      |> source_type_checks(type)

    options = Keyword.put(options, :cel_field_descriptor, field)

    message_type =
      case Keyword.get(options, :cel_message_descriptor) do
        nil -> field.name
        descriptor -> descriptor.full_name
      end

    cel_rules =
      Protovalidate.Rules.Custom.compile_cel_rules!(rules, :field, message_type, options)

    predefined_rules = Protovalidate.Rules.Custom.compile_predefined_rules!(type, field, options)

    Protovalidate.Rules.Custom.validate_cel_rule_namespace!(
      cel_rules ++ predefined_rules,
      field.name
    )

    common ++ type_rules ++ cel_rules ++ predefined_rules
  end

  # collection の入れ子は plan compiler が構造として扱い、通常 check だけに出典を付ける。
  defp source_type_checks(rules, type) do
    Enum.map(rules, fn
      {kind, nested} when kind in [:items, :keys, :values] -> {kind, nested}
      rule -> Protovalidate.RuleSource.standard([rule], type) |> hd()
    end)
  end

  defp reject_unknown_field_rule_fields!(rules) do
    rules
    |> rule_map()
    |> Map.drop([
      :__struct__,
      :__protobuf__,
      :__unknown_fields__,
      :__pb_extensions__,
      :required,
      :ignore,
      :cel,
      :cel_expression,
      :type
    ])
    |> Enum.each(fn {key, value} ->
      if rule_set?(value),
        do: compilation_error!("unknown field rule: #{key}", ["field", Atom.to_string(key)])
    end)
  end

  defp rule_set?(nil), do: false
  defp rule_set?([]), do: false
  defp rule_set?(:IGNORE_UNSPECIFIED), do: false
  defp rule_set?(_value), do: true
end
