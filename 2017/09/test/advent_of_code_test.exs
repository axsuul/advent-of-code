defmodule AdventOfCodeTest do
  use ExUnit.Case
  doctest AdventOfCode

  test "cleaning" do
    assert AdventOfCode.clean("!!") == ""
    assert AdventOfCode.clean("!>") == ""
    assert AdventOfCode.clean("<>") == "<>"
    assert AdventOfCode.clean("{<>}") == "{<>}"
    assert AdventOfCode.clean("<random characters>") == "<>"
    assert AdventOfCode.clean("<<<<>") == "<>"
    assert AdventOfCode.clean("<{!>}>") == "<>"
    assert AdventOfCode.clean("<{!>}><>") == "<><>"
  end

  test "scoring cleaned" do
    assert AdventOfCode.score_cleaned("{}") == 1
    assert AdventOfCode.score_cleaned("{{}}") == 3
    assert AdventOfCode.score_cleaned("{{{}}}") == 6
    assert AdventOfCode.score_cleaned("{{},{}}") == 5
    assert AdventOfCode.score_cleaned("{{{},{},{{}}}}") == 16
    assert AdventOfCode.score_cleaned("{<>},{{<>},{}}") == 6
    assert AdventOfCode.score_cleaned("{<>,<>,<>,<>}") == 1
    assert AdventOfCode.score_cleaned("{{},{},{},{}}") == 9
    assert AdventOfCode.score_cleaned("{{<>},{<>},{<>},{<>}}") == 9
  end

  test "scoring" do
    assert AdventOfCode.score("{<a>,<a>,<a>,<a>}") == 1
    assert AdventOfCode.score("{{<ab>},{<ab>},{<ab>},{<ab>}}") == 9
    assert AdventOfCode.score("{{<!!>},{<!!>},{<!!>},{<!!>}}") == 9
    assert AdventOfCode.score("{{<a!>},{<a!>},{<a!>},{<ab>}}") == 3
  end

  test "cleaning and counting" do
    assert AdventOfCode.clean_and_count("<>") == 0
    assert AdventOfCode.clean_and_count("<random characters>") == 17
    assert AdventOfCode.clean_and_count("<<<<>") == 3
    assert AdventOfCode.clean_and_count("<{!>}>") == 2
    assert AdventOfCode.clean_and_count("<!!>") == 0
    assert AdventOfCode.clean_and_count("<!!!>>") == 0
    assert AdventOfCode.clean_and_count("<{o\"i!a,<{i<a>") == 10
  end
end
