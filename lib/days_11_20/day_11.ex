defmodule Day11 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_monkey_notes()
    |> get_throws_in_time(20)
    |> count_monkey_business()
  end

  def execute_part2() do
    get_data()
    |> parse_monkey_notes()
    |> get_throws_in_time(10_000)
    |> count_monkey_business()
  end

  # actual logic
  def count_monkey_business(throws_history) do
    [{_monkey1, monkey1_score}, {_monkey2, monkey2_score}] =
      throws_history
      |> Enum.group_by(&elem(&1, 0))
      |> Enum.map(fn {number, throws} -> {number, length(throws)} end)
      |> Enum.sort_by(&elem(&1, 1), :desc)
      |> IO.inspect()
      |> Enum.take(2)

    monkey1_score * monkey2_score
  end

  def get_throws_in_time({monkeys, items}, rounds, worry_divider \\ 1) do
    monkey_coprime_numbers_cycle = get_monkey_coprime_numbers_cycle(monkeys)

    {_, throws_history} =
      1..rounds
      |> Enum.reduce({items, []}, fn _round, {round_items, history} ->
        {next_round_items, round_history} =
          throw_during_single_round(
            round_items,
            monkeys,
            worry_divider,
            monkey_coprime_numbers_cycle
          )

        {
          next_round_items,
          history ++ round_history
        }
      end)

    throws_history
  end

  def throw_during_single_round(round_items, monkeys, worry_divider, monkey_coprime_numbers_cycle) do
    monkeys
    |> Enum.reduce({round_items, []}, fn monkey, {items, history} ->
      {current_monkey_items, other_items} = Enum.split_with(items, &(elem(&1, 0) == monkey.index))

      thrown_items =
        current_monkey_items
        |> Enum.map(&throw_item(&1, monkey, worry_divider))
        |> Enum.map(fn item -> fit_in_coprime_number_cycle(item, monkey_coprime_numbers_cycle) end)

      {other_items ++ thrown_items, history ++ current_monkey_items}
    end)
  end

  def throw_item({_, item}, monkey, worry_divider) do
    new_worry = floor(calculate_worry(item, monkey.operation) / worry_divider)

    if rem(new_worry, monkey.test) == 0 do
      {monkey.if_true, new_worry}
    else
      {monkey.if_false, new_worry}
    end
  end

  def fit_in_coprime_number_cycle({monkey, item}, monkey_coprime_numbers_cycle),
    do: {monkey, Integer.mod(item, monkey_coprime_numbers_cycle)}

  def get_monkey_coprime_numbers_cycle(monkeys) do
    Enum.reduce(monkeys, 1, fn %{test: test}, cycle -> cycle * test end)
  end

  def calculate_worry(item, "* old"), do: item * item
  def calculate_worry(item, "* " <> multiplier), do: item * String.to_integer(multiplier)
  def calculate_worry(item, "+ " <> value), do: item + String.to_integer(value)

  # helpers
  def get_data() do
    Api.get_input(11)
  end

  def parse_monkey_notes(data) do
    monkey_notes =
      data
      |> String.split("\n\n", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {monkey, index} ->
        {items, operation, test, mokey_true, mokey_false} = get_monkey_details(monkey)

        %{
          items: [
            items
            |> String.split(",", trim: true)
            |> Enum.map(&{index, &1 |> String.trim() |> String.to_integer()})
          ],
          monkey: %{
            index: index,
            operation: operation,
            test: String.to_integer(test),
            if_true: String.to_integer(mokey_true),
            if_false: String.to_integer(mokey_false)
          }
        }
      end)

    items = monkey_notes |> Enum.map(& &1.items) |> List.flatten()
    monkeys = monkey_notes |> Enum.map(& &1.monkey) |> Enum.sort_by(& &1.index, :asc)
    {monkeys, items}
  end

  def get_monkey_details(monkey) do
    [
      _,
      "Starting items:" <> items,
      "Operation: new = old " <> operation,
      "Test: divisible by " <> test,
      "If true: throw to monkey " <> mokey_true,
      "If false: throw to monkey " <> mokey_false
    ] = monkey |> String.split("\n", trim: true) |> Enum.map(&String.trim(&1))

    {items, operation, test, mokey_true, mokey_false}
  end
end
