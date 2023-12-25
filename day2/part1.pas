program Day2Part1;

Uses 
  sysutils, strutils;

var
  redConstraint, greenConstraint, blueConstraint: Integer;
  total: Integer;
  gameNum, redMax, greenMax, blueMax: Integer;
  gameStr, gameNumStr, after, subSets, part: AnsiString;
  turns, draws: TStringArray;
  turn, draw, dt: AnsiString;
  line: AnsiString;
  i, num: Integer;
  possible: Boolean;

Begin

  redConstraint := 12;
  greenConstraint := 13;
  blueConstraint := 14;
  total := 0;

  while not Eof do  // Read until the end of input
  begin
    ReadLn(line);  // Read a line from standard input
    WriteLn('You entered: ', line);  // Display the entered line
    // Extract game number and draw information
    gameStr := Copy(line, 1, Pos(':', line) - 1);
    gameNumStr := Trim(StringReplace(gameStr, 'Game ', '', [rfReplaceAll, rfIgnoreCase]));
    gameNum := StrToInt(gameNumStr);
    WriteLn('Game num ', gameNum);
    after := Copy(line, Pos(':', line) + 2, Length(line));

    // For each line, there a turns, each turn consists of multiple draws
    // loop through them

    redMax := 0;
    greenMax := 0;
    blueMax := 0;

    turns := after.Split([';']);
    for turn in turns do
      WriteLn('turn ', turn);
      draws := turn.Split([',']);

      // Find maximum red, green, and blue counts
      for draw in draws do
      begin
        WriteLn('draw ', draw);
        if Pos('red', draw) > 0 then
        begin
          num := StrToInt(Trim(StringReplace(draw, 'red', '', [rfReplaceAll, rfIgnoreCase])));
          WriteLn('red num ', num);
          if num > redMax then redMax := num;
        end;
        if Pos('green', draw) > 0 then
        begin
          num := StrToInt(Trim(StringReplace(draw, 'green', '', [rfReplaceAll, rfIgnoreCase])));
          WriteLn('green num ', num);
          if num > greenMax then greenMax := num;
        end;
        if Pos('blue', draw) > 0 then
        begin
          num := StrToInt(Trim(StringReplace(draw, 'blue', '', [rfReplaceAll, rfIgnoreCase])));
          WriteLn('blue num ', num);
          if num > blueMax then blueMax := num;
        end;
      end;

    WriteLn('red max ', redMax);
    WriteLn('green max ', greenMax);
    WriteLn('blue max ', greenMax);

    // Check if constraints are met
    possible := (redMax <= redConstraint) and (greenMax <= greenConstraint) and (blueMax <= blueConstraint);

    if possible then
      WriteLn('game is possible: ', gameNum);
      total := total + gameNum;

  end;

  WriteLn('Total is: ', total)

End.