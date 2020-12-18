defmodule IslandsEngine.Coordinate do
  alias __MODULE__

  @enforce_keys ~w[row col]a
  @board_range 1..10

  defstruct ~w[row col]a

  def new(row, col) when row in @board_range and col in @board_range do
    {:ok, %Coordinate{row: row, col: col}}
  end

  def new(_row, _col), do: {:error, :invalid_coordinate}
end
