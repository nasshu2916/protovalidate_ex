# ルール対応表

対応する `buf.validate` スキーマは **1.2.2** です。`conformant` は公式 conformance の継続確認済み、`implemented` は実装済みであって領域全体の互換性を保証しないことを表します。

| 領域 | 状態 | 範囲 |
| --- | --- | --- |
| bool | conformant | `const` |
| CEL custom rules | conformant | 固定版の `custom_rules` suite |
| message / field / oneof | implemented | required、ignore、ネスト、presence、message oneof |
| 数値・enum | implemented | 比較、集合、NaN / Infinity、`defined_only` |
| string | implemented | 長さ、pattern、prefix / suffix / contains、集合、email、UUID、hostname、IP、URI など |
| bytes | implemented | 長さ、pattern、prefix / suffix / contains、集合、IP、UUID |
| repeated / map | implemented | サイズ、items、keys、values、ネストした message |
| Well-Known Types | implemented | Any、Duration、Timestamp、FieldMask、scalar wrapper |
| predefined rules | implemented | 明示登録した registry の extension |

## 既知の制約

- pattern は RE2 互換を保証しません。詳細は[互換性方針](compatibility_ja.md)を参照してください。
- CEL library 関数の `isEmail`、`isHostname`、`isHostAndPort`、`isIp`、`isIpPrefix`、`isUri`、`isUriRef` に対応しています。predefined rule の自動登録は対象外です。
- 未登録の predefined rule と未知の標準ルールは明示的なエラーになります。

実装済み範囲を採用する際は、全件の固定版スナップショット `priv/conformance/baseline.json` を確認してください。リポジトリのルートで `mise run conformance:check` を実行すると全 suite を再実行してスナップショットと比較できます。`mise run conformance:cel` は CEL の `custom_rules` suite を確認します。CI でも両方を実行し、全件のログを `conformance-all` artifact として保存します。
