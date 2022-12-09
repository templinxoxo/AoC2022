defmodule Day9Test do
  use ExUnit.Case
  doctest Day9
  import Day9

  @test_data """
  R 4
  U 4
  L 3
  D 1
  R 4
  D 1
  L 5
  R 2
  """

  test "Part 1 - follow rope movement" do
    part1 =
      @test_data
      |> get_rope_steps()
      |> count_unique_tail_positions()

    assert part1 == 13
  end
end
