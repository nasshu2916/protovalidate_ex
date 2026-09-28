defmodule Protovalidate.TelemetryBoundaryTest do
  use ExUnit.Case, async: false

  alias Protovalidate.{ValidationError, Validator}

  defmodule InvalidDescriptor do
    defstruct []
    def descriptor, do: raise("invalid descriptor")
  end

  setup do
    id = "telemetry-boundary-#{System.unique_integer([:positive])}"

    :ok =
      :telemetry.attach_many(
        id,
        [
          [:protovalidate, :call, :total, :stop],
          [:protovalidate, :call, :compile, :stop],
          [:protovalidate, :call, :evaluate, :stop],
          [:protovalidate, :message, :stop]
        ],
        &__MODULE__.record/4,
        self()
      )

    on_exit(fn -> :telemetry.detach(id) end)
    :ok
  end

  def record(event, measurements, metadata, owner),
    do: send(owner, {:event, event, measurements, metadata})

  test "cold と warm の公開呼び出しを一度ずつ計測する" do
    validator = Validator.new()
    message = %Acme.Descriptor.V1.Legacy{}

    for _ <- 1..2 do
      assert {:ok, ^message} = Validator.validate(validator, message)

      assert_receive {:event, [:protovalidate, :call, :compile, :stop],
                      %{duration: compile_duration}, %{outcome: :ok}}

      assert_receive {:event, [:protovalidate, :call, :evaluate, :stop],
                      %{duration: evaluate_duration}, %{outcome: :ok}}

      assert_receive {:event, [:protovalidate, :call, :total, :stop], %{duration: total_duration},
                      %{outcome: :ok}}

      assert compile_duration >= 0 and evaluate_duration >= 0 and total_duration >= 0
    end

    refute_receive {:event, [:protovalidate, :call, :total, :stop], _, _}
  end

  test "違反とコンパイル失敗の結果を値なしで記録する" do
    validator = Validator.new()
    secret = "private-input-value"
    message = %Acme.Descriptor.V1.Probe{implicit_string: "", contact: {:email, secret}}

    assert {:error, %ValidationError{}} = Validator.validate(validator, message)

    assert_receive {:event, [:protovalidate, :call, :total, :stop], _,
                    %{outcome: :violation} = metadata}

    refute inspect(metadata) =~ secret

    assert {:error, %Protovalidate.CompilationError{}} =
             Validator.validate(validator, %InvalidDescriptor{})

    assert_receive {:event, [:protovalidate, :call, :compile, :stop], _,
                    %{outcome: :compile_error}}

    assert_receive {:event, [:protovalidate, :call, :total, :stop], _, %{outcome: :compile_error}}
  end

  test "子 message を scope で区別し、全体イベントを重複させない" do
    validator = Validator.new()

    message = %Acme.Descriptor.V1.Probe{
      implicit_string: "allowed",
      contact: {:email, "a@example.com"},
      child: %Acme.Descriptor.V1.Child{code: "ok"}
    }

    assert {:ok, ^message} = Validator.validate(validator, message)
    assert_receive {:event, [:protovalidate, :message, :stop], _, %{scope: :child}}
    assert_receive {:event, [:protovalidate, :message, :stop], _, %{scope: :root}}
    assert_receive {:event, [:protovalidate, :call, :total, :stop], _, %{outcome: :ok}}
    refute_receive {:event, [:protovalidate, :call, :total, :stop], _, _}
  end

  test "入力エラーも全体計測に含める" do
    assert {:error, %Protovalidate.RuntimeError{code: :invalid_message}} =
             Validator.validate(Validator.new(), :invalid)

    assert_receive {:event, [:protovalidate, :call, :total, :stop], _,
                    %{message_module: nil, outcome: :runtime_error}}
  end

  test "同時 cache miss の各公開呼び出しを一度ずつ計測する" do
    validator = Validator.new()
    message = %Acme.Descriptor.V1.Legacy{}

    tasks = for _ <- 1..8, do: Task.async(fn -> Validator.validate(validator, message) end)
    assert Enum.all?(Task.await_many(tasks), &match?({:ok, ^message}, &1))

    for _ <- 1..8 do
      assert_receive {:event, [:protovalidate, :call, :total, :stop], _, %{outcome: :ok}}
    end

    refute_receive {:event, [:protovalidate, :call, :total, :stop], _, _}
  end
end
