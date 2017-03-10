defmodule TrafficEvents.Service do
  import SweetXml

  def list do
    TrafficEvents.Repo.list
  end
end