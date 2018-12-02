import { readFileSync } from 'fs'
import * as path from 'path'

const inputPath: string = path.join(__dirname, 'inputs', 'input.txt')
const input: string[] = readFileSync(inputPath, 'utf-8')
  .split('\n')
let commonLetters: string | undefined

for (let i = 0; i < input[0].length; i++) {
  const removed: string[] = input.slice()
    .map((id: string) => {
      const exploded: string[] = id.split('')

      exploded.splice(i, 1)

      return exploded.join('')
    })

  const set: Set<string> = new Set()

  for (const idRemoved of removed) {
    if (set.has(idRemoved)) {
      commonLetters = idRemoved

      break
    } else {
      set.add(idRemoved)
    }
  }

  if (commonLetters !== undefined) {
    break
  }
}

console.log(commonLetters)
