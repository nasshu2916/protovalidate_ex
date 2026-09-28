# Benchmarks

The benchmarks measure validation plan normalization, compilation and reuse, CEL field access, 20 CEL rules, deep recursion, evaluation of repeated and map fields, and eight concurrent callers sharing a cold or warm validator cache.

```sh
mise run benchmark
MIX_ENV=test mise exec -- mix protovalidate.benchmark --time 2 --warmup 1 --memory-time 1 --output /tmp/protovalidate-benchmark.csv
```

The output CSV records time in ns and memory allocation in bytes. `time_cv` and `memory_cv` are coefficients of variation, and `*_samples` contains the sample count. Memory values measure allocations by the benchmark process; they do not represent the VM's total RSS or ETS memory retained.

`cold_concurrent_8` creates and closes a validator for each sample, while `warm_concurrent_8` shares a prepared cache. Worker allocations and ETS retention are outside Benchee's per-process memory figure. Compare system memory or ETS table sizes separately when those are the subject of the change.

For performance comparisons, alternate multiple runs before and after a change on the same machine with the same toolchain and dependencies. Shared CI runner results are useful for observing trends, but are not a basis for fixed performance pass/fail thresholds.
