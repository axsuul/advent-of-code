import { minBy } from 'lodash'

import { readInput } from '../helpers'

const calcManhattan = ([x, y]: number[], [xx, yy]: number[]): number => {
  return Math.abs(x - xx) + Math.abs(y - yy)
}

const lines: string[] = readInput('06', 'input')

const xCollection = []
const yCollection = []
const areas: { [key: string]: number } = {}
const coords: number[][] = []
let safeCount = 0

// Determine bounds
for (const coord of lines) {
  const [x, y]: string[] = coord.split(', ')

  xCollection.push(+x)
  yCollection.push(+y)

  areas[`${x},${y}`] = 0
  coords.push([+x, +y])
}

const xMin = Math.min(...xCollection)
const xMax = Math.max(...xCollection)
const yMin = Math.min(...yCollection)
const yMax = Math.max(...yCollection)

for (let x = xMin; x < xMax + 1; x++) {
  for (let y = yMin; y < yMax + 1; y++) {
    const distances: { [key: number]: string[] } = {}

    for (const [xx, yy] of coords) {
      const distance = calcManhattan([x, y], [xx, yy])

      if (!distances.hasOwnProperty(distance)) {
        distances[distance] = []
      }

      distances[distance].push(`${xx},${yy}`)
    }

    const sum = coords
      .map(([xx, yy]: number[]) => calcManhattan([x, y], [xx, yy]))
      .reduce((dist: number, total: number) => dist + total, 0)

    if (sum < 10000) {
      safeCount += 1
    }

    const [shortestDistance, closest]: [string, string[]] = minBy(
      Object.entries(distances), ([dist]: [string, string[]]) => +dist
     )!

    if (closest.length > 1) {
      continue
    }

    // Remove from possible areas if one of the coords is on bounds
    if (x === xMin || x === xMax || y === yMin || y === yMax) {
      delete areas[closest[0]]
    }

    if (areas.hasOwnProperty(closest[0])) {
      areas[closest[0]] += 1
    }
  }
}

console.log('Part 1:', Math.max(...Object.values(areas)))
console.log('Part 2:', safeCount)

