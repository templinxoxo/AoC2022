defmodule Day5Test do
  use ExUnit.Case
  doctest Day5
  import Day5

  @test_data """
      [D]    
  [N] [C]    
  [Z] [M] [P]
  1   2   3

  move 1 from 2 to 1
  move 3 from 1 to 3
  move 2 from 2 to 1
  move 1 from 1 to 2
  """

  test "Part 1 - move crates between stacks" do
    part1 =
      @test_data
      |> parse_data()
      |> move_crates()
      |> get_top_crates()

    assert part1 == "CMZ"
  end
  
  test "Part 2 - move crates between stacks keeping initial order" do
    part1 =
      @test_data
      |> parse_data()
      |> move_crates(true)
      |> get_top_crates()

    assert part1 == "MCD"
  end
end
