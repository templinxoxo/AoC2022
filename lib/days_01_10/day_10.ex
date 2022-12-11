defmodule Day10 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> sum_signal_strength()
  end

  def execute_part2() do
    get_data()
    |> parse_data()
    |> render_program_image()
  end

  # actual logic
  def sum_signal_strength(commands) do
    program_states = execute_program(commands)

    [20, 60, 100, 140, 180, 220]
    |> Enum.map(&(Enum.at(program_states, &1 - 1) * &1))
    |> Enum.sum()
  end

  def render_program_image(commands) do
    execute_program(commands)
    |> Enum.with_index()
    |> Enum.map(fn {value, timestamp} ->
      sprite = [value - 1, value, value + 1]

      if Integer.mod(timestamp, 40) in sprite do
        "#"
      else
        " "
      end
    end)
    |> Enum.chunk_every(40)
    |> Enum.map(&(Enum.join(&1, "") |> IO.puts()))
  end

  def execute_program(commands) do
    commands
    |> Enum.reduce([1], &execute_command/2)
  end

  def execute_command("addx " <> value, prev_states) do
    current_state = List.last(prev_states)
    new_state = current_state + String.to_integer(value)

    prev_states ++ [current_state, new_state]
  end

  def execute_command("noop", prev_states) do
    prev_states ++ [List.last(prev_states)]
  end

  # helpers
  @spec get_data :: any
  def get_data() do
    Api.get_input(10)
  end

  def parse_data(data) do
    data
    |> String.split("\n", trim: true)
  end
end
