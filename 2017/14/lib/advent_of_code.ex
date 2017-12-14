use Bitwise

# From Day 10
defmodule KnotHash do
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

  def calc(string) do
    lengths =
    to_charlist(string)
      |> Enum.concat([17, 31, 73, 47, 23])

    Enum.to_list(0..255)
    |> tie_knot_rounds(0, 0, lengths, 64)
    |> generate_dense_hash()
    |> Enum.map(&num_to_hex/1)
    |> Enum.join("")
  end
end

defmodule AdventOfCode do
  defmodule PartA do
    def read_input do
      # "flqrgnkx"
      "oundnydw"
    end

    def hex_to_binary(str) when is_binary(str) do
      hex_to_binary(String.split(str, "", trim: true))
    end
    def hex_to_binary([]), do: ""
    def hex_to_binary([char | rest]) do
      binary =
        case char do
          "0" -> "0000"
          "1" -> "0001"
          "2" -> "0010"
          "3" -> "0011"
          "4" -> "0100"
          "5" -> "0101"
          "6" -> "0110"
          "7" -> "0111"
          "8" -> "1000"
          "9" -> "1001"
          "a" -> "1010"
          "b" -> "1011"
          "c" -> "1100"
          "d" -> "1101"
          "e" -> "1110"
          "f" -> "1111"
        end

      binary <> hex_to_binary(rest)
    end

    def grid_key(x, y) do
      Integer.to_string(x) <> Integer.to_string(y)
    end

    def build_row(grid, x, _, _, used_count) when x > 127, do: {grid, used_count}
    def build_row(grid, x, y, binary, used_count) do
      is_free = if String.at(binary, x) == "0", do: true, else: false
      new_used_count = if is_free, do: used_count, else: used_count + 1

      Map.put(grid, grid_key(x, y), is_free)
      |> build_row(x + 1, y, binary, new_used_count)
    end

    def build_grid(key), do: build_grid(%{}, key, 0, 0)
    def build_grid(_, _, y, used_count) when y > 127, do: used_count
    def build_grid(grid, key, y, used_count) do
      binary =
        key <> "-" <> Integer.to_string(y)
        |> KnotHash.calc()
        |> hex_to_binary

      IO.inspect y

      {new_grid, new_used_count} = build_row(grid, 0, y, binary, used_count)
      build_grid(new_grid, key, y + 1, new_used_count)
    end

    def solve do
      read_input()
      |> build_grid
      |> IO.inspect
    end
  end
end
