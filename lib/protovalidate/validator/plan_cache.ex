defmodule Protovalidate.Validator.PlanCache do
  @moduledoc false

  alias Protovalidate.{DescriptorAdapter, Plan}
  alias Protovalidate.Validator.CompileConfig

  @extensions [
    {:field, Buf.Validate.PbExtension, :field},
    {:message, Buf.Validate.PbExtension, :message},
    {:oneof, Buf.Validate.PbExtension, :oneof}
  ]

  @spec for_module(module(), keyword()) :: Plan.t()
  def for_module(module, options) do
    remaining(options)

    case Keyword.get(options, :validator) do
      nil ->
        descriptor = DescriptorAdapter.describe(module, extensions: @extensions)
        remaining(options)
        plan = Plan.compile(descriptor, options)
        remaining(options)
        plan

      %{cache: cache, stats: stats} ->
        {descriptor, version} = descriptor(cache, module)

        options =
          Keyword.put(
            options,
            :cel_descriptor_resolver,
            Protovalidate.CEL.DescriptorResolver.new(cache)
          )

        fetch(cache, stats, descriptor, version, options)
    end
  rescue
    error in ArgumentError ->
      reraise Protovalidate.CompilationError.exception(message: Exception.message(error)),
              __STACKTRACE__
  end

  @spec new() :: {:ets.tid(), :ets.tid()}
  def new do
    cache = :ets.new(:protovalidate_plan_cache, [:set, :public, read_concurrency: true])
    stats = :ets.new(:protovalidate_plan_cache_stats, [:set, :public, write_concurrency: true])
    {cache, stats}
  end

  @spec delete(:ets.tid(), :ets.tid()) :: :ok
  def delete(cache, stats) do
    :ets.delete(cache)
    :ets.delete(stats)
    :ok
  end

  @spec stats(:ets.tid(), :ets.tid()) :: %{
          hits: non_neg_integer(),
          misses: non_neg_integer(),
          size: non_neg_integer()
        }
  def stats(cache, stats) do
    %{
      hits: :ets.lookup_element(stats, :hits, 2, 0),
      misses: :ets.lookup_element(stats, :misses, 2, 0),
      size: :ets.select_count(cache, [{{{:plan, :_, :_, :_}, :_}, [], [true]}])
    }
  end

  @spec fetch(
          :ets.tid(),
          :ets.tid(),
          DescriptorAdapter.Message.t(),
          Protovalidate.Validator.options()
        ) :: Plan.t()
  def fetch(cache, stats, descriptor, options) do
    # 公開の低レベル API は任意の正規化済み descriptor を受け取れるため、
    # module のロード版だけではなく descriptor 自体も完全比較する。
    fetch(
      cache,
      stats,
      descriptor,
      {:direct, descriptor, dependency_versions(descriptor)},
      options
    )
  end

  @doc false
  @spec field(:ets.tid(), module(), String.t()) :: DescriptorAdapter.Field.t() | nil
  def field(cache, module, name) do
    version = local_version(module)

    case :ets.lookup(cache, {:descriptor, module, version}) do
      [{{:descriptor, ^module, ^version}, _descriptor, fields}] -> Map.get(fields, name)
      [] -> nil
    end
  end

  @doc false
  @spec resolve_field(:ets.tid(), module(), String.t()) :: DescriptorAdapter.Field.t() | nil
  def resolve_field(cache, module, name) do
    {_descriptor, _version} = descriptor(cache, module)
    field(cache, module, name)
  end

  defp fetch(cache, stats, descriptor, version, options) do
    config = CompileConfig.new(options)
    key = {:plan, descriptor.module, version, config}

    :ets.insert(cache, {{:plan_generation, descriptor.module}, version})
    prune_plan_generations(cache, descriptor.module, version)

    case :ets.lookup(cache, key) do
      [{^key, plan}] ->
        record(stats, :hit, descriptor.module)
        plan

      [] ->
        record(stats, :miss, descriptor.module)
        compile_or_wait(cache, key, descriptor, config, options)
    end
  end

  defp compile_or_wait(cache, key, descriptor, config, options) do
    lock = {:compiling, key}
    token = make_ref()

    if :ets.insert_new(cache, {lock, self(), token}) do
      try do
        plan =
          Plan.compile(
            descriptor,
            CompileConfig.options(config) ++
              [validation_budget: Keyword.get(options, :validation_budget)]
          )

        remaining(options)
        :ets.insert(cache, {key, plan})
        discard_obsolete_plan(cache, key, plan)
        plan
      after
        :ets.delete_object(cache, {lock, self(), token})
      end
    else
      wait_for_compile(cache, key, lock, options)
    end
  end

  defp discard_obsolete_plan(cache, {:plan, module, version, _options} = key, plan) do
    # 旧コンパイルは呼び出し元へ返せるが、新世代の公開後は cache に残さない。
    case :ets.lookup(cache, {:plan_generation, module}) do
      [{{:plan_generation, ^module}, ^version}] -> :ok
      _ -> :ets.delete_object(cache, {key, plan})
    end
  end

  defp wait_for_compile(cache, key, lock, options) do
    case :ets.lookup(cache, key) do
      [{^key, plan}] ->
        plan

      [] ->
        case :ets.lookup(cache, lock) do
          [{^lock, owner, token}] -> wait_for_owner(cache, key, lock, owner, token, options)
          [] -> compile_or_wait(cache, key, descriptor_for_key(cache, key), elem(key, 3), options)
        end
    end
  end

  defp wait_for_owner(cache, key, lock, owner, token, options) do
    monitor = Process.monitor(owner)
    timeout = wait_interval(options)

    receive do
      {:DOWN, ^monitor, :process, ^owner, _reason} ->
        :ets.delete_object(cache, {lock, owner, token})
    after
      timeout -> :ok
    end

    Process.demonitor(monitor, [:flush])
    wait_for_compile(cache, key, lock, options)
  end

  defp wait_interval(options) do
    case remaining(options) do
      :infinity -> 10
      milliseconds -> min(milliseconds, 10)
    end
  end

  defp descriptor_for_key(cache, {:plan, module, version, _options}) do
    case :ets.lookup(cache, {:descriptor, module, local_version(module)}) do
      [{{:descriptor, ^module, _local_version}, descriptor, _fields}] -> descriptor
      [] -> descriptor_for_version(cache, module, version)
    end
  end

  defp descriptor_for_version(_cache, _module, {:direct, descriptor, _dependencies}),
    do: descriptor

  defp descriptor_for_version(cache, module, _version), do: elem(descriptor(cache, module), 0)

  defp remaining(options) do
    case Keyword.get(options, :validation_budget) do
      nil -> :infinity
      budget -> Protovalidate.ValidationBudget.remaining(budget)
    end
  end

  # ロード済み BEAM の MD5 を版として使う。ハッシュ値だけで descriptor や設定を同一視せず、
  # ETS の key には完全な compile options を保持する。
  defp descriptor(cache, module) do
    {descriptor, local_version} = cached_descriptor(cache, module)
    {descriptor, {local_version, dependency_versions(descriptor)}}
  end

  defp cached_descriptor(cache, module) do
    local_version = local_version(module)
    key = {:descriptor, module, local_version}

    descriptor =
      case :ets.lookup(cache, key) do
        [{^key, descriptor, _fields}] ->
          descriptor

        [] ->
          descriptor = DescriptorAdapter.describe(module, extensions: @extensions)
          fields = Map.new(descriptor.fields, &{&1.name, &1})
          :ets.insert_new(cache, {key, descriptor, fields})
          prune_descriptor_generations(cache, module, local_version)

          case :ets.lookup(cache, key) do
            [{^key, cached, _fields}] -> cached
          end
      end

    {descriptor, local_version}
  end

  defp local_version(module) do
    Code.ensure_loaded!(module)
    module.module_info(:md5)
  end

  defp dependency_versions(descriptor) do
    descriptor.fields
    |> Enum.flat_map(&field_references/1)
    |> Enum.uniq()
    |> Enum.reject(&(&1 == descriptor.module))
    |> Enum.map(&{&1, local_version(&1)})
    |> Enum.sort()
  end

  defp field_references(field) do
    [
      field.reference
      | Enum.flat_map([field.map_key_field, field.map_value_field], fn
          nil -> []
          nested -> field_references(nested)
        end)
    ]
    |> Enum.filter(&(is_atom(&1) and not is_nil(&1)))
  end

  defp prune_plan_generations(cache, module, version) do
    :ets.select_delete(cache, [
      {{{:plan, module, :"$1", :_}, :_}, [{:"=/=", :"$1", {:const, version}}], [true]}
    ])

    :ok
  end

  defp prune_descriptor_generations(cache, module, local_version) do
    :ets.select_delete(cache, [
      {{{:descriptor, module, :"$1"}, :_, :_}, [{:"=/=", :"$1", {:const, local_version}}], [true]}
    ])

    :ok
  end

  # 同時コンパイルも各呼び出しの miss として数え、入力の値は公開しない。
  defp record(stats, result, module) do
    counter = if result == :hit, do: :hits, else: :misses
    :ets.update_counter(stats, counter, {2, 1}, {counter, 0})

    :telemetry.execute(
      [:protovalidate, :plan_cache, result],
      %{count: 1},
      %{message_module: module}
    )
  end
end
