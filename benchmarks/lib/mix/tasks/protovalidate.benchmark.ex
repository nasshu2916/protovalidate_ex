defmodule Mix.Tasks.Protovalidate.Benchmark do
  @shortdoc "Measure time and memory for normalization, compilation, API calls, recursion, and collections"
  @moduledoc """
  Run with `MIX_ENV=test mix protovalidate.benchmark`.
  Use `--time 2 --warmup 1 --memory-time 1 --output result.csv` to set measurement
  options and an output path. Input setup, plan construction, and correctness checks
  are performed outside the measured interval.
  """
  use Mix.Task

  alias Protovalidate.{DescriptorAdapter, Plan, ValidationError, Validator}

  @requirements ["app.start"]
  @extensions [
    {:field, Buf.Validate.PbExtension, :field},
    {:message, Buf.Validate.PbExtension, :message},
    {:oneof, Buf.Validate.PbExtension, :oneof}
  ]
  @size 3000
  @depth 100

  @impl Mix.Task
  def run(args) do
    {options, []} =
      OptionParser.parse!(args,
        strict: [time: :integer, warmup: :integer, memory_time: :integer, output: :string]
      )

    module = Module.concat([Acme, Descriptor, V1, Probe])
    unless Code.ensure_loaded?(module), do: Mix.raise("Run this task with MIX_ENV=test")
    validator = Protovalidate.new()

    try do
      benchmarks = scenarios(module, validator)

      Mix.shell().info(
        "Preflight passed: ETS cleanup, a violation path at depth 100, and 3,000 repeated/map violations each"
      )

      suite = measure(benchmarks, options)
      if path = options[:output], do: save(suite, path)
    after
      Validator.close(validator)
    end
  end

  defp scenarios(module, validator) do
    descriptor = DescriptorAdapter.describe(module, extensions: @extensions)
    message = struct(module, implicit_string: "allowed", contact: {:email, "a@example.com"})
    {:ok, ^message} = Validator.validate(validator, message)
    check_temporary_cache!(message)

    %{
      "descriptor_normalize" => fn ->
        DescriptorAdapter.describe(module, extensions: @extensions)
      end,
      "plan_compile" => fn -> Plan.compile(descriptor, []) end,
      "cold_api" => fn -> Protovalidate.validate(message) end,
      "warm_api" => fn -> Validator.validate(validator, message) end
    }
    |> Map.merge(cel_field_access_scenarios(validator))
    |> Map.merge(concurrent_scenarios(message, validator))
    |> Map.merge(many_cel_scenarios(descriptor, message))
    |> Map.merge(recursive_scenarios(validator))
    |> Map.merge(collection_scenarios(descriptor, message))
  end

  defp concurrent_scenarios(message, warm_validator) do
    %{
      "cold_concurrent_8" => fn ->
        validator = Validator.new()

        try do
          validate_concurrently(validator, message)
        after
          Validator.close(validator)
        end
      end,
      "warm_concurrent_8" => fn -> validate_concurrently(warm_validator, message) end
    }
  end

  defp validate_concurrently(validator, message) do
    tasks = for _ <- 1..8, do: Task.async(fn -> Validator.validate(validator, message) end)
    results = Task.await_many(tasks, 30_000)
    true = Enum.all?(results, &match?({:ok, ^message}, &1))
    results
  end

  defp many_cel_scenarios(descriptor, message) do
    rules =
      for index <- 1..20,
          do: %{id: "rule_#{index}", expression: "true", message: "allowed"}

    descriptor = %{descriptor | validation: %{message: %{cel: rules}}}
    plan = Plan.compile(descriptor, [])
    {:ok, []} = Plan.evaluate(plan, message, fail_fast: false)

    %{
      "cel_20_rules" => fn ->
        Plan.evaluate(plan, message, fail_fast: false)
      end
    }
  end

  defp cel_field_access_scenarios(validator) do
    module = Module.concat([Acme, User, V1, User])

    message =
      struct(module,
        id: "00000000-0000-0000-0000-000000000000",
        email: "ada@example.com",
        first_name: "Ada",
        last_name: "Lovelace"
      )

    {:ok, ^message} = Validator.validate(validator, message)
    %{"cel_field_access" => fn -> Validator.validate(validator, message) end}
  end

  defp recursive_scenarios(validator) do
    module = Module.concat([Acme, Descriptor, V1, RecursiveNode])
    valid = nested(module, struct(module, code: "ok"))
    invalid = nested(module, struct(module))
    {:ok, ^valid} = Validator.validate(validator, valid)
    {:error, %ValidationError{violations: [violation]}} = Validator.validate(validator, invalid)
    expected = List.duplicate({:field, "child"}, @depth) ++ [{:field, "code"}]
    ^expected = violation.field_path.segments

    %{
      "deep_valid_100" => fn -> Validator.validate(validator, valid) end,
      "deep_invalid_100" => fn -> Validator.validate(validator, invalid) end
    }
  end

  defp nested(module, leaf) do
    Enum.reduce(1..@depth, leaf, fn _, child -> struct(module, code: "ok", child: child) end)
  end

  defp collection_scenarios(descriptor, message) do
    repeated = %{items: %{type: {:string, %{min_len: 1}}}}
    map = %{values: %{type: {:uint32, %{gte: 1}}}}

    [
      {"repeated", :labels, repeated, List.duplicate("ok", @size), List.duplicate("", @size)},
      {"map", :scores, map, Map.new(1..@size, &{"key-#{&1}", 1}),
       Map.new(1..@size, &{"key-#{&1}", 0})}
    ]
    |> Enum.flat_map(fn {kind, name, rules, valid, invalid} ->
      field = Enum.find(descriptor.fields, &(&1.name == Atom.to_string(name)))
      type = if kind == "map", do: :map, else: :repeated
      field = %{field | validation: %{field: %{type: {type, rules}}}}
      plan = Plan.compile(%{descriptor | fields: [field], oneofs: [], validation: %{}}, [])

      for {status, value, count} <- [{"valid", valid, 0}, {"invalid", invalid, @size}] do
        input = Map.put(message, name, value)
        {:ok, violations} = Plan.evaluate(plan, input, fail_fast: false)
        ^count = length(violations)
        {"#{kind}_#{status}_#{@size}", fn -> Plan.evaluate(plan, input, fail_fast: false) end}
      end
    end)
    |> Map.new()
  end

  defp check_temporary_cache!(message) do
    before = owned_tables()

    for _ <- 1..20 do
      {:ok, ^message} = Protovalidate.validate(message)
      {:error, %ValidationError{}} = Protovalidate.validate(%{message | implicit_string: ""})
    end

    ^before = owned_tables()
  end

  defp owned_tables do
    :ets.all() |> Enum.filter(&(:ets.info(&1, :owner) == self())) |> MapSet.new()
  end

  defp measure(benchmarks, options) do
    config = [
      time: Keyword.get(options, :time, 2),
      warmup: Keyword.get(options, :warmup, 1),
      memory_time: Keyword.get(options, :memory_time, 1),
      parallel: 1
    ]

    # Benchee は test 環境限定なので、開発環境の静的解析から直接参照しない。
    # credo:disable-for-next-line Credo.Check.Refactor.Apply
    apply(Benchee, :run, [benchmarks, config])
  end

  defp save(suite, path) do
    rows =
      Enum.map(suite.scenarios, fn scenario ->
        time = scenario.run_time_data.statistics
        memory = scenario.memory_usage_data.statistics

        Enum.join(
          [
            scenario.name,
            time.average,
            time.median,
            time.std_dev_ratio,
            memory.average,
            memory.std_dev_ratio,
            time.sample_size,
            memory.sample_size
          ],
          ","
        )
      end)

    File.write!(
      path,
      Enum.join(
        [
          "scenario,mean_ns,median_ns,time_cv,memory_bytes,memory_cv,time_samples,memory_samples"
          | rows
        ],
        "\n"
      ) <> "\n"
    )
  end
end
