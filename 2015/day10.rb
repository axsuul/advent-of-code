require_relative 'helpers'
require 'rspec'
require 'pry'

def say(input)
  saying = ""
  input_split = input.split('')

  count = 0

  input_split.each_with_index do |char, i|
    next_char = input_split[i+1]

    count += 1

    if char != next_char
      saying << "#{count}#{char}"

      count = 0
    end
  end

  saying
end

def look_and_say(input, n, m = 1)
  saying = say(input)

  if n == m
    saying
  else
    look_and_say(saying, n, m+1)
  end
end

RSpec.describe '#say' do
  it "returns for n sequence for starting input" do
    expect(say("21")).to eq "1211"
    expect(say("1211")).to eq "111221"
    expect(say("111221")).to eq "312211"
  end
end

RSpec.describe '#look_and_say' do
  it "returns for n sequence for starting input" do
    expect(look_and_say("1", 1)).to eq "11"
    expect(look_and_say("1", 2)).to eq "21"
    expect(look_and_say("1", 3)).to eq "1211"
    expect(look_and_say("1", 4)).to eq "111221"
    expect(look_and_say("1", 5)).to eq "312211"
  end
end

puts look_and_say("1321131112", 50).length
