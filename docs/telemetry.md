# Telemetry

`Protovalidate.Validator.validate/2` emits the following Telemetry events. `duration` is in Erlang monotonic time's native unit.

| Event | measurements | metadata |
| --- | --- | --- |
| `[:protovalidate, :plan_cache, :hit]` | `%{count: 1}` | `%{message_module: module}` |
| `[:protovalidate, :plan_cache, :miss]` | `%{count: 1}` | `%{message_module: module}` |
| `[:protovalidate, :validation, :stop]` | `%{duration: integer, violations: non_neg_integer}` | `%{message_module: module, outcome: :ok | :error}` |
| `[:protovalidate, :call, :total, :stop]` | `%{duration: integer}` | `%{message_module: module, outcome: outcome}` |
| `[:protovalidate, :call, :compile, :stop]` | `%{duration: integer}` | `%{message_module: module, outcome: outcome}` |
| `[:protovalidate, :call, :evaluate, :stop]` | `%{duration: integer}` | `%{message_module: module, outcome: outcome}` |
| `[:protovalidate, :message, :stop]` | `%{duration: integer, violations: non_neg_integer}` | `%{message_module: module, scope: :root | :child, outcome: :ok | :compile_error | :runtime_error}` |

Events do not include message values, field values, violation messages, or the CEL environment. `validation:stop` fires for each evaluated message, from child to parent. A parent's `violations` count includes violations from its children, so summing all events does not yield the total number of violations for the validation.

The new `call:total:stop` event fires once for each public `Validator.validate/2` call, including root compilation failures. Use it for request latency and outcome counts. `outcome` is `:ok`, `:violation`, `:compile_error`, or `:runtime_error`. `call:compile:stop` includes descriptor resolution, cache lookup, compilation, and waiting for a concurrent compile. `call:evaluate:stop` includes nested plan compilation and evaluation. `message:stop` identifies root and child evaluations; its duration and violation count include descendants. Do not sum message durations or violation counts to obtain call totals. The old `validation:stop` event remains unchanged.

Each new `:stop` event has a matching `:start` event with empty measurements. `:start` metadata contains `:message_module`; `message:start` also contains `:scope`. Invalid public input uses `message_module: nil` and emits only a total span.

```elixir
:telemetry.attach(
  "my-app-protovalidate",
  [:protovalidate, :validation, :stop],
  fn _event, %{duration: duration, violations: count}, %{message_module: module}, _ ->
    us = System.convert_time_unit(duration, :native, :microsecond)
    MyApp.Metrics.record_validation(module, us, count)
  end,
  nil
)
```
