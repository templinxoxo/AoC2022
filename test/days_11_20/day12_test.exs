defmodule Day12Test do
  use ExUnit.Case
  doctest Day12
  import Day12

  @test_data """
  Sabqponm
  abcryxxl
  accszExk
  acctuvwj
  abdefghi
  """

  test "Part 1 - find shortest path to the top of the hill from the start" do
    {part1, _, _} =
      @test_data
      |> parse_data()
      |> get_edges()
      |> get_path_from_start()

    assert part1 == 31
  end

  test "Part 1 - find shortest path to the top of the hill from any point" do
    part2 =
      @test_data
      |> parse_data()
      |> get_edges()
      |> get_path_from_any_low_alt()
      |> draw()

    assert part2 == 29
  end
end
