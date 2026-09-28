# CEL and Predefined Rules

CEL custom rules are enabled by default with the `Protovalidate.CEL.Celixir` adapter. Expressions are reused as compiled plans.

```elixir
validator = Protovalidate.new(
  cel: {Protovalidate.CEL.Celixir,
    compile_timeout: 1_000,
    timeout: 1_000,
    max_heap_size: 8_000_000}
)

Protovalidate.Validator.validate(validator, message)
Protovalidate.Validator.close(validator)
```

The default compile and evaluation timeouts are 1,000 ms each, and the default heap limit for the execution process is 8,000,000 words. Override these values with positive integers. The adapter runs in a monitored process; timeouts, abnormal exits, and invalid return values are converted to safe `CompilationError` or `RuntimeError` exceptions.

`true` and the empty string indicate success. `false` indicates a violation, and a non-empty string becomes the violation message. Use only trusted schemas and adapters. These limits do not isolate adapter I/O, NIFs, or mutations to shared state.

## Predefined rules

Predefined rules are not executed automatically. Explicitly register extensions in `Protovalidate.PredefinedRuleRegistry` and pass the registry through the validator's `:registry` option. Registration fails during compilation if the target Rules type, extension number, or value type does not match. An unregistered extension raises `UnsupportedRuleError`.

See the [rule support table](rule-support.md) for CEL compatibility coverage.
