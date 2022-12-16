defmodule Day16 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> calculate_max_released_pressure()
  end

  # actual logic
  def calculate_max_released_pressure(nodes) do
    go_to_next_most_value_node("AA", nodes, 30)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def go_to_next_most_value_node(node, visited_nodes \\ [], nodes, time_left) do
    visited = Enum.map(visited_nodes, &elem(&1, 0))

    find_tree_paths(node, nodes, time_left)
    |> Enum.reject(fn
      [] -> true
      path -> List.last(path) in visited
    end)
    |> Enum.map(fn path ->
      node = List.last(path)
      {value, _} = Map.get(nodes, node)

      time_left_after_path = time_left - length(path)

      {time_left_after_path * value, time_left_after_path, node}
    end)
    |> Enum.sort_by(&elem(&1, 0), :desc)
    |> case do
      [] ->
        visited_nodes

      [{0, _, _} | _] ->
        visited_nodes

      [{value, time_left, node} | _] ->
        go_to_next_most_value_node(node, visited_nodes ++ [{node, value}], nodes, time_left)
    end
  end

  def find_tree_paths(node, nodes, time_left) when is_binary(node) do
    find_tree_paths([[node]], [], nodes, time_left)
  end

  def find_tree_paths([], finished_paths, _nodes, _time_left) do
    finished_paths
  end

  def find_tree_paths(paths, finished_paths, nodes, time_left) do
    visited_nodes =
      (paths ++ finished_paths)
      |> List.flatten()
      |> Enum.uniq()

    [current_path | other_paths] = paths

    current_node =
      current_path
      |> List.last()

    next_steps =
      nodes
      |> Map.get(current_node)
      |> elem(1)
      |> Enum.reject(fn node -> node in visited_nodes end)

    if next_steps == [] or time_left - length(current_path) < 2 do
      find_tree_paths(other_paths, finished_paths, nodes, time_left)
    else
      new_paths = Enum.map(next_steps, &(current_path ++ [&1]))

      new_paths
      |> Enum.concat(other_paths)
      |> Enum.sort_by(&length(&1), :asc)
      |> find_tree_paths(finished_paths ++ new_paths, nodes, time_left)
    end
  end

  # helpers
  def get_data() do
    Api.get_input(16)
  end

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
        {String.to_integer(value), Enum.map(neighbors, &String.trim(&1))}
      }
    end)
    |> Map.new()
    |> IO.inspect()
  end
end
