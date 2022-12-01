defmodule Day1Test do
  use ExUnit.Case
  doctest Day1
  import Day1

  @test_data """
  1000
  2000
  3000

  4000

  5000
  6000

  7000
  8000
  9000

  10000
  """

  test "Part 1 - top 1 most caloric inventory" do
    part1 =
      @test_data
      |> parse_calory_list()
      |> find_most_calory_inventory()

    assert part1 == 24_000
  end
end
