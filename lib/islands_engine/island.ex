defmodule IslandsEngine.Island do
  alias IslandsEngine.{Coordinate, Island}

  @enforce_keys ~w[coordinates hit_coordinates]a

  defstruct ~w[coordinates hit_coordinates]a

  def new(type, %Coordinate{} = upper_left) do
    with [_|_] = offsets <- offsets(type),
         %MapSet{} = coordinates <- add_coordinates(offsets, upper_left) do
      {:ok, %Island{coordinates: coordinates, hit_coordinates: MapSet.new()}}
    end
  end

  def overlaps?(existing_island, new_island) do
    not MapSet.disjoint?(existing_island.coordinates, new_island.coordinates)
  end

  def guess(island, coordinate) do
    if MapSet.member?(island.coordinates, coordinate) do
      {:hit, Map.update!(island, :hit_coordinates, &MapSet.put(&1, coordinate))}
    else
      :miss
    end
  end

  def forested?(%Island{coordinates: coords, hit_coordinates: hit_coords}) do
    MapSet.equal?(coords, hit_coords)
  end

  def types(), do: ~w[atoll dot l_shape s_shape square]a

  defp add_coordinates(offsets, upper_left) do
    offsets
    |> Enum.reduce_while(MapSet.new(), &add_coordinate(&2, upper_left, &1))
  end

  defp add_coordinate(coordinates, upper_left, {row_offset, col_offset}) do
    %Coordinate{row: row, col: col} = upper_left

    case Coordinate.new(row + row_offset, col + col_offset) do
      {:ok, coordinate} ->
        {:cont, MapSet.put(coordinates, coordinate)}

      error ->
        {:halt, error}
    end
  end

  defp offsets(:square), do: [{0, 0}, {0, 1}, {1, 0}, {1, 1}]

  defp offsets(:atoll), do: [{0, 0}, {0, 1}, {1, 1}, {2, 0}, {2, 1}]

  defp offsets(:dot), do: [{0, 0}]

  defp offsets(:l_shape), do: [{0, 0}, {1, 0}, {2, 0}, {2, 1}]

  defp offsets(:s_shape), do: [{0, 1}, {0, 2}, {1, 0}, {1, 1}]

  defp offsets(_), do: {:error, :invalid_island_type}
end
