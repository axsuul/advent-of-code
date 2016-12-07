require_relative 'helpers'

def nice?(string)
  chars = string.split('')
  letter_repeat = false

  return false if string.scan(/a|e|i|o|u/).count < 3

  chars.each_with_index do |char, i|
    next if i == 0

    if char == chars[i - 1]
      letter_repeat = true

      break
    end
  end

  return false unless letter_repeat
  return false if string.match(/ab|cd|pq|xy/)

  true
end

def pairs_detected?(string)
  pair_detected = false

  string_split = string.split('')

  # Detect pairs
  string_split.each_with_index do |char, i|
    next if i == 0

    prev_char = string_split[i - 1]

    pair = "#{prev_char}#{char}"

    ((i+1)..(string.length-1)).each do |j|
      next_pair = "#{string_split[j]}#{string_split[j+1]}"

      if pair == next_pair
        pair_detected = true
        break
      end
    end
  end

  pair_detected
end

def inbetweener_found?(string)
  found = false

  string_split = string.split('')

  # Detect in between
  string_split.each_with_index do |char, i|
    next unless i >= 2

    over_char = string_split[i - 2]
    between_char = string_split[i - 1]

    if char == over_char
      found = true
      break
    end
  end

  found
end

def new_nice?(string)
  return false unless pairs_detected?(string)
  return false unless inbetweener_found?(string)

  true
end

nice_count = 0

read_input_lines(5).each do |line|
  if new_nice?(line)
    nice_count += 1
  end
end

puts "There are #{nice_count} nice strings"

puts inbetweener_found?("xyx")
puts inbetweener_found?("abcdefeghi")
puts inbetweener_found?("aaa")

