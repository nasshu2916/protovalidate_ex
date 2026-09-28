defmodule Protovalidate.CEL do
  @moduledoc """
  Adapter interface for CEL evaluators.

  Implementations perform CEL type checking and map Protobuf values during
  `compile/3`. The environment passed to `evaluate/3` contains `this`, `rule`,
  `scope`, `message_type`, `type_environment`, and `now`. Evaluators must not
  expose functions or state beyond this environment.
  """

  alias Protovalidate.{CompilationError, RuntimeError}

  @default_compile_timeout 1_000
  @default_timeout 1_000
  @default_max_heap_size 8_000_000

  @type rule :: %{
          required(:id) => String.t(),
          required(:expression) => String.t(),
          optional(:message) => String.t()
        }
  @type environment :: %{
          required(:this) => term(),
          required(:rule) => term(),
          required(:scope) => :field | :message,
          required(:message_type) => String.t(),
          optional(:now) => map(),
          optional(:type_environment) => Protovalidate.CEL.TypeEnvironment.t()
        }
  @type configuration :: nil | module() | {module(), keyword()}

  @callback compile(rule(), environment(), keyword()) :: {:ok, term()} | {:error, term()}
  @callback evaluate(term(), environment(), keyword()) ::
              {:ok, boolean() | String.t()} | {:error, term()}

  @spec compile!(configuration(), rule(), environment()) :: term()
  def compile!(configuration, rule, environment),
    do: compile!(configuration, rule, environment, :infinity)

  @doc false
  def compile!(configuration, rule, environment, budget) do
    %{module: module, options: options, limits: limits} = normalize_configuration!(configuration)
    timeout = min(limits.compile_timeout, budget)

    result =
      Protovalidate.CELExecution.run(
        fn -> module.compile(rule, environment, options) end,
        timeout,
        limits.max_heap_size
      )

    case result do
      {:ok, {:ok, compiled}} ->
        %{module: module, options: options, expression: compiled, limits: limits}

      {:ok, {:error, _reason}} ->
        raise CompilationError, message: "failed to compile CEL expression: adapter_error"

      {:error, :timeout} when budget <= limits.compile_timeout ->
        raise RuntimeError, message: "validation timeout"

      {:error, code} ->
        raise CompilationError, message: "failed to compile CEL expression: #{code}"

      {:ok, _other} ->
        raise CompilationError,
          message: "CEL evaluator returned an invalid compile/3 result: invalid_result"
    end
  end

  @spec evaluate!(map(), environment()) :: boolean() | String.t()
  def evaluate!(compiled, environment), do: evaluate!(compiled, environment, :infinity)

  @doc false
  def evaluate!(
        %{module: module, options: options, expression: expression, limits: limits},
        environment,
        budget
      ) do
    timeout = min(limits.timeout, budget)

    result =
      Protovalidate.CELExecution.run(
        fn -> module.evaluate(expression, environment, options) end,
        timeout,
        limits.max_heap_size
      )

    case result do
      {:ok, {:ok, value}} when is_boolean(value) or is_binary(value) ->
        value

      {:ok, {:error, _reason}} ->
        raise RuntimeError, message: "failed to evaluate CEL expression: adapter_error"

      {:error, code} ->
        raise RuntimeError, message: "failed to evaluate CEL expression: #{code}"

      {:ok, _other} ->
        raise RuntimeError,
          message: "CEL evaluator result must be a boolean or string: invalid_result"
    end
  end

  @doc false
  def validate_configuration!(configuration) do
    _normalized = normalize_configuration!(configuration)
    :ok
  end

  defp normalize_configuration!(configuration) do
    {module, options} = configuration!(configuration)

    unless Keyword.keyword?(options),
      do: raise(ArgumentError, "CEL options must be a keyword list")

    defaults = %{
      compile_timeout: @default_compile_timeout,
      timeout: @default_timeout,
      max_heap_size: @default_max_heap_size
    }

    limits =
      for {key, default} <- defaults, into: %{} do
        value = Keyword.get(options, key, default)

        unless is_integer(value) and value > 0,
          do: raise(ArgumentError, "CEL #{key} must be a positive integer")

        {key, value}
      end

    %{module: module, options: options, limits: limits}
  end

  defp configuration!(nil), do: {Protovalidate.CEL.Celixir, []}
  defp configuration!(module) when is_atom(module), do: configuration!({module, []})

  defp configuration!({module, options}) when is_atom(module) and is_list(options) do
    unless Code.ensure_loaded?(module) and function_exported?(module, :compile, 3) and
             function_exported?(module, :evaluate, 3),
           do: raise(ArgumentError, ":cel must specify a Protovalidate.CEL implementation")

    {module, options}
  end

  defp configuration!(_), do: raise(ArgumentError, "invalid :cel configuration")
end
