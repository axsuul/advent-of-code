defmodule AdventOfCode do
  def calculate_checksum_a(filename) do
    File.read!(filename)
    |> String.split("\n")
    |> Enum.map(fn row ->
      # Calculate difference within row
      sorted_row =
        row
        |> (&Regex.split(~r{\s+}, &1)).()   # anonymous function pipe
        |> Enum.map(fn d -> String.to_integer(d) end)
        |> Enum.sort

      Enum.at(sorted_row, -1) - Enum.at(sorted_row, 0)
    end)
    |> Enum.reduce(0, fn diff, sum ->
      diff + sum
    end)
  end

  def calculate_checksum_b(filename) do
    File.read!(filename)
    |> String.split("\n")
    |> Enum.map(fn row ->
      row
      |> (&Regex.split(~r{\s+}, &1)).()   # anonymous function pipe
      |> Enum.map(fn d -> String.to_integer(d) end)
      |> Combination.combine(2)
      |> Enum.reduce(nil, fn combo, result ->
        # If result is not nil, means we already found it
        if result do
          result
        else
          [small, big] = combo |> Enum.sort

          # No remainder if divded evenly
          if (Integer.mod(big, small) == 0), do: round(big/small), else: nil
        end
      end)
    end)
    |> Enum.reduce(0, fn result, sum ->
      result + sum
    end)
  end

  def a do
    "inputs/spreadsheet.txt" |> AdventOfCode.calculate_checksum_a |> IO.inspect
  end

  def b do
    "inputs/spreadsheet.txt" |> AdventOfCode.calculate_checksum_b |> IO.inspect
  end
end