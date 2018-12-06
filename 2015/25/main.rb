# codes = {}
# codes["1,1"] = 20151125
value = 20151125

target_row = 2947
target_col = 3029

row = 1
col = 1
row_max = 1

while row < target_row || col < target_col
  if row == 1
    row_max += 1
    row = row_max
    col = 1
  else
    row -= 1
    col += 1
  end

  value = value * 252533 % 33554393
end

puts value
