defmodule AdventOfCode do
  def is_passphrase_valid(:a, passphrase) do
    result =
      String.split(passphrase, " ")
      |> Enum.reduce(%{}, fn part, result ->
        unless result do
          result
        else
          if result[part] do
            false
          else
            Map.put(result, part, 1)
          end
        end
      end)

    if result, do: true, else: false
  end

  def count_valid_passphrases(:a, filename) do
    File.read!(filename)
    |> String.split("\n")
    |> Enum.reduce(0, fn passphrase, count ->
      if is_passphrase_valid(:a, passphrase), do: count + 1, else: count
    end)
  end

  def is_passphrase_valid(:b, passphrase) do
    result =
      String.split(passphrase, " ")
      |> Enum.reduce(%{}, fn part, result ->
        unless result do
          result
        else
          if result[part] do
            false
          else
            # When storing in our map, store all combinations
            # to account for anagrams
            generate_anagrams(:b, part)
            |> Enum.reduce(%{}, fn anagram, result ->
              Map.put(result, anagram, true)
            end)
            |> Map.merge(result)
          end
        end
      end)

    if result, do: true, else: false
  end

  def generate_anagrams(:b, string) do
    0..(String.length(string) - 1)
    |> Combination.permutate
    |> Enum.map(fn permutation ->
      Enum.map(permutation, fn index -> String.at(string, index) end)
      |> Enum.join("")
    end)
  end

  def count_valid_passphrases(:b, filename) do
    File.read!(filename)
    |> String.split("\n")
    |> Enum.reduce(0, fn passphrase, count ->
      if is_passphrase_valid(:b, passphrase), do: count + 1, else: count
    end)
  end

  def a do
    count_valid_passphrases(:a, "inputs/input.txt") |> IO.inspect
  end

  def b do
    count_valid_passphrases(:b, "inputs/input.txt") |> IO.inspect
  end
end
