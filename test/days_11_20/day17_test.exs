defmodule Day17Test do
  use ExUnit.Case
  doctest Day17
  import Day17

  @test_data """
  >>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
  """

  test "Part 1 - find tower height" do
    part1 =
      @test_data
      |> parse_data()
      |> find_tower_height()

    assert part1 == 3068
  end

  test "Part 1 - find tower height using pattern" do
    part1 =
      @test_data
      |> parse_data()
      |> find_tower_height_using_pattern()

    assert part1 == 3068
  end

  test "Part 1 - real data tower height using pattern" do
    part1 =
      get_data()
      |> parse_data()
      |> find_tower_height_using_pattern()

    assert part1 == 3111
  end

  test "Part 2 - find tower height using pattern" do
    part2 =
      @test_data
      |> parse_data()
      |> find_tower_height_using_pattern(1_000_000_000_000)

    assert part2 == 1_514_285_714_288
  end
end
