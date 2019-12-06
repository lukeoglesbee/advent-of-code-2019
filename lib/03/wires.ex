defmodule Wires do
  import Point

  def part1() do
    [w1, w2] =
      "data/03.txt"
      |> File.read!()
      |> String.split()
      |> Enum.map(&Wire.commands/1)
      |> Enum.map(fn c -> Wire.run(%Wire{}, c) end)

    intersects = Wire.intersection(w1, w2)
    Point.find_closest(%Point{x: 0, y: 0}, intersects)
  end

  def part2() do
    [w1, w2] =
      "data/03.txt"
      |> File.read!()
      |> String.split()
      |> Enum.map(&Wire.commands/1)
      |> Enum.map(fn c -> Wire.run(%Wire{}, c) end)

    Wire.intersection(w1, w2)
    |> Enum.map(fn p ->
      Wire.get_distance_at_point(w1, p) + Wire.get_distance_at_point(w2, p)
    end)
    |> Enum.min()
  end
end
