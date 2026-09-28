defmodule PhoenixSample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhoenixSampleWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:phoenix_sample, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhoenixSample.PubSub},
      # Start a worker by calling: PhoenixSample.Worker.start_link(arg)
      # {PhoenixSample.Worker, arg},
      # Start to serve requests, typically the last entry
      PhoenixSampleWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixSample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixSampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
