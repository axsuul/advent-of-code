var assert = require('assert');
var fs = require('fs');

let readInputLines = function(filename, callback) {
  let input = fs.readFileSync(filename).toString();

  input.split("\n").forEach(function(line) {
    if (line != "") callback(line);
  });
}

class Screen {
  constructor(w, h) {
    this.maxX = w - 1;
    this.maxY = h - 1;
    this.screen = [];

    for (var x = 0; x < h; x++) {
      let row = [];

      for (var y = 0; y < w; y++) {
        row.push(".");
      }

      this.screen.push(row);
    }
  }

  turnOn(x, y) {
    this.screen[y][x] = "#";
  }

  turnOff(x, y) {
    this.screen[y][x] = ".";
  }


  isTurnedOn(x, y) {
    return this.screen[y][x] == "#";
  }

  perform(operation) {
    if (operation.match(/rect/)) {
      let match = operation.match(/rect (\d+)x(\d+)/);

      this.performRectangle(parseInt(match[1]), parseInt(match[2]));
    } else if (operation.match(/rotate column/)) {
      let match = operation.match(/rotate column x=(\d+) by (\d+)/);

      this.performRotateColumn(parseInt(match[1]), parseInt(match[2]));
    } else if (operation.match(/rotate row/)) {
      let match = operation.match(/rotate row y=(\d+) by (\d+)/);

      this.performRotateRow(parseInt(match[1]), parseInt(match[2]));
    }
  }

  performRectangle(w, h) {
    for (var y = 0; y < h; y++) {
      for (var x = 0; x < w; x++) {
        this.turnOn(x, y);
      }
    }
  }

  performRotateColumn(x, d) {
    let onY = [];
    let onNewY = [];

    // First write down which ones are turned on
    this.screen.forEach((row, y) => {
      if (this.isTurnedOn(x, y)) {
        onY.push(y);
      }
    });

    onY.forEach((y) => {
      let newY = y + d;
      
      if (newY < 0) newY = this.maxY;
      if (newY > this.maxY) newY = newY - this.maxY - 1;

      onNewY.push(newY);
    });

    this.screen.forEach((row, y) => {
      if (onNewY.indexOf(y) > -1) {
        this.turnOn(x, y);
      } else {
        this.turnOff(x, y);
      }
    });
  }

  performRotateRow(y, d) {
    let onX = [];
    let onNewX = [];

    // First write down which ones are turned on
    this.screen[y].forEach((_, x) => {
      if (this.isTurnedOn(x, y)) {
        onX.push(x);
      }
    });

    onX.forEach((x) => {
      let newX = x + d;
      
      if (newX < 0) newX = this.maxX;
      if (newX > this.maxX) newX = newX - this.maxX - 1;

      onNewX.push(newX);
    });

    this.screen[y].forEach((_, x) => {
      if (onNewX.indexOf(x) > -1) {
        this.turnOn(x, y);
      } else {
        this.turnOff(x, y);
      }
    });
  }

  countOn() {
    let count = 0;

    this.screen.forEach((row) => {
      row.forEach((el) => {
        if (el == "#") count += 1
      });
    });

    return count;
  }

  print() {
    console.log("---");

    this.screen.forEach(function(row) {
      console.log(row.join(''));
    });
  }
}


describe('screen', function() {
  it('works', function() {
    let testScreen = new Screen(7, 3);
    testScreen.perform("rect 3x2");
    testScreen.print();
    testScreen.perform("rotate column x=1 by 1");
    testScreen.print();
    testScreen.perform("rotate row y=0 by 4");
    testScreen.print();
    testScreen.perform("rotate column x=1 by 1");
    testScreen.print();
	});
});

let screen = new Screen(50, 6);

readInputLines("input.txt", function(line) {
  screen.perform(line);
  screen.print();
});

console.log(screen.countOn());

