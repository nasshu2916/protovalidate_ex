# Development

This repository pins Elixir, Erlang/OTP, and `protoc` with [mise](https://mise.jdx.dev/).

```sh
mise install
mise run setup
mise run check
```

`check` runs schema validation, formatting, Credo, Dialyzer, tests, ExDoc, and dependency auditing. Run individual tasks with `mise run test`, `mise run docs`, or `mise run benchmark`.

## Syncing schemas

The sources and checksums for the official `buf.validate` definitions and Google WKT are pinned in `scripts/proto_sources.env`.

```sh
mise run schema:verify
mise run schema:sync
```

After syncing, review `priv/proto` and the checksum list. If generated fixtures change, run the corresponding generation task and tests.

## Compatibility and package checks

```sh
mise run conformance
mise run conformance:cel
mise run package:smoke
```

Depending on the change, add conformance cases and regression tests for the public API. See [CONTRIBUTING](../CONTRIBUTING.md) or the [Japanese contribution guide](../CONTRIBUTING_ja.md).
