defmodule AdventOfCodeTest do
  use ExUnit.Case
  doctest AdventOfCode

  test "stepping" do
    assert AdventOfCode.PartA.step_until(1, 3) == {[0, 1], 1}
    assert AdventOfCode.PartA.step_until(2, 3) == {[0, 2, 1], 1}
    assert AdventOfCode.PartA.step_until(3, 3) == {[0, 2, 3, 1], 2}
  end
end
