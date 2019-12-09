defmodule Command do
  defstruct opcode: 0, params: []
end

defmodule Computer do
  defstruct pointer: 0, state: %{}, cmd: %Command{}, input: [], output: []

  # This is a map from opcode to number of params
  @opcodes %{
    # Add
    1 => 3,

    # Multiply
    2 => 3,

    # Input
    3 => 1,

    # Output
    4 => 1,

    # Jump if true
    5 => 2,

    # Jump if false
    6 => 2,

    # Less than
    7 => 3,

    # Equals
    8 => 3,

    # Halt
    99 => 0
  }

  defp get(%Computer{} = com, {:value, param}), do: get_by_value(com, param)
  defp get(%Computer{} = com, {:pointer, param}), do: get_by_pointer(com, param)

  def get_by_value(%Computer{state: state} = com, index) do
    Map.fetch!(state, index)
  end

  def get_by_pointer(%Computer{} = com, pointer) do
    index = get_by_value(com, pointer)
    get_by_value(com, index)
  end

  defp update(%Computer{} = com, {:value, param}, value), do: update_by_value(com, param, value)

  defp update(%Computer{} = com, {:pointer, param}, value),
    do: update_by_pointer(com, param, value)

  def update_by_value(%Computer{state: state} = com, index, value) do
    next_state = Map.replace!(state, index, value)
    %{com | state: next_state}
  end

  def update_by_pointer(%Computer{} = com, pointer, value) do
    index = get_by_value(com, pointer)
    update_by_value(com, index, value)
  end

  def jump_if(com, condition, pointer) do
    if condition do
      %{com | pointer: pointer}
    else
      com
    end
  end

  # Load command based on pointer value
  defp fetch(%Computer{pointer: pointer} = com) do
    instruction = get_by_value(com, pointer)
    opcode = rem(instruction, 100)
    mode_code = div(instruction, 100)

    modes =
      mode_code
      |> Integer.digits()
      |> Enum.reverse()
      |> Enum.map(fn c ->
        case c do
          0 -> :pointer
          1 -> :value
        end
      end)

    params =
      case Map.fetch(@opcodes, opcode) do
        :error ->
          raise "bad opcode: #{opcode}"

        {:ok, 0} ->
          []

        {:ok, n_params} ->
          1..n_params
          |> Enum.map(fn offset ->
            mode = Enum.at(modes, offset - 1, :pointer)
            {mode, pointer + offset}
          end)
      end

    %Computer{
      com
      | cmd: %Command{params: params, opcode: opcode},
        pointer: pointer + Map.fetch!(@opcodes, opcode) + 1
    }
  end

  # Exectue loaded command
  defp execute(%Computer{} = com) do
    case com.cmd do
      %{opcode: 1, params: [a, b, dest]} ->
        res = get(com, a) + get(com, b)
        {:ok, update(com, dest, res)}

      %{opcode: 2, params: [a, b, dest]} ->
        res = get(com, a) * get(com, b)
        {:ok, update(com, dest, res)}

      %{opcode: 3, params: [dest]} ->
        [arg | next_input] = com.input

        next_com =
          com
          |> update(dest, arg)
          |> Map.put(:input, next_input)

        {:ok, next_com}

      %{opcode: 4, params: [src]} ->
        arg = get(com, src)
        next_com = %Computer{com | output: [arg | com.output]}
        {:ok, next_com}

      %{opcode: 5, params: [a, b]} ->
        {:ok, jump_if(com, get(com, a) != 0, get(com, b))}

      %{opcode: 6, params: [a, b]} ->
        {:ok, jump_if(com, get(com, a) == 0, get(com, b))}

      %{opcode: 7, params: [a, b, dest]} ->
        res = if get(com, a) < get(com, b), do: 1, else: 0
        {:ok, update(com, dest, res)}

      %{opcode: 8, params: [a, b, dest]} ->
        res = if get(com, a) == get(com, b), do: 1, else: 0
        {:ok, update(com, dest, res)}

      %{opcode: 99, params: []} ->
        {:done, com}

      command ->
        raise NOT_IMPLEMENTED
    end
  end

  defp tick(%Computer{} = com) do
    com
    |> fetch()
    |> execute()
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
