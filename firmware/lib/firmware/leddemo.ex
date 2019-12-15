defmodule Firmware.LedDemo do

  use GenServer
  alias GrovePi.Digital, as: Dio

  #@leds [red: 2, blue: 3]

  def start_link(led) do
    GenServer.start_link(__MODULE__, led)
  end
  def init([pin, sts]= state) do
    Dio.set_pin_mode(pin, :output)
    Process.send_after(self(), :tick, 100)
    {:ok, state}
  end

  def handle_info(:tick, [pin, sts] = state) do
    Process.send_after(self(), :tick, 100)
    sts = onoff(sts)
    Dio.write(pin, sts)
    state = [pin, sts]
    {:noreply, state}
  end
  defp onoff(0), do: 1
  defp onoff(_), do: 0

end