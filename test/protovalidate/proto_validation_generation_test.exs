defmodule Protovalidate.ProtoValidationGenerationTest do
  use ExUnit.Case, async: true

  @fixture_root Path.expand("../proto", __DIR__)

  describe "公式サンプルのバリデーション注釈" do
    test "descriptor に生成される" do
      protoc = System.find_executable("protoc") || flunk("protoc が見つかりません")
      protobuf_include = Path.expand("../include", Path.dirname(protoc))
      descriptor_path = Path.join(tmp_dir!(), "user.pb")
      user_proto = Path.join(@fixture_root, "acme/user/v1/user.proto")

      {compile_output, 0} =
        System.cmd(
          protoc,
          [
            "--proto_path",
            @fixture_root,
            "--proto_path",
            protobuf_include,
            "--descriptor_set_out",
            descriptor_path,
            "--include_imports",
            "--retain_options",
            user_proto
          ],
          stderr_to_stdout: true
        )

      assert compile_output == ""

      descriptor =
        decode_descriptor!(
          protoc,
          [
            "--proto_path",
            @fixture_root,
            "--proto_path",
            protobuf_include,
            "--decode=google.protobuf.FileDescriptorSet",
            Path.join(protobuf_include, "google/protobuf/descriptor.proto"),
            Path.join(@fixture_root, "buf/validate/validate.proto")
          ],
          descriptor_path
        )

      assert descriptor =~ "name: \"acme/user/v1/user.proto\""
      assert descriptor =~ "name: \"id\""
      assert descriptor =~ "name: \"age\""
      assert descriptor =~ "name: \"email\""
      assert descriptor =~ "name: \"first_name\""
      assert descriptor =~ "name: \"last_name\""
      assert descriptor =~ "[buf.validate.field] {"
      assert descriptor =~ "uuid: true"
      assert descriptor =~ "lte: 150"
      assert descriptor =~ "email: true"
      assert descriptor =~ "max_len: 64"
      assert descriptor =~ "[buf.validate.message] {"
      assert descriptor =~ "id: \"first_name_requires_last_name\""
    end
  end

  defp tmp_dir! do
    path = Path.join(System.tmp_dir!(), "protovalidate-#{System.unique_integer([:positive])}")
    File.mkdir_p!(path)
    path
  end

  defp decode_descriptor!(protoc, args, input_path) do
    command =
      Enum.join([shell_escape(protoc) | Enum.map(args, &shell_escape/1)], " ") <>
        " < " <> shell_escape(input_path)

    {descriptor, 0} = System.cmd("/bin/sh", ["-c", command], stderr_to_stdout: true)
    descriptor
  end

  defp shell_escape(value) do
    "'" <> String.replace(value, "'", "'\\\"'\\\"'") <> "'"
  end
end
