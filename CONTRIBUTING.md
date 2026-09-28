# Contribution Guide

日本語版は [CONTRIBUTING_ja.md](CONTRIBUTING_ja.md) です。

Contributions are welcome. Before making a change, consider its impact on the relevant `buf.validate` schema and the official conformance suite.

## Development principles

- Organize modules by feature and keep the public API, descriptor normalization, plan construction, rule evaluation, and error conversion responsibilities separate.
- Extract reusable logic into shared modules and keep each function focused on one responsibility.
- Write comments explaining implementation background or decisions in Japanese.
- Do not treat unsupported specifications or intentional differences as successful validation or omit them from the documentation.

## Changes and verification

When adding or changing a standard rule, add tests for valid values, invalid values, boundaries, presence and ignore behavior, and field paths in nested messages and collections. Update the support table in the same change.

For schema changes, use the pinned upstream sources and generation tasks. Do not edit generated files by hand. Run the relevant checks from the development guide, including conformance checks when applicable.

For command and task details, see the [Development guide](docs/development.md) or its [Japanese version](docs/development_ja.md).

Pull requests should describe the changed rule or API, compatibility impact, and verification commands that were run. When a specification decision is required, record its rationale in an issue or design document.

## References

- [Buf Protovalidate](https://github.com/bufbuild/protovalidate)
- [`buf.validate` schema](https://github.com/bufbuild/protovalidate/blob/main/proto/protovalidate/buf/validate/validate.proto)
- [Official conformance tests](https://github.com/bufbuild/protovalidate/tree/main/proto/protovalidate-testing)
