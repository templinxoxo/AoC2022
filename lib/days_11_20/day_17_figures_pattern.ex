defmodule Day17.FiguresPattern do
  # import Day17.Figures
  import Day17.MoveFigures

  def calculate_figures_pattern(moves_pattern) do
    floor = 0..6 |> MapSet.new()
    tower_levels = %{0 => floor}

    calculate_figures_pattern(0, 0, tower_levels, moves_pattern, [{0, 0}])
  end

  def calculate_figures_pattern(
        figure_number,
        move_number,
        tower_levels,
        moves_pattern,
        pattern
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

    current_step = {figure_number, move_number}

    if Enum.member?(pattern, current_step) && figure_number == 0 do
      calculate_pattern_cycle(pattern, current_step)
    else
      calculate_figures_pattern(
        figure_number,
        move_number,
        tower_levels,
        moves_pattern,
        pattern ++ [current_step]
      )
    end
  end

  def calculate_pattern_cycle(pattern, current_step) do
    steps_until_pattern_starts =
      pattern
      |> Enum.with_index()
      |> Enum.find(fn {step, _index} -> step == current_step end)
      |> elem(1)

    pattern_cycle = length(pattern) - steps_until_pattern_starts

    {steps_until_pattern_starts + 1, pattern_cycle}
  end
end
