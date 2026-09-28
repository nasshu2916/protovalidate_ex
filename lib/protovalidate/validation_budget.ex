defmodule Protovalidate.ValidationBudget do
  @moduledoc false

  @enforce_keys [:clock]
  defstruct [:deadline, :clock]

  @type t :: %__MODULE__{deadline: integer() | nil, clock: (-> integer())}

  @spec new(keyword(), (-> integer())) :: t()
  def new(options, clock \\ fn -> System.monotonic_time(:millisecond) end) do
    started_at = clock.()

    %__MODULE__{
      clock: clock,
      deadline:
        case Keyword.get(options, :validation_timeout) do
          nil -> nil
          timeout -> started_at + timeout
        end
    }
  end

  @spec remaining(t()) :: :infinity | pos_integer()
  def remaining(%__MODULE__{deadline: nil}), do: :infinity

  def remaining(%__MODULE__{deadline: deadline, clock: clock}) do
    case deadline - clock.() do
      remaining when remaining > 0 -> remaining
      _ -> raise Protovalidate.RuntimeError, message: "validation timeout"
    end
  end
end
