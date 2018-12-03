import { readFileSync } from 'fs'
import * as path from 'path'

export const readInput = (day: string, fileBaseName: string): string[] => {
  const inputPath: string = path.join(__dirname, day, 'inputs', `${fileBaseName}.txt`)

  return readFileSync(inputPath, 'utf-8')
    .trim()
    .split('\n')
}
