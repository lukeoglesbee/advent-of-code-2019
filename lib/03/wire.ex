defmodule Wire do
  import Point

  defstruct path: %MapSet{}, distances: %{}, point: %Point{x: 0, y: 0}, distance: 0

  def commands(cmd_string) do
    cmd_string
    |> String.split(",")
    |> Enum.flat_map(fn cmd ->
      {dir, step} = String.split_at(cmd, 1)
      List.duplicate(dir, String.to_integer(step))
    end)
  end

  def step(%Wire{path: path, point: point, distance: distance, distances: distances}, cmd) do
    next_point =
      case cmd do
        "R" -> %Point{x: point.x + 1, y: point.y}
        "L" -> %Point{x: point.x - 1, y: point.y}
        "U" -> %Point{x: point.x, y: point.y + 1}
        "D" -> %Point{x: point.x, y: point.y - 1}
      end

    next_distance = distance + 1
    next_distances = Map.put_new(distances, next_point, next_distance)

    %Wire{
      point: next_point,
      path: MapSet.put(path, next_point),
      distance: next_distance,
      distances: next_distances
    }
  end

  def run(wire, []), do: wire

  def run(wire, [cmd | rest_cmd]) do
    wire
    |> step(cmd)
    |> run(rest_cmd)
  end

  def get_distance_at_point(%Wire{distances: distances}, %Point{} = point) do
    Map.fetch!(distances, point)
  end

  def intersection(w1, w2) do
    MapSet.intersection(w1.path, w2.path)
  end
end
