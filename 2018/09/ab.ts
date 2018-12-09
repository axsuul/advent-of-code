const playersCount = 452
const lastMarble = 71250 * 100

interface Player {
  score: number,
}

interface MarbleNode {
  left: number,
  right: number,
}

// Build players
const players: { [key: number]: number } = {}

for (let p = 1; p < playersCount + 1; p++) {
  players[p] = 0
}

const nodes: { [key: number]: MarbleNode } = {}

nodes[0] = { left: 0, right: 0 }

const marbleRightOf = (referenceMarble: number, steps: number): number => {
  let marble = referenceMarble

  for (let n = 1; n <= steps; n++) {
    marble = nodes[marble].right
  }

  return marble
}

const marbleLeftOf = (referenceMarble: number, steps: number): number => {
  let marble = referenceMarble

  for (let n = 1; n <= steps; n++) {
    marble = nodes[marble].left
  }

  return marble
}

const insertAfter = (referenceMarble: number, marble: number): void => {
  const rightMarble = nodes[referenceMarble].right

  nodes[marble] = {
    left: referenceMarble,
    right: rightMarble,
  }

  nodes[referenceMarble].right = marble
  nodes[rightMarble].left = marble
}

const remove = (marble: number): void => {
  nodes[nodes[marble].left].right = nodes[marble].right
  nodes[nodes[marble].right].left = nodes[marble].left

  delete nodes[marble]
}

let nextMarble = 1
let currentMarble = 0
let player = 1

while (nextMarble <= lastMarble) {
  if (nextMarble % 23 === 0) {
    players[player] += nextMarble

    const marbleToBeRemoved = marbleLeftOf(currentMarble, 7)

    players[player] += marbleToBeRemoved
    currentMarble = marbleRightOf(marbleToBeRemoved, 1)

    remove(marbleToBeRemoved)
  } else {
    const marbleBefore = marbleRightOf(currentMarble, 1)

    insertAfter(marbleBefore, nextMarble)

    currentMarble = nextMarble
  }

  player += 1
  nextMarble += 1

  if (player > playersCount) {
    player = 1
  }
}

console.log(Math.max(...Object.values(players)))
