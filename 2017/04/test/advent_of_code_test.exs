defmodule AdventOfCodeTest do
  use ExUnit.Case
  doctest AdventOfCode

  test "part b valid passphrases" do
    assert AdventOfCode.is_passphrase_valid(:b, "abcde fghij") == true
    assert AdventOfCode.is_passphrase_valid(:b, "abcde xyz ecdab") == false
    assert AdventOfCode.is_passphrase_valid(:b, "a ab abc abd abf abj") == true
    assert AdventOfCode.is_passphrase_valid(:b, "iiii oiii ooii oooi oooo") == true
    assert AdventOfCode.is_passphrase_valid(:b, "oiii ioii iioi iiio") == false
  end
end
