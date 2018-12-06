lines = File.readlines('input.txt').map(&:strip)

# Part 1
weights = lines.map(&:to_i)
total_weight = weights.inject(0, :+)
target_weight = total_weight / 3
candidates = []

n = 1

while candidates.empty?
  candidates = weights.combination(n).select { |c| c.inject(0, :+) == target_weight }

  n += 1
end

puts candidates.map { |c| c.inject(:*) }.min

# Part 2
weights = lines.map(&:to_i)
total_weight = weights.inject(0, :+)
target_weight = total_weight / 4
candidates = []

n = 1

while candidates.empty?
  candidates = weights.combination(n).select { |c| c.inject(0, :+) == target_weight }

  n += 1
end

puts candidates.map { |c| c.inject(:*) }.min
