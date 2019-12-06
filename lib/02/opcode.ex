defmodule Opcode do
	def part1() do
		res = Computer.from_file()
		|> Computer.run()
		|> Computer.get(0)
		|> IO.puts
	end

	def part2() do
		desired_output = 19690720
		initial_state = Computer.from_file()

		nouns = 0..99
		verbs = 0..99

		Enum.map(nouns, fn noun ->
			Enum.map(verbs, fn verb ->
				res = initial_state
				|> Computer.update(1, noun)
				|> Computer.update(2, verb)
				|> Computer.run

				if (Computer.get(res, 0) == desired_output) do
					IO.puts "=============="
					IO.puts "noun: #{noun}"
					IO.puts "verb: #{verb}"
					IO.puts "result: #{100 * noun + verb}"
				end
			end)
		end)

		:ok
	end
end
