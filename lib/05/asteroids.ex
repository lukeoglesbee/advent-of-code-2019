defmodule Asteroids do
  def part1() do
    res =
      Computer.from_file("data/05.txt")
      |> Map.put(:input, [1])
      |> Computer.run()

    IO.inspect(res.output)
  end

  def part2() do
    res =
      Computer.from_file("data/05.txt")
      |> Map.put(:input, [5])
      |> Computer.run()

    IO.inspect(res.output)
  end
end
