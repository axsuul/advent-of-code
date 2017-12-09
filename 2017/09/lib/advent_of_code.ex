defmodule AdventOfCode do
  defp tail(str) do
    String.slice(str, 1, String.length(str) - 1)
  end

  def score_cleaned(stream, multiplier \\ 1, inner \\ nil, level \\ 0)
  def score_cleaned("", _, _, _) do 0 end    # reach end
  def score_cleaned("<>" <> tail, multiplier, inner, level) do
    score_cleaned(tail, multiplier, inner, level)
  end
  def score_cleaned("," <> tail, multiplier, inner, level) do
    score_cleaned(tail, multiplier, inner, level)
  end
  def score_cleaned("{" <> tail, multiplier, inner, 0) when is_nil(inner) do
    score_cleaned(tail, multiplier, "", 1)
  end
  def score_cleaned("}" <> tail, multiplier, inner, 1) when is_binary(inner) do
    multiplier +
    score_cleaned(inner, multiplier + 1) +
    score_cleaned(tail, multiplier)
  end
  def score_cleaned("{" <> tail, multiplier, inner, level) do
    score_cleaned(tail, multiplier, inner <> "{", level + 1)
  end
  def score_cleaned("}" <> tail, multiplier, inner, level) do
    score_cleaned(tail, multiplier, inner <> "}", level - 1)
  end

  def clean(stream, until \\ nil)
  def clean("", _) do "" end
  # def clean(">", _) do ">" end
  def clean("!" <> tail, until) do
    clean(tail(tail), until)
  end
  def clean("<" <> tail, until) when is_nil(until) do
    "<" <> clean(tail, ">")
  end
  # Ignore < in garbage
  def clean("<" <> tail, until) do
    clean(tail, until)
  end
  # Allow any character through if not in garbage
  def clean(stream, until) when is_nil(until) do
    String.at(stream, 0) <> clean(tail(stream), until)
  end
  def clean(stream, until) do
    char = String.at(stream, 0)

    cond do
      char == until ->
        char <> clean(tail(stream), nil)
      true ->
        clean(tail(stream), until)
    end
  end

  # Modified from clean/2
  def clean_and_count(stream, cleaned \\ "", until \\ nil)
  def clean_and_count("", _, _) do 0 end
  def clean_and_count("!" <> tail, cleaned, until) do
    clean_and_count(tail(tail), cleaned, until)
  end
  def clean_and_count("<" <> tail, cleaned, until) when is_nil(until) do
    clean_and_count(tail, cleaned <> "<", ">")
  end
  # Ignore < in garbage but count it
  def clean_and_count("<" <> tail, cleaned, until) do
    1 + clean_and_count(tail, cleaned, until)
  end
  # Allow any character through if not in garbage
  def clean_and_count(stream, cleaned, until) when is_nil(until) do
    clean_and_count(tail(stream), cleaned <> String.at(stream, 0), until)
  end
  def clean_and_count(stream, cleaned, until) do
    char = String.at(stream, 0)

    cond do
      char == until ->
        clean_and_count(tail(stream), cleaned <> char, nil)
      true ->
        1 + clean_and_count(tail(stream), cleaned, until)
    end
  end

  def score(stream) do
    stream
    |> clean()
    |> score_cleaned()
  end

  def solve_a do
    File.read!("inputs/input.txt")
    |> score()
    |> IO.inspect
  end

  def solve_b do
    File.read!("inputs/input.txt")
    |> clean_and_count()
    |> IO.inspect
  end
end
