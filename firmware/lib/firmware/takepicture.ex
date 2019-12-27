defmodule Firmware.TakePicture do
  use GenServer

  def start_link(state) do
    ##Picam.Camera.start_link()
    spawn_link(__MODULE__, :loop, [])
    GenServer.start_link(__MODULE__, state)
  end

  def init(state) do
    IO.puts "** TakePicture.start_link #{inspect self()} **"
    Process.send_after(self(), :tick, 5000)
    {:ok, state}  
  end

  def handle_info(:tick, state) do
    Node.set_cookie(Node.self, :"chocolate-chip")

    Application.get_env(:nerves_init_gadget, :node_name)
    |> String.to_atom()
    |> :global.register_name( self())

    IO.puts "Node init <- handle_info #{inspect self()}"
    {:noreply, state}
  end
  def handle_info(:read, state) do
    
  end

  def handle_call(:read, _from, data) do
    data = Picam.next_frame
    { :reply, data, data}
  end

  ## add cast
  def handle_cast({:write, data}, state) do 
    { :noreply, data}
  end

  def take_and_read_picture() do
    Picam.Camera.start_link
    Picam.next_frame
    # |> Base.encode64()
    # |> IO.puts()
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
        #File.read!(msg)
        send sender, {:ok, data}
      msg -> IO.inspect msg
    end
    loop()
  end
end