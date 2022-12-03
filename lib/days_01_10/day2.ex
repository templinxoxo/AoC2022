defmodule Day2 do
  # X for Rock, Y for Paper, and Z for Scissors
  # values: X:1, Y:2, Z:3
  # A for Rock, B for Paper, and C for Scissors
  # values: A:1, B:2, C:3
  @winning_plays [["C", "X"], ["A", "Y"], ["B", "Z"]]
  @draw_plays [["A", "X"], ["B", "Y"], ["C", "Z"]]
  @loose_plays [["A", "Z"], ["B", "X"], ["C", "Y"]]

  # execute methods
  def execute_part1() do
    get_strategy()
    |> parse_strategy()
    |> calculate_total_score()
  end

  def execute_part2() do
    get_strategy()
    |> parse_strategy()
    |> calculate_plays()
    |> calculate_total_score()
  end

  # actual logic
  def calculate_total_score(strategy) do
    strategy
    |> Enum.map(&calculate_play_score(&1))
    |> Enum.sum()
  end

  def calculate_plays(strategy) do
    strategy
    |> Enum.map(&calculate_play(&1))
  end

  def calculate_play_result(play) when play in @winning_plays, do: 6
  def calculate_play_result(play) when play in @draw_plays, do: 3
  def calculate_play_result(_), do: 0

  def calculate_play_score([_, player_figure] = play) do
    calculate_play_result(play) + figure_score(player_figure)
  end

  def figure_score("X"), do: 1
  def figure_score("Y"), do: 2
  def figure_score("Z"), do: 3

  # X means you need to lose, Y means you need to end the round in a draw, and Z means you need to win.
  def calculate_play([elf_play, expected_result]) do
    [elf_play, get_player_play(elf_play, get_plays_table(expected_result))]
  end

  def get_player_play(elf_play, plays),
    do: plays |> Enum.find(fn [play, _] -> play == elf_play end) |> Enum.at(1)

  def get_plays_table("X"), do: @loose_plays
  def get_plays_table("Y"), do: @draw_plays
  def get_plays_table("Z"), do: @winning_plays

  # helpers
  def get_strategy() do
    Api.get_input(2)
  end

  def parse_strategy(stratedy) do
    stratedy
    |> String.split("\n", trim: true)
    |> Enum.map(fn play ->
      String.split(play, " ", trim: true)
    end)
  end
end
