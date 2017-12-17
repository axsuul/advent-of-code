defmodule AdventOfCode do
  defmodule PartA do
    @input 303

    defp step_until(val, steps) do
      step([0], 1, 0, 0, val, steps)
    end

    defp step(state, val, pos, _, target, _) when val == target + 1 do
      {state, pos}
    end
    defp step(state, val, pos, steps_taken, target, steps) when pos >= length(state) do
      step(state, val, 0, steps_taken, target, steps)
    end
    defp step(state, val, pos, steps_taken, target, steps) when pos >= length(state) and steps == steps_taken do
      step([val] ++ state, val + 1, 0, steps, target, steps)
    end
    defp step(state, val, pos, steps_taken, target, steps) when steps == steps_taken do
      Enum.slice(state, 0..pos) ++ [val] ++ Enum.slice(state, pos+1..-1)
      |> step(val + 1, pos + 1, 0, target, steps)
    end
    defp step(state, val, pos, steps_taken, target, steps) do
      step(state, val, pos + 1, steps_taken + 1, target, steps)
    end

    def solve do
      {state, pos} = step_until(2017, @input)

      Enum.at(state, pos + 1)
      |> IO.inspect
    end
  end

  defmodule PartB do
    import PartA

    @input 303

    def step_until(val, steps) do
      step(2, 1, 1, 1, val, steps)
    end

    def step(state_length, pos, val, first_val, target, steps)
    def step(state_length, 1, val, first_val, target, steps) when val != first_val do
      step(state_length, 1, val, val, target, steps)
    end
    def step(state_length, pos, val, first_val, target, steps) when pos >= state_length do
      step(state_length, pos - state_length + 1, val, first_val, target, steps)
    end
    def step(state_length, pos, val, first_val, target, steps) when val == target do
      %{length: state_length, val_after_zero: first_val}
    end
    def step(state_length, pos, val, first_val, target, steps) do
      step(state_length + 1, pos + steps + 1, val + 1, first_val, target, steps)
    end

    def solve do
      step_until(50_000_000, @input)
      |> IO.inspect
    end
  end
end