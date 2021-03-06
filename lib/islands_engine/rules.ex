defmodule IslandsEngine.Rules do
  alias __MODULE__

  defstruct state: :initialized,
    player1: :islands_not_set,
    player2: :islands_not_set

  def new(), do: %Rules{}

  def check(%Rules{state: :initialized} = rules, :add_player) do
    {:ok, %Rules{rules | state: :players_set}}
  end

  def check(%Rules{state: :players_set} = rules, {:position_islands, player}) do
    case Map.get(rules, player) do
      :islands_set -> :error
      :islands_not_set -> {:ok, rules}
    end
  end

  def check(%Rules{state: :players_set} = rules, {:set_islands, player}) do
    rules = Map.put(rules, player, :islands_set)

    if both_players_islands_set?(rules) do
      {:ok, %Rules{rules | state: :player1_turn}}
    else
      {:ok, rules}
    end
  end

  def check(%Rules{state: :player1_turn} = rules, {:guess_coordinate, :player1}) do
    {:ok, %Rules{rules | state: :player2_turn}}
  end

  def check(%Rules{state: :player1_turn} = rules, {:win_check, :no_win}) do
    {:ok, rules}
  end

  def check(%Rules{state: :player1_turn} = rules, {:win_check, :win}) do
    {:ok, %Rules{rules | state: :game_over}}
  end

  def check(%Rules{state: :player2_turn} = rules, {:guess_coordinate, :player2}) do
    {:ok, %Rules{rules | state: :player1_turn}}
  end

  def check(%Rules{state: :player2_turn} = rules, {:win_check, :no_win}) do
    {:ok, rules}
  end

  def check(%Rules{state: :player2_turn} = rules, {:win_check, :win}) do
    {:ok, %Rules{rules | state: :game_over}}
  end

  def check(_state, _action), do: :error

  defp both_players_islands_set?(%Rules{player1: p1, player2: p2}) do
    p1 == :islands_set and p2 == :islands_set
  end
end
