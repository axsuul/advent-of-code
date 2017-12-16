defmodule AdventOfCode do
  defmodule PartA do
    def read_input do
      File.read!("inputs/input.txt")
      |> String.split(",")
    end

    def gen_programs do
      Enum.to_list(97..112) |> Kernel.to_string |> String.split("", trim: true)
    end

    def find_pos_program(programs, needle), do: find_pos_program(programs, needle, 0)
    def find_pos_program([program | rest], needle, pos) when program == needle, do: pos
    def find_pos_program([program | rest], needle, pos) do
      find_pos_program(rest, needle, pos + 1)
    end

    def do_instruction(programs, "s" <> size) do
      size = String.to_integer(size)

      Enum.slice(programs, -size..-1) ++ Enum.slice(programs, 0..-(size + 1))
    end
    def do_instruction(programs, "x" <> input) do
      [a, b] =
        String.split(input, "/")
        |> Enum.map(&String.to_integer/1)
        |> Enum.sort()

      beginning = if a == 0, do: [], else: Enum.slice(programs, 0..(a - 1))

      beginning ++
      [Enum.at(programs, b)] ++
      Enum.slice(programs, (a + 1)..(b - 1)) ++
      [Enum.at(programs, a)] ++
      Enum.slice(programs, (b + 1)..-1)
    end
    def do_instruction(programs, "p" <> input) do
      [a, b] =
        String.split(input, "/")
        |> Enum.map(fn program ->
          find_pos_program(programs, program)
          |> Integer.to_string()
        end)

      do_instruction(programs, "x" <> a <> "/" <> b)
    end

    def dance(programs, []), do: programs
    def dance(programs, [instruction | rest]) do
      programs
      |> do_instruction(instruction)
      |> dance(rest)
    end

    def solve do
      gen_programs()
      |> dance(read_input)
      |> Enum.join("")
      |> IO.inspect
    end
  end

  defmodule PartB do
    import PartA

    def count_until_repeat(programs, instructions, count \\ 0)
    def count_until_repeat(programs, instructions, count) do
      programs_key = programs |> Enum.join("")

      if count > 0 && gen_programs() == programs do
        count
      else
        programs
        |> dance(instructions)
        |> count_until_repeat(instructions, count + 1)
      end
    end

    def dance_for(programs, until, count \\ 0)
    def dance_for(programs, until, count) when count == until, do: programs
    def dance_for(programs, until, count) do
      programs
      |> dance(read_input())
      |> dance_for(until, count + 1)
    end

    def solve do
      input = read_input()

      repeats_every =
        gen_programs()
        |> count_until_repeat(input)

      # Find out where we need to start dancing from
      # in order to simulate 1 billionth since it repeats
      remaining = rem(1_000_000_000, repeats_every)

      gen_programs()
      |> dance_for(remaining)
      |> Enum.join("")
      |> IO.inspect
    end
  end
end
