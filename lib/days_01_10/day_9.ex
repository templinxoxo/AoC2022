defmodule Day9 do
  # execute methods
  def execute_part1() do
    get_data()
    |> get_rope_steps()
    |> count_unique_tail_positions()
  end

  # actual logic
  def count_unique_tail_positions(steps) do
    steps
    |> get_rope_head_movements()
    |> get_rope_tail_movements()
    |> Enum.uniq()
    |> Enum.count()
  end

  def get_rope_head_movements(steps) do
    steps
    |> Enum.reduce({{0, 0}, [{0, 0}]}, fn
      {x, y}, {{x0, y0}, positions} ->
        new_position = {x + x0, y + y0}

        {new_position, positions ++ [new_position]}
    end)
    |> elem(1)
  end

  def get_rope_tail_movements(steps) do
    steps
    |> Enum.reduce({{0, 0}, []}, fn {xH, yH}, {{xT, yT}, positions} ->
      {xM, yM} = get_axis_movements({xH - xT, yH - yT})
      new_position = {xT + xM, yT + yM}

      {new_position, positions ++ [new_position]}
    end)
    |> elem(1)
  end

  def get_axis_movements({xM, yM} = movement) do
    if should_move?(movement) do
      {
        get_axis_movement(xM),
        get_axis_movement(yM)
      }
    else
      {0, 0}
    end
  end

  def should_move?({xM, yM}) do
    abs(xM) > 1 or abs(yM) > 1
  end

  def get_axis_movement(movement) when movement > 0, do: 1
  def get_axis_movement(movement) when movement < 0, do: -1
  def get_axis_movement(_), do: 0

  # helpers
  def get_data() do
    Api.get_input(9)
  end

  def get_rope_steps(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.flat_map(&get_step(&1))
  end

  def get_step("R " <> steps), do: generate_steps(steps, {1, 0})
  def get_step("L " <> steps), do: generate_steps(steps, {-1, 0})
  def get_step("U " <> steps), do: generate_steps(steps, {0, 1})
  def get_step("D " <> steps), do: generate_steps(steps, {0, -1})

  def generate_steps(steps, move) do
    len =
      steps
      |> String.to_integer()

    List.duplicate(move, len)
  end
end
