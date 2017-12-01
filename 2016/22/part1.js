var fs = require('fs');

// Helpers
let readInput = function(filename) {
  return fs.readFileSync(filename).toString();
}

let readInputLines = function(filename, callback) {
  readInput(filename).split("\n").forEach(function(line) {
    if (line != "") callback(line);
  });
}

let nodes = {};

readInputLines('input.txt', (line, i) => {
  let match = line.match(/\/dev\/grid\/node\-x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T/);

  if (match) {
    let [_, x, y, size, used, avail] = match;

    if (!nodes[y]) nodes[y] = {};
    nodes[y][x] = { size: parseInt(size), used: parseInt(used), avail: parseInt(avail) };
  }
});

let getViablePairs = function(nodes) {
  let viableTable = {};
  let viablePairs = [];

  let pairIndex = function(node1, node2) {
    return [node1, node2].sort((a, b) => {
      if (a[0] < b[0]) {
        return -1;
      } else if (a[0] == b[0]) {
        return a[1] - b[1];
      } else {
        return 1;
      }
    }).map((n) => `x${n[0]}y${n[1]}`).join('-');
  }

  for (let y in nodes) {
    for (let x in nodes[y]) {
      let nodeA = nodes[y][x];

      if (nodeA.used == 0) continue;

      for (let yy in nodes) {
        for (let xx in nodes[yy]) {
          let nodeB = nodes[yy][xx];

          if (x == xx && y == yy) continue;
          if (nodeB.avail < nodeA.used) continue;

          viablePairs.push({ nodeA: nodeA, nodeB: nodeB });
        }
      }
    }
  }

  return viablePairs;
}

pairs = getViablePairs(nodes);

console.log(pairs.length);
