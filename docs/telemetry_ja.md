# Telemetry

`Protovalidate.Validator.validate/2` は次の Telemetry event を発行します。`duration` は Erlang の monotonic time の native unit です。

| Event | measurements | metadata |
| --- | --- | --- |
| `[:protovalidate, :plan_cache, :hit]` | `%{count: 1}` | `%{message_module: module}` |
| `[:protovalidate, :plan_cache, :miss]` | `%{count: 1}` | `%{message_module: module}` |
| `[:protovalidate, :validation, :stop]` | `%{duration: integer, violations: non_neg_integer}` | `%{message_module: module, outcome: :ok | :error}` |
| `[:protovalidate, :call, :total, :stop]` | `%{duration: integer}` | `%{message_module: module, outcome: outcome}` |
| `[:protovalidate, :call, :compile, :stop]` | `%{duration: integer}` | `%{message_module: module, outcome: outcome}` |
| `[:protovalidate, :call, :evaluate, :stop]` | `%{duration: integer}` | `%{message_module: module, outcome: outcome}` |
| `[:protovalidate, :message, :stop]` | `%{duration: integer, violations: non_neg_integer}` | `%{message_module: module, scope: :root | :child, outcome: :ok | :compile_error | :runtime_error}` |

イベントには message の値、field 値、違反メッセージ、CEL 環境を含めません。`validation:stop` は評価した各 message で子から親の順に発火します。親の `violations` には子の違反も含まれるため、イベント全件の合計は検証全体の違反数ではありません。

新しい `call:total:stop` は公開 `Validator.validate/2` の呼び出しごとに一度発火し、root のコンパイル失敗も含みます。呼び出し全体の時間と結果件数にはこのイベントを使います。`outcome` は `:ok`、`:violation`、`:compile_error`、`:runtime_error` です。`call:compile:stop` は descriptor 解決、cache 参照、コンパイル、同時コンパイルの待機を含みます。`call:evaluate:stop` は子 plan のコンパイルと評価を含みます。`message:stop` は root と子の評価を区別しますが、時間と違反数には子孫を含みます。message イベントを合算して呼び出し全体の値にしないでください。従来の `validation:stop` は変更していません。

各 `:stop` イベントには対応する `:start` イベントがあり、計測値は空 map です。`:start` の metadata は `:message_module` を含み、`message:start` には `:scope` も含みます。不正な公開入力では `message_module: nil` とし、全体 span のみ発行します。

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
