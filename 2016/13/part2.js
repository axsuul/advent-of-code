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

  maze.forEach((row, y) => {
    let line = '';
    
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
let solveMaze = function(stepsCount, maze) {
  let mazeHistory = {};
  let coords = [];

  maze.forEach((row, y) => {
    mazeHistory[y] = {};

    row.forEach((_, x) => { mazeHistory[y][x] = false });
  });

  let queue = [[[1, 1]]]; // Start at [1, 1]
  
  while (steps = queue.shift()) {
    let step = steps[steps.length - 1];
    let [x, y] = step;

    mazeHistory[y][x] = true;

    if (steps.length == stepsCount + 1) {
      console.log(`Reached ${x}, ${y} in ${steps.length} steps`);
      continue;
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

  for (var y in mazeHistory) {
    for (var x in mazeHistory[y]) {
      if (mazeHistory[y][x]) coords.push([x,y]);
    }
  }

  return coords;
};

let doPart2 = function(minSteps, favNum) {
  let maze = buildMaze(favNum, minSteps);
  let coords = solveMaze(minSteps, maze);

  printMaze(maze, coords);
  console.log("Unique Coords: " + coords.length);
}

doPart2(50, 1362);

