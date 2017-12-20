defmodule AdventOfCodeTest do
  use ExUnit.Case
  doctest AdventOfCode

  test "tick particle" do
    particle = {[3,0,0],[2,0,0],[-1,0,0],0}
    assert AdventOfCode.PartB.tick_particle(particle) == {[4,0,0],[1,0,0],[-1,0,0],0}
  end
end
