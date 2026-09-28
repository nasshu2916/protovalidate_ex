defmodule Protovalidate.P1RegressionTest do
  use ExUnit.Case, async: true

  alias Buf.Validate.FieldRules

  alias Google.Protobuf.{
    Any,
    DescriptorProto,
    FieldDescriptorProto,
    FieldOptions,
    FileDescriptorProto,
    FileDescriptorSet
  }

  alias Protovalidate.{CompilationError, ValidationError}
  alias Protovalidate.Conformance.{RuntimeDescriptorAdapter, ViolationCodec}

  test "整数と float の複合範囲を wire decode と公開 API で検証する" do
    for {type, kind, module} <- [
          {:TYPE_INT64, :int64, Buf.Validate.Int64Rules},
          {:TYPE_UINT64, :uint64, Buf.Validate.UInt64Rules},
          {:TYPE_DOUBLE, :double, Buf.Validate.DoubleRules}
        ],
        lower <- [:gt, :gte],
        upper <- [:lt, :lte],
        {low, high} <- [{5, 10}, {10, 5}, {5, 5}],
        value <- [0, 5, 7, 10, 12],
        fail_fast <- [false, true] do
      rules = struct!(module, greater_than: {lower, low}, less_than: {upper, high})
      message = scalar(type, %FieldRules{type: {kind, rules}}, value)
      above = if lower == :gt, do: value > low, else: value >= low
      below = if upper == :lt, do: value < high, else: value <= high
      expected = if low > high, do: above or below, else: above and below
      assert valid?(message, fail_fast: fail_fast) == expected

      unless expected do
        assert {:error, %ValidationError{violations: [violation]}} =
                 Protovalidate.validate(message, fail_fast: fail_fast)

        assert violation.rule_id ==
                 "#{kind}.#{lower}_#{upper}" <> if(low > high, do: "_exclusive", else: "")

        assert %Buf.Validate.Violations{violations: [%{rule: %{elements: [_, source]}}]} =
                 ViolationCodec.encode([violation], message.__struct__)

        assert source.field_name == Atom.to_string(lower)
      end
    end
  end

  test "64 bit 整数の端点を精度を落とさず比較する" do
    for {type, kind, module, limit} <- [
          {:TYPE_INT64, :int64, Buf.Validate.Int64Rules, 9_223_372_036_854_775_807},
          {:TYPE_UINT64, :uint64, Buf.Validate.UInt64Rules, 18_446_744_073_709_551_615}
        ] do
      rules = struct!(module, greater_than: {:gte, limit}, less_than: {:lte, limit})
      assert valid?(scalar(type, %FieldRules{type: {kind, rules}}, limit))
      refute valid?(scalar(type, %FieldRules{type: {kind, rules}}, limit - 1))
    end
  end

  test "NaN は通常範囲と逆転範囲のいずれにも含まれない" do
    for {low, high} <- [{0.0, 10.0}, {10.0, 0.0}] do
      rules = %Buf.Validate.DoubleRules{greater_than: {:gt, low}, less_than: {:lt, high}}
      refute valid?(scalar(:TYPE_DOUBLE, %FieldRules{type: {:double, rules}}, :nan))
    end
  end

  test "UUID・緩和 header・任意 bytes pattern を公開 API で評価する" do
    assert valid?(
             scalar(
               :TYPE_STRING,
               %FieldRules{type: {:string, %Buf.Validate.StringRules{well_known: {:uuid, true}}}},
               "00000000-0000-0000-0000-000000000000"
             )
           )

    for {regex, value} <- [
          {:KNOWN_REGEX_HTTP_HEADER_NAME, "FOO BAR"},
          {:KNOWN_REGEX_HTTP_HEADER_VALUE, <<7>>}
        ] do
      for strict <- [true, false] do
        rules = %Buf.Validate.StringRules{well_known: {:well_known_regex, regex}, strict: strict}

        assert valid?(scalar(:TYPE_STRING, %FieldRules{type: {:string, rules}}, value)) ==
                 not strict
      end
    end

    assert {:error, %Protovalidate.RuntimeError{}} =
             Protovalidate.validate(
               scalar(
                 :TYPE_BYTES,
                 %FieldRules{type: {:bytes, %Buf.Validate.BytesRules{pattern: "^.$"}}},
                 <<255>>
               )
             )

    assert valid?(
             scalar(
               :TYPE_BYTES,
               %FieldRules{type: {:bytes, %Buf.Validate.BytesRules{pattern: "^.$"}}},
               "é"
             )
           )

    message =
      scalar(:TYPE_BYTES, %FieldRules{type: {:bytes, %Buf.Validate.BytesRules{pattern: "["}}}, "")

    assert {:error, %CompilationError{}} = Protovalidate.validate(message)
  end

  test "無効な validator 設定を初期化時に拒否する" do
    for options <- [
          [regex_matcher: Regex],
          [legacy_required: :yes],
          [fail_fast: nil],
          [registry: 1],
          [:bad]
        ] do
      assert_raise ArgumentError, fn -> Protovalidate.new(options) end
    end

    assert_raise ArgumentError, fn ->
      Protovalidate.new(cel: {Protovalidate.TestCEL, timeout: 0})
    end
  end

  defp valid?(message, options \\ []),
    do: match?({:ok, _}, Protovalidate.validate(message, options))

  defp scalar(type, rules, value), do: decode([field("a", 1, type, rules)], %{a: value})

  defp field(name, number, type, rules),
    do: %FieldDescriptorProto{
      name: name,
      json_name: name,
      number: number,
      type: type,
      label: :LABEL_OPTIONAL,
      options: options(rules)
    }

  defp options(nil), do: nil

  defp options(rules),
    do: FieldOptions.put_extension(%FieldOptions{}, Buf.Validate.PbExtension, :field, rules)

  defp decode(fields, values) do
    descriptor = %DescriptorProto{
      name: "Input",
      field: fields,
      options: nil
    }

    fdset = %FileDescriptorSet{
      file: [
        %FileDescriptorProto{
          name: "p1.proto",
          package: "p1",
          syntax: "proto3",
          message_type: [descriptor]
        }
      ]
    }

    fdset = fdset |> FileDescriptorSet.encode() |> FileDescriptorSet.decode()

    message =
      RuntimeDescriptorAdapter.decode(fdset, %Any{
        type_url: "type.googleapis.com/p1.Input",
        value: <<>>
      })

    message = struct!(message, values)
    message.__struct__.decode(message.__struct__.encode(message))
  end
end
