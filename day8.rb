require_relative 'helpers'
require 'rspec'
require 'pry'

def count_memory_chars(string)
  string.length
end

def count_string_chars(string)
  eval(string).length
end

def encode(string)
  string.gsub(/\\/, '\\\\')    # encode backslash
        .gsub(/(?!^)\"(?!$)/, '\\"')   # encode quotes not at end or beginning
        .sub(/^\"/, '"\\"')
        .sub(/\"$/, '\\""')
end

RSpec.describe 'stuff' do
  it "counts correctly" do
    expect(count_memory_chars('""')).to eq 2
    expect(count_string_chars('""')).to eq 0
  end

  it "counts correctly" do
    expect(count_memory_chars('"abc"')).to eq 5
    expect(count_string_chars('"abc"')).to eq 3
  end

  it "counts correctly" do
    expect(count_memory_chars('"aaa\"aaa"')).to eq 10
    expect(count_string_chars('"aaa\"aaa"')).to eq 7
  end

  it "counts correctly" do
    expect(count_memory_chars('"\x27"')).to eq 6
    expect(count_string_chars('"\x27"')).to eq 1
  end

  it "encodes properly", :focus do
    # expect(encode('""')).to eq '"\"\""'
    # expect(count_memory_chars(encode('""'))).to eq 6
    # expect(encode('"abc"')).to eq '"\"abc\""'
    # expect(count_memory_chars(encode('"abc"'))).to eq 9
    expect(encode('"aaa\"aaa"')).to eq '"\"aaa\\\"aaa\""'
    expect(count_memory_chars(encode('"aaa\"aaa"'))).to eq 16
    # expect(encode('"\x27"')).to eq '"\"\\x27\""'
    # expect(count_memory_chars(encode('"\x27"'))).to eq 11

  end
end

total_string_count = 0
total_memory_count = 0
total_encoded_memory_count = 0

read_input_lines(8).each do |line|
  line = line.chomp
  total_memory_count += count_memory_chars(line)
  total_string_count += count_string_chars(line)
end

diff = total_memory_count - total_string_count

code_chars = 0
esc_chars = 0

read_input_lines(8).each do |line|
  line = line.chomp
  encoded = line.dump
  code_chars += line.length
  esc_chars += line.dump.length

  encoded = line.dump
  total_encoded_memory_count += count_memory_chars(encoded)
end

puts esc_chars - code_chars

encoded_diff = total_encoded_memory_count - total_memory_count

puts "Non-encoded: #{total_memory_count} - #{total_string_count} = #{diff}"
puts "Encoded: #{esc_chars} - #{code_chars} = #{encoded_diff}"