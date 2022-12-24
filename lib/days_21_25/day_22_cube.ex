defmodule Day22.Cube do
  import Day22
  import Day22.CubeDefinition

  # execute methods
  def execute_part2() do
    get_data()
    |> parse_data()
    |> get_password_cube(input_cube_schema(), 50)
  end

  # actual logic
  def get_password_cube({board, commands}, cube_schema, cube_size) do
    cube = get_cube_definition(cube_schema, cube_size, board)

    # start point on 1st side is always 2 lengths right and 0 top
    start_position = {
      cube_size * 2,
      0,
      ">",
      1
    }

    {x, y, direction, _side} = execute_commands(commands, start_position, cube)

    1000 * (y + 1) + 4 * (x + 1) + get_direction_value(direction)
  end

  def execute_commands(commands, start_position, cube) do
    Enum.reduce(
      commands,
      start_position,
      fn command, current_position ->
        execute_command_on_cube(command, current_position, cube)
      end
    )
  end

  def execute_command_on_cube(
        {:turn, turn_direction},
        {x, y, current_direction, current_side},
        _cube
      ) do
    {x, y, rotate(current_direction, turn_direction), current_side}
  end

  def execute_command_on_cube({:move, move_by}, {x, y, direction, current_side}, cube) do
    side_definition = Map.get(cube, current_side)
    full_range = Map.get(side_definition, "range")

    {{range_start, range_end}, walls} =
      case direction do
        horizontal when horizontal in [">", "<"] ->
          {
            elem(full_range, 0),
            get_move_axis(cube, current_side, "rows", y)
          }

        _vertival ->
          {
            elem(full_range, 1),
            get_move_axis(cube, current_side, "columns", x)
          }
      end

    {distance_to_edge, distance_to_wall} =
      case direction do
        ">" ->
          closest_wall_position = walls |> Enum.find(&(&1 > x))

          {
            range_end - x,
            wall_distance(closest_wall_position, x)
          }

        "v" ->
          closest_wall_position = walls |> Enum.find(&(&1 > y))

          {
            range_end - y,
            wall_distance(closest_wall_position, y)
          }

        "<" ->
          closest_wall_position = walls |> Enum.reverse() |> Enum.find(&(&1 < x))

          {
            x - range_start,
            wall_distance(closest_wall_position, x)
          }

        "^" ->
          closest_wall_position = walls |> Enum.reverse() |> Enum.find(&(&1 < y))

          {
            y - range_start,
            wall_distance(closest_wall_position, y)
          }
      end

    cond do
      move_by <= distance_to_wall and move_by <= distance_to_edge ->
        # if in given moves won't make it to wall or edge
        {new_x, new_y} = move_in_direction(x, y, direction, move_by)

        {new_x, new_y, direction, current_side}

      distance_to_wall < distance_to_edge ->
        # if wall is closer than the edge, will stop before a wall
        {new_x, new_y} = move_in_direction(x, y, direction, distance_to_wall)

        {new_x, new_y, direction, current_side}

      true ->
        # will move over the edge
        # first go to the current side edge
        {new_x, new_y} = move_in_direction(x, y, direction, distance_to_edge)

        # try switching sides
        case switch_side({new_x, new_y, direction, current_side}, cube) do
          # if there is a wall on the other side - stay on current side edge
          :edge_wall ->
            {new_x, new_y, direction, current_side}

          # else, move remaining steps on a new side
          new_position ->
            execute_command_on_cube({:move, move_by - distance_to_edge - 1}, new_position, cube)
        end
    end
  end

  def wall_distance(nil, _current_position), do: :no_wall

  def wall_distance(wall_position, current_position),
    do: abs(wall_position - current_position) - 1

  def move_in_direction(x, y, ">", moves), do: {x + moves, y}
  def move_in_direction(x, y, "v", moves), do: {x, y + moves}
  def move_in_direction(x, y, "<", moves), do: {x - moves, y}
  def move_in_direction(x, y, "^", moves), do: {x, y - moves}

  defp get_move_axis(cube, current_side, axis, value),
    do: cube |> Map.get(current_side) |> Map.get("walls") |> Map.get(axis) |> Map.get(value)

  def switch_side({x, y, direction, side}, cube) do
    {new_side, new_direction, position_mapper} =
      cube
      |> Map.get(side)
      |> Map.get(direction)

    {new_x, new_y} = position_mapper.({x, y})

    cube
    |> Map.get(new_side)
    |> Map.get("walls")
    |> Map.get("rows")
    |> Map.get(new_y)
    |> Enum.member?(new_x)
    |> case do
      true ->
        :edge_wall

      false ->
        {new_x, new_y, new_direction, new_side}
    end
  end
end
