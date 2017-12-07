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
      unless tower[above_name] do
        tower = add_program(tower, above_name)
      end

      put_in(tower, [above_name, :below], tower[above_name][:below] ++ [name])
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
        weight = stats[:total_weight]

        unless weight_tallies[weight] do
          weight_tallies = put_in(weight_tallies, [weight], 0)
        end

        weight_tallies = put_in(weight_tallies, [weight], weight_tallies[weight] + 1)
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


