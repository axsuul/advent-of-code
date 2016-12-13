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

let evalInstructions = function(filename) {
  let instructions = [];
  let register = { a: 0, b: 0, c: 1, d: 0 };

  readInputLines(filename, (line) => {
    instructions.push(line);
  });

  let getValue = function(value) {
    if (value.match(/[a-z]+/)) value = register[value];

    return parseInt(value);
  }

  let i = 0;

  while (i < instructions.length) {
    //console.log(register);
    //console.log(i);

    let instruction = instructions[i];
    //console.log(instruction);
    let cpy = instruction.match(/cpy (\w+) (\w+)/);
    let inc = instruction.match(/inc (\w+)/);
    let dec = instruction.match(/dec (\w+)/);
    let jnz = instruction.match(/jnz (\w+) (.+)/);

    if (cpy) {
      let [, value, toRegister] = cpy; 

      register[toRegister] = getValue(value); 
    } else if (inc) {
      register[inc[1]] += 1;  
    } else if (dec) {
      register[dec[1]] -= 1;  
    } else if (jnz) {
      let [, x, y] = jnz;

      if (getValue(x) != 0) {
        i += parseInt(y);
        continue;
      }
    }

    i += 1;
  }

  return register;
};

let testRegister = evalInstructions('test.txt');

console.log(testRegister);

let register = evalInstructions('input.txt');

console.log(register);
