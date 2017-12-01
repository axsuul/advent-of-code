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

let unzipAfter = function(el, zipped) {
  let unzipped = [];

  let i = zipped.indexOf(el) + 1;

  unzipped = unzipped.concat(zipped.slice(i, zipped.length - 1));
  unzipped = zipped.slice(0, i - 1).concat(unzipped);

  return unzipped;
}

let calcDuration = function(label, f) {
  const start = +new Date();
  let result = f();
  const end = +new Date();

  console.log(`${label}: Took ${end - start} ms`);

  return result;
}

let givePresents = function(elvesCount) {
  let elves = {};

  for (let elf = 0; elf < elvesCount; elf++) {
    elves[elf] = 1; 
  }

  let elf = 0;

  while (true) {
    let presentsCount = elves[elf];
    let remainElves = calcDuration('keys', () => Object.keys(elves));
    let remainElvesCount = remainElves.length;

    console.log(`Remaining: ${remainElvesCount}`);

    if (remainElves.length == 1) {
      console.log(`Elf ${elf + 1} has ${elvesCount} presents`);
      break;
    }

    if (presentsCount > 0) {
      let oppElf;

      calcDuration('unzip', () => {
      remainElvesAfter = unzipAfter(elf.toString(), remainElves);
      });

      if (remainElvesAfter.length == 1) {
        oppElf = remainElvesAfter[0];
      } else {

        let remainElvesAfterCount = remainElvesAfter.length;

        if (remainElvesAfterCount % 2 == 0) {
          oppElf = remainElvesAfter[(remainElvesAfterCount/2)];

        } else {
          oppElf = remainElvesAfter[(Math.floor(remainElvesAfterCount/2) - 1)];
        }
      }

      console.log("test");
      delete elves[oppElf];
      console.log("test2");

    }

    elf += 1;

    if (elf > elvesCount - 1) elf = 0;
  }
}

givePresents(5);
givePresents(3001330);
