defmodule Day15 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> find_scanned_empty_row_positions(2_000_000)
  end

  def execute_part2() do
    get_data()
    |> parse_data()
    |> find_distess_coordinates_brute_force(4_000_000)
  end

  # actual logic
  def find_scanned_empty_row_positions(scan_results, row) do
    {covered_points, beacons} = find_scanned_row_positoins(scan_results, row)

    (covered_points -- beacons)
    |> length()
  end

  def find_scanned_row_positoins(scan_results, row) do
    {covered_points, beacons} =
      scan_results
      |> calculate_ranges()
      |> Enum.filter(fn {{_, yb}, _, range} ->
        yb + range >= row and yb - range <= row
      end)
      |> Enum.map(fn {{xb, yb}, {xs, ys}, range} ->
        deviation = abs(range - abs(row - yb))

        covered_points =
          (xb - deviation)..(xb + deviation)
          |> Enum.map(& &1)

        if ys == row do
          {covered_points, xs}
        else
          {covered_points, nil}
        end
      end)
      |> Enum.reduce({[], []}, fn {sonar_points, beacon}, {covered_points, beacons} ->
        {sonar_points ++ covered_points, [beacon] ++ beacons}
      end)

    covered_points = covered_points |> Enum.uniq()
    beacons = beacons |> Enum.uniq()

    {covered_points, beacons}
  end

  def find_distess_coordinates(scan_results, max_range) do
    scan_results
    |> calculate_ranges()
    |> Enum.filter(fn {_, _, range} -> range / 2 > max_range end)
    |> IO.inspect()
  end

  def find_distess_coordinates_brute_force(scan_results, max_range) do
    row_range = 0..max_range |> Enum.map(& &1)

    {x, y} = search_for_distess_signal(0, max_range, scan_results, row_range)

    4_000_000 * x + y
  end

  def search_for_distess_signal(row, max_range, scan_results, row_range) do
    if abs(row / 100_000) == 0, do: IO.inspect(row)

    {row_scan, _} =
      scan_results
      |> find_scanned_row_positoins(row)

    empty_spaces = row_range -- row_scan

    cond do
      row > max_range -> :out_of_bounds
      empty_spaces == [] -> search_for_distess_signal(row + 1, max_range, scan_results, row_range)
      true -> {List.first(empty_spaces), row}
    end
  end

  def calculate_ranges(scan_results) do
    scan_results
    |> Enum.map(fn {{xb, yb}, {xs, ys}} ->
      range = abs(xb - xs) + abs(yb - ys)
      {{xb, yb}, {xs, ys}, range}
    end)
  end

  # helpers
  def get_data() do
    Api.get_input(15)
  end

  def parse_data(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn scan ->
      scan
      |> String.replace("Sensor at x=", "")
      |> String.replace(" y=", ",")
      |> String.replace(": closest beacon is at x=", ",")
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer(&1))
      |> Enum.chunk_every(2)
      |> Enum.map(&List.to_tuple(&1))
      |> List.to_tuple()
    end)
  end
end
