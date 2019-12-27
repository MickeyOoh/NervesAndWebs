defmodule Firmware.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @dht_pin 7 # Use port 7 for the DHT
  @dht_poll_interval 1_000 # poll every 1 second

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    #Picam.Camera.start_link()
    spawn_link(Firmware.TakePicture, :start, [])
    opts = [strategy: :one_for_one, name: Firmware.Supervisor]
    children =
      [
        # Children for all targets
        # Starts a worker by calling: Firmware.Worker.start_link(arg)
        # {Firmware.Worker, arg},
        #{Firmware.TakePicture, []},
        {Firmware.LedDemo,   [2, 0]},
        #{Firmware.LedDemo2,   [3, 0]},
        {Firmware.PersonIdentify, 100},
        worker(GrovePi.DHT, [@dht_pin, [poll_interval: @dht_poll_interval]]),
        {Firmware.TempHumid, @dht_pin}
        #{Firmware.TempHumid, 7}
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

end
