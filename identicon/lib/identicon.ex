defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """

  @spec hello :: :world
  @doc """
  Hello world.

  ## Examples

      iex> Identicon.hello()
      :world

  """
  def hello do
    :world
  end

  @spec main(binary) :: Identicon.Image.t()
  def main(input) do
    input
    |> hash_input()
    |> pick_color()
    |> build_grid()
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  @spec save_image(binary, binary) :: :ok | {:error, atom}
  def save_image(image, name) do
    File.write("#{name}.png", image)
  end

  @spec draw_image(Identicon.Image.t()) :: binary
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(
      pixel_map,
      fn {start, stop} ->
        :egd.filledRectangle(image, start, stop, fill)
      end
    )

    :egd.render(image)
  end

  @spec build_pixel_map(Identicon.Image.t()) :: Identicon.Image.t()
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(
        grid,
        fn {_, k} ->
          hor = rem(k, 5) * 50
          vert = div(k, 5) * 50

          tl = {hor, vert}
          br = {hor + 50, vert + 50}

          {tl, br}
        end
      )

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @spec filter_odd_squares(Identicon.Image.t()) :: Identicon.Image.t()
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter(grid, fn {v, _k} -> rem(v, 2) == 0 end)

    %Identicon.Image{image | grid: grid}
  end

  @spec hash_input(binary) :: Identicon.Image.t()
  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end

  @spec pick_color(Identicon.Image.t()) :: Identicon.Image.t()
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  @spec build_grid(Identicon.Image.t()) :: Identicon.Image.t()
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  @spec mirror_row([...]) :: [...]
  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end
end
