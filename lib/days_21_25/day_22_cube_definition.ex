defmodule Day22.CubeDefinition do
  import Day22

  # this module will create a cube definition object. Each key represent one of the cube walls
  # and it's subsequent keys represent move in each of possible edge directions.
  # move will (almost) always change positions of x, y coordinates on original 2D grid and direction of move
  # sides also contain individual walls, split into rows for each row and column on side grid, similarly to pt1 solution
  def get_cube_definition(cube_schema, side_size, board) do
    # base definition with generic side change function and range
    cube_schema
    |> add_actual_ranges(side_size, board)
    |> add_actual_side_turning_functions(side_size)
  end

  def add_actual_ranges(cube_definition, side_size, board) do
    # populate range from actual board size and add walls for each side
    all_rows =
      map_by_rows(board)
      |> Enum.map(fn {i, {_range, walls}} -> {i, walls} end)
      |> Map.new()

    all_columns =
      map_by_columns(board)
      |> Enum.map(fn {i, {_range, walls}} -> {i, walls} end)
      |> Map.new()

    cube_definition
    |> Map.to_list()
    |> Enum.map(fn {side, definition} ->
      [{start_x, end_x}, {start_y, end_y}] =
        definition
        |> Map.get("range")
        |> Tuple.to_list()
        |> Enum.map(fn {range_start, range_end} ->
          # add actual range
          {range_start * side_size, range_end * side_size - 1}
        end)

      # add walls split to rows and columns
      walls = %{
        "rows" =>
          start_y..end_y
          |> Enum.map(fn i ->
            {i,
             all_rows
             |> Map.get(i)
             |> Enum.filter(&(&1 in start_x..end_x))}
          end)
          |> Map.new(),
        "columns" =>
          start_x..end_x
          |> Enum.map(fn i ->
            {i,
             all_columns
             |> Map.get(i)
             |> Enum.filter(&(&1 in start_y..end_y))}
          end)
          |> Map.new()
      }

      updated_definition =
        definition
        |> Map.replace!("range", {{start_x, end_x}, {start_y, end_y}})
        |> Map.put("walls", walls)

      {side, updated_definition}
    end)
    |> Map.new()
  end

  def add_actual_side_turning_functions(cube_with_ranges, side_size) do
    # return new value, depending on if original counted is taken from beginning or end of edge
    get_new_axis_value = fn value, range_start, range_end ->
      case value do
        {-1, value} ->
          range_end - Integer.mod(abs(value), side_size)

        value ->
          range_start + Integer.mod(value, side_size)
      end
    end

    Enum.map(cube_with_ranges, fn {side, definition} ->
      side_definition =
        all_directions()
        |> Enum.map(fn direction ->
          {new_side, new_direction, position_mapper} = Map.get(definition, direction)
          new_size_definition = Map.get(cube_with_ranges, new_side)

          new_position_mapper = fn position ->
            {{start_x, end_x}, {start_y, end_y}} = new_size_definition["range"]

            # override position_mapper to return coordinates based on actual sides ranges
            case position_mapper.(position) do
              {:start, y} ->
                {start_x, get_new_axis_value.(y, start_y, end_y)}

              {:end, y} ->
                {end_x, get_new_axis_value.(y, start_y, end_y)}

              {x, :start} ->
                {get_new_axis_value.(x, start_x, end_x), start_y}

              {x, :end} ->
                {get_new_axis_value.(x, start_x, end_x), end_y}
            end
          end

          {direction, {new_side, new_direction, new_position_mapper}}
        end)
        |> Map.new()

      {side, Map.merge(definition, side_definition)}
    end)
    |> Map.new()
  end

  def test_cube_schema do
    %{
      1 => %{
        "^" => {2, "v", fn {x, _y} -> {{-1, x}, :start} end},
        "v" => {4, "v", fn {x, _y} -> {x, :start} end},
        ">" => {6, "<", fn {_x, y} -> {:end, {-1, y}} end},
        "<" => {3, "v", fn {_x, y} -> {y, :start} end},
        "range" => {{2, 3}, {0, 1}}
      },
      2 => %{
        "^" => {1, "v", fn {x, _y} -> {{-1, x}, :start} end},
        "v" => {5, "^", fn {x, _y} -> {{-1, x}, :end} end},
        ">" => {3, ">", fn {_x, y} -> {:start, y} end},
        "<" => {6, "^", fn {_x, y} -> {{-1, y}, :end} end},
        "range" => {{0, 1}, {1, 2}}
      },
      3 => %{
        "^" => {1, ">", fn {x, _y} -> {:start, x} end},
        "v" => {5, ">", fn {x, _y} -> {:start, {-1, x}} end},
        ">" => {4, ">", fn {_x, y} -> {:start, y} end},
        "<" => {2, "<", fn {_x, y} -> {:end, y} end},
        "range" => {{1, 2}, {1, 2}}
      },
      4 => %{
        "^" => {1, "^", fn {x, _y} -> {x, :end} end},
        "v" => {5, "v", fn {x, _y} -> {x, :start} end},
        ">" => {6, "v", fn {_x, y} -> {{-1, y}, :start} end},
        "<" => {3, "<", fn {_x, y} -> {:end, y} end},
        "range" => {{2, 3}, {1, 2}}
      },
      5 => %{
        "^" => {4, "^", fn {x, _y} -> {x, :end} end},
        "v" => {2, "^", fn {x, _y} -> {{-1, x}, :end} end},
        ">" => {6, ">", fn {_x, y} -> {:start, y} end},
        "<" => {3, "^", fn {_x, y} -> {{-1, y}, :end} end},
        "range" => {{2, 3}, {2, 3}}
      },
      6 => %{
        "^" => {4, "<", fn {x, _y} -> {:end, {-1, x}} end},
        "v" => {2, ">", fn {x, _y} -> {:start, {-1, x}} end},
        ">" => {1, "<", fn {_x, y} -> {:end, {-1, y}} end},
        "<" => {5, "<", fn {_x, y} -> {:end, y} end},
        "range" => {{3, 4}, {2, 3}}
      }
    }
  end

  def input_cube_schema do
    %{
      1 => %{
        "^" => {6, ">", fn {x, _y} -> {:start, x} end},
        "v" => {3, "v", fn {x, _y} -> {x, :start} end},
        ">" => {2, ">", fn {_x, y} -> {:start, y} end},
        "<" => {4, ">", fn {_x, y} -> {:start, {-1, y}} end},
        "range" => {{1, 2}, {0, 1}}
      },
      2 => %{
        "^" => {6, "^", fn {x, _y} -> {x, :end} end},
        "v" => {3, "<", fn {x, _y} -> {:end, x} end},
        ">" => {5, "<", fn {_x, y} -> {:end, {-1, y}} end},
        "<" => {1, "<", fn {_x, y} -> {:end, y} end},
        "range" => {{2, 3}, {0, 1}}
      },
      3 => %{
        "^" => {1, "^", fn {x, _y} -> {x, :end} end},
        "v" => {5, "v", fn {x, _y} -> {x, :start} end},
        ">" => {2, "^", fn {_x, y} -> {y, :end} end},
        "<" => {4, "v", fn {_x, y} -> {y, :start} end},
        "range" => {{1, 2}, {1, 2}}
      },
      4 => %{
        "^" => {3, ">", fn {x, _y} -> {:start, x} end},
        "v" => {6, "v", fn {x, _y} -> {x, :start} end},
        ">" => {5, ">", fn {_x, y} -> {:start, y} end},
        "<" => {1, ">", fn {_x, y} -> {{-1, y}, :start} end},
        "range" => {{0, 1}, {2, 3}}
      },
      5 => %{
        "^" => {3, "^", fn {x, _y} -> {x, :end} end},
        "v" => {6, "<", fn {x, _y} -> {:end, x} end},
        ">" => {2, "<", fn {_x, y} -> {:end, {-1, y}} end},
        "<" => {4, "<", fn {_x, y} -> {:end, y} end},
        "range" => {{1, 2}, {2, 3}}
      },
      6 => %{
        "^" => {4, "^", fn {x, _y} -> {x, :end} end},
        "v" => {2, "v", fn {x, _y} -> {x, :start} end},
        ">" => {5, "^", fn {_x, y} -> {y, :end} end},
        "<" => {1, "v", fn {_x, y} -> {y, :start} end},
        "range" => {{0, 1}, {3, 4}}
      }
    }
  end
end
