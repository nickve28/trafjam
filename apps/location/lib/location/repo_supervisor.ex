defmodule Location.RepoSupervisor do
  use Supervisor

  @pool_name :location

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init({amount_of_children, location_data}) when is_integer(amount_of_children) and amount_of_children > 0 do
    pool_options = [
      name: {:local, @pool_name},
      worker_module: Location.Repo,
      size: amount_of_children,
      max_overflow: amount_of_children * 2
    ]

    children = [
      :poolboy.child_spec(@pool_name, pool_options, location_data)
    ]

    opts = [
      strategy: :one_for_one
    ]
    supervise(children, opts)
  end
end