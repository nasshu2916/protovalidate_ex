defmodule Protovalidate.CEL.TypeEnvironment do
  @moduledoc "Protobuf type, presence, and reference information passed to a CEL evaluator."

  alias Protovalidate.DescriptorAdapter

  @type t :: %{
          message: map() | nil,
          field: map() | nil,
          resolver: Protovalidate.CEL.DescriptorResolver.t() | nil
        }

  @spec new(keyword()) :: t()
  def new(options),
    do: %{
      message: Keyword.get(options, :cel_message_descriptor),
      field: Keyword.get(options, :cel_field_descriptor),
      resolver: Keyword.get(options, :cel_descriptor_resolver)
    }

  @doc "Resolves references on demand without infinitely expanding recursive types."
  def resolve_message(%{reference: module}) when is_atom(module) and not is_nil(module),
    do: DescriptorAdapter.describe(module)
end
