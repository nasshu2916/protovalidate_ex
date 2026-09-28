defmodule Protovalidate.CEL.DescriptorResolver do
  @moduledoc false

  alias Protovalidate.Validator.PlanCache

  @enforce_keys [:cache]
  defstruct [:cache]

  @type t :: %__MODULE__{cache: :ets.tid()}

  @spec new(:ets.tid()) :: t()
  def new(cache), do: %__MODULE__{cache: cache}

  @spec field(t(), module(), String.t()) :: map() | nil
  def field(%__MODULE__{cache: cache}, module, name),
    do: PlanCache.resolve_field(cache, module, name)
end
