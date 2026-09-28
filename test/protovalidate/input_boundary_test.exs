defmodule Protovalidate.InputBoundaryTest do
  use ExUnit.Case, async: true

  import Protovalidate.TestRules

  alias Protovalidate.{Plan, RuntimeError}

  defmodule RegistryFailure do
    @behaviour Protovalidate.PredefinedRuleRegistry

    def resolve(_number, value, _rule_type) do
      case value do
        :raise -> raise "private"
        :throw -> throw(:private)
        :exit -> exit(:private)
        :invalid -> :invalid
        :error -> {:error, %{private: true}}
      end
    end
  end

  defmodule InvalidDefinition do
    @behaviour Protovalidate.CEL
    def compile(_rule, _environment, _options), do: {:error, :private}
    def evaluate(_expression, _environment, _options), do: {:ok, true}
  end

  test "手動構築された scalar の型不整合を入力境界で正規化する" do
    message = %Acme.User.V1.User{first_name: 123}

    assert {:error, error} = Protovalidate.validate(message)
    assert %RuntimeError{code: :invalid_input_type, stage: :input} = error
    assert Exception.message(error) == "input value does not match its Protobuf field type"
    refute inspect(error) =~ "123"
  end

  test "repeated と map の形状および要素型を検査する" do
    repeated =
      field(:TYPE_STRING, name: "labels", repeated?: true, item_type: :TYPE_STRING)
      |> plan(%{
        type: {:repeated, %{min_items: 1, items: %{type: {:string, %{min_len: 1}}}}}
      })

    map =
      field(:TYPE_MESSAGE,
        name: "scores",
        map?: true,
        repeated?: true,
        map_key: :TYPE_STRING,
        map_value: :TYPE_UINT32
      )
      |> plan(%{
        type:
          {:map,
           %{
             min_pairs: 1,
             keys: %{type: {:string, %{min_len: 1}}},
             values: %{type: {:uint32, %{gte: 0}}}
           }}
      })

    for {validation_plan, message} <- [
          {repeated, %Acme.Descriptor.V1.Probe{labels: :invalid}},
          {repeated, %Acme.Descriptor.V1.Probe{labels: [123]}},
          {map, %Acme.Descriptor.V1.Probe{scores: :invalid}},
          {map, %Acme.Descriptor.V1.Probe{scores: %{1 => 1}}},
          {map, %Acme.Descriptor.V1.Probe{scores: %{"key" => "invalid"}}}
        ] do
      assert %RuntimeError{code: :invalid_input_type, stage: :input} =
               assert_raise(RuntimeError, fn ->
                 Plan.evaluate(validation_plan, message, fail_fast: false)
               end)
    end
  end

  test "不正な enum atom を入力境界で拒否する" do
    enum_field =
      field(:TYPE_ENUM,
        name: "status",
        reference: Acme.Descriptor.V1.Probe.Status,
        enum_values: [0, 1]
      )

    validation_plan = plan(enum_field, %{type: {:enum, %{defined_only: true}}})
    message = %Acme.Descriptor.V1.Probe{status: :NOT_A_STATUS}

    assert %RuntimeError{code: :invalid_input_type, stage: :input} =
             assert_raise(RuntimeError, fn ->
               Plan.evaluate(validation_plan, message, fail_fast: false)
             end)
  end

  test "registry callback の raise、throw、exit、不正戻り値、error を固定結果へ変換する" do
    expected = %{
      raise: "registry callback raised an exception",
      throw: "registry callback threw a value",
      exit: "registry callback exited",
      invalid: "registry callback returned an invalid result",
      error: "registry callback failed"
    }

    for {failure, message} <- expected do
      assert {:error, ^message} =
               Protovalidate.PredefinedRuleRegistry.resolve(
                 RegistryFailure,
                 1_000,
                 failure,
                 :rules
               )
    end
  end

  test "不正な validator 設定は ArgumentError、定義エラーは CompilationError とする" do
    assert_raise ArgumentError, fn -> Protovalidate.new(cel: 123) end
    assert_raise ArgumentError, fn -> Protovalidate.new(cel: String) end

    assert {:error, %Protovalidate.CompilationError{stage: :compile}} =
             Protovalidate.validate(%Acme.User.V1.User{}, cel: InvalidDefinition)
  end
end
