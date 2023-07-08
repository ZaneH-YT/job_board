defmodule JobBoard.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      JobBoardWeb.Telemetry,
      # Start the Ecto repository
      JobBoard.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: JobBoard.PubSub},
      # Start Finch
      {Finch, name: JobBoard.Finch},
      # Start the Endpoint (http/https)
      JobBoardWeb.Endpoint
      # Start a worker by calling: JobBoard.Worker.start_link(arg)
      # {JobBoard.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: JobBoard.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    JobBoardWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
