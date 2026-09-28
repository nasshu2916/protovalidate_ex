# 移行ガイド

`protoc-gen-validate` から移行する場合、`validate.rules` は `buf.validate` と互換ではありません。annotation を `buf.validate.field`、`buf.validate.message`、`buf.validate.oneof` へ置き換え、対象ルールが[対応表](rule-support_ja.md)にあることを確認してください。

生成済みの検証モジュールは不要です。message 生成時に `gen_descriptors=true` を指定し、本ライブラリが提供する `buf.validate` 定義と重複しないようにしてください。

```elixir
case Protovalidate.validate(message) do
  {:ok, valid_message} -> valid_message
  {:error, %Protovalidate.ValidationError{} = error} -> raise error
  {:error, error} -> raise error
end
```

未対応 rule は成功として無視されません。CEL と predefined rule は[CEL ガイド](cel_ja.md)の設定を追加してから導入してください。
