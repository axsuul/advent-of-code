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

let givePresents = function(elvesCount) {
  let elves = {};

  for (let elf = 0; elf < elvesCount; elf++) {
    elves[elf] = 1; 
  }

  let elf = 0;

  while (true) {
    let presentsCount = elves[elf];

    if (presentsCount == elvesCount) {
      console.log(`Elf ${elf + 1} has ${elvesCount} presents`);
      break;
    }

    if (presentsCount > 0) {
      let nextElf = elf + 1;

      while (nextElf != elf) {
        if (nextElf > elvesCount - 1) {
          nextElf = 0;
          continue;
        }

        if (elves[nextElf] > 0) {
          elves[elf] += elves[nextElf];
          elves[nextElf] = 0;
          break;
        }

        nextElf += 1;
      }
    }

    elf += 1;

    if (elf > elvesCount - 1) elf = 0;
  }
}

givePresents(5);
givePresents(3001330);
