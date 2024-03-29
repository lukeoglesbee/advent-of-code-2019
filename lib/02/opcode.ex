defmodule Opcode do
  def part1() do
    res =
      Computer.from_file()
      |> Computer.run()
      |> Computer.get_by_value(0)
      |> IO.puts()
  end

  def part2() do
    desired_output = 19_690_720
    initial_state = Computer.from_file()

    nouns = 0..99
    verbs = 0..99

    Enum.map(nouns, fn noun ->
      Enum.map(verbs, fn verb ->
        res =
          initial_state
          |> Computer.update_by_value(1, noun)
          |> Computer.update_by_value(2, verb)
          |> Computer.run()

        if Computer.get_by_value(res, 0) == desired_output do
          IO.puts("==============")
          IO.puts("noun: #{noun}")
          IO.puts("verb: #{verb}")
          IO.puts("result: #{100 * noun + verb}")
        end
      end)
    end)

    :ok
  end
end
