defmodule Protovalidate.CEL.Celixir do
  @moduledoc """
  CEL adapter powered by `celixir ~> 0.3.0`.

  Reads Protobuf types and field presence from descriptors.
  See `docs/cel.md` for supported features and limitations.
  """
  @behaviour Protovalidate.CEL

  alias Protovalidate.CEL.CelixirTypes

  @base_env Celixir.Environment.new()

  @impl true
  def compile(rule, environment, _options) do
    with {:ok, ast} <- Celixir.parse(rule.expression),
         :ok <- CelixirTypes.check(ast, environment) do
      rewritten =
        ast
        |> Protovalidate.CEL.Library.rewrite()
        |> Protovalidate.CEL.CelixirAccess.rewrite()

      uses_now? = uses_identifier?(ast, "now")
      uses_rule? = uses_identifier?(ast, "rule")
      {:ok, %{ast: rewritten, uses_now?: uses_now?, uses_rule?: uses_rule?}}
    end
  end

  @impl true
  def evaluate(%{ast: ast, uses_now?: uses_now?, uses_rule?: uses_rule?}, environment, _options) do
    variables = %{
      this: CelixirTypes.field_value(environment.this, environment.type_environment.field),
      rule: if(uses_rule?, do: CelixirTypes.value(environment.rule), else: nil),
      now:
        if(uses_now? and environment.now, do: CelixirTypes.timestamp(environment.now), else: nil)
    }

    resolver = get_in(environment, [:type_environment, :resolver])

    env =
      @base_env
      |> Protovalidate.CEL.Library.register()
      |> Celixir.Environment.put_function(
        "_pv_get",
        &Protovalidate.CEL.CelixirAccess.get(&1, &2, resolver)
      )
      |> Celixir.Environment.put_function(
        "_pv_has",
        &Protovalidate.CEL.CelixirAccess.has?(&1, &2, resolver)
      )
      |> Map.put(:variables, variables)

    Celixir.eval_ast(ast, env)
  end

  def evaluate(ast, environment, options) do
    evaluate(%{ast: ast, uses_now?: true, uses_rule?: true}, environment, options)
  end

  defp uses_identifier?(%Celixir.AST.Ident{name: target}, target), do: true

  defp uses_identifier?(%_module{} = ast, target) do
    Enum.any?(Map.from_struct(ast), fn {_k, v} -> uses_identifier?(v, target) end)
  end

  defp uses_identifier?(list, target) when is_list(list),
    do: Enum.any?(list, &uses_identifier?(&1, target))

  defp uses_identifier?(tuple, target) when is_tuple(tuple),
    do: tuple |> Tuple.to_list() |> uses_identifier?(target)

  defp uses_identifier?(_other, _target), do: false
end
