# Phoenix サンプル

English version: [README.md](README.md).

Protovalidate for Elixir を Phoenix の JSON API に統合する最小例です。controller は入力境界で Protobuf message を検証し、rule 違反がある場合は `422 Unprocessable Entity` を返します。

## 起動

```sh
cd examples/phoenix_sample
mix setup
mix test
mix phx.server
```

## API

`POST /api/users` は UUID 形式の `id`、150 以下の `age`、`email` のメールアドレスを受け付けます。

```sh
curl -X POST http://localhost:4000/api/users \
  -H 'Content-Type: application/json' \
  -d '{"id":"550e8400-e29b-41d4-a716-446655440000","email":"alice@example.com","age":28}'
```

rule 違反がある場合は、次の形式で response を返します。

```json
{
  "status": "error",
  "errors": [
    {"field": "id", "rule_id": "string.uuid", "message": "value must be a UUID"}
  ]
}
```

実装の説明と validator の再利用方法は[統合ガイド](../../docs/integrations_ja.md)を参照してください。英語版は[こちら](../../docs/integrations.md)です。
