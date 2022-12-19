defmodule Day19 do
  # execute methods
  def execute_part1() do
    get_data()
    |> parse_data()
    |> sum_blueprint_quality()
  end

  def execute_part2() do
    get_data()
    |> parse_data()
    |> product_of_top_three_blueprints()
  end

  # actual logic
  def sum_blueprint_quality(blueprints) do
    blueprints
    |> Enum.map(fn {blueprint_number, blueprint} ->
      blueprint
      |> get_building_order_for_max_geodes(24)
      |> List.first()
      |> get_blueprint_quality(blueprint_number)
    end)
    |> Enum.sum()
  end

  def product_of_top_three_blueprints(blueprints) do
    blueprints
    |> Enum.take(3)
    |> Enum.map(fn {_blueprint_number, blueprint} ->
      blueprint
      |> get_building_order_for_max_geodes(32)
      |> List.first()
      |> get_blueprint_geodes_total()
    end)
    |> Enum.reduce(&(&1 * &2))
  end

  def get_blueprint_geodes_total(
        {%{"geode" => geode_number}, %{"geode" => geode_robots_number}, moves_left, _history,
         _finished}
      ) do
    geode_number + geode_robots_number * moves_left
  end

  def get_blueprint_quality(
        robot_building_order,
        blueprint_number
      ) do
    get_blueprint_geodes_total(robot_building_order) * blueprint_number
  end

  @default_robots %{"ore" => 1, "clay" => 0, "obsidian" => 0, "geode" => 0}
  @materials ["ore", "clay", "obsidian", "geode"]
  @default_inventory %{"ore" => 0, "clay" => 0, "obsidian" => 0, "geode" => 0}

  def get_building_order_for_max_geodes(robot_blueprints, max_time) do
    build_next_geode_robot(
      [{@default_inventory, @default_robots, max_time, [], false}],
      robot_blueprints,
      max_time
    )
  end

  def build_next_geode_robot(robot_building_order, robot_blueprints, max_time) do
    build_next_robot(
      robot_building_order,
      robot_blueprints,
      max_time
    )
    |> Enum.map(fn {inventory, current_robots, moves_left, history, true} ->
      {inventory, current_robots, moves_left, history, false}
    end)
    |> case do
      [] ->
        IO.inspect("finished")
        robot_building_order

      new_robot_building_order ->
        build_next_geode_robot(new_robot_building_order, robot_blueprints, max_time)
    end
  end

  def build_next_robot(robot_building_order, robot_blueprints, max_time) do
    {finished_moves, in_progress_moves} =
      Enum.split_with(robot_building_order, fn
        {_inventory, _robots, _moves_left, _history, finished} -> finished
      end)

    case in_progress_moves do
      [] ->
        finished_moves

      in_progress_moves ->
        in_progress_moves
        |> Enum.flat_map(fn {inventory, current_robots, moves_left, history, _} ->
          robot_blueprints
          |> get_next_available_robots(current_robots)
          |> Enum.map(fn robot_blueprint ->
            {new_inventory, new_robots, moves_left, move} =
              build_robot(robot_blueprint, current_robots, inventory, moves_left, max_time)

            finished = move |> elem(1) == "geode"

            {new_inventory, new_robots, moves_left, history ++ [move], finished}
          end)
        end)
        |> Enum.concat(finished_moves)
        |> remove_too_long_paths()
        |> remove_non_optimal_paths()
        |> build_next_robot(robot_blueprints, max_time)
    end
  end

  def remove_too_long_paths(robot_building_order) do
    Enum.reject(robot_building_order, fn {_inventory, _robots, moves_left, _history, _finished} ->
      moves_left < 0
    end)
  end

  def remove_non_optimal_paths(robot_building_order) do
    robot_building_order
    |> Enum.filter(fn {_inventory, _robots, _moves_left, _history, finished} -> finished end)
    |> Enum.map(fn {_inventory, _robots, moves_left, _history, _finished} -> moves_left end)
    |> case do
      [] ->
        robot_building_order

      moves ->
        current_best_moves_left = Enum.max(moves)

        Enum.reject(robot_building_order, fn
          {_inventory, _robots, moves_left, _history, true} ->
            moves_left < current_best_moves_left

          {_inventory, _robots, moves_left, _history, false} ->
            moves_left <= current_best_moves_left
        end)
    end
  end

  def get_next_available_robots(robot_blueprints, robot_inventory) do
    robot_blueprints
    |> Enum.filter(fn {_material, cost} ->
      cost
      |> Enum.map(fn {material, _value} ->
        material
      end)
      |> Enum.all?(&(Map.get(robot_inventory, &1) > 0))
    end)
  end

  def build_robot(
        {robot_material, cost_list},
        current_robots,
        current_inventory,
        moves_left,
        max_time
      ) do
    min_time_until_can_build =
      cost_list
      |> Enum.map(fn {material, cost} ->
        material_needed = max(cost - Map.get(current_inventory, material), 0)

        ceil(material_needed / Map.get(current_robots, material))
      end)
      |> Enum.max()

    min_time_until_robot_is_built = min_time_until_can_build + 1

    cost_map = Map.new(cost_list)

    new_inventory =
      @materials
      |> Enum.map(fn material ->
        material_increase = Map.get(current_robots, material) * min_time_until_robot_is_built
        material_inventory = Map.get(current_inventory, material)
        material_cost = Map.get(cost_map, material, 0)

        {material, material_increase + material_inventory - material_cost}
      end)
      |> Map.new()

    new_robots =
      current_robots
      |> Enum.map(fn {material, number} ->
        new_number = if material == robot_material, do: number + 1, else: number
        {material, new_number}
      end)
      |> Map.new()

    moves_after_building = moves_left - min_time_until_robot_is_built

    {
      new_inventory,
      new_robots,
      moves_after_building,
      {max_time - moves_after_building, robot_material}
    }
  end

  # helpers
  def get_data() do
    Api.get_input(19)
  end

  def parse_data(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn blueprint ->
      [blueprint_number | robots_blueprint] =
        String.split(
          blueprint,
          [
            "Blueprint ",
            ": ",
            ".",
            ". "
          ],
          trim: true
        )

      serialized_blueprint =
        robots_blueprint
        |> Enum.map(fn robot_blueprint ->
          [robot | cost_blueprint] =
            String.split(robot_blueprint, ["Each ", " robot costs ", " and ", ". "], trim: true)

          creation_cost =
            cost_blueprint
            |> Enum.map(fn material_cost ->
              [cost, material] = String.split(material_cost, " ", trim: true)
              {material, String.to_integer(cost)}
            end)

          {robot, creation_cost}
        end)

      {String.to_integer(blueprint_number), serialized_blueprint}
    end)
  end
end
