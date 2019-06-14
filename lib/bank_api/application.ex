defmodule BankAPI.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      supervisor(BankAPI.Repo, []),
      # Start the endpoint when the application starts
      supervisor(BankAPIWeb.Endpoint, []),
      # Starts a worker by calling: BankAPI.Worker.start_link(arg)
      # {BankAPI.Worker, arg},
      supervisor(BankAPI.Accounts.Supervisor, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BankAPI.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BankAPIWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
