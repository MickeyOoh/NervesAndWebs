defmodule Firmware.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    ##spawn_link(TakePicture, :loop, [])
    opts = [strategy: :one_for_one, name: Firmware.Supervisor]
    children =
      [
        # Children for all targets
        # Starts a worker by calling: Firmware.Worker.start_link(arg)
        # {Firmware.Worker, arg},
        ##{Firmware.TakePicture, []},
        {Firmware.LedDemo,   [2, 0]},
        ##{Firmware.TempHumid, 7}
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: Firmware.Worker.start_link(arg)
      # {Firmware.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Children for all targets except host
      # Starts a worker by calling: Firmware.Worker.start_link(arg)
      # {Firmware.Worker, arg},
    ]
  end

  def target() do
    Application.get_env(:firmware, :target)
  end

  # def child_spec(opts) do
  #  %{
  #     id: Firmware.TakePicture,
  #     start: {Firmware.TakePicture, :start_link, [opts]},
  #     type: :worker,
  #     restart: :permanent,
  #     shutdown: 500
  #   }
  # end
end
