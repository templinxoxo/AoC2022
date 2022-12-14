defmodule Day14Pt2 do
  import Day14

  # this almost works - idea was to look for negative space instead of positive one
  # i.e. find all empty places after sand falls just by looking at horizontal ledges (enpty spaces will be beneath)
  # this doesn't work because it can't take into account more complex structures found in real data

  # execute methods
  def execute() do
    get_data()
    |> count_falling_sand()
  end

  def count_falling_sand(data) do
    cave_formation =
      data
      |> parse_data()

    bounds = get_cave_bounds(cave_formation)
    %{y: [_, max_depth]} = bounds

    empty_coortinates =
      data
      |> get_ledges()
      |> Enum.flat_map(fn {[start_point, end_point], depth} ->
        width = abs(end_point - start_point)
        height = ceil(width / 2)

        start_elevation = 1

        start_coordinates = {start_point + height, depth - height - start_elevation}

        bounds = %{
          x: [start_point - width - 2, end_point + width + 2],
          y: [elem(start_coordinates, 1), depth + width] |> Enum.map(&Enum.min([&1, max_depth]))
        }

        below_ledge_cave_formation = cave_formation |> Enum.reject(fn {_x, y} -> y < depth end)

        fallen_sand =
          track_falling_sand(
            start_coordinates,
            bounds,
            below_ledge_cave_formation,
            []
          )

        whole_triangle_coordinations =
          get_full_triangle_coordinations(
            start_coordinates,
            Enum.at(bounds.y, 1)
          )

        empty_coortinates =
          (whole_triangle_coordinations -- fallen_sand) -- below_ledge_cave_formation

        # print(start_coordinates, bounds, below_ledge_cave_formation, [])
        # print(start_coordinates, bounds, below_ledge_cave_formation, fallen_sand)
        # print(start_coordinates, bounds, below_ledge_cave_formation, empty_coortinates)

        empty_coortinates
      end)

    full_triangle = get_full_triangle_coordinations({0, 0}, max_depth)
    fallen_sand = (full_triangle -- cave_formation) -- empty_coortinates

    print({0, 0}, bounds, cave_formation, fallen_sand)

    fallen_sand |> Enum.count()
  end

  def get_full_triangle_coordinations({x0, y0}, depth) do
    y0..depth
    |> Enum.with_index()
    |> Enum.flat_map(fn {y, level} ->
      (x0 - level)..(x0 + level)
      |> Enum.map(fn x -> {x, y} end)
    end)
  end

  def get_ledges(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.flat_map(fn path ->
      path
      |> String.split(" -> ", trim: true)
      |> Enum.map(fn point ->
        [x, y] =
          point
          |> String.split(",", trim: true)
          |> Enum.map(&String.to_integer(&1))

        [x - 500, y]
      end)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.filter(fn
        [[_x0, y], [_x1, y]] ->
          true

        _ ->
          false
      end)
      |> Enum.map(fn [[start_point, depth], [end_point, depth]] ->
        {Enum.sort([start_point, end_point]), depth}
      end)
    end)
  end
end
