defmodule Day21Test do
  use ExUnit.Case
  doctest Day21
  import Day21

  @test_data """
  root: pppw + sjmn
  dbpl: 5
  cczh: sllz + lgvd
  zczc: 2
  ptdq: humn - dvpt
  dvpt: 3
  lfqf: 4
  humn: 5
  ljgn: 2
  sjmn: drzm * dbpl
  sllz: 4
  pppw: cczh / lfqf
  lgvd: ljgn * ptdq
  drzm: hmdt - zczc
  hmdt: 32
  """

  test "Part 1 - find root calculation" do
    part1 =
      @test_data
      |> parse_data()
      |> find_root_value()

    assert part1 == 152
  end

  test "Part 2 - reverse calculation" do
    assert reverse_calculations({["+", [:x, 3]], 5}) == 2
    assert reverse_calculations({["+", [3, :x]], 5}) == 2
    assert reverse_calculations({["-", [:x, 3]], 2}) == 5
    assert reverse_calculations({["-", [3, :x]], 2}) == 1
    assert reverse_calculations({["*", [:x, 3]], 6}) == 2
    assert reverse_calculations({["*", [3, :x]], 6}) == 2
    assert reverse_calculations({["/", [:x, 4]], 2}) == 8
    assert reverse_calculations({["/", [4, :x]], 2}) == 2
  end

  test "Part 2 - find human input to match root calculation" do
    part1 =
      @test_data
      |> parse_data()
      |> find_human_input()

    assert part1 == 301
  end
end
