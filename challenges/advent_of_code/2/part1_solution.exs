defmodule CubeConundrum do
  @hipothetical_bag %{red: 12, green: 13, blue: 14}

  @id_group "id"
  @cubesets_group "sets"
  @game_record_regex ~r/^Game (?<#{@id_group}>\d+):\s*(?<#{@cubesets_group}>.+)$/i

  def map_line_to_game_record(line) do
    %{@id_group => id, @cubesets_group => cubesets_str} =
      Regex.named_captures(@game_record_regex, line, capture: :all_names)

    cubeset_strs = String.split(cubesets_str, ";") |> Enum.map(&String.trim/1)

    cubeset_maps =
      cubeset_strs
      |> Stream.map(&to_cubeset_map/1)
      |> Enum.to_list()

    {id, cubeset_maps}
  end

  def possible_with_hipothetical_bag?({_id, cubeset_maps}) do
    Enum.all?(cubeset_maps, fn cm -> possible_cubemap?(cm) end)
  end

  defp to_cubeset_map(cubeset_str) do
    String.split(cubeset_str, ~r/\s*,\s*/)
    |> Enum.into(%{}, &cubeset_entry_from_str/1)
    |> Map.put_new(:red, 0)
    |> Map.put_new(:green, 0)
    |> Map.put_new(:blue, 0)
  end

  defp cubeset_entry_from_str(str) do
    [amount, color] = String.split(str, ~r/\s+/)
    {String.to_atom(color), String.to_integer(amount)}
  end

  defp possible_cubemap?(cm) do
    cm[:red] <= @hipothetical_bag.red and
      cm[:green] <= @hipothetical_bag.green and
      cm[:blue] <= @hipothetical_bag.blue
  end
end

File.stream!("input.txt")
|> Stream.map(&CubeConundrum.map_line_to_game_record/1)
|> Stream.filter(&CubeConundrum.possible_with_hipothetical_bag?/1)
|> Enum.reduce(0, fn {id, _cubeset_maps}, acc -> String.to_integer(id) + acc end)
|> tap(&IO.puts("The ids of all games that could have been possible add up to this: #{&1}"))
