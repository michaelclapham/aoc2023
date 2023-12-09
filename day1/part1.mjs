import {readFileSync} from "fs";

const input = readFileSync("./input.txt").toString();

var firstDigit = -1;
var lastDigit = -1;
var total = 0;
for (var i = 0; i < input.length; i++) {
    var charCode = input.charCodeAt(i);
    if (charCode == 10) {
        if (firstDigit != -1) {
            if (lastDigit != -1) {
                console.log("Two digits on line", firstDigit, lastDigit);
                total += (10 * firstDigit);
                total += lastDigit;
                firstDigit = -1;
                lastDigit = -1;
            } else {
                console.log("One digit on line", firstDigit);
                total += 11 * firstDigit;
                firstDigit = -1;
                lastDigit = -1;
            }
        } else {
            console.log("No digits on this line");
        }
    }
    if (charCode >= 48 && charCode <= 57) {
        console.log("digit", input[i], charCode);
        if (firstDigit == -1) {
            firstDigit = charCode - 48;
            console.log("First digit", input[i], charCode - 48);
        } else {
            lastDigit = charCode - 48;
            console.log("Last digit", input[i], charCode - 48);
        }
    } else {
        console.log("not digit", input[i], charCode);
    }
}
console.log("Total", total);