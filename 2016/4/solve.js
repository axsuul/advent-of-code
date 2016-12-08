var assert = require('assert');
var fs = require('fs');

let readInputLines = function(callback) {
  let input = fs.readFileSync('input.txt').toString();

  input.split("\n").forEach(function(line) {
    if (line != "") callback(line);
  });
}

let sanitizeLine = function(line) {
  return line.trim().replace(/\s+/g, ' ');
}

let analyzeRoom = function(room) {
	let match = room.match(/(.+)\-(\d+)\[(\w+)\]/);

	let name = match[1];
	let sectorId = parseInt(match[2]);
	let checksum = match[3];

	let chars = {};

	// Count chars
  name.split('').forEach(function(char) {
		if (char == '-') return;

		if (!chars[char]) chars[char] = 0;

		chars[char] += 1;
  });

	// Convert object into sorted array by charCode, count
	charsSorted = Object.keys(chars).sort(function(a, b) {
		// If same count, sort by char code
		if (chars[a] == chars[b]) {
			return a.charCodeAt(0) - b.charCodeAt(0);

		// Otherwise, sort by count
		} else {
			return chars[b] - chars[a];			
    }
  });

	realChecksum = charsSorted.join('').substring(0, checksum.length); 

  return {
    real: checksum == realChecksum,
    sectorId: sectorId
  }
}

let decryptChar = function(char, times) {
  let charCode = char.charCodeAt(0);

  for (var i = 0; i < times; i++) {
    if (charCode == 45) {
      charCode = 32;
    } else if (charCode == 32) {
      charCode = 45;
    } else {
      charCode += 1; 

      if (charCode > 122) charCode = 97;
    }
  }

  return String.fromCharCode(charCode);
};

let decryptRoom = function(room) {
	let match = room.match(/(.+)\-(\d+)\[(\w+)\]/);

	let name = match[1];
	let sectorId = parseInt(match[2]);
	let checksum = match[3];

  return name.split('').map(function(char) {
    return decryptChar(char, sectorId);
  }).join('');
};

describe('#analyzeRoom()', function() {
  it('returns true if real room', function() {
		assert.deepEqual({ real: true, sectorId: 123 }, analyzeRoom("aaaaa-bbb-z-y-x-123[abxyz]")); 
		assert.deepEqual({ real: true, sectorId: 987}, analyzeRoom("a-b-c-d-e-f-g-h-987[abcde]")); 
		assert.deepEqual({ real: true, sectorId: 404 }, analyzeRoom("not-a-real-room-404[oarel]")); 
		assert.deepEqual({ real: false, sectorId: 200 }, analyzeRoom("totally-real-room-200[decoy]")); 
		assert.deepEqual({ real: true, sectorId: 561 }, analyzeRoom("aczupnetwp-dnlgpyrpc-sfye-dstaatyr-561[patyc]")); 
	});
});

describe('#decryptRoom()', function() {
  it('returns true if real room', function() {
    assert.equal("very encrypted name", decryptRoom("qzmt-zixmtkozy-ivhz-343[123]"));
	});
});

let sectorIdSum = 0;

readInputLines(function(line) {
  let result = analyzeRoom(line);

  if (result.real) {
    sectorIdSum += result.sectorId;
  }

  // mocha 4.js | grep north
  console.log(`${result.sectorId} => ${decryptRoom(line)}`);
});

console.log(`The sum is ${sectorIdSum}`);
