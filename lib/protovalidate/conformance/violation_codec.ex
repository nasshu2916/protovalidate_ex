defmodule Protovalidate.Conformance.ViolationCodec do
  @moduledoc false

  defdelegate encode(violations, module), to: Protovalidate.ViolationCodec
  defdelegate field_path(segments, module), to: Protovalidate.ViolationPath
end
