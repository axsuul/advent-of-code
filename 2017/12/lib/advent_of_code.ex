defmodule AdventOfCode do
  defmodule PartA do
    def read_input(filename \\ "input.txt") do
      File.read!("inputs/" <> filename) |> String.split("\n")
    end

    def add_pipe(pipes, a, b) do
      pipes_with_a = pipes |> Map.put_new(a, [a])

      Map.replace(pipes_with_a, a, Enum.uniq(pipes_with_a[a] ++ [b]))
    end

    def build_pipes(lines, pipes \\ %{})
    def build_pipes([], pipes), do: pipes
    def build_pipes([line | rest], pipes) do
      [from, _, tos] = String.split(line, " ", parts: 3)

      from = String.to_integer(from)

      new_pipes =
        String.split(tos, ", ")
        |> Enum.map(&String.to_integer/1)
        |> Enum.reduce(pipes, fn to, pipes ->
          add_pipe(pipes, from, to)
          |> add_pipe(to, from)
        end)

      build_pipes(rest, new_pipes)
    end

    def expand_program(pipes, programs, from, expanded \\ [])
    def expand_program(pipes, [program | rest], from, expanded) when from == program do
      [program] ++ expand_program(pipes, rest, from, expanded)
    end
    def expand_program(pipes, [], _, _), do: []
    def expand_program(pipes, [program | rest], from, expanded) do
      if Enum.member?(expanded, program) do
        expand_program(pipes, rest, from, expanded)
      else
        [program] ++ pipes[program] ++ expand_program(pipes, rest ++ pipes[program], from, expanded ++ [program])
      end
    end

    def solve do
      pipes =
        read_input()
        |> build_pipes()

      pipes
      |> expand_program(pipes[0], 0)
      |> Enum.uniq()
      |> Kernel.length()
      |> IO.inspect
    end
  end

  defmodule PartB do
    import PartA

    def expand_pipes(pipes), do: expand_pipes(pipes, Map.keys(pipes), pipes)
    def expand_pipes(pipes, [], expanded_pipes), do: expanded_pipes
    def expand_pipes(pipes, [key | rest], expanded_pipes) do
      expand_program(pipes, Map.fetch!(pipes, key), key)
      |> Enum.uniq()
      |> Enum.sort()
      |> (&expand_pipes(pipes, rest, Map.replace!(expanded_pipes, key, &1))).()
    end

    def collect_groups(pipes), do: collect_groups(pipes, Map.keys(pipes), [])
    def collect_groups(pipes, [], groups), do: groups
    def collect_groups(pipes, [key | rest], groups) do
      group = Map.fetch!(pipes, key)

      if Enum.member?(groups, group) do
        collect_groups(pipes, rest, groups)
      else
        collect_groups(pipes, rest, groups ++ [group])
      end
    end

    def solve do
      read_input()
      |> build_pipes()
      |> expand_pipes()
      |> collect_groups()
      |> Kernel.length()
      |> IO.inspect
    end
  end
end