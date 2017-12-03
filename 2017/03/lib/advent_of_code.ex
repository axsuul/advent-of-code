defmodule AdventOfCode do
  def a_get_coord(target,
                square \\ 1,
                coord \\ {0, 0},
                grid \\ %{0 => %{ 0 => 1 }},
                instruction \\ :right) do
    {x, y} = coord

    # If we need to change direction but don't need to change
    # until we are past square 1
    if square > 1 do
      instruction =
        case instruction do
          :right -> unless grid[x][y+1], do: :up, else: :right
          :up    -> unless grid[x-1][y], do: :left, else: :up
          :left  -> unless grid[x][y-1], do: :down, else: :left
          :down  -> unless grid[x+1][y], do: :right, else: :down
        end
    end

    # Move
    case instruction do
      :right -> x = x + 1
      :up    -> y = y + 1
      :left  -> x = x - 1
      :down  -> y = y - 1
    end

    # Updated
    square = square + 1
    coord = {x, y}

    # Update grid
    unless grid[x] do grid = put_in grid[x], %{} end
    grid = put_in grid[x][y], square

    if target == square do
      coord
    else
      a_get_coord(target, square, coord, grid, instruction)
    end
  end

  def b_get_value(min,
                  square \\ 1,
                  coord \\ {0, 0},
                  grid \\ %{0 => %{ 0 => 1 }},
                  instruction \\ :right) do
    {x, y} = coord

    # If we need to change direction but don't need to change
    # until we are past square 1
    if coord != {0, 0} do
      instruction =
        case instruction do
          :right -> unless grid[x][y+1], do: :up, else: :right
          :up    -> unless grid[x-1][y], do: :left, else: :up
          :left  -> unless grid[x][y-1], do: :down, else: :left
          :down  -> unless grid[x+1][y], do: :right, else: :down
        end
    end

    # Move
    case instruction do
      :right -> x = x + 1
      :up    -> y = y + 1
      :left  -> x = x - 1
      :down  -> y = y - 1
    end

    # Determine value of square by calculating sum of adjacent values
    coord = {x, y}
    square =
      [
        {x+1, y+1},
        {x+1, y},
        {x+1, y-1},
        {x, y+1},
        {x, y-1},
        {x-1, y+1},
        {x-1, y},
        {x-1, y-1}
      ]
      |> Enum.reduce(0, fn adj_coord, sum ->
        {adj_x, adj_y} = adj_coord

        if grid[adj_x][adj_y] do
          sum = sum + grid[adj_x][adj_y]
        else
          sum
        end
      end)

    # Update grid
    unless grid[x] do grid = put_in grid[x], %{} end
    grid = put_in grid[x][y], square

    if square > min do
      {square, coord}
    else
      b_get_value(min, square, coord, grid, instruction)
    end
  end

  def a do
    {x, y} = a_get_coord(361527)

    abs(x) + abs(y) |> IO.inspect
  end

  def b do
    b_get_value(361527) |> IO.inspect
  end
end
