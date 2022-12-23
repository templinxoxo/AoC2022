defmodule Day22Test do
  use ExUnit.Case
  doctest Day22
  import Day22

  @test_data """
          ...#
          .#..
          #...
          ....
  ...#.......#
  ........#...
  ..#....#....
  ..........#.
          ...#....
          .....#..
          .#......
          ......#.

  10R5L5R10L4R5L5
  """

  test "Part 1 - get password after all moves" do
    part1 =
      @test_data
      |> parse_data()
      |> get_password()

    assert part1 == 6032
  end
end
