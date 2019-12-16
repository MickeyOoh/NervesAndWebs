defmodule Display.GetPicture do

  @node1  :"nerves1@Nerves.local"
  @mynode :"master@master.local"
  def start_link() do
    pid = spawn_link(__MODULE__, :init, [])
    {:ok, pid}
  end

  def init() do
    IO.puts "** TakePicture.start_link #{inspect self()} **"

    Node.start(@mynode)
    Node.set_cookie(Node.self, :"chocolate-chip")
    wait_node(:pang, 0)
    # Application.get_env(:firmware, :master_node)
    # |> Node.connect()

    loop()    
  end

  def wait_node(:pong, timer) do
    IO.puts("connected start -> #{timer} ms")
    IO.puts "#{inspect Node.list()}"
  end
  def wait_node(_mode, timer) do
    Process.sleep(1000)
    wait_node(Node.ping(@node1), timer + 1000)
  end

  def loop() do
    #data = get_image()
    #File.write!("priv/static/images/tmp.jpg", data)
    Process.sleep(500)
    loop()
  end

  def get_image() do
    pid = :global.whereis_name(:nerves1)
    case is_pid(pid) do
      true -> 
        send pid, {self(), "request"}
        receive do
           {:ok, data} -> data
        end
      _ -> IO.puts "waiting connect by set into global"
           File.read!("priv/static/images/racoondog.jpg")
    end
    #IO.iodata_to_binary(data)
  end
end