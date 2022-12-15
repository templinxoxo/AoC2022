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
    |> find_distess_coordinates(4_000_000)
  end

  # actual logic
  def find_scanned_empty_row_positions(scan_results, row) do
    scans_in_range =
      scan_results
      |> find_scanned_row_range(row)
      |> Enum.flat_map(fn {r0, r1} ->
        r0..r1 |> Enum.map(& &1)
      end)

    beacons_in_row = get_beacons_in_row(scan_results, row)

    (scans_in_range -- beacons_in_row)
    |> length()
  end

  def find_scanned_row_range(scan_results, row) do
    scan_results
    |> calculate_ranges()
    |> filter_in_row_range(row)
    |> get_scan_ranges(row)
    |> combine_ranges()
  end

  def find_distess_coordinates(scan_results, max_range) do
    {x, y} = search_for_distess_signal(0, max_range, scan_results)

    IO.inspect({x, y})

    4_000_000 * x + y
  end

  def search_for_distess_signal(row, max_range, scan_results) do
    if row > max_range do
      :out_of_bounds
    else
      scan_results
      |> find_scanned_row_range(row)
      |> Enum.reject(fn {x0, x1} -> x1 < 0 or x0 > max_range end)
      |> Enum.map(fn {x0, x1} -> {max(0, x0), min(max_range, x1)} end)
      |> Enum.sort_by(&elem(&1, 0))
      |> case do
        [{0, max_range}] ->
          search_for_distess_signal(row + 1, max_range, scan_results)

        [{0, range_end} | _] ->
          {range_end + 1, row}

        error ->
          IO.inspect({error, row})
          {0, 0}
      end
    end
  end

  def calculate_ranges(scan_results) do
    scan_results
    |> Enum.map(fn {{xs, ys}, {xb, yb}} ->
      range = abs(xs - xb) + abs(ys - yb)
      {{xs, ys}, {xb, yb}, range}
    end)
  end

  def filter_in_row_range(scan_results, row) do
    scan_results
    |> Enum.filter(fn {{_, ys}, _, range} ->
      ys + range >= row and ys - range <= row
    end)
  end

  def get_scan_ranges(scan_results, row) do
    scan_results
    |> Enum.map(fn {{xs, ys}, _beacon, range} ->
      deviation = abs(range - abs(row - ys))

      {xs - deviation, xs + deviation}
    end)
  end

  def combine_ranges(ranges) do
    ranges
    |> Enum.reduce([List.first(ranges)], fn {a0, a1}, combined_ranges ->
      combined_ranges
      |> Enum.find(fn {b0, b1} ->
        are_ranges_touching = a0 - 1 == b1 or b0 - 1 == a0

        are_ranges_partially_intersecting = (a0 >= b0 and a0 <= b1) or (a1 >= b0 and a1 <= b1)

        {x0, x1} = {min(b0, a0), max(b1, a1)}
        is_one_range_fully_contained = {x0, x1} == {a0, a1} or {x0, x1} == {b0, b1}

        are_ranges_touching or are_ranges_partially_intersecting or is_one_range_fully_contained
      end)
      |> case do
        nil ->
          combined_ranges ++ [{a0, a1}]

        {b0, b1} = match ->
          new_range = {min(b0, a0), max(b1, a1)}
          combined_ranges |> Enum.reject(&(&1 == match)) |> Enum.concat([new_range])
      end
    end)
    |> case do
      [_] = result -> result
      result when result == ranges -> result
      result -> combine_ranges(result)
    end
  end

  def get_beacons_in_row(scan_results, row) do
    scan_results
    |> Enum.filter(fn {_scanner, {_xb, yb}} -> yb == row end)
    |> Enum.map(fn {_scanner, {xb, _yb}} -> xb end)
    |> Enum.uniq()
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
