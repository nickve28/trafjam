defmodule Location.Service do
  @pool_name :location

  def list do
    :poolboy.transaction(@pool_name, fn pid ->
      Location.Repo.get_all(pid)
    end)
  end

  def get(id) do
    :poolboy.transaction(@pool_name, fn pid ->
      Location.Repo.get_by_id(pid, id)
    end)
  end
end