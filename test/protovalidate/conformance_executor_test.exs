defmodule Protovalidate.ConformanceExecutorTest do
  use ExUnit.Case, async: true

  alias Buf.Validate.Conformance.Harness.{
    TestConformanceRequest,
    TestConformanceResponse
  }

  alias Google.Protobuf.{
    Any,
    DescriptorProto,
    FeatureSet,
    FieldDescriptorProto,
    FieldOptions,
    FileDescriptorProto,
    FileDescriptorSet
  }

  alias Protovalidate.Conformance.{Executor, RuntimeDescriptorAdapter, ViolationCodec}
  alias Protovalidate.DescriptorAdapter

  test "wire format の request を runtime descriptor で解決し、response を返す" do
    request = %TestConformanceRequest{
      fdset: %FileDescriptorSet{
        file: [
          %FileDescriptorProto{
            name: "conformance.proto",
            package: "conformance",
            syntax: "proto3",
            message_type: [%DescriptorProto{name: "Input"}]
          }
        ]
      },
      cases: %{
        "empty" => %Any{type_url: "type.googleapis.com/conformance.Input", value: <<>>}
      }
    }

    response =
      request
      |> TestConformanceRequest.encode()
      |> TestConformanceRequest.decode()
      |> Executor.execute()

    assert %TestConformanceResponse{results: %{"empty" => %{result: {:success, true}}}} = response

    assert ^response =
             response |> TestConformanceResponse.encode() |> TestConformanceResponse.decode()
  end

  test "同じ型名でも異なる descriptor set を混在させない" do
    first = descriptor_set([])

    second =
      descriptor_set([
        %Google.Protobuf.FieldDescriptorProto{
          name: "value",
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_STRING,
          json_name: "value"
        }
      ])

    any = %Any{type_url: "type.googleapis.com/conformance.Input", value: <<>>}

    assert [] = RuntimeDescriptorAdapter.decode(first, any).__struct__.descriptor().field

    assert [%{name: "value", number: 1}] =
             RuntimeDescriptorAdapter.decode(second, any).__struct__.descriptor().field
  end

  test "同じ runtime 定義の並行生成は同じ module に収束する" do
    original = descriptor_set([])
    [file] = original.file
    fdset = %{original | file: [%{file | package: "concurrent"}]}
    any = %Any{type_url: "type.googleapis.com/concurrent.Input", value: <<>>}

    tasks =
      for _ <- 1..4 do
        Task.async(fn ->
          receive do
            :decode -> RuntimeDescriptorAdapter.decode(fdset, any).__struct__
          end
        end)
      end

    Enum.each(tasks, &send(&1.pid, :decode))
    assert [_module] = tasks |> Enum.map(&Task.await(&1, 30_000)) |> Enum.uniq()
  end

  test "runtime descriptor の group field を再帰的に検証する" do
    group_field_rules =
      FieldOptions.put_extension(
        %FieldOptions{},
        Buf.Validate.PbExtension,
        :field,
        %Buf.Validate.FieldRules{
          type: {:string, %Buf.Validate.StringRules{const: "ok"}}
        }
      )

    group = %DescriptorProto{
      name: "Optional",
      field: [
        %FieldDescriptorProto{
          name: "value",
          json_name: "value",
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_STRING,
          options: group_field_rules
        }
      ]
    }

    input = %DescriptorProto{
      name: "Input",
      nested_type: [group],
      field: [
        %FieldDescriptorProto{
          name: "optional",
          json_name: "optional",
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_GROUP,
          type_name: ".runtime.groups.Input.Optional"
        }
      ]
    }

    fdset = %FileDescriptorSet{
      file: [
        %FileDescriptorProto{
          name: "runtime_groups.proto",
          package: "runtime.groups",
          syntax: "proto2",
          message_type: [input]
        }
      ]
    }

    message =
      RuntimeDescriptorAdapter.decode(fdset, %Any{
        type_url: "type.googleapis.com/runtime.groups.Input",
        value: <<11, 10, 3, "bad", 12>>
      })

    assert message.optional.value == "bad"

    assert {:error, %Protovalidate.ValidationError{violations: [violation]}} =
             Protovalidate.validate(message)

    assert violation.rule_id == "string.const"
    assert violation.field_path.segments == [{:field, "optional"}, {:field, "value"}]

    assert %Buf.Validate.Violations{
             violations: [%{field: %{elements: [group_path, _value_path]}}]
           } =
             ViolationCodec.encode([violation], message.__struct__)

    assert group_path.field_type == :TYPE_GROUP
  end

  test "edition 2023 の DELIMITED と length-prefixed message を型と presence を保って decode する" do
    fdset = edition_message_descriptor_set()
    child_wire = <<10, 3, "foo">>

    populated =
      decode_edition_message(
        fdset,
        <<11, child_wire::binary, 12, 18, byte_size(child_wire), child_wire::binary>>
      )

    assert populated.delimited_child.value == "foo"
    assert populated.length_prefixed_child.value == "foo"

    fields =
      populated.__struct__
      |> Protovalidate.DescriptorAdapter.describe(
        extensions: [
          {:field, Buf.Validate.PbExtension, :field},
          {:message, Buf.Validate.PbExtension, :message},
          {:oneof, Buf.Validate.PbExtension, :oneof}
        ]
      )
      |> Map.fetch!(:fields)
      |> Map.new(&{&1.name, &1})

    assert %{
             type: :TYPE_MESSAGE,
             presence: :explicit,
             features: %{message_encoding: :DELIMITED, field_presence: :EXPLICIT}
           } = fields["delimited_child"]

    assert %{
             type: :TYPE_MESSAGE,
             presence: :explicit,
             features: %{message_encoding: :LENGTH_PREFIXED, field_presence: :EXPLICIT}
           } = fields["length_prefixed_child"]

    assert {:ok, ^populated} = Protovalidate.validate(populated)
  end

  test "edition 2023 nested required and ignore handle unset and default valued messages" do
    fdset = edition_message_descriptor_set()
    child_wire = <<10, 3, "foo">>
    lp_child = <<18, byte_size(child_wire), child_wire::binary>>

    unset_delimited = decode_edition_message(fdset, lp_child)
    assert unset_delimited.delimited_child == nil
    assert {:ok, ^unset_delimited} = Protovalidate.validate(unset_delimited)

    default_delimited = decode_edition_message(fdset, <<11, 12, lp_child::binary>>)
    assert default_delimited.delimited_child.value == nil

    assert {:error, %Protovalidate.ValidationError{violations: [violation]}} =
             Protovalidate.validate(default_delimited)

    assert violation.rule_id == "edition.delimited.child"
    assert violation.field_path == Protovalidate.FieldPath.new([{:field, "delimited_child"}])

    assert [
             %{
               field: %{
                 elements: [%{field_type: :TYPE_GROUP}]
               }
             }
           ] = ViolationCodec.encode([violation], default_delimited.__struct__).violations

    unset_required = decode_edition_message(fdset, <<>>)
    assert unset_required.length_prefixed_child == nil

    assert {:error, %Protovalidate.ValidationError{violations: [required]}} =
             Protovalidate.validate(unset_required)

    assert required.rule_id == "required"

    assert [
             %{
               field: %{
                 elements: [%{field_type: :TYPE_MESSAGE}]
               }
             }
           ] = ViolationCodec.encode([required], unset_required.__struct__).violations
  end

  test "edition LEGACY_REQUIRED tracks encoded scalar defaults without skipping validation" do
    fdset = edition_legacy_required_descriptor_set()
    present_defaults = decode_edition_legacy_required(fdset, <<8, 0, 18, 0>>)

    assert present_defaults.legacy_int == 0
    assert present_defaults.required_string == ""
    assert Protobuf.field_presence(present_defaults, :legacy_int) == :present
    assert Protobuf.field_presence(present_defaults, :required_string) == :present

    assert {:error, %Protovalidate.ValidationError{violations: [violation]}} =
             Protovalidate.validate(present_defaults)

    assert violation.rule_id == "int32.gt"

    missing_required = decode_edition_legacy_required(fdset, <<8, 0>>)
    assert Protobuf.field_presence(missing_required, :required_string) == :not_present

    assert {:error, %Protovalidate.ValidationError{violations: violations}} =
             Protovalidate.validate(missing_required)

    assert Enum.any?(violations, fn violation ->
             violation.rule_id == "required" and
               violation.field_path.segments == [{:field, "required_string"}]
           end)
  end

  test "proto2 custom defaults retain wire presence when absent and explicitly set values match" do
    fdset = proto2_defaults_descriptor_set()
    absent = decode_proto2_defaults(fdset, <<>>)
    explicitly_set = decode_proto2_defaults(fdset, <<10, 3, "foo", 18, 0>>)

    assert absent.value == explicitly_set.value
    assert absent.empty_default == explicitly_set.empty_default
    assert Protobuf.field_presence(absent, :value) == :maybe
    assert Protobuf.field_presence(explicitly_set, :value) == :maybe
    assert DescriptorAdapter.field_presence(absent, :value) == :not_present
    assert DescriptorAdapter.field_presence(explicitly_set, :value) == :present
    assert DescriptorAdapter.field_presence(absent, :empty_default) == :not_present
    assert DescriptorAdapter.field_presence(explicitly_set, :empty_default) == :present

    fields = DescriptorAdapter.describe(absent.__struct__).fields |> Map.new(&{&1.name, &1})
    assert fields["value"].default == "foo"
    assert fields["empty_default"].default == ""
  end

  test "未知の Any 型は conformance の予期しないエラー応答に変換する" do
    request = %TestConformanceRequest{
      fdset: descriptor_set([]),
      cases: %{
        "unknown" => %Any{type_url: "type.googleapis.com/conformance.Unknown", value: <<>>}
      }
    }

    assert %TestConformanceResponse{
             results: %{"unknown" => %{result: {:unexpected_error, message}}}
           } = Executor.execute(request)

    assert message =~ "conformance.Unknown"
  end

  test "descriptor set の predefined extension を wire から復号し registry で解決する" do
    Protobuf.load_extensions()

    annotation =
      FieldOptions.put_extension(
        %FieldOptions{},
        Buf.Validate.PbExtension,
        :predefined,
        %Buf.Validate.PredefinedRules{
          cel: [
            %Buf.Validate.Rule{
              id: "int64.even",
              expression: "!rule || this % 2 == 0",
              message: "must be even"
            }
          ]
        }
      )

    extension = %FieldDescriptorProto{
      name: "even",
      number: 1001,
      extendee: ".buf.validate.Int64Rules",
      label: :LABEL_OPTIONAL,
      type: :TYPE_BOOL,
      options: annotation
    }

    rules = %Buf.Validate.Int64Rules{__unknown_fields__: [{1001, 0, 1}]}

    options =
      FieldOptions.put_extension(
        %FieldOptions{},
        Buf.Validate.PbExtension,
        :field,
        %Buf.Validate.FieldRules{type: {:int64, rules}}
      )

    fdset = %FileDescriptorSet{
      file: [
        %FileDescriptorProto{
          name: "runtime_predefined.proto",
          package: "runtime.predefined",
          syntax: "proto2",
          extension: [extension],
          message_type: [
            %DescriptorProto{
              name: "Input",
              field: [
                %FieldDescriptorProto{
                  name: "value",
                  number: 1,
                  label: :LABEL_OPTIONAL,
                  type: :TYPE_INT64,
                  options: options
                }
              ]
            }
          ]
        }
      ]
    }

    response =
      Executor.execute(
        %TestConformanceRequest{
          fdset: fdset,
          cases: %{
            "invalid" => %Any{
              type_url: "type.googleapis.com/runtime.predefined.Input",
              value: <<8, 3>>
            },
            "valid" => %Any{
              type_url: "type.googleapis.com/runtime.predefined.Input",
              value: <<8, 4>>
            }
          }
        },
        cel: Protovalidate.CEL.Celixir
      )

    assert %{result: {:success, true}} = response.results["valid"]

    assert %{result: {:validation_error, %{violations: [violation]}}} =
             response.results["invalid"]

    assert violation.rule_id == "int64.even"

    assert [%{field_number: 4}, %{field_number: 1001, field_name: "[runtime.predefined.even]"}] =
             violation.rule.elements
  end

  defp descriptor_set(fields) do
    %FileDescriptorSet{
      file: [
        %FileDescriptorProto{
          name: "conformance.proto",
          package: "conformance",
          syntax: "proto3",
          message_type: [%DescriptorProto{name: "Input", field: fields}]
        }
      ]
    }
  end

  defp decode_edition_message(fdset, value) do
    RuntimeDescriptorAdapter.decode(fdset, %Any{
      type_url: "type.googleapis.com/runtime.edition.Input",
      value: value
    })
  end

  defp decode_edition_legacy_required(fdset, value) do
    RuntimeDescriptorAdapter.decode(fdset, %Any{
      type_url: "type.googleapis.com/runtime.edition.LegacyRequired",
      value: value
    })
  end

  defp decode_proto2_defaults(fdset, value) do
    RuntimeDescriptorAdapter.decode(fdset, %Any{
      type_url: "type.googleapis.com/runtime.proto2.Input",
      value: value
    })
  end

  defp proto2_defaults_descriptor_set do
    message = %DescriptorProto{
      name: "Input",
      field: [
        %FieldDescriptorProto{
          name: "value",
          json_name: "value",
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_STRING,
          default_value: "foo"
        },
        %FieldDescriptorProto{
          name: "empty_default",
          json_name: "emptyDefault",
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_STRING,
          default_value: ""
        }
      ]
    }

    %FileDescriptorSet{
      file: [
        %FileDescriptorProto{
          name: "proto2_defaults.proto",
          package: "runtime.proto2",
          syntax: "proto2",
          message_type: [message]
        }
      ]
    }
    |> FileDescriptorSet.encode()
    |> FileDescriptorSet.decode()
  end

  defp edition_message_descriptor_set do
    child = %DescriptorProto{
      name: "Child",
      field: [
        %FieldDescriptorProto{
          name: "value",
          json_name: "value",
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_STRING
        }
      ]
    }

    delimited_options =
      FieldOptions.put_extension(
        %FieldOptions{features: %FeatureSet{message_encoding: :DELIMITED}},
        Buf.Validate.PbExtension,
        :field,
        %Buf.Validate.FieldRules{
          ignore: :IGNORE_IF_ZERO_VALUE,
          cel: [
            %Buf.Validate.Rule{
              id: "edition.delimited.child",
              expression: "this.value == \"foo\""
            }
          ]
        }
      )

    required_options =
      FieldOptions.put_extension(
        %FieldOptions{},
        Buf.Validate.PbExtension,
        :field,
        %Buf.Validate.FieldRules{required: true}
      )

    input = %DescriptorProto{
      name: "Input",
      nested_type: [child],
      field: [
        %FieldDescriptorProto{
          name: "delimited_child",
          json_name: "delimitedChild",
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".runtime.edition.Input.Child",
          options: delimited_options
        },
        %FieldDescriptorProto{
          name: "length_prefixed_child",
          json_name: "lengthPrefixedChild",
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_MESSAGE,
          type_name: ".runtime.edition.Input.Child",
          options: required_options
        }
      ]
    }

    %FileDescriptorSet{
      file: [
        %FileDescriptorProto{
          name: "edition_message.proto",
          package: "runtime.edition",
          syntax: "editions",
          edition: :EDITION_2023,
          message_type: [input]
        }
      ]
    }
    |> FileDescriptorSet.encode()
    |> FileDescriptorSet.decode()
  end

  defp edition_legacy_required_descriptor_set do
    legacy_rules =
      FieldOptions.put_extension(
        %FieldOptions{features: %FeatureSet{field_presence: :LEGACY_REQUIRED}},
        Buf.Validate.PbExtension,
        :field,
        %Buf.Validate.FieldRules{
          ignore: :IGNORE_IF_ZERO_VALUE,
          type: {:int32, %Buf.Validate.Int32Rules{greater_than: {:gt, 0}}}
        }
      )

    required_rules =
      FieldOptions.put_extension(
        %FieldOptions{features: %FeatureSet{field_presence: :LEGACY_REQUIRED}},
        Buf.Validate.PbExtension,
        :field,
        %Buf.Validate.FieldRules{required: true}
      )

    input = %DescriptorProto{
      name: "LegacyRequired",
      field: [
        %FieldDescriptorProto{
          name: "legacy_int",
          json_name: "legacyInt",
          number: 1,
          label: :LABEL_OPTIONAL,
          type: :TYPE_INT32,
          options: legacy_rules
        },
        %FieldDescriptorProto{
          name: "required_string",
          json_name: "requiredString",
          number: 2,
          label: :LABEL_OPTIONAL,
          type: :TYPE_STRING,
          options: required_rules
        }
      ]
    }

    %FileDescriptorSet{
      file: [
        %FileDescriptorProto{
          name: "edition_legacy_required.proto",
          package: "runtime.edition",
          syntax: "editions",
          edition: :EDITION_2023,
          message_type: [input]
        }
      ]
    }
    |> FileDescriptorSet.encode()
    |> FileDescriptorSet.decode()
  end
end
