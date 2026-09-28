# Protovalidate for Elixir

`Protovalidate for Elixir` is a runtime library that applies [Buf Protovalidate](https://github.com/bufbuild/protovalidate) `buf.validate` annotations to Elixir Protobuf messages. Define validation rules in your schema and apply them consistently at HTTP, gRPC, batch processing, and other input boundaries.

## Installation

Add the dependency to `mix.exs`:

```elixir
def deps do
  [
    {:protovalidate, "~> 0.1"}
  ]
end
```

Set `gen_descriptors=true` when generating messages. The library reads `buf.validate` options from the generated message descriptors. With `protoc` and `protoc-gen-elixir` on `PATH`, run this from the repository root to compile the checked-in sample schema:

```sh
mkdir -p generated
protoc --elixir_out=generated --elixir_opt=gen_descriptors=true \
  --proto_path=priv/proto \
  --proto_path=test/proto \
  acme/user/v1/user.proto
```

This library provides the generated `buf.validate` definitions. Do not compile duplicate definitions in your application.

## Quick start

```proto
syntax = "proto3";

package acme.user.v1;

import "buf/validate/validate.proto";

message User {
  string id = 1 [(buf.validate.field).string.uuid = true];
  uint32 age = 2 [(buf.validate.field).uint32.lte = 150];
  string email = 3 [(buf.validate.field).string.email = true];
}
```

```elixir
user = %Acme.User.V1.User{id: "not-a-uuid", age: 200, email: "invalid"}

case Protovalidate.validate(user) do
  {:ok, valid_user} -> valid_user
  {:error, %Protovalidate.ValidationError{violations: violations}} -> violations
  {:error, error} -> raise error
end
```

`Protovalidate.validate/2` creates a validator for each call. For services that validate frequently, reuse a `Protovalidate.Validator`. See the [integration guide](docs/integrations.md).

## CEL

CEL custom rules are enabled by default with the standard Celixir adapter. Set the `:cel` option to adjust timeouts or the heap limit. Predefined rules must be explicitly registered in a registry. See the [CEL guide](docs/cel.md) for configuration and operational notes.

## Support

The supported `buf.validate` schema version is 1.2.2. The [rule support table](docs/rule-support.md) distinguishes areas continuously checked by the official conformance suite from implemented areas for which full compatibility is not claimed. In particular, `string.pattern` and `bytes.pattern` use the BEAM regular expression engine instead of RE2; review the [compatibility policy](docs/compatibility.md) before using them.

## Documentation

- [Integration guide](docs/integrations.md)
- [CEL and predefined rules](docs/cel.md)
- [Migration guide](docs/migration.md)
- [Public API and error contract](docs/api-design.md)
- [Rule support table](docs/rule-support.md)
- [Compatibility policy](docs/compatibility.md)
- [Telemetry](docs/telemetry.md)
- [Phoenix sample](examples/phoenix_sample/README.md) ([日本語](examples/phoenix_sample/README_ja.md))

## Background

Protovalidate is a Protobuf validation specification designed as the successor to `protoc-gen-validate`. This library uses descriptor-driven runtime validation, independently of the earlier Elixir implementation.

## References

- [Buf Protovalidate](https://github.com/bufbuild/protovalidate)
- [`buf.validate` schema](https://github.com/bufbuild/protovalidate/blob/main/proto/protovalidate/buf/validate/validate.proto)
- [CEL](https://cel.dev/)
