defmodule Protovalidate do
  @moduledoc """
  Elixir runtime implementation of Buf Protovalidate.

  Runs `buf.validate` rules attached to generated Protobuf messages.
  """

  @type validation_result(message) ::
          {:ok, message} | {:error, Protovalidate.ValidationError.t() | Exception.t()}

  @spec new(Protovalidate.Validator.options()) :: Protovalidate.Validator.t()
  defdelegate new(options \\ []), to: Protovalidate.Validator

  @spec validate(struct(), Protovalidate.Validator.options()) :: validation_result(struct())
  def validate(message, options \\ []) do
    validator = new(options)

    try do
      Protovalidate.Validator.validate(validator, message)
    after
      Protovalidate.Validator.close(validator)
    end
  end

  @spec validate!(struct(), Protovalidate.Validator.options()) :: struct()
  def validate!(message, options \\ []) do
    case validate(message, options) do
      {:ok, valid_message} -> valid_message
      {:error, exception} -> raise exception
    end
  end
end
