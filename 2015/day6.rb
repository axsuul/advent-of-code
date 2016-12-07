require_relative 'helpers'

class Light
  attr_accessor :state, :brightness

  def initialize
    self.state = :off
    self.brightness = 0
  end

  def toggle!
    self.state = on? ? :off : :on
    self.brightness += 2
  end

  def on!
    self.state = :on
    self.brightness += 1
  end

  def off!
    self.state = :off

    if brightness > 0
      self.brightness -= 1
    end
  end

  def on?
    state == :on
  end

  def off?
    state == :off
  end
end

class LightMatrix
  attr_accessor :matrix, :range

  def initialize(range)
    self.matrix = Hash.new { |h, k| h[k] = {} }

    range.each do |x|
      range.each do |y|
        self.matrix[x][y] = Light.new
      end
    end
  end

  def send_instruction(instruction)
    parsed = instruction.scan(/(\d+)\,(\d+)/)

    # x1 < x2 && y1 < y2
    x1, x2 = parsed.map { |p| p[0].to_i }.sort
    y1, y2 = parsed.map { |p| p[1].to_i }.sort

    method =
      case instruction
      when /turn on/  then :on!
      when /turn off/ then :off!
      when /toggle/   then :toggle!
      end

    (x1..x2).each do |x|
      (y1..y2).each do |y|
        matrix[x][y].send(method)
      end
    end
  end

  def each
    matrix.each do |x, row|
      row.each do |y, _|
        yield(matrix[x][y])
      end
    end
  end

  def count_on
    count = 0

    each { |l| count += 1 if l.on? }

    count
  end

  def calculate_total_brightness
    brightness = 0

    each { |l| brightness += l.brightness }

    brightness
  end

  def to_s
    matrix.map do |x, row|
      row.map { |y, l| l.on? ? "X" : "O" }.join('')
    end.join("\n")
  end
end

matrix = LightMatrix.new(0..999)

read_input_lines(6).each do |instruction|
  matrix.send_instruction(instruction)
end

puts "#{matrix.count_on} lights are on!"
puts "Total brightness: #{matrix.calculate_total_brightness}"
