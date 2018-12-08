import { readInput } from '../helpers'

interface Job {
  nodeCount: number,
  metadataCount: number,
}

const lines: string[] = readInput('08', 'input')

const numbers = lines[0].split(' ').map(Number)

let total = 0
const queue: Job[] = []

while (numbers.length > 0) {
  const nodeCount = numbers.shift()!
  const metadataCount = numbers.shift()!

  queue.push({ nodeCount, metadataCount })

  while (queue.length > 0) {
    const job = queue.pop()!

    if (job.nodeCount === 0) {
      const metadata = numbers.splice(0, job.metadataCount)

      total += metadata.reduce((n: number, s: number) => n + s, 0)
    } else {
      queue.push({ nodeCount: job.nodeCount - 1, metadataCount: job.metadataCount })

      break
    }
  }
}

console.log(total)
