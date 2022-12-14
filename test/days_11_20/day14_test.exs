defmodule Day14Test do
  use ExUnit.Case
  doctest Day14
  import Day14
  import Day14Pt2

  @test_data """
  498,4 -> 498,6 -> 496,6
  503,4 -> 502,4 -> 502,9 -> 494,9
  """

  test "Part 1 - count infinitely falling sand" do
    part1 =
      @test_data
      |> parse_data()
      |> count_infinite_falling_sand()

    assert part1 == 24
  end

  test "Part 2 - count falling sand brute force" do
    part2 =
      @test_data
      |> parse_data()
      |> count_falling_sand_brute_force()

    assert part2 == 93
  end

  test "Part 2 - count falling sand" do
    part2 =
      @test_data
      |> count_falling_sand()

    assert part2 == 93
  end
end
