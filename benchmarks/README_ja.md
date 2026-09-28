# ベンチマーク

ベンチマークは validation plan の正規化・コンパイル・再利用、CEL field access、20 個の CEL ルール、深い再帰、repeated と map の評価、cold / warm cache を共有する 8 並列呼び出しを測定します。

```sh
mise run benchmark
MIX_ENV=test mise exec -- mix protovalidate.benchmark --time 2 --warmup 1 --memory-time 1 --output /tmp/protovalidate-benchmark.csv
```

出力 CSV は時間を ns、メモリ割当を bytes で記録します。`time_cv` と `memory_cv` は変動係数、`*_samples` はサンプル数です。メモリ値は測定プロセスの割当量であり、VM 全体の RSS や ETS の保持量を表しません。

`cold_concurrent_8` は測定ごとに validator を作成・解放し、`warm_concurrent_8` は準備済み cache を共有します。worker の割当量と ETS 保持量は Benchee のプロセス単位のメモリ値に含まれません。それらを評価するときは system memory や ETS table size を別途比較してください。

性能を比較するときは、同じ端末、ツールチェーン、依存関係で変更前後を複数回交互に実行してください。共有 CI runner の結果は傾向の確認用であり、固定の性能合否判定には使用しません。
