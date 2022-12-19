defmodule Day18Test do
  use ExUnit.Case
  doctest Day18
  import Day18

  @test_data """
  2,2,2
  1,2,2
  3,2,2
  2,1,2
  2,3,2
  2,2,1
  2,2,3
  2,2,4
  2,2,6
  1,2,5
  3,2,5
  2,1,5
  2,3,5
  """

  test "Part 1 - count lava droplets surface area" do
    part1 =
      @test_data
      |> parse_data()
      |> count_surface_area()

    assert part1 == 64
  end

  test "Part 2 - count lava droplets exterior surface area" do
    part2 =
      @test_data
      |> parse_data()
      |> count_outside_surface_area()

    assert part2 == 58
  end
end
