# 開発環境

このリポジトリは [mise](https://mise.jdx.dev/) で Elixir、Erlang/OTP、`protoc` を固定します。

```sh
mise install
mise run setup
mise run check
```

`check` はスキーマ検証、整形、Credo、Dialyzer、test、ExDoc、依存監査を実行します。個別には `mise run test`、`mise run docs`、`mise run benchmark` を使えます。

## スキーマの同期

公式 `buf.validate` と Google WKT の取得元およびハッシュは `scripts/proto_sources.env` に固定しています。

```sh
mise run schema:verify
mise run schema:sync
```

同期後は `priv/proto` とハッシュ一覧を確認してください。生成 fixture を変更した場合は対応する生成 task と test を実行します。

## 互換性と配布の確認

```sh
mise run conformance
mise run conformance:cel
mise run package:smoke
```

変更内容に応じて、対象の conformance case と公開 API の回帰 test を追加してください。コントリビューションの基準は [日本語版](../CONTRIBUTING_ja.md) または [CONTRIBUTING](../CONTRIBUTING.md) にあります。
