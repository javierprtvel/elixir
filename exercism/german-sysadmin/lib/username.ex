defmodule Username do
  def sanitize(username) do
    username
    |> Enum.flat_map(&sanitize_german_char/1)
    |> Enum.filter(&((&1 >= ?a and &1 <= ?z) or &1 === ?_))
  end

  defp sanitize_german_char(char) do
    case char do
      ?ä -> ~c"ae"
      ?ö -> ~c"oe"
      ?ü -> ~c"ue"
      ?ß -> ~c"ss"
      _ -> [char]
    end
  end
end
