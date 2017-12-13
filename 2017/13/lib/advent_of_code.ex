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

    def last_depth(state) do
      Map.keys(state) |> Enum.sort |> List.last
    end

    def move_scanners(state), do: move_scanners(state, last_depth(state), 0)
    def move_scanners(state, last_depth, depth) when depth > last_depth, do: state
    def move_scanners(state, last_depth, depth) do
      new_state =
        cond do
          Map.has_key?(state, depth) -> move_scanner(state, depth)
          true -> state
        end

      move_scanners(new_state, last_depth, depth + 1)
    end

    defp move_packet(state, depth) do
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

    def calc_severity(state), do: calc_severity(state, 0, 0, last_depth(state))
    def calc_severity(state, depth, severity, last_depth) when depth > last_depth, do: severity
    def calc_severity(state, depth, severity, last_depth) do
      more_severity = move_packet(state, depth)

      state
      |> move_scanners()
      |> calc_severity(depth + 1, severity + more_severity, last_depth)
    end

    def solve do
      read_input()
      |> initialize()
      |> calc_severity()
      |> IO.inspect
    end
  end

  defmodule PartB do
    import PartA

    def move_packet(state, depth) do
      cond do
        Map.has_key?(state, depth) ->
          case get_in(state, [depth, :pos]) do
            pos when pos == 0 -> true
            pos -> false
          end
        true -> false
      end
    end

    def is_caught(state), do: is_caught(state, 0, 0, last_depth(state))
    def is_caught(state, depth, true, last_depth), do: true
    def is_caught(state, depth, is_caught, last_depth) when depth > last_depth, do: false
    def is_caught(state, depth, is_caught, last_depth) do
      is_caught = move_packet(state, depth)

      state
      |> move_scanners()
      |> is_caught(depth + 1, is_caught, last_depth)
    end

    def delay_state(state, 0), do: state
    def delay_state(state, delay) do
      move_scanners(state)
      |> delay_state(delay - 1)
    end

    def try_delay(state), do: try_delay(state, 0)
    def try_delay(state, delay) do
      case is_caught(state) do
        false -> delay
        true -> move_scanners(state) |> try_delay(delay + 1)
      end
    end

    def solve do
      read_input()
      |> initialize()
      |> try_delay()
      |> IO.inspect
    end
  end
end
