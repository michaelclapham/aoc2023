var points = 0
sinput.split("\n").map((line) => {
    var pipeParts = line.split("|");
    console.log("pp", pipeParts);
    var beforePipe = pipeParts[0];
    console.log("bp", beforePipe);
    var afterPipe = pipeParts[1].trim();
    console.log("ap", afterPipe);
    var afterColon = beforePipe.split(":")[1].trim();
    console.log("ac", afterColon);
    var winningNumbers = afterColon.replace(/  /g, " ").split(" ").map((s) => Number.parseInt(s.trim())).filter((n) => n != NaN);
    var myNumbers = afterPipe.replace(/  /g, " ").split(" ").map((s) => Number.parseInt(s.trim())).filter((n) => n != NaN);
    var myWinners = myNumbers.filter((n) => winningNumbers.includes(n));
    var pointsForCard = 0;
    if (myWinners.length > 0) {
        pointsForCard = Math.pow(2, myWinners.length - 1);
        points += pointsForCard;
    }
    return [winningNumbers, myNumbers, myWinners, pointsForCard];
});
console.log(points);

function winsForLine(line) {
    var pipeParts = line.split("|");
    console.log("pp", pipeParts);
    var beforePipe = pipeParts[0];
    console.log("bp", beforePipe);
    var afterPipe = pipeParts[1].trim();
    console.log("ap", afterPipe);
    var afterColon = beforePipe.split(":")[1].trim();
    console.log("ac", afterColon);
    var winningNumbers = afterColon.replace(/  /g, " ").split(" ").map((s) => Number.parseInt(s.trim())).filter((n) => n != NaN);
    var myNumbers = afterPipe.replace(/  /g, " ").split(" ").map((s) => Number.parseInt(s.trim())).filter((n) => n != NaN);
    var myWinners = myNumbers.filter((n) => winningNumbers.includes(n));
    return myWinners.length;
}