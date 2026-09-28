defmodule Buf.Validate.PbExtension do
  @moduledoc false

  use Protobuf, protoc_gen_elixir_version: "0.17.0"

  extend Google.Protobuf.FieldOptions, :field, 1159, optional: true, type: Buf.Validate.FieldRules

  extend Google.Protobuf.MessageOptions, :message, 1159,
    optional: true,
    type: Buf.Validate.MessageRules

  extend Google.Protobuf.OneofOptions, :oneof, 1159, optional: true, type: Buf.Validate.OneofRules
end
