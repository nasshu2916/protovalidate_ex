defmodule Protovalidate.Rules.StringTest do
  use ExUnit.Case, async: true

  import Protovalidate.TestRules

  alias Protovalidate.Rules.String, as: StringRules
  alias Protovalidate.Rules.String.Format

  test "生成ルールの oneof 正規化と未知ルールの拒否を維持する" do
    assert [:uuid] =
             StringRules.string_rules(%Buf.Validate.StringRules{well_known: {:uuid, true}})

    error =
      assert_raise Protovalidate.UnsupportedRuleError, fn ->
        StringRules.string_rules(%{unknown: false})
      end

    assert error.rule_path == ["string", "unknown"]

    assert {:cont, %{violations: [violation]}} =
             StringRules.evaluate(:uuid, "invalid", field(:TYPE_STRING), context())

    assert violation.rule_id == "string.uuid"
    assert violation.message == "value must be a UUID"
  end

  test "文字列フォーマット規則は有効な値を受け入れ、不正な値を違反にする" do
    field = field(:TYPE_STRING)

    for {rule, valid, invalid} <- [
          {:uuid, "123e4567-e89b-12d3-a456-426614174000", "invalid"},
          {:email, "ada@example.com", "invalid"},
          {:hostname, "api.example.com", "-invalid"},
          {:ip, "127.0.0.1", "invalid"},
          {:ipv4, "127.0.0.1", "invalid"},
          {:ipv6, "2001:db8::1", "invalid"},
          {:uri, "https://example.com/path", "invalid"},
          {:uri_ref, "/relative/path", "bad value"},
          {:address, "api.example.com", "-invalid"},
          {:tuuid, "123e4567e89b12d3a456426614174000", "invalid"},
          {:ip_with_prefixlen, "192.168.0.1/24", "invalid"},
          {:ipv4_with_prefixlen, "192.168.0.1/24", "invalid"},
          {:ipv6_with_prefixlen, "2001:db8::1/64", "invalid"},
          {:ip_prefix, "192.168.0.0/24", "192.168.0.1/24"},
          {:ipv4_prefix, "192.168.0.0/24", "192.168.0.1/24"},
          {:ipv6_prefix, "2001:db8::/32", "2001:db8::1/32"},
          {:host_and_port, "[2001:db8::1]:443", "invalid"},
          {:ulid, "01ARZ3NDEKTSV4RRFFQ69G5FAV", "invalid"},
          {:protobuf_fqn, "acme.v1.Message", "invalid-name"},
          {:protobuf_dot_fqn, ".acme.v1.Message", "invalid"}
        ] do
      assert {:cont, %{violations: []}} = StringRules.evaluate(rule, valid, field, context())

      assert {:cont, %{violations: [violation]}} =
               StringRules.evaluate(rule, invalid, field, context())

      assert violation.rule_id == "string.#{rule}"
    end

    assert {:cont, %{violations: []}} =
             StringRules.evaluate(:host_and_port, "example.com:443", field, context())

    assert {:cont, %{violations: [violation]}} =
             StringRules.evaluate(:host_and_port, "example.com", field, context())

    assert violation.rule_id == "string.host_and_port"
  end

  test "形式判定の境界を固定する" do
    assert Format.email?("a@example.com")
    refute Format.email?("")
    refute Format.email?("ü@example.com")
    refute Format.email?("a@例.example")

    assert Format.ip_prefix?("192.168.0.1/24", 4, false)
    refute Format.ip_prefix?("192.168.0.1/24", 4, true)
    assert Format.ip_prefix?("192.168.0.1/24")
    assert Format.ip_prefix?("0.0.0.0/0", 4, true)
    refute Format.ip_prefix?("192.168.0.1/0", 4, true)
    assert Format.ip_prefix?("192.168.0.1/32", 4, true)
    assert Format.ip_prefix?("2001:db8::1/128", 6, true)
    assert Format.ip_prefix?("2001:db8::192.0.2.1/112", 6, false)
    refute Format.ip_prefix?("2001:db8::192.0.2.1/112", 6, true)

    for value <- [
          "192.168.0.0/",
          "192.168.0.0/-1",
          "192.168.0.0/+24",
          "192.168.0.0/024",
          "192.168.0.0/33",
          "2001:db8::/129",
          "192.168.0.0/24/extra"
        ] do
      refute Format.ip_prefix?(value, 0, false)
    end

    assert Format.host_and_port?("[2001:db8::1]", true)
    assert Format.host_and_port?("example.com", true)
    refute Format.host_and_port?("example.com", false)
    assert Format.host_and_port?("example.com.:443")
    assert Format.host_and_port?("example.com.", true)
    assert Format.host_and_port?("192.168.0.1", true)
    assert Format.host_and_port?("[fe80::1%eth0]:443")
    assert Format.host_and_port?("[fe80::1%/zone]:443")
    assert Format.host_and_port?("[::0%00]]", true)
    refute Format.host_and_port?("[fe80::1%]:443")

    for value <- [
          "example.com:00",
          "example.com:01",
          "example.com:+1",
          "example.com:65536"
        ] do
      refute Format.host_and_port?(value)
    end

    assert Format.uri?("https://example.com/%20")
    refute Format.uri?("https://example.com/%xx")
    assert Format.uri_ref?("")
    refute Format.uri_ref?("path with spaces")
  end

  test "hostname の末尾数字 label と IPv6 zone ID を判定する" do
    assert Format.hostname?("123.api.example")
    assert Format.hostname?("api.example.com.")
    refute Format.hostname?("api.example.123")
    refute Format.hostname?("api.example.123.")
    refute Format.hostname?("123")

    assert Format.hostname?(String.duplicate("a", 63) <> ".example")
    refute Format.hostname?(String.duplicate("a", 64) <> ".example")

    assert Format.ip?("192.168.1.1")
    assert Format.ip?("fe80::1%en1")
    assert Format.ip?("fe80::1%/zone")
    refute Format.ip?("fe80::1%")
    refute Format.ip?("fe80::gg%en1")
    refute Format.ip?("192.168.1.1%en1")
    refute Format.ip?("fe80::1%en1", 4)
    assert Format.ip?("fe80::1", 6)
    refute Format.ip?("fe80::1", 4)
  end

  test "メールの local part の空セグメントと domain の末尾ドットを扱う" do
    assert Format.email?(".@example.com")
    assert Format.email?("...@example.com")

    exhaust_atext =
      "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!#$%&'*+-/=?^_`{|}~"

    assert byte_size(exhaust_atext) > 64
    assert Format.email?(exhaust_atext <> "@example.com")

    refute Format.email?("foo@example.com.")
    refute Format.email?("foo@example.com..")
  end

  test "URI host percent encoding, IPvFuture, and IPv6 zone IDs follow the harness cases" do
    assert Format.uri?("https://foo%61%20%23")
    assert Format.uri?("https://foo%c3%96")
    refute Format.uri?("https://foo%c3x%96")

    for value <- [
          "https://[v1.x]",
          "https://[v1234AF.x]",
          "https://[vF.-!$&'()*+,;=._~0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]",
          "https://[::1%25eth0]",
          "https://[::1%25foo%61%20%23]",
          "https://[::1%25foo%c3%96]"
        ] do
      assert Format.uri?(value), "expected URI to be valid: #{value}"
    end

    for value <- [
          "https://[v1x]",
          "https://[::1%25foo%c3x%96]",
          "https://[::1%25]",
          "https://[::1%eth0]",
          "https://[::1%25foo%]",
          "https://[::1%25foo%2x]"
        ] do
      refute Format.uri?(value), "expected URI to be invalid: #{value}"
    end
  end

  test "長さ、文字列照合、既知 HTTP ヘッダー正規表現を評価する" do
    field = field(:TYPE_STRING)

    for {rule, value, id} <- [
          {{:len, 2}, "a", "string.len"},
          {{:min_len, 2}, "a", "string.min_len"},
          {{:max_len, 1}, "ab", "string.max_len"},
          {{:len_bytes, 2}, "a", "string.len_bytes"},
          {{:min_bytes, 2}, "a", "string.min_bytes"},
          {{:max_bytes, 1}, "ab", "string.max_bytes"},
          {{:prefix, "pre"}, "value", "string.prefix"},
          {{:suffix, "end"}, "value", "string.suffix"},
          {{:contains, "needle"}, "value", "string.contains"},
          {{:not_contains, "bad"}, "bad value", "string.not_contains"},
          {{:pattern, ~r/^ok$/}, "no", "string.pattern"}
        ] do
      assert {:cont, %{violations: [violation]}} =
               StringRules.evaluate(rule, value, field, context())

      assert violation.rule_id == id
    end

    assert {:cont, %{violations: []}} =
             StringRules.evaluate(
               {:well_known_regex, {1, true}},
               "X-Request-ID",
               field,
               context()
             )

    assert {:cont, %{violations: [violation]}} =
             StringRules.evaluate({:well_known_regex, {1, false}}, "", field, context())

    assert violation.rule_id == "string.well_known_regex.header_name_empty"
  end

  test "文字列以外の値と既知正規表現のコンパイルエラーを扱う" do
    field = field(:TYPE_STRING)

    for rule <- [
          :uuid,
          :email,
          :hostname,
          :ip,
          :ipv4,
          :ipv6,
          :uri,
          :uri_ref,
          :tuuid,
          :host_and_port,
          :ulid,
          :protobuf_fqn,
          :protobuf_dot_fqn
        ] do
      assert {:cont, %{violations: [_]}} = StringRules.evaluate(rule, nil, field, context())
    end

    assert [{:well_known_regex, {1, true}}] = StringRules.string_rules(%{well_known_regex: 1})

    assert [{:well_known_regex, {2, false}}] =
             StringRules.string_rules(%{well_known_regex: 2, strict: false})

    error =
      assert_raise Protovalidate.CompilationError, fn ->
        StringRules.string_rules(%{well_known_regex: :UNKNOWN})
      end

    assert error.rule_path == ["string", "well_known_regex"]
  end
end
