defmodule Day21 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> find_root_value()
  end

  def execute_part2() do
    get_data()
    |> parse_data()
    |> find_human_input()
  end

  # actual logic
  def find_root_value(calculations) do
    calculations
    |> get_calculation_order()
    |> calculate(calculations)
    |> Map.get("root")
  end

  def find_human_input(calculations) do
    {_, root_elements} = Map.get(calculations, "root")

    calculations =
      calculations
      |> Map.put("humn", :x)
      |> Map.put("root", {"=", root_elements})

    human_input =
      calculations
      |> get_calculation_order()
      |> calculate(calculations)
      |> Map.get("root")
      |> reverse_calculations()

    calculations =
      calculations
      |> Map.put("humn", human_input)

    calculations
    |> get_calculation_order()
    |> calculate(calculations)
    |> Map.get("root")
    |> case do
      {left, right} when left == right ->
        human_input

      _ ->
        :error
    end
  end

  def get_calculation_order(calculations, elements_to_add \\ ["root"], calculation_order \\ [])

  def get_calculation_order(_calculations, [], calculation_order) do
    Enum.reverse(calculation_order)
  end

  def get_calculation_order(calculations, elements_to_add, calculation_order) do
    next_elements =
      elements_to_add
      |> Enum.flat_map(fn element ->
        case Map.get(calculations, element) do
          {_operation, elements} -> elements
          _value -> []
        end
      end)

    get_calculation_order(calculations, next_elements, calculation_order ++ elements_to_add)
  end

  def calculate(calculation_order, initial_calculations) do
    calculation_order
    |> Enum.reduce(initial_calculations, fn element, calculations ->
      value = get_value(calculations, element)

      Map.put(calculations, element, value)
    end)
  end

  def get_value(calculations, element) do
    Map.get(calculations, element)
    |> case do
      {operation, elements} ->
        elements
        |> Enum.map(&get_value(calculations, &1))
        |> calculate_operation(operation)

      value ->
        value
    end
  end

  def calculate_operation([e1, e2], "+")
      when is_integer(e1) and is_integer(e2),
      do: e1 + e2

  def calculate_operation([e1, e2], "-")
      when is_integer(e1) and is_integer(e2),
      do: e1 - e2

  def calculate_operation([e1, e2], "*")
      when is_integer(e1) and is_integer(e2),
      do: e1 * e2

  def calculate_operation([e1, e2], "/")
      when is_integer(e1) and is_integer(e2),
      do: round(e1 / e2)

  def calculate_operation([e1, e2], "="),
    do: {e1, e2}

  def calculate_operation(elements, operation),
    do: [operation, elements]

  def reverse_calculations({:x, result}) do
    result
  end

  def reverse_calculations({[operation, elements], result}) do
    {[number], [unknown]} = Enum.split_with(elements, &is_integer(&1))

    new_result =
      case {operation, elements} do
        {"+", _} ->
          result - number

        {"*", _} ->
          round(result / number)

        {"-", [_, n]} when n == number ->
          result + number

        {"-", [n, _]} when n == number ->
          -(result - number)

        {"/", [_, n]} when n == number ->
          number * result

        {"/", [n, _]} when n == number ->
          round(number / result)

        _ ->
          IO.inspect("hodor")
          [number, result]
      end

    reverse_calculations({unknown, new_result})
  end

  # helpers
  def get_data() do
    Api.get_input(21)
  end

  def parse_data(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn calculation ->
      calculation
      |> String.split([": ", " "])
      |> case do
        [name, value] ->
          {name, String.to_integer(value)}

        [name, variable1, operation, variable2] ->
          {name, {operation, [variable1, variable2]}}
      end
    end)
    |> Map.new()
  end
end
