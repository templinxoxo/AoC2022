defmodule Day20 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> decrypt_file()
  end

  def get_decryption_key(), do: 811_589_153

  def execute_part2() do
    get_data()
    |> parse_data()
    |> decrypt_file(10, get_decryption_key())
  end

  # actual logic
  def decrypt_file(file, repetitions \\ 1, decryption_key \\ 1) do
    file
    |> apply_decryption_key(decryption_key)
    |> add_init_positions()
    |> decrypt(repetitions)
    |> reorder()
    |> get_values_at_indexes([1000, 2000, 3000])
    |> Enum.sum()
  end

  def apply_decryption_key(file, decryption_key) do
    Enum.map(file, fn number -> decryption_key * number end)
  end

  def add_init_positions(file) do
    Enum.with_index(file)
  end

  def decrypt(file, 0) do
    file
  end

  def decrypt(file, repetitions) do
    file
    |> decrypt_at(0)
    |> decrypt(repetitions - 1)
  end

  def decrypt_at(file, number_index) when number_index >= length(file) do
    file
  end

  def decrypt_at(file, number_index) do
    current_index =
      Enum.find_index(file, fn
        {_number, index} -> index == number_index
        _number -> false
      end)

    {number, _} = Enum.at(file, current_index)

    new_index = get_new_index(number + current_index, length(file))

    file
    |> List.delete_at(current_index)
    |> List.insert_at(new_index, {number, number_index})
    |> decrypt_at(number_index + 1)
  end

  def get_new_index(0, _file_length) do
    -1
  end

  def get_new_index(new_index, file_length) when new_index <= 0 do
    Integer.mod(new_index, file_length - 1)
  end

  def get_new_index(new_index, file_length) when new_index >= file_length do
    Integer.mod(new_index, file_length - 1)
  end

  def get_new_index(new_index, file_length) do
    Integer.mod(new_index, file_length)
  end

  def reorder(file) do
    {before_zero, after_zero} = Enum.split_while(file, fn {number, _} -> number !== 0 end)

    after_zero ++ before_zero
  end

  def get_values_at_indexes(file, indexes) do
    indexes
    |> Enum.map(fn index ->
      relative_index = Integer.mod(index, length(file))

      Enum.at(file, relative_index) |> elem(0)
    end)
  end

  # helpers
  def get_data() do
    Api.get_input(20)
  end

  def parse_data(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer(&1))
  end
end
