# Phoenix Sample

日本語版: [README_ja.md](README_ja.md).

A minimal example of integrating Protovalidate for Elixir with a Phoenix JSON API. The controller validates a Protobuf message at the input boundary and returns `422 Unprocessable Entity` for rule violations.

## Run

```sh
cd examples/phoenix_sample
mix setup
mix test
mix phx.server
```

## API

`POST /api/users` accepts a UUID `id`, an `age` no greater than 150, and an email address in `email`.

```sh
curl -X POST http://localhost:4000/api/users \
  -H 'Content-Type: application/json' \
  -d '{"id":"550e8400-e29b-41d4-a716-446655440000","email":"alice@example.com","age":28}'
```

A rule violation returns a response in this format:

```json
{
  "status": "error",
  "errors": [
    {"field": "id", "rule_id": "string.uuid", "message": "value must be a UUID"}
  ]
}
```

See the [integration guide](../../docs/integrations.md) for implementation notes and guidance on reusing validators. The Japanese version is [here](../../docs/integrations_ja.md).
