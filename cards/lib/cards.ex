defmodule Cards do
  @moduledoc """
  Documentation for `Cards`.
  """

  @spec create_deck :: [<<_::24, _::_*16>>, ...]
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    cards =
      for value <- values, suit <- suits do
        "#{value} of #{suit}"
      end

    List.flatten(cards)
  end

  @spec shuffle(list()) :: any
  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @spec contains?(list(), any) :: boolean
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @spec deal(any, integer) :: {[any], [any]}
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end
end
