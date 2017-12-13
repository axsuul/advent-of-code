defmodule AdventOfCode do
  defmodule PartA do
    def read_input(filename \\ "input.txt") do
      File.read!("inputs/" <> filename) |> String.split("\n")
    end

    def initialize(lines), do: initialize(%{}, lines)
    def initialize(state, []), do: state
    def initialize(state, [line | rest]) do
      [depth, range] = String.split(line, ": ")

      Map.put(state, String.to_integer(depth), %{pos: 0, range: String.to_integer(range), is_reverse: false})
      |> initialize(rest)
    end

    def move_scanner(state, depth) do
      range = get_in(state, [depth, :range])
      pos = get_in(state, [depth, :pos])
      is_reverse = get_in(state, [depth, :is_reverse])

      new_is_reverse =
        case pos do
          pos when pos == 0 -> false
          pos when pos == (range - 1) -> true
          pos -> is_reverse
        end

      new_pos =
        case new_is_reverse do
          false -> pos + 1
          true -> pos - 1
        end

      put_in(state, [depth, :is_reverse], new_is_reverse)
      |> put_in([depth, :pos], new_pos)
    end

    def move_scanners(state, last_depth), do: move_scanners(state, last_depth, 0)
    def move_scanners(state, last_depth, depth) when depth > last_depth, do: state
    def move_scanners(state, last_depth, depth) do
      new_state =
        cond do
          Map.has_key?(state, depth) -> move_scanner(state, depth)
          true -> state
        end

      move_scanners(new_state, last_depth, depth + 1)
    end

    def move_packet(state, depth) do
      cond do
        Map.has_key?(state, depth) ->
          case get_in(state, [depth, :pos]) do
            pos when pos == 0 ->
              depth*get_in(state, [depth, :range])
            pos -> 0
          end
        true -> 0
      end
    end

    def calc_severity(state) do
      last_depth = Map.keys(state) |> Enum.sort |> List.last

      calc_severity(state, 0, 0, last_depth)
    end
    def calc_severity(state, depth, severity, last_depth) when depth > last_depth, do: severity
    def calc_severity(state, depth, severity, last_depth) do
      more_severity = move_packet(state, depth)

      state
      |> move_scanners(last_depth)
      |> calc_severity(depth + 1, severity + more_severity, last_depth)
    end

    def solve do
      read_input()
      |> initialize
      |> calc_severity
      |> IO.inspect
    end
  end
end
