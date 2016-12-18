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

let expandDisk = function(input) {
  let a = input.toString();
  let b = a.split('').reverse().join('');


  return a + '0' + b.split('').map((c) => c == '1' ? '0' : '1').join('');

}

let fillDisk = function(input, length) {
  let disk = input;

  while (disk.length < length) {
    disk = expandDisk(disk);
  }

  return disk.substr(0, length);
}

let calcChecksum = function(str) {
  let checksum = '';

  while (true) {
    let chunks = str.match(/.{2}/g);

    let checksum = chunks.map((chunk) => { 
      if (chunk[0] == chunk[1]) {
        return '1';
      } else {
        return '0';
      }
    }).join('');

    if (checksum.length % 2 == 1) return checksum;

    str = checksum;
  }
}

let genData = function(input, length) {
  return calcChecksum(fillDisk(input, length));
}

console.log(genData('10000', 20));
console.log(genData('11110010111001001', 272));
console.log(genData('11110010111001001', 35651584));
