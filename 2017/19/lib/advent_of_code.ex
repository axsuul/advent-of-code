defmodule AdventOfCode do
  defmodule PartA do
    def build_diagram_row(diagram, y, row) do
      row
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(diagram, fn {cell, x}, diagram ->
        Map.put_new(diagram, y, %{})
        |> put_in([y, x], cell)
      end)
    end

    # We are using {x, y} coordinate system with {0, 0} being top left
    def build_diagram_from_input(filename \\ "input.txt") do
      File.read!("inputs/" <> filename)
      |> String.split("\n")
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {row, y}, diagram ->
        build_diagram_row(diagram, y, row)
      end)
    end

    def get_cell(diagram, x, y), do: get_cell(diagram, {x, y})
    def get_cell(diagram, {x, y}) when x < 0 or y < 0, do: " "
    def get_cell(diagram, {x, y}) do
      get_in(diagram, [y, x])
    end

    def empty_cell?(diagram, pos) do
      get_cell(diagram, pos) |> String.trim == ""
    end

    def add_history(history, cell) do
      cond do
        Regex.match?(~r/\w+/, cell) -> history ++ [cell]
        true -> history
      end
    end

    defp travel(diagram) do
      # Find start
      start =
        Map.fetch!(diagram, 0)
        |> Enum.reduce(nil, fn {x, cell}, start ->
          if cell == "|", do: {x, 0}, else: start
        end)

      travel(diagram, start, :down, [])
    end
    defp travel(_, _, :end, history), do: history
    defp travel(diagram, {x, y}, direction, history) do
      cell = get_cell(diagram, {x, y})

      {next_pos, next_direction} =
        case cell do
          " " -> {{x, y}, :end}
          "+" ->
            case direction do
              d when d in [:up, :down] ->
                if empty_cell?(diagram, {x - 1, y}) do
                  {{x + 1, y}, :right}
                else
                  {{x - 1, y}, :left}
                end
              d when d in [:left, :right] ->
                if empty_cell?(diagram, {x, y - 1}) do
                  {{x, y + 1}, :down}
                else
                  {{x, y - 1}, :up}
                end
            end
          ___ ->
            {
              case direction do
                :up    -> {x, y - 1}
                :down  -> {x, y + 1}
                :left  -> {x - 1, y}
                :right -> {x + 1, y}
              end,
              direction
            }
        end

      travel(diagram, next_pos, next_direction, add_history(history, cell))
    end

    def solve do
      build_diagram_from_input()
      |> travel()
      |> Enum.join("")
      |> IO.inspect
    end
  end

  defmodule PartB do
    import PartA

    def travel(diagram) do
      # Find start
      start =
        Map.fetch!(diagram, 0)
        |> Enum.reduce(nil, fn {x, cell}, start ->
          if cell == "|", do: {x, 0}, else: start
        end)

      travel(diagram, start, :down, 0)
    end
    def travel(_, _, :end, steps), do: steps - 1
    def travel(diagram, {x, y}, direction, steps) do
      cell = get_cell(diagram, {x, y})

      {next_pos, next_direction} =
        case cell do
          " " -> {{x, y}, :end}
          "+" ->
            case direction do
              d when d in [:up, :down] ->
                if empty_cell?(diagram, {x - 1, y}) do
                  {{x + 1, y}, :right}
                else
                  {{x - 1, y}, :left}
                end
              d when d in [:left, :right] ->
                if empty_cell?(diagram, {x, y - 1}) do
                  {{x, y + 1}, :down}
                else
                  {{x, y - 1}, :up}
                end
            end
          ___ ->
            {
              case direction do
                :up    -> {x, y - 1}
                :down  -> {x, y + 1}
                :left  -> {x - 1, y}
                :right -> {x + 1, y}
              end,
              direction
            }
        end

      travel(diagram, next_pos, next_direction, steps + 1)
    end

    def solve do
      build_diagram_from_input()
      |> travel()
      |> IO.inspect
    end
  end
end
