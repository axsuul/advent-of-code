defmodule AdventOfCode.PartA do
  def read_input(filename \\ "input.txt") do
    File.read!("inputs/" <> filename) |> String.split("\n")
  end

  defp add_pipe(pipes, a, b) do
    pipes_with_a = pipes |> Map.put_new(a, [a])

    Map.replace(pipes_with_a, a, Enum.uniq(pipes_with_a[a] ++ [b]))
  end

  defp build_pipes(lines, pipes \\ %{})
  defp build_pipes([], pipes), do: pipes
  defp build_pipes([line | rest], pipes) do
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

  defp expand_program(pipes, programs, from, expanded \\ [])
  defp expand_program(pipes, [program | rest], from, expanded) when from == program do
    expand_program(pipes, rest, from, expanded)
  end
  defp expand_program(pipes, [], _, _), do: []
  defp expand_program(pipes, [program | rest], from, expanded) do
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
    |> Enum.uniq
    |> Kernel.length
    |> IO.inspect
  end
end
