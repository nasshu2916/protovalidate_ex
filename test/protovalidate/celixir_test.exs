defmodule Protovalidate.CelixirTest do
  use ExUnit.Case, async: true

  import Protovalidate.TestRules

  alias Celixir.AST
  alias Protovalidate.CEL.{CelixirTypes, CelixirVariables}
  alias Protovalidate.{CompilationError, Plan, ValidationError}
  alias Protovalidate.DescriptorAdapter

  test "実エンジンで scalar と文字列違反を評価する" do
    compiled =
      plan(field(:TYPE_STRING), %{cel_expression: ["this.size() >= 3 ? '' : 'too short'"]},
        cel: Protovalidate.CEL.Celixir
      )

    assert {:ok, []} =
             Plan.evaluate(compiled, %Acme.Descriptor.V1.Probe{implicit_string: "abc"},
               fail_fast: false
             )

    assert {:ok, [%{message: "too short", rule_id: "this.size() >= 3 ? '' : 'too short'"}]} =
             Plan.evaluate(compiled, %Acme.Descriptor.V1.Probe{implicit_string: "a"},
               fail_fast: false
             )
  end

  test "標準文字列ルールと CEL library 関数が同じ形式判定を使う" do
    field = field(:TYPE_STRING)

    for {rule, expression, valid, invalid} <- [
          {:email, "this.isEmail()", "ada@example.com", "ada@-example.com"},
          {:hostname, "this.isHostname()", "api.example.com", "-example.com"},
          {:host_and_port, "this.isHostAndPort()", "example.com:443", "example.com"},
          {:ip, "this.isIp()", "2001:db8::1", "2001:db8::gg"},
          {:ip_prefix, "this.isIpPrefix(true)", "192.168.0.0/24", "192.168.0.1/24"},
          {:uri, "this.isUri()", "https://example.com/path", "not a uri"},
          {:uri_ref, "this.isUriRef()", "/relative/path", "bad value"}
        ] do
      compiled = plan(field, %{cel_expression: [expression]}, cel: Protovalidate.CEL.Celixir)

      for {value, valid?} <- [{valid, true}, {invalid, false}] do
        {:cont, standard_context} =
          Protovalidate.Rules.String.evaluate(rule, value, field, context())

        {:ok, cel_violations} =
          Plan.evaluate(compiled, %Acme.Descriptor.V1.Probe{implicit_string: value},
            fail_fast: false
          )

        assert standard_context.violations == [] == valid?
        assert cel_violations == [] == valid?
      end
    end
  end

  test "CEL library の省略可能引数を評価する" do
    for {expression, value, valid?} <- [
          {"this.isHostAndPort(true)", "example.com:443", true},
          {"this.isHostAndPort(true)", "example.com", false},
          {"this.isHostAndPort(false)", "example.com", true},
          {"this.isHostAndPort(false)", "192.168.0.1", true},
          {"this.isHostAndPort(false)", "[fe80::1%eth0]", true},
          {"this.isIp(4)", "127.0.0.1", true},
          {"this.isIp(6)", "127.0.0.1", false},
          {"this.isIpPrefix(4, false)", "192.168.0.1/24", true},
          {"this.isIpPrefix(4, true)", "192.168.0.1/24", false},
          {"this.isIpPrefix()", "192.168.0.1/24", true},
          {"this.isIpPrefix(4)", "192.168.0.1/24", true},
          {"this.isIpPrefix(false)", "192.168.0.1/24", true},
          {"this.isIpPrefix(true)", "192.168.0.1/24", false},
          {"this.isIpPrefix(6, false)", "2001:db8::192.0.2.1/112", true},
          {"this.isIpPrefix(6, true)", "2001:db8::192.0.2.1/112", false}
        ] do
      compiled =
        plan(field(:TYPE_STRING), %{cel_expression: [expression]}, cel: Protovalidate.CEL.Celixir)

      assert {:ok, violations} =
               Plan.evaluate(compiled, %Acme.Descriptor.V1.Probe{implicit_string: value},
                 fail_fast: false
               )

      assert violations == [] == valid?
    end
  end

  test "descriptor 付き message の CEL を公開 API で評価する" do
    message = %Acme.User.V1.User{
      id: "00000000-0000-0000-0000-000000000000",
      email: "ada@example.com",
      first_name: "Ada"
    }

    assert {:error, %ValidationError{violations: [violation]}} =
             Protovalidate.validate(message, cel: Protovalidate.CEL.Celixir)

    assert violation.rule_id == "first_name_requires_last_name"
    wire = Protovalidate.Conformance.ViolationCodec.encode([violation], message.__struct__)

    assert [%{rule: nil, field: nil}] = wire.violations
    assert violation.rule_source.root == Buf.Validate.MessageRules
    assert violation.rule_source.segments == [field: "cel", index: 0]
  end

  test "cel オプション未指定時でもデフォルトで celixir により CEL が評価される" do
    message = %Acme.User.V1.User{
      id: "00000000-0000-0000-0000-000000000000",
      email: "ada@example.com",
      first_name: "Ada"
    }

    assert {:error, %ValidationError{violations: [violation]}} = Protovalidate.validate(message)
    assert violation.rule_id == "first_name_requires_last_name"
  end

  test "型エラーと bool/string 以外の式をコンパイル時に拒否する" do
    for expression <- ["this + 1", "42"] do
      assert_raise CompilationError, fn ->
        plan(field(:TYPE_STRING), %{cel_expression: [expression]}, cel: Protovalidate.CEL.Celixir)
      end
    end
  end

  test "未知の自由識別子をコンパイル時に拒否する" do
    for expression <- ["typo", "typo == 1", "typo ? true : false"] do
      assert_raise CompilationError, fn ->
        plan(field(:TYPE_STRING), %{cel_expression: [expression]}, cel: Protovalidate.CEL.Celixir)
      end
    end
  end

  test "comprehension の局所変数と shadowing を自由変数として扱わない" do
    for expression <- [
          "[1, 2].all(item, item > 0)",
          "[1, 2].all(item, [item].all(item, item > 0))",
          "[1, 2].all(this, this > 0)"
        ] do
      assert %{fields: [_]} =
               plan(field(:TYPE_STRING), %{cel_expression: [expression]},
                 cel: Protovalidate.CEL.Celixir
               )
    end

    assert_raise CompilationError, fn ->
      plan(field(:TYPE_STRING), %{cel_expression: ["[1].all(item, typo == item)"]},
        cel: Protovalidate.CEL.Celixir
      )
    end
  end

  test "now は timestamp として宣言される" do
    compiled =
      plan(field(:TYPE_STRING), %{cel_expression: ["now == now"]}, cel: Protovalidate.CEL.Celixir)

    assert {:ok, []} =
             Plan.evaluate(compiled, %Acme.Descriptor.V1.Probe{},
               fail_fast: false,
               now: %{seconds: 0, nanos: 0}
             )
  end

  test "型環境は field 名の代わりに親 FQN と descriptor を保持する" do
    compiled =
      plan(field(:TYPE_STRING), %{cel_expression: ["this != ''"]}, cel: Protovalidate.CEL.Celixir)

    [%Plan.FieldPlan{checks: [{:cel, cel}]}] = compiled.fields
    assert cel.message_type == "test.Probe"
    assert cel.type_environment.field.type == :TYPE_STRING
    assert cel.type_environment.message.full_name == "test.Probe"
  end

  test "自由変数検査は CEL AST の各コンテナと局所スコープを走査する" do
    this = %AST.Ident{name: "this"}
    literal = %AST.IntLit{value: 1}
    declared = MapSet.new(["this"])

    expressions = [
      %AST.UnaryOp{operand: this},
      %AST.BinaryOp{left: this, right: literal},
      %AST.Ternary{condition: this, true_expr: literal, false_expr: literal},
      %AST.CreateList{elements: [{:optional_list_elem, this}, literal]},
      %AST.CreateMap{entries: [{this, literal}, {:optional, this, literal}]},
      %AST.CreateStruct{
        type_name: "example.Input",
        entries: [{"value", this}, {:optional, "other", literal}]
      },
      %AST.Select{operand: this, field: "value"},
      %AST.OptSelect{operand: this, field: "value"},
      %AST.Index{operand: this, index: literal},
      %AST.OptIndex{operand: this, index: literal},
      %AST.Call{function: "abs", target: %AST.Ident{name: "math"}, args: [this]},
      %AST.Call{function: "method", target: this, args: [literal]},
      %AST.OptLambda{kind: :map, target: this, var: "item", expr: %AST.Ident{name: "item"}},
      %AST.CelBlock{bindings: [this], result: literal},
      %AST.CelIndex{index: 0},
      %AST.CelIterVar{depth: 0, index: 0}
    ]

    assert Enum.all?(expressions, &(CelixirVariables.check(&1, declared) == :ok))

    for kind <- [
          :standard,
          {:transform_map, this, nil},
          {:transform_map_entry, this, literal},
          {:sort_by, this},
          {:collect_list, literal, this}
        ] do
      comprehension = %AST.Comprehension{
        iter_var: "item",
        iter_var2: "index",
        iter_range: this,
        acc_var: "acc",
        acc_init: literal,
        loop_condition: %AST.Ident{name: "item"},
        loop_step: %AST.Ident{name: "acc"},
        result: %AST.Ident{name: "index"},
        kind: kind
      }

      assert :ok = CelixirVariables.check(comprehension, declared)
    end

    assert {:error, "unknown CEL identifier: missing"} =
             CelixirVariables.check(
               %AST.BinaryOp{left: this, right: %AST.Ident{name: "missing"}},
               declared
             )
  end

  test "CEL 型検査は descriptor の scalar、collection、message 型を解決する" do
    descriptor = DescriptorAdapter.describe(Acme.Descriptor.V1.Probe)
    fields = Map.new(descriptor.fields, &{&1.name, &1})

    for field <- [
          nil,
          field(:TYPE_FLOAT),
          field(:TYPE_BYTES),
          field(:TYPE_BOOL),
          field(:TYPE_UINT32),
          fields["labels"],
          fields["scores"],
          fields["created_at"],
          fields["child"]
        ] do
      assert :ok =
               CelixirTypes.check(
                 %AST.BinaryOp{
                   op: :eq,
                   left: %AST.Ident{name: "this"},
                   right: %AST.Ident{name: "this"}
                 },
                 %{scope: :field, type_environment: %{field: field}, rule: 1}
               )
    end

    assert :ok =
             CelixirTypes.check(
               %AST.Select{
                 operand: %AST.Select{operand: %AST.Ident{name: "this"}, field: "child"},
                 field: "code"
               },
               %{scope: :message, type_environment: %{message: descriptor}, rule: "rule"}
             )

    assert {:error, "unknown CEL field: missing"} =
             CelixirTypes.check(
               %AST.Select{operand: %AST.Ident{name: "this"}, field: "missing"},
               %{scope: :message, type_environment: %{message: descriptor}, rule: nil}
             )
  end

  test "CEL 型検査は複合 AST と rule の値型を注釈する" do
    field = field(:TYPE_STRING)
    environment = %{scope: :field, type_environment: %{field: field}, rule: nil}
    this = %AST.Ident{name: "this"}
    literal = %AST.IntLit{value: 1}

    for rule <- [true, 1, "value", %{value: 1}] do
      assert :ok =
               CelixirTypes.check(
                 %AST.BinaryOp{
                   op: :eq,
                   left: %AST.Ident{name: "rule"},
                   right: %AST.Ident{name: "rule"}
                 },
                 %{environment | rule: rule}
               )
    end

    for expression <- [
          %AST.BinaryOp{
            op: :eq,
            left: %AST.CreateList{elements: [this]},
            right: %AST.CreateList{elements: [this]}
          },
          %AST.BinaryOp{
            op: :eq,
            left: %AST.CreateMap{entries: [{this, literal}]},
            right: %AST.CreateMap{entries: [{this, literal}]}
          }
        ] do
      assert :ok = CelixirTypes.check(expression, environment)
    end

    assert %Celixir.Types.Timestamp{} =
             CelixirTypes.value(%Google.Protobuf.Timestamp{seconds: 0, nanos: 0})

    assert %URI{} = CelixirTypes.value(%URI{scheme: "https", host: "example.com"})
    assert :atom == CelixirTypes.value(:atom)

    assert :ok =
             CelixirTypes.check(
               %AST.BinaryOp{
                 op: :eq,
                 left: %AST.Ident{name: "this"},
                 right: %AST.Ident{name: "this"}
               },
               %{
                 scope: :field,
                 type_environment: %{
                   field: field(:TYPE_MESSAGE, well_known_type: {:wrapper, :string})
                 },
                 rule: nil
               }
             )

    assert :ok =
             CelixirTypes.check(
               %AST.Select{operand: %AST.Ident{name: "rule"}, field: "unknown"},
               %{
                 scope: :field,
                 type_environment: %{field: field(:TYPE_STRING)},
                 rule: %{value: 1}
               }
             )
  end

  test "CEL adapter は未コンパイル AST と map 内の識別子を評価する" do
    environment = %{
      this: "value",
      rule: nil,
      now: %{seconds: 0, nanos: 0},
      type_environment: %{field: field(:TYPE_STRING)}
    }

    assert {:ok, true} =
             Protovalidate.CEL.Celixir.evaluate(%AST.BoolLit{value: true}, environment, [])

    assert {:ok, %{uses_now?: false, uses_rule?: false}} =
             Protovalidate.CEL.Celixir.compile(
               %{expression: "{'key': this} == {'key': this}"},
               Map.put(environment, :scope, :field),
               []
             )
  end
end
