defmodule Protovalidate.Rules.Messages do
  @moduledoc false

  def constant(value, %{type: :TYPE_BYTES}), do: "must be #{Base.encode16(value, case: :lower)}"
  def constant(value, %{type: :TYPE_STRING}), do: "must equal `#{value}`"
  def constant(value, _field), do: "must equal #{format(value)}"

  def comparison(rule, %{seconds: seconds, nanos: nanos}, :duration) do
    sign = if seconds < 0 or nanos < 0, do: "-", else: ""

    fraction =
      if nanos == 0,
        do: "",
        else:
          "." <>
            (abs(nanos)
             |> Integer.to_string()
             |> String.pad_leading(9, "0")
             |> String.trim_trailing("0"))

    "must be #{operator(rule)} #{sign}#{abs(seconds)}#{fraction}s"
  end

  def comparison(rule, limit, _type), do: comparison(rule, limit)

  def comparison(rule, limit), do: "must be #{operator(rule)} #{format(limit)}"
  def membership(:in, values), do: "must be in list [#{Enum.map_join(values, ", ", &format/1)}]"

  def membership(:not_in, values),
    do: "must not be in list [#{Enum.map_join(values, ", ", &format/1)}]"

  def operator(:gt), do: "greater than"
  def operator(:gte), do: "greater than or equal to"
  def operator(:lt), do: "less than"
  def operator(:lte), do: "less than or equal to"

  def format(%{seconds: seconds, nanos: nanos}) do
    base = seconds |> DateTime.from_unix!() |> DateTime.to_iso8601() |> String.trim_trailing("Z")

    fraction =
      if nanos == 0,
        do: "",
        else:
          "." <>
            (nanos
             |> Integer.to_string()
             |> String.pad_leading(9, "0")
             |> String.trim_trailing("0"))

    base <> fraction <> "Z"
  end

  def format(value) when is_float(value),
    do: value |> Float.to_string() |> String.replace(~r/\.0\z/, "")

  def format(:negative_infinity), do: "-inf"
  def format(:infinity), do: "inf"
  def format(:nan), do: "nan"
  def format(value), do: to_string(value)
end
