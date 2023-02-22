defmodule ExMon.GameTest do
  alias ExMon.{Game, Player}
  use ExUnit.Case

  describe "start/2" do
    test "starts the game state" do
      computer = Player.new("Computer", :kick, :punch, :heal)
      player = Player.new("Player", :kick, :punch, :heal)

      assert {:ok, _pid} = Game.start(computer, player)
    end
  end

  describe "update/1" do
    test "returns the game state updated" do
      computer = Player.new("Computer", :kick, :punch, :heal)
      player = Player.new("Player", :kick, :punch, :heal)

      Game.start(computer, player)

      Game.update(Map.merge(Game.info(), %{turn: :computer}))

      expected = %{
        computer: computer,
        player: player,
        turn: :computer,
        status: :started
      }

      assert expected = Game.info()
    end
  end

  describe "info/0" do
    test "returns the current state" do
      computer = Player.new("Computer", :kick, :punch, :heal)
      player = Player.new("Player", :kick, :punch, :heal)

      Game.start(computer, player)

      expected = %{
        computer: computer,
        player: player,
        turn: :player,
        status: :started
      }

      assert expected = Game.info()
    end
  end

  describe "player/1" do
    test "returns player when no pass reference" do
      computer = Player.new("Computer", :kick, :punch, :heal)
      player = Player.new("Player", :kick, :punch, :heal)

      Game.start(computer, player)

      assert Game.player() == player
    end

    test "returns computer when pass computer as reference" do
      computer = Player.new("Computer", :kick, :punch, :heal)
      player = Player.new("Player", :kick, :punch, :heal)

      Game.start(computer, player)

      assert Game.player(:computer) == computer
    end
  end

  describe "turn/0" do
    test "returns actual turn" do
      computer = Player.new("Computer", :kick, :punch, :heal)
      player = Player.new("Player", :kick, :punch, :heal)

      Game.start(computer, player)

      assert Game.turn() == :player
    end
  end
end
