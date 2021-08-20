defmodule Poller do
  use Application
  alias Poller.PollSupervisor

  # start call back function which is entry point
  # for poller project and start supervision tree
  def start(_type, _args) do
    children = [
      PollSupervisor,
      {Phoenix.PubSub.PG2, name: Poller.PubSub.server_name()}
    ]

    opts = [strategy: :one_for_one, name: Poller.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
