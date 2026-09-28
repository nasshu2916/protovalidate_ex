defmodule Protovalidate.Rules.Violations do
  @moduledoc false

  alias Protovalidate.{FieldPath, Violation}

  def check(context, valid?, field, id, message, details \\ %{})
  def check(context, true, _field, _id, _message, _details), do: {:cont, context}

  def check(context, false, field, id, message, details),
    do: add(context, violation(path(field), id, message, details))

  def add(context, violation), do: Protovalidate.Plan.Context.add(context, violation)

  def unwrap({_, context}), do: context
  def halted?(%{stopped: true}), do: true
  def halted?(_), do: false

  def violation(path, id, message, details \\ %{}),
    do: Violation.new(path, id, message, details: details)

  def path(%{name: ""}), do: FieldPath.new([])
  def path(field), do: FieldPath.new([{:field, field.name}])

  def rule_id(%{well_known_type: {:wrapper, type}} = field, suffix),
    do: rule_id(%{field | type: type, well_known_type: nil}, suffix)

  def rule_id(%{type: :TYPE_BYTES}, suffix), do: "bytes.#{suffix}"
  def rule_id(%{type: :TYPE_BOOL}, suffix), do: "bool.#{suffix}"
  def rule_id(%{type: :TYPE_ENUM}, suffix), do: "enum.#{suffix}"
  def rule_id(%{type: type}, suffix) when type in [:TYPE_STRING], do: "string.#{suffix}"

  def rule_id(%{type: type}, suffix) when is_atom(type),
    do:
      "#{type |> Atom.to_string() |> String.downcase() |> String.replace_prefix("type_", "")}.#{suffix}"

  def rule_id(_field, suffix), do: suffix
end
