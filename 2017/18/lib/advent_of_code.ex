defmodule AdventOfCode do
  defmodule PartA do
    @input "input.txt"
    @instructions File.read!("inputs/" <> @input) |> String.split("\n")

    defp get(state, x) when is_binary(x), do: Map.get(state, x, 0)
    defp get(state, x), do: x

    def set(state, x, y) do
      Map.put(state, x, y)
    end

    defp run_instruction(["set", x, y], state) do
      {set(state, x, get(state, y)), 1}
    end
    defp run_instruction(["snd", x], state) do
      {set(state, "snd", get(state, x)), 1}
    end
    defp run_instruction(["add", x, y], state) do
      {set(state, x, get(state, x) + get(state, y)), 1}
    end
    defp run_instruction(["mul", x, y], state) do
      {set(state, x, get(state, x) * get(state, y)), 1}
    end
    defp run_instruction(["mod", x, y], state) do
      {set(state, x, get(state, x) |> rem(get(state, y))), 1}
    end
    defp run_instruction(["rcv", x], state) do
      case get(state, x) do
        0   -> {state, 1}
        val -> {Map.put(state, "rcv", get(state, "snd")), 1}
      end
    end
    defp run_instruction(["jgz", x, y], state) do
      case get(state, x) do
        val when val > 0 -> {state, y}
        val              -> {state, 1}
      end
    end

    defp run_instructions(state \\ %{}, index \\ 0)
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

  defmodule PartB do
    import PartA

    @input "input.txt"
    @instructions File.read!("inputs/" <> @input) |> String.split("\n")

    def get(state, x) when is_binary(x), do: Map.get(state, x, 0)
    def get(state, :receive), do: Map.get(state, :receive, [])
    def get(state, :send), do: Map.get(state, :send, [])
    def get(state, :send_count), do: Map.get(state, :send_count, 0)
    def get(state, x), do: x

    def run_instruction(["set", x, y], state) do
      {set(state, x, get(state, y)), 1}
    end
    def run_instruction(["snd", x], state) do
      changed_state =
        set(state, :send, get(state, :send) ++ [get(state, x)])
        |> set(:send_count, get(state, :send_count) + 1)

      {changed_state, 1}
    end
    def run_instruction(["add", x, y], state) do
      {set(state, x, get(state, x) + get(state, y)), 1}
    end
    def run_instruction(["mul", x, y], state) do
      {set(state, x, get(state, x) * get(state, y)), 1}
    end
    def run_instruction(["mod", x, y], state) do
      {set(state, x, get(state, x) |> rem(get(state, y))), 1}
    end
    def run_instruction(["rcv", x], state) do
      {val, changed_queue} = get(state, :receive) |> List.pop_at(0)

      case val do
        nil -> {state, 0} # wait
        val ->
          changed_state =
            set(state, x, val)
            |> set(:receive, changed_queue)

          {changed_state, 1}
      end
    end
    def run_instruction(["jgz", x, y], state) do
      case get(state, x) do
        val when val > 0 -> {state, get(state, y)}
        val              -> {state, 1}
      end
    end

    def run_instructions(state \\ %{}, index \\ 0)
    def run_instructions(state, index) when index < 0 or index >= length(@instructions) do
      {state, 0}
    end
    def run_instructions(state, index) do
      Enum.at(@instructions, index)
      |> String.split(" ")
      |> Enum.map(fn el ->
        cond do
          Regex.match?(~r/\d+/, el) -> String.to_integer(el)
          true                      -> el
        end
      end)
      |> run_instruction(state)
    end

    def send_to(sender_state, receiver_state) do
      {queue, changed_sender_state} = sender_state |> Map.pop(:send, [])
      changed_receiver_state = set(receiver_state, :receive, get(receiver_state, :receive) ++ queue)

      {changed_sender_state, changed_receiver_state}
    end

    def run_programs(state0, state1, index0 \\ 0, index1 \\ 0)
    def run_programs(state0, state1, index0, index1) do
      {changed_state0, offset0} = run_instructions(state0, index0)
      {changed_state1, offset1} = run_instructions(state1, index1)

      {changed_state0, changed_state1} = send_to(changed_state0, changed_state1)
      {changed_state1, changed_state0} = send_to(changed_state1, changed_state0)

      cond do
        # deadlock or termination
        offset0 == 0 && offset1 == 0 -> {changed_state0, changed_state1}
        true ->
          run_programs(changed_state0, changed_state1, index0 + offset0, index1 + offset1)
      end
    end

    def solve do
      {state0, state1} = run_programs(%{"p" => 0}, %{"p" => 1})

      Map.fetch!(state1, :send_count) |> IO.inspect
    end
  end
end
