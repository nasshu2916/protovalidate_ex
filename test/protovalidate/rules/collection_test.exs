defmodule Protovalidate.Rules.CollectionTest do
  use ExUnit.Case, async: true

  import Protovalidate.TestRules

  alias Protovalidate.{Plan, PredefinedRuleRegistry}

  test "repeated 内の predefined も設定を引き継ぎ、fail_fast で次の要素を評価しない" do
    registry =
      PredefinedRuleRegistry.new(%{
        1001 => %{rule_type: :map, cel: [%{id: "item", expression: "track"}]}
      })

    field = field(:TYPE_STRING, name: "labels", repeated?: true, item_type: :TYPE_STRING)

    plan =
      plan(
        field,
        %{
          type:
            {:repeated,
             %{
               items: %{type: {:string, %{__pb_extensions__: %{1001 => true}}}}
             }}
        },
        cel: {Protovalidate.TestCEL, parent: self()},
        registry: registry
      )

    assert {:ok, [violation]} =
             Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{labels: ["a", "b"]}, fail_fast: true)

    assert violation.rule_path == ["repeated", "items", "predefined", "1001", "item"]
    assert violation.field_path.segments == [{:field, "labels"}, {:index, 0}]
    assert_receive {:cel_evaluate, :field}
    refute_receive {:cel_evaluate, :field}
  end

  test "map key の CEL に設定を渡し、fail_fast で value の CEL を評価しない" do
    field =
      field(:TYPE_STRING,
        name: "scores",
        map?: true,
        map_key: :TYPE_STRING,
        map_value: :TYPE_STRING
      )

    plan =
      plan(
        field,
        %{
          type:
            {:map,
             %{
               keys: %{cel: [%{id: "key", expression: "track"}]},
               values: %{cel: [%{id: "value", expression: "track"}]}
             }}
        },
        cel: {Protovalidate.TestCEL, parent: self()}
      )

    assert {:ok, [violation]} =
             Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{scores: %{"key" => "value"}},
               fail_fast: true
             )

    assert violation.rule_id == "key"
    assert violation.for_key
    assert violation.field_path.segments == [{:field, "scores"}, {:map_key, :string, "key"}]
    assert_receive {:cel_evaluate, :field}
    refute_receive {:cel_evaluate, :field}
  end
end
