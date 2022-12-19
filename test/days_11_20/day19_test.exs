defmodule Day19Test do
  use ExUnit.Case
  doctest Day19
  import Day19

  @test_data """
  Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
  Blueprint 2: Each ore robot costs 2 ore.Each clay robot costs 3 ore.Each obsidian robot costs 3 ore and 8 clay.Each geode robot costs 3 ore and 12 obsidian.
  """

  test "Part 1 - find all blueprints quality" do
    part1 =
      @test_data
      |> parse_data()
      |> sum_blueprint_quality()

    assert part1 == 33
  end
end
