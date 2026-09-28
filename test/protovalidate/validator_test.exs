defmodule Protovalidate.ValidatorTest do
  use ExUnit.Case, async: false

  alias Protovalidate.{
    CompilationError,
    DescriptorAdapter,
    Plan,
    PredefinedRuleRegistry,
    UnsupportedRuleError,
    ValidationError
  }

  test "複数違反を決定的な順序で返す" do
    plan = plan_for(%{uuid: true})
    message = %Acme.User.V1.User{id: "invalid", email: "invalid", first_name: "long"}

    assert {:ok, violations} = Plan.evaluate(plan, message, fail_fast: false)
    assert Enum.map(violations, & &1.rule_id) == ["string.uuid", "string.email", "string.max_len"]
  end

  test "fail_fast は最初の違反で停止する" do
    plan = plan_for(%{uuid: true})
    message = %Acme.User.V1.User{id: "invalid", email: "invalid"}

    assert {:ok, [violation]} = Plan.evaluate(plan, message, fail_fast: true)
    assert violation.rule_id == "string.uuid"
  end

  test "CEL を含む記述子は明示的なオプションなしで celixir により評価される" do
    base = %Acme.User.V1.User{
      id: "123e4567-e89b-12d3-a456-426614174000",
      email: "ada@example.com",
      first_name: "Ada"
    }

    assert {:error, %ValidationError{violations: [violation]}} = Protovalidate.validate(base)
    assert violation.rule_id == "first_name_requires_last_name"
  end

  test "設定済み CEL 実行器で message rule をコンパイルして違反へ変換する" do
    validator = Protovalidate.new(cel: Protovalidate.TestCEL)

    base = %Acme.User.V1.User{
      id: "123e4567-e89b-12d3-a456-426614174000",
      email: "ada@example.com"
    }

    assert {:ok, %Acme.User.V1.User{}} = Protovalidate.Validator.validate(validator, base)

    assert {:error, %ValidationError{violations: [violation]}} =
             Protovalidate.Validator.validate(validator, %{base | first_name: "Ada"})

    assert violation.rule_id == "first_name_requires_last_name"
    assert violation.rule_path == ["cel", "first_name_requires_last_name"]
  end

  test "CEL のコンパイル失敗と実行時異常を区別する" do
    assert_raise CompilationError, fn ->
      plan_for_cel("invalid", cel: Protovalidate.TestCEL)
    end

    non_boolean = plan_for_cel("not_boolean", cel: Protovalidate.TestCEL)

    assert_raise Protovalidate.RuntimeError, fn ->
      Plan.evaluate(non_boolean, %Acme.Descriptor.V1.Probe{}, fail_fast: false)
    end

    timeout = plan_for_cel("slow", cel: {Protovalidate.TestCEL, timeout: 1})

    assert_raise Protovalidate.RuntimeError, ~r/timeout/, fn ->
      Plan.evaluate(timeout, %Acme.Descriptor.V1.Probe{}, fail_fast: false)
    end
  end

  test "field CEL はフィールド値を this として評価する" do
    plan =
      plan_for_field(
        :TYPE_STRING,
        %{cel: [%{id: "field_rule", message: "field", expression: "false"}]},
        "implicit_string",
        cel: Protovalidate.TestCEL
      )

    assert {:ok, [violation]} =
             Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{implicit_string: "value"},
               fail_fast: false
             )

    assert violation.rule_id == "field_rule"
    assert violation.field_path.segments == [field: "implicit_string"]
  end

  test "fail_fast は field CEL の違反後に message CEL を評価しない" do
    field = %DescriptorAdapter.Field{
      name: "implicit_string",
      json_name: "implicit_string",
      number: 1,
      type: :TYPE_STRING,
      repeated?: false,
      map?: false,
      oneof: nil,
      presence: :implicit,
      well_known_type: nil,
      validation: %{field: %{cel: [%{id: "field", expression: "false"}]}}
    }

    plan =
      Plan.compile(
        %DescriptorAdapter.Message{
          module: Acme.Descriptor.V1.Probe,
          full_name: "test.Probe",
          fields: [field],
          oneofs: [],
          validation: %{message: %{cel: [%{id: "message", expression: "false"}]}}
        },
        cel: Protovalidate.TestCEL
      )

    assert {:ok, [violation]} =
             Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{implicit_string: "value"},
               fail_fast: true
             )

    assert violation.rule_id == "field"
  end

  test "fail_fast は oneof、field、message CEL の評価境界で停止する" do
    field = %DescriptorAdapter.Field{
      name: "implicit_string",
      json_name: "implicit_string",
      number: 1,
      type: :TYPE_STRING,
      repeated?: false,
      map?: false,
      oneof: nil,
      presence: :implicit,
      well_known_type: nil,
      validation: %{field: %{cel: [%{id: "field", expression: "track"}]}}
    }

    plan =
      Plan.compile(
        %DescriptorAdapter.Message{
          module: Acme.Descriptor.V1.Probe,
          full_name: "test.Probe",
          fields: [field],
          oneofs: [
            %DescriptorAdapter.Oneof{
              name: "contact",
              fields: ["email"],
              validation: %{oneof: %{required: true}}
            }
          ],
          validation: %{message: %{cel: [%{id: "message", expression: "track"}]}}
        },
        cel: {Protovalidate.TestCEL, parent: self()}
      )

    assert {:ok, [oneof_violation]} =
             Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{}, fail_fast: true)

    assert oneof_violation.rule_id == "required"
    refute_receive {:cel_evaluate, _scope}

    assert {:ok, [field_violation]} =
             Plan.evaluate(
               plan,
               %Acme.Descriptor.V1.Probe{contact: {:email, "selected"}, implicit_string: "value"},
               fail_fast: true
             )

    assert field_violation.rule_id == "field"
    assert_receive {:cel_evaluate, :field}
    refute_receive {:cel_evaluate, :message}
  end

  test "validate! は通常の入力違反を ValidationError として raise する" do
    violation = Protovalidate.Violation.new(Protovalidate.FieldPath.new([]), "test", "invalid")

    assert_raise ValidationError, fn ->
      raise ValidationError.exception(violations: [violation])
    end
  end

  test "validator ごとの ETS cache は descriptor と設定単位で plan を再利用する" do
    validator = Protovalidate.new()

    assert {:ok, %Acme.Descriptor.V1.Legacy{}} =
             Protovalidate.Validator.validate(validator, %Acme.Descriptor.V1.Legacy{})

    assert %{hits: 0, misses: 1, size: 1} = Protovalidate.Validator.cache_stats(validator)

    assert {:ok, %Acme.Descriptor.V1.Legacy{}} =
             Protovalidate.Validator.validate(validator, %Acme.Descriptor.V1.Legacy{})

    assert %{hits: 1, misses: 1, size: 1} = Protovalidate.Validator.cache_stats(validator)
  end

  test "同時の cache miss では採用済み plan を返す" do
    validator = Protovalidate.new(cel: {Protovalidate.TestCEL, compile_barrier: {self(), 1}})

    message = %Acme.User.V1.User{
      id: "123e4567-e89b-12d3-a456-426614174000",
      email: "ada@example.com"
    }

    tasks =
      for _index <- 1..8 do
        Task.async(fn ->
          receive do
            :validate -> Protovalidate.Validator.validate(validator, message)
          end
        end)
      end

    Enum.each(tasks, &send(&1.pid, :validate))

    assert_receive {:cel_compile, compiler_pid}, 5_000
    refute_receive {:cel_compile, _other}, 50
    send(compiler_pid, :continue_compile)

    assert Enum.all?(Task.await_many(tasks, 5_000), &match?({:ok, ^message}, &1))
    assert %{hits: 0, misses: 8, size: 1} = Protovalidate.Validator.cache_stats(validator)
  end

  test "利便 API は一時 validator の ETS table を残さない" do
    initial_tables = cache_tables_owned_by(self())

    Enum.each(1..3, fn _index ->
      assert {:ok, %Acme.Descriptor.V1.Legacy{}} =
               Protovalidate.validate(%Acme.Descriptor.V1.Legacy{})
    end)

    assert cache_tables_owned_by(self()) == initial_tables
  end

  test "Telemetry は cache と検証の集計値だけを公開する" do
    handler_id = "protovalidate-validator-test-#{System.unique_integer([:positive])}"
    parent = self()

    :ok =
      :telemetry.attach_many(
        handler_id,
        [
          [:protovalidate, :plan_cache, :miss],
          [:protovalidate, :plan_cache, :hit],
          [:protovalidate, :validation, :stop]
        ],
        &__MODULE__.handle_telemetry/4,
        parent
      )

    on_exit(fn -> :telemetry.detach(handler_id) end)
    validator = Protovalidate.new()
    message = %Acme.Descriptor.V1.Legacy{}

    assert {:ok, ^message} = Protovalidate.Validator.validate(validator, message)

    assert_receive {:telemetry, [:protovalidate, :plan_cache, :miss], %{count: 1},
                    %{message_module: Acme.Descriptor.V1.Legacy}}

    assert_receive {:telemetry, [:protovalidate, :validation, :stop],
                    %{duration: duration, violations: 0},
                    %{message_module: Acme.Descriptor.V1.Legacy, outcome: :ok}}

    assert is_integer(duration)

    assert {:ok, ^message} = Protovalidate.Validator.validate(validator, message)

    assert_receive {:telemetry, [:protovalidate, :plan_cache, :hit], %{count: 1},
                    %{message_module: Acme.Descriptor.V1.Legacy}}
  end

  def handle_telemetry(event, measurements, metadata, parent) do
    send(parent, {:telemetry, event, measurements, metadata})
  end

  test "implicit presence の required はゼロ値を拒否する" do
    plan = plan_for_field(:TYPE_STRING, %{required: true})

    assert {:ok, [violation]} = Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{}, fail_fast: false)
    assert violation.rule_id == "required"
  end

  test "ignore は required と後続ルールを評価しない" do
    plan = plan_for_field(:TYPE_STRING, %{required: true, ignore: :IGNORE_ALWAYS})

    assert {:ok, []} = Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{}, fail_fast: false)
  end

  test "bool const と nested message を評価する" do
    bool_plan = plan_for_field(:TYPE_BOOL, %{type: {:bool, %{const: true}}})

    assert {:ok, [_violation]} =
             Plan.evaluate(bool_plan, %Acme.Descriptor.V1.Probe{implicit_string: false},
               fail_fast: false
             )

    child_field =
      Acme.Descriptor.V1.Probe
      |> DescriptorAdapter.describe()
      |> Map.fetch!(:fields)
      |> Enum.find(&(&1.name == "child"))

    nested_plan = plan_for_fields([child_field])

    assert {:ok, []} =
             Plan.evaluate(
               nested_plan,
               %Acme.Descriptor.V1.Probe{
                 child: %Acme.Descriptor.V1.Child{code: "ok"}
               },
               fail_fast: false
             )
  end

  test "P0 の string ルールを組み合わせて評価する" do
    plan =
      plan_for_field(:TYPE_STRING, %{
        type: {
          :string,
          %{min_len: 3, max_len: 5, prefix: "ab", contains: "c", pattern: "^abc"}
        }
      })

    assert {:ok, []} =
             Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{implicit_string: "abcd"},
               fail_fast: false
             )

    assert {:ok, violations} =
             Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{implicit_string: "a"},
               fail_fast: false
             )

    assert Enum.map(violations, & &1.rule_id) == [
             "string.min_len",
             "string.pattern",
             "string.prefix",
             "string.contains"
           ]
  end

  test "数値の集合・比較ルールを評価する" do
    plan =
      plan_for_field(:TYPE_UINT32, %{
        type: {:uint32, %{gte: 10, lt: 20, in: [10, 12], not_in: [12]}}
      })

    assert {:ok, []} =
             Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{implicit_string: 10}, fail_fast: false)

    assert {:ok, violations} =
             Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{implicit_string: 12}, fail_fast: false)

    assert Enum.map(violations, & &1.rule_id) == ["uint32.not_in"]
  end

  test "生成済み descriptor の string ルールを実行する" do
    message = %Acme.Descriptor.V1.Probe{implicit_string: "x", contact: {:email, "selected"}}

    assert {:error, %ValidationError{violations: violations}} = Protovalidate.validate(message)
    assert Enum.map(violations, & &1.rule_id) == ["string.min_len", "string.prefix"]
  end

  test "生成済み descriptor で optional、oneof と子 message を検証する" do
    valid = %Acme.Descriptor.V1.Probe{
      implicit_string: "ab",
      contact: {:email, "selected"},
      optional_string: "ok",
      child: %Acme.Descriptor.V1.Child{code: "ok"}
    }

    assert {:ok, ^valid} = Protovalidate.validate(valid)

    assert {:error, %ValidationError{violations: [optional_violation]}} =
             Protovalidate.validate(%{valid | optional_string: "x"})

    assert optional_violation.rule_id == "string.min_len"
    assert optional_violation.field_path.segments == [{:field, "optional_string"}]

    assert {:error, %ValidationError{violations: [oneof_violation]}} =
             Protovalidate.validate(%{valid | contact: nil})

    assert oneof_violation.rule_id == "required"

    assert {:error, %ValidationError{violations: [child_violation]}} =
             Protovalidate.validate(%{valid | child: %Acme.Descriptor.V1.Child{code: "x"}})

    assert child_violation.rule_id == "string.min_len"
    assert child_violation.field_path.segments == [{:field, "child"}, {:field, "code"}]
  end

  test "生成済み descriptor の深い子 message 違反に全階層の path を設定する" do
    message = %Acme.Descriptor.V1.Probe{
      implicit_string: "ab",
      contact: {:email, "selected"},
      child: %Acme.Descriptor.V1.Child{
        code: "ok",
        grandchild: %Acme.Descriptor.V1.Grandchild{code: "x"}
      }
    }

    assert {:error, %ValidationError{violations: [violation]}} = Protovalidate.validate(message)
    assert violation.rule_id == "string.min_len"

    assert violation.field_path.segments == [
             {:field, "child"},
             {:field, "grandchild"},
             {:field, "code"}
           ]
  end

  test "repeated と map のサイズルールを評価する" do
    repeated_plan = plan_for_collection(:repeated, %{min_items: 2, unique: true})
    map_plan = plan_for_collection(:map, %{max_pairs: 1})

    assert {:ok, violations} =
             Plan.evaluate(repeated_plan, %Acme.Descriptor.V1.Probe{labels: ["same", "same"]},
               fail_fast: false
             )

    assert Enum.map(violations, & &1.rule_id) == ["repeated.unique"]

    assert {:ok, [violation]} =
             Plan.evaluate(map_plan, %Acme.Descriptor.V1.Probe{scores: %{"a" => 1, "b" => 2}},
               fail_fast: false
             )

    assert violation.rule_id == "map.max_pairs"
  end

  test "repeated.items の違反には添字付き field path を設定する" do
    plan =
      plan_for_collection(:repeated, %{
        items: %{type: {:string, %{min_len: 2}}}
      })

    assert {:ok, [violation]} =
             Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{labels: ["valid", "x"]},
               fail_fast: false
             )

    assert violation.rule_id == "string.min_len"
    assert violation.field_path.segments == [{:field, "labels"}, {:index, 1}]
  end

  test "map の keys と values は型付き key path と for_key を保持する" do
    plan =
      plan_for_collection(:map, %{
        keys: %{type: {:string, %{min_len: 2}}},
        values: %{type: {:uint32, %{gte: 10}}}
      })

    assert {:ok, violations} =
             Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{scores: %{"a" => 1, "valid" => 10}},
               fail_fast: false
             )

    assert Enum.map(violations, & &1.rule_id) == ["string.min_len", "uint32.gte"]

    assert [%{field_path: key_path, for_key: true}, %{field_path: value_path, for_key: false}] =
             violations

    assert key_path.segments == [{:field, "scores"}, {:map_key, :string, "a"}]
    assert value_path.segments == [{:field, "scores"}, {:map_key, :string, "a"}]
  end

  test "正の signed map key は descriptor の符号種別を path に保持する" do
    plan =
      plan_for_collection(
        :map,
        %{keys: %{type: {:sint32, %{gte: 100}}}},
        map_key: :TYPE_SINT32,
        map_value: :TYPE_STRING
      )

    assert {:ok, [violation]} =
             Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{scores: %{42 => "value"}},
               fail_fast: false
             )

    assert violation.for_key
    assert violation.field_path.segments == [{:field, "scores"}, {:map_key, :int, 42}]
  end

  test "collection 内の CEL と predefined rule は validator 設定を引き継ぐ" do
    cel_plan =
      plan_for_collection(
        :repeated,
        %{items: %{cel: [%{id: "item", expression: "false"}]}},
        cel: Protovalidate.TestCEL
      )

    assert {:ok, [cel_violation]} =
             Plan.evaluate(cel_plan, %Acme.Descriptor.V1.Probe{labels: ["invalid"]},
               fail_fast: false
             )

    assert cel_violation.rule_id == "item"
    assert cel_violation.field_path.segments == [{:field, "labels"}, {:index, 0}]

    registry =
      PredefinedRuleRegistry.new(%{
        1001 => %{
          rule_type: Buf.Validate.StringRules,
          value_type: :boolean,
          cel: [%{id: "predefined", expression: "predefined_false"}]
        }
      })

    rules = %{
      values: %{
        type:
          {:string,
           Protobuf.Extension.put(
             Buf.Validate.StringRules,
             %Buf.Validate.StringRules{},
             Protovalidate.TestPredefinedExtension,
             :required_value,
             true
           )}
      }
    }

    predefined_plan =
      plan_for_collection(:map, rules,
        map_value: :TYPE_STRING,
        registry: registry,
        cel: Protovalidate.TestCEL
      )

    assert {:ok, [predefined_violation]} =
             Plan.evaluate(
               predefined_plan,
               %Acme.Descriptor.V1.Probe{scores: %{"item" => "invalid"}},
               fail_fast: false
             )

    assert predefined_violation.rule_id == "predefined"

    assert predefined_violation.field_path.segments == [
             {:field, "scores"},
             {:map_key, :string, "item"}
           ]
  end

  test "Timestamp と Any の WKT ルールを評価する" do
    timestamp_plan =
      plan_for_wkt("created_at", :timestamp, {:timestamp, %{gte: %{seconds: 10, nanos: 0}}})

    any_plan = plan_for_wkt("payload", :any, {:any, %{in: ["type.googleapis.com/acme.User"]}})

    assert {:ok, [timestamp_violation]} =
             Plan.evaluate(
               timestamp_plan,
               %Acme.Descriptor.V1.Probe{created_at: %Google.Protobuf.Timestamp{}},
               fail_fast: false
             )

    assert timestamp_violation.rule_id == "timestamp.gte"

    assert {:ok, [any_violation]} =
             Plan.evaluate(any_plan, %Acme.Descriptor.V1.Probe{payload: %Google.Protobuf.Any{}},
               fail_fast: false
             )

    assert any_violation.rule_id == "any.in"
  end

  test "Timestamp の現在時刻ルールは評価時刻を注入して決定的に検証できる" do
    plan =
      plan_for_wkt("created_at", :timestamp, {
        :timestamp,
        %{lt_now: true, within: %{seconds: 5, nanos: 0}}
      })

    assert {:ok, []} =
             Plan.evaluate(
               plan,
               %Acme.Descriptor.V1.Probe{created_at: %Google.Protobuf.Timestamp{seconds: 98}},
               fail_fast: false,
               now: %{seconds: 100, nanos: 0}
             )

    assert {:ok, violations} =
             Plan.evaluate(
               plan,
               %Acme.Descriptor.V1.Probe{created_at: %Google.Protobuf.Timestamp{seconds: 110}},
               fail_fast: false,
               now: %{seconds: 100, nanos: 0}
             )

    assert Enum.map(violations, & &1.rule_id) == ["timestamp.lt_now", "timestamp.within"]
  end

  test "wrapper WKT は対応する scalar rule で値を検証する" do
    field = %DescriptorAdapter.Field{
      name: "optional_string",
      json_name: "optional_string",
      number: 1,
      type: ".google.protobuf.StringValue",
      repeated?: false,
      map?: false,
      oneof: nil,
      presence: :explicit,
      well_known_type: {:wrapper, :TYPE_STRING},
      validation: %{field: %{type: {:string, %{min_len: 2}}}}
    }

    plan = plan_for_fields([field])

    assert {:ok, [violation]} =
             Plan.evaluate(
               plan,
               %Acme.Descriptor.V1.Probe{
                 optional_string: %Google.Protobuf.StringValue{value: "x"}
               },
               fail_fast: false
             )

    assert violation.rule_id == "string.min_len"
  end

  test "enum.defined_only は schema に定義されない値を拒否する" do
    field = %DescriptorAdapter.Field{
      name: "status",
      json_name: "status",
      number: 11,
      type: :TYPE_ENUM,
      repeated?: false,
      map?: false,
      oneof: nil,
      presence: :implicit,
      well_known_type: nil,
      enum_values: [0, 1],
      validation: %{field: %{type: {:enum, %{defined_only: true}}}}
    }

    plan = plan_for_fields([field])

    assert {:ok, []} =
             Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{status: 1}, fail_fast: false)

    assert {:ok, [violation]} =
             Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{status: 99}, fail_fast: false)

    assert violation.rule_id == "enum.defined_only"
  end

  test "未知の rule と field 型に合わない rule は CompilationError になる" do
    assert_raise CompilationError, fn -> plan_for_field(:TYPE_STRING, %{unknown: true}) end

    assert_raise CompilationError, fn ->
      plan_for_field(:TYPE_STRING, %{type: {:bool, %{const: true}}})
    end
  end

  test "追加された string の標準 rule を評価する" do
    valid_values = [
      {:address, "example.com"},
      {:tuuid, "550e8400e29b41d4a716446655440000"},
      {:ip_with_prefixlen, "192.168.1.42/24"},
      {:ipv4_prefix, "192.168.1.0/24"},
      {:host_and_port, "[2001:db8::1]:443"},
      {:ulid, "01ARZ3NDEKTSV4RRFFQ69G5FAV"},
      {:protobuf_fqn, "google.protobuf.Timestamp"},
      {:protobuf_dot_fqn, ".google.protobuf.Timestamp"}
    ]

    Enum.each(valid_values, fn {rule, value} ->
      plan = plan_for_field(:TYPE_STRING, %{type: {:string, %{rule => true}}})

      assert {:ok, []} =
               Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{implicit_string: value},
                 fail_fast: false
               )
    end)

    plan = plan_for_field(:TYPE_STRING, %{type: {:string, %{ip_prefix: true}}})

    assert {:ok, [violation]} =
             Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{implicit_string: "192.168.1.42/24"},
               fail_fast: false
             )

    assert violation.rule_id == "string.ip_prefix"
  end

  test "bytes の IP と UUID ルールはバイト列の長さを検証する" do
    valid_values = [
      {:ip, <<192, 0, 2, 1>>},
      {:ip, :binary.copy(<<0>>, 16)},
      {:ipv4, <<192, 0, 2, 1>>},
      {:ipv6, :binary.copy(<<0>>, 16)},
      {:uuid, :binary.copy(<<0>>, 16)}
    ]

    Enum.each(valid_values, fn {rule, value} ->
      plan = plan_for_field(:TYPE_BYTES, %{type: {:bytes, %{rule => true}}})

      assert {:ok, []} =
               Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{implicit_string: value},
                 fail_fast: false
               )
    end)

    plan =
      plan_for_field(:TYPE_BYTES, %{type: {:bytes, %{ipv4: true, example: [<<127, 0, 0, 1>>]}}})

    assert {:ok, [violation]} =
             Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{implicit_string: <<1, 2, 3>>},
               fail_fast: false
             )

    assert violation.rule_id == "bytes.ipv4"
  end

  test "FieldMask の in/not_in は指定 path の subpath を判定する" do
    plan =
      plan_for_wkt("update_mask", :field_mask, {
        :field_mask,
        %{in: ["profile"], not_in: ["profile.private"]}
      })

    assert {:ok, []} =
             Plan.evaluate(
               plan,
               %Acme.Descriptor.V1.Probe{
                 update_mask: %Google.Protobuf.FieldMask{paths: ["profile.name"]}
               },
               fail_fast: false
             )

    assert {:ok, [violation]} =
             Plan.evaluate(
               plan,
               %Acme.Descriptor.V1.Probe{
                 update_mask: %Google.Protobuf.FieldMask{paths: ["profile.private.token"]}
               },
               fail_fast: false
             )

    assert violation.rule_id == "field_mask.not_in"
  end

  test "predefined extension は CEL 実行器なしで成功として扱わない" do
    assert_raise UnsupportedRuleError, fn ->
      plan_for_field(:TYPE_STRING, %{
        type: {:string, %{__pb_extensions__: %{1001 => true}}}
      })
    end
  end

  test "predefined rule を registry で解決し、拡張値を CEL の rule 環境へ渡す" do
    registry =
      PredefinedRuleRegistry.new(%{
        1001 => %{
          rule_type: Buf.Validate.StringRules,
          value_type: :boolean,
          cel: [
            %{
              id: "acme.string.required_value",
              message: "invalid",
              expression: "predefined_false"
            }
          ]
        }
      })

    plan =
      plan_for_field(
        :TYPE_STRING,
        %{
          type:
            {:string,
             Protobuf.Extension.put(
               Buf.Validate.StringRules,
               %Buf.Validate.StringRules{},
               Protovalidate.TestPredefinedExtension,
               :required_value,
               true
             )}
        },
        "implicit_string",
        registry: registry,
        cel: Protovalidate.TestCEL
      )

    assert {:ok, [violation]} =
             Plan.evaluate(plan, %Acme.Descriptor.V1.Probe{implicit_string: "invalid"},
               fail_fast: false
             )

    assert violation.rule_id == "acme.string.required_value"
    assert violation.rule_path == ["predefined", "1001", "acme.string.required_value"]
  end

  test "predefined rule の型不一致、未知 extension、CEL ID 衝突を plan 構築時に失敗させる" do
    typed_registry =
      PredefinedRuleRegistry.new(%{
        1001 => %{
          rule_type: :other,
          value_type: :boolean,
          cel: [%{id: "one", expression: "true"}]
        }
      })

    assert_raise CompilationError, fn ->
      plan_for_field(
        :TYPE_STRING,
        %{type: {:string, %{__pb_extensions__: %{1001 => true}}}},
        "implicit_string",
        registry: typed_registry,
        cel: Protovalidate.TestCEL
      )
    end

    assert_raise UnsupportedRuleError, fn ->
      plan_for_field(
        :TYPE_STRING,
        %{type: {:string, %{__pb_extensions__: %{1002 => true}}}},
        "implicit_string",
        registry: PredefinedRuleRegistry.new(),
        cel: Protovalidate.TestCEL
      )
    end

    colliding_registry =
      PredefinedRuleRegistry.new(%{
        1001 => %{rule_type: :map, cel: [%{id: "duplicate", expression: "true"}]}
      })

    assert_raise CompilationError, ~r/duplicate/, fn ->
      plan_for_field(
        :TYPE_STRING,
        %{
          cel: [%{id: "duplicate", expression: "true"}],
          type: {:string, %{__pb_extensions__: %{1001 => true}}}
        },
        "implicit_string",
        registry: colliding_registry,
        cel: Protovalidate.TestCEL
      )
    end
  end

  defp plan_for(rules) do
    field = %DescriptorAdapter.Field{
      name: "id",
      json_name: "id",
      number: 1,
      type: :TYPE_STRING,
      repeated?: false,
      map?: false,
      oneof: nil,
      presence: :implicit,
      well_known_type: nil,
      validation: %{field: %{type: {:string, rules}}}
    }

    email = %{
      field
      | name: "email",
        number: 3,
        validation: %{field: %{type: {:string, %{email: true}}}}
    }

    first_name = %{
      field
      | name: "first_name",
        number: 4,
        validation: %{field: %{type: {:string, %{max_len: 3}}}}
    }

    Plan.compile(
      %DescriptorAdapter.Message{
        module: Acme.User.V1.User,
        full_name: "test.User",
        fields: [field, email, first_name],
        oneofs: [],
        validation: %{}
      },
      []
    )
  end

  defp cache_tables_owned_by(owner) do
    :ets.all()
    |> Enum.filter(fn table ->
      :ets.info(table, :owner) == owner and
        :ets.info(table, :name) in [:protovalidate_plan_cache, :protovalidate_plan_cache_stats]
    end)
  end

  defp plan_for_cel(expression, options) do
    Plan.compile(
      %DescriptorAdapter.Message{
        module: Acme.Descriptor.V1.Probe,
        full_name: "test.Probe",
        fields: [],
        oneofs: [],
        validation: %{
          message: %{cel: [%{id: "test_rule", message: "test", expression: expression}]}
        }
      },
      options
    )
  end

  defp plan_for_field(type, rules, name \\ "implicit_string", options \\ []) do
    field = %DescriptorAdapter.Field{
      name: name,
      json_name: name,
      number: 1,
      type: type,
      repeated?: false,
      map?: false,
      oneof: nil,
      presence: :implicit,
      well_known_type: nil,
      validation: %{field: rules}
    }

    plan_for_fields([field], options)
  end

  defp plan_for_fields(fields, options \\ []) do
    Plan.compile(
      %DescriptorAdapter.Message{
        module: Acme.Descriptor.V1.Probe,
        full_name: "test.Probe",
        fields: fields,
        oneofs: [],
        validation: %{}
      },
      options
    )
  end

  defp plan_for_collection(kind, rules, options \\ []) do
    field = %DescriptorAdapter.Field{
      name: if(kind == :repeated, do: "labels", else: "scores"),
      json_name: if(kind == :repeated, do: "labels", else: "scores"),
      number: 1,
      type: :TYPE_STRING,
      repeated?: kind == :repeated,
      map?: kind == :map,
      item_type: if(kind == :repeated, do: :TYPE_STRING),
      map_key: if(kind == :map, do: Keyword.get(options, :map_key, :TYPE_STRING)),
      map_value: if(kind == :map, do: Keyword.get(options, :map_value, :TYPE_UINT32)),
      oneof: nil,
      presence: :implicit,
      well_known_type: nil,
      validation: %{field: %{type: {kind, rules}}}
    }

    Plan.compile(
      %DescriptorAdapter.Message{
        module: Acme.Descriptor.V1.Probe,
        full_name: "test.Collection",
        fields: [field],
        oneofs: [],
        validation: %{}
      },
      Keyword.drop(options, [:map_key, :map_value])
    )
  end

  defp plan_for_wkt(name, well_known_type, rules) do
    field = %DescriptorAdapter.Field{
      name: name,
      json_name: name,
      number: 1,
      type: ".google.protobuf.#{well_known_type}",
      repeated?: false,
      map?: false,
      oneof: nil,
      presence: :explicit,
      well_known_type: well_known_type,
      validation: %{field: %{type: rules}}
    }

    Plan.compile(
      %DescriptorAdapter.Message{
        module: Acme.Descriptor.V1.Probe,
        full_name: "test.Wkt",
        fields: [field],
        oneofs: [],
        validation: %{}
      },
      []
    )
  end
end
