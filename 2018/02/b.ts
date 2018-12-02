import { readInput } from '../helpers'

const input: string[] = readInput('02', 'input')

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
