defmodule Day25 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> calculate_fuel_sum()
  end

  # actual logic
  def calculate_fuel_sum(numbers) do
    numbers
    |> Enum.map(fn number ->
      convert_number(number, 0)
    end)
    |> Enum.sum()
    |> convert_number()
  end

  def convert_number("", current_value) do
    current_value
  end

  def convert_number(number, current_value) when is_binary(number) do
    current_digit = String.first(number)
    number_len = String.length(number) - 1

    multiplier = get_multiplier(current_digit)
    base_value = :math.pow(5, number_len) |> round()

    digit_value = multiplier * base_value
    new_number = String.slice(number, 1, number_len)

    convert_number(new_number, current_value + digit_value)
  end

  def convert_number(number) when is_integer(number) do
    powers_base = get_5_power_base(number, [1])

    solve_for_SNAFU(number, powers_base, "")
  end

  def get_multiplier("2"), do: 2
  def get_multiplier("1"), do: 1
  def get_multiplier("0"), do: 0
  def get_multiplier("-"), do: -1
  def get_multiplier("="), do: -2
  def get_SNAFU(2), do: "2"
  def get_SNAFU(1), do: "1"
  def get_SNAFU(0), do: "0"
  def get_SNAFU(-1), do: "-"
  def get_SNAFU(-2), do: "="

  def get_5_power_base(number, powers) do
    max_powers_number = powers |> Enum.map(&(&1 * 2)) |> Enum.sum()

    if max_powers_number >= number do
      powers
    else
      last_value = List.first(powers)
      get_5_power_base(number, [last_value * 5] ++ powers)
    end
  end

  def solve_for_SNAFU(0, [], snafu_number) do
    snafu_number
  end

  def solve_for_SNAFU(number, [current_power | powers], snafu_number) do
    powers_max_val_range = powers |> Enum.map(&(&1 * 2)) |> Enum.sum()

    current_multiplier =
      Enum.find(2..-2, fn multiplier ->
        current_power * multiplier + powers_max_val_range >= number and
          current_power * multiplier - powers_max_val_range <= number
      end)

    new_snafu_digit = get_SNAFU(current_multiplier)

    solve_for_SNAFU(
      number - current_power * current_multiplier,
      powers,
      "#{snafu_number}#{new_snafu_digit}"
    )
  end

  # helpers
  def get_data() do
    Api.get_input(25)
  end

  def parse_data(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn yyy ->
      yyy
    end)
  end
end
