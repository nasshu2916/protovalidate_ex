defmodule Protovalidate.ErrorPrivacyTest do
  use ExUnit.Case, async: false

  import ExUnit.CaptureLog

  @secret "audit-secret-marker"
  @events [
    [:protovalidate, :plan_cache, :miss],
    [:protovalidate, :plan_cache, :hit],
    [:protovalidate, :validation, :stop]
  ]

  defmodule SecretError do
    defexception [:message]

    # 例外の整形自体にも副作用があり得るため、呼び出されないことを確認する。
    def message(_error), do: raise("audit-secret-marker: exception formatting")
  end

  defmodule Adapter do
    @behaviour Protovalidate.CEL
    def compile(_rule, _environment, options) do
      if options[:stage] == :compile, do: result(options), else: {:ok, :compiled}
    end

    def evaluate(_expression, _environment, options), do: result(options)

    defp result(options) do
      secret = options[:secret]

      case options[:failure] do
        :error -> {:error, %{token: secret}}
        :malformed -> %{token: secret}
        :invalid_ok -> {:ok, %{token: secret}}
        :raise -> raise secret
        :custom_exception -> raise SecretError, message: secret
        :throw -> throw({:secret, secret})
        :exit -> exit({:secret, secret})
        :killed -> Process.exit(self(), :kill)
        :string -> {:ok, secret}
      end
    end
  end

  setup do
    id = {__MODULE__, make_ref()}
    :ok = :telemetry.attach_many(id, @events, &__MODULE__.event/4, self())
    on_exit(fn -> :telemetry.detach(id) end)
    :ok
  end

  def event(event, measurements, metadata, parent),
    do: send(parent, {:privacy_event, event, measurements, metadata})

  test "非 struct 入力を公開例外と計測へ含めない" do
    logs =
      capture_log(fn ->
        input = %{token: @secret}
        assert {:error, error} = Protovalidate.validate(input)
        assert_safe(error, Protovalidate.RuntimeError)
        raised = assert_raise Protovalidate.RuntimeError, fn -> Protovalidate.validate!(input) end
        assert raised == error
        validator = Protovalidate.new()

        try do
          assert {:error, ^error} = Protovalidate.Validator.validate(validator, input)
        after
          Protovalidate.Validator.close(validator)
        end

        assert drain_events() == []
      end)

    refute logs =~ @secret
  end

  for stage <- [:compile, :evaluate] do
    test "#{stage} の障害情報を公開しない（既定でも監視実行）" do
      assert_private_failure(unquote(stage))
    end
  end

  defp assert_private_failure(stage) do
    error_type =
      if stage == :compile, do: Protovalidate.CompilationError, else: Protovalidate.RuntimeError

    failures = [:error, :malformed, :raise, :custom_exception, :throw, :exit]
    failures = if stage == :evaluate, do: [:invalid_ok | failures], else: failures
    failures = [:killed | failures]

    logs =
      capture_log(fn ->
        for failure <- failures do
          options = [stage: stage, failure: failure, secret: @secret]

          config = [cel: {Adapter, options}]
          assert {:error, error} = Protovalidate.validate(message(), config)
          assert_safe(error, error_type)

          code =
            case failure do
              :error -> "adapter_error"
              failure when failure in [:malformed, :invalid_ok] -> "invalid_result"
              failure when failure in [:raise, :custom_exception] -> "exception"
              :killed -> "process_exit"
              failure -> Atom.to_string(failure)
            end

          assert Exception.message(error) =~ code
          raised = assert_raise error_type, fn -> Protovalidate.validate!(message(), config) end
          assert raised == error
          events = drain_events()
          refute inspect(events) =~ @secret

          assert Enum.count(events, fn {event, _, _} ->
                   event == [:protovalidate, :plan_cache, :miss]
                 end) == 2

          stops =
            Enum.filter(events, fn {event, _, _} ->
              event == [:protovalidate, :validation, :stop]
            end)

          assert length(stops) == if(stage == :evaluate, do: 2, else: 0)

          for {_, measurements, metadata} <- stops do
            assert %{duration: duration, violations: 0} = measurements
            assert is_integer(duration)
            assert metadata == %{message_module: Acme.User.V1.User, outcome: :error}
          end
        end
      end)

    refute logs =~ @secret
  end

  test "正常に返した CEL 文字列は意図した違反メッセージとして保持する" do
    for limits <- [[], [compile_timeout: 1_000, timeout: 1_000]] do
      options = [stage: :evaluate, failure: :string, secret: @secret] ++ limits

      assert {:error, %Protovalidate.ValidationError{violations: [violation]}} =
               Protovalidate.validate(message(), cel: {Adapter, options})

      assert violation.message == @secret
      refute inspect(drain_events()) =~ @secret
    end
  end

  defp assert_safe(error, type) do
    assert error.__struct__ == type
    refute Exception.message(error) =~ @secret
    refute inspect(error) =~ @secret
  end

  defp message do
    %Acme.User.V1.User{
      id: "123e4567-e89b-12d3-a456-426614174000",
      email: "ada@example.com",
      first_name: @secret
    }
  end

  defp drain_events do
    receive do
      {:privacy_event, event, measurements, metadata} ->
        [{event, measurements, metadata} | drain_events()]
    after
      0 -> []
    end
  end
end
