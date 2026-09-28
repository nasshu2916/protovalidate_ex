defmodule Protovalidate.P0RegressionTest do
  use ExUnit.Case, async: true

  alias Buf.Validate.{FieldRules, MessageOneofRule, MessageRules}

  alias Google.Protobuf.{
    Any,
    DescriptorProto,
    FieldDescriptorProto,
    FieldOptions,
    FileDescriptorProto,
    FileDescriptorSet,
    MessageOptions
  }

  alias Protovalidate.{CompilationError, UnsupportedRuleError, ValidationError}
  alias Protovalidate.Conformance.{RuntimeDescriptorAdapter, ViolationCodec}

  test "wire の NaN・無限大を公開 API で数値として判定する" do
    for {type, kind, module} <- [
          {:TYPE_FLOAT, :float, Buf.Validate.FloatRules},
          {:TYPE_DOUBLE, :double, Buf.Validate.DoubleRules}
        ] do
      for value <- [:nan, :infinity, :negative_infinity, 0.0, 1.0] do
        message = scalar(type, %FieldRules{type: {kind, struct!(module, finite: true)}}, value)
        assert valid?(message) == is_number(value)
      end

      for {rule, limit, value, valid} <- [
            {:lt, 0.0, :negative_infinity, true},
            {:lt, 0.0, :infinity, false},
            {:gt, 0.0, :infinity, true},
            {:gt, 0.0, :negative_infinity, false},
            {:lte, :infinity, :infinity, true},
            {:gte, :negative_infinity, :negative_infinity, true},
            {:lt, 0.0, :nan, false},
            {:gte, 0.0, :nan, false},
            {:const, :nan, :nan, false},
            {:const, :infinity, :infinity, true},
            {:in, [:nan], :nan, false},
            {:not_in, [:nan], :nan, true},
            {:in, [:negative_infinity], :negative_infinity, true}
          ] do
        rules =
          case rule do
            key when key in [:lt, :lte] -> struct!(module, less_than: {key, limit})
            key when key in [:gt, :gte] -> struct!(module, greater_than: {key, limit})
            key -> struct!(module, [{key, limit}])
          end

        assert valid?(scalar(type, %FieldRules{type: {kind, rules}}, value)) == valid
      end
    end
  end

  test "文字列は code point、bytes は任意バイナリのバイト数を数える" do
    for {type, kind, module, value, size} <- [
          {:TYPE_STRING, :string, Buf.Validate.StringRules, "", 0},
          {:TYPE_STRING, :string, Buf.Validate.StringRules, "é", 1},
          {:TYPE_STRING, :string, Buf.Validate.StringRules, "e\u0301", 2},
          {:TYPE_STRING, :string, Buf.Validate.StringRules,
           "\u{1F468}\u200D\u{1F469}\u200D\u{1F467}", 5},
          {:TYPE_BYTES, :bytes, Buf.Validate.BytesRules, "", 0},
          {:TYPE_BYTES, :bytes, Buf.Validate.BytesRules, "é", 2},
          {:TYPE_BYTES, :bytes, Buf.Validate.BytesRules, <<255, 0>>, 2}
        ],
        rule <- [:len, :min_len, :max_len] do
      assert valid?(
               scalar(type, %FieldRules{type: {kind, struct!(module, [{rule, size}])}}, value)
             )

      invalid_size = if rule == :max_len, do: max(size - 1, 0), else: size + 1

      unless rule == :max_len and size == 0 do
        message =
          scalar(type, %FieldRules{type: {kind, struct!(module, [{rule, invalid_size}])}}, value)

        assert {:error, %ValidationError{violations: [violation]}} =
                 Protovalidate.validate(message)

        assert violation.rule_id == "#{kind}.#{rule}"
      end
    end
  end

  test "message oneof の 0・1・2 field と暗黙 ignore・明示 override" do
    fields =
      for {name, number} <- [{"a", 1}, {"b", 2}],
          do:
            field(name, number, :TYPE_STRING, %FieldRules{
              type: {:string, %Buf.Validate.StringRules{min_len: 2}}
            })

    for required <- [false, true],
        fail_fast <- [false, true],
        {values, expected} <- [
          {%{}, not required},
          {%{a: "ok"}, true},
          {%{a: "ok", b: "ok"}, false}
        ] do
      rules = %MessageRules{oneof: [%MessageOneofRule{fields: ["a", "b"], required: required}]}
      message = decode(fields, values, rules)
      assert valid?(message, fail_fast: fail_fast) == expected

      if map_size(values) == 2 do
        assert {:error, %ValidationError{violations: [violation]}} =
                 Protovalidate.validate(message)

        assert violation.rule_id == "message.oneof"

        assert [%{rule: nil, field: nil}] =
                 ViolationCodec.encode([violation], message.__struct__).violations
      end
    end

    override =
      field("a", 1, :TYPE_STRING, %FieldRules{
        ignore: :IGNORE_UNSPECIFIED,
        type: {:string, %Buf.Validate.StringRules{min_len: 2}}
      })

    assert not valid?(
             decode([override], %{}, %MessageRules{oneof: [%MessageOneofRule{fields: ["a"]}]})
           )
  end

  test "message oneof の未定義 field・重複・空リストを拒否する" do
    for names <- [["missing"], ["a", "a"], []] do
      message =
        decode([field("a", 1, :TYPE_STRING, nil)], %{}, %MessageRules{
          oneof: [%MessageOneofRule{fields: names}]
        })

      assert {:error, %CompilationError{}} = Protovalidate.validate(message)
    end
  end

  test "未知の検証 wire field と extension を拒否し入力の未知 field は許容する" do
    for rules <- [
          %FieldRules{__unknown_fields__: [{999, 0, 1}]},
          %FieldRules{ignore: :IGNORE_ALWAYS, __unknown_fields__: [{999, 0, 1}]},
          %FieldRules{
            type: {:string, %Buf.Validate.StringRules{__unknown_fields__: [{999, 0, 1}]}}
          },
          %FieldRules{
            type: {:string, %Buf.Validate.StringRules{__unknown_fields__: [{1000, 0, 1}]}}
          }
        ] do
      assert {:error, %UnsupportedRuleError{}} =
               Protovalidate.validate(scalar(:TYPE_STRING, rules, "ok"))
    end

    message = decode([], %{}, %MessageRules{__unknown_fields__: [{999, 0, 1}]})
    assert {:error, %UnsupportedRuleError{}} = Protovalidate.validate(message)
    message = scalar(:TYPE_STRING, nil, "ok")
    assert valid?(%{message | __unknown_fields__: [{999, 0, 1}]})
  end

  test "optional 未設定は ZERO_VALUE でも skip し設定済みゼロは評価する" do
    rules = %FieldRules{
      ignore: :IGNORE_IF_ZERO_VALUE,
      type: {:string, %Buf.Validate.StringRules{min_len: 1}}
    }

    descriptor = %{field("a", 1, :TYPE_STRING, rules) | proto3_optional: true, oneof_index: 0}

    for fail_fast <- [false, true] do
      assert valid?(decode([descriptor], %{}, nil, true), fail_fast: fail_fast)
      assert not valid?(decode([descriptor], %{a: ""}, nil, true), fail_fast: fail_fast)
      required = %{descriptor | options: options(%{rules | required: true})}
      message = decode([required], %{}, nil, true)

      assert {:error, %ValidationError{violations: [%{rule_id: "required"}]}} =
               Protovalidate.validate(message, fail_fast: fail_fast)
    end
  end

  test "required 失敗後は field 評価を停止し items の ignore を適用する" do
    for fail_fast <- [false, true] do
      message =
        scalar(
          :TYPE_STRING,
          %FieldRules{required: true, type: {:string, %Buf.Validate.StringRules{min_len: 2}}},
          ""
        )

      assert {:error, %ValidationError{violations: [%{rule_id: "required"}]}} =
               Protovalidate.validate(message, fail_fast: fail_fast)

      for {ignore, values} <- [{:IGNORE_ALWAYS, ["x", ""]}, {:IGNORE_IF_ZERO_VALUE, ["", "ok"]}] do
        item = %FieldRules{ignore: ignore, type: {:string, %Buf.Validate.StringRules{min_len: 2}}}

        descriptor = %{
          field("a", 1, :TYPE_STRING, %FieldRules{
            type: {:repeated, %Buf.Validate.RepeatedRules{items: item}}
          })
          | label: :LABEL_REPEATED
        }

        assert valid?(decode([descriptor], %{a: values}), fail_fast: fail_fast)
      end
    end
  end

  test "collection の keys・values の ignore と required を独立に適用する" do
    alias Acme.Descriptor.V1.Probe
    alias Protovalidate.{DescriptorAdapter, Plan}
    descriptor = DescriptorAdapter.describe(Probe)
    source = Enum.find(descriptor.fields, &(&1.name == "scores"))

    for fail_fast <- [false, true], kind <- [:keys, :values] do
      type = if kind == :keys, do: {:string, %{min_len: 2}}, else: {:uint32, %{gt: 0}}

      for ignore <- [:IGNORE_ALWAYS, :IGNORE_IF_ZERO_VALUE] do
        rules = %{type: {:map, %{kind => %{ignore: ignore, type: type}}}}
        field = %{source | validation: %{field: rules}}
        plan = Plan.compile(%{descriptor | fields: [field], oneofs: []}, [])
        assert {:ok, []} = Plan.evaluate(plan, %Probe{scores: %{"" => 0}}, fail_fast: fail_fast)
      end

      rules = %{type: {:map, %{kind => %{required: true, type: type}}}}
      field = %{source | validation: %{field: rules}}
      plan = Plan.compile(%{descriptor | fields: [field], oneofs: []}, [])

      # collection 要素は実在するため、ゼロ値でも required を満たす。
      assert {:ok, [%{rule_id: rule_id, for_key: for_key}]} =
               Plan.evaluate(plan, %Probe{scores: %{"" => 0}}, fail_fast: fail_fast)

      assert rule_id == if(kind == :keys, do: "string.min_len", else: "uint32.gt")
      assert for_key == (kind == :keys)
    end
  end

  test "collection の ignore は子 message の再帰も止め、通常時は一度だけ評価する" do
    alias Acme.Descriptor.V1.{Child, Probe}
    alias Protovalidate.{DescriptorAdapter, Plan}
    descriptor = DescriptorAdapter.describe(Probe)

    for fail_fast <- [false, true],
        {name, kind, type, value} <- [
          {"children", :items, :repeated, [%Child{code: "x"}]},
          {"children_by_name", :values, :map, %{"a" => %Child{code: "x"}}}
        ],
        ignore <- [:IGNORE_ALWAYS, :IGNORE_IF_ZERO_VALUE] do
      source = Enum.find(descriptor.fields, &(&1.name == name))
      field = %{source | validation: %{field: %{type: {type, %{kind => %{ignore: ignore}}}}}}
      plan = Plan.compile(%{descriptor | fields: [field], oneofs: []}, [])

      assert {:ok, violations} =
               Plan.evaluate(plan, struct!(Probe, [{String.to_existing_atom(name), value}]),
                 fail_fast: fail_fast
               )

      assert length(violations) == if(ignore == :IGNORE_ALWAYS, do: 0, else: 1)
      assert Enum.all?(violations, &(&1.rule_path == ["string", "min_len"]))
    end
  end

  test "wrapper の未設定・設定済みゼロ・required・ignore を区別する" do
    alias Acme.Descriptor.V1.Probe
    alias Protovalidate.{DescriptorAdapter, Plan}
    descriptor = DescriptorAdapter.describe(Probe)

    source = %{
      Enum.find(descriptor.fields, &(&1.name == "child"))
      | well_known_type: {:wrapper, :TYPE_STRING},
        reference: Google.Protobuf.StringValue
    }

    for fail_fast <- [false, true] do
      rules = %{ignore: :IGNORE_IF_ZERO_VALUE, type: {:string, %{min_len: 1}}}
      field = %{source | validation: %{field: rules}}
      plan = Plan.compile(%{descriptor | fields: [field], oneofs: []}, [])
      assert {:ok, []} = Plan.evaluate(plan, %Probe{}, fail_fast: fail_fast)

      message =
        struct!(Probe, [{String.to_existing_atom(source.name), %Google.Protobuf.StringValue{}}])

      assert {:ok, [%{rule_id: "string.min_len"}]} =
               Plan.evaluate(plan, message, fail_fast: fail_fast)

      field = %{
        field
        | validation: %{field: %{rules | ignore: :IGNORE_ALWAYS} |> Map.put(:required, true)}
      }

      plan = Plan.compile(%{descriptor | fields: [field], oneofs: []}, [])
      assert {:ok, []} = Plan.evaluate(plan, message, fail_fast: fail_fast)
      assert {:ok, []} = Plan.evaluate(plan, %Probe{}, fail_fast: fail_fast)
    end
  end

  test "oneof と message oneof の未知 wire 設定と未知 extension を拒否する" do
    alias Protovalidate.{DescriptorAdapter, Plan}
    descriptor = DescriptorAdapter.describe(Acme.Descriptor.V1.Probe)
    [oneof | _] = descriptor.oneofs

    for metadata <- [%{__unknown_fields__: [{999, 0, 1}]}, %{__pb_extensions__: %{1000 => true}}] do
      assert_raise UnsupportedRuleError, fn ->
        Plan.compile(
          %{descriptor | fields: [], oneofs: [%{oneof | validation: %{oneof: metadata}}]},
          []
        )
      end

      assert_raise UnsupportedRuleError, fn ->
        Plan.compile(%{descriptor | fields: [], oneofs: [], validation: %{message: metadata}}, [])
      end

      assert_raise UnsupportedRuleError, fn ->
        Protovalidate.TestRules.plan(Protovalidate.TestRules.field(:TYPE_STRING), metadata)
      end
    end

    message =
      decode([field("a", 1, :TYPE_STRING, nil)], %{}, %MessageRules{
        oneof: [%MessageOneofRule{fields: ["a"], __unknown_fields__: [{999, 0, 1}]}]
      })

    assert {:error, %UnsupportedRuleError{}} = Protovalidate.validate(message)
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

  defp decode(fields, values, rules \\ nil, optional \\ false) do
    options =
      if rules,
        do:
          MessageOptions.put_extension(
            %MessageOptions{},
            Buf.Validate.PbExtension,
            :message,
            rules
          )

    descriptor = %DescriptorProto{
      name: "Input",
      field: fields,
      options: options,
      oneof_decl: if(optional, do: [%Google.Protobuf.OneofDescriptorProto{name: "_a"}], else: [])
    }

    fdset = %FileDescriptorSet{
      file: [
        %FileDescriptorProto{
          name: "p0.proto",
          package: "p0",
          syntax: "proto3",
          message_type: [descriptor]
        }
      ]
    }

    fdset = fdset |> FileDescriptorSet.encode() |> FileDescriptorSet.decode()

    message =
      RuntimeDescriptorAdapter.decode(fdset, %Any{
        type_url: "type.googleapis.com/p0.Input",
        value: <<>>
      })

    message = struct!(message, values)
    message.__struct__.decode(message.__struct__.encode(message))
  end
end
