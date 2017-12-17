defmodule AdventOfCode do
  defmodule PartA do
    @input 303

    def step_until(val, steps) do
      step([0], 1, 0, 0, val, steps)
    end

    def step(state, val, pos, _, target, _) when val == target + 1 do
      {state, pos}
    end
    def step(state, val, pos, steps_taken, target, steps) when pos >= length(state) do
      step(state, val, 0, steps_taken, target, steps)
    end
    def step(state, val, pos, steps_taken, target, steps) when pos >= length(state) and steps == steps_taken do
      step([val] ++ state, val + 1, 0, steps, target, steps)
    end
    def step(state, val, pos, steps_taken, target, steps) when steps == steps_taken do
      Enum.slice(state, 0..pos) ++ [val] ++ Enum.slice(state, pos+1..-1)
      |> step(val + 1, pos + 1, 0, target, steps)
    end
    def step(state, val, pos, steps_taken, target, steps) do
      step(state, val, pos + 1, steps_taken + 1, target, steps)
    end

    def solve do
      {state, pos} = step_until(2017, @input)

      Enum.at(state, pos + 1)
      |> IO.inspect
    end
  end
end