defmodule Protovalidate.Rules.BytesTest do
  use ExUnit.Case, async: true

  import Protovalidate.TestRules

  alias Protovalidate.Rules.Bytes

  test "バイト列固有と共通のルールを評価し、bytes の ID を維持する" do
    assert [{:const, <<0>>}, :bytes_ipv4] = Bytes.bytes_rules(%{const: <<0>>, ipv4: true})

    for {rule, id} <- [
          {{:const, <<0>>}, "bytes.const"},
          {:bytes_ipv4, "bytes.ipv4"},
          {{:prefix, <<0>>}, "bytes.prefix"}
        ] do
      assert {:cont, %{violations: [violation]}} =
               Bytes.evaluate(rule, <<1>>, field(:TYPE_BYTES), context())

      assert violation.rule_id == id
    end
  end
end
