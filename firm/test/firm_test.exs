defmodule FirmTest do
  use ExUnit.Case
  doctest Firm

  test "greets the world" do
    assert Firm.hello() == :world
  end
end
