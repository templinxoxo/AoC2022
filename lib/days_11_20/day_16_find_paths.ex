defmodule Day16.FindPaths do
  # types

  # node_map :: %{[nodeName]: nove_value}
  @type node_map :: %{
          required(String.t()) => node_value
        }
  # nodeValues :: {valve_flow_rate neighbor_node_list}
  @type node_value :: {
          Integer.t(),
          List.t(valve_node)
        }
  # valve_node :: {nodeName, cost_of_movement}
  @type valve_node :: {String.t(), Integer.t()}

  # find shortest paths between nodes
  @spec find_tree_paths(
          String.t(),
          node_map,
          Integer.t()
        ) :: any
  def find_tree_paths(node, nodes, max_cost)

  def find_tree_paths(node, nodes, max_cost) when is_binary(node) do
    find_tree_paths([[{node, 0}]], [], nodes, max_cost)
  end

  @spec find_tree_paths(
          List.t(List.t(valve_node)),
          List.t(List.t(valve_node)),
          node_map,
          Integer.t()
        ) :: any
  def find_tree_paths(current_paths, finished_paths, nodes, max_cost)

  def find_tree_paths([], finished_paths, _nodes, _max_cost) do
    finished_paths
  end

  def find_tree_paths(paths, finished_paths, nodes, max_cost) do
    visited_nodes =
      (paths ++ finished_paths)
      |> List.flatten()
      |> Enum.map(&elem(&1, 0))
      |> Enum.uniq()

    [current_path | other_paths] = paths

    {current_node, _} =
      current_path
      |> List.last()

    # get unvisited nodes
    nodes
    |> Map.get(current_node)
    |> elem(1)
    |> Enum.reject(fn {node, _cost} -> node in visited_nodes end)
    # create new paths
    |> Enum.map(&(current_path ++ [&1]))
    # filter out paths longer than max_cost
    |> Enum.filter(fn path ->
      path_cost(path) <= max_cost
    end)
    |> case do
      [] ->
        find_tree_paths(other_paths, finished_paths, nodes, max_cost)

      new_paths ->
        new_paths
        |> Enum.concat(other_paths)
        |> Enum.sort_by(&path_cost/1, :asc)
        |> find_tree_paths(finished_paths ++ new_paths, nodes, max_cost)
    end
  end

  @spec path_cost(List.t(valve_node)) :: number
  def path_cost(path), do: path |> Enum.map(&elem(&1, 1)) |> Enum.sum()

  @spec get_path_cost_between_working_valve_nodes(node_map) :: node_map
  def get_path_cost_between_working_valve_nodes(nodes) do
    # get all nodes with working valves
    working_valve_nodes =
      nodes
      |> Enum.filter(fn {_node, {value, _}} ->
        value > 0
      end)
      |> Enum.map(fn {node, _} -> node end)

    working_valve_nodes
    # also include path from starting node to all working nodes
    |> Enum.concat(["AA"])
    |> Enum.map(fn node ->
      # find paths from working nodes within 30 steps
      # and filter them to only show 'cost' of going between working nodes
      paths =
        find_tree_paths(node, nodes, 30)
        |> Enum.filter(fn
          [] ->
            false

          path ->
            {node_name, _} = List.last(path)
            node_name in working_valve_nodes
        end)
        |> Enum.map(fn path ->
          {node_name, _} = List.last(path)

          # add 1 to cost to compensate for 1 unit of time needed to open valve
          {node_name, path_cost(path) + 1}
        end)

      {value, _} = Map.get(nodes, node)

      {node, {value, paths}}
    end)
    |> Map.new()
  end
end
