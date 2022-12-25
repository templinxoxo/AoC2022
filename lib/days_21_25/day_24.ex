defmodule Day24 do
  use Memoize
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> count_steps_to_pass_site()
  end

  def execute_part2() do
    get_data()
    |> parse_data()
    |> count_steps_to_pass_site_2_times()
  end

  # actual logic
  def count_steps_to_pass_site({winds, height, width}) do
    {path, _} = traverse_blizzard([[{0, -1}]], winds, height, width, {width - 1, height - 1})
    length(path)
  end

  def count_steps_to_pass_site_2_times({winds, height, width}) do
    {path_to_finish, winds_after_finishing} =
      traverse_blizzard([[{0, -1}]], winds, height, width, {width - 1, height - 1})

    {path_back, winds_after_coming_back} =
      traverse_blizzard(
        [[{width - 1, height - 1}]],
        winds_after_finishing,
        height,
        width,
        {0, -1}
      )

    {path_again_to_finish, _} =
      traverse_blizzard(
        [[{0, -1}]],
        winds_after_coming_back,
        height,
        width,
        {width - 1, height - 1}
      )

    length(path_to_finish) + length(path_back) + length(path_again_to_finish) - 2
  end

  def traverse_blizzard([], _winds, _height, _width, _end_coordinates) do
    []
  end

  def traverse_blizzard(paths, winds, height, width, end_coordinates) do
    paths |> Enum.at(0) |> length() |> IO.inspect()

    new_winds = blizzard_movement(winds, height, width)
    safe_coordinates = get_safe_coordinates(new_winds, height, width)

    new_paths =
      paths
      |> Enum.flat_map(fn path ->
        path
        |> List.last()
        |> get_possible_movements(height, width)
        |> MapSet.intersection(safe_coordinates)
        |> MapSet.to_list()
        |> Enum.map(&(path ++ [&1]))
      end)
      |> deduplicate()

    new_paths
    |> Enum.find(fn path -> List.last(path) == end_coordinates end)
    |> case do
      nil ->
        traverse_blizzard(new_paths, new_winds, height, width, end_coordinates)

      path ->
        {path, new_winds}
    end
  end

  def deduplicate(paths) do
    paths
    |> Enum.map(&List.last(&1))
    |> Enum.uniq()
    |> Enum.map(fn last -> Enum.find(paths, &(List.last(&1) == last)) end)
  end

  def blizzard_movement(winds, height, width) do
    Enum.map(winds, fn {wind, positions} ->
      {wind, positions |> Enum.map(fn position -> move(position, wind, height, width) end)}
    end)
  end

  def move({x, y}, ">", _height, width), do: {Integer.mod(x + 1, width), y}
  def move({x, y}, "v", height, _width), do: {x, Integer.mod(y + 1, height)}
  def move({x, y}, "<", _height, width), do: {Integer.mod(x - 1, width), y}
  def move({x, y}, "^", height, _width), do: {x, Integer.mod(y - 1, height)}

  def get_safe_coordinates(winds, height, width) do
    wind_coordinates = Enum.flat_map(winds, &elem(&1, 1))
    MapSet.new((all_coordinates(height, width) -- wind_coordinates) ++ [{0, -1}])
  end

  defmemo all_coordinates(height, width), expires_in: 30 * 1000 do
    0..(width - 1)
    |> Enum.flat_map(fn x ->
      0..(height - 1)
      |> Enum.map(fn y ->
        {x, y}
      end)
    end)
  end

  def get_possible_movements({x0, y0}, height, width) do
    [{x0 - 1, y0}, {x0 + 1, y0}, {x0, y0 - 1}, {x0, y0 + 1}, {x0, y0}]
    |> Enum.filter(fn
      # always allow end points if reached
      {0, -1} -> true
      {x, y} when x == width - 1 and y == height - 1 -> true
      {-1, _y} -> false
      {_x, -1} -> false
      {x, _y} when x >= width -> false
      {_x, y} when y >= height -> false
      _ -> true
    end)
    |> MapSet.new()
  end

  # helpers
  def get_data() do
    Api.get_input(24)
  end

  def parse_data(data) do
    winds =
      data
      |> String.replace("#", "")
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, y} ->
        row
        |> String.split("", trim: true)
        |> Enum.with_index()
        |> Enum.filter(fn {tile, _x} ->
          tile in [">", "v", "<", "^"]
        end)
        |> Enum.map(fn {tile, x} -> {tile, {x, y - 1}} end)
      end)
      |> Enum.group_by(&elem(&1, 0))
      |> Enum.map(fn {wind, coordinates} ->
        {wind, Enum.map(coordinates, &elem(&1, 1))}
      end)

    width = data |> String.split("\n", trim: true) |> Enum.at(1) |> String.length()
    height = data |> String.split("\n", trim: true) |> length()

    {winds, height - 2, width - 2}
  end
end
