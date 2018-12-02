import { readInput } from '../helpers'

const input: string[] = readInput('02', 'input')

let twoCount = 0
let threeCount = 0

const tally = (id: string): [boolean, boolean] => {
  const charCodes: number[] = id.split('')
    .map((char: string) => char.charCodeAt(0))
    .sort()

  let isTwo = false
  let isThree = false

  for (const [i, code] of charCodes.entries()) {
    if (charCodes[i + 1] === code && charCodes[i + 2] !== code) {
      isTwo = true
    } else if (charCodes[i + 2] === code && charCodes[i + 3] !== code) {
      isThree = true
    }
  }

  return [isTwo, isThree]
}

input.forEach((id: string) => {
  const [isTwo, isThree]: [boolean, boolean] = tally(id)

  if (isTwo) {
    twoCount += 1
  }

  if (isThree) {
    threeCount += 1
  }
})

console.log(twoCount * threeCount)
