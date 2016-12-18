var fs = require('fs');
var md5 = require('md5');

// Helpers
let readInput = function(filename) {
  return fs.readFileSync(filename).toString();
}

let readInputLines = function(filename, callback) {
  readInput(filename).split("\n").forEach(function(line) {
    if (line != "") callback(line);
  });
}

let calcPath = function(passcode) {
  // [position, steps]
  let queue = [[[0, 0], '']];

  while (data = queue.shift()) {
    let [position, steps] = data;
    let [x, y] = position;
    let hash = md5(passcode + steps);

    if (x == 3 && y == 3) {
      console.log(data);
      break;
    }

    [
      [[x, y - 1], 'U'],
      [[x, y + 1], 'D'],
      [[x - 1, y], 'L'],
      [[x + 1, y], 'R'] 
    ].forEach((movement, i) => {
      let [nextPosition, direction] = movement;
      let [x, y] = nextPosition;

      if (!hash[i].match(/b|c|d|e|f/)) return false;  // locked
      if (x < 0 || x > 3) return false;
      if (y < 0 || y > 3) return false;

      queue.push([nextPosition, steps + direction]);
    });
  }
}

calcPath('ihgpwlah');
calcPath('kglvqrro');
calcPath('ulqzkmiv');

// Part 1
calcPath('ioramepc');
