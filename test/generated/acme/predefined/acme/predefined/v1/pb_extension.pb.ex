defmodule Acme.Predefined.V1.PbExtension do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.17.0"

  extend Buf.Validate.Int64Rules, :even, 1001, optional: true, type: :bool, deprecated: false
end
