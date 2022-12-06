defmodule Day6Test do
  use ExUnit.Case
  doctest Day6
  import Day6

  @test_data [
    "mjqjpqmgbljsphdztnvjfqwrcgsmlb",
    "bvwbjplbgvbhsrlpgdmjqwftvncz",
    "nppdvjthqldpwncqszvftbrmjlhg",
    "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg",
    "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"
  ]

  test "Part 1 - find 4 character start packet" do
    part1 =
      @test_data
      |> Enum.map(&find_start_marker(&1))

    assert part1 == [7, 5, 6, 10, 11]
  end
end
