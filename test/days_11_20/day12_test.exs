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

  test "Part 1 - find shortest path to the top of the hill" do
    {part1, _, _} =
      @test_data
      |> parse_data()
      |> get_edges()
      |> dijkstra()

    assert part1 == 31
  end
end
