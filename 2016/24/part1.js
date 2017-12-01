var fs = require('fs');

// Helpers
let readInput = function(filename) {
  return fs.readFileSync(filename).toString();
}

let readInputLines = function(filename, callback) {
  readInput(filename).split("\n").forEach(function(line, i) {
    if (line != "") callback(line, i);
  });
}

let mapRobot = function(input) {
  let map = {};
  let pointsCount = 1;
  let start;

  readInputLines(input, (line, y) => {
    line.split('').forEach((space, x) => {
      if (!map[y]) map[y] = {};

      map[y][x] = space;

      if (space == '0') {
        start = [x, y];
      } else if (space.match(/\d+/)) {
        pointsCount += 1; // include 0
      }
    });
  });

  let history = {};
  let queue = [{ points: [], story: {}, steps: [start]}];

  // BFS
  while (attempt = queue.shift()) {
    let steps = attempt.steps;
    let points = attempt.points;
    let [x, y] = steps[steps.length - 1];
    let space = map[y][x];

    let pointsIndex = points.join('');

    if (space.match(/\d+/)) {
      if (points.indexOf(space) < 0) {
        points = points.concat([space]);
        pointsIndex = points.join('');

        // Create history for this type of path
        history[pointsIndex] = {};

        console.log(points);

        if (points.length == pointsCount) {
          return { count: steps.length - 1, steps: steps }; 
        }
      }
    }

    // Add to history
    if (!history[pointsIndex].hasOwnProperty(y)) history[pointsIndex][y] = {};
    history[pointsIndex][y][x] = true;

    [
      [x + 1, y],
      [x - 1, y],
      [x, y + 1],
      [x, y - 1]
    ].forEach((nextStep) => {
      let [nextX, nextY] = nextStep;

      if (!map.hasOwnProperty(nextY)) return;
      if (!map[nextY].hasOwnProperty(x)) return;
      if (history[pointsIndex].hasOwnProperty(nextY) && history[pointsIndex][nextY].hasOwnProperty(nextX)) return;

      let nextSpace = map[nextY][nextX];

      if (nextSpace == '#') return;

      queue.push({ points: points, steps: steps.concat([nextStep]) });
    });
  }
}

console.log(mapRobot('test.txt'));
console.log(mapRobot('input.txt'));
