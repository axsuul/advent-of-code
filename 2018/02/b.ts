import { readFileSync } from 'fs'
import * as path from 'path'

const inputPath = path.join(__dirname, 'inputs', 'input.txt')
const input = readFileSync(inputPath, 'utf-8').split('\n')
let commonLetters: string | undefined

for (let i = 0; i < input[0].length; i++) {
  const removed = input.slice().map((id) => {
    const exploded = id.split('')

    exploded.splice(i, 1)

    return exploded.join('')
  })

  const set = new Set()

  for (const idRemoved of removed) {
    if (set.has(idRemoved)) {
      commonLetters = idRemoved

      break
    } else {
      set.add(idRemoved)
    }
  }

  if (commonLetters != undefined) break
}

console.log(commonLetters)
