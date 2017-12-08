defmodule AdventOfCode do
  defp run_line(register, line) do
    [
      _,
      variable,
      operator,
      delta,
      dependent_variable,
      condition
    ] = Regex.run(~r/^(\w+) (\w+) (\-?\d+) if (\w+) (.+)/, line)

    # Eval string to Elixir code
    value = get_value(register, dependent_variable)
    {result, _} = Code.eval_string(Integer.to_string(value) <> " " <> condition)

    if result do
      delta = String.to_integer(delta)

      new_value =
        case operator do
          "inc" -> get_value(register, variable) + delta
          "dec" -> get_value(register, variable) - delta
        end

      Map.put(register, variable, new_value)
    else
      register
    end
  end

  defp get_value(register, variable) do
    Map.get(register, variable, 0)
  end

  defp run(filename) do
    filename
    |> File.read!
    |> String.split("\n")
    |> Enum.reduce(%{}, fn line, register ->
      run_line(register, line)
    end)
  end

  defp max_register_value(register) do
    register
    |> Enum.reduce(nil, fn {_, value}, max ->
      cond do
        max == nil -> value
        max < value -> value
        max >= value -> max
      end
    end)
  end

  defp run_max(filename) do
    filename
    |> File.read!
    |> String.split("\n")
    |> Enum.reduce({%{}, nil}, fn line, {register, max} ->
      new_register = run_line(register, line)
      max_value = max_register_value(new_register)

      new_max =
        cond do
          max == nil -> max_value
          max < max_value -> max_value
          max >= max_value -> max
        end

      {new_register, new_max}
    end)
  end

  def solve_a do
    "inputs/input.txt"
    |> run
    |> max_register_value
    |> IO.inspect
  end

  def solve_b do
    {_, max} =
      "inputs/input.txt"
      |> run_max()

    max |> IO.inspect
  end
end