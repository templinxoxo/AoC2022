defmodule Day22Test do
  use ExUnit.Case
  doctest Day22
  import Day22
  import Day22.Cube
  import Day22.CubeDefinition

  @test_data """
          ...#
          .#..
          #...
          ....
  ...#.......#
  ........#...
  ..#....#....
  ..........#.
          ...#....
          .....#..
          .#......
          ......#.

  10R5L5R10L4R5L5
  """

  test "Part 1 - get password after all moves" do
    part1 =
      @test_data
      |> parse_data()
      |> get_password()

    assert part1 == 6032
  end

  #   0123456789012345
  # 0         E.FG
  # 1         A..H
  # 2         ...I
  # 3         BC.D
  # 4 .F.E.A.B.C.D
  # .
  # 8             ....
  # 9             ...I
  # 0             ...H
  # 1             ...G
  test "Part 2 - move between cube sides - side 1 #1" do
    # A, B
    cube = get_no_wall_cube()

    assert switch_side({8, 1, "<", 1}, cube) == {5, 4, "v", 3}
    assert switch_side({8, 3, "<", 1}, cube) == {7, 4, "v", 3}
    # and back
    assert switch_side({5, 4, "^", 3}, cube) == {8, 1, ">", 1}
    assert switch_side({7, 4, "^", 3}, cube) == {8, 3, ">", 1}
  end

  test "Part 2 - move between cube sides - side 1 #2" do
    # C, D
    cube = get_no_wall_cube()

    assert switch_side({9, 3, "v", 1}, cube) == {9, 4, "v", 4}
    assert switch_side({11, 3, "v", 1}, cube) == {11, 4, "v", 4}
    # and back
    assert switch_side({9, 4, "^", 4}, cube) == {9, 3, "^", 1}
    assert switch_side({11, 4, "^", 4}, cube) == {11, 3, "^", 1}
  end

  test "Part 2 - move between cube sides - side 1 #3" do
    # E, F
    cube = get_no_wall_cube()

    assert switch_side({8, 0, "^", 1}, cube) == {3, 4, "v", 2}
    assert switch_side({10, 0, "^", 1}, cube) == {1, 4, "v", 2}
    # and back
    assert switch_side({3, 4, "^", 2}, cube) == {8, 0, "v", 1}
    assert switch_side({1, 4, "^", 2}, cube) == {10, 0, "v", 1}
  end

  test "Part 2 - move between cube sides - side 1 #4" do
    # G, H, I
    cube = get_no_wall_cube()

    assert switch_side({11, 0, ">", 1}, cube) == {15, 11, "<", 6}
    assert switch_side({11, 1, ">", 1}, cube) == {15, 10, "<", 6}
    assert switch_side({11, 2, ">", 1}, cube) == {15, 9, "<", 6}
    # and back
    assert switch_side({15, 11, ">", 6}, cube) == {11, 0, "<", 1}
    assert switch_side({15, 10, ">", 6}, cube) == {11, 1, "<", 1}
    assert switch_side({15, 9, ">", 6}, cube) == {11, 2, "<", 1}
  end

  #   0123456789012345
  # 0         A..#
  # 1         .#..
  # 2         #...
  # 3         ....
  # 4 ...#..B.....
  # .
  # 8             ....
  # 9               ..
  # 0               ..
  # 1               .C
  test "Part 2 - move between cube sides - won't move if there is an edge wall #1" do
    # A
    cube = get_test_cube()

    assert switch_side({8, 0, "^", 1}, cube) == :edge_wall
  end

  test "Part 2 - move between cube sides - won't move if there is an edge wall #2" do
    # B
    cube = get_test_cube()

    assert switch_side({6, 4, "^", 3}, cube) == :edge_wall
  end

  test "Part 2 - move between cube sides - won't move if there is an edge wall #3" do
    # C
    cube = get_test_cube()

    assert switch_side({15, 11, ">", 6}, cube) == :edge_wall
  end

  #   0123456789012345
  # 0         A.B#
  # 1         .#..
  # 2         #...
  # 3         ..C.
  # 4 ...#........
  # 5 ........#...
  # 6 ..#....#....
  test "Part 2 - move between cube sides - go to the edge and over to finish the move #1" do
    # from A, go right 1 step -> won't reach wall or edge
    cube = get_test_cube()

    assert {9, 0, ">", 1} = execute_commands([{:move, 1}], {8, 0, ">", 1}, cube)
  end

  test "Part 2 - move between cube sides - go to the edge and over to finish the move #2" do
    # from C, go up 1 step -> won't reach wall or edge going up
    cube = get_test_cube()

    assert {10, 2, "^", 1} = execute_commands([{:move, 1}], {10, 3, "^", 1}, cube)
  end

  test "Part 2 - move between cube sides - go to the edge and over to finish the move #3" do
    # from A, go right 4 steps -> will reach a wall and stop before
    cube = get_test_cube()

    assert {10, 0, ">", 1} = execute_commands([{:move, 4}], {8, 0, ">", 1}, cube)
  end

  test "Part 2 - move between cube sides - go to the edge and over to finish the move #4" do
    # from C, go up 1 steps, turn left, go 4 steps left -> will reach a wall and stop before
    cube = get_test_cube()

    assert {9, 2, "<", 1} =
             execute_commands([{:move, 1}, {:turn, "L"}, {:move, 4}], {10, 3, "^", 1}, cube)
  end

  test "Part 2 - move between cube sides - go to the edge and over to finish the move #5" do
    # from B, go left 2 steps -> will reach an edge but run out of moves, turn right to face up, try to go 2 steps up, find a wall trying to switch sides and stay on the edge
    cube = get_test_cube()

    assert {8, 0, "^", 1} =
             execute_commands([{:move, 2}, {:turn, "R"}, {:move, 2}], {10, 0, "<", 1}, cube)
  end

  test "Part 2 - move between cube sides - go to the edge and over to finish the move #6" do
    # from B, go left 5 steps -> will reach an edge, switch sides and direction and finish the move on new side without running into other edge or wall
    cube = get_test_cube()

    assert {4, 6, "v", 3} = execute_commands([{:move, 5}], {10, 0, "<", 1}, cube)
  end

  test "Part 2 - move between cube sides - go to the edge and over to finish the move #7" do
    # from C, go left 5 steps -> will reach an edge, switch sides and direction and finish the move on new side, run into a wall and stop there
    cube = get_test_cube()

    assert {7, 5, "v", 3} = execute_commands([{:move, 5}], {10, 3, "<", 1}, cube)
  end

  test "Part 2 - test cube schema" do
    # going 4 times the size of cube in 1 direction will result in coming back to original starting point
    cube = get_no_wall_cube()

    assert {8, 0, ">", 1} = execute_commands([{:move, 16}], {8, 0, ">", 1}, cube)
    assert {8, 0, "<", 1} = execute_commands([{:move, 16}], {8, 0, "<", 1}, cube)

    assert {8, 0, "^", 1} = execute_commands([{:move, 16}], {8, 0, "^", 1}, cube)
    assert {8, 0, "v", 1} = execute_commands([{:move, 16}], {8, 0, "v", 1}, cube)

    assert {0, 4, ">", 2} = execute_commands([{:move, 16}], {0, 4, ">", 2}, cube)
    assert {0, 4, "<", 2} = execute_commands([{:move, 16}], {0, 4, "<", 2}, cube)
  end

  test "Part 2 - test actual data cube schema" do
    # going 4 times the size of cube in 1 direction will result in coming back to original starting point
    cube = get_no_wall_cube_actual_data()

    assert {50, 0, ">", 1} = execute_commands([{:move, 200}], {50, 0, ">", 1}, cube)
    assert {50, 0, "<", 1} = execute_commands([{:move, 200}], {50, 0, "<", 1}, cube)

    assert {50, 0, "^", 1} = execute_commands([{:move, 200}], {50, 0, "^", 1}, cube)
    assert {50, 0, "v", 1} = execute_commands([{:move, 200}], {50, 0, "v", 1}, cube)

    assert {50, 50, ">", 3} = execute_commands([{:move, 200}], {50, 50, ">", 3}, cube)
    assert {50, 50, "<", 3} = execute_commands([{:move, 200}], {50, 50, "<", 3}, cube)

    assert {50, 50, "^", 3} = execute_commands([{:move, 200}], {50, 50, "^", 3}, cube)
    assert {50, 50, "v", 3} = execute_commands([{:move, 200}], {50, 50, "v", 3}, cube)
  end

  test "Part 2 - get password after all moves on the cube" do
    part2 =
      @test_data
      |> parse_data()
      |> get_password_cube(test_cube_schema(), 4)

    assert part2 == 5031
  end

  defp get_no_wall_cube() do
    {board, _commands} = @test_data |> String.replace("#", ".") |> parse_data()

    test_cube_schema()
    |> get_cube_definition(4, board)
  end

  defp get_no_wall_cube_actual_data() do
    {board, _commands} = get_data() |> String.replace("#", ".") |> parse_data()

    input_cube_schema()
    |> get_cube_definition(50, board)
  end

  defp get_test_cube() do
    {board, _commands} = parse_data(@test_data)

    test_cube_schema()
    |> get_cube_definition(4, board)
  end
end
