defmodule AdventOfCode.Part1 do
  defp rearrange([], _), do: []
  defp rearrange(list, pos) when pos == length(list), do: rearrange(list, 0)
  defp rearrange(list, pos) do
    {el, new_list} = List.pop_at(list, pos)

    [el] ++ rearrange(new_list, pos)
  end

  defp reverse(list, pos, length) do
    new_list = rearrange(list, pos)

    new_list
    |> Enum.slice(0, length)
    |> Enum.reverse
    |> Enum.concat(Enum.slice(new_list, length, length(new_list) - length + 1))
    |> rearrange(length(new_list) - pos)
  end

  defp tie_knot(list, pos, skip_size, []), do: list
  defp tie_knot(list, pos, skip_size, lengths) when pos >= length(list) do
    tie_knot(list, pos - length(list), skip_size, lengths)
  end
  defp tie_knot(list, pos, skip_size, [length | rest]) do
    reverse(list, pos, length)
    |> tie_knot(pos + length + skip_size, skip_size + 1, rest)
  end

  def solve do
    lengths =
      "106,118,236,1,130,0,235,254,59,205,2,87,129,25,255,118"
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    tie_knot(Enum.to_list(0..255), 0, 0, lengths)
    |> IO.inspect
  end
end
