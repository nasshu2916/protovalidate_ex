defmodule PhoenixSampleWeb.UserController do
  use PhoenixSampleWeb, :controller

  alias PhoenixSample.Proto.User

  def create(conn, params) do
    with {:ok, user} <- Protobuf.JSON.from_decoded(params, User),
         {:ok, valid_user} <- Protovalidate.validate(user),
         {:ok, user_json} <- Protobuf.JSON.to_encodable(valid_user, use_proto_names: true) do
      conn
      |> put_status(:created)
      |> json(%{
        status: "ok",
        user: user_json
      })
    else
      {:error, %Protovalidate.ValidationError{violations: violations}} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          status: "error",
          errors: Enum.map(violations, &format_violation/1)
        })

      {:error, %Protobuf.JSON.DecodeError{} = error} ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          status: "error",
          message: Exception.message(error)
        })

      {:error, error} ->
        raise error
    end
  end

  defp format_violation(violation) do
    %{
      field: format_field_path(violation.field_path),
      rule_id: violation.rule_id,
      message: violation.message
    }
  end

  defp format_field_path(%Protovalidate.FieldPath{segments: []}), do: "message"

  defp format_field_path(%Protovalidate.FieldPath{segments: segments}) do
    Enum.map_join(segments, ".", fn {:field, name} -> name end)
  end
end
