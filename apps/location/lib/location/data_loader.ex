defmodule Location.DataLoader do
  use GenServer
  import Supervisor.Spec

  @file_name "./apps/location/data/locations.csv"

  def start_link(sup_process, amount_of_children) do
    GenServer.start_link(__MODULE__, {sup_process, amount_of_children})
  end

  def init({sup_process, amount_of_children}) do
    send(self, :load_data)
    {:ok, {sup_process, amount_of_children}}
  end

  def handle_info(:load_data, {sup_process, amount_of_children}) do
    location_data = File.stream!(@file_name)
    |> CSV.decode
    |> Enum.to_list
    |> parse_data
    |> List.flatten

    start_repo(sup_process, location_data, amount_of_children)

    {:noreply, {sup_process, amount_of_children}}
  end

  defp parse_data([columns | rows]) do
    lowercase_cols = columns
    |> Enum.map(&String.downcase/1)

    for row <- rows do
      Enum.zip(lowercase_cols, row)
      |> Enum.into(%{})
    end
  end

  defp start_repo(sup_process, location_data, amount_of_children) do
    IO.puts "DATA LOADER: starting repo pool..."
    Supervisor.start_child(sup_process, supervisor_spec(amount_of_children, location_data))
  end

  defp supervisor_spec(amount_of_children, location_data) do
    opts = [restart: :permanent]
    supervisor(Location.RepoSupervisor, [{amount_of_children, location_data}], opts)
  end
end