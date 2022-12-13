defmodule Day13Test do
  use ExUnit.Case
  doctest Day13
  import Day13

  @test_data [
    [1, 1, 3, 1, 1],
    [1, 1, 5, 1, 1],
    [[1], [2, 3, 4]],
    [[1], 4],
    [9],
    [[8, 7, 6]],
    [[4, 4], 4, 4],
    [[4, 4], 4, 4, 4],
    [7, 7, 7, 7],
    [7, 7, 7],
    [],
    [3],
    [[[]]],
    [[]],
    [1, [2, [3, [4, [5, 6, 7]]]], 8, 9],
    [1, [2, [3, [4, [5, 6, 0]]]], 8, 9]
  ]

  test "Part 1 - find right ordered packets" do
    part1 =
      @test_data
      |> parse_data()
      |> find_in_order_packets()
      |> sum_ordered_packets()

    assert part1 == 13
  end

  test "Part 2 - find right ordered packets" do
    part2 =
      @test_data
      |> parse_data()
      |> order_packets_with_dividers()
      |> multiply_divider_packets()

    assert part2 == 140
  end
end
