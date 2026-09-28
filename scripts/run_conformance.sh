#!/usr/bin/env sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
project_root=$(CDPATH= cd -- "$script_dir/.." && pwd)
. "$script_dir/proto_sources.env"

temp_dir=$(mktemp -d)
trap 'rm -rf "$temp_dir"' EXIT HUP INT TERM
archive_path="$temp_dir/protovalidate.tar.gz"
extract_dir="$temp_dir/extracted"
harness_root="$extract_dir/protovalidate-$PROTOVALIDATE_VERSION"
harness_dir="$harness_root/tools"
expected_failures="$project_root/priv/conformance/expected_failures.yaml"

curl --fail --location --silent --show-error --output "$archive_path" "$PROTOVALIDATE_ARCHIVE_URL"
actual_archive_sha=$(shasum -a 256 "$archive_path" | awk '{print $1}')

if [ "$actual_archive_sha" != "$PROTOVALIDATE_ARCHIVE_SHA256" ]; then
  printf 'Protovalidate conformance archive checksum mismatch\nExpected: %s\nActual:   %s\n' \
    "$PROTOVALIDATE_ARCHIVE_SHA256" "$actual_archive_sha" >&2
  exit 1
fi

mkdir -p "$extract_dir"
tar -xzf "$archive_path" -C "$extract_dir"

if [ ! -f "$harness_root/go.work" ] || [ ! -f "$harness_dir/go.mod" ] ||
  [ ! -d "$harness_dir/protovalidate-conformance" ]; then
  printf 'Conformance harness was not found in the fixed archive\n' >&2
  exit 1
fi

if [ ! -f "$expected_failures" ]; then
  printf 'Expected failures file was not found: %s\n' "$expected_failures" >&2
  exit 1
fi

# executor の標準出力は protobuf wire format 専用のため、Mix のコンパイル出力は先に消費する。
MIX_ENV=test mix compile >/dev/null

cd "$harness_dir"
MIX_ENV=test go run ./protovalidate-conformance \
  --expected_failures "$expected_failures" \
  "$@" \
  "$project_root/scripts/conformance_executor.sh"
