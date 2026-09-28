# コントリビューションガイド

English version: [CONTRIBUTING.md](CONTRIBUTING.md).

コントリビューションを歓迎します。変更を始める前に、関連する `buf.validate` スキーマと公式 conformance suite への影響を確認してください。

## 開発原則

- 機能ごとにモジュールを整理し、公開 API、descriptor の正規化、plan の構築、rule の評価、エラー変換の責務を分けてください。
- 再利用する処理は共通モジュールに切り出し、各関数は一つの役割に集中させてください。
- 実装の背景や判断理由を説明するコメントは日本語で書いてください。
- 未対応の仕様や意図的な差異を、検証成功として扱ったりドキュメントから省いたりしないでください。

## 変更と検証

標準 rule を追加・変更する場合は、有効値、無効値、境界値、presence と ignore の挙動、nested message や collection 内の field path を確認するテストを追加してください。同じ変更で対応状況の表も更新してください。

schema を変更する場合は、固定された upstream source と生成 task を使ってください。生成ファイルを手作業で編集しないでください。該当する変更では、開発ガイドにある conformance check を含む確認を実行してください。

Pull request には、変更した rule または API、互換性への影響、実行した検証コマンドを記載してください。仕様上の判断が必要な場合は、その理由を issue または設計文書に記録してください。

検証コマンドと開発 task の詳細は [開発ガイド](docs/development_ja.md) を参照してください。英語版は [Development](docs/development.md) です。

## 参考資料

- [Buf Protovalidate](https://github.com/bufbuild/protovalidate)
- [`buf.validate` schema](https://github.com/bufbuild/protovalidate/blob/main/proto/protovalidate/buf/validate/validate.proto)
- [公式 conformance tests](https://github.com/bufbuild/protovalidate/tree/main/proto/protovalidate-testing)
