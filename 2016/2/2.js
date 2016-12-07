var assert = require('assert');

let findCode = function(instructions, keypadType = 1) {
  let position, keypad;

  // start at 5
  if (keypadType == 1) {
    keypad = [
      ["1", "2", "3"],
      ["4", "5", "6"],
      ["7", "8", "9"]
    ];
    position = [1, 1];

  } else if (keypadType == 2) {
    keypad = [
      [null, null, "1", null, null],
      [null, "2",  "3", "4",  null],
      ["5",  "6",  "7", "8",   "9"],
      [null, "A",  "B", "C",  null],
      [null, null, "D", null, null]
    ];
    position = [0, 2];
  }

  let code = "";

  // Check if keypad doesn't have key at position
  let keypadWithout = function(position) {
    let row = keypad[position[0]];

    if (row == null) return true;

    return row[position[1]] == null;
  }

  instructions.split("\n").forEach(function(line) {
    if (line === "") return;

    line.split("").forEach(function(move) {
      switch (move) {
        case 'U':
          position[1] -= 1;
          if (keypadWithout(position)) position[1] += 1;
          break;
        case 'R':
          position[0] += 1;
          if (keypadWithout(position)) position[0] -= 1;
          break;
        case 'D':
          position[1] += 1;
          if (keypadWithout(position)) position[1] -= 1;
          break;
        case 'L':
          position[0] -= 1;
          if (keypadWithout(position)) position[0] += 1;
          break;
      }
    });

    code += keypad[position[1]][position[0]];
  });

  return code;
};

describe('#findCode()', function() {
  it('returns keypad code from instructions', function() {
    assert.equal("1985", findCode("ULL\nRRDDD\nLURDL\nUUUUD"));
  });

  it('returns keypad code from instructions using second keypad type', function() {
    assert.equal("5DB3", findCode("ULL\nRRDDD\nLURDL\nUUUUD", 2));
  });
});

let fs = require('fs');

let input = fs.readFileSync('input.txt').toString();

console.log(findCode(input));
console.log(findCode(input, 2));
