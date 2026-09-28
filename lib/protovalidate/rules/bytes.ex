defmodule Protovalidate.Rules.Bytes do
  @moduledoc false

  @type compiled ::
          {:const | :pattern | :prefix | :suffix | :contains, binary()}
          | {:pattern, Regex.t()}
          | {:len | :min_len | :max_len, non_neg_integer()}
          | {:in | :not_in, [binary()]}
          | :bytes_ip
          | :bytes_ipv4
          | :bytes_ipv6
          | :bytes_uuid

  import Protovalidate.Rules.Compilation
  import Protovalidate.Rules.Violations

  @spec bytes_rules(map()) :: [Protovalidate.Rules.compiled()]
  def bytes_rules(rules) do
    known = [
      :const,
      :len,
      :min_len,
      :max_len,
      :pattern,
      :prefix,
      :suffix,
      :contains,
      :in,
      :not_in,
      :ip,
      :ipv4,
      :ipv6,
      :uuid,
      :example
    ]

    reject_unknown_rule_fields!(rules, known, "bytes")

    []
    |> append_scalar_rules(rules, known -- [:ip, :ipv4, :ipv6, :uuid, :example])
    |> add_if(rule_value(rules, :ip) == true, :bytes_ip)
    |> add_if(rule_value(rules, :ipv4) == true, :bytes_ipv4)
    |> add_if(rule_value(rules, :ipv6) == true, :bytes_ipv6)
    |> add_if(rule_value(rules, :uuid) == true, :bytes_uuid)
    |> Protovalidate.Rules.Pattern.compile(:bytes)
  end

  @spec evaluate(
          Protovalidate.Rules.compiled(),
          Protovalidate.Rules.value(),
          Protovalidate.DescriptorAdapter.Field.t(),
          Protovalidate.Rules.context()
        ) :: Protovalidate.Rules.result()
  def evaluate({:pattern, _regex}, value, _field, _context) when not is_binary(value),
    do: raise(Protovalidate.RuntimeError, message: "bytes pattern requires a binary value")

  def evaluate({:pattern, regex}, value, field, context) do
    unless String.valid?(value),
      do: raise(Protovalidate.RuntimeError, message: "value must be valid UTF-8 to apply regexp")

    check(
      context,
      Protovalidate.Rules.Pattern.match?(regex, value),
      field,
      "bytes.pattern",
      "value does not match the pattern"
    )
  end

  def evaluate(:bytes_uuid, "", field, context),
    do:
      add(
        context,
        Protovalidate.Violation.new(path(field), "bytes.uuid_empty", "value must not be empty",
          rule_path: ["bytes", "uuid"]
        )
      )

  def evaluate({kind, limit}, value, field, context) when kind in [:len, :min_len, :max_len] do
    size = byte_size(value)

    valid? =
      case kind do
        :len -> size == limit
        :min_len -> size >= limit
        :max_len -> size <= limit
      end

    check(context, valid?, field, "bytes.#{kind}", "value byte length violates the constraint", %{
      kind => limit
    })
  end

  def evaluate(:bytes_ip, value, field, context),
    do:
      check(
        context,
        byte_size(value) in [4, 16],
        field,
        "bytes.ip",
        "value must be an IP address"
      )

  def evaluate(:bytes_ipv4, value, field, context),
    do:
      check(context, byte_size(value) == 4, field, "bytes.ipv4", "value must be an IPv4 address")

  def evaluate(:bytes_ipv6, value, field, context),
    do:
      check(context, byte_size(value) == 16, field, "bytes.ipv6", "value must be an IPv6 address")

  def evaluate(:bytes_uuid, value, field, context),
    do: check(context, byte_size(value) == 16, field, "bytes.uuid", "UUID must be 16 bytes")

  # bytes と string が共用していた判定と rule ID を、この段階ではそのまま維持する。
  def evaluate(rule, value, field, context),
    do: Protovalidate.Rules.String.evaluate(rule, value, field, context)
end
