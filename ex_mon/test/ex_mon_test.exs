defmodule ExMonTest do
  use ExUnit.Case

  alias ExMon
  alias ExMon.Player

  import ExUnit.CaptureIO

  describe "new_player/4" do
    test "returns a player" do
      expected = %{
        life: 100,
        moves: %{avg: :avg, rnd: :rnd, heal: :heal},
        name: "Player"
      }

      player = ExMon.new_player("Player", :avg, :heal, :rnd)

      assert expected = player
    end
  end

  describe "start/1" do
    test "when game starts, should return a message" do
      player = Player.new("Player", :avg, :heal, :rnd)

      messages = capture_io(fn -> assert ExMon.start(player) == :ok end)

      assert messages =~ "The game is started"
      assert messages =~ "status: :started"
      assert messages =~ "turn: :player"
    end
  end

  describe "make_move/1" do
    setup do
      player = Player.new("Player", :avg, :heal, :rnd)
      capture_io(fn -> ExMon.start(player) end)
      :ok
    end

    test "when move is valid, do move and computer makes a move" do
      messages = capture_io(fn -> ExMon.make_move(:avg) end)

      assert messages =~ "The Player attacked the computer"
      assert messages =~ "It's computer turn"
      assert messages =~ "It's player turn"
      assert messages =~ "status: :continue"
      assert messages =~ "turn: :player"
    end
  end
end
