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

let state = { E: 1 };

readInputLines('input.txt', function(line) {
  let floorName = line.match(/(\w+) floor/)[1];
  let floor;

  switch (floorName) {
    case 'first':
      floor = 1;
      break;
    case 'second':
      floor = 2;
      break;
    case 'third':
      floor = 3;
      break;
    case 'fourth':
      floor = 4;
      break;
  };


  let genRegEx = /(\w+) generator/g;
  let chipRegEx = /(\w+)-compatible microchip/g;
  let matched;

  while (matched = genRegEx.exec(line)) {
    state[matched[1].substr(0, 2).toUpperCase() + 'G'] = floor;
  }

  while (matched = chipRegEx.exec(line)) {
    state[matched[1].substr(0, 2).toUpperCase() + 'M'] = floor;
  }
});


let getFloorItems = function(state, floor) {
  let items = [];

  for (var item in state) {
    if (item != 'E' && state[item] == floor) items.push(item)
  }

  return items;
}

let getCombinations = function(items, max = 2) {
  let combos = [];

  let f = function(a, b) {
    for (var i = 0; i < b.length; i++) {
      let c = a.concat(b[i]);

      combos.push(c);

      if (c.length < max) f(c, b.slice(i + 1, b.length));
    }
  }

  f([], items);

  return combos;
}

let getElevatorCombinations = function(state, floor) {
  return getCombinations(getFloorItems(state, floor), 2);
};

let isValidState = function(state) {
  for (var item in state) {
    if (item.substr(item.length - 1) == "M") {
      let element = item.substr(0, 2);
      let otherGenFound = false; 
      let thisGenFound = false;

      getFloorItems(state, state[item]).forEach(function(gen) {
        if (gen.substr(gen.length - 1) != "G") return;

        if (gen.substr(0, 1) == item.substr(0, 1)) {
          thisGenFound = true;
        } else {
          otherGenFound = true;
        }
      });

      if (otherGenFound && !thisGenFound) return false;
    }
  }

  return true;
};

let printState = function(state) {
  for (var floor = 4; floor > 0; floor--) {
    let items = Object.keys(state).filter((item) => item != 'E').sort();
    let line = `F${floor} `;

    if (state.E == floor) {
      line += "E  ";
    } else {
      line += ".  ";
    }

    items.forEach(function(item) {
      if (state[item] == floor) {
        line += item + " ";
      } else {
        line += ".   ";
      }
    });

		console.log(line);
  }
}

let printStates = function(states) {
  states.forEach(function(state) {
    printState(state);
    console.log("----------------");
  });
}

let stateToKey = function(state) {
  return Object.keys(state).sort((a, b) => a < b ? -1 : 1)
                           .map((i) => `${i}${state[i]}`)
                           .join('');
};

// BFS
let solveBreadth = function(state, callback) {
  let stateHistory = {};
  let breadth = 1;

	// queue is array of [[state, prevStates], ...]
	let solveNextBreadth = function(queue, callback) {
		while (item = queue.shift()) {
      let [state, prevStates] = item;
      let key = stateToKey(state);

      if (stateHistory[key]) {
        continue;

      } else {
        stateHistory[key] = true;
      }

      if (prevStates.length + 1 > breadth) {
        breadth = prevStates.length + 1;

        console.log(`Breadth: ${breadth}`);
      }

      let nextFloors = [];
      let floor = state.E;

      if (floor == 4 && (getFloorItems(state, 4).length == Object.keys(state).length - 1)) {
        console.log(Object.keys(stateHistory).length);
        callback(prevStates.concat(state));
        break;
      }

      if (floor != 4) nextFloors.push(floor + 1);
      if (floor != 1) nextFloors.push(floor - 1);

      // Calculate permutations
      nextFloors.forEach(function(nextFloor) {
        let combos = getElevatorCombinations(state, floor);

        combos.forEach(function(combo) {
          let nextState = Object.assign({}, state);

          combo.forEach(function(item) {
            nextState[item] = nextFloor;
          });

          nextState.E = nextFloor;

          if (isValidState(nextState)) {
            let newPrevStates = prevStates.concat(state);

            queue.push([nextState, newPrevStates]);
          }
        });
      });
		}
  }

  solveNextBreadth([[state, []]], callback);
}

let testState = {
  E: 1,
  HYG: 2,
  HYM: 1,
  LIG: 3,
  LIM: 1
}

let part2State = Object.assign({}, state);

part2State.ELG = 1;
part2State.ELM = 1;
part2State.DIG = 1;
part2State.DIM = 1;

solveBreadth(state, function(solution) {
  printStates(solution);
  console.log(`Steps: ${solution.length - 1}`);
});
