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

  test "Part 1 - cound lava droplets sides" do
    part1 =
      @test_data
      |> parse_data()
      |> count_sides()

    assert part1 == 64
  end
end
