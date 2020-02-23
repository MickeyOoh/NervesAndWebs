defmodule DisplayWeb.Camera do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="picture">
      <img border="0" src="<%= @image %>" width="480" height="480" 
        style="transform: rotateX( 180deg );" alt="イラスト1">
    </div>
    <h1><%= Integer.to_string(div(@time, 1000) ) <> "秒" %></h1>
    """
  end

  def mount(_session, socket) do
    IO.inspect connected?(socket), label: "socket connected: "
    if connected?(socket), do: Process.send_after(self(), :tick, 500)
    {:ok, assign(socket, image: "/video.mjpg", time: 0)}
    ##{:ok, assign(socket, image: "/images/racoondog.jpg", time: "xx")}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 500)
    #{{year, month, date},{hour, min, sec}} = :calendar.local_time()
    #tim = Integer.to_string(sec) <> "秒"
    tim = socket.assign.time + 500
    {:noreply, assign(socket, image: "/video.mjpg", time: tim)}
    ##:noreply, assign(socket, image: "/images/racoondog.jpg", time: tim)}
  end
end