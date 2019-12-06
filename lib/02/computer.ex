defmodule Computer do
  defstruct pointer: 0, state: %{}, cmd: 0

  def get(%Computer{state: state} = com, index) do
    Map.fetch!(state, index)
  end

  def get_by_pointer(%Computer{} = com, pointer) do
    index = get(com, pointer)
    get(com, index)
  end

  def update(%Computer{state: state} = com, index, value) do
    next_state = Map.replace!(state, index, value)
    %{com | state: next_state}
  end

  def update_by_pointer(%Computer{} = com, pointer, value) do
    index = get(com, pointer)
    update(com, index, value)
  end

  def step(%Computer{pointer: pointer} = com, val) do
    next_pointer = com.pointer + val
    %{com | pointer: next_pointer, cmd: get(com, next_pointer)}
  end

  def tick(%Computer{cmd: 99} = com) do
    next = step(com, 1)
    {:done, next}
  end

  def tick(%Computer{cmd: 1, pointer: pointer} = com) do
    res = get_by_pointer(com, pointer + 1) + get_by_pointer(com, pointer + 2)

    next =
      com
      |> update_by_pointer(pointer + 3, res)
      |> step(4)

    {:ok, next}
  end

  def tick(%Computer{cmd: 2, pointer: pointer} = com) do
    res = get_by_pointer(com, pointer + 1) * get_by_pointer(com, pointer + 2)

    next =
      com
      |> update_by_pointer(pointer + 3, res)
      |> step(4)

    {:ok, next}
  end

  def tick(com) do
    raise NOT_IMPLEMENTED
  end

  def run(com) do
    case tick(com) do
      {:done, c} -> c
      {:ok, c} -> run(c)
    end
  end

  def from_file() do
    from_file("data/02.txt")
  end

  def from_file(filename) do
    state =
      filename
      |> File.read!()
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Map.new(fn {a, b} -> {b, a} end)

    %Computer{
      pointer: 0,
      cmd: Map.fetch!(state, 0),
      state: state
    }
  end
end
