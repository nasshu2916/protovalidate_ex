# 互換性方針

本ライブラリは [Buf Protovalidate](https://github.com/bufbuild/protovalidate) の `buf.validate` スキーマと公式 conformance suite を基準にします。`protoc-gen-validate` の `validate.rules` とは別のスキーマ・実行モデルです。

対応するスキーマ版は 1.2.2 です。対応状況には次の語を使います。

| 状態 | 意味 |
| --- | --- |
| `conformant` | 該当する公式 conformance を継続確認している |
| `implemented` | 実装と回帰 test はあるが、領域全体の互換性は未宣言 |
| `unsupported` | 明示的なエラーとして扱う |

詳細は[ルール対応表](rule-support_ja.md)を参照してください。未知のルールを検証成功として無視しません。

## 留意事項

`string.pattern` と `bytes.pattern` は BEAM の Unicode 正規表現エンジン（`Regex.compile(expression, "u")`）を使います。式にアンカーがなければ部分一致を判定します。`bytes.pattern` はまず UTF-8 の妥当性を確認し、同じ Unicode 照合を適用します。不正な UTF-8 は実行時エラーです。BEAM は後方参照など RE2 が拒否する式も受理します。RE2 の構文互換性は保証しません。BEAM で無効な式はコンパイルエラーです。

各 pattern 照合には PCRE の `match_limit` として 1,000,000 を設定します。上限到達時は検証違反ではなく実行時エラー（`pattern match failed: :match_limit`）を返します。これは照合処理量の上限であり、経過時間の期限や RE2 の線形時間保証ではありません。`validation_timeout` は検証処理の合間に確認され、実行中の照合を中断できません。pattern のコンパイルには個別の実行上限がありません。特に信頼できない入力には、信頼できる pattern だけを使用してください。固定版 1.2.2 の公式 fixture は `mise run conformance:pattern` で実行できます（string と bytes の正常・異常、計 8 件）。

CEL の `custom_rules` は継続確認対象です。`library/*` の文字列形式関数には対応していますが、すべての型構築式と predefined rule の自動登録は完全対応ではありません。CEL の制限と登録方法は [CEL ガイド](cel_ja.md) に記載しています。

proto3 の scalar、repeated、map は値だけでは presence を判定できません。本ライブラリは descriptor の情報を用いて `required` と `ignore` を評価します。
