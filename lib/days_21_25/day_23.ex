defmodule Day23 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> calculate_covered_ground()
  end

  # actual logic
  def calculate_covered_ground(elf_positions, max_rounds \\ 10) do
    directions = default_directions()

    elf_move_round(elf_positions, directions, max_rounds)
    |> calculate_empty_spaces()
  end

  def calculate_empty_spaces(elf_positions) do
    positions =
      elf_positions
      |> MapSet.to_list()

    {min_x, max_x} = positions |> Enum.map(&elem(&1, 0)) |> Enum.min_max() |> IO.inspect()
    {min_y, max_y} = positions |> Enum.map(&elem(&1, 1)) |> Enum.min_max() |> IO.inspect()

    (max_x + 1 - min_x) * (max_y + 1 - min_y) - length(positions)
  end

  def elf_move_round(elf_positions, _directions, 0) do
    elf_positions
  end

  def elf_move_round(elf_positions, directions, rounds_left) do
    IO.inspect(elf_positions)

    proposed_positions =
      elf_positions
      |> Enum.map(fn elf ->
        direction_neighbours =
          directions |> Enum.map(fn direction -> {direction, get_neighbours(elf, direction)} end)

        cond do
          has_no_neighbours?(direction_neighbours, elf_positions) -> {:finished, elf}
          true -> move_in_any_direction(elf, direction_neighbours, elf_positions)
        end
      end)

    {moving_elves, stacionary_elves} =
      Enum.split_with(proposed_positions, &(elem(&1, 0) == :move))

    finished_elves = Enum.filter(stacionary_elves, &(elem(&1, 0) == :finished))

    if length(finished_elves) == MapSet.size(elf_positions) do
      elf_positions
    else
      duplicated_proposed_positions = get_duplicated_propositions(moving_elves)

      {duplicated_moving_elves, unique_moving_elves} =
        Enum.split_with(moving_elves, &(elem(&1, 1) in duplicated_proposed_positions))

      stacionary_elves_positions = Enum.map(stacionary_elves, &elem(&1, 1))
      duplicated_moving_elves_positions = Enum.map(duplicated_moving_elves, &elem(&1, 2))
      moving_elves_positions = Enum.map(unique_moving_elves, &elem(&1, 1))

      new_elf_positions =
        MapSet.new(
          stacionary_elves_positions ++
            duplicated_moving_elves_positions ++ moving_elves_positions
        )

      [last_direction | other_directions] = directions

      elf_move_round(new_elf_positions, other_directions ++ [last_direction], rounds_left - 1)
    end
  end

  def get_neighbours({x0, y0}, "^"),
    do: (x0 - 1)..(x0 + 1) |> Enum.map(fn x -> {x, y0 - 1} end) |> MapSet.new()

  def get_neighbours({x0, y0}, "v"),
    do: (x0 - 1)..(x0 + 1) |> Enum.map(fn x -> {x, y0 + 1} end) |> MapSet.new()

  def get_neighbours({x0, y0}, "<"),
    do: (y0 - 1)..(y0 + 1) |> Enum.map(fn y -> {x0 - 1, y} end) |> MapSet.new()

  def get_neighbours({x0, y0}, ">"),
    do: (y0 - 1)..(y0 + 1) |> Enum.map(fn y -> {x0 + 1, y} end) |> MapSet.new()

  def has_no_neighbours?(direction_neighbours, elf_positions) do
    direction_neighbours
    |> Enum.map(&elem(&1, 1))
    |> Enum.reduce(&MapSet.union(&1, &2))
    |> MapSet.intersection(elf_positions)
    |> MapSet.size()
    |> case do
      0 -> true
      _ -> false
    end
  end

  def move_in_any_direction({x, y}, direction_neighbours, elf_positions) do
    direction_neighbours
    |> Enum.find(fn {_direction, neighbours} ->
      MapSet.intersection(elf_positions, neighbours) |> MapSet.size() == 0
    end)
    |> case do
      nil ->
        {:blocked, {x, y}}

      {"^", _} ->
        {:move, {x, y - 1}, {x, y}}

      {"v", _} ->
        {:move, {x, y + 1}, {x, y}}

      {"<", _} ->
        {:move, {x - 1, y}, {x, y}}

      {">", _} ->
        {:move, {x + 1, y}, {x, y}}
    end
  end

  def get_duplicated_propositions(moving_elves) do
    moving_elves
    |> Enum.group_by(&elem(&1, 1))
    |> Enum.map(fn {new_position, duplicates} -> {new_position, length(duplicates)} end)
    |> Enum.filter(fn {_, number} -> number > 1 end)
    |> Enum.map(&elem(&1, 0))
  end

  # helpers
  def default_directions do
    ["^", "v", "<", ">"]
  end

  def get_data() do
    Api.get_input(23)
  end

  def parse_data(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.filter(fn {figure, _x} -> figure !== "." end)
      |> Enum.map(fn {_figure, x} -> {x, y} end)
    end)
    |> MapSet.new()
  end
end
