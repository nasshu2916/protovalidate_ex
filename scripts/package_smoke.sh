#!/usr/bin/env sh
set -eu
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
project_root=$(CDPATH= cd -- "$script_dir/.." && pwd)
smoke_root=$(mktemp -d)
trap 'rm -rf "$smoke_root"' EXIT HUP INT TERM

cd "$project_root"
mix hex.build --output "$smoke_root/package.tar"
mkdir -p "$smoke_root/archive" "$smoke_root/package" "$smoke_root/consumer/lib"
tar -xf "$smoke_root/package.tar" -C "$smoke_root/archive"
tar -xzf "$smoke_root/archive/contents.tar.gz" -C "$smoke_root/package"

cat > "$smoke_root/consumer/mix.exs" <<'EX'
defmodule PackageSmoke.MixProject do
  use Mix.Project
  def project do
    [app: :package_smoke, version: "0.0.0", deps: [{:protovalidate, path: "../package"}]]
  end
  def application, do: [extra_applications: [:logger]]
end
EX

cat > "$smoke_root/consumer/input.proto" <<'PROTO'
syntax = "proto3";
package package_smoke;
import "buf/validate/validate.proto";
message Input {
  int64 value = 1 [(buf.validate.field).int64 = {gt: 10, lt: 5}];
  string name = 2 [(buf.validate.field).string.uuid = true];
}
PROTO

plugin_path="${PROTOC_GEN_ELIXIR:-$(mise where elixir)/.mix/escripts/protoc-gen-elixir}"
if [ ! -x "$plugin_path" ]; then
  printf 'Install protoc-gen-elixir first: mix escript.install hex protobuf 0.17.0 --force\n' >&2
  exit 1
fi
protoc --plugin="protoc-gen-elixir=$plugin_path" \
  --proto_path "$smoke_root/package/priv/proto" \
  --proto_path "$smoke_root/consumer" \
  --elixir_out "$smoke_root/consumer/lib" --elixir_opt gen_descriptors=true \
  "$smoke_root/consumer/input.proto"

cat > "$smoke_root/consumer/smoke.exs" <<'EX'
message = %PackageSmoke.Input{value: 12, name: "00000000-0000-0000-0000-000000000000"}
{:ok, ^message} = Protovalidate.validate(message)
{:error, %Protovalidate.ValidationError{violations: [violation]}} =
  Protovalidate.validate(%{message | value: 7})
"int64.gt_lt_exclusive" = violation.rule_id
["int64", "gt"] = violation.rule_path
IO.puts("Package smoke passed")
EX

cd "$smoke_root/consumer"
mix deps.get
mix run smoke.exs
