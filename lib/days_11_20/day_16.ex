defmodule Day16 do
  import Day16.FindPaths

  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> calculate_max_released_pressure()
  end

  # actual logic
  def calculate_max_released_pressure(nodes) do
    working_nodes_map = get_path_cost_between_working_valve_nodes(nodes)
    time = 30

    [[{"AA", 0}]]
    |> get_all_paths([], working_nodes_map, time)
    |> Enum.map(fn path -> calculate_released_pressure(path, nodes, time) end)
    |> Enum.max()
  end

  @spec get_all_paths(
          List.t(List.t(Day16.FindPaths.valve_node())),
          List.t(List.t(Day16.FindPaths.valve_node())),
          Day16.FindPaths.node_map(),
          Integer.t()
        ) :: List.t(List.t(Day16.FindPaths.valve_node()))

  def get_all_paths([], finished_paths, _nodes, _max_cost) do
    finished_paths
  end

  def get_all_paths([path | paths], finished_paths, nodes, max_cost) do
    path_nodes = path |> Enum.map(fn {node, _} -> node end)
    {current_node, _} = List.last(path)
    current_cost = path_cost(path)

    {_value, neighbors} = Map.get(nodes, current_node)

    neighbors
    |> Enum.reject(fn {node, cost} -> node in path_nodes or cost + current_cost > max_cost end)
    |> Enum.map(fn node -> path ++ [node] end)
    |> case do
      [] -> get_all_paths(paths, finished_paths ++ [path], nodes, max_cost)
      new_paths -> get_all_paths(paths ++ new_paths, finished_paths ++ [path], nodes, max_cost)
    end
  end

  @spec calculate_released_pressure(
          List.t(Day16.FindPaths.valve_node()),
          Day16.FindPaths.node_map(),
          Integer.t()
        ) :: Integer.t()
  def calculate_released_pressure(path, nodes, total_time) do
    {pressure, _} =
      path
      |> Enum.reduce({0, total_time}, fn {node, move_time},
                                         {total_pressure_released, start_time} ->
        time_left = start_time - move_time
        {pressure_flow, _} = Map.get(nodes, node)
        node_pressure_released = time_left * pressure_flow

        {total_pressure_released + node_pressure_released, time_left}
      end)

    pressure
  end

  # helpers
  def get_data() do
    Api.get_input(16)
  end

  @spec parse_data(binary) :: Day16.FindPaths.node_map()
  def parse_data(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn valve ->
      [node, value | neighbors] =
        valve
        |> String.replace("Valve ", "")
        |> String.replace(
          [" has flow rate=", "; tunnel leads to valve ", "; tunnels lead to valves "],
          ","
        )
        |> String.split(",", trim: true)

      {
        node,
        {String.to_integer(value), Enum.map(neighbors, &{String.trim(&1), 1})}
      }
    end)
    |> Map.new()
  end
end
