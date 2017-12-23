require 'pry'

# Part A
# registers = { "a" => 0, "b" => 0 }

# Part B
registers = { "a" => 1, "b" => 0 }
instructions = File.open('day23input.txt').readlines.map(&:strip)

i = 0
max_i = instructions.length - 1

def parse_offset(offset)
  match = offset.match(/(\+|\-)(\d+)/)
  mod = (match[1] == "-") ? -1 : 1

  mod*match[2].to_i
end

while i >= 0 && i <= max_i do
  instruction = instructions[i]
  offset = 1

  if match = instruction.match(/inc (.+)/)
    registers[match[1]] += 1
  elsif match = instruction.match(/hlf (.+)/)
    registers[match[1]] /= 2
  elsif match = instruction.match(/tpl (.+)/)
    registers[match[1]] *= 3
  elsif match = instruction.match(/jio (.+)\, (.+)/)
    if registers[match[1]] == 1
      offset = parse_offset(match[2])
    end
  elsif match = instruction.match(/jie (.+)\, (.+)/)
    if registers[match[1]] % 2 == 0
      offset = parse_offset(match[2])
    end
  elsif match = instruction.match(/jmp (.+)/)
    offset = parse_offset(match[1])
  end

  puts registers.inspect

  i += offset
end

puts registers.inspect
