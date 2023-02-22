defmodule ExMon do
  alias ExMon.Game.Actions
  alias ExMon.{Game, Player}
  alias ExMon.Game.Status

  @computer_name "Computer"
  @computer_moves [:avg, :rnd, :heal]

  def new_player(name, move_avg, move_heal, move_rnd) do
    Player.new(name, move_avg, move_heal, move_rnd)
  end

  def start(player) do
    @computer_name
    |> new_player(:punch, :kick, :heal)
    |> Game.start(player)

    Status.print_round_message(Game.info())
  end

  def make_move(move) do
    Game.info()
    |> Map.get(:status)
    |> handle_status(move)

    computer_move(Game.info())
  end

  defp handle_status(:game_over, _move), do: Status.print_round_message(Game.info())

  defp handle_status(_, move) do
    move
    |> Actions.fetch_move()
    |> do_move()
  end

  defp computer_move(%{turn: :computer, status: :continue}) do
    move = {:ok, Enum.random(@computer_moves)}
    do_move(move)
  end

  defp computer_move(_), do: :ok

  defp do_move({:error, move}), do: Status.print_wrong_move(move)

  defp do_move({:ok, move}) do
    case move do
      :heal -> Actions.heal()
      _ -> Actions.attack(move)
    end

    Status.print_round_message(Game.info())
  end
end
