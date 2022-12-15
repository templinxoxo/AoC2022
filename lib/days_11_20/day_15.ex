defmodule Day15 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> find_scanned_empty_row_positions(2_000_000)
  end

  # actual logic
  def find_scanned_empty_row_positions(scan_results, row) do
    {covered_points, beacons} =
      scan_results
      |> Enum.map(fn {{xb, yb}, {xs, ys}} ->
        range = abs(xb - xs) + abs(yb - ys)
        {{xb, yb}, {xs, ys}, range}
      end)
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

    (covered_points -- beacons) |> length()
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
