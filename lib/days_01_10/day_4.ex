defmodule Day4 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> get_fully_contained_assignments()
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
