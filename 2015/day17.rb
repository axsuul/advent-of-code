require_relative 'helpers'
require 'rspec'
require 'pry'

def calc_combos(containers, target)
  containers.map! { |s| s.to_i }
  combos = []

  (1..containers.count).each do |n|
    containers.combination(n).each do |combo|
      combos << combo if combo.reduce(:+) == target
    end
  end

  combos
end

puts calc_combos(%w(20 15 10 5 5), 25).count

counts = {}

calc_combos(read_input_lines(17), 150).each do |combo|
  counts[combo.count] ||= 0
  counts[combo.count] += 1
end

puts counts.inspect
