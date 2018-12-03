import { readInput } from '../helpers'

const input: string[] = readInput('03', 'input')

const claims = new Map()
const overlappingIds = new Set()
const ids = new Set()

for (const line of input) {
  const result = RegExp(/(\d+) @ (\d+),(\d+)\: (\d+)x(\d+)/).exec(line)

  if (result !== null) {
    const id = Number(result[1])
    const l = Number(result[2])
    const t = Number(result[3])
    const w = Number(result[4])
    const h = Number(result[5])

    ids.add(id)

    for (let y = t; y < t + h; y++) {
      for (let x = l; x < l + w; x++) {
        const key = `${x},${y}`

        if (!claims.has(key)) {
          claims.set(key, [])
        }

        claims.set(key, claims.get(key).concat(id))

        if (claims.get(key).length >= 2) {
          claims.get(key).forEach((overlappingId: number) => overlappingIds.add(overlappingId))
        }
      }
    }
  }
}

// Compare list of ids to overlapping ids and obtain id that's not overlapping
for (const id of ids) {
  if (!overlappingIds.has(id)) {
    console.log(id)

    break
  }
}
