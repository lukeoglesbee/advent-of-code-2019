defmodule Fuel do
	def gas_for_mass(mass) do
		max(div(mass, 3) - 2, 0)
	end

	def gas_for_mass_recursive(mass) do
		gas = gas_for_mass(mass)

		if (gas > 0) do
			gas + gas_for_mass_recursive(gas)
		else
			gas
		end
	end

	def part1() do
		"data/01.txt"
		|> File.read!
		|> String.split
		|> Enum.map(&String.to_integer/1)
		|> Enum.map(&Fuel.gas_for_mass/1)
		|> Enum.sum
		|> IO.puts
	end

	def part2() do
		"data/01.txt"
		|> File.read!
		|> String.split
		|> Enum.map(&String.to_integer/1)
		|> Enum.map(&Fuel.gas_for_mass_recursive/1)
		|> Enum.sum
		|> IO.puts
	end
end
