# Integration Guide

## Single validation

```elixir
def validate(message), do: Protovalidate.validate(message, fail_fast: false)
```

## Reusing a validator

The process that creates a validator owns its ETS tables. Make a long-lived process in your supervision tree the owner, then use the validator it provides for validation calls.

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

Validation calls do not need to pass through the GenServer. After the owner restarts, fetch its new validator and discard the old one.

## Phoenix and gRPC

In Phoenix, validate immediately after decoding JSON into a Protobuf message and convert `ValidationError` to `422 Unprocessable Entity`. In gRPC, the same error is commonly mapped to `INVALID_ARGUMENT`. Do not expose internal details from `CompilationError`, `UnsupportedRuleError`, or `RuntimeError` to clients; handle these as configuration or execution failures.

See the [sample](../examples/phoenix_sample/README.md) for a working Phoenix application.
