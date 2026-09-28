# 統合ガイド

## 単発の検証

```elixir
def validate(message), do: Protovalidate.validate(message, fail_fast: false)
```

## validator の再利用

validator は ETS を作成したプロセスが所有します。supervision tree 内の長寿命プロセスに所有させ、呼び出し側では取得した validator を使って検証します。

```elixir
defmodule MyApp.ValidationOwner do
  use GenServer

  def start_link(options), do: GenServer.start_link(__MODULE__, options, name: __MODULE__)
  def validator, do: GenServer.call(__MODULE__, :validator)
  def init(options), do: {:ok, Protovalidate.new(options)}
  def handle_call(:validator, _from, validator), do: {:reply, validator, validator}
  def terminate(_reason, validator), do: Protovalidate.Validator.close(validator)
end
```

検証自体を GenServer に通す必要はありません。owner が再起動した後は validator を取得し直し、古い値を再利用しないでください。

## Phoenix と gRPC

Phoenix では JSON を Protobuf message に decode した直後に検証し、`ValidationError` を `422 Unprocessable Entity` に変換します。gRPC では同じエラーを `INVALID_ARGUMENT` に変換するのが一般的です。`CompilationError`、`UnsupportedRuleError`、`RuntimeError` はクライアントへ内部情報を返さず、設定または実行障害として扱ってください。

動作する Phoenix の例は[サンプル](../examples/phoenix_sample/README_ja.md)を参照してください。
