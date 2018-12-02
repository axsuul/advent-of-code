import { readFileSync } from 'fs'
import * as path from 'path'

const inputPath = path.join(__dirname, 'inputs', 'input.txt')
const input = readFileSync(inputPath, 'utf-8').split('\n')

const applyChanges = function(value: number, changes: string[]): number {
  if (changes.length == 0) {
    return value
  } else {
    const change = changes.shift()

    return applyChanges(eval(`${value} ${change}`), changes)
  }
}

console.log(applyChanges(0, input))
