defmodule AdventOfCode do
  defmodule PartA do
    def pattern_row_to_pixels(row) do
      row
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> pattern_row_to_pixels(%{})
    end
    def pattern_row_to_pixels([], pixels), do: pixels
    def pattern_row_to_pixels([{v, i} | rest], pixels) do
      pattern_row_to_pixels(rest, put_in(pixels, [i], v))
    end

    def pattern_to_pixels(pattern) do
      pattern
      |> String.split("/")
      |> Enum.with_index()
      |> pattern_to_pixels(%{})
    end
    def pattern_to_pixels([], pixels), do: pixels
    def pattern_to_pixels([{row, y} | rest], pixels) do
      next_pixels =
        put_in(pixels, [y], pattern_row_to_pixels(row))

      pattern_to_pixels(rest, next_pixels)
    end

    def pixels_to_pattern(pixels) do
      pixels_to_pattern(pixels |> Map.to_list(), [])
    end
    def pixels_to_pattern([], row_patterns) do
      row_patterns |> Enum.join("/")
    end
    def pixels_to_pattern([{_, row} | rest], row_patterns) do
      row_pattern =
        row
        |> Enum.reduce("", fn {i, v}, p -> p <> v end)

      pixels_to_pattern(rest, row_patterns ++ [row_pattern])
    end

    def pixels_size(pixels), do: map_size(pixels)

    def rotate_row(pixels, rotated, y) do
      max = pixels_size(pixels) - 1
      rotate_row(pixels, rotated, y, max, max)
    end
    def rotate_row(_, rotated, y, x, _) when x < 0, do: rotated
    def rotate_row(pixels, rotated, y, x, max) do
      next_rotated =
        put_in(rotated, [x, max - y], get_in(pixels, [y, x]))

      rotate_row(pixels, next_rotated, y, x - 1, max)
    end

    # Rotate clockwise
    def rotate(pixels) do
      rotate(pixels, pixels, pixels_size(pixels) - 1)
    end
    def rotate(pixels, rotated, y) when y < 0, do: rotated
    def rotate(pixels, rotated, y) do
      next_rotated = rotate_row(pixels, rotated, y)

      rotate(pixels, next_rotated, y - 1)
    end

    def flip_row(pixels, flipped, y) do
      max = pixels_size(pixels) - 1
      flip_row(pixels, flipped, y, max, max)
    end
    def flip_row(_, flipped, y, x, _) when x < 0, do: flipped
    def flip_row(pixels, flipped, y, x, max) do
      next_flipped =
        put_in(flipped, [y, max - x], get_in(pixels, [y, x]))

      flip_row(pixels, next_flipped, y, x - 1, max)
    end

    # Flip horizontally
    def flip(pixels) do
      flip(pixels, pixels, pixels_size(pixels) - 1)
    end
    def flip(_, flipped, y) when y < 0, do: flipped
    def flip(pixels, flipped, y) do
      next_flipped = flip_row(pixels, flipped, y)

      flip(pixels, next_flipped, y - 1)
    end

    # def split_section_row(pixels, section, size, y, x) do

    # end
    # def split_section_row(pixels, section, size, y, x) do
    #   section_pixel = get_in(pixels, [])
    #   next_section = put_in(section, [y, x])

    # end

    # def split_section(pixels, size, y, x) do
    #   split_section(pixels, %{}, size, size - 1, size - 1)
    # end
    # def split_section(pixels, section, size, _, _) when map_size(section) == size do
    #   section
    # end
    # def split_section(pixels, section, section_size, qy, qx) do
    #   split_section_row(pixels, size, )


    # end
    # def split_row(pixels, split, section_size, max) do

    # end

    def split_section_row(pixel_row, section_size, x) do
      split_section_row(pixel_row, %{}, x, section_size - 1)
    end
    def split_section_row(pixel_row, section_row, x, sx) when sx < 0, do: section_row
    def split_section_row(pixel_row, section_row, x, sx) do
      next_split = put_in(section_row, [sx], get_in(pixel_row, [x]))

      split_section_row(pixel_row, next_split, x - 1, sx - 1)
    end

    def split_section(pixels, section_size, y_max, x_max) do
      split_section(pixels, %{}, section_size, y_max, x_max, section_size - 1)
    end
    def split_section(_, section, _, y, x_max, sy) when sy < 0, do: section
    def split_section(pixels, section, section_size, y, x_max, sy) do
      section_row = split_section_row(get_in(pixels, [y]), section_size, x_max)
      # IO.inspect {y, sy, section_row}
      next_section = put_in(section, [sy], section_row)

      split_section(pixels, next_section, section_size, y - 1, x_max, sy - 1)
    end

    # qy, qx refers to quadrants
    def split_row(pixels, section_size, qy) do
      size = pixels_size(pixels)
      split_row(pixels, %{}, section_size, qy, div(size, section_size) - 1)
    end
    def split_row(_, row, _, _, qx) when qx < 0, do: row
    def split_row(pixels, row, section_size, qy, qx) do
      y_max = (qy + 1)*section_size - 1
      x_max = (qx + 1)*section_size - 1
      section = split_section(pixels, section_size, y_max, x_max)
      next_row = put_in(row, [qx], section)

      split_row(pixels, next_row, section_size, qy, qx - 1)
    end

    def split(pixels) do
      size = pixels_size(pixels)
      section_size = if rem(size, 2) == 0, do: 2, else: 3

      split(pixels, %{}, section_size, div(size, section_size) - 1)
    end
    def split(_, split, _, qy) when qy < 0, do: split
    def split(pixels, split, section_size, qy) do
      sections = split_row(pixels, section_size, qy)
      next_split = put_in(split, [qy], sections)

      split(pixels, next_split, section_size, qy - 1)
    end
  end
end
