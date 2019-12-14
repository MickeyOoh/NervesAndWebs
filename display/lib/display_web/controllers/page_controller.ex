defmodule DisplayWeb.PageController do
  use DisplayWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
