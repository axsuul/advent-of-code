def read_input(day)
  File.open("day#{day}.txt").read
end

def read_input_lines(*args)
  read_input(*args).split("\n")
end