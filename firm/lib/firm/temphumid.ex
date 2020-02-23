defmodule Firm.TempHumid do
  use GenServer
  require Logger

  @interval 1_000   # 1 sec
  defstruct [:dht, :temp, :humidity]
  alias GrovePi.{Digital, DHT}

  def start_link(pin) do
    GenServer.start_link(__MODULE__, pin, name: __MODULE__)
  end

  def init(dht_pin) do
    state = %Firm.TempHumid{dht: dht_pin, temp: 0, humidity: 0}
    Process.send_after(self(), :tick, @interval)
    #DHT.subscribe(dht_pin, :changed)
    {:ok, state}
  end
  def get_temphumid() do
    state = GenServer.call(__MODULE__, :read)
    state.temp <> state.humidity
  end

  def handle_info({_pin, :changed, %{temp: temp, humidity: humidity}}, state) do
    temp = format_temp(temp)
    humidity = format_humidity(humidity)
    state = %{state | temp: temp, humidity: humidity}
    Logger.debug(temp <> " " <> humidity)
    {:noreply, state}
  end

  def handle_info(:kick, state) do
    Process.send_after(self(), :tick, @interval)
    {:noreply, state}
  end

  def handle_call(:read, _from, state) do
    { :reply, state, state}
  end
 
  defp format_temp(temp) do
    "temp: #{Float.to_string(temp)}"
  end

  defp format_humidity(humidity) do
    "Humidity: #{Float.to_string(humidity)}%"
  end
end 