defmodule Day3Test do
  use ExUnit.Case
  doctest Day3
  import Day3

  @test_data """
  vJrwpWtwJgWrhcsFMMfFFhFp
  jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
  PmmdzqPrVvPwwTWBwg
  wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
  ttgJtRGJQctTZtZT
  CrZsJsPPZsGzwwsLwLmpwMDw
  """

  test "Part 1 - get duplicated items and their priority" do
    part1 =
      @test_data
      |> parse_data()
      |> find_duplicated_items_weight()

    assert part1 == 157
  end
end
