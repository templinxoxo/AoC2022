defmodule Day3 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> find_duplicated_items_weight()
  end

  def execute_part2() do
    get_data()
    |> parse_data()
    |> find_groups_badges_priority()
  end

  # actual logic
  def find_duplicated_items_weight(rucksacks) do
    rucksacks
    |> Enum.flat_map(fn rucksack ->
      rucksack
      |> get_compartments_items()
      |> get_common_items()
      |> get_priorities()
    end)
    |> Enum.sum()
  end

  def find_groups_badges_priority(rucksacks) do
    rucksacks
    |> Enum.map(&String.to_charlist(&1))
    |> Enum.chunk_every(3)
    |> Enum.flat_map(fn group ->
      group
      |> get_group_badge()
      |> get_priorities()
    end)
    |> Enum.sum()
  end

  def get_compartments_items(rucksack) do
    items = String.to_charlist(rucksack)

    Enum.split(items, round(length(items) / 2))
  end

  def get_common_items(compartments),
    do:
      MapSet.intersection(
        MapSet.new(elem(compartments, 0)),
        MapSet.new(elem(compartments, 1))
      )

  def get_group_badge([elf1, elf2, elf3]),
    do: {get_common_items({elf1, elf2})} |> Tuple.append(elf3) |> get_common_items()

  def get_priorities(duplicated_items), do: duplicated_items |> Enum.map(&item_priority(&1))

  def item_priority(item) when item > 96, do: item - 96

  def item_priority(item), do: item - 64 + 26

  # helpers
  def get_data() do
    Api.get_input(3)
  end

  def parse_data(data) do
    data
    |> String.split("\n", trim: true)
  end
end
