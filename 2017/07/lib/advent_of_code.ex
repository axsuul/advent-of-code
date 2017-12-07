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
    if tower[name] do
      tower
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

      put_in(tower, [above_name, :below], tower[above_name][:below] ++ [above_name])
    end)).()
  end

  def find_bottom(filename) do
    build_tower(filename)
    |> Enum.reduce(nil, fn {name, stats}, below ->
      if below do
        below
      else
        if Enum.empty?(stats[:below]), do: name, else: nil
      end
    end)
  end

  def solve_a do
    find_bottom("inputs/input.txt") |> IO.inspect
  end
end


