defmodule AdventOfCodeTest do
  use ExUnit.Case
  doctest AdventOfCode

  test "rotate and flipping pixels" do
    pattern = ".#./..#/###"

    pixels = AdventOfCode.PartA.pattern_to_pixels(pattern)

    assert pixels == %{
      0 => %{ 0 => ".", 1 => "#", 2 => "." },
      1 => %{ 0 => ".", 1 => ".", 2 => "#" },
      2 => %{ 0 => "#", 1 => "#", 2 => "#" }
    }

    rotated = AdventOfCode.PartA.rotate(pixels)

    assert rotated == %{
      0 => %{ 0 => "#", 1 => ".", 2 => "." },
      1 => %{ 0 => "#", 1 => ".", 2 => "#" },
      2 => %{ 0 => "#", 1 => "#", 2 => "." }
    }

    rotated_pattern = AdventOfCode.PartA.pixels_to_pattern(rotated)

    assert rotated_pattern == "#../#.#/##."

    flipped_pattern =
      AdventOfCode.PartA.flip(pixels)
      |> AdventOfCode.PartA.pixels_to_pattern()

    assert flipped_pattern == ".#./#../###"
  end

  test "splitting 2x2 pixels" do
    pattern = "../.#"

    split =
      pattern
      |> AdventOfCode.PartA.pattern_to_pixels()
      |> AdventOfCode.PartA.split()

    assert split == %{
      0 => %{
        0 => %{
          0 => %{0 => ".", 1 => "."},
          1 => %{0 => ".", 1 => "#"}
        }
      }
    }
  end

  test "splitting 3x3 pixels" do
    pattern = ".#./..#/###"

    split =
      pattern
      |> AdventOfCode.PartA.pattern_to_pixels()
      |> AdventOfCode.PartA.split()

      # IO.inspect split

    assert split == %{
      0 => %{
        0 => %{
          0 => %{0 => ".", 1 => "#", 2 => "."},
          1 => %{0 => ".", 1 => ".", 2 => "#"},
          2 => %{0 => "#", 1 => "#", 2 => "#"}
        }
      }
    }
  end

  test "splitting 4x4 pixels" do
    pattern = "#..#/..../..../#..#"

    split =
      pattern
      |> AdventOfCode.PartA.pattern_to_pixels()
      |> AdventOfCode.PartA.split()

    assert split == %{
      0 => %{
        0 => %{
          0 => %{0 => "#", 1 => "."},
          1 => %{0 => ".", 1 => "."}
        },
        1 => %{
          0 => %{0 => ".", 1 => "#"},
          1 => %{0 => ".", 1 => "."}
        }
      },
      1 => %{
        0 => %{
          0 => %{0 => ".", 1 => "."},
          1 => %{0 => "#", 1 => "."}
        },
        1 => %{
          0 => %{0 => ".", 1 => "."},
          1 => %{0 => ".", 1 => "#"}
        }
      }
    }

    # split_pattern =
    #   split
    #   |> Enum.reduce(%{}, fn {i, p}, pat ->
    #     IO.inspect {i, get_in(p, [i]), pat}
    #     # pattern = AdventOfCode.PartA.pixels_to_pattern(p)
    #     # IO.inspect pattern
    #     # put_in(pat, [i], pattern)
    #   end)

    # # split
    # # |> AdventOfCode.PartA.pixels_to_pattern()

    # # |> assert == [["#"]]

    # assert split == %{
    #   0 => %{0 => "#./..", 1 => ".#/.."},
    #   1 => %{0 => "../#.", 1 => "../.#"}
    # }
  end
end
