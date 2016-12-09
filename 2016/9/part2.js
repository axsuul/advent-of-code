var assert = require('assert');
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

let decompress = function(seq) {
  let decompressed = "";
  let length = 0;
  let index = 0;
  let markerRegEx = /(\d+)x(\d+)/;

  while (index < seq.length) {
    let char = seq.charAt(index);

    if (char != '(') {
      if (!char.match(/\s+/)) {
        decompressed += char;
        length += 1;
      }

      index += 1;
      continue;
    }

    let markerIndexStart = index;
    let markerIndexEnd = seq.indexOf(')', index);
    let marker = seq.substring(markerIndexStart + 1, markerIndexEnd);

    let [_, markerLength, repeat] = marker.match(markerRegEx);
    markerLength = parseInt(markerLength);

    let dataIndexStart = markerIndexEnd + 1;
    let dataIndexEnd = dataIndexStart + markerLength - 1;
    
    let data = seq.substring(dataIndexStart, dataIndexEnd + 1);

    //if (data.match(markerRegEx)) {
      data = decompress(data);

      for (var i = 0; i < repeat; i++) {
        if (!isNaN(parseInt(data))) {
          length += data;
        } else {
          decompressed += data;
          length += data.length;
        }
      }
    //}

    index = dataIndexEnd + 1;
  }

  if (decompressed.match(markerRegEx)) return decompressed;
  
  return length;
};

// Solution begins here
describe('#decompress', function() {
  it('returns length of decompressed for v2', function() {
    assert.equal(9, decompress('(3x3)XYZ'));
    assert.equal(20, decompress('x(8x2)(3x3)abcy'));
    assert.equal(241920, decompress('(27x12)(20x12)(13x14)(7x10)(1x12)a'));
    assert.equal(445, decompress('(25x3)(3x3)abc(2x3)xy(5x2)pqrstx(18x9)(3x2)two(5x7)seven'));
  });
});

let length = decompress(readInput('input.txt'));

console.log(length);
