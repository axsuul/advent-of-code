require_relative 'helpers'
require 'rspec'
require 'pry'

def increment_password(password)
  password = password.reverse
  new_password = password.dup
  password_length = password.length

  password.split('').each_with_index do |char, i|
    # increment char
    ord = char.ord + 1
    ord += 1 if [105, 108, 111].include?(ord)  # skip i, o, l

    if ord > 122
      new_password[i] = "a"

      next
    end

    new_password[i] = ord.chr

    break
  end

  new_password.reverse
end

def increasing_straight?(password)
  indexes = 0.upto(password.length - 3)
  indexes.each do |i|
    if (password[i].ord == password[i+1].ord - 1) &&
       (password[i].ord == password[i+2].ord - 2)
      return true
    end
  end

  false
end

def valid_chars?(password)
  password.match(/i|o|l/).nil?
end

def has_pairs?(password)
  count = 0
  i = 0

  while i <= password.length - 2
    if password[i] == password[i+1]
      count += 1
      i += 2
    else
      i += 1
    end
  end

  count == 2
end

def valid_password?(password)
  increasing_straight?(password) &&
  valid_chars?(password) &&
  has_pairs?(password)
end

def increment_valid_password(password)
  loop do
    password = increment_password(password)

    break if valid_password?(password)
  end

  password
end

RSpec.describe '#increment_password' do
  it "increments" do
    expect(increment_password("xx")).to eq "xy"
    expect(increment_password("xy")).to eq "xz"
    expect(increment_password("xz")).to eq "ya"
    expect(increment_password("ya")).to eq "yb"
    expect(increment_password("xzz")).to eq "yaa"
  end
end

RSpec.describe 'validation methods' do
  it "validates" do
    expect(increasing_straight?("hijklmmn")).to eq true
    expect(increasing_straight?("abbceffg")).to eq false
    expect(valid_chars?("hijklmmn")).to eq false
    expect(valid_chars?("abbcegjk")).to eq true
    expect(has_pairs?("abbceffg")).to eq true
    expect(has_pairs?("abbcegjk")).to eq false
    expect(has_pairs?("abcdeggg")).to eq false
  end
end

RSpec.describe 'valid_password?' do
  it "returns true if so" do
    expect(valid_password?("abcdffaa")).to eq true
  end
end

RSpec.describe '#increment_valid_password' do
  it "increments" do
    expect(increment_valid_password("abcdefgh")).to eq "abcdffaa"
    expect(increment_valid_password("ghijklmn")).to eq "ghjaabcc"   # skip i
  end
end

puts increment_valid_password("cqjxjncq")
puts increment_valid_password("cqjxxyzz")