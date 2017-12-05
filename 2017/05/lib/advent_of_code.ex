defmodule AdventOfCodeA do
  def execute(filename) do
    offsets =
      File.read!(filename)
      |> String.split("\n")
      |> Enum.map(fn v -> String.to_integer(v) end)
      |> Enum.with_index
      |> Enum.reduce(%{}, fn {offset, i}, offsets ->
        Map.put(offsets, i, offset)
      end)
      |> execute_offsets()
  end

  def execute_offsets(offsets, pos, steps) when pos >= map_size(offsets) do
    steps
  end
  def execute_offsets(offsets, pos \\ 0, steps \\ 0) do
    offset = offsets[pos]

    new_pos = pos + offset

    execute_offsets(
      Map.put(offsets, pos, offset + 1),
      pos + offset,
      steps + 1
    )
  end

  def solve do
    execute("inputs/input.txt") |> IO.inspect
  end
end

defmodule AdventOfCodeB do
  def execute(filename) do
    offsets =
      File.read!(filename)
      |> String.split("\n")
      |> Enum.map(fn v -> String.to_integer(v) end)
      |> Enum.with_index
      |> Enum.reduce(%{}, fn {offset, i}, offsets ->
        Map.put(offsets, i, offset)
      end)
      |> execute_offsets()
  end

  def execute_offsets(offsets, pos, steps) when pos >= map_size(offsets) do
    steps
  end
  def execute_offsets(offsets, pos \\ 0, steps \\ 0) do
    offset = offsets[pos]

    new_pos = pos + offset
    new_offset = if offset >= 3, do: offset - 1, else: offset + 1

    execute_offsets(
      Map.put(offsets, pos, new_offset),
      pos + offset,
      steps + 1
    )
  end

  def solve do
    execute("inputs/input.txt") |> IO.inspect
  end
end