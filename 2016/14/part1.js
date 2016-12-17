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

let findKeys = function(salt, n) {
  let index = 0;
  let keys = [];

  let findRepeating = function(num, str) {
    let repeats = [];
    let lastChar;
    let charCount;

    str.split('').forEach((c) => {
      if (lastChar != c) {
        lastChar = c;
        charCount = 1;
      } else {
        charCount += 1;
      }

      if (charCount == num) repeats.push(c);
    });

    return repeats;
  }

  while (keys.length < n) {
    let hash = md5(salt + index);
    let threePeats = findRepeating(3, hash);

    //console.log(`At key: ${index}`);

    if (threePeats.length > 0) {
      let char = threePeats[0];

      for (var j = index + 1; j < index + 1000; j++) {
        let fivePeats = findRepeating(5, md5(salt + j));

        if (fivePeats.indexOf(char) >= 0) {
          console.log(`Found key at ${index}`);
          keys.push([index, hash]);
          break;
        }
      }
    }

    index += 1;
  }

  return keys;
}

keys = findKeys('ihaygndm', 64);

console.log(keys);



