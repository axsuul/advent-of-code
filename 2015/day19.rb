require 'pry'

def expand_molecule(replacements, molecule)
  molecules = []
  replacements = replacements.each_with_object({}) do |line, h|
    to, from = line.split(' => ')

    h[to] ||= []
    h[to] << from
  end

  molecule_split = molecule.split(/(?=[A-Z0-9])/)

  molecule_split.each_with_index do |element, i|
    [*replacements[element]].each do |el|
      new_molecule_split = molecule_split.dup
      new_molecule_split[i] = el

      molecules << new_molecule_split.join('')
    end
  end

  molecules.uniq
end

def contract_molecule(replacements, molecule, finish, step = 1)
  molecules = []
  mapping = replacements.each_with_object({}) do |line, h|
    to, from = line.split(' => ')

    h[from] ||= []
    h[from] << to
  end

  mapping.each do |from, to|
    to.each do |el|
      molecule.scan(Regexp.new(from)) do |match|
        index = Regexp.last_match.offset(0).first

        new_molecule = molecule.dup
        new_molecule[index..(index+from.length-1)] = el

        molecules << new_molecule
      end
    end
  end

  if molecules.any?
    molecules.uniq.map { |m| contract_molecule(replacements, m, finish, step + 1).uniq }
  else
    if molecule == finish
      [step - 1]
    else
      []
    end
  end
end

def only_contract_molecule(replacements, molecule)
  molecules = []
  mapping = replacements.each_with_object({}) do |line, h|
    to, from = line.split(' => ')

    h[from] ||= []
    h[from] << to
  end

  mapping.each do |from, to|
    to.each do |el|
      molecule.scan(Regexp.new(from)) do |match|
        index = Regexp.last_match.offset(0).first

        new_molecule = molecule.dup
        new_molecule[index..(index+from.length-1)] = el

        molecules << new_molecule
      end
    end
  end

  molecules
end

def calc_steps(replacements, initial, final)
  steps = []
  memory = []
  molecule = final

  loop do
    step = 1

    loop do
      molecules = only_contract_molecule(replacements, molecule)

      break unless molecules.any?

      molecule = molecules.sample

      return step if molecule == initial

      step += 1
    end

    molecule = final
  end

  steps
end

replacements = File.open('day19.txt').readlines.map(&:strip)

# Part 2
# puts calc_steps(["e => H", "e => O", "H => HO", "H => OH", "O => HH"], "e", "HOHOHO").inspect
puts calc_steps(replacements, "e", "ORnPBPMgArCaCaCaSiThCaCaSiThCaCaPBSiRnFArRnFArCaCaSiThCaCaSiThCaCaCaCaCaCaSiRnFYFArSiRnMgArCaSiRnPTiTiBFYPBFArSiRnCaSiRnTiRnFArSiAlArPTiBPTiRnCaSiAlArCaPTiTiBPMgYFArPTiRnFArSiRnCaCaFArRnCaFArCaSiRnSiRnMgArFYCaSiRnMgArCaCaSiThPRnFArPBCaSiRnMgArCaCaSiThCaSiRnTiMgArFArSiThSiThCaCaSiRnMgArCaCaSiRnFArTiBPTiRnCaSiAlArCaPTiRnFArPBPBCaCaSiThCaPBSiThPRnFArSiThCaSiThCaSiThCaPTiBSiRnFYFArCaCaPRnFArPBCaCaPBSiRnTiRnFArCaPRnFArSiRnCaCaCaSiThCaRnCaFArYCaSiRnFArBCaCaCaSiThFArPBFArCaSiRnFArRnCaCaCaFArSiRnFArTiRnPMgArF").inspect
