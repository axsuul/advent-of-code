IO.puts "Hello World"

{:ok, file} = File.open "input.txt", [:read]
line = IO.read file, :line
IO.puts line
