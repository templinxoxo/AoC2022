defmodule Day12 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> get_edges()
    |> dijkstra()
    |> draw()
  end

  # actual logic
  def dijkstra({edges, matrix}) do
    unvisited_nodes = matrix |> List.flatten() |> Enum.map(fn node -> {node, :infinity} end)

    {starting_node, _} = unvisited_nodes |> Enum.find(fn {{node, _, _}, _} -> node == "S" end)

    {cost, history} = dijkstra([{starting_node, 0, []}], unvisited_nodes, [], edges)
    {cost, history, matrix}
  end

  def dijkstra(
        [{{"E", _, _}, cost, history} | _],
        _unvisited_nodes,
        _visited_nodes,
        _edges
      ) do
    {cost, history}
  end

  def dijkstra(
        [{current_node, current_cost, history} | other_nodes],
        unvisited_nodes,
        visited_nodes,
        edges
      ) do
    IO.inspect({current_node, current_cost})
    history = history ++ [current_node]

    next_steps =
      current_node
      |> get_node_neighbors(edges)
      |> get_node_current_cost(unvisited_nodes, visited_nodes)
      |> get_new_node_cost(current_cost, history)
      |> Enum.concat(other_nodes)
      |> sort_and_dedup_by_node_cost()

    unvisited_nodes =
      unvisited_nodes
      |> Enum.reject(fn {node, _cost} -> node == current_node end)

    visited_nodes =
      visited_nodes
      |> Enum.concat([{current_node, current_cost}])
      |> sort_and_dedup_by_node_cost()

    dijkstra(next_steps, unvisited_nodes, visited_nodes, edges)
  end

  def get_node_neighbors(current_node, edges),
    do:
      edges
      |> Enum.filter(fn
        [edge, _] when edge == current_node -> true
        _ -> false
      end)
      |> Enum.map(fn [_, node] -> node end)

  def get_node_current_cost(nodes, visited_nodes, unvisited_nodes) when is_list(nodes),
    do:
      visited_nodes
      |> Enum.concat(unvisited_nodes)
      |> sort_and_dedup_by_node_cost()
      |> Enum.filter(fn {node, _cost} -> node in nodes end)

  def get_new_node_cost(nodes, current_cost, history),
    do:
      nodes
      |> Enum.map(fn {node, cost} ->
        if current_cost + 1 < cost do
          {node, current_cost + 1, history}
        else
          nil
        end
      end)
      |> Enum.reject(&is_nil(&1))

  # helpers
  def draw({cost, history, matrix}) do
    matrix
    |> Enum.each(fn row ->
      row
      |> Enum.map(fn node ->
        if node in history do
          "*"
        else
          elem(node, 0)
        end
      end)
      |> Enum.join("")
      |> IO.puts()
    end)

    cost
  end

  def get_edges(matrix) do
    row_edges = get_row_edges(matrix)

    col_edges =
      matrix
      |> transpose()
      |> get_row_edges()

    {
      row_edges ++ col_edges,
      matrix
    }
  end

  def sort_and_dedup_by_node_cost(list) do
    list
    |> Enum.sort_by(&elem(&1, 1), :asc)
    |> Enum.uniq_by(&elem(&1, 0))
  end

  def transpose(matrix) do
    matrix
    |> List.zip()
    |> Enum.map(&Tuple.to_list(&1))
  end

  def get_row_edges(matrix_graph) do
    matrix_graph
    |> Enum.flat_map(fn row ->
      row
      |> Enum.reverse()
      |> Enum.concat(row)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.filter(&can_climb?(&1))
    end)
  end

  def get_data() do
    Api.get_input(12)
  end

  def parse_data(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {row, y} ->
      row
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {node, x} ->
        {node, x, y}
      end)
    end)
  end

  def can_climb?([{"S", _, _}, {p2, _, _}]), do: p2 in ["a", "b"]
  def can_climb?([{p1, _, _}, {"E", _, _}]), do: p1 in ["y", "z"]
  def can_climb?([_, {"E", _, _}]), do: false
  def can_climb?([_, {"S", _, _}]), do: false
  def can_climb?([{<<p1>>, _, _}, {<<p2>>, _, _}]), do: p2 - p1 <= 1
end
