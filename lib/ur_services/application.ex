defmodule UrServices.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      UrServicesWeb.Telemetry,
      UrServices.Repo,
      {DNSCluster, query: Application.get_env(:ur_services, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: UrServices.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: UrServices.Finch},
      # Start a worker by calling: UrServices.Worker.start_link(arg)
      # {UrServices.Worker, arg},
      # Start to serve requests, typically the last entry
      UrServicesWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UrServices.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl Application
  def config_change(changed, _new, removed) do
    UrServicesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
