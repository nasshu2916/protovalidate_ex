# Migration Guide

When migrating from `protoc-gen-validate`, note that `validate.rules` is not compatible with `buf.validate`. Replace annotations with `buf.validate.field`, `buf.validate.message`, and `buf.validate.oneof`, and check that your rules are listed in the [support table](rule-support.md).

Generated validation modules are not required. Set `gen_descriptors=true` when generating messages, and avoid duplicating the `buf.validate` definitions provided by this library.

```elixir
case Protovalidate.validate(message) do
  {:ok, valid_message} -> valid_message
  {:error, %Protovalidate.ValidationError{} = error} -> raise error
  {:error, error} -> raise error
end
```

Unsupported rules are not silently treated as valid. Configure CEL and predefined rules using the [CEL guide](cel.md) before adopting them.
