fs = require('fs')

let move = function(input) {
  let position = [0, 0];
  let instructions = input.split(", ");

  // coordinate system [x, y]
  const movements = [[0, 1], [1, 0], [0, -1], [-1, 0]];
  let direction = 0   // facing north initially 

  // keep track of positions
  var history = [];

  instructions.forEach(function(step) {
    let turn = step[0];
    let blocks = step.substring(1);

    if (turn == "R") {
      direction += 1;
    } else if (turn == "L") {
      direction -= 1;
    }

    if (direction < 0) direction = 3;
    if (direction > 3) direction = 0;

    let movement = movements[direction];

    for (var i = 0; i < blocks; i++) {
      position[0] += movement[0];
      position[1] += movement[1];

      let coord = `${position[0]},${position[1]}`

      if (history.indexOf(coord) >= 0) {
        console.log(`Visited before: ${position}`);
      }

      history.push(coord);
    }
  });

  return position;
}

// test cases
console.log(move("R2, L3"));
console.log(move("R2, R2, R2"));
console.log(move("R5, L5, R5, R3"));
console.log(move("R8, R4, R4, R8"));

// input
let input = fs.readFileSync('input.txt').toString();

console.log(move(input));
