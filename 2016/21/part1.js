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

let readInputLinesReverse = function(filename, callback) {
  readInput(filename).split("\n").reverse().forEach(function(line, i) {
    if (line != "") callback(line, i);
  });
}

let replaceCharAt = function(input, pos, char) {
  return input.substring(0, pos) + char + input.substring(pos + 1, input.length);
}

let swapPos = function(input, pos1, pos2) {
  let [posA, posB] = [pos1, pos2].sort();

  return replaceCharAt(replaceCharAt(input, posA, input.charAt(posB)), posB, input.charAt(posA));
}

let swapLet = function(input, let1, let2) {
  return swapPos(input, input.indexOf(let1), input.indexOf(let2));
}

let rotateSteps = function(initialInput, direction, steps) {
  let input = initialInput;

  if (steps == 0) return initialInput;

  for (var i = 0; i < input.length; i++) {
    let j = i;

    if (direction == 'left') {
      j -= 1;

      if (j < 0) j = input.length - 1;
    } else {
      j += 1;

      if (j > input.length - 1) j = 0;
    }

    input = replaceCharAt(input, j, initialInput[i]);
  }

  if (steps > 1) {
    return rotateSteps(input, direction, steps - 1);
  } else {
    return input;
  }
}

let rotatePos = function(input, char, direction = 'right') {
  let index = input.indexOf(char);
  let steps = 1 + index;

  if (index >= 4) steps += 1;

  return rotateSteps(input, direction, steps);
}

let reverse = function(input, pos1, pos2) {
  return input.substring(0, pos1) +
         input.substring(pos1, pos2 + 1).split('').reverse().join('') +
         input.substring(pos2 + 1, input.length);
}

let move = function(input, from, to) {
  let char = input.charAt(from);
  let gone = replaceCharAt(input, from, '');
  let moved = "";

  gone.split('').forEach((c, i) => {
    if (i == to) moved += char;

    moved += c;
  });

  if (to == input.length - 1) moved += char;

  return moved;
}

let genPass = function(initialInput, instructions) {
  let input = initialInput;

  readInputLines(instructions, (line, i) => {
    let swapPosMatch = line.match(/swap position (\d+) with position (\d+)/);
    let swapLetMatch = line.match(/swap letter (\w+) with letter (\w+)/);
    let rotateStepsMatch = line.match(/rotate (left|right) (\d+) steps?/);
    let rotatePosMatch = line.match(/rotate based on position of letter (\w+)/);
    let reverseMatch = line.match(/reverse positions (\d+) through (\d+)/);
    let moveMatch = line.match(/move position (\d+) to position (\d+)/);

    if (swapPosMatch) {
      input = swapPos(input, parseInt(swapPosMatch[1]), parseInt(swapPosMatch[2]));
    } else if (swapLetMatch) {
      input = swapLet(input, swapLetMatch[1], swapLetMatch[2]);
    } else if (rotateStepsMatch) {
      input = rotateSteps(input, rotateStepsMatch[1], parseInt(rotateStepsMatch[2]));
    } else if (rotatePosMatch) {
      input = rotatePos(input, rotatePosMatch[1]);
    } else if (reverseMatch) {
      input = reverse(input, parseInt(reverseMatch[1]), parseInt(reverseMatch[2]));
    } else if (moveMatch) {
      input = move(input, parseInt(moveMatch[1]), parseInt(moveMatch[2]));
    } else {
      console.log("Unrecognized");
    }
  });

  return input;
}

let getCombinations = function(arr, k = []) {
	let combos, remaining;

	if (arr.length == 0) return [k];

	combos = [];

	arr.forEach((e, i) => {
		remaining = arr.slice(0, i == 0 ? 0 : i).concat(arr.slice(i + 1, arr.length));

		getCombinations(remaining, k.concat(e)).forEach((combo) => {
			combos.push(combo);
		});
	});

	return combos;
}

let unscramblePass = function(password, instructions) {
	let combos = getCombinations(password.split(''));
	let unscrambleds = [];

	while (combo = combos.shift()) {
		let unscrambled = combo.join('');
		let pw = genPass(unscrambled, instructions);

		if (pw == password) {
			unscrambleds.push(unscrambled);
		}
	}

	return unscrambleds;

};

console.log(genPass('abcdefgh', 'input.txt'));
console.log(unscramblePass('fbgdceah', 'input.txt'));
