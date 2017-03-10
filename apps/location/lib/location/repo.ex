defmodule Location.Repo do
  use GenServer

  def start_link(location_data) do
    GenServer.start_link(__MODULE__, location_data, [])
  end

  def init(location_data) do
    location_data = Enum.reduce(location_data, [], fn %{"loc_nr" => loc_nr} = location, memo ->
      [{loc_nr, location} | memo]
    end)
    |> Enum.into(%{})
    {:ok, location_data}
  end

  def get_all(pid) when is_pid(pid) do
    GenServer.call(pid, :get_all)
  end

  def get_by_id(pid, id) when is_binary(id) and is_pid(pid) do
      GenServer.call(pid, {:get_by_id, id})
  end

  def handle_call(:get_all, _from, locations), do: {:reply, Map.values(locations), locations}

  def handle_call({:get_by_id, id}, _from, locations), do: {:reply, locations[id], locations}
end