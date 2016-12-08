var assert = require('assert');
var fs = require('fs');
var md5 = require('md5');

let readInputLines = function(callback) {
  let input = fs.readFileSync('input.txt').toString();

  input.split("\n").forEach(function(line) {
    if (line != "") callback(line);
  });
}

let sanitizeLine = function(line) {
  return line.trim().replace(/\s+/g, ' ');
}

let generatePassword = function(doorId) {
  let index = 0;
  let password1 = "";
  let password1Solved = false;
  let password2 = "________";
  let password2Solved = false;

  while (true) {
    let hash = md5(doorId + index);

    if (hash.substring(0, 5) == "00000") {
      console.log(`Found ${hash} for ${index}`);

      if (!password1Solved) {
        password1 += hash.charAt(5);
        console.log(`Password1 is now: ${password1}`);

        if (password1.length == 8) password1Solved = true;
      }

      if (!password2Solved) {
        let position = parseInt(hash.charAt(5));
        let char = hash.charAt(6);

        if (!isNaN(position) && 
            position >= 0 && 
            position <= 7 && 
            password2.charAt(position) == "_") {
          password2 = password2.substr(0, position) + char + password2.substr(position + 1);
          
          console.log(`Password2 is now: ${password2}`);

          if (password2.length == password2.replace(/\_/g, '').length) {
            password2Solved = true;
          }
        }
      }
    }

    if (password1Solved && password2Solved) break;

    index += 1;
  }

  return [password1, password2];
}

describe('#generatePassword()', function() {
  it('generates password from door ID', function() {
   assert.equal(["18f47a30", "05ace8e3"], generatePassword("abc"));
	});
});

generatePassword("abc");
generatePassword("ojvtpuvg");
