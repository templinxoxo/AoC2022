defmodule Day6 do
  # execute methods
  def execute_part1() do
    get_data()
    |> find_start_marker()
  end

  # actual logic
  def find_start_marker(datastream) do
    datastream
    |> String.split("", trim: true)
    |> Enum.chunk_every(4, 1, :discard)
    |> Enum.with_index()
    |> Enum.find(fn {sequence, _index} ->
      sequence
      |> Enum.uniq()
      |> Enum.count() == 4
    end)
    |> case do
      {_, index} -> index + 4
      _ -> 0
    end
  end

  # helpers
  def get_data() do
    Api.get_input(6)
  end
end
