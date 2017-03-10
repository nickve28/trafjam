defmodule TrafficEvents.Adapters.MockEvent do
  @file_name "./apps/traffic_events/data/files.xml"

  def list do
    File.read(@file_name)
  end
end