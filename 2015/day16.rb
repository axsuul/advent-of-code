require_relative 'helpers'
require 'rspec'
require 'pry'

sues = []

read_input_lines(16).each do |line|
  props = line.match(/Sue \d+\:(.+)/).captures.first.split(',')
  sue = {}

  props.each do |prop|
    key, value = prop.strip.split(': ')

    sue[key.to_sym] = value.to_i
  end

  sues << sue
end

target_sue = {
  children: 3,
  cats: 7,
  samoyeds: 2,
  pomeranians: 3,
  akitas: 0,
  vizslas: 0,
  goldfish: 5,
  trees: 3,
  cars: 2,
  perfumes: 1
}
possibly_sues = []

sues.each_with_index do |sue, i|
  match = true

  sue.each do |key, value|
    if [:cats, :trees].include?(key)
      if target_sue[key] >= value
        match = false
        break
      end

    elsif [:pomeranians, :goldfish].include?(key)
      if target_sue[key] <= value
        match = false
        break
      end
    else
      if target_sue[key] != value
        match = false
        break
      end
    end
  end

  possibly_sues << [i+1, sue] if match
end

puts possibly_sues.inspect