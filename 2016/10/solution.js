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

let bots = {};
let outputs = {};

let initializeBot = function(n) {
  if (!bots[n]) {
    bots[n] = {
      values: [],
      low: null,
      high: null
    };
  }

  return bots[n];
}

let initializeOutput = function(n) {
  if (!outputs[n]) {
    outputs[n] = {
      value: null,
    };
  }

  return outputs[n];
}

let giveValue = function(recipient, value) {
  let match1 = recipient.match(/bot(\d+)/);
  let match2 = recipient.match(/output(\d+)/);
  
  if (match1) giveBotValue(match1[1], value);
  if (match2) giveOutputValue(match2[1], value);
}

let giveOutputValue = function(n, value) {
  initializeOutput(n);

  outputs[n].value = parseInt(value);
}

let giveBotValue = function(n, value) {
  initializeBot(n);

  bots[n].values.push(parseInt(value));

  processBot(n);
}

let processBot = function(n) {
  let bot = bots[n];

  if (bot.values.length == 2 &&
      bot.low != null &&
      bot.high != null) {

    let values = bot.values.sort((a, b) => a - b);

    giveValue(bot.low, values[0]);
    giveValue(bot.high, values[1]);
  }
};

readInputLines('input.txt', (line) => {
  let match1 = line.match(/bot (\d+) gives low to (bot|output) (\d+) and high to (bot|output) (\d+)/);
  let match2 = line.match(/value (\d+) goes to bot (\d+)/);

  if (match1) {
    initializeBot(match1[1]);

    bots[match1[1]].low = match1[2] + match1[3];
    bots[match1[1]].high = match1[4] + match1[5];

    processBot(match1[1]);
  } else if (match2) {
    giveBotValue(match2[2], match2[1]);
  }
});

for (var n in bots) {
  let bot = bots[n];

  valuesSorted = bot.values.sort();

  if (valuesSorted[0] == 17 && valuesSorted[1] == 61) {
    console.log(`Part 1: ${n}`);
  }
}
  
console.log(`Part 2: ${outputs['0'].value*outputs['1'].value*outputs['2'].value}`);
