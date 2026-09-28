# R3 の違反収集を、同じ plan と要素数の成功・違反入力で比較する。
# MIX_ENV=test mise exec -- mix run scripts/benchmark_evaluation.exs
field = %Protovalidate.DescriptorAdapter.Field{
  name: "labels",
  json_name: "labels",
  number: 3,
  type: :TYPE_STRING,
  repeated?: true,
  map?: false,
  item_type: :TYPE_STRING,
  presence: :implicit,
  oneof: nil,
  well_known_type: nil,
  validation: %{field: %{type: {:repeated, %{items: %{type: {:string, %{min_len: 1}}}}}}}
}

plan =
  Protovalidate.Plan.compile(
    %Protovalidate.DescriptorAdapter.Message{
      module: Acme.Descriptor.V1.Probe,
      full_name: "benchmark.Collection",
      fields: [field],
      oneofs: [],
      validation: %{}
    },
    []
  )

valid = %Acme.Descriptor.V1.Probe{labels: List.duplicate("ok", 3000)}
invalid = %Acme.Descriptor.V1.Probe{labels: List.duplicate("", 3000)}
{:ok, []} = Protovalidate.Plan.evaluate(plan, valid, fail_fast: false)
{:ok, violations} = Protovalidate.Plan.evaluate(plan, invalid, fail_fast: false)
3000 = length(violations)

Benchee.run(
  %{
    "collection_valid_3000" => fn ->
      Protovalidate.Plan.evaluate(plan, valid, fail_fast: false)
    end,
    "collection_invalid_3000" => fn ->
      Protovalidate.Plan.evaluate(plan, invalid, fail_fast: false)
    end
  }, time: 2, warmup: 1, memory_time: 1)
