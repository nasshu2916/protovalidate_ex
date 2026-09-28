# Public API and Error Contract

## Validation

Use `Protovalidate.validate/2` for a single validation:

```elixir
case Protovalidate.validate(message, fail_fast: false) do
  {:ok, valid_message} -> valid_message
  {:error, %Protovalidate.ValidationError{violations: violations}} -> violations
  {:error, error} -> raise error
end
```

`validate!/2` returns the message on success and raises an exception otherwise. For repeated validations, create a validator with `Validator.new/1` and call `Validator.validate/2`. The creating process owns the ETS tables, so call `Validator.close/1` once from that process when the validator is no longer needed or before the owner exits.

Call `Validator.prepare(validator, MessageModule)` to compile a message schema and all reachable child schemas before accepting input. It returns `:ok` or `{:error, exception}`. Recursive message types are visited once. Preparation uses the validator's compilation settings and cache; it has a separate, unbounded compilation budget, so a later validation starts its own `:validation_timeout`. Prepared and lazy validation use the same plans and produce the same results.

## Options

| Option | Default | Description |
| --- | --- | --- |
| `:fail_fast` | `false` | Stop evaluating after the first violation. |
| `:legacy_required` | `false` | Validate legacy required fields in proto2 and editions. |
| `:registry` | `nil` | Registry used to resolve predefined rules. |
| `:cel` | Default adapter | CEL adapter and its limits. |
| `:validation_timeout` | Not set | Cooperative time budget for the full validation, in milliseconds. |

Unknown options and invalid configuration raise `ArgumentError` when calling `Validator.new/1`.
This includes malformed `:cel` and `:registry` values. Invalid descriptors, rule definitions,
and CEL expressions remain `CompilationError`s because they are schema errors rather than
validator configuration errors.

## Results and errors

| Type | Meaning | Typical handling |
| --- | --- | --- |
| `ValidationError` | The input violates one or more rules. | Convert to a client input error, such as HTTP 400. |
| `CompilationError` | A descriptor, schema, or CEL definition is invalid. | Fix the schema before deployment. |
| `UnsupportedRuleError` | A standard or predefined rule is unsupported. | Review supported features or configuration. |
| `RuntimeError` | A message and descriptor mismatch or CEL execution failure occurred. | Investigate as an operational failure. |

Error structs expose stable `code` and `stage` fields for programmatic classification. Do not
branch on error message text. `stage` is `:input` for malformed manually constructed message
values, `:compile` for schema and rule preparation, and `:evaluate` for execution failures.

Validation supports decoded messages and manually constructed Protobuf structs. For every field
that validation evaluates, the runtime checks scalar types, repeated and map shapes, collection
element types, enum atoms, and child message types after absence and ignore handling. A mismatch
returns a `RuntimeError` with `code: :invalid_input_type` and `stage: :input`; neither the error nor
Telemetry metadata contains the offending value.

Custom predefined-rule registry callbacks are treated as an external boundary. Exceptions,
throws, exits, error reasons, and malformed callback results are converted to fixed compilation
errors without embedding callback data or input values.

Each `Violation` in `ValidationError.violations` has `field_path`, `rule_path`, `rule_id`, `message`, `for_key`, and `details` fields. Input values are not retained. Violation messages returned as normal CEL results are controlled by the schema author; review them before returning them to external callers.

`validation_timeout` starts at the `Validator.validate/2` entry point and is shared by descriptor resolution, initial and nested plan compilation, CEL compilation and evaluation, and nested validation. CEL workers receive the shorter of their own timeout and the remaining validation budget. The budget is also checked at evaluation boundaries such as fields, oneofs, and collection elements. It does not forcibly interrupt an individual expensive regular expression or other non-CEL operation while it is running.
