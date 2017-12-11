defmodule AdventOfCode do
  # Use cube coordinates for hex grid
  defp walk(directions, x \\ 0, y \\ 0, z \\ 0)
  defp walk([], x, y, z), do: {x, y, z}
  defp walk([direction | rest], x, y, z) do
    case direction do
      "n"  -> walk(rest, x, y + 1, z - 1)
      "s"  -> walk(rest, x, y - 1, z + 1)
      "ne" -> walk(rest, x + 1, y, z - 1)
      "sw" -> walk(rest, x - 1, y, z + 1)
      "nw" -> walk(rest, x - 1, y + 1, z)
      "se" -> walk(rest, x + 1, y - 1, z)
    end
  end

  defp track_visit(visited, {x, y, z}) do
    visited |> Map.put_new(x, %{}) |> Kernel.put_in([x, y], z)
  end

  defp visited?(visited, {x, y, z}) do
    visited |> get_in([x, y]) == z
  end

  defp calc_steps({x, y, z}), do: calc_steps([{x, y, z, 0}], %{})
  defp calc_steps([{0, 0, 0, steps} | _], _), do: steps
  defp calc_steps([{x, y, z, steps} | rest], visited) do
    if visited?(visited, {x, y, z}) do
      calc_steps(rest, visited)
    else
      [
        {x, y + 1, z - 1},
        {x, y - 1, z + 1},
        {x + 1, y, z - 1},
        {x - 1, y, z + 1},
        {x - 1, y + 1, z},
        {x + 1, y - 1, z}
      ]
      |> Enum.map(fn {x, y, z} -> {x, y, z, steps + 1} end)
      |> Enum.into(rest)
      |> calc_steps(track_visit(visited, {x, y, z}))
    end
  end

  def solve do
    File.read!("inputs/input.txt")
    |> String.split(",")
    |> walk()
    |> calc_steps()
    |> IO.inspect
  end
end
