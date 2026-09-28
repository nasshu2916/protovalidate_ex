defmodule Protovalidate.CEL.CelixirVariables do
  @moduledoc false

  alias Celixir.AST

  @type_denotations ~w[bool int uint double string bytes list map type null_type optional_type]
  @namespaces ~w[base64 lists math optional regex sets strings]

  @spec check(AST.expr(), MapSet.t(String.t())) :: :ok | {:error, String.t()}
  def check(ast, declared), do: check_ast(ast, declared)

  defp check_ast(%AST.Ident{name: name}, declared) do
    if MapSet.member?(declared, name) or name in @type_denotations or
         name in ["true", "false", "null"] do
      :ok
    else
      unknown(name)
    end
  end

  defp check_ast(%AST.UnaryOp{operand: operand}, declared), do: check_ast(operand, declared)

  defp check_ast(%AST.BinaryOp{left: left, right: right}, declared),
    do: all([left, right], declared)

  defp check_ast(
         %AST.Ternary{condition: condition, true_expr: true_expr, false_expr: false_expr},
         declared
       ),
       do: all([condition, true_expr, false_expr], declared)

  defp check_ast(%AST.CreateList{elements: elements}, declared),
    do: all(Enum.map(elements, &list_element/1), declared)

  defp check_ast(%AST.CreateMap{entries: entries}, declared) do
    entries
    |> Enum.flat_map(fn
      {:optional, key, value} -> [key, value]
      {key, value} -> [key, value]
    end)
    |> all(declared)
  end

  defp check_ast(%AST.CreateStruct{entries: entries}, declared),
    do: entries |> Enum.map(&struct_value/1) |> all(declared)

  defp check_ast(%AST.Select{operand: operand}, declared), do: check_ast(operand, declared)

  defp check_ast(%AST.OptSelect{operand: operand}, declared), do: check_ast(operand, declared)

  defp check_ast(%AST.Index{operand: operand, index: index}, declared),
    do: all([operand, index], declared)

  defp check_ast(%AST.OptIndex{operand: operand, index: index}, declared),
    do: all([operand, index], declared)

  defp check_ast(%AST.Call{target: %AST.Ident{name: name}, args: args}, declared)
       when name in @namespaces,
       do: all(args, declared)

  defp check_ast(%AST.Call{target: target, args: args}, declared),
    do: all([target | args], declared)

  defp check_ast(%AST.Comprehension{} = comprehension, declared) do
    with :ok <- all([comprehension.iter_range, comprehension.acc_init], declared) do
      inner =
        declared
        |> MapSet.put(comprehension.iter_var)
        |> MapSet.put(comprehension.acc_var)
        |> put_optional(comprehension.iter_var2)

      all(
        [
          comprehension.loop_condition,
          comprehension.loop_step,
          comprehension.result
          | kind_expressions(comprehension.kind)
        ],
        inner
      )
    end
  end

  defp check_ast(%AST.OptLambda{target: target, var: var, expr: expr}, declared) do
    with :ok <- check_ast(target, declared), do: check_ast(expr, MapSet.put(declared, var))
  end

  defp check_ast(%AST.CelBlock{bindings: bindings, result: result}, declared),
    do: all(bindings ++ [result], declared)

  defp check_ast(%AST.CelIndex{}, _declared), do: :ok
  defp check_ast(%AST.CelIterVar{}, _declared), do: :ok
  defp check_ast(_literal, _declared), do: :ok

  defp all(expressions, declared),
    do:
      Enum.reduce_while(expressions, :ok, fn expression, :ok ->
        case check_ast(expression, declared) do
          :ok -> {:cont, :ok}
          {:error, _} = error -> {:halt, error}
        end
      end)

  defp list_element({:optional_list_elem, expression}), do: expression
  defp list_element(expression), do: expression
  defp struct_value({:optional, _field, value}), do: value
  defp struct_value({_field, value}), do: value
  defp put_optional(set, nil), do: set
  defp put_optional(set, name), do: MapSet.put(set, name)

  defp kind_expressions({:transform_map, transform, filter}),
    do: optional_expression(filter, [transform])

  defp kind_expressions({:transform_map_entry, transform, filter}),
    do: optional_expression(filter, [transform])

  defp kind_expressions({:sort_by, key}), do: [key]

  defp kind_expressions({:collect_list, filter, transform}),
    do: optional_expression(filter, [transform])

  defp kind_expressions(:standard), do: []
  defp optional_expression(nil, expressions), do: expressions
  defp optional_expression(expression, expressions), do: [expression | expressions]
  defp unknown(name), do: {:error, "unknown CEL identifier: #{name}"}
end
