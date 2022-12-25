defmodule Day24Test do
  use ExUnit.Case
  doctest Day24
  import Day24

  @test_data """
  #.######
  #>>.<^<#
  #.<..<<#
  #>v.><>#
  #<^v^^>#
  ######.#
  """

  test "Part 1 - " do
    part1 =
      @test_data
      |> parse_data()
      |> count_steps_to_pass_site()
      |> IO.inspect()

    assert part1 == 18
  end
end
