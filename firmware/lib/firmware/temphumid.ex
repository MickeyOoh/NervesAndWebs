defmodule Firmware.TempHumid do
  use GenServer
  require Logger

  defstruct [:dht]
  alias GrovePi.{Digital, DHT}

  def start_link(pin) do
    IO.puts "start TempHumid -> #{pin}"
    GenServer.start_link(__MODULE__, pin)
    #DHT.start_link(pin)
  end

  def init(dht_pin) do
    #Digital.set_pin_mode(2, :output)
    state = %Firmware.TempHumid{dht: dht_pin}
    Logger.debug "TempHumid #{inspect :calendar.local_time}"
    DHT.subscribe(dht_pin, :changed)
    IO.inspect state
    {:ok, state}
  end

  def handle_info({_pin, :changed, %{temp: temp, humidity: humidity}}, state) do
    #Digital.write(2, 1)
    temp = format_temp(temp)
    humidity = format_humidity(humidity)

    Logger.debug(temp <> " " <> humidity)
    IO.puts temp <> " " <> humidity
    {:noreply, state}
  end

  def handle_info(message, state) do
    IO.inspect message
    {:noreply, state}
  end
  def handle_call(:read, _from, state) do
    {:reply, state, state}
  end
  def handle_cast({:write, value}, state) do
    {:noreply, state ++ [value]}
  end
 
  defp format_temp(temp) do
    "temp: #{Float.to_string(temp)} C"
  end

  defp format_humidity(humidity) do
    "Humidity: #{Float.to_string(humidity)}%"
  end
end 