defmodule Protovalidate.DescriptorBoundaryTest do
  use ExUnit.Case, async: true

  alias Acme.Descriptor.V1.{Child, Grandchild, Legacy, Probe, RecursiveNode}

  alias Google.Protobuf.{
    Any,
    DescriptorProto,
    FeatureSet,
    FieldDescriptorProto,
    FieldOptions,
    FileDescriptorProto,
    FileDescriptorSet,
    FileOptions,
    MessageOptions
  }

  alias Protovalidate.Conformance.{RuntimeDescriptorAdapter, ViolationCodec}
  alias Protovalidate.{DescriptorAdapter, FieldPath, Violation}

  test "同一 fixture の生成済みと runtime の optional/map/enum と検証結果が一致する" do
    generated = %Probe{
      implicit_string: "ab",
      optional_string: "x",
      contact: {:email, "a"},
      status: :STATUS_ACTIVE,
      scores: %{"a" => 1},
      child: %Child{code: "x"},
      children: [%Child{code: "x"}],
      children_by_name: %{"a" => %Child{code: "x"}}
    }

    runtime = decode(generated)
    left = DescriptorAdapter.describe(Probe)
    right = DescriptorAdapter.describe(runtime.__struct__)
    assert Enum.map(left.fields, &shape/1) == Enum.map(right.fields, &shape/1)
    assert left.oneofs == right.oneofs
    assert runtime.optional_string == "x"
    assert runtime.status == :STATUS_ACTIVE
    assert runtime.scores == %{"a" => 1}
    assert DescriptorAdapter.field_presence(decode(%Probe{}), :optional_string) == :not_present
    assert {:error, a} = Protovalidate.validate(generated)
    assert {:error, b} = Protovalidate.validate(runtime)
    assert a.violations == b.violations
  end

  test "ネストの番号と repeated 添字、符号付き・符号なし map key を wire に保持する" do
    probe = decode(%Probe{})

    for module <- [Probe, probe.__struct__] do
      path =
        ViolationCodec.field_path(
          [
            {:field, "child"},
            {:field, "grandchild"},
            {:field, "code"}
          ],
          module
        )

      assert ^path = path |> Buf.Validate.FieldPath.encode() |> Buf.Validate.FieldPath.decode()
      assert Enum.map(path.elements, & &1.field_number) == [12, 2, 1]

      assert Enum.map(path.elements, & &1.field_type) == [
               :TYPE_MESSAGE,
               :TYPE_MESSAGE,
               :TYPE_STRING
             ]
    end

    paths = [
      [{:field, "children"}, {:index, 2}, {:field, "code"}],
      [{:field, "signed_children"}, {:map_key, :int, 7}, {:field, "code"}],
      [{:field, "unsigned_children"}, {:map_key, :uint, 7}, {:field, "code"}]
    ]

    runtime = decode(%RecursiveNode{})

    for module <- [RecursiveNode, runtime.__struct__] do
      violations = Enum.map(paths, &Violation.new(FieldPath.new(&1), "string.min_len", "short"))
      encoded = ViolationCodec.encode(violations, module)

      assert ^encoded =
               encoded |> Buf.Validate.Violations.encode() |> Buf.Validate.Violations.decode()

      [repeated, signed, unsigned] = Enum.map(encoded.violations, & &1.field.elements)

      assert [
               %{field_number: 3, field_type: :TYPE_MESSAGE, subscript: {:index, 2}},
               %{field_number: 1, field_type: :TYPE_STRING}
             ] = repeated

      assert [
               %{
                 field_number: 4,
                 key_type: :TYPE_INT32,
                 value_type: :TYPE_MESSAGE,
                 subscript: {:int_key, 7}
               },
               %{field_number: 1}
             ] = signed

      assert [
               %{field_number: 5, key_type: :TYPE_UINT32, subscript: {:uint_key, 7}},
               %{field_number: 1}
             ] = unsigned
    end
  end

  test "map 全体の違反と string key の違反を区別し for_key を保持する" do
    whole = Violation.new(FieldPath.new([{:field, "scores"}]), "map.min_pairs", "short")

    key =
      Violation.new(
        FieldPath.new([{:field, "scores"}, {:map_key, :string, "a"}]),
        "string.min_len",
        "short",
        for_key: true
      )

    encoded = ViolationCodec.encode([whole, key], Probe)

    assert ^encoded =
             encoded |> Buf.Validate.Violations.encode() |> Buf.Validate.Violations.decode()

    assert [a, b] = encoded.violations
    assert [%{key_type: nil, value_type: nil, subscript: nil}] = a.field.elements
    assert b.for_key

    assert [%{key_type: :TYPE_STRING, value_type: :TYPE_UINT32, subscript: {:string_key, "a"}}] =
             b.field.elements
  end

  test "enum の定義済み atom と未知の数値を双方の descriptor で評価する" do
    for message <- [%Probe{status: :STATUS_ACTIVE}, decode(%Probe{status: :STATUS_ACTIVE})] do
      descriptor = DescriptorAdapter.describe(message.__struct__)
      enum = Enum.find(descriptor.fields, &(&1.name == "status"))
      enum = %{enum | validation: %{field: %{type: {:enum, %{defined_only: true}}}}}
      plan = Protovalidate.Plan.compile(%{descriptor | fields: [enum], oneofs: []}, [])
      assert {:ok, []} = Protovalidate.Plan.evaluate(plan, message, fail_fast: false)

      assert {:ok, [%{rule_id: "enum.defined_only"}]} =
               Protovalidate.Plan.evaluate(plan, %{message | status: 99}, fail_fast: false)
    end
  end

  test "runtime descriptor は edition feature を file、message、field の順に継承する" do
    fields = [
      semantic_field("from_file", 1),
      semantic_field("from_message", 2),
      semantic_field("from_field", 3, :EXPLICIT)
    ]

    message = %DescriptorProto{
      name: "EditionProbe",
      field: fields,
      options: %MessageOptions{features: %FeatureSet{field_presence: :IMPLICIT}}
    }

    set = %FileDescriptorSet{
      file: [
        %FileDescriptorProto{
          name: "edition_probe.proto",
          package: "semantic",
          syntax: "proto3",
          edition: :EDITION_2023,
          options: %FileOptions{features: %FeatureSet{field_presence: :EXPLICIT}},
          message_type: [message]
        }
      ]
    }

    runtime =
      RuntimeDescriptorAdapter.decode(set, %Any{
        type_url: "type.googleapis.com/semantic.EditionProbe",
        value: <<>>
      })

    descriptor = DescriptorAdapter.describe(runtime.__struct__)
    by_name = Map.new(descriptor.fields, &{&1.name, &1})

    assert by_name["from_file"].features.edition == :EDITION_2023
    assert by_name["from_file"].features.field_presence == :IMPLICIT
    assert by_name["from_message"].presence == :implicit
    assert by_name["from_field"].features.field_presence == :EXPLICIT
    assert by_name["from_field"].presence == :explicit
  end

  test "意味モデルは collection 要素、well-known type、enum を独立に表す" do
    descriptor = DescriptorAdapter.describe(Probe)
    fields = Map.new(descriptor.fields, &{&1.name, &1})

    assert fields["labels"].semantic_type == {:list, {:scalar, :TYPE_STRING}}

    assert fields["scores"].semantic_type ==
             {:map, {:scalar, :TYPE_STRING}, {:scalar, :TYPE_UINT32}}

    assert DescriptorAdapter.collection_field(fields["labels"], :items).presence == :collection

    assert fields["created_at"].semantic_type ==
             {:message, ".google.protobuf.Timestamp", :timestamp}

    assert {:enum, ".acme.descriptor.v1.Probe.Status", values} = fields["status"].semantic_type
    assert 0 in values
  end

  test "runtime descriptor は proto2 default と group の wire 意味を保持する" do
    group = %DescriptorProto{
      name: "LegacyGroup",
      field: [semantic_field("value", 1)]
    }

    message = %DescriptorProto{
      name: "LegacyProbe",
      nested_type: [group],
      field: [
        %FieldDescriptorProto{
          name: "count",
          json_name: "count",
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_INT32,
          default_value: "7"
        },
        %FieldDescriptorProto{
          name: "legacy_group",
          json_name: "legacyGroup",
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_GROUP,
          type_name: ".semantic.LegacyProbe.LegacyGroup"
        }
      ]
    }

    set = %FileDescriptorSet{
      file: [
        %FileDescriptorProto{
          name: "legacy_probe.proto",
          package: "semantic",
          syntax: "proto2",
          message_type: [message]
        }
      ]
    }

    runtime =
      RuntimeDescriptorAdapter.decode(set, %Any{
        type_url: "type.googleapis.com/semantic.LegacyProbe",
        value: <<>>
      })

    fields =
      runtime.__struct__
      |> DescriptorAdapter.describe()
      |> Map.fetch!(:fields)
      |> Map.new(&{&1.name, &1})

    assert fields["count"].default == 7
    assert fields["count"].presence == :explicit

    assert fields["legacy_group"].semantic_type ==
             {:message, ".semantic.LegacyProbe.LegacyGroup", nil}

    assert fields["legacy_group"].features.message_encoding == :DELIMITED
  end

  test "未知 field と不正な subscript を明示エラーにする" do
    for segments <- [
          [{:field, "missing"}],
          [{:field, "code"}, {:index, 0}],
          [{:field, "code"}, {:field, "missing"}]
        ] do
      assert_raise Protovalidate.RuntimeError, fn ->
        ViolationCodec.field_path(segments, Child)
      end
    end

    unknown_rule = Violation.new(FieldPath.new([]), "missing.rule", "unknown")

    assert_raise Protovalidate.RuntimeError, fn ->
      ViolationCodec.encode([unknown_rule], Child)
    end
  end

  test "依存する子だけが変更されても以前の runtime 定義を再利用しない" do
    original = fdset()

    changed = %{
      original
      | file:
          Enum.map(original.file, fn file ->
            %{
              file
              | message_type:
                  Enum.map(file.message_type, fn
                    %{name: "Child"} = child ->
                      %{child | field: Enum.map(child.field, &%{&1 | number: &1.number + 10})}

                    message ->
                      message
                  end)
            }
          end)
    }

    any = %Any{type_url: "type.googleapis.com/acme.descriptor.v1.Probe", value: <<>>}
    first = RuntimeDescriptorAdapter.decode(original, any).__struct__
    second = RuntimeDescriptorAdapter.decode(changed, any).__struct__
    refute first == second

    first_child =
      Enum.find(DescriptorAdapter.describe(first).fields, &(&1.name == "child")).reference

    second_child =
      Enum.find(DescriptorAdapter.describe(second).fields, &(&1.name == "child")).reference

    assert hd(first_child.descriptor().field).number == 1
    assert hd(second_child.descriptor().field).number == 11
    assert RuntimeDescriptorAdapter.decode(original, any).__struct__ == first
  end

  test "子の宣言型を単一・repeated・map で照合し、入力値をエラーに含めない" do
    valid = %Probe{
      implicit_string: "ab",
      contact: {:email, "a"},
      child: %Child{code: "ok"},
      children: [%Child{code: "ok"}],
      children_by_name: %{"secret-key" => %Child{code: "ok"}}
    }

    for message <- [valid, decode(valid)] do
      assert {:ok, ^message} = Protovalidate.validate(message)

      for wrong <- [%Legacy{id: "secret-value"}, %{code: "secret-value"}, "secret-value"],
          {field, value} <- [
            child: wrong,
            children: [wrong],
            children_by_name: %{"secret-key" => wrong}
          ] do
        invalid = Map.put(message, field, value)

        assert {:error, %Protovalidate.RuntimeError{message: error}} =
                 Protovalidate.validate(invalid)

        assert error == "declared and actual child message types do not match"
        assert_raise Protovalidate.RuntimeError, error, fn -> Protovalidate.validate!(invalid) end
      end
    end
  end

  test "ルールなし WKT とルールあり WKT の異型を拒否する" do
    valid = %Probe{
      implicit_string: "ab",
      contact: {:email, "a"},
      payload: %Any{},
      created_at: %Google.Protobuf.Timestamp{},
      timeout: %Google.Protobuf.Duration{},
      update_mask: %Google.Protobuf.FieldMask{}
    }

    for message <- [valid, decode(valid)] do
      assert {:ok, ^message} = Protovalidate.validate(message)
    end

    for message <- [valid, decode(valid)],
        field <- [:payload, :created_at, :timeout, :update_mask] do
      assert {:error, %Protovalidate.RuntimeError{}} =
               Protovalidate.validate(Map.put(message, field, %Legacy{}))
    end

    assert {:error, %Protovalidate.RuntimeError{}} =
             Protovalidate.validate(%RecursiveNode{
               code: "ok",
               timestamp: %Google.Protobuf.Duration{seconds: 1}
             })
  end

  test "collection 仮想 field の型検証と IGNORE_ALWAYS を維持する" do
    for ignore <- [:IGNORE_UNSPECIFIED, :IGNORE_ALWAYS] do
      item = %Buf.Validate.FieldRules{ignore: ignore, required: true}

      rules = %{
        "child" => item,
        "children" => %Buf.Validate.FieldRules{
          type: {:repeated, %Buf.Validate.RepeatedRules{items: item}}
        },
        "children_by_name" => %Buf.Validate.FieldRules{
          type: {:map, %Buf.Validate.MapRules{values: item}}
        }
      }

      message = runtime_probe(rules)

      child_module =
        Enum.find(DescriptorAdapter.describe(message.__struct__).fields, &(&1.name == "child")).reference

      child = struct!(child_module, code: "ok")
      valid = %{message | child: child, children: [child], children_by_name: %{"a" => child}}
      assert {:ok, ^valid} = Protovalidate.validate(valid)

      for {field, value} <- [
            child: %Legacy{},
            children: [%Legacy{}],
            children_by_name: %{"a" => %Legacy{}}
          ] do
        invalid = Map.put(valid, field, value)

        if ignore == :IGNORE_ALWAYS do
          assert {:ok, ^invalid} = Protovalidate.validate(invalid)
        else
          assert {:error, %Protovalidate.RuntimeError{}} = Protovalidate.validate(invalid)
        end
      end
    end
  end

  test "親 field の ignore と fail_fast は未走査の異型を検査しない" do
    ignored = %Buf.Validate.FieldRules{ignore: :IGNORE_ALWAYS}
    message = runtime_probe(Map.new(["child", "children", "children_by_name"], &{&1, ignored}))

    message = %{
      message
      | child: %Legacy{},
        children: [%Legacy{}],
        children_by_name: %{"a" => %Legacy{}}
    }

    assert {:ok, ^message} = Protovalidate.validate(message)

    assert {:error, %Protovalidate.ValidationError{violations: [_]}} =
             Protovalidate.validate(%RecursiveNode{child: %Legacy{}}, fail_fast: true)
  end

  test "正しい再帰型は runtime descriptor でも子と collection を検証できる" do
    child = %RecursiveNode{code: "ok"}

    message = %RecursiveNode{
      code: "ok",
      child: child,
      children: [child],
      signed_children: %{1 => child}
    }

    for value <- [message, decode(message)] do
      assert {:ok, ^value} = Protovalidate.validate(value)
    end
  end

  test "wrapper は unwrap 前に宣言型を照合する" do
    rules = %Buf.Validate.FieldRules{type: {:int32, %Buf.Validate.Int32Rules{const: 7}}}

    message =
      runtime_probe(%{"created_at" => rules}, %{"created_at" => ".google.protobuf.Int32Value"})

    field =
      Enum.find(DescriptorAdapter.describe(message.__struct__).fields, &(&1.name == "created_at"))

    valid = %{message | created_at: struct!(field.reference, value: 7)}
    assert {:ok, ^valid} = Protovalidate.validate(valid)

    for wrong <- [%Google.Protobuf.Int64Value{value: 7}, %{value: 7}] do
      assert {:error, %Protovalidate.RuntimeError{}} =
               Protovalidate.validate(%{message | created_at: wrong})
    end
  end

  defp runtime_probe(rules, references \\ %{}) do
    set = fdset()
    [fixture | rest] = set.file

    messages =
      Enum.map(fixture.message_type, fn
        %{name: "Probe"} = descriptor ->
          %{
            descriptor
            | field:
                Enum.map(descriptor.field, fn field ->
                  field = %{field | type_name: Map.get(references, field.name, field.type_name)}

                  case Map.fetch(rules, field.name) do
                    {:ok, rule} ->
                      options =
                        Google.Protobuf.FieldOptions.put_extension(
                          %Google.Protobuf.FieldOptions{},
                          Buf.Validate.PbExtension,
                          :field,
                          rule
                        )

                      %{field | options: options}

                    :error ->
                      field
                  end
                end)
          }

        descriptor ->
          descriptor
      end)

    set = %{set | file: [%{fixture | message_type: messages} | rest]}
    set = set |> FileDescriptorSet.encode() |> FileDescriptorSet.decode()

    message =
      RuntimeDescriptorAdapter.decode(set, %Any{
        type_url: "type.googleapis.com/acme.descriptor.v1.Probe",
        value: <<>>
      })

    %{message | implicit_string: "ab", contact: {:email, "a"}}
  end

  defp shape(field) do
    field
    |> Map.from_struct()
    |> Map.delete(:reference)
    |> Map.update!(:map_key_field, &nested_shape/1)
    |> Map.update!(:map_value_field, &nested_shape/1)
  end

  defp nested_shape(nil), do: nil
  defp nested_shape(field), do: shape(field)

  defp semantic_field(name, number, presence \\ nil) do
    options =
      if presence,
        do: %FieldOptions{features: %FeatureSet{field_presence: presence}},
        else: nil

    %FieldDescriptorProto{
      name: name,
      json_name: name,
      number: number,
      label: :LABEL_OPTIONAL,
      type: :TYPE_STRING,
      options: options
    }
  end

  defp decode(%module{} = message) do
    RuntimeDescriptorAdapter.decode(fdset(), %Any{
      type_url: "type.googleapis.com/" <> module.full_name(),
      value: module.encode(message)
    })
  end

  defp fdset do
    %FileDescriptorSet{
      file: [
        %FileDescriptorProto{
          name: "fixture.proto",
          package: "acme.descriptor.v1",
          syntax: "proto3",
          message_type: Enum.map([Probe, Child, Grandchild, RecursiveNode], & &1.descriptor())
        },
        %FileDescriptorProto{
          name: "wkt.proto",
          package: "google.protobuf",
          syntax: "proto3",
          message_type:
            Enum.map(
              [
                Google.Protobuf.Any,
                Google.Protobuf.Timestamp,
                Google.Protobuf.Duration,
                Google.Protobuf.FieldMask,
                Google.Protobuf.Int32Value
              ],
              & &1.descriptor()
            )
        }
      ]
    }
  end
end
