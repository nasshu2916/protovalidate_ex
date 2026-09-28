defmodule Protovalidate.Plan.EvaluatorTest do
  use ExUnit.Case, async: true

  alias Acme.Descriptor.V1.{CELNode, RecursiveNode}
  alias Protovalidate.{DescriptorAdapter, Plan, ValidationError, Validator}
  alias Protovalidate.Plan.{Context, Evaluator, FieldPlan}
  alias Protovalidate.Validator.PlanCache

  test "collection の走査対象と子参照を FieldPlan に明示する" do
    plan = PlanCache.for_module(RecursiveNode, [])
    fields = Map.new(plan.fields, &{&1.field.name, &1})

    assert %Plan.FieldPlan{
             checks: [],
             collection: %Plan.CollectionPlan{
               items: %Plan.FieldPlan{child: RecursiveNode},
               keys: nil,
               values: nil
             }
           } = fields["children"]

    assert %Plan.FieldPlan{
             collection: %Plan.CollectionPlan{
               items: nil,
               keys: nil,
               values: %Plan.FieldPlan{child: RecursiveNode}
             }
           } = fields["signed_children"]

    refute Enum.any?(plan.fields, &Enum.any?(&1.checks, fn rule -> match?({:items, _}, rule) end))
  end

  test "深い再帰は必要な plan だけを取得し、完全なパスを構築する" do
    message =
      Enum.reduce(1..100, %RecursiveNode{}, fn _, child ->
        %RecursiveNode{code: "ok", child: child}
      end)

    validator = Protovalidate.new()

    assert {:error, %ValidationError{violations: [violation]}} =
             Validator.validate(validator, message)

    assert violation.field_path.segments ==
             List.duplicate({:field, "child"}, 100) ++ [{:field, "code"}]

    assert violation.rule_id == "string.min_len"
    assert Validator.cache_stats(validator) == %{size: 1, misses: 1, hits: 100}
  end

  test "collection の子メッセージも走査し、兄弟間でパスを復元する" do
    message = %RecursiveNode{
      code: "ok",
      child: %RecursiveNode{},
      children: [%RecursiveNode{child: %RecursiveNode{}}],
      signed_children: %{7 => %RecursiveNode{}},
      unsigned_children: %{7 => %RecursiveNode{}}
    }

    assert {:error, %ValidationError{violations: violations}} = Protovalidate.validate(message)

    assert Enum.map(violations, & &1.field_path.segments) == [
             [{:field, "child"}, {:field, "code"}],
             [{:field, "children"}, {:index, 0}, {:field, "code"}],
             [{:field, "children"}, {:index, 0}, {:field, "child"}, {:field, "code"}],
             [{:field, "signed_children"}, {:map_key, :int, 7}, {:field, "code"}],
             [{:field, "unsigned_children"}, {:map_key, :uint, 7}, {:field, "code"}]
           ]

    assert Enum.all?(violations, &(not &1.for_key))
  end

  test "直接 Plan 評価も子の CEL 設定を伝播し、fail_fast は兄弟と親 CEL を止める" do
    options = [cel: {Protovalidate.TestCEL, parent: self()}, fail_fast: true]
    plan = PlanCache.for_module(CELNode, options)

    for message <- [
          %CELNode{child: %CELNode{}, children: [%CELNode{}]},
          %CELNode{children: [%CELNode{}, %CELNode{}]},
          %CELNode{children_by_name: %{"a" => %CELNode{}, "b" => %CELNode{}}}
        ] do
      assert {:ok, [violation]} = Plan.evaluate(plan, message, options)
      assert violation.rule_id == "node"
      assert violation.rule_path == ["cel", "node"]
      assert_receive {:cel_evaluate, :message}
      refute_receive {:cel_evaluate, :message}
    end
  end

  test "時刻依存ルールは子と collection で同じ基準時刻を使う" do
    timestamp = %Google.Protobuf.Timestamp{seconds: 101}
    child = %RecursiveNode{code: "ok", timestamp: timestamp}

    message = %RecursiveNode{
      code: "ok",
      timestamp: timestamp,
      child: child,
      children: [child],
      signed_children: %{1 => child}
    }

    plan = PlanCache.for_module(RecursiveNode, [])

    assert {:ok, []} =
             Plan.evaluate(plan, message, fail_fast: false, now: %{seconds: 100, nanos: 0})

    assert {:ok, violations} =
             Plan.evaluate(plan, message, fail_fast: false, now: %{seconds: 102, nanos: 0})

    assert length(violations) == 4
    assert Enum.all?(violations, &(&1.rule_id == "timestamp.gt_now"))
  end

  test "CEL を含まない repeated と map は期限到達後に残りの要素を走査しない" do
    repeated_field = collection_field(:repeated)
    map_field = collection_field(:map)

    cases = [
      {:items, [{:min_len, 1}], Stream.map(1..10, &"item-#{&1}"), repeated_field},
      {:values, [{:gte, 0}], Stream.map(1..10, &{"key-#{&1}", &1}), map_field}
    ]

    for {kind, rules, values, field} <- cases do
      clock_key = {__MODULE__, kind, :clock}
      visited_key = {__MODULE__, kind, :visited}
      Process.put(clock_key, 0)
      Process.put(visited_key, 0)

      # 実時間ではなく呼び出し回数で期限を進め、テストの揺らぎを避ける。
      clock = fn ->
        current = Process.get(clock_key)
        Process.put(clock_key, current + 1)
        current
      end

      values =
        Stream.map(values, fn value ->
          Process.put(visited_key, Process.get(visited_key) + 1)
          value
        end)

      context = Context.new([fail_fast: false, validation_timeout: 3], clock)
      virtual = %{DescriptorAdapter.collection_field(field, kind) | name: ""}

      item_plan = %FieldPlan{
        field: virtual,
        checks: rules,
        presence: :optional,
        ignore: nil,
        collection: nil,
        child: nil
      }

      assert_raise Protovalidate.RuntimeError, "validation timeout", fn ->
        Evaluator.collection(kind, item_plan, values, field, context)
      end

      assert Process.get(visited_key) == 3
    end
  end

  test "検証 Telemetry は子から親の順に部分木の違反数を報告する" do
    id = {__MODULE__, self()}
    :ok = :telemetry.attach(id, [:protovalidate, :validation, :stop], &__MODULE__.event/4, self())
    on_exit(fn -> :telemetry.detach(id) end)
    message = %RecursiveNode{child: %RecursiveNode{}}
    assert {:error, _} = Protovalidate.validate(message)

    assert_receive {:validation, %{violations: 1, duration: child_duration},
                    %{message_module: RecursiveNode, outcome: :ok}}

    assert_receive {:validation, %{violations: 2, duration: parent_duration},
                    %{message_module: RecursiveNode, outcome: :ok}}

    assert parent_duration >= child_duration
    refute_receive {:validation, _, _}
  end

  test "fail_fast は子 plan の取得も停止する" do
    validator = Protovalidate.new(fail_fast: true)
    message = %RecursiveNode{child: %RecursiveNode{}, children: [%RecursiveNode{}]}
    assert {:error, %ValidationError{violations: [_]}} = Validator.validate(validator, message)
    assert Validator.cache_stats(validator) == %{size: 1, misses: 1, hits: 0}
  end

  test "子の実行障害は親へ伝播し、両方の Telemetry を error とする" do
    id = {__MODULE__, self()}
    :ok = :telemetry.attach(id, [:protovalidate, :validation, :stop], &__MODULE__.event/4, self())
    on_exit(fn -> :telemetry.detach(id) end)
    validator = Protovalidate.new(cel: {__MODULE__.FailingCEL, []})

    assert {:error, %Protovalidate.RuntimeError{}} =
             Validator.validate(validator, %CELNode{child: %CELNode{}})

    for _ <- 1..2 do
      assert_receive {:validation, %{violations: 0}, %{message_module: CELNode, outcome: :error}}
    end

    refute_receive {:validation, _, _}
  end

  defmodule FailingCEL do
    @behaviour Protovalidate.CEL
    @impl true
    def compile(rule, _environment, _options), do: {:ok, rule.expression}
    @impl true
    def evaluate(_expression, _environment, _options), do: {:error, "evaluation failed"}
  end

  def event(_name, measurements, metadata, pid) do
    if self() == pid, do: send(pid, {:validation, measurements, metadata})
  end

  defp collection_field(kind) do
    %DescriptorAdapter.Field{
      name: if(kind == :repeated, do: "labels", else: "scores"),
      json_name: if(kind == :repeated, do: "labels", else: "scores"),
      number: 1,
      type: :TYPE_STRING,
      repeated?: kind == :repeated,
      map?: kind == :map,
      item_type: if(kind == :repeated, do: :TYPE_STRING),
      map_key: if(kind == :map, do: :TYPE_STRING),
      map_value: if(kind == :map, do: :TYPE_UINT32),
      oneof: nil,
      presence: :implicit,
      well_known_type: nil,
      validation: %{}
    }
  end
end
