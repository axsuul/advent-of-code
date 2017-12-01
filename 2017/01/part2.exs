input = File.read! "part2.txt"

defmodule Advent do
  def solve_captcha(input) do
    digits = String.graphemes(input)
    steps_forward = round(length(digits)/2)

    last_index = length(digits) - 1

    sum =
      digits
      |> Enum.with_index
      |> Enum.reduce(0, fn({digit, index}, sum) ->
          digit = String.to_integer(digit)

          # circular list
          next_index = index + steps_forward
          next_index = if (next_index > last_index), do: (next_index - last_index - 1), else: next_index

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