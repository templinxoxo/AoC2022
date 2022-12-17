defmodule Day17.MoveFigures do
  import Day17.Figures

  def calculate_figures_movement(moves_pattern) do
    floor = 0..6 |> MapSet.new()
    tower_levels = %{0 => floor}

    calculate_figures_movement(0, 0, tower_levels, moves_pattern, 2022)
  end

  def calculate_figures_movement(_figure_number, _move_number, tower_levels, _moves_pattern, 0) do
    tower_levels
  end

  def calculate_figures_movement(
        figure_number,
        move_number,
        tower_levels,
        moves_pattern,
        figures_left
      ) do
    x = 2
    tower_height = tower_levels |> Map.keys() |> Enum.max()
    y = tower_height + 4

    {
      figure_number,
      move_number,
      tower_levels,
      _x
    } = move_figure(figure_number, move_number, tower_levels, moves_pattern, x, y)

    calculate_figures_movement(
      figure_number,
      move_number,
      tower_levels,
      moves_pattern,
      figures_left - 1
    )
  end

  def move_figure(figure_number, move_number, tower_levels, moves_pattern, x0, y0) do
    figure_len = get_figure_len(figure_number)

    x =
      moves_pattern
      |> Enum.at(move_number)
      |> get_horizontal_movement(x0, figure_len)
      |> case do
        :border ->
          x0

        movement ->
          if can_move_to?({x0 + movement, y0}, figure_number, tower_levels),
            do: x0 + movement,
            else: x0
      end

    moves_len = length(moves_pattern)

    if can_move_to?({x, y0 - 1}, figure_number, tower_levels) do
      move_figure(
        figure_number,
        Integer.mod(move_number + 1, moves_len),
        tower_levels,
        moves_pattern,
        x,
        y0 - 1
      )
    else
      new_levels =
        figure_number
        |> get_figure(x, y0)
        |> Enum.map(fn {y, level} ->
          new_level =
            tower_levels
            |> Map.get(y, MapSet.new())
            |> MapSet.union(level)

          {y, new_level}
        end)
        |> Map.new()

      {
        Integer.mod(figure_number + 1, 5),
        Integer.mod(move_number + 1, moves_len),
        Map.merge(tower_levels, new_levels),
        x
      }
    end
  end

  # can move to position x, y if no of current levels intersect with figure at this coortinates
  def can_move_to?({x, y}, figure_number, tower_levels) do
    figure_number
    |> get_figure(x, y)
    |> Enum.all?(fn {y, level} ->
      tower_levels
      |> Map.get(y, MapSet.new())
      |> MapSet.intersection(level)
      |> MapSet.to_list()
      |> List.first()
      |> is_nil()
    end)
  end

  def get_horizontal_movement(">", x, len) when x + len >= 6, do: :border
  def get_horizontal_movement(">", _x, _len), do: 1
  def get_horizontal_movement("<", 0, _len), do: :border
  def get_horizontal_movement("<", _x, _len), do: -1
end
