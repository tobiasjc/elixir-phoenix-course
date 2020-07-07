defmodule Cards do
  @moduledoc """
  Provides methods for creating and handling a deck of cards.
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

  @spec save(any, binary | [[any] | char]) :: :ok
  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write!(filename, binary)
  end

  @spec load(binary) :: any
  def load(filename) do
    case File.read(filename) do
      {:ok, data} -> :erlang.binary_to_term(data)
      {:error, reason} -> reason
    end
  end

  @spec create_hand(integer) :: {[binary], [binary]}
  def create_hand(hand_size) do
    Cards.create_deck() |> Cards.shuffle() |> Cards.deal(hand_size)
  end
end
