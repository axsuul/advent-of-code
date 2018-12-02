import { readFileSync } from 'fs'
import * as path from 'path'

const inputPath = path.join(__dirname, 'inputs', 'input.txt')
const input = readFileSync(inputPath, 'utf-8').trim().split('\n')

const freqs = new Set()
let i = 0
let value = 0

while (true) {
  if (i > input.length - 1) i = 0

  freqs.add(value)

  value = eval(`${value} ${input[i]}`)

  if (freqs.has(value)) {
    console.log(value)

    break
  }

  i += 1
}
