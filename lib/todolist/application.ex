defmodule Todolist.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TodolistWeb.Telemetry,
      Todolist.Repo,
      {DNSCluster, query: Application.get_env(:todolist, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Todolist.PubSub},
      # Start a worker by calling: Todolist.Worker.start_link(arg)
      # {Todolist.Worker, arg},
      # Start to serve requests, typically the last entry
      TodolistWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Todolist.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TodolistWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
