defmodule AdventOfCode.PartA do
  def coord_towards(direction, {x, y, z}) do
    case direction do
      "n"  -> {x, y + 1, z - 1}
      "s"  -> {x, y - 1, z + 1}
      "ne" -> {x + 1, y, z - 1}
      "sw" -> {x - 1, y, z + 1}
      "nw" -> {x - 1, y + 1, z}
      "se" -> {x + 1, y - 1, z}
    end
  end

  # Use cube coordinates for hex grid
  defp walk(directions, coord \\ {0, 0, 0})
  defp walk([], coord), do: coord
  defp walk([direction | rest], {x, y, z}) do
    walk(rest, coord_towards(direction, {x, y, z}))
  end

  def calc_distance({x, y, z}) do
    round((abs(x) + abs(y) + abs(z))/2)
  end

  def read_input do
    File.read!("inputs/input.txt")
    |> String.split(",")
  end

  def solve do
    read_input()
    |> walk()
    |> calc_distance()
    |> IO.inspect
  end
end

defmodule AdventOfCode.PartB do
  import AdventOfCode.PartA

  # Use cube coordinates for hex grid
  defp walk(directions, coord \\ {0, 0, 0}, max_dist \\ 0)
  defp walk([], coord, max_dist), do: max_dist
  defp walk([direction | rest], {x, y, z}, max_dist) do
    dist = calc_distance({x, y, z})
    new_max_dist = if dist > max_dist, do: dist, else: max_dist

    walk(rest, coord_towards(direction, {x, y, z}), new_max_dist)
  end

  def solve do
    read_input()
    |> walk()
    |> IO.inspect
  end
end