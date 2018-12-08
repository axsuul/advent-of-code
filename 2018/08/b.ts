import { readInput } from '../helpers'

interface Job {
  nodeCount: number,
  metadataCount: number,
  values: number[],
}

const lines: string[] = readInput('08', 'input')

const numbers = lines[0].split(' ').map(Number)

const queue: Job[] = []

while (numbers.length > 0) {
  const nodeCount = numbers.shift()!
  const metadataCount = numbers.shift()!

  queue.push({ nodeCount, metadataCount, values: [] })

  while (queue.length > 0) {
    const job = queue.pop()!

    if (job.nodeCount === 0) {
      const metadata = numbers.splice(0, job.metadataCount)
      const parentJob = queue.pop()

      let value: number

      // If a node has no child nodes, its value is the sum of its metadata entries
      if (job.values.length === 0) {
        value = metadata.reduce((s: number, n: number) => n + s, 0)
      } else {
        value = metadata.reduce((s: number, n: number) => (job.values[n - 1] || 0) + s, 0)
      }

      if (parentJob) {
        parentJob.values.push(value)
        queue.push(parentJob)
      } else {
        // No more parent job so at root!
        console.log(value)
      }
    } else {
      queue.push({ nodeCount: job.nodeCount - 1, metadataCount: job.metadataCount, values: job.values })

      break
    }
  }
}
