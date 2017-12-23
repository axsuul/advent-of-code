defmodule AdventOfCode do
  defmodule PartA do
    @input "input.txt"
    @instructions File.read!("inputs/" <> @input) |> String.split("\n")

    defp get(state, x) when is_binary(x), do: Map.get(state, x, 0)
    defp get(state, x), do: x

    def set(state, x, y) do
      Map.put(state, x, y)
    end

    def run_instruction(["set", x, y], state) do
      {set(state, x, get(state, y)), 1}
    end
    def run_instruction(["sub", x, y], state) do
      {set(state, x, get(state, x) - get(state, y)), 1}
    end
    def run_instruction(["mul", x, y], state) do
      next_state =
        get_and_update_in(state, ["mul_count"], &{&1, &1 + 1}) |> elem(1)
        |> set(x, get(state, x) * get(state, y))

      {next_state, 1}
    end
    def run_instruction(["jnz", x, y], state) do
      case get(state, x) do
        val when val != 0 -> {state, get(state, y)}
        val               -> {state, 1}
      end
    end

    defp run_instructions(state \\ %{ "mul_count" => 0, "a" => 0, "b" => 0, "c" => 0, "d" => 0, "e" => 0, "f" => 0, "g" => 0, "h" => 0 }, index \\ 0)
    defp run_instructions(state, index) when index < 0 or index >= length(@instructions) do
      state
    end
    defp run_instructions(state, index) do
      {changed_state, offset} =
        Enum.at(@instructions, index)
        |> String.split(" ")
        |> Enum.map(fn el ->
          cond do
            Regex.match?(~r/\d+/, el) -> String.to_integer(el)
            true                      -> el
          end
        end)
        |> run_instruction(state)

      run_instructions(changed_state, index + offset)
    end

    def solve do
      run_instructions()
      |> IO.inspect
    end
  end

  defmodule PartB do
    import PartA

    def solve do
      b = 93
      c = b
      b = b * 100
      b = b + 100_000
      c = b
      c = c + 17_000

      {_, h} =
        Stream.unfold({b, 0}, fn cur = {b, h} ->
          {_, _, f} =
            Stream.unfold({b, 2, 1}, fn cur = {b, d, f} ->
              # Don't have to loop through all values of e
              # since it's just checking if it's a multiple
              next_f = if rem(b, d) == 0, do: 0, else: f

              {cur, {b, d + 1, next_f}}
            end)
            |> Stream.drop_while(fn {b, d, f} -> b != d end)
            |> Stream.take(1)
            |> Enum.to_list
            |> List.first

          next_h = if f == 0, do: h + 1, else: h

          {cur, {b + 17, next_h}}
        end)
        |> Stream.drop_while(fn {b, h} -> (b - 17) != c end)
        |> Stream.take(1)
        |> Enum.to_list
        |> List.first

      IO.inspect h
    end
  end
end
