defmodule DisplayWeb.Sendimg do

  @moduledoc """
    Plug for streaming an image
  """ 
  import Plug.Conn

  @behaviour Plug
  # @boundary "w58EW1cEpjzydSCq"
  ##@boundary "myboundary[CRLF]"

  def init(opts) do
    IO.puts "init -> #{inspect self()}"
   opts
  end
  def call(conn, _opts) do
    IO.puts "Streamer call invoked"
    jpg = get_image()
    size = byte_size(jpg)
    conn
    |> put_resp_header("Age", "0")
    |> put_resp_header("Cache-Control", "no-cache, private")
    |> put_resp_header("Pragma", "no-cache")
    |> put_resp_header("Content-Type", "image/jpeg")
    |> put_resp_header("Content-length", "#{size}")
    |> put_resp_header("Connection", "keep-alive")
    |> send_chunked(200)
    |> send_picture( jpg)
  end
  def send_picture(conn, jpg) do
    {:ok, conn} = chunk(conn, jpg)
    conn
  end

  def get_image() do
    IO.puts "get image"
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