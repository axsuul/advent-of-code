require 'pry'

def group_packages(packages)
  groups_count = 3

  groups = []

  (1..(packages.count - groups_count - 1)).each do |n|
    groups += packages.combination(n).to_a
  end

  groups
end

puts group_packages(%w(1 2 3 4 5 7 8 9 10 11)).inspect