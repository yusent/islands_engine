defmodule IslandsEngine.Guesses do
  alias __MODULE__

  @enforce_keys ~w[hits misses]a

  defstruct ~w[hits misses]a

  def new(), do: %Guesses{hits: MapSet.new(), misses: MapSet.new()}
end
