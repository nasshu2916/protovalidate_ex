defmodule Protovalidate.Validator do
  @moduledoc "Owns validation options and an immutable validation plan cache."

  alias Protovalidate.{CompilationError, ValidationError}
  alias Protovalidate.Validator.{CompileConfig, EvaluationContext, PlanCache, Telemetry}

  @allowed_options [:fail_fast, :legacy_required, :registry, :cel, :validation_timeout]

  @enforce_keys [:options, :compile_config, :cache, :stats]
  defstruct [:options, :compile_config, :cache, :stats]

  @typedoc "Options used to configure a validator."
  @type option() ::
          {:fail_fast, boolean()}
          | {:legacy_required, boolean()}
          | {:registry, term()}
          | {:cel, term()}
          | {:validation_timeout, pos_integer()}

  @type options() :: [option()]
  @type t :: %__MODULE__{
          options: options(),
          compile_config: CompileConfig.t(),
          cache: :ets.tid(),
          stats: :ets.tid()
        }

  @doc """
  Creates a reusable validator.

  The ETS tables are owned by the calling process and are deleted when it exits.
  The validator can be used by other processes, but keep the owner alive until
  all validations are complete. To release the tables explicitly, call `close/1`
  from the owner process.
  """
  @spec new(options()) :: t()
  def new(options \\ [])

  def new(options) when is_list(options) do
    unless Keyword.keyword?(options),
      do: raise(ArgumentError, "validator options must be a keyword list")

    unknown = Keyword.keys(options) -- @allowed_options
    if unknown != [], do: raise(ArgumentError, "unknown validator options: #{inspect(unknown)}")

    fail_fast = Keyword.get(options, :fail_fast, false)
    unless is_boolean(fail_fast), do: raise(ArgumentError, ":fail_fast must be a boolean")

    unless is_boolean(Keyword.get(options, :legacy_required, false)),
      do: raise(ArgumentError, ":legacy_required must be a boolean")

    if not is_nil(Keyword.get(options, :cel)),
      do: Protovalidate.CEL.validate_configuration!(options[:cel])

    validate_registry!(Keyword.get(options, :registry))

    if Keyword.has_key?(options, :validation_timeout) do
      value = options[:validation_timeout]

      unless is_integer(value) and value > 0,
        do: raise(ArgumentError, ":validation_timeout must be a positive integer")
    end

    {cache, stats} = PlanCache.new()

    normalized = [
      fail_fast: fail_fast,
      legacy_required: Keyword.get(options, :legacy_required, false),
      registry: Keyword.get(options, :registry),
      cel: Keyword.get(options, :cel),
      validation_timeout: Keyword.get(options, :validation_timeout)
    ]

    %__MODULE__{
      options: normalized,
      compile_config: CompileConfig.new(normalized),
      cache: cache,
      stats: stats
    }
  end

  def new(_options), do: raise(ArgumentError, "validator options must be a keyword list")

  defp validate_registry!(nil), do: :ok
  defp validate_registry!(%Protovalidate.PredefinedRuleRegistry{}), do: :ok

  defp validate_registry!(module) when is_atom(module) do
    unless Code.ensure_loaded?(module) and function_exported?(module, :resolve, 3),
      do: raise(ArgumentError, ":registry must be a registry or implement resolve/3")
  end

  defp validate_registry!(_), do: raise(ArgumentError, "invalid :registry configuration")

  @doc """
  Releases the validator's ETS tables from the owner process.

  Call this once after use by other processes has completed. The validator cannot
  be used after its tables are released.
  """
  @spec close(t()) :: :ok
  def close(%__MODULE__{cache: cache, stats: stats}), do: PlanCache.delete(cache, stats)

  @doc """
  Returns statistics for this validator's plan cache.

  The ETS tables are owned by the process that created the validator and are
  deleted when that process exits. Descriptors are normalized per loaded module
  version, and cache keys include all compilation options so plans from an older
  code version are not reused after reloads.
  """
  @spec cache_stats(t()) :: %{
          hits: non_neg_integer(),
          misses: non_neg_integer(),
          size: non_neg_integer()
        }
  def cache_stats(%__MODULE__{cache: cache, stats: stats}) do
    PlanCache.stats(cache, stats)
  end

  @doc """
  Compiles a Protobuf module and every reachable child message before validation.

  Recursive message references are visited once. Returns `:ok` or a schema
  compilation error. Preparation has its own unbounded compilation budget and
  does not consume a later call's `:validation_timeout`.
  """
  @spec prepare(t(), module()) :: :ok | {:error, Exception.t()}
  def prepare(%__MODULE__{} = validator, module) when is_atom(module) do
    _visited = prepare_module(validator, module, MapSet.new())
    :ok
  rescue
    error in [CompilationError, Protovalidate.UnsupportedRuleError] ->
      {:error, error}

    error in ArgumentError ->
      {:error, CompilationError.exception(message: Exception.message(error))}
  end

  def prepare(%__MODULE__{}, _module),
    do: {:error, CompilationError.exception(message: "expected a Protobuf message module")}

  defp prepare_module(validator, module, visited) do
    if MapSet.member?(visited, module) do
      visited
    else
      visited = MapSet.put(visited, module)
      plan = PlanCache.for_module(module, compile_options(validator))

      plan.fields
      |> Enum.flat_map(&child_modules/1)
      |> Enum.reduce(visited, &prepare_module(validator, &1, &2))
    end
  end

  defp child_modules(%{child: child, collection: collection}) do
    direct = if child, do: [child], else: []

    nested =
      if collection do
        collection
        |> Map.from_struct()
        |> Map.values()
        |> Enum.reject(&is_nil/1)
        |> Enum.flat_map(&child_modules/1)
      else
        []
      end

    direct ++ nested
  end

  @spec validate(t(), struct()) :: {:ok, struct()} | {:error, Exception.t()}
  def validate(%__MODULE__{} = validator, %module{} = message) do
    Telemetry.measure(:total, module, fn ->
      context = EvaluationContext.new(validator.options)
      options = compile_options(validator) ++ EvaluationContext.options(context)

      with {:ok, plan} <-
             Telemetry.measure(:compile, module, fn -> plan(validator, module, options) end),
           {:ok, violations} <-
             Telemetry.measure(:evaluate, module, fn ->
               evaluate(validator, plan, message, options)
             end) do
        case violations do
          [] -> {:ok, message}
          _ -> {:error, ValidationError.exception(violations: violations)}
        end
      end
    end)
  rescue
    error in [CompilationError, Protovalidate.UnsupportedRuleError, Protovalidate.RuntimeError] ->
      {:error, error}
  end

  def validate(_validator, _message) do
    Telemetry.measure(:total, nil, fn ->
      {:error,
       %Protovalidate.RuntimeError{
         message: "expected a Protobuf message struct",
         code: :invalid_message,
         stage: :input
       }}
    end)
  end

  defp plan(%__MODULE__{cache: cache, stats: stats}, module, options) do
    {:ok,
     PlanCache.for_module(module, Keyword.put(options, :validator, %{cache: cache, stats: stats}))}
  rescue
    error in ArgumentError -> {:error, %CompilationError{message: Exception.message(error)}}
  end

  defp compile_options(%__MODULE__{} = validator) do
    CompileConfig.options(validator.compile_config) ++
      [validator: %{cache: validator.cache, stats: validator.stats}]
  end

  defp evaluate(validator, plan, message, options) do
    Protovalidate.Plan.evaluate(
      plan,
      message,
      Keyword.put(options, :validator, validator)
    )
  end
end
