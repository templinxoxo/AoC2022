defmodule Day6 do
  # execute methods
  def execute_part1() do
    get_data()
    |> find_start_marker()
  end

  # execute methods
  def execute_part2() do
    get_data()
    |> find_start_marker(14)
  end

  # actual logic
  def find_start_marker(datastream, masker_size \\ 4) do
    datastream
    |> String.split("", trim: true)
    |> Enum.chunk_every(masker_size, 1, :discard)
    |> Enum.with_index()
    |> Enum.find(fn {sequence, _index} ->
      sequence
      |> Enum.uniq()
      |> Enum.count() == masker_size
    end)
    |> case do
      {_, index} -> index + masker_size
      _ -> 0
    end
  end

  # helpers
  def get_data() do
    Api.get_input(6)
  end
end
