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

let buildRoom = function(firstRow, numRows, print = true) {
  let room = [firstRow.split('')];
  let trapCount = 0;

  let isTrap = (row, i) => {
    if (i < 0) return false;
    if (i > row.length - 1) return false;

    return row[i] == '^';
  }

  for (var i = 1; i < numRows; i++) {
    let prevRow = room[i-1];
    let row = [];

    for (var j = 0; j < prevRow.length; j++) {
      let left   = isTrap(prevRow, j-1); 
      let center = isTrap(prevRow, j); 
      let right  = isTrap(prevRow, j+1); 

      if ((left && center && !right) ||
          (center && right && !left) ||
          (left && !center && !right) ||
          (right && !center && !left)) {
        row.push('^');
      } else {
        row.push('.');
      }
    }

    room.push(row);
  }

  room.forEach((row) => {
    row.forEach((space) => {
      trapCount += space == '^' ? 1 : 0;
    });

    if (print) console.log(row.join(''));
  });

  console.log(`Traps: ${trapCount}, Safe: ${room.length*room[0].length - trapCount}`);
}

buildRoom('..^^.', 3);
buildRoom('.^^.^.^^^^', 10);

// Part 1
buildRoom('^^^^......^...^..^....^^^.^^^.^.^^^^^^..^...^^...^^^.^^....^..^^^.^.^^...^.^...^^.^^^.^^^^.^^.^..^.^', 40);

// Part 2
buildRoom('^^^^......^...^..^....^^^.^^^.^.^^^^^^..^...^^...^^^.^^....^..^^^.^.^^...^.^...^^.^^^.^^^^.^^.^..^.^', 400000, false);
