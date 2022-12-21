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
end
