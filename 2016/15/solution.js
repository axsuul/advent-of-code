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

class Disk {
  constructor(position, positions) {
    this.time = 0;
    this.position = position;
    this.positions = positions;
  }

  tick(n = 1) {
    this.position = this.positionIn(n);
    this.time += 1;
  }

  positionIn(time) {
    let position = this.position;

    for (var t = this.time; t < this.time + time; t++) {
      position += 1;

      if (position > this.positions - 1) position = 0;
    }

    return position;
  }
}

// returns anonymous func
let newDisk = function(position, positionsCount) {
  let disk = function(time) {
    let currentPosition = position;

    if (time == 0) return currentPosition;

    for (var t = 0; t < time; t++) {
      currentPosition += 1;

      if (currentPosition > positionsCount - 1) currentPosition = 0;
    }

    return currentPosition;
  }

	return disk;
}

let calcReleaseTime = function(disks, t = 0) {
  // Starting positions
  disks.forEach((d, i) => d.tick(i+t+1));

  while (true) {
    let positions = disks.map((d) => d.position);

    if (positions.filter((p) => p == 0).length == positions.length) {
      console.log(`t: ${t}`);
      break;
    }

    disks.forEach((d) => d.tick());
    t += 1;
  }
}

let testDisks = [new Disk(4, 5), new Disk(1, 2)];
let part1Disks = [
	new Disk(0, 7),
	new Disk(0, 13),
	new Disk(2, 3),
	new Disk(2, 5),
	new Disk(0, 17),
	new Disk(7, 19)
];
let part2Disks = part1Disks.concat(new Disk(0, 11));

calcReleaseTime(part1Disks);
calcReleaseTime(part2Disks);
