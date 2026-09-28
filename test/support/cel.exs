defmodule Protovalidate.TestCEL do
  @behaviour Protovalidate.CEL

  @impl true
  def compile(%{expression: "pid"}, _environment, _options), do: {:ok, self()}

  def compile(%{expression: "slow_compile"}, _environment, _options) do
    Process.sleep(100)
    {:ok, "true"}
  end

  def compile(%{expression: "slow_compile_default"}, _environment, _options) do
    Process.sleep(1_100)
    {:ok, "true"}
  end

  def compile(%{expression: "heap"}, _environment, _options) do
    100_000 = :value |> List.duplicate(100_000) |> length()
    {:ok, "heap"}
  end

  def compile(%{expression: "invalid"}, _environment, _options), do: {:error, "syntax error"}

  def compile(rule, _environment, options) do
    case Keyword.get(options, :compile_barrier) do
      {parent, _expected} when is_pid(parent) ->
        send(parent, {:cel_compile, self()})

        receive do
          :continue_compile -> :ok
        end

      nil ->
        :ok
    end

    {:ok, rule.expression}
  end

  @impl true
  def evaluate("result", _environment, options), do: {:ok, Keyword.fetch!(options, :result)}

  def evaluate("delay_true", _environment, _options) do
    Process.sleep(20)
    {:ok, true}
  end

  def evaluate(owner, _environment, _options) when is_pid(owner), do: {:ok, self() != owner}

  def evaluate("slow_default", _environment, _options) do
    Process.sleep(1_100)
    {:ok, true}
  end

  def evaluate("heap", _environment, _options) do
    100_000 = :value |> List.duplicate(100_000) |> length()
    {:ok, true}
  end

  def evaluate("false", _environment, _options), do: {:ok, false}

  def evaluate("track", %{scope: scope}, options) do
    send(Keyword.fetch!(options, :parent), {:cel_evaluate, scope})
    {:ok, false}
  end

  def evaluate("not_boolean", _environment, _options), do: {:ok, :invalid}
  def evaluate("slow", _environment, _options), do: Process.sleep(100)
  def evaluate("predefined_false", %{this: "invalid", rule: true}, _options), do: {:ok, false}

  def evaluate("!has(this.first_name) || has(this.last_name)", %{this: message}, _options) do
    {:ok, message.first_name == "" or message.last_name != ""}
  end

  def evaluate(_expression, _environment, _options), do: {:ok, true}
end

defmodule Protovalidate.TestPredefinedExtension do
  use Protobuf, protoc_gen_elixir_version: "0.17.0"

  extend(Buf.Validate.StringRules, :required_value, 1001, optional: true, type: :bool)
end

defmodule Protovalidate.FailingCEL do
  @behaviour Protovalidate.CEL

  @impl true
  def compile(_rule, _environment, _options), do: {:error, "compile failure"}

  @impl true
  def evaluate(_expression, _environment, _options), do: {:ok, true}
end
