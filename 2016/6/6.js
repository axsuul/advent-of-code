var assert = require('assert');
var fs = require('fs');

let readInputLines = function(filename, callback) {
  let input = fs.readFileSync(filename).toString();

  input.split("\n").forEach(function(line) {
    if (line != "") callback(line);
  });
}

let sanitizeLine = function(line) {
  return line.trim().replace(/\s+/g, ' ');
}

let decipherMessage = function(filename) {
  chars = [];
  message1 = "";
  message2 = "";

  readInputLines(filename, function(line) {
    if (chars.length == 0) {
      for (var i = 0; i < line.length; i++) {
        chars.push({});
      }
    }

    line.split('').forEach(function(char, i) {
      if (!chars[i][char]) chars[i][char] = 0;

      chars[i][char] += 1;
    });
  });

  chars.forEach(function(colChar) {
    sorted = Object.keys(colChar).sort((a, b) => colChar[b] - colChar[a]);

    message1 += sorted[0];
    message2 += sorted[sorted.length - 1];
  });

  return [message1, message2];
}

describe('#decipherMessage()', function() {
  it('deciphers message from file', function() {
    assert.deepEqual(["easter", "advent"], decipherMessage("test.txt"));
	});
});

console.log(decipherMessage("input.txt"));
