defmodule AdventOfCode do
  defmodule PartA do
    @input "input.txt"
    @instructions File.read!("inputs/" <> @input) |> String.split("\n")

    def get(state, x) do
      if is_binary(x), do: Map.get(state, x, 0), else: x
    end

    def set(state, x, y) do
      Map.put(state, x, y)
    end

    def run_instruction(["set", x, y], state) do
      {set(state, x, get(state, y)), 1}
    end
    def run_instruction(["snd", x], state) do
      {set(state, "snd", get(state, x)), 1}
    end
    def run_instruction(["add", x, y], state) do
      {set(state, x, get(state, x) + get(state, y)), 1}
    end
    def run_instruction(["mul", x, y], state) do
      {set(state, x, get(state, x) * get(state, y)), 1}
    end
    def run_instruction(["mod", x, y], state) do
      # IO.inspect {get(state, x), get(state, y)}
      # IO.inspect state
      {set(state, x, get(state, x) |> rem(get(state, y))), 1}
    end
    def run_instruction(["rcv", x], state) do
      case get(state, x) do
        0   -> {state, 1}
        val -> {Map.put(state, "rcv", get(state, "snd")), 1}
      end
    end
    def run_instruction(["jgz", x, y], state) do
      case get(state, x) do
        val when val > 0 -> {state, y}
        val              -> {state, 1}
      end
    end

    def run_instructions(state \\ %{}, index \\ 0)
    def run_instructions(state, index) when index < 0 or index >= length(@instructions) do
      state
    end
    def run_instructions(state, index) do
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

      case get(changed_state, "rcv") do
        val when val > 0 -> "Recovered frequency: " <> Integer.to_string(val)
        val -> run_instructions(changed_state, index + offset)
      end
    end

    def solve do
      run_instructions()
      |> IO.inspect
    end
  end
end
