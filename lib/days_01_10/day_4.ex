defmodule Day4 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> get_fully_contained_assignments()
  end

  def execute_part2() do
    get_data()
    |> parse_data()
    |> get_overlapping_assignments()
  end

  # actual logic
  def get_fully_contained_assignments(groups) do
    groups
    |> Enum.filter(fn assignments ->
      total_range =
        assignments
        |> List.flatten()
        |> Enum.min_max()
        |> Tuple.to_list()

      total_range in assignments
    end)
    |> Enum.count()
  end

  def get_overlapping_assignments(groups) do
    IO.inspect(length(groups))
    # one assignment sections must close before other one begins to avoid overlap
    # so, possible overlap is from 2nd section start to 1st section end
    groups
    |> Enum.filter(fn assignments ->
      [[_, possible_overlap_end], [possible_overlap_start, _]] =
        assignments
        |> Enum.sort_by(&Enum.at(&1, 0))

      possible_overlap_end >= possible_overlap_start
    end)
    |> Enum.count()
  end

  # helpers
  def get_data() do
    Api.get_input(4)
  end

  def parse_data(data) do
    data
    |> String.split(["\n", "-", ","], trim: true)
    |> Enum.map(&String.to_integer(&1))
    |> Enum.chunk_every(2)
    |> Enum.chunk_every(2)
  end
end
