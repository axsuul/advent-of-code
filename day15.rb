require_relative 'helpers'
require 'rspec'
require 'pry'

class Ingredient
  attr_accessor :name, :capacity, :durability, :flavor, :texture, :calories

  def initialize(name, capacity, durability, flavor, texture, calories)
    self.name = name
    self.capacity = capacity.to_i
    self.durability = durability.to_i
    self.flavor = flavor.to_i
    self.texture = texture.to_i
    self.calories = calories.to_i
  end

  def ingredients

  end

  def calculate_score
    score = capacity * durability * flavor * texture
    score = 0 if score < 0

    score
  end
end

scores = []
calorie_scores = []
ingredients = []

File.open('day15.txt').readlines.each do |line|
  name, capacity, durability, flavor, texture, calories = line.match(/(\w+)\: capacity (.+)\, durability (.+), flavor (.+), texture (.+), calories (.+)/).captures

  ingredients << Ingredient.new(name, capacity, durability, flavor, texture, calories)
end

combos = (0..ingredients.length-1).to_a.repeated_combination(100)

combos.each do |combo|
  capacity = 0
  durability = 0
  flavor = 0
  texture = 0
  calories = 0

  combo.each do |i|
    ingredient = ingredients[i]

    capacity += ingredient.capacity
    durability += ingredient.durability
    flavor += ingredient.flavor
    texture += ingredient.texture
    calories += ingredient.calories
  end

  if capacity < 0 || durability < 0 || flavor < 0 || texture < 0
    score = 0
  else
    score = capacity*durability*flavor*texture
  end

  if calories == 500
    calorie_scores << score
  end

  scores << score
end

puts scores.sort.last
puts calorie_scores.sort.last
