defmodule Protovalidate.Validator.EvaluationContext do
  @moduledoc false

  alias Protovalidate.ValidationBudget

  @enforce_keys [:budget, :now, :fail_fast]
  defstruct [:budget, :now, :fail_fast]

  @type t :: %__MODULE__{
          budget: ValidationBudget.t(),
          now: map(),
          fail_fast: boolean()
        }

  @spec new(keyword()) :: t()
  def new(options) do
    %__MODULE__{
      budget: ValidationBudget.new(options),
      now: Protovalidate.Rules.WellKnown.timestamp_now(),
      fail_fast: Keyword.fetch!(options, :fail_fast)
    }
  end

  @spec options(t()) :: keyword()
  def options(context) do
    [
      validation_budget: context.budget,
      now: context.now,
      fail_fast: context.fail_fast
    ]
  end
end
