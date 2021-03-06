defmodule Firmware.TakePicture do
  use GenServer
  alias Firmware.{TakePicture, Detect}
  defstruct [:image, :count, :mode]


  def start_link(_arg) do
    state = %TakePicture{}
    state = %{state | image: 0, count: 0, mode: 0}
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    IO.puts "** TakePicture.start_link #{inspect self()} **"
    Process.send_after(self(), :tick, 5000)
    Application.get_env(:nerves_init_gadget, :node_name)
    |> String.to_atom()
    |> :global.register_name( self())    
    {:ok, state}  
  end

  def handle_info(:tick, state) do
    IO.puts "Node init <- handle_info #{inspect self()}"
    {:noreply, state}
  end
  def handle_info(:read, state) do
    
  end

  def handle_call(:read, _from, state) do
    data = Picam.next_frame
    state = %{state | image: data}
    { :reply, state, state}
  end

  ## add cast
  def handle_cast({:write, data}, state) do 
    { :noreply, data}
  end

  def get_picture() do
    GenServer.call(__MODULE__, :read)
  end

  def start() do
    IO.puts "TakePicture start"
    Application.get_env(:nerves_init_gadget, :node_name)
    |> String.to_atom()
    |> :global.register_name( self())
    loop()       
  end

  def loop() do
    IO.puts "** req/res process **"
    receive do
      {sender, "request"} ->
        ##IO.puts "#{msg} from #{inspect sender} #{:time.uc}"
        data = Picam.next_frame
        Detect.detect_motion(data)
        #File.read!(msg)
        send sender, {:ok, data}
      msg -> IO.inspect msg
    end
    loop()
  end
end