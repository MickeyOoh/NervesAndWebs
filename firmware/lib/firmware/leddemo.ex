defmodule Firmware.LedDemo do

  use GenServer
  alias GrovePi.Digital, as: Dio

  @leds [red: 2, blue: 3]

  def start_link(led) do
    IO.puts "Digital start"
    GenServer.start_link(__MODULE__, led)
  end
  def init(pin) do
    Process.send_after(self(), :tick, 500)
    {:ok, pin}
  end

  def handle_info(:tick, pin) do
    Process.send_after(self(), :tick, 500)
    Dio.write(pin, 1)
    {:noreply, pin}
  end
  defp onoff(0), do: 1
  defp onoff(_), do: 0

end