var assert = require('assert');

let sanitizeLine = function(line) {
  return line.trim().replace(/\s+/g, ' ');
}

let isValidTriangle = function(input) {
  let sides = input.split(" ").map(Number).sort(function(a, b) {
    return a - b;
  });

  return (sides[0] + sides[1]) > sides[2];
}

let countValidTriangles = function(lines) {
  let count = 0;

  lines.forEach(function(line) {
    if (isValidTriangle(sanitizeLine(line))) count += 1;
  });

  return count;
}

describe('#isValidTriangle()', function() {
  it('returns false if not valid triangle', function() {
    assert.equal(false, isValidTriangle("5 10 25"));
  });

  it('returns true if not valid triangle', function() {
    assert.equal(true, isValidTriangle("833 574 967"));
  });
});

let fs = require('fs');

let input = fs.readFileSync('input.txt').toString();
let lines = input.split("\n");

console.log(`Part 1: ${countValidTriangles(lines)}`);

let part2Lines = [];

for (var i = 0; i < lines.length; i += 3) {
  if (lines[i] === "") break;

  let line1 = sanitizeLine(lines[i]).split(" ");
  let line2 = sanitizeLine(lines[i+1]).split(" ");
  let line3 = sanitizeLine(lines[i+2]).split(" ");

  part2Lines.push(`${line1[0]} ${line2[0]} ${line3[0]}`);
  part2Lines.push(`${line1[1]} ${line2[1]} ${line3[1]}`);
  part2Lines.push(`${line1[2]} ${line2[2]} ${line3[2]}`);
}

console.log(`Part 2: ${countValidTriangles(part2Lines)}`);
