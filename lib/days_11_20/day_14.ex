defmodule Day14 do
  use Memoize

  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> count_infinite_falling_sand()
  end

  def execute_part2() do
    get_data()
    |> parse_data()
    |> count_falling_sand_brute_force()
  end

  # actual logic
  def count_infinite_falling_sand(cave_formation) do
    bounds = get_cave_bounds(cave_formation)
    print({0, 0}, bounds, cave_formation, [])

    fallen_sand = track_infinite_falling_sand(bounds, cave_formation, [])

    fallen_sand |> length()
  end

  def track_infinite_falling_sand(bounds, cave_formation, fallen_sand) do
    case track_sand_fall(
           {0, 0},
           bounds,
           cave_formation ++ fallen_sand
         ) do
      {:end, :infinite} ->
        fallen_sand

      new_sand_coordinates ->
        # print({0, 0}, bounds, cave_formation, [new_sand_coordinates] ++ fallen_sand)

        track_infinite_falling_sand(bounds, cave_formation, [new_sand_coordinates] ++ fallen_sand)
    end
  end

  def count_falling_sand_brute_force(cave_formation) do
    bounds = get_cave_bounds(cave_formation)
    print({0, 0}, bounds, cave_formation, [])

    fallen_sand = track_falling_sand({0, 0}, bounds, cave_formation, [])

    fallen_sand |> length()
  end

  def track_falling_sand(start_coortinates, bounds, cave_formation, fallen_sand) do
    case track_sand_fall(
           start_coortinates,
           bounds,
           fallen_sand ++ cave_formation,
           false
         ) do
      coordinates when coordinates == start_coortinates ->
        [start_coortinates] ++ fallen_sand

      new_sand_coordinates ->
        track_falling_sand(
          start_coortinates,
          bounds,
          cave_formation,
          [new_sand_coordinates] ++ fallen_sand
        )
    end
  end

  def track_sand_fall(position, bounds, filled_coordinates, infinite \\ true) do
    %{
      x: [xMin, xMax],
      y: [_yMin, yMax]
    } = bounds

    case {position, infinite} do
      {{:end, coordinates}, _} ->
        coordinates

      {{x0, y0}, false} when y0 == yMax ->
        {x0, y0}

      {{x0, y0}, true} when x0 <= xMin or x0 >= xMax or y0 >= yMax ->
        {:end, :infinite}

      _ ->
        track_sand_fall(
          get_next_coordinates(position, filled_coordinates),
          bounds,
          filled_coordinates,
          infinite
        )
    end
  end

  def get_next_coordinates({x, y}, taken_corrdinates) do
    cond do
      {x, y + 1} not in taken_corrdinates -> {x, y + 1}
      {x - 1, y + 1} not in taken_corrdinates -> {x - 1, y + 1}
      {x + 1, y + 1} not in taken_corrdinates -> {x + 1, y + 1}
      true -> {:end, {x, y}}
    end
  end

  # helpers
  def get_data() do
    Api.get_input(14)
  end

  def parse_data(data) do
    # parse initial corrdinates to ones easier to track (change 494, 4 to -6, 4)
    # sand falls from point 0,0
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
      |> Enum.flat_map(fn [[x0, y0], [x1, y1]] ->
        x0..x1
        |> Enum.flat_map(fn x ->
          y0..y1
          |> Enum.map(fn y ->
            {x, y}
          end)
        end)
      end)
    end)
    |> Enum.uniq()
  end

  def print({x0, y0}, bounds, cave_formation, fallen_sand) do
    %{
      x: [xMin, xMax],
      y: [yMin, yMax]
    } = bounds

    yMin..yMax
    |> Enum.each(fn y ->
      xMin..xMax
      |> Enum.map(fn x ->
        cond do
          Enum.member?(fallen_sand, {x, y}) -> "."
          Enum.member?(cave_formation, {x, y}) -> "#"
          x == x0 and y == y0 -> "+"
          true -> " "
        end
      end)
      |> Enum.join("")
      |> IO.puts()
    end)
  end

  defmemo get_cave_bounds(cave_formation), expires_in: 30 do
    cave_formation
    |> Enum.flat_map(fn {x, y} -> [{:x, x}, {:y, y}] end)
    |> Enum.group_by(fn {axis, _} -> axis end)
    |> Enum.map(fn {axis, values} ->
      {min, max} = values |> Enum.map(&elem(&1, 1)) |> Enum.concat([0]) |> Enum.min_max()

      {axis, [min - 1, max + 1]}
    end)
    |> Map.new()
  end
end
