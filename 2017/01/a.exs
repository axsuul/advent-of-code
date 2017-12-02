input = File.read! "part1.txt"

defmodule Advent do
  def solve_captcha(input) do
    digits = String.graphemes(input)
    last_index = length(digits) - 1

    sum =
      digits
      |> Enum.with_index
      |> Enum.reduce(0, fn({digit, index}, sum) ->
          digit = String.to_integer(digit)

          # circular list
          next_index = if (index == last_index), do: 0, else: index+1

          next_digit = String.to_integer(Enum.at(digits, next_index))

          if digit == next_digit do
            digit + sum
          else
            sum
          end
         end)

    IO.puts sum
  end
end

Advent.solve_captcha(input)