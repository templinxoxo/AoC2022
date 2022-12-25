defmodule Day23Test do
  use ExUnit.Case
  doctest Day23
  import Day23

  @test_data_small """
  .....
  ..##.
  ..#..
  .....
  ..##.
  .....
  """

  test "Part 1 - calculate covered ground - small example" do
    part1 =
      @test_data_small
      |> parse_data()
      |> calculate_covered_ground()

    assert part1 == 25
  end

  @test_data_big """
  ..............
  ..............
  .......#......
  .....###.#....
  ...#...#.#....
  ....#...##....
  ...#.###......
  ...##.#.##....
  ....#..#......
  ..............
  ..............
  ..............
  """

  test "Part 1 - calculate covered ground - big example" do
    part1 =
      @test_data_big
      |> parse_data()
      |> calculate_covered_ground()

    assert part1 == 110
  end

  test "Part 2 - count rounds until moving is complete - small example" do
    part2 =
      @test_data_small
      |> parse_data()
      |> count_rounds_until_moving_is_complete()

    assert part2 == 4
  end

  test "Part 2 - count rounds until moving is complete - big example" do
    part2 =
      @test_data_big
      |> parse_data()
      |> count_rounds_until_moving_is_complete()

    assert part2 == 20
  end
end
