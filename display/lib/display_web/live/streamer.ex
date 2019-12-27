defmodule DisplayWeb.Streamer do

  @moduledoc """
    Plug for streaming an image
  """ 
  import Plug.Conn

  @behaviour Plug
  ##@boundary "w58EW1cEpjzydSCq"
  @boundary "myboundary[CRLF]"

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    IO.puts "Streamer call invoked #{inspect self()}"
    conn
    |> put_resp_header("Age", "0")
    |> put_resp_header("Cache-Control", "no-cache, private")
    |> put_resp_header("Pragma", "no-cache")
    |> put_resp_header("Content-Type", "multipart/x-mixed-replace; boundary=--#{@boundary}")
    |> send_chunked(200)
    |> send_pictures( File.read!("priv/static/images/racoondog.jpg"))
  end


  defp send_pictures(conn, data) do
    send_picture(conn, data)
    send_pictures(conn, data)
  end

  defp send_picture(conn, data) do
    jpg = get_image(data)
    size = byte_size(jpg)
    ##IO.puts "send_picture #{size}"
    header = "------#{@boundary}\r\nContent-Type:image/jpeg\r\nContent-length: #{size}\r\n\r\n"
    footer = "\r\n"
    with {:ok, conn} <- chunk(conn, header),
         {:ok, conn} <- chunk(conn, jpg),
         {:ok, conn} <- chunk(conn, footer),
         do: conn
  end

  defp get_image(data) do
    #{{_,_,_},{_,_,sec}} = :calendar.local_time
    #IO.puts "get_image: #{sec} [sec]"
    pid = :global.whereis_name(:nerves1)
    case is_pid(pid) do
      true -> 
          send pid, {self(), "request"}
          receive do
            {:ok, data} -> data
          end
      _ -> #IO.puts "waiting connect by set into global"
           #File.read!("priv/static/images/racoondog.jpg")
           data
    end
    #IO.iodata_to_binary(data)
  end

end