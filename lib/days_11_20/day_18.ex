defmodule Day18 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> count_sides()
  end

  # actual logic
  def count_sides(droplets) do
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
end
