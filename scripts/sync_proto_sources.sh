#!/usr/bin/env sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
project_root=$(CDPATH= cd -- "$script_dir/.." && pwd)
. "$script_dir/proto_sources.env"

protoc_path=$(command -v protoc)
actual_protoc_version=$("$protoc_path" --version)
expected_protoc_version="libprotoc $PROTOC_VERSION"

if [ "$actual_protoc_version" != "$expected_protoc_version" ]; then
  printf 'Expected %s, got %s\n' "$expected_protoc_version" "$actual_protoc_version" >&2
  exit 1
fi

temp_dir=$(mktemp -d)
trap 'rm -rf "$temp_dir"' EXIT HUP INT TERM
archive_path="$temp_dir/protovalidate.tar.gz"
extract_dir="$temp_dir/extracted"
target_dir="$project_root/priv/proto"
protobuf_include="$(dirname "$protoc_path")/../include"

curl --fail --location --silent --show-error --output "$archive_path" "$PROTOVALIDATE_ARCHIVE_URL"
actual_archive_sha=$(shasum -a 256 "$archive_path" | awk '{print $1}')

if [ "$actual_archive_sha" != "$PROTOVALIDATE_ARCHIVE_SHA256" ]; then
  printf 'Protovalidate archive checksum mismatch\nExpected: %s\nActual:   %s\n' \
    "$PROTOVALIDATE_ARCHIVE_SHA256" "$actual_archive_sha" >&2
  exit 1
fi

mkdir -p "$extract_dir"
tar -xzf "$archive_path" -C "$extract_dir"

schema_dir="$extract_dir/protovalidate-$PROTOVALIDATE_VERSION/proto/protovalidate/buf/validate"

if [ ! -d "$schema_dir" ] || [ ! -d "$protobuf_include/google/protobuf" ]; then
  printf 'Required proto sources were not found\n' >&2
  exit 1
fi

rm -rf "$target_dir"
mkdir -p "$target_dir/buf/validate"
find "$schema_dir" -type f -name '*.proto' -exec cp {} "$target_dir/buf/validate" \;
cp -R "$protobuf_include/google" "$target_dir/google"

(
  cd "$target_dir"
  find . -type f -name '*.proto' -print | LC_ALL=C sort | xargs shasum -a 256 > SHA256SUMS
)

cat > "$target_dir/SOURCES" <<EOF
Protovalidate version: $PROTOVALIDATE_VERSION
Protovalidate archive: $PROTOVALIDATE_ARCHIVE_URL
Protovalidate archive SHA-256: $PROTOVALIDATE_ARCHIVE_SHA256
protoc version: $actual_protoc_version
EOF

printf 'Synchronized proto sources in %s\n' "$target_dir"
