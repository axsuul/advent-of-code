defmodule AdventOfCode do
  defmodule PartA do
    def read_input_lines(filename \\ "input.txt") do
      File.read!("inputs/" <> filename)
      |> String.split("\n")
    end

    def sum_components_strength(components, strength \\ 0)
    def sum_components_strength([], strength), do: strength
    def sum_components_strength([component | rest], strength) do
      [port_a, port_b] = component |> String.split("/") |> Enum.map(&String.to_integer/1)

      sum_components_strength(rest, strength + port_a + port_b)
    end

    def build_strongest_bridge(components) do
      build_strongest_bridge([{0, {[], 0}, components}], 0, components)
    end
    def build_strongest_bridge([], max_str, _), do: max_str
    def build_strongest_bridge([{_, {[], _}, []} | rest_q], max_str, components) do
      build_strongest_bridge(rest_q, max_str, components)
    end
    def build_strongest_bridge([{port, {bridge, str}, []} | rest_q], max_str, components) do
      next_max_str = if str > max_str, do: str, else: max_str

      build_strongest_bridge(rest_q, next_max_str, components)
    end
    def build_strongest_bridge([{port, {bridge, str}, [component | rest_c]} | rest_q], max_str, components) do
      [port_a, port_b] = component |> String.split("/") |> Enum.map(&String.to_integer/1)

      next =
        cond do
          Enum.member?(bridge, component) -> []
          Enum.member?([port_a, port_b], port) ->
            next_str = str + port_a + port_b
            next_port = if port == port_a, do: port_b, else: port_a
            next_bridge = bridge ++ [component]
            next_components = components -- next_bridge
            potential_max_str = next_str + sum_components_strength(next_components)

            # Ignore if potential is less than current max str
            if potential_max_str <= max_str do
              []
            else
              [{next_port, {next_bridge, next_str}, next_components}]
            end
          true -> []
        end

      queue = [{port, {bridge, str}, rest_c}] ++ next ++ rest_q

      build_strongest_bridge(queue, max_str, components)
    end

    def solve do
      read_input_lines()
      |> build_strongest_bridge()
      |> IO.inspect
    end
  end

  defmodule PartB do
    import PartA

    def build_longest_bridge(components) do
      build_longest_bridge([{0, {[], 0}, components}], {0, 0}, components)
    end
    def build_longest_bridge([], {max_len, max_str}, _), do: {max_len, max_str}
    def build_longest_bridge([{_, {[], _}, []} | rest_q], max, components) do
      build_longest_bridge(rest_q, max, components)
    end
    def build_longest_bridge([{port, {bridge, str}, []} | rest_q], {max_len, max_str}, components) do
      {next_max_len, next_max_str} =
        cond do
          length(bridge) > max_len -> {length(bridge), str}
          length(bridge) == max_len and str > max_str -> {max_len, str}
          true -> {max_len, max_str}
        end

      build_longest_bridge(rest_q, {next_max_len, next_max_str}, components)
    end
    def build_longest_bridge([{port, {bridge, str}, [component | rest_c]} | rest_q], max = {max_len, max_str}, components) do
      [port_a, port_b] = component |> String.split("/") |> Enum.map(&String.to_integer/1)

      next =
        cond do
          Enum.member?(bridge, component) -> []
          Enum.member?([port_a, port_b], port) ->
            next_str = str + port_a + port_b
            next_port = if port == port_a, do: port_b, else: port_a
            next_bridge = bridge ++ [component]
            next_components = components -- next_bridge
            potential_max_len = length(next_bridge) + length(next_components)

            # Ignore if potential is less than current max len
            if potential_max_len < max_len do
              []
            else
              [{next_port, {next_bridge, next_str}, next_components}]
            end
          true -> []
        end

      queue = [{port, {bridge, str}, rest_c}] ++ next ++ rest_q

      build_longest_bridge(queue, max, components)
    end

    def solve do
      read_input_lines()
      |> build_longest_bridge()
      |> IO.inspect
    end
  end
end
