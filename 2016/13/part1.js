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

let buildMaze = function(favNum, size) {
  let maze = [];

  for (var y = 0; y < size; y++) {
    let row = [];

    for (var x = 0; x < size; x++) {
      let z = x*x + 3*x + 2*x*y + y + y*y;
      let sum = z + favNum;
      let binary = (sum >>> 0).toString(2);
      let numBits = binary.match(/1/g).length;

      if (numBits % 2 == 1) {
        row.push('#');
      } else {
        row.push('.');
      }
    }

    maze.push(row);
  }

  return maze;

}

let printMaze = function(maze, solution = []) {
  let header = "  ";

  for (var i = 0; i < maze.length; i++) { header += i.toString() }

  console.log(header);

  maze.forEach((row, y) => {
    let line = y + ' ';
    
    row.forEach((space, x) => {
      let output = space;

      solution.forEach((s) => {
        if (x == s[0] && y == s[1]) {
          output = 'O';
        }      
      });

      line += output;
    });

    console.log(line);
  });
}

// Uses BFS (Breadth First Search)
let solveMaze = function(destX, destY, maze) {
  let solution = [];
  let mazeHistory = {};

  maze.forEach((row, y) => {
    mazeHistory[y] = {};

    row.forEach((_, x) => { mazeHistory[y][x] = false });
  });

  let queue = [[[1, 1]]]; // Start at [1, 1]
  
  while (steps = queue.shift()) {
    let step = steps[steps.length - 1];
    let [x, y] = step;

    mazeHistory[y][x] = true;

    if (x == destX && y == destY) {
      solution = steps;
      break;
    }

    // Find positions around that can move to
    let nextSteps = [[x, y+1], [x, y-1], [x+1, y], [x-1, y]].filter((nextStep) => {
      let [x, y] = nextStep;

      if (x < 0 || y < 0) return false;
      if (maze.hasOwnProperty(y)) {
        if (!maze[y].hasOwnProperty(x)) return false;  
        if (mazeHistory[y][x]) return false;
        if (maze[y][x] == '#') return false;
      } else {
        return false;
      }

      return true;
    });

    nextSteps.forEach((nextStep) => {
      let allSteps = steps.concat([nextStep]);
      queue.push(allSteps);
    });
  };

  return solution;
};

let doPart1 = function(dest, favNum) {
  for (var i = 2; i < 10000; i++) {
    console.log("Trying maze of size " + i.toString());

    let maze = buildMaze(favNum, i);
    let solution = solveMaze(dest[0], dest[1], maze);

    if (solution.length > 0) {
      printMaze(maze, solution);
      console.log("Steps: " + (solution.length - 1).toString());
      break;
    }
  }
};

//doPart1([7, 4], 10);
doPart1([31, 39], 1362);

