defmodule Protovalidate.Rules.String.Format do
  @moduledoc false

  import Bitwise

  @prefix_length_regex ~r/\A(?:0|[1-9][0-9]*)\z/
  @port_regex ~r/\A(?:0|[1-9][0-9]*)\z/
  @long_uri_port_regex ~r/\A:[0-9]{6,}\z/
  @uri_authority_regex ~r/\A((?:[A-Za-z][A-Za-z0-9+.-]*:)?\/\/)([^\/?#]*)(.*)\z/s

  def uuid?(value) when is_binary(value),
    do: Regex.match?(~r/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i, value)

  def uuid?(_value), do: false

  def tuuid?(value) when is_binary(value), do: Regex.match?(~r/^[0-9a-f]{32}$/i, value)
  def tuuid?(_value), do: false

  def email?(value) when is_binary(value) and byte_size(value) <= 254 do
    case String.split(value, "@") do
      [local, host] ->
        Regex.match?(~r/\A[a-zA-Z0-9!#$%&'*+\/?=^_`{|}~.-]+\z/, local) and
          not String.ends_with?(host, ".") and
          hostname?(host, false)

      _other ->
        false
    end
  end

  def email?(_value), do: false

  def hostname?(value) when is_binary(value), do: hostname?(value, true)
  def hostname?(_value), do: false

  defp hostname?(value, reject_numeric_final_label?) when is_binary(value) do
    host = String.trim_trailing(value, ".")
    labels = String.split(host, ".")
    last_label = List.last(labels)

    byte_size(host) in 1..253 and
      (not reject_numeric_final_label? or not Regex.match?(~r/\A[0-9]+\z/, last_label)) and
      Enum.all?(labels, fn label ->
        byte_size(label) in 1..63 and
          Regex.match?(~r/^[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\z/, label)
      end)
  end

  def ip?(value, version \\ 0)
  def ip?(value, 0) when is_binary(value), do: ipv4?(value) or ipv6_literal?(value)
  def ip?(_value, 0), do: false
  def ip?(value, 4), do: ipv4?(value)
  def ip?(value, 6), do: ipv6?(value)
  def ip?(_value, _version), do: false

  def ipv4?(value) when is_binary(value),
    do: match?({:ok, {_, _, _, _}}, :inet.parse_strict_address(String.to_charlist(value)))

  def ipv4?(_value), do: false

  def ipv6?(value) when is_binary(value),
    do:
      match?(
        {:ok, {_, _, _, _, _, _, _, _}},
        :inet.parse_strict_address(String.to_charlist(value))
      )

  def ipv6?(_value), do: false

  def ip_prefix?(value, version \\ 0, strict? \\ false)

  def ip_prefix?(value, version, strict?)
      when is_binary(value) and is_integer(version) and is_boolean(strict?) do
    with [address, length] <- String.split(value, "/", parts: 2),
         true <- Regex.match?(@prefix_length_regex, length),
         {prefix_length, ""} <- Integer.parse(length),
         {:ok, tuple} <- :inet.parse_strict_address(String.to_charlist(address)),
         true <- ip_family?(tuple, version),
         true <- prefix_length >= 0 and prefix_length <= ip_bit_size(tuple),
         true <- not strict? or network_address?(tuple, prefix_length) do
      true
    else
      _other -> false
    end
  end

  def ip_prefix?(_value, _version, _strict?), do: false

  def ip_prefix_option?(value, version) when is_integer(version),
    do: ip_prefix?(value, version, false)

  def ip_prefix_option?(value, strict?) when is_boolean(strict?),
    do: ip_prefix?(value, 0, strict?)

  def ip_prefix_option?(_value, _option), do: false

  def ip_prefix_options?(value, version, strict?)
      when is_integer(version) and is_boolean(strict?),
      do: ip_prefix?(value, version, strict?)

  def ip_prefix_options?(_value, _version, _strict?), do: false

  def host_and_port?(value, optional_port? \\ false)

  def host_and_port?(value, optional_port?)
      when is_binary(value) and is_boolean(optional_port?) do
    case split_host_and_port(value) do
      {:ok, host, port} -> valid_host?(host) and valid_port?(port)
      {:host, host} -> optional_port? and valid_host?(host)
      :error -> false
    end
  end

  def host_and_port?(_value, _optional_port?), do: false

  def host_and_port_required?(value, port_required?) when is_boolean(port_required?),
    do: host_and_port?(value, not port_required?)

  def host_and_port_required?(_value, _port_required?), do: false

  def uri?(value) when is_binary(value) do
    valid_uri_characters?(value) and
      (valid_standard_uri?(value) or valid_uri_with_ip_literal?(value))
  end

  def uri?(_value), do: false

  def uri_ref?(value) when is_binary(value),
    do: valid_uri_characters?(value) and match?({:ok, _uri}, new_uri(value))

  def uri_ref?(_value), do: false

  def address?(value), do: hostname?(value) or ip?(value)

  def ulid?(value) when is_binary(value),
    do: Regex.match?(~r/^[0-7][0-9A-HJKMNP-TV-Z]{25}$/i, value)

  def ulid?(_value), do: false

  def protobuf_fqn?(value) when is_binary(value),
    do: Regex.match?(~r/^[A-Za-z_][A-Za-z_0-9]*(\.[A-Za-z_][A-Za-z_0-9]*)*$/, value)

  def protobuf_fqn?(_value), do: false

  def protobuf_dot_fqn?(value) when is_binary(value),
    do: Regex.match?(~r/^\.[A-Za-z_][A-Za-z_0-9]*(\.[A-Za-z_][A-Za-z_0-9]*)*$/, value)

  def protobuf_dot_fqn?(_value), do: false

  defp split_host_and_port(value) do
    cond do
      match = Regex.run(~r/\A\[(.+)\]:([0-9]+)\z/, value) ->
        [_, host, port] = match
        if ipv6_literal?(host), do: {:ok, host, port}, else: :error

      match = Regex.run(~r/\A([^:]+):([0-9]+)\z/, value) ->
        [_, host, port] = match
        {:ok, host, port}

      Regex.match?(~r/\A\[.+\]\z/, value) ->
        host = value |> String.trim_leading("[") |> String.trim_trailing("]")
        if ipv6_literal?(host), do: {:host, host}, else: :error

      String.contains?(value, ":") ->
        if ipv6_literal?(value), do: {:host, value}, else: :error

      true ->
        {:host, value}
    end
  end

  defp valid_host?(host) do
    if Regex.match?(~r/\A[0-9.]+\z/, host),
      do: ipv4?(host),
      else: hostname?(host) or ipv6_literal?(host)
  end

  defp valid_port?(port) do
    Regex.match?(@port_regex, port) and
      case Integer.parse(port) do
        {number, ""} -> number in 0..65_535
        _other -> false
      end
  end

  defp valid_standard_uri?(value) do
    case new_uri(value) do
      {:ok, %URI{scheme: scheme, host: host}} when is_binary(scheme) and scheme != "" ->
        valid_uri_reg_name?(host)

      _other ->
        false
    end
  end

  defp valid_uri_reg_name?(nil), do: true
  defp valid_uri_reg_name?(host), do: valid_percent_encoded_utf8?(host)

  defp valid_uri_with_ip_literal?(value) do
    with [prefix, authority, suffix] <- uri_authority_parts(value),
         {:ok, userinfo, host, port_suffix} <- split_uri_ip_literal_authority(authority),
         true <- valid_uri_ip_literal?(host),
         sanitized <- prefix <> userinfo <> "[::1]" <> port_suffix <> suffix,
         {:ok, %URI{scheme: scheme}} <- new_uri(sanitized),
         true <- is_binary(scheme) and scheme != "" do
      true
    else
      _other -> false
    end
  end

  # RFC 3986 の port は桁数無制限。
  # OTP 29.0.6 の URI parser は整数変換を5桁に制限するため、
  # 構文検証時だけ長い port を短い数字に置き換える。
  defp new_uri(value), do: value |> normalize_long_uri_port() |> URI.new()

  defp normalize_long_uri_port(value) do
    case Regex.run(@uri_authority_regex, value) do
      [_, prefix, authority, suffix] ->
        prefix <> normalize_uri_authority_port(authority) <> suffix

      _other ->
        value
    end
  end

  defp normalize_uri_authority_port(authority) do
    case String.split(authority, "@") do
      [host_port] ->
        normalize_uri_host_port(host_port)

      [userinfo, host_port] ->
        userinfo <> "@" <> normalize_uri_host_port(host_port)

      _other ->
        authority
    end
  end

  defp normalize_uri_host_port(<<"[", rest::binary>> = host_port) do
    case :binary.match(rest, "]") do
      {offset, 1} ->
        suffix = binary_part(rest, offset + 1, byte_size(rest) - offset - 1)

        if Regex.match?(@long_uri_port_regex, suffix),
          do: binary_part(host_port, 0, offset + 2) <> ":0",
          else: host_port

      :nomatch ->
        host_port
    end
  end

  defp normalize_uri_host_port(host_port) do
    case String.split(host_port, ":", parts: 2) do
      [host, port] ->
        if Regex.match?(@long_uri_port_regex, ":" <> port),
          do: host <> ":0",
          else: host_port

      _other ->
        host_port
    end
  end

  defp uri_authority_parts(value) do
    case Regex.run(~r/\A([A-Za-z][A-Za-z0-9+.-]*:\/\/)([^\/?#]*)(.*)\z/s, value) do
      [_, prefix, authority, suffix] -> [prefix, authority, suffix]
      _other -> :error
    end
  end

  defp split_uri_ip_literal_authority(authority) do
    case String.split(authority, "@") do
      [host_port] -> split_uri_ip_literal_host_port("", host_port)
      [userinfo, host_port] -> split_uri_ip_literal_host_port(userinfo <> "@", host_port)
      _other -> :error
    end
  end

  defp split_uri_ip_literal_host_port(_userinfo, ""), do: :error

  defp split_uri_ip_literal_host_port(userinfo, <<"[", rest::binary>>) do
    case :binary.match(rest, "]") do
      {offset, 1} ->
        host = binary_part(rest, 0, offset)
        port_suffix = binary_part(rest, offset + 1, byte_size(rest) - offset - 1)

        if valid_ip_literal_port_suffix?(port_suffix),
          do: {:ok, userinfo, host, port_suffix},
          else: :error

      :nomatch ->
        :error
    end
  end

  defp split_uri_ip_literal_host_port(_userinfo, _host_port), do: :error

  defp valid_ip_literal_port_suffix?(""), do: true
  defp valid_ip_literal_port_suffix?(<<":", _port::binary>>), do: true
  defp valid_ip_literal_port_suffix?(_port_suffix), do: false

  defp valid_uri_ip_literal?(host) do
    if Regex.match?(~r/\A[vV][0-9a-fA-F]+\.[A-Za-z0-9._~!$&'()*+,;=:-]+\z/, host) do
      true
    else
      case String.split(host, "%25", parts: 2) do
        [address] -> ipv6?(address)
        [address, zone] -> ipv6?(address) and valid_uri_zone_id?(zone)
      end
    end
  end

  defp valid_uri_zone_id?(zone) do
    Regex.match?(~r/\A(?:[A-Za-z0-9._~-]|%[0-9a-fA-F]{2})+\z/, zone) and
      valid_percent_encoded_utf8?(zone)
  end

  defp valid_percent_encoded_utf8?(value) do
    value |> URI.decode() |> String.valid?()
  end

  defp ipv6_literal?(value) when is_binary(value) do
    case String.split(value, "%", parts: 2) do
      [address] ->
        ipv6?(address)

      [address, zone] ->
        ipv6?(address) and byte_size(zone) > 0 and :binary.match(zone, <<0>>) == :nomatch
    end
  end

  defp ip_family?(tuple, 0), do: tuple_size(tuple) in [4, 8]
  defp ip_family?(tuple, 4), do: tuple_size(tuple) == 4
  defp ip_family?(tuple, 6), do: tuple_size(tuple) == 8
  defp ip_family?(_tuple, _version), do: false

  defp network_address?(tuple, prefix_length) do
    bits = ip_bit_size(tuple)
    radix = if tuple_size(tuple) == 4, do: 256, else: 65_536
    address = tuple |> Tuple.to_list() |> Enum.reduce(0, &(&2 * radix + &1))
    rem(address, 1 <<< (bits - prefix_length)) == 0
  end

  defp ip_bit_size(tuple) when tuple_size(tuple) == 4, do: 32
  defp ip_bit_size(tuple), do: tuple_size(tuple) * 16

  defp valid_uri_characters?(value),
    do: not Regex.match?(~r/[\x00-\x20\x7f]|%(?![0-9a-fA-F]{2})/, value)
end
