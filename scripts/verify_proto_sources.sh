#!/usr/bin/env sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
project_root=$(CDPATH= cd -- "$script_dir/.." && pwd)
target_dir="$project_root/priv/proto"
expected_hashes="$target_dir/SHA256SUMS"

if [ ! -f "$expected_hashes" ]; then
  printf 'Missing hash manifest: %s\nRun mise run schema:sync first.\n' "$expected_hashes" >&2
  exit 1
fi

actual_hashes=$(mktemp)
trap 'rm -f "$actual_hashes"' EXIT HUP INT TERM

(
  cd "$target_dir"
  find . -type f -name '*.proto' -print | LC_ALL=C sort | xargs shasum -a 256 > "$actual_hashes"
)

diff -u "$expected_hashes" "$actual_hashes"
printf 'Verified proto source hashes in %s\n' "$target_dir"
