defmodule Day8 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> count_visible_trees()
  end

  # execute methods
  def execute_part2() do
    get_data()
    |> parse_data()
    |> find_best_house_place()
  end

  # actual logic
  def count_visible_trees(trees) do
    hidden_trees = length(find_hidden_trees(trees))

    total_trees = length(trees) * length(Enum.at(trees, 0))

    total_trees - hidden_trees
  end

  def find_hidden_trees(trees) do
    trees
    |> get_trees_in_all_directions()
    |> Enum.map(fn {row, col, value, inline_trees} ->
      is_hidden =
        inline_trees
        |> Enum.all?(&(Enum.max(&1) >= value))

      {row, col, is_hidden}
    end)
    |> Enum.reject(fn {_row, _col, is_hidden} -> !is_hidden end)
  end

  def find_best_house_place(trees) do
    trees
    |> get_trees_in_all_directions()
    |> Enum.map(fn {row, col, value, inline_trees} ->
      [a, b, c, d] =
        inline_trees
        |> Enum.map(fn line ->
          line
          |> Enum.reduce({0, false}, fn tree, {count, blocked} ->
            cond do
              blocked ->
                {count, blocked}

              tree >= value ->
                {count + 1, true}

              true ->
                {count + 1, blocked}
            end
          end)
          |> elem(0)
        end)

      {row, col, a * b * c * d}
    end)
    |> Enum.max_by(fn {_row, _col, score} -> score end)
    |> elem(2)
  end

  def get_trees_in_all_directions(trees) do
    rows = trees
    cols = trees |> List.zip() |> Enum.map(&Tuple.to_list(&1))

    1..(length(rows) - 2)
    |> Enum.flat_map(fn row_index ->
      1..(length(cols) - 2)
      |> Enum.map(fn col_index ->
        row = Enum.at(rows, row_index)
        col = Enum.at(cols, col_index)
        value = row |> Enum.at(col_index)

        inline_trees = [
          Enum.slice(row, 0..(col_index - 1)) |> Enum.reverse(),
          Enum.slice(col, 0..(row_index - 1)) |> Enum.reverse(),
          Enum.slice(row, (col_index + 1)..length(row)),
          Enum.slice(col, (row_index + 1)..length(col))
        ]

        {row_index, col_index, value, inline_trees}
      end)
    end)
  end

  # helpers
  def get_data() do
    Api.get_input(8)
  end

  def parse_data(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer(&1))
    end)
  end
end
