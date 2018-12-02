import { readFileSync } from 'fs'
import * as path from 'path'

const inputPath = path.join(__dirname, 'inputs', 'a.txt')
const input = readFileSync(inputPath, 'utf-8').split('\n')

let twoCount = 0
let threeCount = 0

const tally = function(id: string): [boolean, boolean] {
  const charCodes: number[] = id.split('').map(char => char.charCodeAt(0)).sort()

  let isTwo = false
  let isThree = false

  for (const [i, code] of charCodes.entries()) {
    if (charCodes[i + 1] == code && charCodes[i + 2] != code) {
      isTwo = true
    } else if (charCodes[i + 2] == code && charCodes[i + 3] != code) {
      isThree = true
    }
  }

  return [isTwo, isThree]
}

input.forEach((id) => {
  const [isTwo, isThree] = tally(id)

  if (isTwo) twoCount += 1
  if (isThree) threeCount += 1
})

console.log(twoCount * threeCount)
