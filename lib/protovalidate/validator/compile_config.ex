defmodule Protovalidate.Validator.CompileConfig do
  @moduledoc false

  @enforce_keys [:cel, :legacy_required, :registry, :cel_descriptor_resolver]
  defstruct [:cel, :legacy_required, :registry, :cel_descriptor_resolver]

  @type t :: %__MODULE__{
          cel: term(),
          legacy_required: boolean(),
          registry: term(),
          cel_descriptor_resolver: term()
        }

  @spec new(keyword()) :: t()
  def new(options) do
    %__MODULE__{
      cel: Keyword.get(options, :cel),
      legacy_required: Keyword.get(options, :legacy_required, false),
      registry: Keyword.get(options, :registry),
      cel_descriptor_resolver: Keyword.get(options, :cel_descriptor_resolver)
    }
  end

  @spec options(t()) :: keyword()
  def options(config) do
    [
      cel: config.cel,
      legacy_required: config.legacy_required,
      registry: config.registry,
      cel_descriptor_resolver: config.cel_descriptor_resolver
    ]
  end
end
