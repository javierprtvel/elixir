defmodule CubeConundrum do
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

  def map_game_record_to_minimum_cubeset_power({_id, cubeset_maps}) do
    power_of(calculate_minimum_cubeset(cubeset_maps))
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

  defp calculate_minimum_cubeset(cubeset_maps) do
    Enum.reduce(
      cubeset_maps,
      %{red: 0, green: 0, blue: 0},
      fn cm, min_cubeset ->
        %{
          min_cubeset
          | red: max(cm.red, min_cubeset.red),
            green: max(cm.green, min_cubeset.green),
            blue: max(cm.blue, min_cubeset.blue)
        }
      end
    )
  end

  defp power_of(cubeset) do
    cubeset.red * cubeset.green * cubeset.blue
  end
end

File.stream!("input.txt")
|> Stream.map(&CubeConundrum.map_line_to_game_record/1)
|> Stream.map(&CubeConundrum.map_game_record_to_minimum_cubeset_power/1)
|> Enum.reduce(0, &(&1 + &2))
|> tap(&IO.puts("The sum of the power of all minimum cubesets is: #{&1}"))
