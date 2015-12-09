require_relative 'helpers'

houses = Hash.new { |h, k| h[k] = {} }

positions = {
  santa: { x: 0, y: 0 },
  robo: { x: 0, y: 0 }
}

directions = read_input(3).split('')

houses[0][0] = 2
count = 1

directions.each_with_index do |direction, i|
  person = i.even? ? :santa : :robo

  case direction
  when '^' then positions[person][:y] += 1
  when '>' then positions[person][:x] += 1
  when 'v' then positions[person][:y] -= 1
  when '<' then positions[person][:x] -= 1
  end

  x = positions[person][:x]
  y = positions[person][:y]

  if houses[x][y]
    houses[x][y] += 1
  else
    houses[x][y] = 1
    count += 1
  end
end

puts "There are #{count} houses that receive at least one present!"

