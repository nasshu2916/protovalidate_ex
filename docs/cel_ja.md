# CEL と predefined rules

CEL カスタムルールは標準の `Protovalidate.CEL.Celixir` adapter で既定有効です。式はコンパイル済みの plan として再利用されます。

```elixir
validator = Protovalidate.new(
  cel: {Protovalidate.CEL.Celixir,
    compile_timeout: 1_000,
    timeout: 1_000,
    max_heap_size: 8_000_000}
)

Protovalidate.Validator.validate(validator, message)
Protovalidate.Validator.close(validator)
```

compile と evaluate の既定 timeout は各 1,000 ms、実行プロセスの既定ヒープ上限は 8,000,000 words です。正の整数で上書きできます。adapter は監視プロセスで実行され、timeout、異常終了、不正な戻り値は安全な `CompilationError` または `RuntimeError` へ変換されます。

`true` と空文字列は成功、`false` は違反、空でない文字列はその文字列を違反メッセージにします。スキーマと adapter は信頼できるものだけを使用してください。制限値は adapter の I/O、NIF、共有状態の変更を隔離するものではありません。

## predefined rule

predefined rule は自動実行しません。`Protovalidate.PredefinedRuleRegistry` に extension を明示登録し、validator の `:registry` に渡してください。拡張先の Rules 型、extension number、値の型が一致しない登録はコンパイルエラーになります。未登録の拡張は `UnsupportedRuleError` です。

完全な CEL 互換性の対象は[ルール対応表](rule-support_ja.md)を参照してください。
