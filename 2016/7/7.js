var assert = require('assert');
var fs = require('fs');

let readInputLines = function(filename, callback) {
  let input = fs.readFileSync(filename).toString();

  input.split("\n").forEach(function(line) {
    if (line != "") callback(line);
  });
}

let parse = function(ip) {
  let regulars = [];
  let brackets = [];

  ip.split('[').forEach(function(segment) {
    if (segment.match(/\]/)) {
      brackets.push(segment.split(']')[0]);
      regulars.push(segment.split(']')[1]);
    } else {
      regulars.push(segment);
    }
  });

  return [regulars, brackets];
}

let supportsTLS = function(ip) {
  const [regulars, brackets] = parse(ip);

  let abbaFound = false;
  let abbaBracketFound = false;

  let hasAbba = function(str) {
    for (var i = 0; i < str.length - 3; i++) {
      let abba = str.substring(i, i + 4);

      if ((abba[0] != abba[1]) &&
          (abba[0] + abba[1]) == (abba[3] + abba[2])) {
        return true;
      }
    }

    return false;
  }

  regulars.forEach(function(s) { if (hasAbba(s)) abbaFound = true });
  brackets.forEach(function(s) { if (hasAbba(s)) abbaBracketFound = true });

  return abbaFound && !abbaBracketFound; 
}

let supportsSSL = function(ip) {
  const [regulars, brackets] = parse(ip);

  let aba = [];
  let bab = [];
  let supports = false;

  let buildPairs = function(str, callback) {
    for (var i = 0; i < str.length - 2; i++) {
      let pair = str.substring(i, i + 3);

      if ((pair[0] != pair[1]) &&
          (pair[0] == pair[2])) {
        callback(pair);
      }
    }
  };

  regulars.forEach(function(str) {
    buildPairs(str, (pair) => aba.push(pair));
  });

  brackets.forEach(function(str) {
    buildPairs(str, (pair) => bab.push(pair));
  });

  aba.forEach(function(eachAba) {
    bab.forEach(function(eachBab) {
      if (eachAba[0] == eachBab[1] && eachAba[1] == eachBab[0]) {
        supports = true;
        return;
      }
    });
  });

  return supports;
}

describe('#supportsTLS()', function() {
  it('returns true if supports', function() {
    assert.equal(true, supportsTLS("abba[mnop]qrst"));
    assert.equal(false, supportsTLS("abcd[bddb]xyyx"));
    assert.equal(false, supportsTLS("aaaa[qwer]tyui"));
    assert.equal(true, supportsTLS("ioxxoj[asdfgh]zxcvbn"));
	});
});

describe('#supportsSSL()', function() {
  it('returns true if supports', function() {
    assert.equal(true, supportsSSL("aba[bab]xyz"));
    assert.equal(false, supportsSSL("xyx[xyx]xyx"));
    assert.equal(true, supportsSSL("aaa[kek]eke"));
    assert.equal(true, supportsSSL("zazbz[bzb]cdb"));
	});
});

var tlsCount = 0;
var sslCount = 0;

readInputLines("input.txt", function(line) {
  if (supportsTLS(line)) tlsCount += 1;
  if (supportsSSL(line)) sslCount += 1;
});

console.log(`Num. TLS supported: ${tlsCount}`);
console.log(`Num. SSL supported: ${sslCount}`);
