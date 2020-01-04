defmodule Firmware.LedDemo do
  use GenServer
  alias GrovePi.Digital, as: Dio
  alias Firmware.LedDemo
  defstruct [:pin, :sts]
  @interval 100
  @pinno  2

  def start_link([pin, sts]= state) do
    IO.puts "LedDemo.start_link #{inspect state}"
    state = %LedDemo{ %LedDemo{} | pin: pin, sts: sts}
    GenServer.start_link(__MODULE__, state)
  end

  def init(state) do
    Dio.set_pin_mode(@pinno, :output)
    Process.send_after(self(), :tick, @interval)
    IO.puts "LedDemo init(#{inspect state}) pid=#{inspect self()}"
    {:ok, state}
  end

  def handle_info(:tick, state) do
    Process.send_after(self(), :tick, @interval)
    sts = onoff(state.sts)
    Dio.write(@pinno, sts)
    state = %LedDemo{state | sts: sts}   
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