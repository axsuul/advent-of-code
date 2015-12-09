require_relative 'helpers'
require 'rspec'
require 'pry'

class Source
  attr_reader :signal

  def signal=(signal)
    @signal = signal.to_i
  end
end

class NotGate < Source
  attr_reader :wire

  def initialize(wire, destination)
    self.wire = wire
  end

  def update!
    if wire.source
      self.signal = (wire.source.signal-65535).abs
    end
  end

  def wire=(wire)
    @wire = wire

    wire.gates << self
  end
end

class Gate < Source
  attr_accessor :operator
  attr_reader :wire1, :wire2

  def initialize(operator, wire1, wire2, destination)
    self.operator = operator
    self.wire1 = wire1
    self.wire2 = wire2

    destination.source = self
  end

  def wire1=(wire)
    @wire1 = wire

    wire.add_gate(self)
  end

  def wire2=(wire)
    @wire2 = wire

    wire.add_gate(self)
  end

  def update!
    if wire1.source && wire2.source
      self.signal = wire1.source.signal.send(operator, wire2.source.signal)
    end
  end

  def calculate!
    raise NotImplementedError
  end
end

class Power < Source
  def initialize(signal)
    self.signal = signal
  end
end

class Circuit
  attr_accessor :wires

  def initialize
    self.wires = {}
  end

  def find_wire(name)
    wires[name]
  end

  def find_or_initialize_wire(name)
    find_wire(name) || begin
      wires[name] = Wire.new(name)
    end
  end

  def add_instruction!(instruction)
    operation, name = instruction.split(' -> ')

    destination = find_or_initialize_wire(name) if name

    if operation.match(/^(\w+)$/)
      wire = find_or_initialize_wire(name)
      wire.source = Power.new($1)
    elsif operation.match(/NOT/)

    else
      name1, description, name2 = operation.split(' ')

      operator = case description
        when "AND"    then :&
        when "OR"     then :|
        when "LSHIFT" then :<<
        when "RSHIFT" then :>>
        end

      Gate.new(
        operator,
        find_or_initialize_wire(name1),
        find_or_initialize_wire(name2),
        destination
      )
    end
  end

  def wire_signals
    signals = {}

    wires.each do |name, wire|
      if source = wire.source
        signals[name] = source.signal
      end
    end

    signals
  end
end

class Wire
  attr_accessor :name, :gates, :source

  def initialize(name, signal = nil)
    self.name = name
    self.gates = []
    self.signal = signal if signal
  end

  def source=(source)
    @source = source

    binding.pry

    gates.each { |g| g.update! }
  end

  def add_gate(gate)
    self.gates << gate

    binding.pry
  end
end

RSpec.describe Circuit do
  it "connects like in real life" do
    circuit = Circuit.new
    circuit.add_instruction!("123 -> x")

    x = circuit.find_wire("x")

    expect(x.source).to be_a Power
    expect(x.source.signal).to eq 123
    expect(x.gates).to be_empty

    circuit.add_instruction!("x AND y -> d")

    y = circuit.find_wire("y")
    d = circuit.find_wire("d")

    expect(y.source).to be_nil

    gate = d.source

    expect(gate).to be_a Gate
    expect(gate.operator).to eq :&
    expect(gate.wire1).to eq x
    expect(gate.wire2).to eq y

    expect(x.gates.count).to eq 1
    expect(x.gates.first).to eq gate

    circuit.add_instruction!("456 -> y")

    expect(y.source).to be_a Power
    expect(y.source.signal).to eq 456
    expect(d.source.signal).to eq 72

    expect(circuit.wire_signals).to eq ({
      "x" => 123,
      "y" => 456,
      "d" => 72
    })
  end

  it "works on test case", :focus do
    circuit = Circuit.new
    circuit.add_instruction! "123 -> x"
    circuit.add_instruction! "456 -> y"
    circuit.add_instruction! "x AND y -> d"
    # circuit.add_instruction! "x OR y -> e"
    # circuit.add_instruction! "x LSHIFT 2 -> f"
    # circuit.add_instruction! "y RSHIFT 2 -> g"
    # circuit.add_instruction! "NOT x -> h"
    # circuit.add_instruction! "NOT y -> i"

    expect(circuit.wire_signals).to eq ({
      "d" => 72,
      "e" => 507,
      "f" => 492,
      "g" => 114,
      "h" => 65412,
      "i" => 65079,
      "x" => 123,
      "y" => 456
    })
  end
end