# Protovalidate for Elixir

`Protovalidate for Elixir` は、[Buf Protovalidate](https://github.com/bufbuild/protovalidate) の
`buf.validate` アノテーションを Elixir の Protobuf メッセージに適用するランタイムライブラリです。
スキーマに検証規則を集約し、HTTP、gRPC、バッチ処理などの入力境界で同じ検証を実行できます。

## インストール

`mix.exs` に追加します。

```elixir
def deps do
  [
    {:protovalidate, "~> 0.1"}
  ]
end
```

メッセージの生成時には `gen_descriptors=true` を指定してください。ライブラリは生成済みメッセージの
descriptor から `buf.validate` オプションを読み取ります。`protoc` と `protoc-gen-elixir` を `PATH` に設定し、
リポジトリのルートで次を実行すると、追跡済みの sample schema をコンパイルできます。

```sh
mkdir -p generated
protoc --elixir_out=generated --elixir_opt=gen_descriptors=true \
  --proto_path=priv/proto \
  --proto_path=test/proto \
  acme/user/v1/user.proto
```

`buf.validate` の生成済み定義は本ライブラリが提供します。同じ定義をアプリケーション側で重複して
コンパイルしないでください。

## 最小例

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

`Protovalidate.validate/2` は呼び出しごとに validator を作成します。高頻度に検証するサービスでは、
`Protovalidate.Validator` を再利用してください。詳しくは[統合ガイド](docs/integrations_ja.md)を参照してください。

## CEL

CEL カスタムルールは標準の Celixir アダプターで既定有効です。タイムアウトやヒープ上限を調整する場合は
`:cel` オプションを指定します。predefined rule は安全のため明示的な registry 登録が必要です。
設定例と実行上の注意は [CEL ガイド](docs/cel_ja.md) にあります。

## 対応範囲

対応する `buf.validate` スキーマは 1.2.2 です。公式 conformance で継続確認済みの範囲と、
実装済みだが完全互換を宣言していない範囲を[ルール対応表](docs/rule-support_ja.md)で公開しています。
とくに `string.pattern` と `bytes.pattern` は RE2 ではなく BEAM の正規表現エンジンを使用するため、
利用前に[互換性方針](docs/compatibility_ja.md)を確認してください。

## ドキュメント

- [利用ガイド: 統合](docs/integrations_ja.md)
- [利用ガイド: CEL と predefined rules](docs/cel_ja.md)
- [移行ガイド](docs/migration_ja.md)
- [公開 API とエラー契約](docs/api-design_ja.md)
- [ルール対応表](docs/rule-support_ja.md)
- [互換性方針](docs/compatibility_ja.md)
- [Telemetry](docs/telemetry_ja.md)
- [Phoenix サンプル](examples/phoenix_sample/README_ja.md) ([English](examples/phoenix_sample/README.md))

## 背景

Protovalidate は `protoc-gen-validate` の後継として設計された Protobuf 検証仕様です。
本ライブラリは前身の Elixir 実装とは別の、descriptor 駆動のランタイム検証を採用しています。

## 参考資料

- [Buf Protovalidate](https://github.com/bufbuild/protovalidate)
- [`buf.validate` スキーマ](https://github.com/bufbuild/protovalidate/blob/main/proto/protovalidate/buf/validate/validate.proto)
- [CEL](https://cel.dev/)
