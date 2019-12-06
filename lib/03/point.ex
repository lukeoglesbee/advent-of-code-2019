defmodule Point do
	defstruct [x: 0, y: 0]

	def distance(%Point{x: x1, y: y1}, %Point{x: x2, y: y2}) do
		abs(x2 - x1) + abs(y2 - y1)
	end

	def find_closest(%Point{} = origin, points) do
		points
		|> Enum.min_by(fn p -> distance(origin, p) end)
	end
end
