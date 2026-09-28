# Rule Support Table

The supported `buf.validate` schema version is **1.2.2**. `conformant` means the official conformance suite is checked continuously. `implemented` means the feature is implemented, but compatibility across the whole area is not guaranteed.

| Area | Status | Coverage |
| --- | --- | --- |
| bool | conformant | `const` |
| CEL custom rules | conformant | `custom_rules` suite for the pinned schema version |
| message / field / oneof | implemented | required, ignore, nesting, presence, message oneof |
| numeric / enum | implemented | comparisons, sets, NaN / Infinity, `defined_only` |
| string | implemented | length, pattern, prefix / suffix / contains, sets, email, UUID, hostname, IP, URI, and more |
| bytes | implemented | length, pattern, prefix / suffix / contains, sets, IP, UUID |
| repeated / map | implemented | size, items, keys, values, nested messages |
| Well-Known Types | implemented | Any, Duration, Timestamp, FieldMask, scalar wrappers |
| predefined rules | implemented | explicitly registered registry extensions |

## Known limitations

- RE2 compatibility is not guaranteed for patterns. See the [compatibility policy](compatibility.md).
- The CEL library functions `isEmail`, `isHostname`, `isHostAndPort`, `isIp`, `isIpPrefix`, `isUri`, and `isUriRef` are supported. Automatic registration of predefined rules is not supported.
- Unregistered predefined rules and unknown standard rules produce explicit errors.

Before adopting an implemented feature, review the pinned full-suite snapshot in `priv/conformance/baseline.json`. From the repository root, `mise run conformance:check` reruns the full suite and compares it with that snapshot; `mise run conformance:cel` checks the CEL `custom_rules` suite. CI runs both checks and uploads the full-suite log as the `conformance-all` artifact.
