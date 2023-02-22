defmodule ExMon.Game.Actions.Heal do
  alias ExMon.Game
  alias ExMon.Game.Status

  @heal_power 18..25

  def heal_life(player) do
    player
    |> Game.player()
    |> Map.get(:life)
    |> calculate_total_life()
    |> set_life(player)
  end

  defp calculate_total_life(life), do: Enum.random(@heal_power) + life

  defp set_life(life, player) when life > 100, do: update_player_life(player, 100)
  defp set_life(life, player), do: update_player_life(player, life)

  defp update_player_life(player, life) do
    player
    |> Game.player()
    |> Map.put(:life, life)
    |> update_game(player, life)
  end

  def update_game(player_data, player_name, life) do
    Game.info()
    |> Map.put(player_name, player_data)
    |> Game.update()

    Status.print_move(player_name, :heal, life)
  end
end
