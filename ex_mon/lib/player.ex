defmodule ExMon.Player do
  alias ExMon.Player

  @enforce_keys [:life, :moves, :name]
  defstruct @enforce_keys

  @type t :: %Player{
          life: integer(),
          name: String.t(),
          moves: %{
            avg: atom(),
            heal: atom(),
            rnd: atom()
          }
        }

  @max_life 100

  def new(name, move_avg, move_heal, move_rnd) do
    %Player{
      life: @max_life,
      name: name,
      moves: %{
        avg: move_avg,
        heal: move_heal,
        rnd: move_rnd
      }
    }
  end
end
