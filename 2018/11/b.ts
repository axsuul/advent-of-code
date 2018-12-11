const gridSerialNumber = 7347
const gridSize = 300

const grid: { [key: string]: number } = {}

const calculatePowerLevel = (x: number, y: number): number => {
  const rackId = x + 10
  let powerLevel = rackId * y

  powerLevel += gridSerialNumber
  powerLevel *= rackId
  powerLevel = Math.floor((powerLevel / 100) % 10)
  powerLevel -= 5

  return powerLevel
}

const getPowerLevel = (x: number, y: number): number => {
  return grid[`${x},${y}`]
}

for (let y = 1; y <= gridSize; y++) {
  for (let x = 1; x <= gridSize; x++) {
    grid[`${x},${y}`] = calculatePowerLevel(x, y)
  }
}

const largestSquare: { [key: string]: number } = {
  powerLevel: 0,
  size: 0,
  x: 0,
  y: 0,
}

for (let y = 1; y <= gridSize; y++) {
  for (let x = 1; x <= gridSize; x++) {
    console.log(x, y)
    const maxCoord = (x > y) ? x : y
    const maxSize = (gridSize - (maxCoord - 1))

    let squarePowerLevel = 0

    for (let size = 1; size <= maxSize; size++) {
      const maxX = x + size - 1
      const maxY = y + size - 1

      // Get the power levels for next border
      for (let xx = x; xx <= maxX - 1; xx++) {
        squarePowerLevel += getPowerLevel(xx, maxY)
      }

      for (let yy = y; yy <= maxY - 1; yy++) {
        squarePowerLevel += getPowerLevel(maxX, yy)
      }

      squarePowerLevel += getPowerLevel(maxX, maxY)

      if (squarePowerLevel > largestSquare.powerLevel) {
        largestSquare.powerLevel = squarePowerLevel
        largestSquare.x = x
        largestSquare.y = y
        largestSquare.size = size
      }
    }
  }
}
