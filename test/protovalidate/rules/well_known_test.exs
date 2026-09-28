defmodule Protovalidate.Rules.WellKnownTest do
  use ExUnit.Case, async: true

  import Protovalidate.TestRules

  alias Protovalidate.Rules.WellKnown

  test "Duration の比較は seconds と nanos の順序で評価する" do
    field = field(".google.protobuf.Duration", well_known_type: :duration)
    rules = WellKnown.temporal_rules(%{gte: %{seconds: 1, nanos: 2}}, "duration")
    assert [{:gte, _} = rule] = rules

    assert {:cont, %{violations: []}} =
             WellKnown.evaluate(rule, %{seconds: 1, nanos: 3}, field, context())

    assert {:cont, %{violations: [violation]}} =
             WellKnown.evaluate(rule, %{seconds: 1, nanos: 1}, field, context())

    assert violation.rule_id == "duration.gte"
  end

  test "Any、timestamp、field mask の固有規則を評価する" do
    any = field(:TYPE_MESSAGE, well_known_type: :any)
    timestamp = field(:TYPE_MESSAGE, well_known_type: :timestamp)
    field_mask = field(:TYPE_MESSAGE, well_known_type: :field_mask)

    assert {:cont, %{violations: []}} =
             WellKnown.evaluate(
               {:in, ["type.googleapis.com/acme.Input"]},
               %{type_url: "type.googleapis.com/acme.Input"},
               any,
               context()
             )

    assert {:cont, %{violations: [_]}} =
             WellKnown.evaluate(
               {:not_in, ["type.googleapis.com/acme.Input"]},
               %{type_url: "type.googleapis.com/acme.Input"},
               any,
               context()
             )

    for {rule, value} <- [
          {{:const, %{seconds: 1, nanos: 0}}, %{seconds: 2, nanos: 0}},
          {{:lt, %{seconds: 2, nanos: 0}}, %{seconds: 3, nanos: 0}},
          {{:lte, %{seconds: 2, nanos: 0}}, %{seconds: 3, nanos: 0}},
          {{:gt, %{seconds: 2, nanos: 0}}, %{seconds: 1, nanos: 0}},
          {{:gte, %{seconds: 2, nanos: 0}}, %{seconds: 1, nanos: 0}},
          {{:lt_now, true}, %{seconds: 100, nanos: 0}},
          {{:gt_now, true}, %{seconds: 100, nanos: 0}},
          {{:within, %{seconds: 1, nanos: 0}}, %{seconds: 102, nanos: 0}}
        ] do
      assert {:cont, %{violations: [_]}} = WellKnown.evaluate(rule, value, timestamp, context())
    end

    assert {:cont, %{violations: []}} =
             WellKnown.evaluate({:in, ["child"]}, %{paths: ["child.code"]}, field_mask, context())

    assert {:cont, %{violations: [_]}} =
             WellKnown.evaluate(
               {:not_in, ["child"]},
               %{paths: ["child.code"]},
               field_mask,
               context()
             )
  end
end
