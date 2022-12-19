defmodule Day18 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> count_surface_area()
  end

  def execute_part2() do
    get_data()
    |> parse_data()
    |> count_outside_surface_area()
  end

  # actual logic - pt1
  def count_surface_area(droplets) do
    droplets
    |> Enum.flat_map(fn droplet ->
      # dimensions for x, y and z mapped to indexes of droplet
      0..2
      |> Enum.flat_map(&get_neighbor_by_dimension(droplet, &1))
    end)
    |> Enum.reject(fn neighbor -> neighbor in droplets end)
    |> Enum.count()
  end

  def get_neighbor_by_dimension(droplet, dimension) do
    Enum.map([1, -1], fn added_value ->
      # go one up and down for a given dimension
      dimension_value = Enum.at(droplet, dimension)

      List.replace_at(droplet, dimension, dimension_value + added_value)
    end)
  end

  # pt2
  def count_outside_surface_area(droplets) do
    total_surface_area = count_surface_area(droplets)

    gaps =
      droplets
      |> dissect_by_plane()
      |> remove_false_positives(droplets)

    internal_surface_area = count_surface_area(gaps)

    total_surface_area - internal_surface_area
  end

  def dissect_by_plane([[_ | _] | _] = points) do
    # we have to dissect given sphere by each dimension
    dimensions_number = points |> Enum.at(0) |> Enum.count()
    dissect_by_plane(points, dimensions_number)
  end

  def dissect_by_plane(points, 1) do
    # when we get to 1-dimension plane, we are basically operating on a straight line of points
    # we can simply take all numbers between start and end points and search for gaps (not included in points)
    # those will be possible gaps by axis in more complex plane
    {from, to} = points |> List.flatten() |> Enum.sort() |> Enum.min_max()

    from..to
    |> Enum.reject(&([&1] in points))
    |> Enum.map(&[&1])
  end

  def dissect_by_plane([[_ | _] | _] = points, dimensions_number) do
    # for each dimension
    0..(dimensions_number - 1)
    |> Enum.map(fn dimension_number ->
      # group points by given dimension plane
      points
      |> Enum.group_by(&Enum.at(&1, dimension_number))
      |> Enum.flat_map(fn {dimension, dimension_points} ->
        # IO.inspect({"dimension_value_dissect", dimension, dimension_number})
        # then we can remove this particular dimension from calculations
        dimension_points
        |> Enum.map(&List.delete_at(&1, dimension_number))
        # and disect 1-dimension smaller plane again until we get to 1 dimension
        |> dissect_by_plane(dimensions_number - 1)
        |> Enum.map(fn point ->
          # re-add dimension we took out earlier to get current plane coordinates
          List.insert_at(point, dimension_number, dimension)
        end)
      end)
    end)
    # now when points by each n-1 plane are calculated, we can compare each axix
    |> Enum.reduce(nil, fn dimension_gaps, current_points ->
      dimension_gaps = MapSet.new(dimension_gaps)

      # a point is a true gap inside figure, it has to appear as a gap on each dissected plane
      case current_points do
        nil -> dimension_gaps
        # intersecting all planes with each other will return only those points
        current_points -> MapSet.intersection(current_points, dimension_gaps)
      end
    end)
    |> MapSet.to_list()
  end

  def remove_false_positives(gaps, droplets) do
    gaps_after_removal =
      gaps
      |> Enum.filter(fn gap ->
        0..2
        |> Enum.flat_map(&get_neighbor_by_dimension(gap, &1))
        |> Enum.all?(fn point -> point in (gaps ++ droplets) end)
      end)

    case length(gaps_after_removal) - length(gaps) do
      0 ->
        gaps

      _ ->
        remove_false_positives(gaps_after_removal, droplets)
    end
  end

  # helpers
  def get_data() do
    Api.get_input(18)
  end

  def parse_data(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn droplet ->
      droplet
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer(&1))
    end)
  end

  def print(droplets, gaps) do
    [{x0, x1}, {y0, y1}, {z0, z1}] =
      (droplets ++ gaps)
      |> Enum.flat_map(&Enum.with_index(&1))
      |> Enum.group_by(fn {_val, index} -> index end)
      |> Enum.map(fn {_index, values} ->
        values
        |> Enum.map(&elem(&1, 0))
        |> Enum.min_max()
      end)

    z0..z1
    |> Enum.each(fn z ->
      IO.puts("")
      IO.puts("")
      IO.puts(z)
      IO.puts("")

      y0..y1
      |> Enum.each(fn y ->
        x0..x1
        |> Enum.map(fn x ->
          point = [x, y, z]

          cond do
            point in droplets ->
              "*"

            point in gaps ->
              "o"

            true ->
              "."
          end
        end)
        |> Enum.join("")
        |> IO.puts()
      end)
    end)
  end
end
