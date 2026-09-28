defmodule Protovalidate.Rules.String do
  @moduledoc false

  @type compiled ::
          {:const | :pattern | :prefix | :suffix | :contains | :not_contains, binary()}
          | {:pattern, Regex.t()}
          | {:len | :min_len | :max_len | :len_bytes | :min_bytes | :max_bytes, non_neg_integer()}
          | {:in | :not_in, [binary()]}
          | {:well_known_regex, {integer() | atom(), boolean()}}
          | :uuid
          | :email
          | :hostname
          | :ip
          | :ipv4
          | :ipv6
          | :uri
          | :uri_ref
          | :address
          | :tuuid
          | :ip_with_prefixlen
          | :ipv4_with_prefixlen
          | :ipv6_with_prefixlen
          | :ip_prefix
          | :ipv4_prefix
          | :ipv6_prefix
          | :host_and_port
          | :ulid
          | :protobuf_fqn
          | :protobuf_dot_fqn

  import Protovalidate.Rules.Compilation
  import Protovalidate.Rules.Violations
  alias Protovalidate.Rules.String.Format

  @spec string_rules(map()) :: [Protovalidate.Rules.compiled()]
  def string_rules(rules) do
    known = [
      :const,
      :len,
      :min_len,
      :max_len,
      :len_bytes,
      :min_bytes,
      :max_bytes,
      :pattern,
      :prefix,
      :suffix,
      :contains,
      :not_contains,
      :in,
      :not_in,
      :uuid,
      :email,
      :hostname,
      :ip,
      :ipv4,
      :ipv6,
      :uri,
      :uri_ref,
      :address,
      :tuuid,
      :ip_with_prefixlen,
      :ipv4_with_prefixlen,
      :ipv6_with_prefixlen,
      :ip_prefix,
      :ipv4_prefix,
      :ipv6_prefix,
      :host_and_port,
      :ulid,
      :protobuf_fqn,
      :protobuf_dot_fqn,
      :well_known_regex,
      :strict,
      :example
    ]

    reject_unknown_rule_fields!(rules, known, "string")

    []
    |> append_scalar_rules(rules, [
      :const,
      :len,
      :min_len,
      :max_len,
      :len_bytes,
      :min_bytes,
      :max_bytes
    ])
    |> append_scalar_rules(rules, [
      :pattern,
      :prefix,
      :suffix,
      :contains,
      :not_contains,
      :in,
      :not_in
    ])
    |> add_if(rule_value(rules, :uuid) == true, :uuid)
    |> add_if(rule_value(rules, :email) == true, :email)
    |> add_if(rule_value(rules, :hostname) == true, :hostname)
    |> add_if(rule_value(rules, :ip) == true, :ip)
    |> add_if(rule_value(rules, :ipv4) == true, :ipv4)
    |> add_if(rule_value(rules, :ipv6) == true, :ipv6)
    |> add_if(rule_value(rules, :uri) == true, :uri)
    |> add_if(rule_value(rules, :uri_ref) == true, :uri_ref)
    |> add_if(rule_value(rules, :address) == true, :address)
    |> add_if(rule_value(rules, :tuuid) == true, :tuuid)
    |> add_if(rule_value(rules, :ip_with_prefixlen) == true, :ip_with_prefixlen)
    |> add_if(rule_value(rules, :ipv4_with_prefixlen) == true, :ipv4_with_prefixlen)
    |> add_if(rule_value(rules, :ipv6_with_prefixlen) == true, :ipv6_with_prefixlen)
    |> add_if(rule_value(rules, :ip_prefix) == true, :ip_prefix)
    |> add_if(rule_value(rules, :ipv4_prefix) == true, :ipv4_prefix)
    |> add_if(rule_value(rules, :ipv6_prefix) == true, :ipv6_prefix)
    |> add_if(rule_value(rules, :host_and_port) == true, :host_and_port)
    |> add_if(rule_value(rules, :ulid) == true, :ulid)
    |> add_if(rule_value(rules, :protobuf_fqn) == true, :protobuf_fqn)
    |> add_if(rule_value(rules, :protobuf_dot_fqn) == true, :protobuf_dot_fqn)
    |> append_well_known_regex(rules)
    |> Protovalidate.Rules.Pattern.compile(:string)
  end

  defp append_well_known_regex(compiled, rules) do
    case rule_value(rules, :well_known_regex) do
      nil ->
        compiled

      :KNOWN_REGEX_UNSPECIFIED ->
        compiled

      0 ->
        compiled

      value when value in [1, 2, :KNOWN_REGEX_HTTP_HEADER_NAME, :KNOWN_REGEX_HTTP_HEADER_VALUE] ->
        compiled ++ [{:well_known_regex, {value, rule_value(rules, :strict) != false}}]

      value ->
        compilation_error!("string.well_known_regex must be a known value: #{inspect(value)}", [
          "string",
          "well_known_regex"
        ])
    end
  end

  defp well_known_regex?(regex, value) when regex in [1, :KNOWN_REGEX_HTTP_HEADER_NAME],
    do:
      is_binary(value) and value != "" and
        Regex.match?(~r/^:?[0-9A-Za-z!#$%&'*+\-.^_|~`]+$/, value)

  defp well_known_regex?(regex, value) when regex in [2, :KNOWN_REGEX_HTTP_HEADER_VALUE],
    do: is_binary(value) and Regex.match?(~r/^[^\x00-\x08\x0A-\x1F\x7F]*$/, value)

  defp well_known_regex?(_, _), do: false

  defp header_regex?(regex, value, true), do: well_known_regex?(regex, value)

  defp header_regex?(regex, value, false),
    do:
      is_binary(value) and not String.contains?(value, [<<0>>, "\r", "\n"]) and
        (regex in [2, :KNOWN_REGEX_HTTP_HEADER_VALUE] or value != "")

  defp header_regex_id(regex, "") when regex in [1, :KNOWN_REGEX_HTTP_HEADER_NAME],
    do: "string.well_known_regex.header_name_empty"

  defp header_regex_id(regex, _value), do: well_known_regex_id(regex)

  defp well_known_regex_id(regex) when regex in [1, :KNOWN_REGEX_HTTP_HEADER_NAME],
    do: "string.well_known_regex.header_name"

  defp well_known_regex_id(_), do: "string.well_known_regex.header_value"

  @spec evaluate(
          Protovalidate.Rules.compiled(),
          Protovalidate.Rules.value(),
          Protovalidate.DescriptorAdapter.Field.t(),
          Protovalidate.Rules.context()
        ) :: Protovalidate.Rules.result()
  def evaluate(format, "", field, context)
      when format in [
             :uuid,
             :email,
             :hostname,
             :ip,
             :ipv4,
             :ipv6,
             :uri,
             :address,
             :tuuid,
             :ip_with_prefixlen,
             :ipv4_with_prefixlen,
             :ipv6_with_prefixlen,
             :ip_prefix,
             :ipv4_prefix,
             :ipv6_prefix,
             :host_and_port,
             :ulid,
             :protobuf_fqn,
             :protobuf_dot_fqn
           ] do
    add(
      context,
      Protovalidate.Violation.new(
        path(field),
        "string.#{format}_empty",
        "value must not be empty",
        rule_path: ["string", Atom.to_string(format)]
      )
    )
  end

  def evaluate(:uuid, value, field, context),
    do: check(context, Format.uuid?(value), field, "string.uuid", "value must be a UUID")

  def evaluate(:email, value, field, context),
    do:
      check(
        context,
        Format.email?(value),
        field,
        "string.email",
        "value must be an email address"
      )

  def evaluate({:max_len, limit}, value, field, context),
    do:
      check(
        context,
        length(String.codepoints(value)) <= limit,
        field,
        "string.max_len",
        "value exceeds the maximum length",
        %{
          max_len: limit
        }
      )

  def evaluate({:min_len, limit}, value, field, context),
    do:
      check(
        context,
        length(String.codepoints(value)) >= limit,
        field,
        "string.min_len",
        "value is shorter than the minimum length",
        %{
          min_len: limit
        }
      )

  def evaluate({:len, limit}, value, field, context),
    do:
      check(
        context,
        length(String.codepoints(value)) == limit,
        field,
        "string.len",
        "value length does not match",
        %{
          len: limit
        }
      )

  def evaluate({:len_bytes, limit}, value, field, context),
    do:
      check(
        context,
        byte_size(value) == limit,
        field,
        "string.len_bytes",
        "value byte length does not match",
        %{
          len_bytes: limit
        }
      )

  def evaluate({:min_bytes, limit}, value, field, context),
    do:
      check(
        context,
        byte_size(value) >= limit,
        field,
        "string.min_bytes",
        "value is shorter than the minimum byte length",
        %{
          min_bytes: limit
        }
      )

  def evaluate({:max_bytes, limit}, value, field, context),
    do:
      check(
        context,
        byte_size(value) <= limit,
        field,
        "string.max_bytes",
        "value exceeds the maximum byte length",
        %{
          max_bytes: limit
        }
      )

  def evaluate({:prefix, expected}, value, field, context),
    do:
      check(
        context,
        String.starts_with?(value, expected),
        field,
        rule_id(field, "prefix"),
        "value does not have the required prefix"
      )

  def evaluate({:suffix, expected}, value, field, context),
    do:
      check(
        context,
        String.ends_with?(value, expected),
        field,
        rule_id(field, "suffix"),
        "value does not have the required suffix"
      )

  def evaluate({:contains, expected}, value, field, context),
    do:
      check(
        context,
        String.contains?(value, expected),
        field,
        rule_id(field, "contains"),
        "value must contain the specified substring"
      )

  def evaluate({:not_contains, expected}, value, field, context),
    do:
      check(
        context,
        not String.contains?(value, expected),
        field,
        "string.not_contains",
        "value must not contain the specified substring"
      )

  def evaluate({:pattern, regex}, value, field, context),
    do:
      check(
        context,
        Protovalidate.Rules.Pattern.match?(regex, value),
        field,
        rule_id(field, "pattern"),
        "value does not match the pattern"
      )

  def evaluate(:hostname, value, field, context),
    do:
      check(
        context,
        Format.hostname?(value),
        field,
        "string.hostname",
        "value must be a hostname"
      )

  def evaluate(:ip, value, field, context),
    do: check(context, Format.ip?(value), field, "string.ip", "value must be an IP address")

  def evaluate(:ipv4, value, field, context),
    do: check(context, Format.ipv4?(value), field, "string.ipv4", "value must be an IPv4 address")

  def evaluate(:ipv6, value, field, context),
    do: check(context, Format.ipv6?(value), field, "string.ipv6", "value must be an IPv6 address")

  def evaluate(:uri, value, field, context),
    do: check(context, Format.uri?(value), field, "string.uri", "value must be a URI")

  def evaluate(:uri_ref, value, field, context),
    do:
      check(
        context,
        Format.uri_ref?(value),
        field,
        "string.uri_ref",
        "value must be a URI reference"
      )

  def evaluate(:address, value, field, context),
    do:
      check(
        context,
        Format.address?(value),
        field,
        "string.address",
        "value must be a hostname or IP address"
      )

  def evaluate(:tuuid, value, field, context),
    do:
      check(
        context,
        Format.tuuid?(value),
        field,
        "string.tuuid",
        "value must be a UUID without dashes"
      )

  def evaluate(:ip_with_prefixlen, value, field, context),
    do:
      check(
        context,
        Format.ip_prefix?(value, 0, false),
        field,
        "string.ip_with_prefixlen",
        "value must be an IP prefix"
      )

  def evaluate(:ipv4_with_prefixlen, value, field, context),
    do:
      check(
        context,
        Format.ip_prefix?(value, 4, false),
        field,
        "string.ipv4_with_prefixlen",
        "value must be an IPv4 prefix"
      )

  def evaluate(:ipv6_with_prefixlen, value, field, context),
    do:
      check(
        context,
        Format.ip_prefix?(value, 6, false),
        field,
        "string.ipv6_with_prefixlen",
        "value must be an IPv6 prefix"
      )

  def evaluate(:ip_prefix, value, field, context),
    do:
      check(
        context,
        Format.ip_prefix?(value, 0, true),
        field,
        "string.ip_prefix",
        "value must be an IP network prefix"
      )

  def evaluate(:ipv4_prefix, value, field, context),
    do:
      check(
        context,
        Format.ip_prefix?(value, 4, true),
        field,
        "string.ipv4_prefix",
        "value must be an IPv4 network prefix"
      )

  def evaluate(:ipv6_prefix, value, field, context),
    do:
      check(
        context,
        Format.ip_prefix?(value, 6, true),
        field,
        "string.ipv6_prefix",
        "value must be an IPv6 network prefix"
      )

  def evaluate(:host_and_port, value, field, context),
    do:
      check(
        context,
        Format.host_and_port?(value),
        field,
        "string.host_and_port",
        "value must be in host:port format"
      )

  def evaluate(:ulid, value, field, context),
    do: check(context, Format.ulid?(value), field, "string.ulid", "value must be a ULID")

  def evaluate(:protobuf_fqn, value, field, context),
    do:
      check(
        context,
        Format.protobuf_fqn?(value),
        field,
        "string.protobuf_fqn",
        "value must be a fully qualified Protobuf name"
      )

  def evaluate(:protobuf_dot_fqn, value, field, context),
    do:
      check(
        context,
        Format.protobuf_dot_fqn?(value),
        field,
        "string.protobuf_dot_fqn",
        "value must be a fully qualified Protobuf name with a leading dot"
      )

  def evaluate({:well_known_regex, {regex, strict?}}, value, field, context) do
    if header_regex?(regex, value, strict?) do
      {:cont, context}
    else
      add(
        context,
        Protovalidate.Violation.new(
          path(field),
          header_regex_id(regex, value),
          "value does not match the known regular expression",
          rule_path: ["string", "well_known_regex"]
        )
      )
    end
  end

  def evaluate(rule, value, field, context),
    do: Protovalidate.Rules.Common.evaluate(rule, value, field, context)
end
