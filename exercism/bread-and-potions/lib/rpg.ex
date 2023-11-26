defmodule RPG do
  defmodule Character do
    defstruct health: 100, mana: 0
  end

  defmodule LoafOfBread do
    defstruct []
  end

  defmodule ManaPotion do
    defstruct strength: 10
  end

  defmodule Poison do
    defstruct []
  end

  defmodule EmptyBottle do
    defstruct []
  end

  defprotocol Edible do
    def eat(item, character)
  end

  defimpl Edible, for: LoafOfBread do
    @health_points 5

    def eat(_item, %Character{health: health} = character) do
      {nil, %{character | health: health + @health_points}}
    end
  end

  defimpl Edible, for: ManaPotion do
    def eat(item, %Character{mana: mana} = character) do
      {%RPG.EmptyBottle{}, %{character | mana: mana + item.strength}}
    end
  end

  defimpl Edible, for: Poison do
    def eat(_item, character) do
      {%RPG.EmptyBottle{}, %{character | health: 0}}
    end
  end
end
