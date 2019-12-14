defmodule Firmware.TakePicture do
  
  def start_link() do
    Picam.Camera.start_link
    pid = spawn_link(__MODULE__, :init, [])
    {:ok, pid}
  end

  def init() do
    IO.puts "** TakePicture.start_link #{inspect self()} **"
    wait_node(false, 0)

    Node.set_cookie(Node.self, :"chocolate-chip")

    Application.get_env(:nerves_init_gadget, :node_name)
    |> String.to_atom()
    |> :global.register_name( self())

    # Application.get_env(:firmware, :master_node)
    # |> Node.connect()

    loop()    
  end

  def wait_node(false, timer) do
    Process.sleep(1000)
    wait_node(Node.alive?, timer + 1000)
  end
  def wait_node(true, timer) do
    IO.puts("node start -> #{timer} ms")
  end

  def take_and_read_picture() do
    Picam.Camera.start_link

    Picam.next_frame
    # |> Base.encode64()
    # |> IO.puts()
  end

  def loop() do
    ##IO.puts "** req/res process **"
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