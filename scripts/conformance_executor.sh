#!/usr/bin/env sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
project_root=$(CDPATH= cd -- "$script_dir/.." && pwd)

cd "$project_root"
stdin_file=$(mktemp "${TMPDIR:-/tmp}/protovalidate-conformance.XXXXXX")
trap 'rm -f "$stdin_file"' 0
cat > "$stdin_file"

PROTOVALIDATE_CONFORMANCE_STDIN_FILE="$stdin_file" mix run --no-compile --no-start -e 'options = case System.get_env("PROTOVALIDATE_CEL") do
  nil -> []
  "celixir" -> [cel: Protovalidate.CEL.Celixir]
  other -> raise "Unknown CEL executor: #{other}"
end
Protovalidate.Conformance.Executor.run(options)' 
