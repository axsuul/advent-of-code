interface Point {
  px: number,
  py: number,
  vx: number,
  vy: number,
}

import { readInput } from '../helpers'

let points: Point[] = []

const lines = readInput('10', 'input')

lines.forEach((line: string) => {
  const match = RegExp(/position\=<(.+),(.+)> velocity=<(.+),(.+)>/).exec(line)!

  points.push({
    px: +match[1],
    py: +match[2],
    vx: +match[3],
    vy: +match[4],
  })
})

let t = 0

const maxViewSize = 100

while (true) {
  let [minPx, maxPx, minPy, maxPy]: number[] = [points[0].px, points[0].px, points[0].py, points[0].py]

  const drawn = new Set()

  points.forEach(({ px, py }: { px: number, py: number }) => {
    if (px > maxPx) {
      maxPx = px
    }

    if (px < minPx) {
      minPx = px
    }

    if (py > maxPy) {
      maxPy = py
    }

    if (py < minPy) {
      minPy = py
    }

    drawn.add(`${px},${py}`)
  })

  // Only start printing if all points are within a bounding box
  if ((maxPx - minPx < maxViewSize) && (maxPy - minPy < maxViewSize)) {
    console.log(t)

    for (let y = minPy; y <= maxPy; y++) {
      let line = ''

      for (let x = minPx; x <= maxPx; x++) {
        if (drawn.has(`${x},${y}`)) {
          line += '#'
        } else {
          line += '.'
        }
      }

      console.log(line)
    }
  }

  t += 1

  points = points.map(({ px, py, vx, vy }: { px: number, py: number, vx: number, vy: number }) => {
    px += vx
    py += vy

    return { px, py, vx, vy }
  })
}
