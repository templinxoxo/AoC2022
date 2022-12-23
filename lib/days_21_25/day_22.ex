defmodule Day22 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> get_password()
  end

  # actual logic
  def get_password({board, commands}) do
    rows = map_by_rows(board)
    columns = map_by_columns(board)

    start_position = {
      rows |> Map.get(0) |> elem(0) |> elem(0),
      0,
      ">"
    }

    {x, y, direction} =
      commands
      |> Enum.reduce(start_position, fn command, current_position ->
        execute_command(command, current_position, rows, columns)
      end)

    1000 * (y + 1) + 4 * (x + 1) + get_direction_value(direction)
  end

  def execute_command({:turn, turn_direction}, {x, y, current_direction}, _rows, _columns) do
    IO.inspect("turn")

    {x, y, rotate(current_direction, turn_direction)}
  end

  def execute_command({:move, tiles}, {x, y, ">"}, rows, _columns),
    do: {move(rows[y], x, tiles, 1), y, ">"}

  def execute_command({:move, tiles}, {x, y, "<"}, rows, _columns),
    do: {move(rows[y], x, tiles, -1), y, "<"}

  def execute_command({:move, tiles}, {x, y, "v"}, _rows, columns),
    do: {x, move(columns[x], y, tiles, 1), "v"}

  def execute_command({:move, tiles}, {x, y, "^"}, _rows, columns),
    do: {x, move(columns[x], y, tiles, -1), "^"}

  def move({{range_start, range_end}, []}, start_index, move_by, direction) do
    # in case there is no walls in the way - relative move will be module of number of moves and row (/column) length
    row_length = range_end - range_start

    case start_index + direction * Integer.mod(move_by, row_length) do
      new_index when new_index > range_end ->
        # if new index is over range -> wrap to beginning
        range_start + (new_index - range_end) - 1

      new_index when new_index < range_start ->
        # if new index is under range -> wrap to end
        range_end - (range_start - new_index) + 1

      new_index ->
        new_index
    end
  end

  def move({range, walls}, start_index, move_by, direction) do
    {walls_before, walls_after} = Enum.split_with(walls, &(&1 < start_index))

    first_wall = List.first(walls_before)
    first_wall_after_current_position = List.first(walls_after)
    first_wall_before_current_position = List.last(walls_before)
    last_wall = List.last(walls_after)

    # calculate distance to closest wall in given direction
    moves_to_closest_wall =
      case direction do
        1 ->
          moves_to_wall(first_wall_after_current_position, start_index) ||
            moves_to_wall_with_wrap(first_wall, start_index, range)

        -1 ->
          moves_to_wall(first_wall_before_current_position, start_index) ||
            moves_to_wall_with_wrap(last_wall, start_index, range)
      end

    # move disregarding walls - new moves number is either going to fill all move_by steps or stop before a wall
    move({range, []}, start_index, min(move_by, moves_to_closest_wall), direction)
  end

  def moves_to_wall(nil, _position), do: nil

  def moves_to_wall(wall, position), do: abs(position - wall) - 1

  def moves_to_wall_with_wrap(nil, _position, _range), do: nil

  def moves_to_wall_with_wrap(wall, position, {range_start, range_end}),
    do: range_end - range_start - abs(position - wall)

  @directions [">", "v", "<", "^"]
  def get_direction_value(direction) do
    Enum.find_index(@directions, &(&1 == direction))
  end

  @turn_values %{"L" => -1, "R" => 1}
  def rotate(current_direction, turn_direction) do
    current_direction_index = get_direction_value(current_direction)
    turn_direction_change = Map.get(@turn_values, turn_direction)

    Enum.at(
      @directions,
      Integer.mod(current_direction_index + turn_direction_change, length(@directions))
    )
  end

  # helpers
  def map_by_rows(board) do
    board
    |> Enum.with_index()
    |> Enum.map(fn {column, index} ->
      board_tiles =
        column
        |> Enum.with_index()
        |> Enum.reject(fn {type, _} -> type == :empty end)

      walls =
        board_tiles
        |> Enum.filter(fn {type, _index} -> type == :wall end)
        |> Enum.map(fn {_type, index} -> index end)

      range =
        board_tiles
        |> Enum.map(fn {_type, index} -> index end)
        |> Enum.min_max()

      {index, {range, walls}}
    end)
    |> Map.new()
  end

  def map_by_columns(board) do
    board
    |> List.zip()
    |> Enum.map(&Tuple.to_list(&1))
    |> map_by_rows()
  end

  def get_data() do
    Api.get_input(22)
  end

  def parse_data(data) do
    [raw_board, raw_commands] = String.split(data, "\n\n", trim: true)

    raw_rows = String.split(raw_board, "\n", trim: true)
    row_size = raw_rows |> Enum.map(&String.length(&1)) |> Enum.max()

    board =
      raw_rows
      |> Enum.map(fn row ->
        row
        |> String.split("", trim: true)
        |> Enum.map(fn
          " " -> :empty
          "." -> :board
          "#" -> :wall
        end)
      end)
      |> Enum.map(fn row ->
        0..(row_size - 1)
        |> Enum.map(fn index ->
          Enum.at(row, index, :empty)
        end)
      end)

    commands =
      raw_commands
      |> String.replace("R", ",R,")
      |> String.replace("L", ",L,")
      |> String.replace("\n", "")
      |> String.split(",", trim: true)
      |> Enum.map(fn
        turn when turn in ["R", "L"] ->
          {:turn, turn}

        move ->
          {:move, String.to_integer(move)}
      end)

    {board, commands}
  end
end
