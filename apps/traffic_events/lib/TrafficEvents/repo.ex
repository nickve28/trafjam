defmodule TrafficEvents.Repo do
  use GenServer
  import SweetXml

  @event_adapter TrafficEvents.Adapters.Event

  @situation_path "//SOAP:Envelope/SOAP:Body/d2LogicalModel/payloadPublication/situation"
  @location_path "//situationRecord/groupOfLocations/alertCLinear"
  @abnormal_traffic "situationRecord[@xsi:type='AbnormalTraffic' or @xsi:type='RoadOrCarriagewayOrLaneManagement']"

  @five_min 1000 * 60 * 5

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    send(self(), :load_data)
    {:ok, []}
  end

  def list do
    GenServer.call(__MODULE__, :list)
  end

  def handle_call(:list, _from, events) do
    {:reply, events, events}
  end

  def handle_info(:load_data, _) do
    {:ok, events} = @event_adapter.list
    new_state = events
    |> xmap(
      events: [
        ~x"#{@situation_path}/#{@abnormal_traffic}"l,
        type: ~x"./abnormalTrafficType/text()"s,
        cause_type: ~x"./cause/causeType/text()"s,
        causes: ~x"./cause/causeDescription/values/value/text()"ls,
        start: ~x"./groupOfLocations/alertCLinear/alertCMethod4PrimaryPointLocation/alertCLocation/specificLocation/text()"s,
        end: ~x"./groupOfLocations/alertCLinear/alertCMethod4SecondaryPointLocation/alertCLocation/specificLocation/text()"s
      ]
    )
    |> Map.get(:events)

    Process.send_after(self(), :load_data, @five_min)
    {:noreply, new_state}
  end
end