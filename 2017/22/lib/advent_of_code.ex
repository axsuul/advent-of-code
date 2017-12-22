defmodule AdventOfCode do
  defmodule PartA do
    def read_input_lines(filename) do
      File.read!("inputs/" <> filename)
      |> String.split("\n")
    end

    def node_key({x, y}), do: node_key(x, y)
    def node_key(x, y) do
      Integer.to_string(x) <> "," <> Integer.to_string(y)
    end

    def coord(state) do
      {get_in(state, [:x]), get_in(state, [:y])}
    end

    def coord_key(state) do
      coord(state) |> node_key()
    end

    def node_value(state) do
      get_in(state, [:map])
      |> get_in([coord_key(state)])
    end

    def infected?(state) do
      node_value(state) == "#"
    end

    def clean(state) do
      put_in(state, [:map, coord_key(state)], ".")
    end

    def infect(state) do
      put_in(state, [:map, coord_key(state)], "#")
      |> get_and_update_in([:infected], &{&1, &1 + 1}) |> elem(1)
    end

    def turn_right(state) do
      next_direction =
        case get_in(state, [:direction]) do
          :up    -> :right
          :down  -> :left
          :right -> :down
          :left  -> :up
        end

      put_in(state, [:direction], next_direction)
    end

    def turn_left(state) do
      next_direction =
        case get_in(state, [:direction]) do
          :up    -> :left
          :down  -> :right
          :right -> :up
          :left  -> :down
        end

      put_in(state, [:direction], next_direction)
    end

    def move_forward(state) do
      {dx, dy} =
        case get_in(state, [:direction]) do
          :up    -> {0, -1}
          :down  -> {0, 1}
          :right -> {1, 0}
          :left  -> {-1, 0}
        end

      get_and_update_in(state, [:x], &{&1, &1 + dx}) |> elem(1)
      |> get_and_update_in([:y], &{&1, &1 + dy}) |> elem(1)
    end

    def load_map(filename \\ "input.txt") do
      lines =
        read_input_lines(filename)

      # Determine center and assume that 0,0 but this is
      # also assuming our map is always an odd size. Then
      # start building map from top left corner
      x = length(lines) |> div(2) |> round() |> Kernel.*(-1)
      y = x

      load_map(lines, x, y, %{})
    end
    def load_map([], _, _, map), do: map
    def load_map([row | rest], x, y, map) do
      {next_map, _} =
        row
        |> String.split("", trim: true)
        |> Enum.reduce({map, x}, fn val, {map, x} ->
          {put_in(map, [node_key(x, y)], val), x + 1}
        end)

      load_map(rest, x, y + 1, next_map)
    end

    def print_map(state) do
      # Find boundary conditions
      {coord_min = {x_min, y_min}, coord_max} =
        get_in(state, [:map])
        |> Enum.reduce({{0, 0}, {0, 0}}, fn {node_key, v}, {{x_min, y_min}, {x_max, y_max}} ->
          [x, y] = node_key |> String.split(",") |> Enum.map(&String.to_integer/1)

          next_x_min = if x < x_min, do: x, else: x_min
          next_y_min = if y < y_min, do: y, else: y_min
          next_x_max = if x > x_max, do: x, else: x_max
          next_y_max = if y > y_max, do: y, else: y_max

          {{next_x_min, next_y_min}, {next_x_max, next_y_max}}
        end)

      print_map(state, coord_min, coord_max, x_min, y_min)
    end
    def print_map(state, _, {_, y_max}, _, y) when y > y_max do
      IO.puts "---------"
      IO.inspect state
      IO.puts "---------"
    end
    def print_map(state, {x_min, y_min}, {x_max, y_max}, x, y) when x > x_max do
      IO.write("\n")
      print_map(state, {x_min, y_min}, {x_max, y_max}, x_min, y + 1)
    end
    def print_map(state, coord_min, coord_max, x, y) do
      key = node_key(x, y)
      val = get_in(state, [:map, key]) || "."

      if coord(state) == {x, y} do
        "[" <> val <> "]"
      else
        " " <> val <> " "
      end
      |> IO.write()

      print_map(state, coord_min, coord_max, x + 1, y)
    end

    defp burst(map, iterations) do
      state = %{map: map, x: 0, y: 0, infected: 0, direction: :up}

      Stream.unfold(state, fn state ->
        next_state =
          cond do
            infected?(state) -> turn_right(state) |> clean()
            true             -> turn_left(state) |> infect()
          end
          |> move_forward()

        {state, next_state}
      end)
      |> Stream.drop(iterations)
      |> Stream.take(1)
      |> Enum.to_list
    end

    def solve do
      load_map()
      |> burst(10_000)
      |> Enum.map(&print_map/1)
    end
  end

  defmodule PartB do
    import PartA

    def weaken(state) do
      put_in(state, [:map, coord_key(state)], "W")
    end

    def flag(state) do
      put_in(state, [:map, coord_key(state)], "F")
    end

    def weakened?(state) do
      node_value(state) == "W"
    end

    def flagged?(state) do
      node_value(state) == "F"
    end

    def reverse(state) do
      next_direction =
        case get_in(state, [:direction]) do
          :up    -> :down
          :down  -> :up
          :right -> :left
          :left  -> :right
        end

      put_in(state, [:direction], next_direction)
    end

    def burst(map, iterations) do
      state = %{map: map, x: 0, y: 0, infected: 0, direction: :up}

      Stream.unfold(state, fn state ->
        next_state =
          cond do
            weakened?(state) -> infect(state)
            infected?(state) -> turn_right(state) |> flag()
            flagged?(state)  -> reverse(state) |> clean()
            true             -> turn_left(state) |> weaken()
          end
          |> move_forward()

        {state, next_state}
      end)
      |> Stream.drop(iterations)
      |> Stream.take(1)
      |> Enum.to_list
    end

    def solve do
      load_map()
      |> burst(10_000_000)
      |> Enum.map(&print_map/1)
    end
  end
end
