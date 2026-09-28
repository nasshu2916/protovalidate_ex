defmodule Protovalidate.Rules.PatternTest do
  use ExUnit.Case, async: true

  alias Protovalidate.Rules.Pattern

  test "BEAM の Unicode 照合を string と bytes で共有する" do
    for kind <- [:string, :bytes] do
      assert [{:pattern, regex}] = Pattern.compile([{:pattern, "^.$"}], kind)
      assert Pattern.match?(regex, "é")
      refute Pattern.match?(regex, "ab")
    end
  end

  test "照合の実行上限を通常の不一致と区別する" do
    [{:pattern, regex}] = Pattern.compile([{:pattern, "^(a+)+$"}], :string)

    error =
      assert_raise Protovalidate.RuntimeError, fn ->
        Pattern.match?(regex, String.duplicate("a", 30) <> "!")
      end

    assert error.message == "pattern match failed: :match_limit"
  end

  test "BEAM が受理する RE2 非対応構文も受理する" do
    assert [{:pattern, regex}] = Pattern.compile([{:pattern, "^(a)\\1$"}], :string)
    assert Pattern.match?(regex, "aa")
    refute Pattern.match?(regex, "ab")
  end
end
