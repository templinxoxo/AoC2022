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
end
