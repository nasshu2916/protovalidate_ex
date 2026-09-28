defmodule Protovalidate.Conformance.Executor do
  @moduledoc "One-shot executor for the official Protovalidate conformance harness."

  alias Buf.Validate.Conformance.Harness.{
    TestConformanceRequest,
    TestConformanceResponse,
    TestResult
  }

  alias Protovalidate.{
    CompilationError,
    RuntimeError,
    UnsupportedRuleError,
    ValidationError,
    ViolationCodec
  }

  alias Protovalidate.Conformance.RuntimeDescriptorAdapter

  @spec run(keyword()) :: :ok
  def run(options \\ []) do
    # protobuf wire data は文字コード変換せず、標準入出力でバイト列として扱う。
    :ok = :io.setopts(:standard_io, binary: true, encoding: :latin1)
    request = read_stdin() |> TestConformanceRequest.decode()
    response = execute(request, options)
    IO.binwrite(:stdio, TestConformanceResponse.encode(response))
  end

  defp read_stdin, do: read_stdin([])

  defp read_stdin(chunks) do
    case IO.binread(:stdio, 65_536) do
      :eof -> chunks |> Enum.reverse() |> IO.iodata_to_binary()
      data -> read_stdin([data | chunks])
    end
  end

  @spec execute(struct(), keyword()) :: struct()
  def execute(%TestConformanceRequest{} = request, options \\ []) do
    results =
      Map.new(request.cases, fn {name, any} ->
        {name, execute_case(request.fdset, any, options)}
      end)

    %TestConformanceResponse{results: results}
  end

  defp execute_case(fdset, any, options) do
    {message, registry} = RuntimeDescriptorAdapter.decode_with_registry(fdset, any)
    options = Keyword.put_new(options, :registry, registry)

    case Protovalidate.validate(message, options) do
      {:ok, _} ->
        %TestResult{result: {:success, true}}

      {:error, %ValidationError{violations: violations}} ->
        %TestResult{
          result: {:validation_error, ViolationCodec.encode(violations, message.__struct__)}
        }

      {:error, error} ->
        error_result(error)
    end
  rescue
    error -> error_result(error)
  end

  defp error_result(%CompilationError{} = error),
    do: %TestResult{result: {:compilation_error, error.message}}

  defp error_result(%UnsupportedRuleError{} = error),
    do: %TestResult{result: {:compilation_error, error.message}}

  defp error_result(%RuntimeError{} = error),
    do: %TestResult{result: {:runtime_error, error.message}}

  defp error_result(error), do: %TestResult{result: {:unexpected_error, Exception.message(error)}}
end
