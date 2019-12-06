defmodule Password do
	def check(password) do
		is_ascending(password) && has_adjacent(password)
	end

	def is_ascending(password) do
		password == Enum.sort(password)
	end

	# def has_adjacent(list), do: has_adjacent(list, [])
	
	def has_adjacent([a, b, c | rest]) when a == b and a == c, do: has_adjacent(rest)
	def has_adjacent([a, b | rest]) when a == b, do: true
	def has_adjacent([_ | rest]), do: has_adjacent(rest)
	def has_adjacent([]), do: false

	def check_range() do
		start = 359282
		fin = 820401

		start..fin
		|> Enum.map(&Integer.to_string/1)
		|> Enum.map(&String.codepoints/1)
		|> Enum.count(&check/1)
	end
end
