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

  test "Part 2 - follow long rope movement" do
    results =
      @test_data
      |> get_rope_steps()
      |> count_unique_long_tail_positions()

    assert results == 1
  end

  @long_rope_test_data """
  R 5
  U 8
  L 8
  D 3
  R 17
  D 10
  L 25
  U 20
  """

  test "Part 2 - follow long rope movement - bigger example" do
    results =
      @long_rope_test_data
      |> get_rope_steps()
      |> count_unique_long_tail_positions()

    assert results == 36
  end
end
