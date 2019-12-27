defmodule Firmware.LedDemo2 do

  use GenServer
  alias GrovePi.Digital, as: Dio
  alias Firmware.LedDemo2, as: LedDemo
  defstruct [:pin, :sts]

  def start_link([pin, sts]= state) do
    IO.puts "LedDemo2.start_link #{inspect state}"
    state = %LedDemo{ %LedDemo{} | pin: pin, sts: sts}
    GenServer.start_link(__MODULE__, state)
  end
  def init(state) do
    #Dio.set_pin_mode(2, :output)
    Dio.set_pin_mode(3, :output)
    #Dio.set_pin_mode(4, :input)
    Process.send_after(self(), :tick, 100)
    IO.puts "LedDemo2 init(#{inspect state}) pid=#{inspect self()}"
    {:ok, state}
  end

  def handle_info(:tick, state) do
    Process.send_after(self(), :tick, 40)
    pin = state.pin
    sts = onoff(state.sts)
    Dio.write(pin, sts)
    state = %LedDemo{state | sts: sts}   
    #state = %LedDemo{state | sts: sts}
    {:noreply, state}
  end
  def handle_call(:din, _from, state) do
    new_state = state
    {:reply, state, new_state}
  end

  def handle_cast({:dout, value}, state) do
    IO.puts "value = #{inspect value}"
    sts = value[:sts]
    pin = value[:pin]
    state = %LedDemo{state | sts: sts}
    Dio.write(pin, sts)
    {:noreply, state}
  end
  def handle_cast(msg, state) do
    IO.puts "msg-> #{inspect msg}"
    {:noreply, state}
  end

  defp onoff(0), do: 1
  defp onoff(_), do: 0

end