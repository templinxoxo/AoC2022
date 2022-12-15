defmodule Day15Test do
  use ExUnit.Case
  doctest Day15
  import Day15

  @test_data """
  Sensor at x=2, y=18: closest beacon is at x=-2, y=15
  Sensor at x=9, y=16: closest beacon is at x=10, y=16
  Sensor at x=13, y=2: closest beacon is at x=15, y=3
  Sensor at x=12, y=14: closest beacon is at x=10, y=16
  Sensor at x=10, y=20: closest beacon is at x=10, y=16
  Sensor at x=14, y=17: closest beacon is at x=10, y=16
  Sensor at x=8, y=7: closest beacon is at x=2, y=10
  Sensor at x=2, y=0: closest beacon is at x=2, y=10
  Sensor at x=0, y=11: closest beacon is at x=2, y=10
  Sensor at x=20, y=14: closest beacon is at x=25, y=17
  Sensor at x=17, y=20: closest beacon is at x=21, y=22
  Sensor at x=16, y=7: closest beacon is at x=15, y=3
  Sensor at x=14, y=3: closest beacon is at x=15, y=3
  Sensor at x=20, y=1: closest beacon is at x=15, y=3
  """

  test "Part 1 - find positions in a row not containing a beacon" do
    part1 =
      @test_data
      |> parse_data()
      |> find_scanned_empty_row_positions(10)

    assert part1 == 26
  end

  test "Part 1 - find distress signal coordinates" do
    part1 =
      @test_data
      |> parse_data()
      |> find_distess_coordinates_brute_force(20)

    assert part1 == 56_000_011
  end
end
