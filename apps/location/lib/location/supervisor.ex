defmodule Location.Supervisor do
  use Supervisor

  def start_link({:amount_of_children, amount_of_children}) do
    Supervisor.start_link(__MODULE__, [amount_of_children: amount_of_children])
  end

  def init(amount_of_children: amount_of_children) do
    children = [
      worker(Location.DataLoader, [self, amount_of_children])
    ]

    opts = [
      strategy: :one_for_one
    ]

    supervise(children, opts)
  end
end