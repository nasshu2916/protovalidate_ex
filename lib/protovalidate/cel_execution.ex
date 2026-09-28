defmodule Protovalidate.CELExecution do
  @moduledoc false

  # adapter の戻り値と実行境界の失敗を分け、例外の内容は文字列化しない。
  def invoke(function) do
    {:ok, function.()}
  rescue
    _error -> {:error, :exception}
  catch
    :throw, _reason -> {:error, :throw}
    :exit, _reason -> {:error, :exit}
  end

  def run(function, timeout, max_heap_size) do
    parent = self()
    ref = make_ref()

    {pid, monitor} =
      :erlang.spawn_opt(
        fn ->
          result = invoke(function)

          send(parent, {ref, result})
        end,
        [:monitor, max_heap_size: %{size: max_heap_size, kill: true, error_logger: false}]
      )

    receive do
      {^ref, result} ->
        Process.demonitor(monitor, [:flush])
        result

      {:DOWN, ^monitor, :process, ^pid, _reason} ->
        {:error, :process_exit}
    after
      timeout ->
        Process.exit(pid, :kill)

        receive do
          {:DOWN, ^monitor, :process, ^pid, _reason} -> :ok
        end

        # DOWN より先に送られた応答を回収し、次の検証の mailbox に残さない。
        receive do
          {^ref, _result} -> :ok
        after
          0 -> :ok
        end

        {:error, :timeout}
    end
  end
end
