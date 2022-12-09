defmodule Day8Test do
  use ExUnit.Case
  doctest Day8
  import Day8

  @test_data """
  30373
  25512
  65332
  33549
  35390
  """

  test "Part 1 - find visible trees number" do
    part1 =
      @test_data
      |> parse_data()
      |> count_visible_trees()

    assert part1 == 21
  end

  test "Part 1 - find best house place" do
    part1 =
      @test_data
      |> parse_data()
      |> find_best_house_place()

    assert part1 == 8
  end
end
