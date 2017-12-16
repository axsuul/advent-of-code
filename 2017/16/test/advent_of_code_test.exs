defmodule AdventOfCodeTest do
  use ExUnit.Case
  doctest AdventOfCode

  test "dancing" do
    assert AdventOfCode.PartA.do_instruction("abcde" |> String.split("", trim: true), "s1") == "eabcd" |> String.split("", trim: true)
    assert AdventOfCode.PartA.do_instruction("eabcd" |> String.split("", trim: true), "x3/4") == "eabdc" |> String.split("", trim: true)
    assert AdventOfCode.PartA.do_instruction("abcde" |> String.split("", trim: true), "x0/2") == "cbade" |> String.split("", trim: true)
    assert AdventOfCode.PartA.do_instruction("abcde" |> String.split("", trim: true), "x0/4") == "ebcda" |> String.split("", trim: true)
    assert AdventOfCode.PartA.do_instruction("abcde" |> String.split("", trim: true), "x2/4") == "abedc" |> String.split("", trim: true)
    assert AdventOfCode.PartA.do_instruction("abcde" |> String.split("", trim: true), "x4/0") == "ebcda" |> String.split("", trim: true)
    assert AdventOfCode.PartA.do_instruction("efghijlknmopabcd" |> String.split("", trim: true), "x15/8") == "efghijlkdmopabcn" |> String.split("", trim: true)
    assert AdventOfCode.PartA.do_instruction("eabdc" |> String.split("", trim: true), "pe/b") == "baedc" |> String.split("", trim: true)
  end
end
