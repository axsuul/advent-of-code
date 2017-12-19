require 'pry'

queue = [];
queue << {
  player: { hp: 10, armor: 0, mana: 250, effects: {} },
  boss:   { hp: 13, effects: {} },
  moves: []
}

turn = :player
wins = []

def cloneState(state)
  Marshal.load(Marshal.dump(state))
end

def add_effect(state, target, spell, duration)
  return state if state[target][:effects][spell]

  state[target][:effects][spell] = duration

  state
end

# BFS
while (state = queue.shift())
  move = state[:moves].last

  if move
    # Effects
    [:player, :boss].each do |target|
      state[target][:effects].keys.each do |effect|
        state[target][:effects][effect] -= 1

        case effect
        when :recharge
          state[target][:mana] += 101
        when :poison
          state[target][:hp] -= 3
        when :shield
          state[target][:armor] = 7
        end

        if state[target][:effects][effect] < 0
          state[target][:effects].delete(effect)

          state[target][:armor] = 0 if effect == :shield
        end
      end
    end

    # Actions
    actor = move[:actor]
    target = (actor == :player ? :boss : :player)

    case move[:action]
    when :attack
      state[target][:hp] -= (8 - state[target][:armor])
    when :magic_missile
      state[actor][:mana] -= 53
      state[target][:hp]  -= 4
    when :drain
      state[actor][:mana] -= 73
      state[actor][:hp]   += 2
      state[target][:hp]  -= 2
    when :shield
      state[actor][:mana] -= 113
      add_effect(state, actor, :shield, 6)
    when :poison
      state[actor][:mana] -= 173
      add_effect(state, target, :poison, 6)
    when :recharge
      state[actor][:mana] -= 229
      add_effect(state, actor, :recharge, 5)
    end
  end

  if state[:boss][:hp] <= 0
    binding.pry
    wins << state
  elsif state[:player][:hp] <= 0
    # Dead
    next
  elsif state[:player][:mana] <= 0
    # Dead
    next
  end

  # next turn
  nextMoves = []
  turn = (turn == :player ? :boss : :player)

  if turn == :player
    [:magic_missile, :drain, :shield, :poison, :recharge].each do |spell|
      nextMoves << { actor: :player, action: spell }
    end
  else
    nextMoves << { actor: :boss, action: :attack }
  end

  nextMoves.each do |move|
    nextState = cloneState(state)
    nextState[:moves] << move

    queue << nextState
  end
end

puts wins
