defmodule DisplayWeb.Camera do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="picture">
      <img border="0" src="<%= @image %>" width="256" height="256" 
        style="transform: rotateX( 180deg );" alt="イラスト1">
    </div>
    <h1><%= @time %></h1>
    """
    #~L"""
    #<img border="0" src="<%= Routes.static_path(UiWeb.Endpoint, "/images/racoondog.jpg") %>" width="256" height="256" alt="イラスト1">
    #"""
  end

  def mount(_session, socket) do
    IO.inspect connected?(socket), label: "socket connected: "
    if connected?(socket), do: Process.send_after(self(), :tick, 500)  
    {:ok, assign(socket, image: "/video.mjpg", time: "xx")}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 500)
    #IO.puts "info comes "
    {{year, month, date},{hour, min, sec}} = :calendar.local_time()
    tim = Integer.to_string(sec) <> "秒"
    {:noreply, assign(socket, image: "/video.mjpg", time: tim)}
  end

end