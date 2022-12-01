defmodule Day1 do
  def execute_part1() do
    get_elf_calory_list()
    |> parse_calory_list()
    |> find_most_calory_inventory()
  end

  def find_most_calory_inventory(elves_inventories) do
    elves_inventories
    |> Enum.map(&Enum.sum(&1))
    |> Enum.max()
  end

  def get_elf_calory_list() do
    Api.get_input(1)
  end

  def parse_calory_list(elves_inventories_list) when is_binary(elves_inventories_list) do
    elves_inventories_list
    |> String.split("\n\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(fn elf_inventory ->
      elf_inventory
      |> String.split("\n")
      |> Enum.reject(&(&1 == ""))
      |> Enum.map(&String.to_integer(&1))
    end)
  end

  def parse_calory_list(_), do: [[]]
end
