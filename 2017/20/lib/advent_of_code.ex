defmodule AdventOfCode do
  defmodule PartA do
    def read_lines(filename \\ "input.txt") do
      File.read!("inputs/" <> filename)
      |> String.split("\n")
    end

    def calc_manhattan([x, y, z]) do
      abs(x) + abs(y) + abs(z)
    end

    def reduce_slowest(lines) do
      lines
      |> Enum.with_index
      |> reduce_slowest(nil)
    end
    def reduce_slowest([], slowest), do: slowest
    def reduce_slowest([{line, i} | rest], slowest) do
      [[_, p_str], [_, v_str], [_, a_str]] = Regex.scan(~r/\<([^\>]+)>/, line)

      particle =
        Enum.map([p_str, v_str, a_str], fn v ->
          String.split(v, ",")
          |> Enum.map(&String.to_integer/1)
          |> calc_manhattan()
        end)

      [p, v, a] = particle

      new_slowest =
        cond do
          slowest == nil ->
            {particle, i}
          true ->
            {[pp, vv, aa], _} = slowest

            cond do
              a < aa -> {particle, i}
              a == aa ->
                cond do
                  v < vv -> {particle, i}
                  v == vv ->
                    cond do
                      p < pp -> {particle, i}
                      true -> slowest
                    end
                  true -> slowest
                end
              true -> slowest
            end
        end

      reduce_slowest(rest, new_slowest)
    end

    def solve do
      read_lines()
      |> reduce_slowest()
      |> IO.inspect
    end
  end

  defmodule PartB do
    import PartA

    def build_particles(lines) do
      build_particles(lines |> Enum.with_index, [])
    end
    def build_particles([], particles), do: particles
    def build_particles([{line, i} | rest], particles) do
      [[_, p], [_, v], [_, a]] = Regex.scan(~r/\<([^\>]+)>/, line)

      particle =
        Enum.map([p, v, a], fn v ->
          String.split(v, ",")
          |> Enum.map(&String.to_integer/1)
        end)
        |> List.to_tuple
        |> Tuple.append(i)

      build_particles(rest, particles ++ [particle])
    end

    def tick_particle(particle, ticket \\ {[],[],[]})
    def tick_particle({[],[],[],i}, ticked), do: Tuple.append(ticked, i)
    def tick_particle({[p | pr], [v | vr], [a | ar], i}, {np, nv, na}) do
      new_v = v + a
      new_p = p + new_v
      new_ticked = {np ++ [new_p], nv ++ [new_v], na ++ [a]}

      tick_particle({pr, vr, ar, i}, new_ticked)
    end

    def tick_particles(particles, ticked \\ [])
    def tick_particles([], ticked), do: ticked
    def tick_particles([particle | rest], ticked) do
      next_ticked = ticked ++ [tick_particle(particle)]

      tick_particles(rest, next_ticked)
    end

    def pos_key(pos) do
      pos
      |> Enum.map(&Integer.to_string/1)
      |> Enum.join(",")
    end

    def filter_collisions(particles) do
      # Tally to see how many of each
      counts =
        particles
        |> Enum.reduce(%{}, fn {p, _, _, i}, counts ->
          Map.update(counts, pos_key(p), 1, &(&1 + 1))
        end)

      # Reject ones with more than one occurrence
      particles
      |> Enum.reject(fn {p, _, _, _} ->
        Map.fetch!(counts, pos_key(p)) > 1
      end)
    end

    def tick_particles_for(particles, 0), do: particles
    def tick_particles_for(particles, cycles) do
      particles
      |> tick_particles()
      |> filter_collisions()
      |> tick_particles_for(cycles - 1)
    end

    def reduce_closest(particles) do
      particles
      |> Enum.reduce({nil, nil}, fn {p, _, _, i}, {closest, y} ->
        dist = calc_manhattan(p)

        cond do
          closest == nil -> {dist, i}
          dist < closest -> {dist, i}
          true -> {closest, y}
        end
      end)
    end

    def solve do
      read_lines()
      |> build_particles()
      |> tick_particles_for(1_000)
      |> Kernel.length()
      |> IO.inspect
    end
  end
end
