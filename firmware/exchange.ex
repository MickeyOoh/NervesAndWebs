defmodule Server do
  def server_start do
    pid = spawn(__MODULE__, :loop, [])
    :global.register_name(:server, pid)
  end
     
  def loop() do
    receive do
      {sender, msg} ->
        data = File.read!(msg)
        send sender, {:ok, data}
    end
    loop()
  end
end
 
defmodule Client do
  def start do
    send :global.whereis_name(:server), {self(), "racoondog.jpg"}
     
    receive do
      {:ok, message} ->
        File.write("getimg.jpg", message)
    end
  end
end
