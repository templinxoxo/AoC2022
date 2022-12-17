defmodule Day17 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> find_tower_height()
  end

  # actual logic
  def find_tower_height(moves) do
    floor = 0..6 |> MapSet.new()
    # {figure_number, move_number, tower_levels} =
    next_figure_movement(0, 0, %{0 => floor}, moves, 2022)
    |> Map.keys()
    |> Enum.max()
  end

  def next_figure_movement(_figure_number, _move_number, tower_levels, _moves_pattern, 0) do
    tower_levels
  end

  def next_figure_movement(figure_number, move_number, tower_levels, moves_pattern, figures_left) do
    x = 2
    tower_height = tower_levels |> Map.keys() |> Enum.max()
    y = tower_height + 4

    args =
      move_figure(figure_number, move_number, tower_levels, moves_pattern, x, y)
      |> Enum.concat([moves_pattern, figures_left - 1])

    apply(Day17, :next_figure_movement, args)
  end

  def move_figure(figure_number, move_number, tower_levels, moves_pattern, x, y)
      when move_number >= length(moves_pattern) do
    move_number = moves_pattern |> length() |> Integer.mod(move_number)

    move_figure(figure_number, move_number, tower_levels, moves_pattern, x, y)
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

    if can_move_to?({x, y0 - 1}, figure_number, tower_levels) do
      move_figure(figure_number, move_number + 1, tower_levels, moves_pattern, x, y0 - 1)
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

      [
        figure_number + 1,
        move_number + 1,
        Map.merge(tower_levels, new_levels)
      ]
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

  def get_figure_len(number) do
    case Integer.mod(number, 5) do
      0 -> 3
      1 -> 2
      2 -> 2
      3 -> 0
      4 -> 1
    end
  end

  def get_figure(number, x0, y0) do
    case Integer.mod(number, 5) do
      0 ->
        [{y0, MapSet.new(x0..(x0 + 3))}]

      1 ->
        [
          {y0, MapSet.new([x0 + 1])},
          {y0 + 1, MapSet.new(x0..(x0 + 2))},
          {y0 + 2, MapSet.new([x0 + 1])}
        ]

      2 ->
        [
          {y0, MapSet.new(x0..(x0 + 2))},
          {y0 + 1, MapSet.new([x0 + 2])},
          {y0 + 2, MapSet.new([x0 + 2])}
        ]

      3 ->
        y0..(y0 + 3)
        |> Enum.map(fn y ->
          {y, MapSet.new([x0])}
        end)

      4 ->
        y0..(y0 + 1)
        |> Enum.map(fn y ->
          {y, MapSet.new(x0..(x0 + 1))}
        end)
    end
  end

  # helpers
  def get_data() do
    Api.get_input(17)
  end

  def parse_data(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.flat_map(&String.split(&1, "", trim: true))
  end
end
