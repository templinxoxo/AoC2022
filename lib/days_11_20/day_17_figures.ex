defmodule Day17.Figures do
  def get_figure(0, x0, y0),
    do: [
      {y0, MapSet.new(x0..(x0 + 3))}
    ]

  def get_figure(1, x0, y0),
    do: [
      {y0, MapSet.new([x0 + 1])},
      {y0 + 1, MapSet.new(x0..(x0 + 2))},
      {y0 + 2, MapSet.new([x0 + 1])}
    ]

  def get_figure(2, x0, y0),
    do: [
      {y0, MapSet.new(x0..(x0 + 2))},
      {y0 + 1, MapSet.new([x0 + 2])},
      {y0 + 2, MapSet.new([x0 + 2])}
    ]

  def get_figure(3, x0, y0),
    do:
      y0..(y0 + 3)
      |> Enum.map(fn y ->
        {y, MapSet.new([x0])}
      end)

  def get_figure(4, x0, y0),
    do:
      y0..(y0 + 1)
      |> Enum.map(fn y ->
        {y, MapSet.new(x0..(x0 + 1))}
      end)

  def get_figure_len(0), do: 3
  def get_figure_len(1), do: 2
  def get_figure_len(2), do: 2
  def get_figure_len(3), do: 0
  def get_figure_len(4), do: 1
end
