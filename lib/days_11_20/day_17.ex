defmodule Day17 do
  import Day17.MoveFigures

  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> find_tower_height()
  end

  # actual logic
  def find_tower_height(moves) do
    calculate_figures_movement(moves)
    |> Map.keys()
    |> Enum.max()
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
