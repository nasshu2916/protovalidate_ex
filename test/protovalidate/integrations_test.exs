defmodule Protovalidate.IntegrationsTest do
  use ExUnit.Case, async: false

  test "統合文書の単発検証例はコンパイルできる" do
    assert [_ | _] = compile_example("単発の検証")
  end

  test "統合文書の validator 再利用例はコンパイルできる" do
    assert [_ | _] = compile_example("validator の再利用")
  end

  defp compile_example(heading) do
    docs = File.read!(Path.expand("../../docs/integrations_ja.md", __DIR__))

    [source] =
      Regex.run(~r/## #{Regex.escape(heading)}.*?```elixir\n(.*?)```/s, docs,
        capture: :all_but_first
      )

    source
    |> wrap_top_level_definition()
    |> Code.compile_string()
  end

  # ガイドには利用者が自身の module 内へ置く短い関数例もあるため、
  # テスト時だけ module で包み、Elixir として有効な形で検証する。
  defp wrap_top_level_definition(source) do
    if String.starts_with?(String.trim_leading(source), "defmodule ") do
      source
    else
      "defmodule Protovalidate.IntegrationsExample do\n#{source}\nend"
    end
  end
end
