# Compatibility Policy

This library follows the [Buf Protovalidate](https://github.com/bufbuild/protovalidate) `buf.validate` schema and the official conformance suite. It uses a different schema and execution model from `protoc-gen-validate`'s `validate.rules`.

The supported schema version is 1.2.2. Support statuses mean:

| Status | Meaning |
| --- | --- |
| `conformant` | The corresponding official conformance cases are checked continuously. |
| `implemented` | The feature has implementation and regression tests, but compatibility across the entire area is not claimed. |
| `unsupported` | The feature is reported as an explicit error. |

See the [rule support table](rule-support.md) for details. Unknown rules are never silently treated as valid.

## Limitations

`string.pattern` and `bytes.pattern` use BEAM's Unicode regular expression engine (`Regex.compile(expression, "u")`). Matching searches for a substring unless the expression is anchored. `bytes.pattern` first requires valid UTF-8 and then applies the same Unicode matching rules; invalid UTF-8 produces a runtime error. BEAM may accept expressions that RE2 rejects (for example, backreferences), and RE2 syntax compatibility is not guaranteed. Invalid BEAM expressions produce a compilation error.

Each pattern match has a PCRE `match_limit` of 1,000,000. Reaching it produces a runtime error (`pattern match failed: :match_limit`), never a validation violation. This is a matching work limit, not a wall-clock deadline or RE2's linear-time guarantee. `validation_timeout` is checked between validation operations; it cannot interrupt a match already running. Pattern compilation has no separate execution limit. Only use trusted patterns, especially with untrusted input. The pinned 1.2.2 official fixtures can be run with `mise run conformance:pattern` (8 cases: string and bytes, valid and invalid cases).

CEL `custom_rules` are continuously checked. The string-format functions under `library/*` are supported, but all type construction expressions and automatic registration of predefined rules are not fully supported. See the [CEL guide](cel.md) for limits and registration instructions.

The value alone cannot determine presence for proto3 scalar, repeated, and map fields. This library uses descriptor information to evaluate `required` and `ignore` rules.
