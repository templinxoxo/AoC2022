defmodule Day4Test do
  use ExUnit.Case
  doctest Day4
  import Day4

  @test_data """
  2-4,6-8
  2-3,4-5
  5-7,7-9
  2-8,3-7
  6-6,4-6
  2-6,4-8
  """

  test "Part 1 - get fully contained assignments number" do
    part1 =
      @test_data
      |> parse_data()
      |> get_fully_contained_assignments()

    assert part1 == 2
  end
end
