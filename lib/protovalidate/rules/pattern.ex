defmodule Protovalidate.Rules.Pattern do
  @moduledoc false

  import Protovalidate.Rules.Compilation

  @match_limit 1_000_000

  # 固定版 CEL の bytes.matches も UTF-8 を要求する。RE2 と同等とは宣言しない。
  def compile(rules, kind) do
    Enum.map(rules, fn
      {:pattern, expression} -> {:pattern, compile_pattern!(expression, kind)}
      rule -> rule
    end)
  end

  def match?(regex, value) do
    # PCRE の上限超過を通常の不一致に変換せず、検証不能として報告する。
    case :re.run(value, regex.re_pattern, [
           :report_errors,
           {:capture, :none},
           {:match_limit, @match_limit}
         ]) do
      :match ->
        true

      :nomatch ->
        false

      {:error, reason} ->
        raise Protovalidate.RuntimeError, message: "pattern match failed: #{inspect(reason)}"
    end
  end

  defp compile_pattern!(expression, kind) when is_binary(expression) do
    case Regex.compile(expression, "u") do
      {:ok, regex} ->
        regex

      {:error, reason} ->
        compilation_error!("invalid regular expression: #{inspect(reason)}", [
          to_string(kind),
          "pattern"
        ])
    end
  end

  defp compile_pattern!(_expression, kind),
    do: compilation_error!("pattern must be a string", [to_string(kind), "pattern"])
end
