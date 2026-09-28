defmodule Protovalidate.Rules.CustomTest do
  use ExUnit.Case, async: true

  import Protovalidate.TestRules

  alias Protovalidate.{Plan, PredefinedRuleRegistry}

  test "CEL の空文字列は成功し、非空文字列は違反メッセージになる" do
    for {result, count} <- [{true, 0}, {"", 0}, {false, 1}, {"具体的な理由", 1}] do
      plan =
        plan(field(:TYPE_STRING), %{cel_expression: ["result"]},
          cel: {Protovalidate.TestCEL, result: result}
        )

      assert {:ok, violations} =
               Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{}, fail_fast: false)

      assert length(violations) == count

      if is_binary(result) and result != "" do
        assert [%{rule_id: "result", message: ^result}] = violations
      end
    end
  end

  test "CEL 未指定時も既定実行器と制限で評価する" do
    compiled = plan(field(:TYPE_STRING), %{cel_expression: ["true"]})

    assert {:ok, []} =
             Plan.evaluate(compiled, %Acme.Descriptor.V1.Probe{}, fail_fast: false)
  end

  test "message CEL の重複 ID も拒否する" do
    assert_raise Protovalidate.CompilationError, ~r/duplicate/, fn ->
      Protovalidate.Rules.Custom.compile_cel_rules!(
        %{cel_expression: ["true", "true"]},
        :message,
        "test.Probe",
        cel: Protovalidate.TestCEL
      )
    end
  end

  test "timeout 後に監視・遅延応答を mailbox に残さない" do
    compiled =
      Protovalidate.CEL.compile!(
        {Protovalidate.TestCEL, timeout: 1},
        %{id: "slow", expression: "slow"},
        %{this: nil, rule: %{}, scope: :field, message_type: "test.Probe"}
      )

    {:messages, before} = Process.info(self(), :messages)

    for _ <- 1..20 do
      assert_raise Protovalidate.RuntimeError, ~r/timeout/, fn ->
        Protovalidate.CEL.evaluate!(compiled, %{
          this: nil,
          rule: %{},
          scope: :field,
          message_type: "test.Probe"
        })
      end
    end

    assert {:messages, ^before} = Process.info(self(), :messages)
  end

  test "既定 CEL 制限を全設定形式へ適用し、callback を分離する" do
    environment = %{this: nil, rule: %{}, scope: :field, message_type: "test.Probe"}

    for configuration <- [Protovalidate.TestCEL, {Protovalidate.TestCEL, []}] do
      compiled =
        Protovalidate.CEL.compile!(configuration, %{id: "pid", expression: "pid"}, environment)

      assert compiled.options == []

      assert compiled.limits == %{
               compile_timeout: 1_000,
               timeout: 1_000,
               max_heap_size: 8_000_000
             }

      refute compiled.expression == self()
      assert Protovalidate.CEL.evaluate!(compiled, environment)
    end

    compiled =
      Protovalidate.CEL.compile!(
        {Protovalidate.TestCEL, timeout: 17},
        %{id: "pid", expression: "pid"},
        environment
      )

    assert compiled.options == [timeout: 17]
    assert compiled.limits == %{compile_timeout: 1_000, timeout: 17, max_heap_size: 8_000_000}
  end

  test "既定 timeout と heap 制限を compile と evaluate に適用する" do
    environment = %{this: nil, rule: %{}, scope: :field, message_type: "test.Probe"}

    assert_raise Protovalidate.CompilationError, ~r/timeout/, fn ->
      Protovalidate.CEL.compile!(
        Protovalidate.TestCEL,
        %{id: "slow", expression: "slow_compile_default"},
        environment
      )
    end

    compiled =
      Protovalidate.CEL.compile!(
        Protovalidate.TestCEL,
        %{id: "slow", expression: "slow_default"},
        environment
      )

    assert_raise Protovalidate.RuntimeError, ~r/timeout/, fn ->
      Protovalidate.CEL.evaluate!(compiled, environment)
    end

    assert_raise Protovalidate.CompilationError, ~r/process_exit/, fn ->
      Protovalidate.CEL.compile!(
        {Protovalidate.TestCEL, max_heap_size: 1_000},
        %{id: "heap", expression: "heap"},
        environment
      )
    end

    assert_raise Protovalidate.RuntimeError, ~r/process_exit/, fn ->
      Protovalidate.CEL.evaluate!(
        %{compiled | expression: "heap", limits: %{compiled.limits | max_heap_size: 1_000}},
        environment
      )
    end
  end

  test "CEL コンパイルと検証全体に別々の時間制限を適用する" do
    assert_raise Protovalidate.CompilationError, ~r/timeout/, fn ->
      plan(field(:TYPE_STRING), %{cel_expression: ["slow_compile"]},
        cel: {Protovalidate.TestCEL, compile_timeout: 1}
      )
    end

    compiled =
      plan(field(:TYPE_STRING), %{cel_expression: ["delay_true", "delay_true == true"]},
        cel: Protovalidate.TestCEL
      )

    assert_raise Protovalidate.RuntimeError, ~r/timeout/, fn ->
      Plan.evaluate(compiled, %Acme.Descriptor.V1.Probe{},
        fail_fast: false,
        validation_timeout: 1
      )
    end
  end

  test "標準、CEL、extension 番号順の predefined の違反順序を保つ" do
    registry =
      PredefinedRuleRegistry.new(%{
        1001 => %{rule_type: :map, cel: [%{id: "first", expression: "false"}]},
        1002 => %{rule_type: :map, cel: [%{id: "second", expression: "false"}]}
      })

    plan =
      plan(
        field(:TYPE_STRING),
        %{
          type: {:string, %{min_len: 2, __pb_extensions__: %{1002 => true, 1001 => true}}},
          cel: [%{id: "custom", expression: "false"}]
        },
        cel: Protovalidate.TestCEL,
        registry: registry
      )

    assert {:ok, violations} =
             Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{implicit_string: "x"},
               fail_fast: false
             )

    assert Enum.map(violations, & &1.rule_id) == ["string.min_len", "custom", "first", "second"]

    assert Enum.map(Enum.drop(violations, 1), & &1.rule_path) == [
             ["cel", "custom"],
             ["predefined", "1001", "first"],
             ["predefined", "1002", "second"]
           ]
  end
end
