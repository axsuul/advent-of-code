require_relative 'helpers'
require 'rspec'
require 'pry'
require 'json'

def count(struct, blacklisted = nil)
  case struct
  when Array
    struct.map { |s| count(s, blacklisted) }.inject(:+)
  when Hash
    struct.values.include?(blacklisted) ? 0 : count(struct.values, blacklisted)
  when Fixnum
    struct
  else
    0
  end
end

total = 0
red_total = 0

JSON.parse(read_input(12)).each do |struct|
  total += count(struct)
  red_total += count(struct, 'red')
end

puts total
puts red_total