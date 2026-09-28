# 公開 API とエラー契約

## 検証する

単発の検証には `Protovalidate.validate/2` を使います。

```elixir
case Protovalidate.validate(message, fail_fast: false) do
  {:ok, valid_message} -> valid_message
  {:error, %Protovalidate.ValidationError{violations: violations}} -> violations
  {:error, error} -> raise error
end
```

`validate!/2` は成功時に message を返し、それ以外では例外を raise します。多数回検証する場合は `Validator.new/1` で validator を作り、`Validator.validate/2` を使用します。作成したプロセスが ETS を所有するため、終了時または不要になったときに同じプロセスから `Validator.close/1` を一度呼んでください。

入力を受け取る前に message と到達可能な子 schema をコンパイルするには、`Validator.prepare(validator, MessageModule)` を呼びます。戻り値は `:ok` または `{:error, exception}` です。再帰型は一度だけ訪問します。準備には validator のコンパイル設定とキャッシュを使用し、独立した無制限のコンパイル予算を使うため、後続の検証では `:validation_timeout` が新たに始まります。準備済みと遅延コンパイルの検証は同じ plan と結果を使います。

## オプション

| オプション | 既定値 | 説明 |
| --- | --- | --- |
| `:fail_fast` | `false` | 最初の違反で評価を停止する |
| `:legacy_required` | `false` | proto2 / edition の legacy required を検証する |
| `:registry` | `nil` | predefined rule を解決する registry |
| `:cel` | 既定 adapter | CEL adapter とその制限値 |
| `:validation_timeout` | 未設定 | 検証全体の協調的な時間予算（ms） |

未知のオプションや不正な設定は `Validator.new/1` 時に `ArgumentError` になります。
不正な `:cel` と `:registry` の値も含みます。descriptor、ルール定義、CEL 式の不正は
validator の設定エラーではなくスキーマのエラーなので、引き続き `CompilationError` になります。

## 結果とエラー

| 型 | 意味 | 呼び出し側の一般的な扱い |
| --- | --- | --- |
| `ValidationError` | 入力がルールに違反した | 400 系の入力エラーへ変換する |
| `CompilationError` | descriptor、スキーマ、CEL 定義が不正 | デプロイ前にスキーマを修正する |
| `UnsupportedRuleError` | 未対応の標準または predefined rule | 対応範囲または設定を見直す |
| `RuntimeError` | 値と descriptor の不整合、CEL 実行障害 | 運用上の障害として調査する |

エラー struct は、プログラムから分類するための安定した `code` と `stage` を公開します。
エラーメッセージの文字列で分岐しないでください。手動構築 message の不正値は `:input`、
スキーマとルールの準備は `:compile`、実行時障害は `:evaluate` stage です。

decode 済み message と手動構築した Protobuf struct の両方をサポートします。実際に検証する
field は、absence と ignore の処理後に、scalar 型、repeated / map の形、collection 要素型、
enum atom、子 message 型を検査します。不一致は `code: :invalid_input_type`、`stage: :input` の
`RuntimeError` になり、エラーと Telemetry metadata のどちらにも不正な実値を含めません。

predefined rule の独自 registry callback は外部境界として扱います。例外、throw、exit、error の
reason、不正な戻り値は、callback のデータや入力値を埋め込まない固定のコンパイルエラーへ変換します。

`ValidationError.violations` の各 `Violation` は `field_path`、`rule_path`、`rule_id`、`message`、`for_key`、`details` を持ちます。入力値は保持しません。CEL が正常な結果として返す違反メッセージはスキーマ作成者の管理対象なので、外部へ返す場合はその内容を確認してください。

`validation_timeout` は `Validator.validate/2` の入口から開始し、descriptor 解決、root と子 plan のコンパイル、CEL のコンパイルと評価、ネストした検証で共有します。CEL worker には固有の timeout と検証の残り予算の短い方を渡します。field、oneof、collection 要素などの評価境界でも予算を確認します。単一の高コストな正規表現など、CEL 以外の処理途中を強制中断するものではありません。
