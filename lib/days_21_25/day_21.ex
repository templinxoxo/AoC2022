defmodule Day21 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> find_root_value()
  end

  # actual logic
  def find_root_value(calculations) do
    calculations
    |> get_calculation_order()
    |> calculate(calculations)
    |> Map.get("root")
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
        calculate_element(operation, elements, calculations)

      value ->
        value
    end
  end

  def calculate_element("+", elements, calculations) do
    elements |> Enum.map(&get_value(calculations, &1)) |> Enum.sum()
  end

  def calculate_element("-", elements, calculations) do
    elements |> Enum.map(&get_value(calculations, &1)) |> Enum.reduce(&(&2 - &1))
  end

  def calculate_element("*", elements, calculations) do
    elements |> Enum.map(&get_value(calculations, &1)) |> Enum.reduce(&(&1 * &2))
  end

  def calculate_element("/", elements, calculations) do
    elements |> Enum.map(&get_value(calculations, &1)) |> Enum.reduce(&(&2 / &1)) |> round()
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
