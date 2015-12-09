require_relative 'helpers'

grand_total_surface_area = 0
grand_total_ribbon_length = 0

read_input_lines(2).each do |line|
  length, width, height = line.split('x').map(&:to_i)

  surfaces_areas = [2*length*width, 2*width*height, 2*height*length].sort
  perimeters = [2*length+2*width, 2*width+2*height, 2*height+2*length].sort
  volume = length*width*height

  total_surface_area = surfaces_areas.first/2 + surfaces_areas.inject(:+)
  total_ribbon_length = perimeters.first + volume

  grand_total_surface_area += total_surface_area
  grand_total_ribbon_length += total_ribbon_length
end

puts "Total surface area: #{grand_total_surface_area}"
puts "Total ribbon length: #{grand_total_ribbon_length}"