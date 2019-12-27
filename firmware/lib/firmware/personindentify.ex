defmodule Firmware.PersonIdentify do
  use GenServer
  alias GrovePi.Digital, as: GPir
  alias Firmware.PersonIdentify, as: PIR
  defstruct [:piron, :onoff, :period]
  @pinno 8        # D8
  @interval 100   # ms
  @pirtimer 3000  # 1000ms間offの場合、人がいない

  def start_link(_interval) do
    #IO.puts "LedDemo2.start_link #{inspect state}"
    state = %PIR{ %PIR{} | piron: 0, onoff: 0, period: 0}
    GenServer.start_link(__MODULE__, state)
  end
  def init(state) do
    GPir.set_pin_mode(@pinno, :input)
    Process.send_after(self(), :tick, @interval)
    {:ok, state}
  end

  def handle_info(:tick, state) do
    Process.send_after(self(), :tick, @interval)
    onoff = GPir.read(@pinno)
    {piron, period} = cond do
      onoff != 0 -> {1, @pirtimer}
      onoff == 0 && state.period > 0 -> {1, state.period - @interval}
      true  -> {0, 0}
    end
    state = %PIR{state | piron: piron, onoff: onoff, period: period}
    GrovePi.Digital.write(3, piron)
    {:noreply, state}
  end

end