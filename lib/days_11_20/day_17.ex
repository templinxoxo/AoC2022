defmodule Day17 do
  import Day17.MoveFigures
  import Day17.FiguresPattern

  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> find_tower_height()
  end

  @spec execute_part1_with_pattern :: number
  def execute_part1_with_pattern() do
    get_data()
    |> parse_data()
    |> find_tower_height_using_pattern()
  end

  def execute_part2() do
    get_data()
    |> parse_data()
    |> find_tower_height_using_pattern(1_000_000_000_000)
  end

  # actual logic
  def find_tower_height(moves, steps \\ 2022) do
    calculate_figures_movement(moves, steps)
    |> Map.keys()
    |> Enum.max()
  end

  def find_tower_height_using_pattern(moves, steps \\ 2022) do
    {steps_until_pattern_starts, pattern_cycle, pattern_height} = find_tower_pattern(moves)

    pattern_repetitions = floor((steps - steps_until_pattern_starts) / pattern_cycle)
    patterns_height = pattern_height * pattern_repetitions

    manual_steps = steps - pattern_repetitions * pattern_cycle
    manual_steps_height = find_tower_height(moves, manual_steps)

    manual_steps_height + patterns_height
  end

  def find_tower_pattern(moves) do
    {steps_until_pattern_starts, pattern_cycle} = calculate_figures_pattern(moves)

    pattern_height =
      find_tower_height(moves, steps_until_pattern_starts + pattern_cycle) -
        find_tower_height(moves, steps_until_pattern_starts)

    {steps_until_pattern_starts, pattern_cycle, pattern_height}
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
