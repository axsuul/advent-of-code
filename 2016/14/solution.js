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

let findKeys = function(salt, n, stretch = 1) {
  let md5Cache = {};
  let index = 0;
  let keys = [];

  let hashString = function(str) {
    if (md5Cache.hasOwnProperty(str)) return md5Cache[str];

    let hash = str;

    for (var i = 0; i < stretch; i++) {
      hash = md5(hash);
    }
    
    md5Cache[str] = hash;

    return hash;
  }

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
    let hash = hashString(salt + index);
    let threePeats = findRepeating(3, hash);

    if (threePeats.length > 0) {
      let char = threePeats[0];

      for (var j = index + 1; j < index + 1000; j++) {
        let fiveHash = hashString(salt + j);
        let fivePeats = findRepeating(5, fiveHash);

        if (fivePeats.indexOf(char) >= 0) {
          console.log(`Found key at ${index} - ${j}: ${hash}`);
          keys.push([index, hash]);
          break;
        }
      }
    }

    index += 1;
  }

  return keys;
}

let input = 'ihaygndm';
//let input = 'abc';

// Part 1
keys = findKeys(input, 64);
console.log(keys);

// Part 2
keys = findKeys(input, 64, 2017);
console.log(keys);
