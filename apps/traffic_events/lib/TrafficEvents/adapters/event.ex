defmodule TrafficEvents.Adapters.Event do
  @url "http://opendata.ndw.nu/gebeurtenisinfo.xml.gz"

  def list do
    IO.puts "Loading data from #{@url}..."
    {:ok, %{body: body}} = HTTPoison.get(@url)

    {:ok, :zlib.gunzip(body)}
  end
end
