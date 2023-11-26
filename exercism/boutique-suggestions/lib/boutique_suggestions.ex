defmodule BoutiqueSuggestions do
  @default_maximum_price 100.0

  def get_combinations(tops, bottoms, options \\ [maximum_price: @default_maximum_price]) do
    opts =
      if !options[:maximum_price],
        do: [{:maximum_price, @default_maximum_price} | options],
        else: options

    for itemx <- tops,
        itemy <- bottoms,
        itemx.base_color !== itemy.base_color,
        itemx.price + itemy.price <= opts[:maximum_price] do
      {itemx, itemy}
    end
  end
end
