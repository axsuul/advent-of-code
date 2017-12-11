defmodule AdventOfCode do
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
      # Optimize directions
      cond do
                         x == 0 -> ["s", "n"]
                         y == 0 -> ["ne", "sw"]
                         z == 0 -> ["se", "nw"]
        x > 0 && y > 0 && z < 0 -> ["sw", "s"]
        x > 0 && y < 0 && z < 0 -> ["nw", "sw"]
        x > 0 && y < 0 && z > 0 -> ["nw", "n"]
        x < 0 && y < 0 && z > 0 -> ["ne", "n"]
        x < 0 && y > 0 && z > 0 -> ["ne", "se"]
        x < 0 && y > 0 && z < 0 -> ["s", "se"]
      end
      |> Enum.map(fn direction ->
        direction
        |> coord_towards({x, y, z})
        |> Tuple.append(steps + 1)
      end)
      |> Enum.into(rest)
      |> calc_steps(track_visit(visited, {x, y, z}))
    end
  end

  defp walk_furthest(directions, coord \\ {0, 0, 0}, most_steps \\ 0, visited \\ %{})
  defp walk_furthest([], _, most_steps, _), do: most_steps
  defp walk_furthest([direction | rest], {x, y, z}, most_steps, visited) do
    # To optimize this even further, cache how many steps for each coord
    # and then calculate steps based off that
    unless visited?(visited, {x, y, z}) do
      steps = calc_steps({x, y, z})
      new_most_steps = if steps > most_steps, do: steps, else: most_steps
    else
      new_most_steps = most_steps
    end

    IO.inspect %{coord: {x, y, z}, most_steps: new_most_steps, left: length(rest)}

    walk_furthest(rest, coord_towards(direction, {x, y, z}), new_most_steps)
  end

  def read_input do
    File.read!("inputs/input.txt")
    # "se,sw,se,sw,sw"
    |> String.split(",")
  end

  def solve_a do
    read_input()
    |> walk()
    |> calc_steps()
    |> IO.inspect
  end

  def solve_b do
    read_input()
    |> walk_furthest()
    |> IO.inspect
  end
end