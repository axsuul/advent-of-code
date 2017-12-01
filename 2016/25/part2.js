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

let getIPs = function(input) {
  let ranges = {};
  let ips = [];

  readInputLines(input, (line) => {
    let match = line.match(/(\d+)\-(\d+)/);
    console.log(match);

    ranges[parseInt(match[1])] = parseInt(match[2]);
  });

  console.log(ranges);

  let n = 0;

  while (n <= 4294967295) {
    if (ranges.hasOwnProperty(n)) {
      n = ranges[n] + 1;
    } else {
      let nn = n;

      for (let a in ranges) {
        a = parseInt(a);
        b = parseInt(ranges[a]);

        if (a <= nn && nn <= b) {
          nn = b + 1;
          break;
        }
      }

      if (n == nn) {
        ips.push(n);

        n += 1;
      } else {
        n = nn;
      }
    }
  }

  return ips;
}

console.log(getIPs('input.txt').length);
