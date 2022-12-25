defmodule Day25Test do
  use ExUnit.Case
  doctest Day25
  import Day25

  @test_data """
  1=-0-2
  12111
  2=0=
  21
  2=01
  111
  20012
  112
  1=-1=
  1-12
  12
  1=
  122
  """

  test "Part 1 - sum fuel needed" do
    part1 =
      @test_data
      |> parse_data()
      |> calculate_fuel_sum()

    assert part1 == "2=-1=0"
  end
end
