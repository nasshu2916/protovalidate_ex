defmodule Protovalidate.Rules.Range do
  @moduledoc false

  alias Protovalidate.Rules.{Numeric, Violations}
  alias Protovalidate.Violation

  @type compiled :: {:range, %{lower: tuple(), upper: tuple(), reversed?: boolean()}}

  def compile(rules) do
    lower = Enum.find(rules, &(elem(&1, 0) in [:gt, :gte]))
    upper = Enum.find(rules, &(elem(&1, 0) in [:lt, :lte]))

    if lower && upper do
      range = %{
        lower: lower,
        upper: upper,
        reversed?: compare(elem(lower, 1), elem(upper, 1)) == :gt
      }

      Enum.flat_map(rules, fn rule ->
        cond do
          rule == upper -> []
          rule == lower -> [{:range, range}]
          true -> [rule]
        end
      end)
    else
      rules
    end
  end

  def evaluate(range, value, field, context) do
    %{lower: {lower, low}, upper: {upper, high}, reversed?: reversed?} = range
    above? = compare(value, low) in if(lower == :gt, do: [:gt], else: [:gt, :eq])
    below? = compare(value, high) in if(upper == :lt, do: [:lt], else: [:lt, :eq])
    valid? = if reversed?, do: above? or below?, else: above? and below?
    prefix = prefix(field)
    id = "#{prefix}.#{lower}_#{upper}" <> if(reversed?, do: "_exclusive", else: "")

    if valid? do
      {:cont, context}
    else
      Violations.add(
        context,
        Violation.new(Violations.path(field), id, "value does not match the specified range",
          rule_path: [prefix, Atom.to_string(lower)]
        )
      )
    end
  end

  defp prefix(%{well_known_type: type}) when type in [:duration, :timestamp],
    do: Atom.to_string(type)

  defp prefix(field), do: field |> Violations.rule_id("") |> String.trim_trailing(".")

  defp compare(%{seconds: s, nanos: n}, %{seconds: ls, nanos: ln}),
    do: Numeric.compare({s, n}, {ls, ln})

  defp compare(left, right), do: Numeric.compare(left, right)
end
