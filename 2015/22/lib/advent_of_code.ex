defmodule AdventOfCode do
  defmodule PartA do
    def start_fight(player_hp, player_mana, boss_hp, boss_damage) do
      state =
        %{
          turn: :player,
          player: %{
            hp: player_hp,
            mana: player_mana,
            armor: 0,
            mana_spent: 0,
            shield: 0,
            poison: 0,
            recharge: 0,
            history: []
          },
          boss: %{
            hp: boss_hp,
            damage: boss_damage
          }
        }

      fight([state])
    end

    def check_effect(state, spell) do
      turns = get_in(state, [:player, spell])

      case get_in(state, [:player, spell]) do
        0 -> state
        turns ->
          apply_effect(state, spell)
          |> put_in([:player, spell], turns - 1)
      end
    end

    def apply_effect(state, :shield) do
      put_in(state, [:player, :armor], 7)
    end
    def apply_effect(state, :poison) do
      hurt(state, :boss, 3)
    end
    def apply_effect(state, :recharge) do
      get_and_update_in(state, [:player, :mana], &{&1, &1 + 101}) |> elem(1)
    end

    def spend_mana(state, mana) do
      get_and_update_in(state, [:player, :mana], &{&1, &1 - mana})
      |> elem(1)
      |> get_and_update_in([:player, :mana_spent], &{&1, &1 + mana})
      |> elem(1)
    end

    def hurt(state, actor, damage) do
      get_and_update_in(state, [actor, :hp], &{&1, &1 - damage})
      |> elem(1)
    end

    def heal(state, hp) do
      get_and_update_in(state, [:player, :hp], &{&1, &1 + hp})
      |> elem(1)
    end

    def start_effect(state, effect, turns) do
      put_in(state, [:player, effect], turns)
    end

    def check_spell(state = %{}, spell), do: check_spell({state, []}, spell)
    def check_spell({state, next_states}, spell) do
      mana =
        case spell do
          :missile  -> 53
          :drain    -> 73
          :shield   -> 113
          :poison   -> 173
          :recharge -> 229
        end

      case get_in(state, [:player, :mana]) do
        pmana when pmana >= mana ->
          case (get_in(state, [:player, spell]) || 0) do
            0 ->
              next_state =
                add_spell(state, spell)
                |> spend_mana(mana)

              {state, next_states ++ [next_state]}
            _ ->
              {state, next_states}
          end
        _ -> {state, next_states}
      end
    end

    def check_effects(state) do
      state
      |> put_in([:player, :armor], 0)  # reset armor
      |> check_effect(:shield)
      |> check_effect(:recharge)
      |> check_effect(:poison)
    end

    def add_spell(state, :missile), do: state |> hurt(:boss, 4)
    def add_spell(state, :drain), do: state |> hurt(:boss, 2) |> heal(2)
    def add_spell(state, :shield), do: state |> start_effect(:shield, 6)
    def add_spell(state, :poison), do: state |> start_effect(:poison, 6)
    def add_spell(state, :recharge), do: state |> start_effect(:recharge, 5)

    defp fight(states, victory_states \\ [])
    defp fight([], victory_states), do: victory_states
    defp fight([state = %{player: %{mana_spent: mana_spent}, boss: %{hp: hp}} | rest], victory_states) when hp <= 0 do
      state
    end
    defp fight([state = %{player: %{hp: hp}} | rest], victory_states) when hp <= 0 do
      fight(rest, victory_states)
    end
    defp fight([state = %{turn: :player} | rest], victory_states) do
      {_, next_states} =
        state
        |> put_in([:turn], :boss)
        |> check_effects()
        |> check_spell(:missile)
        |> check_spell(:drain)
        |> check_spell(:shield)
        |> check_spell(:poison)
        |> check_spell(:recharge)

      fight(rest ++ next_states, victory_states)
    end
    defp fight([state = %{turn: :boss} | rest], victory_states) do
      after_effects_state =
        state
        |> put_in([:turn], :player)
        |> check_effects()

      next_state =
        case after_effects_state do
          s = %{boss: %{hp: hp}} when hp <= 0 -> s
          s -> s |> hurt(:player, get_in(s, [:boss, :damage]) - get_in(s, [:player, :armor]))
        end

      fight(rest ++ [next_state], victory_states)
    end

    def solve do
      start_fight(50, 500, 71, 10)
      |> IO.inspect
    end
  end

  defmodule PartB do
    def start_fight(player_hp, player_mana, boss_hp, boss_damage) do
      state =
        %{
          turn: :player,
          player: %{
            hp: player_hp,
            mana: player_mana,
            armor: 0,
            mana_spent: 0,
            shield: 0,
            poison: 0,
            recharge: 0,
            history: []
          },
          boss: %{
            hp: boss_hp,
            damage: boss_damage
          }
        }

      fight([state])
    end

    def check_effect(state, spell) do
      turns = get_in(state, [:player, spell])

      case get_in(state, [:player, spell]) do
        0 -> state
        turns ->
          apply_effect(state, spell)
          |> put_in([:player, spell], turns - 1)
      end
    end

    def apply_effect(state, :shield) do
      put_in(state, [:player, :armor], 7)
    end
    def apply_effect(state, :poison) do
      hurt(state, :boss, 3)
    end
    def apply_effect(state, :recharge) do
      get_and_update_in(state, [:player, :mana], &{&1, &1 + 101}) |> elem(1)
    end

    def spend_mana(state, mana) do
      get_and_update_in(state, [:player, :mana], &{&1, &1 - mana})
      |> elem(1)
      |> get_and_update_in([:player, :mana_spent], &{&1, &1 + mana})
      |> elem(1)
    end

    def hurt(state, actor, damage) do
      get_and_update_in(state, [actor, :hp], &{&1, &1 - damage})
      |> elem(1)
    end

    def heal(state, hp) do
      get_and_update_in(state, [:player, :hp], &{&1, &1 + hp})
      |> elem(1)
    end

    def start_effect(state, effect, turns) do
      put_in(state, [:player, effect], turns)
    end

    def check_spell(state = %{}, spell), do: check_spell({state, []}, spell)
    def check_spell({state, next_states}, spell) do
      mana =
        case spell do
          :missile  -> 53
          :drain    -> 73
          :shield   -> 113
          :poison   -> 173
          :recharge -> 229
        end

      case get_in(state, [:player, :mana]) do
        pmana when pmana >= mana ->
          case (get_in(state, [:player, spell]) || 0) do
            0 ->
              next_state =
                add_spell(state, spell)
                |> spend_mana(mana)

              {state, next_states ++ [next_state]}
            _ ->
              {state, next_states}
          end
        _ -> {state, next_states}
      end
    end

    def check_effects(state) do
      state
      |> put_in([:player, :armor], 0)  # reset armor
      |> check_effect(:shield)
      |> check_effect(:recharge)
      |> check_effect(:poison)
    end

    def add_spell(state, :missile), do: state |> hurt(:boss, 4)
    def add_spell(state, :drain), do: state |> hurt(:boss, 2) |> heal(2)
    def add_spell(state, :shield), do: state |> start_effect(:shield, 6)
    def add_spell(state, :poison), do: state |> start_effect(:poison, 6)
    def add_spell(state, :recharge), do: state |> start_effect(:recharge, 5)

    def start_fight(player_hp, player_mana, boss_hp, boss_damage) do
      state =
        %{
          turn: :player,
          player: %{
            hp: player_hp,
            mana: player_mana,
            armor: 0,
            mana_spent: 0,
            shield: 0,
            poison: 0,
            recharge: 0,
            history: []
          },
          boss: %{
            hp: boss_hp,
            damage: boss_damage
          }
        }

      fight([state])
    end

    def fight(states, victory_states \\ [])
    def fight([], victory_states), do: victory_states
    def fight([state = %{player: %{mana_spent: mana_spent}, boss: %{hp: hp}} | rest], victory_states) when hp <= 0 do
      state
    end
    def fight([state = %{player: %{hp: hp}} | rest], victory_states) when hp <= 0 do
      fight(rest, victory_states)
    end
    def fight([state = %{turn: :player} | rest], victory_states) do
      after_hit_state = state |> hurt(:player, 1)

      next_states =
        case after_hit_state do
          s = %{player: %{hp: hp}} when hp <= 0 -> [s]
          s ->
            s
            |> put_in([:turn], :boss)
            |> check_effects()
            |> check_spell(:missile)
            |> check_spell(:drain)
            |> check_spell(:shield)
            |> check_spell(:poison)
            |> check_spell(:recharge)
            |> elem(1)
        end

      fight(rest ++ next_states, victory_states)
    end
    def fight([state = %{turn: :boss} | rest], victory_states) do
      after_effects_state =
        state
        |> put_in([:turn], :player)
        |> check_effects()

      next_state =
        case after_effects_state do
          s = %{boss: %{hp: hp}} when hp <= 0 -> s
          s -> s |> hurt(:player, get_in(s, [:boss, :damage]) - get_in(s, [:player, :armor]))
        end

      fight(rest ++ [next_state], victory_states)
    end

    def solve do
      start_fight(50, 500, 71, 10)
      |> IO.inspect
    end
  end
end
