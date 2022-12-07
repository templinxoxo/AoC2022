defmodule Day7 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> map_file_structure()
    |> find_10kb_directories()
  end

  def execute_part2() do
    get_data()
    |> parse_data()
    |> map_file_structure()
    |> free_up_space()
  end

  # actual logic
  def map_file_structure(commands, structure \\ [{[], "/", :dir}], current_dir \\ [])

  def map_file_structure(["$ cd .." | commands], structure, current_dir) do
    {new_dir, _} = Enum.split(current_dir, -1)
    map_file_structure(commands, structure, new_dir)
  end

  def map_file_structure(["$ cd " <> path | commands], structure, current_dir) do
    new_dir = current_dir ++ [path]
    map_file_structure(commands, structure, new_dir)
  end

  def map_file_structure(["$ ls" | commands], structure, current_dir) do
    map_file_structure(commands, structure, current_dir)
  end

  def map_file_structure(["dir " <> dir | commands], structure, current_dir) do
    map_file_structure(commands, structure ++ [{current_dir, dir, :dir}], current_dir)
  end

  def map_file_structure([file | commands], structure, current_dir) do
    [size, name] = String.split(file, " ", trim: true)

    map_file_structure(
      commands,
      structure ++ [{current_dir, name, String.to_integer(size)}],
      current_dir
    )
  end

  def map_file_structure([], structure, _current_dir) do
    structure
    |> Enum.group_by(&elem(&1, 0))
    |> to_file_tree()
  end

  def to_file_tree(grouped_files, path \\ [])

  def to_file_tree(grouped_files, path) do
    grouped_files
    |> Map.get(path)
    |> Enum.map(fn
      {path, name, :dir} ->
        content = to_file_tree(grouped_files, path ++ [name])
        size = content |> Enum.map(&elem(&1, 1)) |> Enum.sum()
        {name, size, content}

      {_path, name, size} ->
        {name, size}
    end)
  end

  def find_10kb_directories(file_tree) do
    file_tree
    |> get_nested_directories()
    |> Enum.map(fn {_dir, size} -> size end)
    |> Enum.filter(&(&1 <= 100_000))
    |> Enum.sum()
  end

  def free_up_space(file_tree) do
    {"/", total_size, _} = file_tree |> List.first()

    needed_space = 30_000_000 - (70_000_000 - total_size)

    file_tree
    |> get_nested_directories()
    |> Enum.map(fn {_dir, size} -> size end)
    |> Enum.sort(:asc)
    |> Enum.find(&(&1 >= needed_space))
  end

  def get_nested_directories(file_tree) do
    file_tree
    |> Enum.flat_map(fn
      {name, size, files} ->
        [{name, size}] ++ get_nested_directories(files)

      _ ->
        []
    end)
  end

  # helpers
  def get_data() do
    Api.get_input(7)
  end

  def parse_data(data) do
    data
    |> String.split("\n", trim: true)
  end
end
