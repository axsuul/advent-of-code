require 'pry'

store = {
  weapons: [],
  armor: [],
  rings: []
}

type = nil

File.open('day21store.txt').readlines.each do |line|
  line.strip!

  if match = line.match(/(\w+)\:.*/)
    type =
      case match[1]
      when "Weapons" then :weapons
      when "Armor"   then :armor
      when "Rings"   then :rings
      end
  elsif match = line.match(/([A-Za-z0-9\+]+) .+ (\d+) .+ (\d+) .+ (\d+)/)
    name, cost, damage, armor = match.captures

    store[type] << {
      name: name,
      cost: cost.to_i,
      damage: damage.to_i,
      armor: armor.to_i
    }
  end
end

class Player
  attr_accessor :equipment, :damage, :armor, :hp

  def initialize(hp, armor, damage)
    self.hp = hp
    self.armor = armor
    self.damage = damage
  end

  def equip!(equipment)
    begin
    self.armor += equipment[:armor]
    self.damage += equipment[:damage]
  rescue TypeError
    binding.pry
  end
  end

  def attack(defender)
    diff = damage - defender.armor
    diff = 1 if diff <= 0

    defender.hp -= diff
  end

  def fight!(player)
    attacker = self
    defender = player

    loop do
      attacker.attack(defender)

      break if defender.hp <= 0

      if attacker == self
        attacker = player
        defender = self
      else
        attacker = self
        defender = player
      end
    end

    true
  end

  def wins?(player)
    fight!(player)

    alive?
  end

  def alive?
    hp > 0
  end

  def dead?
    !alive?
  end
end

costs_to_win = []
costs_to_lose = []
weapon_combos = store[:weapons]
armor_combos = (store[:armor] + [nil])
ring_combos = store[:rings].combination(1).to_a + store[:rings].combination(2).to_a + [[nil]]

weapon_combos.each do |weapon|
  armor_combos.each do |armor|
    ring_combos.each do |rings|
      boss = Player.new(100, 2, 8)
      player = Player.new(100, 0, 0)
      player.equip!(weapon)
      player.equip!(armor) if armor

      rings.each do |ring|
        player.equip!(ring) if ring
      end

      costs = [weapon, armor, rings].flatten.compact.map { |e| e[:cost] }.reduce(&:+)

      if player.wins?(boss)
        costs_to_win << costs
      else
        costs_to_lose << costs
      end
    end
  end
end

# Part 1
puts "Least amount of gold to win: #{costs_to_win.min}"

# Part 2
puts "Most amount of gold to lose: #{costs_to_lose.max}"