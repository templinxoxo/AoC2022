defmodule Day13 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> find_in_order_packets()
    |> sum_ordered_packets()
  end

  def execute_part2() do
    get_data()
    |> parse_data()
    |> order_packets_with_dividers()
    |> multiply_divider_packets()
  end

  # actual logic
  def find_in_order_packets(packets) do
    packets
    |> Enum.with_index()
    |> Enum.map(fn {packets, index} -> {packets, index + 1} end)
    |> Enum.map(fn {[packet1, packet2], index} ->
      ordered = is_ordered?(packet1, packet2)

      {[packet1, packet2], index, ordered}
    end)
  end

  def sum_ordered_packets(packets) do
    packets
    |> Enum.filter(fn {_packets, _index, ordered} -> ordered end)
    |> Enum.map(fn {_packets, index, _ordered} -> index end)
    |> Enum.sum()
  end

  @divider_packets [
    [[2]],
    [[6]]
  ]

  def order_packets_with_dividers(packets) do
    packets
    |> Enum.flat_map(& &1)
    |> Enum.concat(@divider_packets)
    |> Enum.sort(&is_ordered?/2)
  end

  def multiply_divider_packets(packets) do
    packets
    |> Enum.with_index()
    |> Enum.map(fn {packets, index} -> {packets, index + 1} end)
    |> Enum.filter(&(elem(&1, 0) in @divider_packets))
    |> Enum.reduce(1, &(elem(&1, 1) * &2))
  end

  def is_ordered?(p1, p2) when is_integer(p1) and is_integer(p2) do
    cond do
      p1 == p2 -> :continue
      p1 > p2 -> false
      p1 < p2 -> true
    end
  end

  def is_ordered?([p1 | rest1], [p2 | rest2]) do
    case is_ordered?(p1, p2) do
      :continue -> is_ordered?(rest1, rest2)
      ordered -> ordered
    end
  end

  def is_ordered?([], []), do: :continue
  def is_ordered?([], [_ | _]), do: true
  def is_ordered?([_ | _], []), do: false

  def is_ordered?(p1, p2) when is_list(p1) and is_integer(p2), do: is_ordered?(p1, [p2])
  def is_ordered?(p1, p2) when is_integer(p1) and is_list(p2), do: is_ordered?([p1], p2)

  # helpers
  def get_data() do
    Day13.Data.call()
  end

  def parse_data(data) do
    data
    |> Enum.chunk_every(2)
  end
end
