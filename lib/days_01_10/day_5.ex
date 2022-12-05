defmodule Day5 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> move_crates()
    |> get_top_crates()
  end

  # actual logic
  def move_crates({stacks, []}) do
    stacks
  end

  def move_crates({stacks, [[no, from, to] | instructions]}) do
    {moved_crates, leftover} = stacks |> Enum.at(from - 1) |> Enum.split(no)

    stacks =
      stacks
      |> Enum.with_index()
      |> Enum.map(fn {stack, index} ->
        case index do
          i when i == from - 1 -> leftover
          i when i == to - 1 -> (moved_crates |> Enum.reverse()) ++ stack
          _ -> stack
        end
      end)

    move_crates({stacks, instructions})
  end

  def get_top_crates(stacks) do
    stacks |> Enum.map(&Enum.at(&1, 0)) |> Enum.join("")
  end

  # helpers
  def get_data() do
    Api.get_input(5)
  end

  def parse_data(data) do
    [stacks, instructions] =
      data
      |> String.split("\n\n")

    stacks =
      stacks
      |> String.replace("    ", " [0]")
      |> String.replace([" ", "[", "]"], "")
      |> String.split("\n", trin: true)
      |> Enum.map(&(&1 |> String.split("", trim: true)))

    stacks =
      Enum.take(stacks, length(stacks) - 1)
      |> List.zip()
      |> Enum.map(fn row ->
        row
        |> Tuple.to_list()
        |> Enum.reject(&(&1 == "0"))
      end)

    instructions =
      instructions
      |> String.split(["\n", "move", "from", "to"], trim: true)
      |> Enum.map(&(&1 |> String.trim() |> String.to_integer()))
      |> Enum.chunk_every(3)

    {stacks, instructions}
  end
end
