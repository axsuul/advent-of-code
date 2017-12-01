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
  let register = { a: 0, b: 0, c: 0, d: 0 };

  readInputLines(filename, (line) => {
    instructions.push(line.replace(/^\s+/, '').replace(/\s+$/, ''));
  });

  let getValue = function(value) {
    if (value.match(/[a-z]+/)) value = register[value];

    return parseInt(value);
  }

  let i = 0;

  while (i < instructions.length) {
    let instruction = instructions[i];

    console.log(instruction);

    let cpy = instruction.match(/cpy (\w+) (\w+)/);
    let inc = instruction.match(/inc (\w+)/);
    let dec = instruction.match(/dec (\w+)/);
    let jnz = instruction.match(/jnz (\w+) (.+)/);
    let tgl = instruction.match(/tgl (\w+)/);

    if (cpy) {
      let [, value, toRegister] = cpy; 

      if (toRegister.match(/[a-z]/)) {
        register[toRegister] = getValue(value); 
      }
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
    } else if (tgl) {
      let toggledIndex = i+getValue(tgl[1]);

      if (toggledIndex < 0 || toggledIndex > instructions.length - 1) continue;

      let toggledInstruction = instructions[toggledIndex];
      let match = toggledInstruction.match(/(\w+) (.+)/);

      let [_, cmd, args] = match;
      let newCmd;

      if (args.split(' ').length == 1) {
        newCmd = (cmd == "inc") ? "dec" : "inc";
      } else {
        newCmd = (cmd == "jnz") ? "cpy" : "jnz";
      }

      console.log(newCmd + " " + args);

      instructions[toggledIndex] = newCmd + " " + args;
    }

    i += 1;
  }

  return register;
};

console.log(evalInstructions('test.txt'));
console.log(evalInstructions('input.txt'));
