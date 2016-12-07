require_relative 'helpers'
require 'rspec'
require 'pry'

# lines = read_input_lines(13)
lines = File.open('day13.txt').readlines

guestlist = Hash.new { |h, k| h[k] = {} }

lines.each do |line|
  _, guest, type, points, actor = line.match(/(\w+).+(lose|gain)\s(\d+).+next to (\w+)/).to_a

  points = points.to_i
  points = -1*points if type == "lose"

  guestlist[guest][actor] = points
end

# Add yourself
guestlist.keys.each do |guest|
  guestlist['James'][guest] = 0
  guestlist[guest]['James'] = 0
end

guests = guestlist.keys

last_index = guests.count - 1
combos = (0..last_index).to_a.permutation.to_a

totals = []

combos.each do |combo|
  total = 0

  combo.each_with_index do |i, j|
    guest = guests[i]
    left = guests[(j == 0) ? combo[last_index] : combo[j - 1]]
    right = guests[(j == last_index) ? combo[0] : combo[j + 1]]

    left_points = guestlist[guest][left]
    right_points = guestlist[guest][right]

    total +=  left_points + right_points
.  end

  totals << total
end

puts totals.sort.last
