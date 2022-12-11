defmodule Day11Test do
  use ExUnit.Case
  doctest Day11
  import Day11

  @test_data """
  Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

  Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

  Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

  Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
  """

  test "Part 1 - count monkey business in 20 rounds" do
    part1 =
      @test_data
      |> parse_monkey_notes()
      |> get_throws_in_time(20, 3)
      |> count_monkey_business()

    assert part1 == 10_605
  end
end
