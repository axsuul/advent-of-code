defmodule AdventOfCodeA do
  defp solve_file(filename) do
    File.read!(filename)
    |> (&Regex.split(~r{\s+}, &1)).()
    |> Enum.map(&String.to_integer/1)
    |> distribute()
  end

  defp distribute(banks, history \\ %{}, count \\ 0) do
    # Select largest to distribute
    {bank, index} =
      banks
      |> Enum.with_index
      |> Enum.reduce({0, nil}, fn {bank, i}, {largest_bank, largest_i} ->
        if bank > largest_bank do
          {bank, i}
        else
          {largest_bank, largest_i}
        end
      end)

    new_banks =
      banks
      |> Enum.with_index
      |> Enum.map(fn {bank, i} ->
        # Clear out the bank we distribute from
        if i == index, do: 0, else: bank
      end)
      |> distribute_memory(index + 1, bank)

    # History
    key = new_banks |> Enum.map(&Integer.to_string/1)

    if history[key] do
      count + 1
    else
      distribute(new_banks, Map.put(history, key, true), count + 1)
    end
  end

  defp distribute_memory(banks, index, memory) when index >= length(banks) do
    distribute_memory(banks, 0, memory)
  end
  defp distribute_memory(banks, index, memory) when memory == 0 do
    banks
  end
  defp distribute_memory(banks, index, memory) do
    banks
    |> Enum.with_index
    |> Enum.map(fn {bank, i} ->
      if i == index do bank + 1 else bank end
    end)
    |> distribute_memory(index + 1, memory - 1)
  end

  def solve do
    solve_file("inputs/input.txt") |> IO.inspect
  end
end

defmodule AdventOfCodeB do
  defp solve_file(filename) do
    File.read!(filename)
    |> (&Regex.split(~r{\s+}, &1)).()
    |> Enum.map(&String.to_integer/1)
    |> distribute()
  end

  defp distribute(banks, history \\ %{}, count \\ 0, is_looped \\ false) do
    # Select largest to distribute
    {bank, index} =
      banks
      |> Enum.with_index
      |> Enum.reduce({0, nil}, fn {bank, i}, {largest_bank, largest_i} ->
        if bank > largest_bank do
          {bank, i}
        else
          {largest_bank, largest_i}
        end
      end)

    new_banks =
      banks
      |> Enum.with_index
      |> Enum.map(fn {bank, i} ->
        # Clear out the bank we distribute from
        if i == index, do: 0, else: bank
      end)
      |> distribute_memory(index + 1, bank)

    # History
    key = new_banks |> Enum.map(&Integer.to_string/1)

    if history[key] do
      if history[key] == 2 do
        count + 1
      else
        new_history = Map.put(history, key, 2)

        unless is_looped do
          distribute(new_banks, new_history, 0, true)
        else
          distribute(new_banks, new_history, count + 1, is_looped)
        end
      end
    else
      distribute(new_banks, Map.put(history, key, 1), count + 1)
    end
  end

  defp distribute_memory(banks, index, memory) when index >= length(banks) do
    distribute_memory(banks, 0, memory)
  end
  defp distribute_memory(banks, index, memory) when memory == 0 do
    banks
  end
  defp distribute_memory(banks, index, memory) do
    banks
    |> Enum.with_index
    |> Enum.map(fn {bank, i} ->
      if i == index do bank + 1 else bank end
    end)
    |> distribute_memory(index + 1, memory - 1)
  end

  def solve do
    solve_file("inputs/input.txt") |> IO.inspect
  end
end
