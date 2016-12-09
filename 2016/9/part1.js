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
  let index = 0;

  while (index < seq.length) {
    let char = seq.charAt(index);

    if (char != '(') {
      if (!char.match(/\s+/)) decompressed += char;
      index += 1;
      continue;
    }

    let markerRegEx = /(\d+)x(\d+)/;
    let markerIndexStart = index;
    let markerIndexEnd = seq.indexOf(')', index);
    let marker = seq.substring(markerIndexStart + 1, markerIndexEnd);

    let [_, length, repeat] = marker.match(markerRegEx);
    length = parseInt(length);

    let dataIndexStart = markerIndexEnd + 1;
    let dataIndexEnd = dataIndexStart + length - 1;
    
    let data = seq.substring(dataIndexStart, dataIndexEnd + 1);

    for (var i = 0; i < repeat; i++) decompressed += data;

    index = dataIndexEnd + 1;
  }

  return decompressed;
};

// Solution begins here
describe('#decompress', function() {
  it('works', function() {
    assert.equal('ADVENT', decompress('ADVENT'));
    assert.equal('XYZXYZXYZ', decompress('(3x3)XYZ'));
    assert.equal('ABCBCDEFEFG', decompress('A(2x2)BCD(2x2)EFG'));
    assert.equal('(1x3)A', decompress('(6x1)(1x3)A'));
    assert.equal('X(3x3)ABC(3x3)ABCY', decompress('X(8x2)(3x3)ABCY'));
  });
});
