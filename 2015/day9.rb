require_relative 'helpers'
require 'rspec'
require 'pry'

def build_routes(lines)
  chart = Hash.new { |h, k| h[k] = {} }
  routes = {}

  lines.each do |line|
    _, from, to, distance = line.match(/(\w+) to (\w+) \= (\d+)/).to_a

    distance = distance.to_i

    chart[to][from] = distance
    chart[from][to] = distance
  end

  locations = chart.keys
  permutations = (0..(locations.length-1)).to_a.permutation.to_a

  possible_routes = permutations.map { |r| r.map { |i| locations[i] }}

  possible_routes.each do |route|
    distance = 0

    route.each_with_index do |location, i|
      from = location
      to = route[i+1]

      next if to.nil?

      distance += chart[from][to]
    end

    routes[route.join(' -> ')] = distance
  end

  routes
end

RSpec.describe '#build_combinations' do
  it "takes in an array and returns array of arrays of permutations" do
    expect(build_combinations([0, 1])).to match_array([[0, 1], [1, 0]])
    # expect(build_combinations([0, 1, 2])).to match_array([[0, 1, 2], [0, 2, 1], [1, 0, 2], [1, 2, 0], [2, 1, 0], [2, 0, 1]])
  end
end

RSpec.describe '#build_routes' do
  it "returns routes from distances" do
    routes = build_routes(["London to Dublin = 464", "London to Belfast = 518", "Dublin to Belfast = 141"])

    expect(routes).to eq ({
      "Dublin -> London -> Belfast" => 982,
      "London -> Dublin -> Belfast" => 605,
      "London -> Belfast -> Dublin" => 659,
      "Dublin -> Belfast -> London" => 659,
      "Belfast -> Dublin -> London" => 605,
      "Belfast -> London -> Dublin" => 982
    })
  end
end

lines = read_input_lines(9)

routes = build_routes(lines)

puts routes.values.min_by { |v| v }
puts routes.values.max_by { |v| v }
