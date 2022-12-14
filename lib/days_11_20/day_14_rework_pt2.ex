defmodule Day14Rweork do
  import Day14

  # execute methods

  def execute() do
    get_data()
    |> parse_data()
    |> go_through_sand_piramide()
  end

  def go_through_sand_piramide(cave_formation) do
    # get cave bounds and depth
    bounds = get_cave_bounds(cave_formation)
    %{y: [_, max_depth]} = bounds

    # map cave rocks by each level
    cave_levels =
      cave_formation
      |> Enum.group_by(fn {_x, y} -> y end)
      |> Enum.map(fn {y, formations} ->
        {
          y,
          formations
          |> Enum.map(fn {x, _y} -> x end)
        }
      end)
      |> Map.new()

    fallen_sand =
      1..max_depth
      |> Enum.reduce([{0, [0]}], fn level, fallen_sand ->
        last_level = fallen_sand |> List.last() |> elem(1) |> MapSet.new()
        # go through each level, looking up if level above has sand

        rocks = Map.get(cave_levels, level, [])
        current_level_space = Enum.map(-level..level, & &1) -- rocks
        # each next level can be at max 1 tile wider in both directions
        # each empty space (not rock) which has sand in any position on top of it top, top-left or top-right
        # will also have sand

        current_level_fallen_sand =
          current_level_space
          |> Enum.filter(fn x ->
            [x - 1, x, x + 1]
            |> MapSet.new()
            |> MapSet.intersection(last_level)
            |> Enum.any?(& &1)
          end)

        # don't have to track full coordinates. When grouped by level it's easier when coparing,
        # i.e. [{0,1}, {0,2}, {0,3}, {1,-1}, {1,1}] becomes: [{0, [1,2,3]}, {-1, 1}]
        # using structure like this makes 2 things simpler
        #   * finding intersection between current x coordinates and parent x coordinates
        #   * getting exactly the level above - you don't have to iterate through all coordinates when searching for direct parents

        fallen_sand ++ [{level, current_level_fallen_sand}]
      end)
      |> Enum.flat_map(fn {level, sand_coordinates} ->
        sand_coordinates
        |> Enum.map(fn x ->
          # change to normal coordinates for sake of printing
          {x, level}
        end)
      end)

    print({0, 0}, bounds, cave_formation, fallen_sand)

    Enum.count(fallen_sand)
  end
end
