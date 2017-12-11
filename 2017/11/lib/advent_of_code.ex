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

  defp coord_key({x, y, z}) do
    Integer.to_string(x) <> "," <> Integer.to_string(y) <> "," <> Integer.to_string(z)
  end

  defp calc_steps({x, y, z}, steps_cache \\ %{}), do: calc_steps([{x, y, z, 0}], %{}, steps_cache)
  defp calc_steps([{0, 0, 0, steps} | _], _, _), do: steps
  defp calc_steps([{x, y, z, steps} | rest], visited, steps_cache) do
    coord_key = coord_key({x, y, z})

    cond do
      Map.has_key?(steps_cache, coord_key) ->
        steps + steps_cache[coord_key]
      visited?(visited, {x, y, z}) -> calc_steps(rest, visited, steps_cache)
      true ->
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
        |> calc_steps(track_visit(visited, {x, y, z}), steps_cache)
    end
  end

  defp walk_furthest(directions, coord \\ {0, 0, 0}, most_steps \\ 0, steps_cache \\ %{})
  defp walk_furthest([], _, most_steps, _, steps_cache), do: most_steps
  defp walk_furthest([direction | rest], {x, y, z}, most_steps, steps_cache) do
    # To optimize this even further, cache how many steps for each coord
    # and then calculate steps based off that
    IO.inspect {{x, y, z}, length(rest)}
    steps = calc_steps({x, y, z}, steps_cache)
    new_steps_cache = Map.put(steps_cache, coord_key({x, y, z}), steps)
    new_most_steps = if steps > most_steps, do: steps, else: most_steps

    walk_furthest(rest, coord_towards(direction, {x, y, z}), new_most_steps, new_steps_cache)
  end

  def read_input do
    File.read!("inputs/input.txt") |> String.split(",")
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