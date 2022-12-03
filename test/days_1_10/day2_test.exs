defmodule Day2Test do
  use ExUnit.Case
  doctest Day2
  import Day2

  @test_data """
  A Y
  B X
  C Z
  """

  test "Part 1 - single play scores" do
    assert calculate_play_score(["A", "X"]) == 3 + 1
    assert calculate_play_score(["B", "X"]) == 0 + 1
    assert calculate_play_score(["C", "X"]) == 6 + 1

    assert calculate_play_score(["A", "Y"]) == 6 + 2
    assert calculate_play_score(["B", "Y"]) == 3 + 2
    assert calculate_play_score(["C", "Y"]) == 0 + 2

    assert calculate_play_score(["A", "Z"]) == 0 + 3
    assert calculate_play_score(["B", "Z"]) == 6 + 3
    assert calculate_play_score(["C", "Z"]) == 3 + 3
  end

  test "Part 1 - calculate total score" do
    part1 =
      @test_data
      |> parse_strategy()
      |> calculate_total_score()

    assert part1 == 15
  end

  test "Part 2 - calculate plays and total score" do
    part1 =
      @test_data
      |> parse_strategy()
      |> calculate_plays()
      |> calculate_total_score()

    assert part1 == 12
  end
end
