use Bitwise

defmodule AdventOfCode.PartA do
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

    Enum.to_list(0..255)
    |> tie_knot(0, 0, lengths)
    |> IO.inspect
  end
end

defmodule AdventOfCode.PartB do
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

  defp tie_knot(list, pos, skip_size, []) do
    {pos, skip_size, list}
  end
  defp tie_knot(list, pos, skip_size, lengths) when pos >= length(list) do
    tie_knot(list, pos - length(list), skip_size, lengths)
  end
  defp tie_knot(list, pos, skip_size, [length | rest]) do
    reverse(list, pos, length)
    |> tie_knot(pos + length + skip_size, skip_size + 1, rest)
  end

  defp tie_knot_rounds(list, pos, skip_size, lengths, 0), do: list
  defp tie_knot_rounds(list, pos, skip_size, lengths, round) do
    {new_pos, new_skip_size, new_list} = tie_knot(list, pos, skip_size, lengths)

    tie_knot_rounds(new_list, new_pos, new_skip_size, lengths, round - 1)
  end

  defp generate_dense_hash([]), do: []
  defp generate_dense_hash(list) do
    output =
      list
      |> Enum.slice(1, 15)
      |> Enum.reduce(Enum.at(list, 0), fn num, output ->
        output ^^^ num
      end)

    [output] ++ generate_dense_hash(Enum.slice(list, 16, length(list) - 16))
  end

  defp num_to_hex(num, pos \\ 0, count \\ 0, prefix \\ 0)
  defp num_to_hex(num, pos, count, prefix) when pos == 16 do
    num_to_hex(num, 0, count, prefix + 1)
  end
  defp num_to_hex(num, pos, count, prefix) when num == count do
    hex =
      ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]

    Enum.at(hex, prefix) <> Enum.at(hex, pos)
  end

  defp num_to_hex(num, pos, count, prefix) do
    num_to_hex(num, pos + 1, count + 1, prefix)
  end

  def solve do
    lengths =
      '106,118,236,1,130,0,235,254,59,205,2,87,129,25,255,118'
      |> Enum.concat([17, 31, 73, 47, 23])

    Enum.to_list(0..255)
    |> tie_knot_rounds(0, 0, lengths, 64)
    |> generate_dense_hash()
    |> Enum.map(&num_to_hex/1)
    |> Enum.join("")
    |> IO.inspect
  end
end
