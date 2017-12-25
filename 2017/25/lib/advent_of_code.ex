defmodule AdventOfCode do
  defmodule PartA do
    def load_blueprint(filename \\ "input.txt") do
      File.read!("inputs/" <> filename)
      |> String.split("\n")
      |> Enum.with_index()
      |> load_blueprint(%{})
    end
    def load_blueprint([], blueprint), do: blueprint
    def load_blueprint([{line, 0} | rest], blueprint) do
      [_, initial_state] = Regex.run(~r/Begin in state (\w+)/, line)

      put_in(blueprint, ["initial_state"], initial_state)
      |> (&load_blueprint(rest, &1)).()
    end
    def load_blueprint([{line, 1} | rest], blueprint) do
      [_, steps] = Regex.run(~r/Perform a diagnostic checksum after (\d+)/, line)

      put_in(blueprint, ["steps"], steps |> String.to_integer())
      |> (&load_blueprint(rest, &1)).()
    end
    def load_blueprint([{"In state " <> <<state::bytes-size(1)>> <> ":", i} | rest], blueprint) do
      next_blueprint = put_in(blueprint, [state], %{})

      next_blueprint =
        Enum.slice(rest, 0, 4)
        |> load_blueprint_state(state, next_blueprint)

      Enum.slice(rest, 4, 4)
      |> load_blueprint_state(state, next_blueprint)
      |> (&load_blueprint(rest, &1)).()
    end
    def load_blueprint([_ | rest], blueprint) do
      load_blueprint(rest, blueprint)
    end

    def load_blueprint_state([{condition, _}, {write, _}, {move, _}, {continue, _}], state, blueprint) do
      [_, if_value] = Regex.run(~r/current value is (\d+)/, condition)
      [_, write_value] = Regex.run(~r/Write the value (\d+)/, write)
      [_, direction] = Regex.run(~r/Move one slot to the (\w+)/, move)
      [_, next_state] = Regex.run(~r/Continue with state (\w)/, continue)

      condition = %{
        "write" => write_value |> String.to_integer(),
        "move" => direction |> String.to_atom(),
        "next_state" => next_state
      }

      put_in(blueprint, [state, if_value |> String.to_integer()], condition)
    end

    def read_tape(tape, pos) do
      Map.get(tape, pos, 0)
    end

    def update_tape(tape, pos, value) do
      Map.put(tape, pos, value)
    end

    def turing(blueprint) do
      state = get_in(blueprint, ["initial_state"])

      turing(%{"pos" => 0, "state" => state, "steps" => 0}, blueprint, 0)
    end
    def turing(tape, blueprint, count) do
      Stream.unfold({tape, blueprint, count}, fn cur = {tape, blueprint, count} ->
        %{"pos" => pos, "state" => state} = Map.take(tape, ["pos", "state"])
        value = read_tape(tape, pos)

        %{
          "write" => next_value,
          "move" => direction,
          "next_state" => next_state
        } = get_in(blueprint, [state, value])

        next_count =
          cond do
            [value, next_value] == [0, 1] -> count + 1
            [value, next_value] == [1, 0] -> count - 1
            true -> count
          end
        next_pos = if direction == :right, do: pos + 1, else: pos - 1
        next_tape =
          update_tape(tape, pos, next_value)
          |> put_in(["pos"], next_pos)
          |> put_in(["state"], next_state)
          |> get_and_update_in(["steps"], &{&1, &1 + 1}) |> elem(1)

        {cur, {next_tape, blueprint, next_count}}
      end)
      |> Stream.drop_while(fn {tape, _, _} -> get_in(tape, ["steps"]) < get_in(blueprint, ["steps"]) end)
    end

    def solve do
      {_, _, count} =
        load_blueprint()
        |> turing()
        |> Stream.take(1)
        |> Enum.to_list
        |> List.first

      IO.inspect count
    end
  end
end
