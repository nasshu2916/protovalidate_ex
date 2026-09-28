#!/usr/bin/env sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
project_root=$(CDPATH= cd -- "$script_dir/.." && pwd)
log_path="${CONFORMANCE_LOG:-$project_root/_build/conformance/all.log}"
mkdir -p "$(dirname -- "$log_path")"

# 既知失敗も実行する。完全な終了記録と件数を検査し、途中終了を成功扱いしない。
status=0
if [ "${CONFORMANCE_REUSE_LOG:-0}" = 1 ]; then
  # 同じ変更で既に全件実行したログを再利用し、基準更新後の再実行を避ける。
  if [ -z "${CONFORMANCE_LOG:-}" ] || [ ! -f "$log_path" ]; then
    printf 'CONFORMANCE_REUSE_LOG requires an existing CONFORMANCE_LOG\n' >&2
    exit 1
  fi
else
  # CI のフル実行には 5 秒では短いため、全ケースを完了できる時間を指定する。
  "$script_dir/run_conformance.sh" --timeout 2m >"$log_path" 2>&1 || status=$?
fi
if ! python3 "$script_dir/conformance_snapshot.py" "$log_path" \
  --check "$project_root/priv/conformance/baseline.json" \
  --plan "$project_root/_build/conformance/implementation-plan.json"; then
  tail -n 80 "$log_path"
  exit 1
fi
if [ "${CONFORMANCE_REUSE_LOG:-0}" = 1 ]; then
  printf 'Checked existing full log: %s\n' "$log_path"
else
  printf 'Harness exit: %s; full log: %s\n' "$status" "$log_path"
fi
