require 'pry'

def build_matrix(filename)
  matrix = {}

  File.open(filename).readlines.each_with_index do |line, x|
    line.strip.split('').each_with_index do |dot, y|
      matrix[x] ||= {}
      matrix[x][y] = dot
    end
  end

  matrix
end

def print_matrix(matrix)
  matrix.each do |_, row|
    puts row.values.join('')
  end
end

def count_on(matrix)
  count = 0

  matrix.each do |_, row|
    row.each do |_, dot|
      count += 1 if dot == '#'
    end
  end

  count
end

def stuck!(matrix)
  z = matrix.length - 1

  matrix[0][0] = '#'
  matrix[0][z] = '#'
  matrix[z][0] = '#'
  matrix[z][z] = '#'

  matrix
end

def animate_lights(matrix, steps, stuck = false)
  z = matrix.length - 1

  stuck!(matrix) if stuck

  # Create deep copy of matrix
  next_matrix = Marshal.load(Marshal.dump(matrix))

  matrix.each do |x, row|
    row.each do |y, dot|
      neighbors = []

      (x-1..x+1).each do |xx|
        (y-1..y+1).each do |yy|
          next if x == xx && y == yy
          next if xx < 0 || xx > z
          next if yy < 0 || yy > z

          neighbors << matrix[xx][yy]
        end
      end

      on_count = neighbors.select { |d| d == '#' }.count

      new_dot =
        # If off, turn on if exactly 3 neighbors are on
        if dot == '.'
          on_count == 3 ? '#' : '.'
        # If on, leave on if 2 or 3 neighbors are on
        else
          (2..3).cover?(on_count) ? '#' : '.'
        end

      next_matrix[x][y] = new_dot
    end
  end

  stuck!(next_matrix) if stuck

  if steps == 0
    matrix
  elsif steps == 1
    next_matrix
  else
    animate_lights(next_matrix, steps - 1, stuck)
  end
end

puts count_on(animate_lights(build_matrix('day18.txt'), 100))
puts count_on(animate_lights(build_matrix('day18.txt'), 100, true))
