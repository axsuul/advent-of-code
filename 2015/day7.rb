require_relative 'helpers'
require 'rspec'
require 'pry'

class Circuit
  attr_accessor :wires, :all_instructions

  def initialize
    self.wires = {}
    self.all_instructions = []
  end

  def add_instruction!(instruction)
    self.all_instructions << instruction
  end

  def build!(instructions = all_instructions)
    return if instructions.empty?

    instructions.each do |instruction|
      if complete_instruction!(instruction)
        instructions.delete(instruction)
      end
    end

    build!(instructions)
  end

  def complete_instruction!(instruction)
    begin
      operation, label = instruction.split(' -> ')

      wire =
        case operation
        when /(\w+) AND (\w+)/
          find_wire($1).and(find_wire($2))
        when /(\w+) OR (\w+)/
          find_wire($1).or(find_wire($2))
        when /(\w+) LSHIFT (\w+)/
          find_wire($1).lshift(find_wire($2))
        when /(\w+) RSHIFT (\w+)/
          find_wire($1).rshift(find_wire($2))
        when /NOT (\w+)/
          find_wire($1).not
        when /([a-z]+)/
          Wire.new(find_wire($1).signal)
        when /(\w+)/
          Wire.new($1)
        end

      wires[label.to_sym] = wire

      true
    rescue Wire::NotFound
      false
    end
  end

  def find_wire(label)
    if label.match(/[a-z]+/)
      if wire = wires[label.to_sym]
        return wire
      else
        raise Wire::NotFound
      end
    else
      return Wire.new(label)
    end
  end

  def wire_signals
    signals = {}

    wires.each do |label, wire|
      signals[label] = wire.signal if wire
    end

    signals
  end
end

class Wire
  attr_accessor :signal

  def initialize(signal)
    self.signal = signal.to_i
  end

  def and(wire)
    Wire.new(signal & wire.signal)
  end

  def or(wire)
    Wire.new(signal | wire.signal)
  end

  def lshift(wire)
    Wire.new(signal << wire.signal)
  end

  def rshift(wire)
    Wire.new(signal >> wire.signal)
  end

  def not
    Wire.new((signal-65535).abs)
  end

  class NotFound < Exception; end
end

RSpec.describe Wire do
  it "supports AND operator" do
    x = Wire.new(123)
    y = Wire.new(456)

    d = x.and(y)

    expect(d).to be_a Wire
    expect(d.signal).to eq 72
  end

  it "supports NOT operator" do
    x = Wire.new(123)
    h = x.not

    expect(h).to be_a Wire
    expect(h.signal).to eq 65412

    h = Wire.new(65412)
    expect(h.not.signal).to eq 123
  end

  it "suppor RSHIFT operator" do
    y = Wire.new(456)
    g = y.rshift(Wire.new(2))

    expect(g).to be_a Wire
    expect(g.signal).to eq 114
  end
end

RSpec.describe Circuit do
  it "can add instructions and return signals on each wire" do
    circuit = Circuit.new
    circuit.add_instruction! "x AND y -> d"
    circuit.add_instruction! "y RSHIFT 2 -> g"
    circuit.add_instruction! "x LSHIFT 2 -> f"
    circuit.add_instruction! "x OR y -> e"
    circuit.add_instruction! "123 -> x"
    circuit.add_instruction! "NOT x -> h"
    circuit.add_instruction! "456 -> y"
    circuit.add_instruction! "NOT y -> i"
    circuit.add_instruction! "x -> z"
    circuit.build!

    expect(circuit.wire_signals).to eq({
      d: 72,
      e: 507,
      f: 492,
      g: 114,
      h: 65412,
      i: 65079,
      x: 123,
      y: 456,
      z: 123
    })
  end
end

circuit = Circuit.new

instructions = read_input_lines(7)

instructions.each do |instruction|
  circuit.add_instruction!(instruction)
end
# circuit.add_instruction!("16076 -> b")

circuit.build!


puts circuit.wire_signals
