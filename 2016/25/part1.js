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

let swapPos = function(input, pos1, pos2) {
  let [posA, posB] = [pos1, pos2].sort();

  return input.substring(0, posA) + 
         input.charAt(posB) + 
         input.substring(posA + 1, posB) +
         input.charAt(posA) +
         input.substring(posB + 1, input.length);
}

let swapLet = function(input, let1, let2) {
  return swapPos(input, input.indexOf(let1), input.indexOf(let2));
}

let rotateSteps = function(input, direction, steps) {

}

let reverse = function(input, pos1, pos2) {
  return input.substring(0, pos1) +
         input.substring(pos1, pos2 + 1).split('').reverse().join('') +
         input.substring(pos2 + 1, input.length);
}

let genPass = function(initialInput, instructions) {
  let input = initialInput;

  readInputLines(instructions, (line) => {
    let swapPosMatch = line.match(/swap position (\d+) with position (\d+)/);
    let swapLetMatch = line.match(/swap letter (\w+) with letter (\w+)/);
    let rotateStepsMatch = line.match(/rotate (left|right) (\d+) steps/);
    let rotatePosMatch = line.match(/rotate based on position of letter (\w+)/);
    let reverseMatch = line.match(/reverse positions (\d+) through (\d+)/);
    let moveMatch = line.match(/move position (\d+) to position (\d+)/);

    if (swapPosMatch) {
      input = swapPos(input, parseInt(swapPosMatch[1]), parseInt(swapPosMatch[2]));
    } else if (swapLetMatch) {
      input = swapLet(input, swapLetMatch[1], swapLetMatch[2]);
    } else if (rotateStepsMatch) {
      input = rotatePos(input, rotatePosMatch[1], rotatePosMatch[2]);
    } else if (rotatePosMatch) {
    } else if (reverseMatch) {
      input = reverse(input, parseInt(reverseMatch[1]), parseInt(reverseMatch[2]));
    } else if (moveMatch) {
    }

    console.log(input);
  });

  return input;
}

console.log(genPass('abcde', 'test.txt'));

console.log('---');

console.log(swapPos('abcd', 0, 1));
console.log(swapPos('abcd', 1, 0));
console.log(swapPos('abcde', 4, 0));
console.log(swapPos('abcde', 0, 4));
console.log(swapLet('ebcda', 'd', 'b'));
console.log(swapLet('ebcda', 'd', 'b'));
console.log(swapLet('ebcda', 'd', 'b'));
console.log('rev' + reverse('abcde', 2, 4));

