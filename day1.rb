require_relative 'helpers'

instructions = read_input(1)

floor = 0
position = 1
entered_basement = false

instructions.split("").each do |instruction|
  floor += (instruction == "(") ? 1 : -1

  if floor == -1 && !entered_basement
    puts "Santa has entered the basement at position #{position}!"

    entered_basement = true
  end

  position += 1
end

puts floor