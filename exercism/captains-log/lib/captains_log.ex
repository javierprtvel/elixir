defmodule CaptainsLog do
  @planetary_classes ["D", "H", "J", "K", "L", "M", "N", "R", "T", "Y"]
  @registry_number_range 1_000..9_999

  def random_planet_class() do
    Enum.random(@planetary_classes)
  end

  def random_ship_registry_number() do
    "NCC-#{Enum.random(@registry_number_range)}"
  end

  def random_stardate() do
    :rand.uniform() * 1_000.0 + 41_000.0
  end

  def format_stardate(stardate) do
    :io_lib.format("~.1f", [stardate]) |> to_string()
  end
end
