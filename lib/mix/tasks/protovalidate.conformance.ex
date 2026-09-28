defmodule Mix.Tasks.Protovalidate.Conformance do
  @shortdoc "Process a Protovalidate conformance request from stdin and write the response to stdout"

  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run("app.start")
    Protovalidate.Conformance.Executor.run()
  end
end
