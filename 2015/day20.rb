
def calculate_divisors(n)
  divisors = []

  # When calculaing divisors, only need to consider up to square root of number
  1.upto((n**0.5).floor) do |i|
    q, r = n.divmod(i)

    divisors << q << i if r.zero?
  end

  divisors.uniq
end

target = 33100000
houses = {}
house = 1

# Part 1
loop do
  puts "@ House ##{house}..."

  houses[house] ||= 0
  houses[house] = calculate_divisors(house).map { |d| d*10 }.inject(:+)

  if houses[house] >= target
    puts "House ##{house} has at least #{target}!"
    break
  else
    puts "It has #{houses[house]} presents!  "
  end

  house += 1
end

counts = Hash.new { |h, k| h[k] = 0 }

# Part 2
loop do
  puts "@ House ##{house}..."


  presents = 0

  calculate_divisors(house).each do |elf|
    if counts[elf] < 50
      presents += 11*elf

      counts[elf] += 1
    end
  end

  houses[house] = presents

  if houses[house] >= target
    puts "House ##{house} has at least #{target}!"
    break
  else
    puts "It has #{houses[house]} presents!  "
  end

  house += 1
end