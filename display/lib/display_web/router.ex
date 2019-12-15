defmodule DisplayWeb.Router do
  use DisplayWeb, :router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_layout, { DisplayWeb.LayoutView, :app }
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DisplayWeb do
    pipe_through :browser

    get "/", PageController, :index
    live "/camera", Camera
    forward "/video.mjpg", Streamer
  end


  # Other scopes may use custom stacks.
  # scope "/api", DisplayWeb do
  #   pipe_through :api
  # end
end
