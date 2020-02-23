defmodule Firm.AudioControl do
  use GenServer
  alias Firm.AudioControl, as: Audio 

  def start_link(_arg) do
    state = 0
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    Application.get_env(:nerves_init_gadget, :node_name)
    |> String.to_atom()
    |> :global.register_name( self())    
    {:ok, state}  
  end

  def handle_info(:tick, state) do
    {:noreply, state}
  end

  def handle_call(:read, _from, state) do
    { :reply, state, state}
  end

  ## add cast
  def handle_cast({:write, data}, state) do 
    { :noreply, data}
  end

  def say_() do
    GenServer.call(__MODULE__, :read)
  end

  def start() do
    "audioout"
    |> String.to_atom()
    |> :global.register_name( self())
    loop()       
  end

  def loop() do
    receive do
      {sender, {"say", file}} ->
        File.write("/tmp/out.wav", file)
        :os.cmd('aplay -q /tmp/out.wav')

      msg -> IO.inspect msg
    end
    loop()
  end
end