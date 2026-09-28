defmodule Protovalidate.Validator.Telemetry do
  @moduledoc false

  alias Protovalidate.{CompilationError, RuntimeError, UnsupportedRuleError, ValidationError}

  @spec measure(atom(), module() | nil, (-> term())) :: term()
  def measure(phase, module, operation) do
    started_at = System.monotonic_time()
    :telemetry.execute([:protovalidate, :call, phase, :start], %{}, %{message_module: module})

    try do
      result = operation.()
      emit(phase, module, started_at, outcome(result))
      result
    rescue
      error ->
        emit(phase, module, started_at, classify_error(error))
        reraise error, __STACKTRACE__
    end
  end

  defp outcome({:ok, violations}) when is_list(violations),
    do: if(violations == [], do: :ok, else: :violation)

  defp outcome({:error, %ValidationError{}}), do: :violation
  defp outcome({:error, error}), do: classify_error(error)
  defp outcome(_result), do: :ok

  @spec classify_error(Exception.t()) :: :compile_error | :runtime_error
  def classify_error(%CompilationError{}), do: :compile_error
  def classify_error(%UnsupportedRuleError{}), do: :compile_error
  def classify_error(%RuntimeError{}), do: :runtime_error
  def classify_error(_error), do: :runtime_error

  defp emit(phase, module, started_at, outcome) do
    :telemetry.execute(
      [:protovalidate, :call, phase, :stop],
      %{duration: System.monotonic_time() - started_at},
      %{message_module: module, outcome: outcome}
    )
  end
end
