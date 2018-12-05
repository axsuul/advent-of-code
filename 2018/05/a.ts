import { readInput } from '../helpers'

const input: string[] = readInput('05', 'input')

const isReactive = (unit1: string, unit2: string): boolean => {
  return Math.abs(unit1.charCodeAt(0) - unit2.charCodeAt(0)) === 32
}

const react = (polymer: string): string => {
  let i = 0

  while (true) {
    const unit = polymer[i]
    const nextUnit = polymer[i + 1]

    if (nextUnit === undefined) {
      break
    }

    if (isReactive(unit, nextUnit)) {
      polymer = polymer.substring(0, i) + polymer.substring(i + 2, polymer.length)

      i = (i > 0) ? i - 1 : 0
    } else {
      i += 1
    }
  }

  return polymer
}

const inputPolymer: string = input[0]

console.log('Part 1:', react(inputPolymer).length)

// Generate unit pairs, create polymers from them and get them to react
const lengths: number[] = Array.from(Array(26).keys()).map((i: number) => {
  return [String.fromCharCode(i + 65), String.fromCharCode(i + 97)]
}).map(([unit1, unit2]: string[]) => {
  return react(inputPolymer.replace(RegExp(unit1, 'g'), '').replace(RegExp(unit2, 'g'), '')).length
})

console.log('Part 2:', Math.min(...lengths))
