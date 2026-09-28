defmodule Protovalidate.Rules.NumericTest do
  use ExUnit.Case, async: true

  import Protovalidate.TestRules

  alias Protovalidate.{CompilationError, Rules, UnsupportedRuleError}
  alias Protovalidate.Rules.Numeric

  test "数値の型検証と未知ルール検出はエラーのパスを保つ" do
    for {rules, path} <- [{%{lt: 1, lte: 2}, ["int32"]}, {%{in: [1, "x"]}, ["int32", "in"]}] do
      error =
        assert_raise CompilationError, fn ->
          Numeric.compile(field(:TYPE_INT32), rules, :int32)
        end

      assert error.rule_path == path
    end

    error =
      assert_raise CompilationError, fn ->
        Numeric.compile(field(:TYPE_STRING), %{gt: 1}, :int32)
      end

    assert error.rule_path == ["implicit_string", "int32"]

    error =
      assert_raise UnsupportedRuleError, fn ->
        Numeric.compile(field(:TYPE_INT32), %{unknown: true}, :int32)
      end

    assert error.rule_path == ["int32", "unknown"]
  end

  test "数値の比較と共通集合判定の順序と詳細を保つ" do
    field = field(:TYPE_INT32)
    rules = Numeric.compile(field, %{lte: 5, in: [1, 2]}, :int32)
    result = Enum.reduce_while(rules, context(), &Rules.evaluate(&1, 10, field, &2))
    assert [membership, comparison] = result.violations
    assert membership.rule_id == "int32.in"
    assert comparison.rule_id == "int32.lte"
    assert comparison.details == %{lte: 5}
  end
end
