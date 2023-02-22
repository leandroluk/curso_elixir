defmodule ExMon.Game do
  alias ExMon.Player
  use Agent

  @enforce_keys [:computer, :player, :turn, :status]
  defstruct @enforce_keys

  @type t :: %ExMon.Game{
          computer: Player.t(),
          player: Player.t(),
          turn: :player | :computer,
          status: :started | :continue | :game_over
        }

  def start(computer, player) do
    initial_value = %ExMon.Game{
      computer: computer,
      player: player,
      turn: :player,
      status: :started
    }

    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def update(state) do
    Agent.update(__MODULE__, fn _ -> update_game_status(state) end)
  end

  defp update_game_status(state) do
    player = Map.get(state, :player)
    computer = Map.get(state, :computer)

    if Map.get(player, :life) == 0 or Map.get(computer, :life) == 0 do
      Map.put(state, :status, :game_over)
    else
      state
      |> Map.put(:status, :continue)
      |> update_turn()
    end
  end

  defp update_turn(%{turn: :player} = state), do: Map.put(state, :turn, :computer)
  defp update_turn(%{turn: :computer} = state), do: Map.put(state, :turn, :player)

  def info, do: Agent.get(__MODULE__, & &1)

  def player(player \\ :player), do: Map.get(info(), player)

  def turn, do: Map.get(info(), :turn)
end
