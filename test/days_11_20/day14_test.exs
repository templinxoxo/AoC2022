defmodule Day14Test do
  use ExUnit.Case
  doctest Day14
  import Day14

  @test_data """
  498,4 -> 498,6 -> 496,6
  503,4 -> 502,4 -> 502,9 -> 494,9
  """

  test "Part 1 - " do
    System.put_env("print", "true")

    part1 =
      @test_data
      |> parse_data()
      |> count_falling_sand()

    # System.put_env("print", "false")

    assert part1 == 24
  end
end
