defmodule AdventOfCode do
  def build_tower(filename) do
    File.read!(filename)
    |> String.split("\n")
    |> Enum.reduce(%{}, fn instructions, tower ->
      if String.match?(instructions, ~r/\-\>/) do
        [_, name, weight, above] = Regex.run(~r/(\w+) \((\d+)\) \-\> (.+)/, instructions)

        add_program(tower, name, weight, above |> String.split(", "))
      else
        [_, name, weight] = Regex.run(~r/(\w+) \((\d+)\)/, instructions)

        add_program(tower, name, weight)
      end
    end)
  end

  defp add_program(tower, name, weight \\ nil) do
    weight = if weight, do: String.to_integer(weight)

    if tower[name] do
      put_in(tower, [name, :weight], weight)
    else
      put_in(tower, [name], %{ weight: weight, above: [], below: [] })
    end
  end
  defp add_program(tower, name, weight, above) do
    add_program(tower, name, weight)

    # In addition track what's above, and for those on top
    # what's below them
    |> put_in([name, :above], above)
    |> (&Enum.reduce(above, &1, fn above_name, tower ->
      new_tower =
        unless tower[above_name] do
          add_program(tower, above_name)
        else
          tower
        end

      put_in(new_tower, [above_name, :below], new_tower[above_name][:below] ++ [name])
    end)).()
  end

  def find_bottom(tower) do
    tower
    |> Enum.reduce(nil, fn {name, stats}, below ->
      if below do
        below
      else
        if Enum.empty?(stats[:below]), do: name, else: nil
      end
    end)
  end

  defp tally_weights_above(tower, above, total) when length(above) == 0 do
    total
  end
  defp tally_weights_above(tower, above, total) do
    above
    |> Enum.reduce(total, fn above_name, total ->
      tally_weights_above(
        tower,
        tower[above_name][:above],
        tower[above_name][:weight] + total
      )
    end)
  end

  def find_unbalanced_program(tower, name) do
    tallies =
      tower[name][:above]
      |> Enum.map(fn above_name ->
        weight = tower[above_name][:weight]
        total_weight =
          tally_weights_above(tower, tower[above_name][:above], weight)

        %{ name: above_name, weight: weight, total_weight: total_weight }
      end)

    # Find odd one out
    odd =
      tallies
      |> Enum.reduce(%{}, fn stats, weight_tallies ->
        Map.update(weight_tallies, stats[:total_weight], 1, fn value -> value + 1 end)
      end)
      |> Enum.filter(fn {total_weight, count} -> count == 1 end)

    # If all the weights are equal, then the current program we are on
    # is the one that needs its weight changed
    if Enum.empty?(odd) do
      # This is nasty but below we find calculate what the final
      # weight needs to be
      unbalanced = tower[name]
      [below_unbalanced_name] = unbalanced[:below]

      [unbalanced_sibling_name | tail] =
        Enum.filter(tower[below_unbalanced_name][:above], fn unbalanced_sibling_name ->
          unbalanced_sibling_name != name
        end)

      goal_weight =
        tally_weights_above(
          tower,
          tower[unbalanced_sibling_name][:above],
          tower[unbalanced_sibling_name][:weight]
        )

      unbalanced_tower_weight =
        tally_weights_above(tower, tower[name][:above], unbalanced[:weight])

      (goal_weight - unbalanced_tower_weight) + unbalanced[:weight]
    else
      [{odd_weight, _}] = odd

      [unbalanced] =
        tallies
        |> Enum.filter(fn stats -> stats[:total_weight] == odd_weight end)

      find_unbalanced_program(tower, unbalanced[:name])
    end
  end

  def solve_a do
    build_tower("inputs/input.txt")
    |> find_bottom
    |> IO.inspect
  end

  def solve_b do
    tower = build_tower("inputs/input.txt")

    tower
    |> find_unbalanced_program(find_bottom(tower))
    |> IO.inspect
  end
end


