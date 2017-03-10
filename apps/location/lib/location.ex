defmodule Location do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Location.Supervisor, [amount_of_children: 5], [])
    ]

    opts = [strategy: :one_for_one, name: Location]
    Supervisor.start_link(children, opts)
  end
end
