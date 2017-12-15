use Bitwise

defmodule AdventOfCode do
  defmodule PartA do
    @pairs_count 40_000_000
    @a_start 883
    @b_start 879

    def generate(value, factor) do
      {value, value*factor |> rem(2147483647)}
    end

    def calc_binary_tail(value) do
      # AND operation since 65535 is 16-bit and use that to
      # mask our value
      value &&& 65535
    end

    def judge({a, b}) do
      calc_binary_tail(a) == calc_binary_tail(b)
    end

    defp count_pairs(a, b) do
      gen_a = Stream.unfold(a, fn aa -> generate(aa, 16807) end)
      gen_b = Stream.unfold(b, fn bb -> generate(bb, 48271) end)

      Stream.zip(gen_a, gen_b)
      |> Stream.take(@pairs_count)
      |> Stream.filter(&judge/1)
      |> Enum.to_list
      |> Kernel.length
    end

    def solve do
      count_pairs(@a_start, @b_start)
      |> IO.inspect
    end
  end

  defmodule PartB do
    import PartA

    @pairs_count 5_000_000
    @a_start 883
    @b_start 879

    def stream_generator(val, factor, multiple) do
      Stream.unfold(val, fn val -> generate(val, factor) end)
      |> Stream.filter(fn changed_val -> Integer.mod(changed_val, multiple) == 0 end)
    end

    def count_pairs(a, b) do
      gen_a = stream_generator(a, 16807, 4)
      gen_b = stream_generator(b, 48271, 8)

      Stream.zip(gen_a, gen_b)
      |> Stream.take(@pairs_count)
      |> Stream.filter(&judge/1)
      |> Enum.to_list
      |> Kernel.length
    end

    def solve do
      count_pairs(@a_start, @b_start)
      |> IO.inspect
    end
  end
end
