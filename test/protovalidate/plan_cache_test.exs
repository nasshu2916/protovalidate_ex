defmodule Protovalidate.PlanCacheTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  alias Protovalidate.{DescriptorAdapter, Validator}
  alias Protovalidate.Validator.PlanCache

  defmodule BrokenMessage do
    defstruct []
    def descriptor, do: raise("descriptor failure")
  end

  defmodule BrokenMessageProps do
    defstruct []
    def descriptor, do: Acme.Descriptor.V1.Legacy.descriptor()
    def __message_props__, do: raise("message props failure")
    def full_name, do: Acme.Descriptor.V1.Legacy.full_name()
  end

  defmodule BrokenFullName do
    defstruct []
    def descriptor, do: Acme.Descriptor.V1.Legacy.descriptor()
    def __message_props__, do: Acme.Descriptor.V1.Legacy.__message_props__()
    def full_name, do: raise("full name failure")
  end

  defmodule InvalidChild do
    defstruct []
    def descriptor, do: raise("invalid child descriptor")
  end

  defmodule ParentWithInvalidChild do
    defstruct []
    def descriptor, do: Acme.Descriptor.V1.Probe.descriptor()
    def full_name, do: Acme.Descriptor.V1.Probe.full_name()

    def __message_props__ do
      props = Acme.Descriptor.V1.Probe.__message_props__()

      fields =
        Map.new(props.field_props, fn {number, field} ->
          if field.name_atom == :child,
            do: {number, %{field | type: InvalidChild}},
            else: {number, field}
        end)

      %{props | field_props: fields}
    end
  end

  defmodule ConcurrentCEL do
    @behaviour Protovalidate.CEL

    @impl true
    def compile(_rule, _environment, options) do
      send(Keyword.fetch!(options, :parent), {:compiling, self()})

      receive do
        :continue -> {:ok, self()}
      end
    end

    @impl true
    def evaluate(_compiled, _environment, _options), do: {:ok, true}
  end

  test "競合した同一 key は一度だけコンパイルして全呼び出しで共有する" do
    {cache, stats} = PlanCache.new()

    descriptor = %DescriptorAdapter.Message{
      module: Acme.Descriptor.V1.Legacy,
      full_name: "test.Concurrent",
      fields: [],
      oneofs: [],
      validation: %{message: %{cel: [%{id: "test", expression: "true", message: "test"}]}}
    }

    options = [cel: {ConcurrentCEL, parent: self()}]

    tasks =
      for _ <- 1..8, do: Task.async(fn -> PlanCache.fetch(cache, stats, descriptor, options) end)

    assert_receive {:compiling, compiler}, 5_000
    refute_receive {:compiling, _other}, 50
    send(compiler, :continue)
    plans = Task.await_many(tasks)
    assert length(Enum.uniq(plans)) == 1
    assert %{hits: 0, misses: 8, size: 1} = PlanCache.stats(cache, stats)
    assert PlanCache.fetch(cache, stats, descriptor, options) == hd(plans)
  end

  test "コンパイル設定と descriptor を分離し、評価設定では plan を再利用する" do
    {cache, stats} = PlanCache.new()
    descriptor = DescriptorAdapter.describe(Acme.Descriptor.V1.Legacy)
    plan = PlanCache.fetch(cache, stats, descriptor, [])
    assert PlanCache.fetch(cache, stats, descriptor, fail_fast: true) == plan

    for options <- [
          [cel: Protovalidate.TestCEL],
          [legacy_required: true],
          [registry: %{}],
          [regex_matcher: :custom]
        ] do
      PlanCache.fetch(cache, stats, descriptor, options)
    end

    PlanCache.fetch(cache, stats, %{descriptor | full_name: "changed.Legacy"}, [])
    assert %{hits: 2, misses: 5, size: 1} = PlanCache.stats(cache, stats)
    assert :ok = PlanCache.delete(cache, stats)
  end

  test "既定値の省略と指定順は同じ plan identity を使う" do
    {cache, stats} = PlanCache.new()
    descriptor = DescriptorAdapter.describe(Acme.Descriptor.V1.Legacy)

    plan = PlanCache.fetch(cache, stats, descriptor, [])
    assert PlanCache.fetch(cache, stats, descriptor, legacy_required: false, cel: nil) == plan
    assert PlanCache.fetch(cache, stats, descriptor, cel: nil, legacy_required: false) == plan
    assert %{misses: 1, hits: 2, size: 1} = PlanCache.stats(cache, stats)
    assert :ok = PlanCache.delete(cache, stats)
  end

  test "prepare は子型と再帰型を一度ずつ準備し検証結果を維持する" do
    alias Acme.Descriptor.V1.{Probe, RecursiveNode}

    lazy = Validator.new()
    prepared = Validator.new()

    assert :ok = Validator.prepare(prepared, Probe)
    assert Validator.cache_stats(prepared).size > 1
    assert :ok = Validator.prepare(prepared, RecursiveNode)
    assert :ok = Validator.prepare(prepared, RecursiveNode)

    message = %Probe{}
    assert Validator.validate(prepared, message) == Validator.validate(lazy, message)

    assert :ok = Validator.close(lazy)
    assert :ok = Validator.close(prepared)
  end

  test "prepare は入力を受け取る前に子型の descriptor 不正を検出する" do
    validator = Validator.new()

    assert {:error, %Protovalidate.CompilationError{}} =
             Validator.prepare(validator, ParentWithInvalidChild)

    assert :ok = Validator.close(validator)
  end

  test "module の再ロード後は正規化 descriptor と plan を再利用しない" do
    {cache, stats} = PlanCache.new()
    module = Module.concat(__MODULE__, "Reloadable#{System.unique_integer([:positive])}")

    define_reloadable_message(module, "test.Reloadable.One")
    PlanCache.for_module(module, validator: %{cache: cache, stats: stats})
    assert %{misses: 1, size: 1} = PlanCache.stats(cache, stats)

    capture_io(:stderr, fn -> define_reloadable_message(module, "test.Reloadable.Two") end)
    PlanCache.for_module(module, validator: %{cache: cache, stats: stats})
    assert %{misses: 2, size: 1} = PlanCache.stats(cache, stats)
    assert :ok = PlanCache.delete(cache, stats)
  end

  test "参照先 module だけの再ロードでも plan を無効化して旧世代を回収する" do
    {cache, stats} = PlanCache.new()
    dependency = Module.concat(__MODULE__, "Dependency#{System.unique_integer([:positive])}")
    define_reloadable_message(dependency, "test.Dependency.One")

    child_field =
      Acme.Descriptor.V1.Probe
      |> DescriptorAdapter.describe()
      |> Map.fetch!(:fields)
      |> Enum.find(&(&1.name == "child"))

    descriptor = DescriptorAdapter.describe(Acme.Descriptor.V1.Legacy)
    descriptor = %{descriptor | fields: [%{child_field | reference: dependency}]}
    PlanCache.fetch(cache, stats, descriptor, [])
    assert %{misses: 1, size: 1} = PlanCache.stats(cache, stats)

    capture_io(:stderr, fn -> define_reloadable_message(dependency, "test.Dependency.Two") end)
    PlanCache.fetch(cache, stats, descriptor, [])
    assert %{misses: 2, size: 1} = PlanCache.stats(cache, stats)
  end

  test "旧世代のコンパイルが新世代の登録後に終わっても旧 plan を保存しない" do
    {cache, stats} = PlanCache.new()

    descriptor = %DescriptorAdapter.Message{
      module: Acme.Descriptor.V1.Legacy,
      full_name: "test.Generation.Old",
      fields: [],
      oneofs: [],
      validation: %{message: %{cel: [%{id: "test", expression: "true", message: "test"}]}}
    }

    newer = %{descriptor | full_name: "test.Generation.New"}
    options = [cel: {ConcurrentCEL, parent: self()}]
    old_task = Task.async(fn -> PlanCache.fetch(cache, stats, descriptor, options) end)
    assert_receive {:compiling, old_compiler}, 5_000

    new_task = Task.async(fn -> PlanCache.fetch(cache, stats, newer, options) end)
    assert_receive {:compiling, new_compiler}, 5_000
    send(new_compiler, :continue)
    new_plan = Task.await(new_task)
    assert %{size: 1} = PlanCache.stats(cache, stats)

    send(old_compiler, :continue)
    old_plan = Task.await(old_task)
    refute old_plan == new_plan
    assert %{size: 1} = PlanCache.stats(cache, stats)
    assert PlanCache.fetch(cache, stats, newer, options) == new_plan
    assert %{hits: 1, misses: 2, size: 1} = PlanCache.stats(cache, stats)
  end

  test "コンパイル待機者の timeout でも lock を破棄せず、完了後に再利用する" do
    {cache, stats} = PlanCache.new()

    descriptor = %DescriptorAdapter.Message{
      module: Acme.Descriptor.V1.Legacy,
      full_name: "test.WaitTimeout",
      fields: [],
      oneofs: [],
      validation: %{message: %{cel: [%{id: "test", expression: "true", message: "test"}]}}
    }

    options = [cel: {ConcurrentCEL, parent: self()}]
    compiler = Task.async(fn -> PlanCache.fetch(cache, stats, descriptor, options) end)
    assert_receive {:compiling, compiler_pid}, 5_000

    budget = Protovalidate.ValidationBudget.new(validation_timeout: 10)

    assert_raise Protovalidate.RuntimeError, "validation timeout", fn ->
      PlanCache.fetch(cache, stats, descriptor, Keyword.put(options, :validation_budget, budget))
    end

    send(compiler_pid, :continue)
    plan = Task.await(compiler)
    assert PlanCache.fetch(cache, stats, descriptor, options) == plan
  end

  test "コンパイル担当が停止した場合は待機者が lock を回収して再試行する" do
    {cache, stats} = PlanCache.new()

    descriptor = %DescriptorAdapter.Message{
      module: Acme.Descriptor.V1.Legacy,
      full_name: "test.OwnerDown",
      fields: [],
      oneofs: [],
      validation: %{message: %{cel: [%{id: "test", expression: "true", message: "test"}]}}
    }

    options = [cel: {ConcurrentCEL, parent: self()}]
    doomed = spawn(fn -> PlanCache.fetch(cache, stats, descriptor, options) end)
    assert_receive {:compiling, _cel_worker}, 5_000

    waiter = Task.async(fn -> PlanCache.fetch(cache, stats, descriptor, options) end)
    Process.exit(doomed, :kill)
    assert_receive {:compiling, retry_pid}, 5_000
    send(retry_pid, :continue)
    assert %Protovalidate.Plan{} = Task.await(waiter)
  end

  test "所有者が生存する間は別プロセスで利用でき、終了すると両テーブルが消える" do
    parent = self()

    {owner, monitor} =
      spawn_monitor(fn ->
        send(parent, {:validator, Validator.new()})

        receive do
          :stop -> :ok
        end
      end)

    assert_receive {:validator, validator}
    assert {:ok, _} = Validator.validate(validator, %Acme.Descriptor.V1.Legacy{})
    assert %{misses: 1, size: 1} = Validator.cache_stats(validator)
    send(owner, :stop)
    assert_receive {:DOWN, ^monitor, :process, ^owner, :normal}
    assert :ets.info(validator.cache) == :undefined
    assert :ets.info(validator.stats) == :undefined
  end

  test "失敗したコンパイルは保存せず再試行も miss として数える" do
    validator = Validator.new(cel: Protovalidate.FailingCEL)

    for _ <- 1..2 do
      assert {:error, %Protovalidate.CompilationError{}} =
               Validator.validate(validator, %Acme.User.V1.User{})
    end

    assert %{hits: 0, misses: 2, size: 0} = Validator.cache_stats(validator)
    assert :ok = Validator.close(validator)
  end

  test "利便 API は違反、コンパイル失敗、descriptor 不整合でも一時テーブルを解放する" do
    validator = Validator.new()
    initial_tables = owned_tables()

    for _ <- 1..3 do
      assert {:error, %Protovalidate.ValidationError{}} =
               Protovalidate.validate(%Acme.User.V1.User{}, cel: Protovalidate.TestCEL)

      assert {:error, %Protovalidate.CompilationError{}} =
               Protovalidate.validate(%Acme.User.V1.User{}, cel: Protovalidate.FailingCEL)

      assert_descriptor_error(%BrokenMessage{})
      assert_descriptor_error(%BrokenMessageProps{})
      assert_descriptor_error(%BrokenFullName{})

      assert_raise Protovalidate.ValidationError, fn ->
        Protovalidate.validate!(%Acme.User.V1.User{}, cel: Protovalidate.TestCEL)
      end

      assert owned_tables() == initial_tables
    end

    assert {:ok, _} = Validator.validate(validator, %Acme.Descriptor.V1.Legacy{})
  end

  defp owned_tables do
    :ets.all()
    |> Enum.filter(&(:ets.info(&1, :owner) == self()))
    |> Enum.sort()
  end

  defp define_reloadable_message(module, full_name) do
    Module.create(
      module,
      quote do
        def descriptor, do: Acme.Descriptor.V1.Legacy.descriptor()
        def __message_props__, do: Acme.Descriptor.V1.Legacy.__message_props__()
        def full_name, do: unquote(full_name)
      end,
      Macro.Env.location(__ENV__)
    )
  end

  defp assert_descriptor_error(message) do
    assert {:error, %Protovalidate.CompilationError{message: error}} =
             Protovalidate.validate(message)

    assert error == "invalid Protobuf message descriptor"

    raised =
      assert_raise Protovalidate.CompilationError, fn -> Protovalidate.validate!(message) end

    assert Exception.message(raised) == error
  end
end
