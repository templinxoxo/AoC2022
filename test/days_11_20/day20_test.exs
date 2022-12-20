defmodule Day20Test do
  use ExUnit.Case
  doctest Day20
  import Day20

  @test_data """
  1
  2
  -3
  3
  -2
  0
  4
  """

  test "Part 1 - decrypt file" do
    part1 =
      @test_data
      |> parse_data()
      |> decrypt_file()

    assert part1 == 3
  end

  test "Part 2 - decrypt file with decryption key and repetitions" do
    part1 =
      @test_data
      |> parse_data()
      |> decrypt_file(10, get_decryption_key())

    assert part1 == 1_623_178_306
  end
end
