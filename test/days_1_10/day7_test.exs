defmodule Day7Test do
  use ExUnit.Case
  doctest Day7
  import Day7

  @test_data """
  $ cd /
  $ ls
  dir a
  14848514 b.txt
  8504156 c.dat
  dir d
  $ cd a
  $ ls
  dir e
  29116 f
  2557 g
  62596 h.lst
  $ cd e
  $ ls
  584 i
  $ cd ..
  $ cd ..
  $ cd d
  $ ls
  4060174 j
  8033020 d.log
  5626152 d.ext
  7214296 k
  """

  test "Part 1 - find 10kb max directories" do
    part1 =
      @test_data
      |> parse_data()
      |> map_file_structure()
      |> find_10kb_directories()

    assert part1 == 95437
  end

  test "Part 1 - find smallest dir freeing up space" do
    part1 =
      @test_data
      |> parse_data()
      |> map_file_structure()
      |> free_up_space()

    assert part1 == 24_933_642
  end
end
