%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Slings and Arrows.t
%
%   This program is a two-player competitive game in which both players try to
%   kill each other by shooting unidirectional rocks and curving arrows
%   forwards ans moving side to side in order to avoid the other player's
%   projectiles.
%
% Author:   Tiger He
% Course:   ICS2OG/3-01, Mr. Cox, Newmarket High School
% Date:     23 Jan 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Declare Variables %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% declare window properties
View.Set ("graphics:1200;675;nocursor;noecho;offscreenonly;position:center;center;title:Slings and Arrows;nobuttonbar")

% declare turing preset graphic variables
var fadeClr : int := 218
var xIntoBall : int := maxx div 2
var yIntoBall : int := -3
var curtainY : int := 0

% declare text variables
var text1 : int := Font.New ("Mono:64")
var text2 : int := Font.New ("Mono:16")
var text3 : int := Font.New ("Mono:11")

% declare key and pointing device detection variables
var chars : array char of boolean
var mx, my, mb : int

% declare menu option variables
var menuSelection : string := ""
var instructionLine : array 1 .. 100 of string
var instructionLineCount : int := 0
var streamNumberInstructions : int

var prevGameLine : array 1 .. 100 of string
var prevGameLineCount : int := 0
var streamNumberprevGame : int

% declare player location variables
var p1x : int
var p1y : int
var p2x : int
var p2y : int

% declare player movement variables
var left1 : int := 0
var right1 : int := 0
var left2 : int := 0
var right2 : int := 0

var p1Move : int := 0
var p2Move : int := 0

var p1MoveCount : int := 0
var p2MoveCount : int := 0

% declare player health text
var p1HealthText : string := "P1 HEALTH: 100%"
var p2HealthText : string := "P2 HEALTH: 100%"

% declare projectile state and location variables
var shootRock1 : boolean
var shootRockCount1 : int := 0
var shootRock2 : boolean
var shootRockCount2 : int := 0

var rock1x : int := 0
var rock1y : int := 0
var rock2x : int := 0
var rock2y : int := 0

var shootArrow1 : boolean
var shootArrowCount1 : int := 0
var shootArrow2 : boolean
var shootArrowCount2 : int := 0

var arrow1x : int := 0
var arrow1y : int := 0
var arrow1Direction : int := 0
var arrow2x : int := 0
var arrow2y : int := 0
var arrow2Direction : int := 0

% declare collision sound variables
var chooseMusic : int

% declare sound variables
var backgroundMusic : boolean := true
var collisionSound : boolean := true

% declare player status variables
var death1Count : int := 0
var death1x : int := 0
var death1y : int := 0

var death2Count : int := 0
var death2x : int := 0
var death2y : int := 0

var p1Health : int := 100
var p2Health : int := 100

% declare game state variables
var winner : string := ""
var gameEnd : boolean := false
var tombstoneFalling : int

% define game name constant
const gameName : string := "Slings and Arrows"



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sound %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% declare background song process
process playBackgroundMusic
    loop
	if backgroundMusic = true then
	    Music.PlayFile ("bgM.mp3")
	end if
    end loop
end playBackgroundMusic

% declare collision sound processes
process playSound1
    Music.PlayFile ("Sound 1.wav")
end playSound1

process playSound2
    Music.PlayFile ("Sound 2.wav")
end playSound2

process playSound3
    Music.PlayFile ("Sound 3.wav")
end playSound3

process playSound4
    Music.PlayFile ("Sound 4.wav")
end playSound4

process playSound5
    Music.PlayFile ("Sound 5.wav")
end playSound5

process playSound6
    Music.PlayFile ("Sound 6.wav")
end playSound6

% declare random colision sound procedure
procedure playHitMusic
    randint (chooseMusic, 1, 6)
    if chooseMusic = 1 then
	fork playSound1
    elsif chooseMusic = 2 then
	fork playSound2
    elsif chooseMusic = 3 then
	fork playSound3
    elsif chooseMusic = 4 then
	fork playSound4
    elsif chooseMusic = 5 then
	fork playSound5
    elsif chooseMusic = 6 then
	fork playSound6
    end if
end playHitMusic



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Menu Selection Start %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% declare draw exit button procedure
procedure drawExit
    for count : 1 .. 256 by 1
	RGB.SetColor (fadeClr, count / 256, count / 256, count / 256)
	Font.Draw ("Exit", (maxx div 2) - (Font.Width
	    ("Exit", text2) div 2), maxy div 8 * 1, text2, fadeClr)
	View.Update
	delay (1)
    end for
end drawExit


% declare fade in menu from black to white procedure
procedure fadeMenu
    for count : 1 .. 256 by 1
	colorback (black)
	cls
	RGB.SetColor (fadeClr, count / 256, count / 256, count / 256)
	Font.Draw (gameName, (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 4 * 3, text1, fadeClr)
	Font.Draw ("Start Game", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 5, text2, fadeClr)
	Font.Draw ("Previous Games", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 4, text2, fadeClr)
	Font.Draw ("Settings", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 3, text2, fadeClr)
	Font.Draw ("Instructions", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 2, text2, fadeClr)
	View.Update
	delay (1)
    end for
end fadeMenu


% declare check if user inputs exit procedure
procedure detectExit
    loop
	Mouse.Where (mx, my, mb)
	if mx >= (maxx div 2) - (Font.Width ("Exit", text2) div 2)
		and mx <= (maxx div 2) + (Font.Width ("Exit", text2) div 2)
		and my >= maxy div 8 * 1
		and my <= maxy div 8 * 1 + 16 then
	    Font.Draw ("Exit", (maxx div 2) - (Font.Width
		("Exit", text2) div 2), maxy div 8 * 1, text2, red)
	    menuSelection := "Exit"
	else
	    Font.Draw ("Exit", (maxx div 2) - (Font.Width
		("Exit", text2) div 2), maxy div 8 * 1, text2, white)
	end if
	exit when menuSelection = "Exit" and mb = 1
	View.Update
    end loop
end detectExit


% declare draw introduction annimation procedure
procedure runIntroGraphic

    % draw black background
    colorback (black)
    cls
    View.Update
    delay (500)

    % draw white bullet fly up to screen center
    loop
	cls
	yIntoBall := yIntoBall + 1
	drawline (xIntoBall - 2, yIntoBall, xIntoBall + 2, yIntoBall, white)
	drawline (xIntoBall, yIntoBall - 2, xIntoBall, yIntoBall + 2, white)
	View.Update
	delay (1)

	cls
	yIntoBall := yIntoBall + 1
	drawline (xIntoBall - 2, yIntoBall - 2,
	    xIntoBall + 2, yIntoBall + 2, white)
	drawline (xIntoBall - 2, yIntoBall + 2,
	    xIntoBall + 2, yIntoBall - 2, white)
	View.Update
	delay (1)
	exit when yIntoBall = maxy div 2
    end loop

    % reset bullet variables
    xIntoBall := maxx div 2
    yIntoBall := -3

    % draw fade black to white
    for count : 1 .. 256 by 2
	RGB.SetColor (fadeClr, count / 256, count / 256, count / 256)
	colorback (fadeClr)
	cls
	View.Update
    end for

    % draw white background
    colorback (white)
    cls
    View.Update
    delay (500)

    % draw backgroud fade white to black
    % draw white title
    for decreasing count : 256 .. 1
	RGB.SetColor (fadeClr, count / 256, count / 256, count / 256)
	colorback (fadeClr)
	cls
	Font.Draw (gameName, (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 4 * 3, text1, white)
	View.Update
	delay (1)
    end for

    delay (100)

    % fade in white menu
    for count : 1 .. 256 by 1
	RGB.SetColor (fadeClr, count / 256, count / 256, count / 256)
	Font.Draw ("Start Game", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 5, text2, fadeClr)
	Font.Draw ("Previous Games", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 4, text2, fadeClr)
	Font.Draw ("Settings", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 3, text2, fadeClr)
	Font.Draw ("Instructions", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 2, text2, fadeClr)
	View.Update
	delay (1)
    end for

end runIntroGraphic


% declare previous games menu procedure
procedure runPreviousGames

    % fade away all but previous games text
    for decreasing count : 256 .. 1 by 1
	RGB.SetColor (fadeClr, count / 256, count / 256, count / 256)
	colorback (black)
	cls
	Font.Draw (gameName, (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 4 * 3, text1, fadeClr)
	Font.Draw ("Start Game", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 5, text2, fadeClr)
	Font.Draw ("Previous Games", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 4, text2, white)
	Font.Draw ("Settings", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 3, text2, fadeClr)
	Font.Draw ("Instructions", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 2, text2, fadeClr)
	View.Update
	delay (1)
    end for

    delay (100)

    % fade away previous games text
    for decreasing count : 256 .. 1 by 1
	RGB.SetColor (fadeClr, count / 256, count / 256, count / 256)
	colorback (black)
	cls
	Font.Draw ("Previous Games", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 4, text2, fadeClr)
	View.Update
	delay (1)
    end for

    delay (200)

    % fade in previous games title
    for count : 1 .. 256 by 1
	RGB.SetColor (fadeClr, count / 256, count / 256, count / 256)
	colorback (black)
	cls
	Font.Draw ("Previous Games", (maxx div 2) - (Font.Width
	    ("Previous Games", text1) div 2), maxy div 4 * 3, text1, fadeClr)
	View.Update
	delay (1)
    end for

    % access and get info of previous games from text fle
    open : streamNumberprevGame, "Previous Games.txt", get
    assert streamNumberprevGame > 0

    loop
	get : streamNumberprevGame, skip
	exit when eof (streamNumberprevGame)
	get : streamNumberprevGame,
	    prevGameLine (prevGameLineCount + 1) : *
	prevGameLineCount := prevGameLineCount + 1
    end loop

    close : streamNumberprevGame

    % fade in info of previous games text and exit text
    for count : 1 .. 256 by 1
	RGB.SetColor (fadeClr, count / 256, count / 256, count / 256)
	for amount : 1 .. prevGameLineCount
	    Font.Draw (prevGameLine (amount), (maxx div 2) - (Font.Width
		("Previous Games", text1) div 2),
		maxy div 20 * (14 - amount), text3, fadeClr)
	end for
	Font.Draw ("Exit", (maxx div 2) - (Font.Width
	    ("Exit", text2) div 2), maxy div 8 * 1, text2, fadeClr)
	View.Update
	delay (1)
    end for

    detectExit

    % fade away info of previous games text and exit
    for decreasing count : 256 .. 1
	RGB.SetColor (fadeClr, count / 256, count / 256, count / 256)
	colorback (black)
	cls
	Font.Draw ("Previous Games", (maxx div 2) - (Font.Width
	    ("Previous Games", text1) div 2), maxy div 4 * 3, text1, fadeClr)
	for amount : 1 .. prevGameLineCount
	    Font.Draw (prevGameLine (amount), (maxx div 2) - (Font.Width
		("Previous Games", text1) div 2),
		maxy div 20 * (14 - amount), text3, fadeClr)
	end for
	Font.Draw ("Exit", (maxx div 2) - (Font.Width
	    ("Exit", text2) div 2), maxy div 8 * 1, text2, fadeClr)
	View.Update
	delay (1)
    end for

    % reset line count for previous games text
    prevGameLineCount := 0

    fadeMenu

end runPreviousGames


% declare settings menu procedure
procedure runSettings

    % fade away all but settings text
    for decreasing count : 256 .. 1 by 1
	RGB.SetColor (fadeClr, count / 256, count / 256, count / 256)
	colorback (black)
	cls
	Font.Draw (gameName, (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 4 * 3, text1, fadeClr)
	Font.Draw ("Start Game", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 5, text2, fadeClr)
	Font.Draw ("Previous Games", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 4, text2, fadeClr)
	Font.Draw ("Settings", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 3, text2, white)
	Font.Draw ("Instructions", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 2, text2, fadeClr)
	View.Update
	delay (1)
    end for

    delay (100)

    % fade away settings text
    for decreasing count : 256 .. 1 by 1
	RGB.SetColor (fadeClr, count / 256, count / 256, count / 256)
	colorback (black)
	cls
	Font.Draw ("Settings", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 3, text2, fadeClr)
	View.Update
	delay (1)
    end for

    delay (100)

    % fade in settings title
    for count : 1 .. 256 by 1
	RGB.SetColor (fadeClr, count / 256, count / 256, count / 256)
	colorback (black)
	cls
	Font.Draw ("Settings", (maxx div 2) - (Font.Width
	    ("Settings", text1) div 2), maxy div 4 * 3, text1, fadeClr)
	View.Update
	delay (1)
    end for

    % fade in settings options
    for count : 1 .. 256 by 1
	RGB.SetColor (fadeClr, count / 256, count / 256, count / 256)
	if backgroundMusic = true then
	    Font.Draw ("Background Music: On", (maxx div 2) - (Font.Width
		(gameName, text1) div 2), maxy div 8 * 5, text2, fadeClr)
	elsif backgroundMusic = false then
	    Font.Draw ("Background Music: Off", (maxx div 2) - (Font.Width
		(gameName, text1) div 2), maxy div 8 * 5, text2, fadeClr)
	end if
	if collisionSound = true then
	    Font.Draw ("Collision Sound: On", (maxx div 2) - (Font.Width
		(gameName, text1) div 2), maxy div 8 * 4, text2, fadeClr)
	elsif collisionSound = false then
	    Font.Draw ("Collision Sound: Off", (maxx div 2) - (Font.Width
		(gameName, text1) div 2), maxy div 8 * 4, text2, fadeClr)
	end if
	Font.Draw ("Exit", (maxx div 2) - (Font.Width
	    ("Exit", text2) div 2), maxy div 8 * 1, text2, fadeClr)
	View.Update
	delay (1)
    end for

    % detect settings changes
    loop

	cls

	% redraw text
	Font.Draw ("Settings", (maxx div 2) - (Font.Width
	    ("Settings", text1) div 2), maxy div 4 * 3, text1, white)

	% detect pointing device state
	Mouse.Where (mx, my, mb)

	% set collision sound state
	if backgroundMusic = true then
	    if mx >= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		    and mx <= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		    + (Font.Width ("Background Music: On", text2))
		    and my >= maxy div 8 * 5
		    and my <= maxy div 8 * 5 + 16
		    and mb = 0 then
		Font.Draw ("Background Music: On", (maxx div 2) - (Font.Width
		    (gameName, text1) div 2), maxy div 8 * 5, text2, red)
	    elsif mx >= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		    and mx <= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		    + (Font.Width ("Background Music: On", text2))
		    and my >= maxy div 8 * 5
		    and my <= maxy div 8 * 5 + 16
		    and mb = 1 then
		backgroundMusic := false
		delay (500)
		Music.PlayFileStop
	    elsif backgroundMusic = true then
		Font.Draw ("Background Music: On", (maxx div 2) - (Font.Width
		    (gameName, text1) div 2), maxy div 8 * 5, text2, white)
	    end if
	elsif backgroundMusic = false then
	    if mx >= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		    and mx <= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		    + (Font.Width ("Background Music: Off", text2))
		    and my >= maxy div 8 * 5
		    and my <= maxy div 8 * 5 + 16
		    and mb = 0 then
		Font.Draw ("Background Music: Off", (maxx div 2) - (Font.Width
		    (gameName, text1) div 2), maxy div 8 * 5, text2, red)
	    elsif mx >= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		    and mx <= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		    + (Font.Width ("Background Music: Off", text2))
		    and my >= maxy div 8 * 5
		    and my <= maxy div 8 * 5 + 16
		    and mb = 1 then
		delay (500)
		backgroundMusic := true
	    elsif backgroundMusic = false then
		Font.Draw ("Background Music: Off", (maxx div 2) - (Font.Width
		    (gameName, text1) div 2), maxy div 8 * 5, text2, white)
	    end if
	end if

	% set collision sound state
	if collisionSound = true then
	    if mx >= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		    and mx <= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		    + (Font.Width ("Collision Sound: On", text2))
		    and my >= maxy div 8 * 4
		    and my <= maxy div 8 * 4 + 16
		    and mb = 0 then
		Font.Draw ("Collision Sound: On", (maxx div 2) - (Font.Width
		    (gameName, text1) div 2), maxy div 8 * 4, text2, red)
	    elsif mx >= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		    and mx <= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		    + (Font.Width ("Collision Sound: On", text2))
		    and my >= maxy div 8 * 4
		    and my <= maxy div 8 * 4 + 16
		    and mb = 1 then
		collisionSound := false
		delay (500)
	    elsif collisionSound = true then
		Font.Draw ("Collision Sound: On", (maxx div 2) - (Font.Width
		    (gameName, text1) div 2), maxy div 8 * 4, text2, white)
	    end if
	elsif collisionSound = false then
	    if mx >= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		    and mx <= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		    + (Font.Width ("Collision Sound: Off", text2))
		    and my >= maxy div 8 * 4
		    and my <= maxy div 8 * 4 + 16
		    and mb = 0 then
		Font.Draw ("Collision Sound: Off", (maxx div 2) - (Font.Width
		    (gameName, text1) div 2), maxy div 8 * 4, text2, red)
	    elsif mx >= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		    and mx <= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		    + (Font.Width ("Collision Sound: Off", text2))
		    and my >= maxy div 8 * 4
		    and my <= maxy div 8 * 4 + 16
		    and mb = 1 then
		collisionSound := true
		delay (500)
	    elsif collisionSound = false then
		Font.Draw ("Collision Sound: Off", (maxx div 2) - (Font.Width
		    (gameName, text1) div 2), maxy div 8 * 4, text2, white)
	    end if
	end if

	% detect if exit is selected
	if mx >= (maxx div 2) - (Font.Width ("Exit", text2) div 2)
		and mx <= (maxx div 2) + (Font.Width ("Exit", text2) div 2)
		and my >= maxy div 8 * 1
		and my <= maxy div 8 * 1 + 16 then
	    Font.Draw ("Exit", (maxx div 2) - (Font.Width
		("Exit", text2) div 2), maxy div 8 * 1, text2, red)
	    menuSelection := "Exit"
	else
	    Font.Draw ("Exit", (maxx div 2) - (Font.Width
		("Exit", text2) div 2), maxy div 8 * 1, text2, white)
	end if
	exit when menuSelection = "Exit" and mb = 1

	View.Update

    end loop

    % fade away settings and exit text
    for decreasing count : 256 .. 1 by 1
	RGB.SetColor (fadeClr, count / 256, count / 256, count / 256)
	colorback (black)
	cls
	Font.Draw ("Settings", (maxx div 2) - (Font.Width
	    ("Settings", text1) div 2), maxy div 4 * 3, text1, fadeClr)
	Font.Draw ("Exit", (maxx div 2) - (Font.Width
	    ("Exit", text2) div 2), maxy div 8 * 1, text2, fadeClr)
	if backgroundMusic = true then
	    Font.Draw ("Background Music: On", (maxx div 2) - (Font.Width
		(gameName, text1) div 2), maxy div 8 * 5, text2, fadeClr)
	elsif backgroundMusic = false then
	    Font.Draw ("Background Music: Off", (maxx div 2) - (Font.Width
		(gameName, text1) div 2), maxy div 8 * 5, text2, fadeClr)
	end if
	if collisionSound = true then
	    Font.Draw ("Collision Sound: On", (maxx div 2) - (Font.Width
		(gameName, text1) div 2), maxy div 8 * 4, text2, fadeClr)
	elsif collisionSound = false then
	    Font.Draw ("Collision Sound: Off", (maxx div 2) - (Font.Width
		(gameName, text1) div 2), maxy div 8 * 4, text2, fadeClr)
	end if
	View.Update
	delay (1)
    end for

    fadeMenu

end runSettings


% declare instructions menu procedure
procedure runInstructions

    % fade away all but instruction text
    for decreasing count : 256 .. 1 by 1
	RGB.SetColor (fadeClr, count / 256, count / 256, count / 256)
	colorback (black)
	cls
	Font.Draw (gameName, (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 4 * 3, text1, fadeClr)
	Font.Draw ("Start Game", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 5, text2, fadeClr)
	Font.Draw ("Previous Games", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 4, text2, fadeClr)
	Font.Draw ("Settings", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 3, text2, fadeClr)
	Font.Draw ("Instructions", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 2, text2, white)
	View.Update
	delay (1)
    end for

    delay (100)

    % fade away instruction text
    for decreasing count : 256 .. 1 by 1
	RGB.SetColor (fadeClr, count / 256, count / 256, count / 256)
	colorback (black)
	cls
	Font.Draw ("Instructions", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 2, text2, fadeClr)
	View.Update
	delay (1)
    end for

    delay (100)

    % fade in instruction text title
    for count : 1 .. 256 by 1
	RGB.SetColor (fadeClr, count / 256, count / 256, count / 256)
	colorback (black)
	cls
	Font.Draw ("Instructions", (maxx div 2) - (Font.Width
	    ("Instructions", text1) div 2), maxy div 4 * 3, text1, fadeClr)
	View.Update
	delay (1)
    end for

    % access and get instructions from text fle
    open : streamNumberInstructions, "Instructions.txt", get
    assert streamNumberInstructions > 0

    loop
	get : streamNumberInstructions, skip
	exit when eof (streamNumberInstructions)
	get : streamNumberInstructions,
	    instructionLine (instructionLineCount + 1) : *
	instructionLineCount := instructionLineCount + 1
    end loop

    close : streamNumberInstructions

    % fade in instructions text and exit text
    for count : 1 .. 256 by 1
	RGB.SetColor (fadeClr, count / 256, count / 256, count / 256)
	for amount : 1 .. instructionLineCount
	    Font.Draw (instructionLine (amount), 48,
		maxy div 20 * (14 - amount), text3, fadeClr)
	end for
	Font.Draw ("Exit", (maxx div 2) - (Font.Width
	    ("Exit", text2) div 2), maxy div 8 * 1, text2, fadeClr)
	View.Update
	delay (1)
    end for

    detectExit

    % fade away instructions text and exit
    for decreasing count : 256 .. 1
	RGB.SetColor (fadeClr, count / 256, count / 256, count / 256)
	colorback (black)
	cls
	Font.Draw ("Instructions", (maxx div 2) - (Font.Width
	    ("Instructions", text1) div 2), maxy div 4 * 3, text1, fadeClr)
	for amount : 1 .. instructionLineCount
	    Font.Draw (instructionLine (amount), 48,
		maxy div 20 * (14 - amount), text3, fadeClr)
	end for
	Font.Draw ("Exit", (maxx div 2) - (Font.Width
	    ("Exit", text2) div 2), maxy div 8 * 1, text2, fadeClr)
	View.Update
	delay (1)
    end for

    % reset instructions line count
    instructionLineCount := 0

    fadeMenu

end runInstructions


% declare game menu option selection detection procedure
procedure runMenuSelection
    loop

	% detect pointing device state
	Mouse.Where (mx, my, mb)

	% determine if pointing device selected start game
	if mx >= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		and mx <= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		+ (Font.Width ("Start Game", text2))
		and my >= maxy div 8 * 5
		and my <= maxy div 8 * 5 + 16 then
	    Font.Draw ("Start Game", (maxx div 2) - (Font.Width
		(gameName, text1) div 2), maxy div 8 * 5, text2, red)
	    menuSelection := "Start Game"

	    % determine if pointing device selected previous games
	elsif mx >= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		and mx <= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		+ (Font.Width ("Previous Games", text2))
		and my >= maxy div 8 * 4
		and my <= maxy div 8 * 4 + 16 then
	    Font.Draw ("Previous Games", (maxx div 2) - (Font.Width
		(gameName, text1) div 2), maxy div 8 * 4, text2, red)
	    menuSelection := "Previous Games"

	    % determine if pointing device selected settings
	elsif mx >= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		and mx <= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		+ (Font.Width ("Settings", text2))
		and my >= maxy div 8 * 3
		and my <= maxy div 8 * 3 + 16 then
	    Font.Draw ("Settings", (maxx div 2) - (Font.Width
		(gameName, text1) div 2), maxy div 8 * 3, text2, red)
	    menuSelection := "Settings"

	    % determine if pointing device selected instructions
	elsif mx >= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		and mx <= (maxx div 2) - (Font.Width (gameName, text1) div 2)
		+ (Font.Width ("Instructions", text2))
		and my >= maxy div 8 * 2
		and my <= maxy div 8 * 2 + 16 then
	    Font.Draw ("Instructions", (maxx div 2) - (Font.Width
		(gameName, text1) div 2), maxy div 8 * 2, text2, red)
	    menuSelection := "Instructions"

	    % redraw options
	else
	    Font.Draw ("Start Game", (maxx div 2) - (Font.Width
		(gameName, text1) div 2), maxy div 8 * 5, text2, white)
	    Font.Draw ("Previous Games", (maxx div 2) - (Font.Width
		(gameName, text1) div 2), maxy div 8 * 4, text2, white)
	    Font.Draw ("Settings", (maxx div 2) - (Font.Width
		(gameName, text1) div 2), maxy div 8 * 3, text2, white)
	    Font.Draw ("Instructions", (maxx div 2) - (Font.Width
		(gameName, text1) div 2), maxy div 8 * 2, text2, white)
	    menuSelection := ""
	end if

	% run game is pointing device relected run game
	exit when menuSelection = "Start Game" and mb = 1

	% run which menu pointing device selected
	if menuSelection = "Previous Games" and mb = 1 then
	    runPreviousGames
	elsif menuSelection = "Settings" and mb = 1 then
	    runSettings
	elsif menuSelection = "Instructions" and mb = 1 then
	    runInstructions
	end if

	View.Update

    end loop

    % fade away all but start game text
    for decreasing count : 256 .. 1 by 1
	RGB.SetColor (fadeClr, count / 256, count / 256, count / 256)
	colorback (black)
	cls
	Font.Draw (gameName, (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 4 * 3, text1, fadeClr)
	Font.Draw ("Start Game", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 5, text2, white)
	Font.Draw ("Previous Games", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 4, text2, fadeClr)
	Font.Draw ("Settings", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 3, text2, fadeClr)
	Font.Draw ("Instructions", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 2, text2, fadeClr)
	View.Update
	delay (1)
    end for

    delay (100)

    % fade away start game text
    for decreasing count : 256 .. 1 by 1
	RGB.SetColor (fadeClr, count / 256, count / 256, count / 256)
	colorback (black)
	cls
	Font.Draw ("Start Game", (maxx div 2) - (Font.Width
	    (gameName, text1) div 2), maxy div 8 * 5, text2, fadeClr)
	View.Update
	delay (1)
    end for

end runMenuSelection



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Game %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% declare run game procedure
procedure runGame

    % declare background pictures/sprites and picture/sprite variables
    var backgroundORIG : int := Pic.FileNew ("MarioBackground1200x675.gif")
    var background := Pic.Scale (backgroundORIG, 1200, 675)

    var curtainORIG : int := Pic.FileNew ("curtain.gif")
    var curtainPic := Pic.Scale (curtainORIG, 1200, 675)
    var curtain : int := Sprite.New (curtainPic)
    Sprite.SetHeight (curtain, 6)

    % declare Troy pictures/sprites and picture/sprite variables
    var pic1left1ORIG : int := Pic.FileNew ("p1left1.gif")
    var pic1left1 : int := Pic.Scale (pic1left1ORIG, 56, 70)
    var sprite1left1 : int := Sprite.New (pic1left1)
    Sprite.SetHeight (sprite1left1, 2)

    var pic1left2ORIG : int := Pic.FileNew ("p1left2.gif")
    var pic1left2 : int := Pic.Scale (pic1left2ORIG, 48, 74)
    var sprite1left2 : int := Sprite.New (pic1left2)
    Sprite.SetHeight (sprite1left2, 2)

    var pic1left3ORIG : int := Pic.FileNew ("p1left3.gif")
    var pic1left3 : int := Pic.Scale (pic1left3ORIG, 54, 70)
    var sprite1left3 : int := Sprite.New (pic1left3)
    Sprite.SetHeight (sprite1left3, 2)

    var pic1right1ORIG : int := Pic.FileNew ("p1right1.gif")
    var pic1right1 : int := Pic.Scale (pic1right1ORIG, 56, 70)
    var sprite1right1 : int := Sprite.New (pic1right1)
    Sprite.SetHeight (sprite1right1, 2)

    var pic1right2ORIG : int := Pic.FileNew ("p1right2.gif")
    var pic1right2 : int := Pic.Scale (pic1right2ORIG, 48, 74)
    var sprite1right2 : int := Sprite.New (pic1right2)
    Sprite.SetHeight (sprite1right2, 2)

    var pic1right3ORIG : int := Pic.FileNew ("p1right3.gif")
    var pic1right3 : int := Pic.Scale (pic1right3ORIG, 54, 70)
    var sprite1right3 : int := Sprite.New (pic1right3)
    Sprite.SetHeight (sprite1right3, 2)

    var pic1centerORIG : int := Pic.FileNew ("p1center.gif")
    var pic1center : int := Pic.Scale (pic1centerORIG, 48, 70)
    var sprite1center : int := Sprite.New (pic1center)
    Sprite.SetHeight (sprite1center, 2)

    var pic1shootORIG : int := Pic.FileNew ("p1shoot.gif")
    var pic1shoot : int := Pic.Scale (pic1shootORIG, 50, 70)
    var sprite1shoot : int := Sprite.New (pic1shoot)
    Sprite.SetHeight (sprite1shoot, 2)

    % declare Jeff pictures/sprites and picture/sprite variables
    var pic2left1ORIG : int := Pic.FileNew ("p2left1.gif")
    var pic2left1 : int := Pic.Scale (pic2left1ORIG, 60, 88)
    var sprite2left1 : int := Sprite.New (pic2left1)
    Sprite.SetHeight (sprite2left1, 2)

    var pic2left2ORIG : int := Pic.FileNew ("p2left2.gif")
    var pic2left2 : int := Pic.Scale (pic2left2ORIG, 42, 88)
    var sprite2left2 : int := Sprite.New (pic2left2)
    Sprite.SetHeight (sprite2left2, 2)

    var pic2left3ORIG : int := Pic.FileNew ("p2left3.gif")
    var pic2left3 : int := Pic.Scale (pic2left3ORIG, 68, 90)
    var sprite2left3 : int := Sprite.New (pic2left3)
    Sprite.SetHeight (sprite2left3, 2)

    var pic2right1ORIG : int := Pic.FileNew ("p2right1.gif")
    var pic2right1 : int := Pic.Scale (pic2right1ORIG, 60, 88)
    var sprite2right1 : int := Sprite.New (pic2right1)
    Sprite.SetHeight (sprite2right1, 2)

    var pic2right2ORIG : int := Pic.FileNew ("p2right2.gif")
    var pic2right2 : int := Pic.Scale (pic2right2ORIG, 42, 88)
    var sprite2right2 : int := Sprite.New (pic2right2)
    Sprite.SetHeight (sprite2right2, 2)

    var pic2right3ORIG : int := Pic.FileNew ("p2right3.gif")
    var pic2right3 : int := Pic.Scale (pic2right3ORIG, 68, 90)
    var sprite2right3 : int := Sprite.New (pic2right3)
    Sprite.SetHeight (sprite2right3, 2)

    var pic2centerORIG : int := Pic.FileNew ("p2center.gif")
    var pic2center : int := Pic.Scale (pic2centerORIG, 44, 90)
    var sprite2center : int := Sprite.New (pic2center)
    Sprite.SetHeight (sprite2center, 2)

    var pic2shootORIG : int := Pic.FileNew ("p2shoot.gif")
    var pic2shoot : int := Pic.Scale (pic2shootORIG, 44, 94)
    var sprite2shoot : int := Sprite.New (pic2shoot)
    Sprite.SetHeight (sprite2shoot, 2)

    % declare projectile pictures/sprites and picture/sprite variables
    var basketballORIG : int := Pic.FileNew ("Bat.gif")
    var basketball : int := Pic.Scale (basketballORIG, 42, 29)
    var basketballSprite : int := Sprite.New (basketball)
    Sprite.SetHeight (basketballSprite, 1)

    var exclaimORIG : int := Pic.FileNew ("Blorgons.gif")
    var exclaim : int := Pic.Scale (exclaimORIG, 40, 78)
    var exclaimSprite : int := Sprite.New (exclaim)
    Sprite.SetHeight (exclaimSprite, 1)

    var heartORIG : int := Pic.FileNew ("Heart.gif")
    var heart : int := Pic.Scale (heartORIG, 34, 34)
    var heartSprite : int := Sprite.New (heart)
    Sprite.SetHeight (heartSprite, 1)

    var fishORIG : int := Pic.FileNew ("Fish.gif")
    var fish : int := Pic.Scale (fishORIG, 38, 68)
    var fishSprite : int := Sprite.New (fish)
    Sprite.SetHeight (fishSprite, 1)

    var p1tombstonePic : int := Pic.FileNew ("p1tombstone.gif")
    var p1tombstone : int := Sprite.New (p1tombstonePic)
    Sprite.SetHeight (p1tombstone, 5)

    var p2tombstonePic : int := Pic.FileNew ("p2tombstone.gif")
    var p2tombstone : int := Sprite.New (p2tombstonePic)
    Sprite.SetHeight (p2tombstone, 5)

    % declare explosion pictures/sprites and picture/sprite variables
    var explosion1 : int := Pic.FileNew ("explosion1p1.gif")
    var explosion1p1 : int := Sprite.New (explosion1)
    Sprite.SetHeight (explosion1p1, 3)

    var explosion2 : int := Pic.FileNew ("explosion2p1.gif")
    var explosion2p1 : int := Sprite.New (explosion2)
    Sprite.SetHeight (explosion2p1, 3)

    var explosion3 : int := Pic.FileNew ("explosion3p1.gif")
    var explosion3p1 : int := Sprite.New (explosion3)
    Sprite.SetHeight (explosion3p1, 3)

    var explosion4 : int := Pic.FileNew ("explosion4p1.gif")
    var explosion4p1 : int := Sprite.New (explosion4)
    Sprite.SetHeight (explosion4p1, 3)

    var explosion5 : int := Pic.FileNew ("explosion1p2.gif")
    var explosion1p2 : int := Sprite.New (explosion5)
    Sprite.SetHeight (explosion1p2, 3)

    var explosion6 : int := Pic.FileNew ("explosion2p2.gif")
    var explosion2p2 : int := Sprite.New (explosion6)
    Sprite.SetHeight (explosion2p2, 3)

    var explosion7 : int := Pic.FileNew ("explosion3p2.gif")
    var explosion3p2 : int := Sprite.New (explosion7)
    Sprite.SetHeight (explosion3p2, 3)

    var explosion8 : int := Pic.FileNew ("explosion4p2.gif")
    var explosion4p2 : int := Sprite.New (explosion8)
    Sprite.SetHeight (explosion4p2, 3)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % draw background
    Pic.Draw (background, 0, 0, 0)

    % move black curtain up
    loop
	curtainY := curtainY + 1
	Sprite.SetPosition (curtain, 0, curtainY, false)
	Sprite.Show (curtain)
	exit when curtainY = maxy
	delay (0)
	View.Update
    end loop

    % hide curtain
    Sprite.Hide (curtain)

    delay (500)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % set initial player locations
    p1x := maxx div 2
    p1y := 45 + 35

    p2x := maxx div 2
    p2y := maxy - 45 - 44

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    loop
	cls

	% draw background
	Pic.Draw (background, 0, 0, 0)

	% hide all sprites
	Sprite.Hide (sprite1shoot)
	Sprite.Hide (sprite1center)
	Sprite.Hide (sprite1left1)
	Sprite.Hide (sprite1left2)
	Sprite.Hide (sprite1left3)
	Sprite.Hide (sprite1right1)
	Sprite.Hide (sprite1right2)
	Sprite.Hide (sprite1right3)

	Sprite.Hide (sprite2shoot)
	Sprite.Hide (sprite2center)
	Sprite.Hide (sprite2left1)
	Sprite.Hide (sprite2left2)
	Sprite.Hide (sprite2left3)
	Sprite.Hide (sprite2right1)
	Sprite.Hide (sprite2right2)
	Sprite.Hide (sprite2right3)

	Sprite.Hide (basketballSprite)
	Sprite.Hide (exclaimSprite)
	Sprite.Hide (heartSprite)
	Sprite.Hide (fishSprite)

	Sprite.Hide (explosion1p1)
	Sprite.Hide (explosion2p1)
	Sprite.Hide (explosion3p1)
	Sprite.Hide (explosion4p1)

	Sprite.Hide (explosion1p2)
	Sprite.Hide (explosion2p2)
	Sprite.Hide (explosion3p2)
	Sprite.Hide (explosion4p2)

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% detect key
	if gameEnd = false then
	    Input.KeyDown (chars)
	end if

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% set last move
	p1Move := (right1 - left1) div 12
	p2Move := (right2 - left2) div 12

	% determine speed increase from input keys
	if (chars ('a') or chars ('A')) and left1 <= 84 then
	    left1 := left1 + 1
	elsif left1 > 0 then
	    left1 := left1 - 2
	elsif left1 not= 0 then
	    left1 := 0
	end if

	if (chars ('d') or chars ('D')) and right1 <= 84 then
	    right1 := right1 + 1
	elsif right1 > 0 then
	    right1 := right1 - 2
	elsif right1 not= 0 then
	    right1 := 0
	end if

	if chars (KEY_LEFT_ARROW) and left2 <= 84 then
	    left2 := left2 + 1
	elsif left2 > 0 then
	    left2 := left2 - 2
	elsif left2 not= 0 then
	    left2 := 0
	end if

	if chars (KEY_RIGHT_ARROW) and right2 <= 84 then
	    right2 := right2 + 1
	elsif right2 > 0 then
	    right2 := right2 - 2
	elsif right2 not= 0 then
	    right2 := 0
	end if

	% set move count
	if p1Move = 0 then
	    p1MoveCount := 0
	else
	    p1MoveCount := p1MoveCount + p1Move
	end if

	if p2Move = 0 then
	    p2MoveCount := 0
	else
	    p2MoveCount := p2MoveCount + p2Move
	end if

	% move characters
	p1x := p1x + p1Move
	p2x := p2x + p2Move

	% disallow players graphics to exit window
	if p1x < -23 then
	    p1x := maxx + 23
	elsif p1x > maxx + 23 then
	    p1x := -23
	end if

	if p2x < -23 then
	    p2x := maxx + 23
	elsif p2x > maxx + 23 then
	    p2x := -23
	end if

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% set all player sprites to player location
	% player 1
	Sprite.SetPosition (sprite1center, p1x, p1y, true)
	Sprite.SetPosition (sprite1left1, p1x, p1y, true)
	Sprite.SetPosition (sprite1left2, p1x, p1y, true)
	Sprite.SetPosition (sprite1left3, p1x, p1y, true)
	Sprite.SetPosition (sprite1right1, p1x, p1y, true)
	Sprite.SetPosition (sprite1right2, p1x, p1y, true)
	Sprite.SetPosition (sprite1right3, p1x, p1y, true)
	Sprite.SetPosition (sprite1shoot, p1x, p1y, true)

	% player 2
	Sprite.SetPosition (sprite2center, p2x, p2y, true)
	Sprite.SetPosition (sprite2left1, p2x, p2y, true)
	Sprite.SetPosition (sprite2left2, p2x, p2y, true)
	Sprite.SetPosition (sprite2left3, p2x, p2y, true)
	Sprite.SetPosition (sprite2right1, p2x, p2y, true)
	Sprite.SetPosition (sprite2right2, p2x, p2y, true)
	Sprite.SetPosition (sprite2right3, p2x, p2y, true)
	Sprite.SetPosition (sprite2shoot, p2x, p2y, true)

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% detect if projectiles are fired
	% player 1
	if chars ('w') and shootRockCount1 = 0 then
	    shootRockCount1 := 1
	    rock1x := p1x
	elsif chars ('s') and shootArrowCount1 = 0 then
	    shootArrowCount1 := 1
	    arrow1x := p1x
	    arrow1Direction := p1Move
	end if

	% player 2
	if chars (KEY_UP_ARROW) and shootRockCount2 = 0 then
	    shootRockCount2 := 1
	    rock2x := p2x
	elsif chars (KEY_DOWN_ARROW) and shootArrowCount2 = 0 then
	    shootArrowCount2 := 1
	    arrow2x := p2x
	    arrow2Direction := p2Move
	end if


	% draw and move projectiles for player 1
	% rock
	if shootRockCount1 > 0 and shootRockCount1 < 675 then
	    shootRockCount1 := shootRockCount1 + 8
	    rock1y := shootRockCount1 + p1y
	    Sprite.SetPosition (exclaimSprite, rock1x, rock1y, true)
	    Sprite.Show (exclaimSprite)
	else
	    shootRockCount1 := 0
	    rock1y := 0
	end if

	% arrow
	if shootArrowCount1 > 0 and shootArrowCount1 < 675 then
	    shootArrowCount1 := shootArrowCount1 + 8
	    arrow1y := shootArrowCount1 + 45 + 35
	    arrow1x := arrow1x + arrow1Direction
	    Sprite.SetPosition (basketballSprite, arrow1x, arrow1y, true)
	    Sprite.Show (basketballSprite)
	else
	    shootArrowCount1 := 0
	    arrow1y := 0
	end if

	% draw and move projectiles for player 2
	% rock
	if shootRockCount2 > 0 and shootRockCount2 < 675 then
	    shootRockCount2 := shootRockCount2 + 8
	    rock2y := -shootRockCount2 + p2y
	    Sprite.SetPosition (fishSprite, rock2x, rock2y, true)
	    Sprite.Show (fishSprite)
	else
	    shootRockCount2 := 0
	    rock2y := 0
	end if

	% arrow
	if shootArrowCount2 > 0 and shootArrowCount2 < 675 then
	    shootArrowCount2 := shootArrowCount2 + 8
	    arrow2y := 0 - shootArrowCount2 + (maxy - 70)
	    arrow2x := arrow2x + arrow2Direction
	    Sprite.SetPosition (heartSprite, arrow2x, arrow2y, true)
	    Sprite.Show (heartSprite)
	else
	    shootArrowCount2 := 0
	    arrow2y := 0
	end if

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% detect collision for player 1 projectiles
	% rock
	if rock1x > p2x - 25 and rock1x < p2x + 25
		and rock1y > p2y - 40 and rock1y < p2y + 40
		and death2Count = 0 and p1Health > 0 and p2Health > 0 then
	    if collisionSound = true then
		playHitMusic
	    end if
	    p2Health := p2Health - 5
	    p2HealthText := "P2 HEALTH: " + intstr (p2Health) + "%"
	    shootRockCount1 := 0
	    rock1y := 0
	    death2Count := 1
	    death2x := p2x
	    death2y := p2y
	    Sprite.SetPosition (explosion1p2, death2x, death2y, true)
	    Sprite.SetPosition (explosion2p2, death2x, death2y, true)
	    Sprite.SetPosition (explosion3p2, death2x, death2y, true)
	    Sprite.SetPosition (explosion4p2, death2x, death2y, true)
	end if

	% arrow
	if arrow1x > p2x - 25 and arrow1x < p2x + 25
		and arrow1y > p2y - 40 and arrow1y < p2y + 40
		and death2Count = 0 and p1Health > 0 and p2Health > 0 then
	    if collisionSound = true then
		playHitMusic
	    end if
	    p2Health := p2Health - 3
	    p2HealthText := "P2 HEALTH: " + intstr (p2Health) + "%"
	    shootArrowCount1 := 0
	    arrow1y := 0
	    death2Count := 1
	    death2x := p2x
	    death2y := p2y
	    Sprite.SetPosition (explosion1p2, death2x, death2y, true)
	    Sprite.SetPosition (explosion2p2, death2x, death2y, true)
	    Sprite.SetPosition (explosion3p2, death2x, death2y, true)
	    Sprite.SetPosition (explosion4p2, death2x, death2y, true)
	end if

	% update player 2 hit state
	if death2Count > 0 then
	    death2Count := death2Count + 1
	end if

	% show sprite for current player 2 hit state
	if death2Count > 60 then
	    death2Count := 0
	elsif death2Count > 45 then
	    Sprite.Show (explosion4p2)
	elsif death2Count > 30 then
	    Sprite.Show (explosion3p2)
	elsif death2Count > 15 then
	    Sprite.Show (explosion2p2)
	elsif death2Count > 0 then
	    Sprite.Show (explosion1p2)
	end if

	% detect collirsion for player 2 projectiles
	% rock
	if rock2x > p1x - 25 and rock2x < p1x + 25
		and rock2y > p1y - 40 and rock2y < p1y + 40
		and death1Count = 0 and p1Health > 0 and p2Health > 0 then
	    if collisionSound = true then
		playHitMusic
	    end if
	    p1Health := p1Health - 5
	    p1HealthText := "P1 HEALTH: " + intstr (p1Health) + "%"
	    shootRockCount2 := 0
	    rock2y := 0
	    death1Count := 1
	    death1x := p1x
	    death1y := p1y
	    Sprite.SetPosition (explosion1p1, death1x, death1y, true)
	    Sprite.SetPosition (explosion2p1, death1x, death1y, true)
	    Sprite.SetPosition (explosion3p1, death1x, death1y, true)
	    Sprite.SetPosition (explosion4p1, death1x, death1y, true)
	end if

	% arrow
	if arrow2x > p1x - 25 and arrow2x < p1x + 25
		and arrow2y > p1y - 40 and arrow2y < p1y + 40
		and death1Count = 0 and p1Health > 0 and p2Health > 0 then
	    if collisionSound = true then
		playHitMusic
	    end if
	    p1Health := p1Health - 3
	    p1HealthText := "P1 HEALTH: " + intstr (p1Health) + "%"
	    shootArrowCount2 := 0
	    arrow2y := 0
	    death1Count := 1
	    death1x := p1x
	    death1y := p1y
	    Sprite.SetPosition (explosion1p1, death1x, death1y, true)
	    Sprite.SetPosition (explosion2p1, death1x, death1y, true)
	    Sprite.SetPosition (explosion3p1, death1x, death1y, true)
	    Sprite.SetPosition (explosion4p1, death1x, death1y, true)
	end if

	% update player 1 hit state
	if death1Count > 0 then
	    death1Count := death1Count + 1
	end if

	% show sprite for current player 1 hit state
	if death1Count > 60 then
	    death1Count := 0
	elsif death1Count > 45 then
	    Sprite.Show (explosion4p1)
	elsif death1Count > 30 then
	    Sprite.Show (explosion3p1)
	elsif death1Count > 15 then
	    Sprite.Show (explosion2p1)
	elsif death1Count > 0 then
	    Sprite.Show (explosion1p1)
	end if

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% determine and show which player graphic depending on movement and action
	% player 1
	if (death1Count = 0 or death1Count div 2 mod 2 not= 0) and p1Health > 0 then
	    if (shootRockCount1 > 0 and shootRockCount1 < 250)
		    or (shootArrowCount1 > 0 and shootArrowCount1 < 250) then
		Sprite.Show (sprite1shoot)
	    else
		if left1 = right1 then
		    Sprite.Show (sprite1center)
		elsif left1 > right1 and (p1MoveCount div 35) mod 3 = 0 then
		    Sprite.Show (sprite1left1)
		elsif left1 > right1 and (p1MoveCount div 35) mod 3 = 1 then
		    Sprite.Show (sprite1left2)
		elsif left1 > right1 and (p1MoveCount div 35) mod 3 = 2 then
		    Sprite.Show (sprite1left3)
		elsif left1 < right1 and (p1MoveCount div 35) mod 3 = 0 then
		    Sprite.Show (sprite1right1)
		elsif left1 < right1 and (p1MoveCount div 35) mod 3 = 1 then
		    Sprite.Show (sprite1right2)
		elsif left1 < right1 and (p1MoveCount div 35) mod 3 = 2 then
		    Sprite.Show (sprite1right3)
		end if
	    end if
	end if

	% player 2
	if (death2Count = 0 or death2Count div 2 mod 2 not= 0) and p2Health > 0 then
	    if (shootRockCount2 > 0 and shootRockCount2 < 250)
		    or (shootArrowCount2 > 0 and shootArrowCount2 < 250) then
		Sprite.Show (sprite2shoot)
	    else
		if left2 = right2 then
		    Sprite.Show (sprite2center)
		elsif left2 > right2 and (p2MoveCount div 35) mod 3 = 0 then
		    Sprite.Show (sprite2left1)
		elsif left2 > right2 and (p2MoveCount div 35) mod 3 = 1 then
		    Sprite.Show (sprite2left2)
		elsif left2 > right2 and (p2MoveCount div 35) mod 3 = 2 then
		    Sprite.Show (sprite2left3)
		elsif left2 < right2 and (p2MoveCount div 35) mod 3 = 0 then
		    Sprite.Show (sprite2right1)
		elsif left2 < right2 and (p2MoveCount div 35) mod 3 = 1 then
		    Sprite.Show (sprite2right2)
		elsif left2 < right2 and (p2MoveCount div 35) mod 3 = 2 then
		    Sprite.Show (sprite2right3)
		end if
	    end if
	end if

	% display player 1 score
	Font.Draw (p1HealthText, 720, 325, text3, red)
	Font.Draw (p2HealthText, 720, 345, text3, blue)

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% check for winner
	if p2Health <= 0 and winner = "" then
	    winner := "Player One"
	    tombstoneFalling := -1200
	    gameEnd := true
	end if

	if p1Health <= 0 and winner = "" then
	    winner := "Player Two"
	    tombstoneFalling := 1200
	    gameEnd := true
	end if

	% end game
	if gameEnd = true then
	    if tombstoneFalling not= 0 then
		% stop user control
		chars ('w') := false
		chars ('a') := false
		chars ('s') := false
		chars ('d') := false
		chars (KEY_UP_ARROW) := false
		chars (KEY_DOWN_ARROW) := false
		chars (KEY_LEFT_ARROW) := false
		chars (KEY_RIGHT_ARROW) := false
		% move winning character left
	    elsif winner = "Player One" then
		chars ('d') := true
	    elsif winner = "Player Two" then
		chars (KEY_RIGHT_ARROW) := true
	    end if

	    % move tombstone to dead player
	    if winner = "Player One" and tombstoneFalling not= 0 then
		tombstoneFalling := tombstoneFalling + 8
		Sprite.SetPosition
		    (p2tombstone, death2x, p2y + tombstoneFalling, true)
		Sprite.Show (p2tombstone)
	    end if

	    if winner = "Player Two" and tombstoneFalling not= 0 then
		tombstoneFalling := tombstoneFalling - 8
		Sprite.SetPosition
		    (p1tombstone, death1x, p1y + tombstoneFalling, true)
		Sprite.Show (p1tombstone)
	    end if

	    % move black curtain down
	    if gameEnd = true and tombstoneFalling = 0 then
		curtainY := curtainY - 1
		Sprite.SetPosition (curtain, 0, curtainY, false)
		Sprite.Show (curtain)
		exit when curtainY = 0
	    end if
	end if

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	delay (0)

	% update screen
	View.Update

    end loop

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % free sprites
    Sprite.Free (curtain)
    Sprite.Free (sprite1left1)
    Sprite.Free (sprite1left2)
    Sprite.Free (sprite1left3)
    Sprite.Free (sprite1right1)
    Sprite.Free (sprite1right2)
    Sprite.Free (sprite1right3)
    Sprite.Free (sprite1center)
    Sprite.Free (sprite1shoot)
    Sprite.Free (sprite2left1)
    Sprite.Free (sprite2left2)
    Sprite.Free (sprite2left3)
    Sprite.Free (sprite2right1)
    Sprite.Free (sprite2right2)
    Sprite.Free (sprite2right3)
    Sprite.Free (sprite2center)
    Sprite.Free (sprite2shoot)
    Sprite.Free (basketballSprite)
    Sprite.Free (exclaimSprite)
    Sprite.Free (heartSprite)
    Sprite.Free (fishSprite)
    Sprite.Free (p1tombstone)
    Sprite.Free (p2tombstone)
    Sprite.Free (explosion1p1)
    Sprite.Free (explosion2p1)
    Sprite.Free (explosion3p1)
    Sprite.Free (explosion4p1)
    Sprite.Free (explosion1p2)
    Sprite.Free (explosion2p2)
    Sprite.Free (explosion3p2)
    Sprite.Free (explosion4p2)

    % open previous game statistics file and get info
    open : streamNumberprevGame, "Previous Games.txt", get
    assert streamNumberprevGame > 0

    loop
	get : streamNumberprevGame, skip
	exit when eof (streamNumberprevGame)
	get : streamNumberprevGame,
	    prevGameLine (prevGameLineCount + 1) : *
	prevGameLineCount := prevGameLineCount + 1
    end loop

    close : streamNumberprevGame

    % input current game info into previous game statistics file as well
    % as previous info
    open : streamNumberprevGame, "Previous Games.txt", put
    assert streamNumberprevGame > 0

    if p1Health > p2Health then
	put : streamNumberprevGame, "P1: ", p1Health,
	    "  -  P2: ", "0", "  -  P1 Won!"
    elsif p2Health > p1Health then
	put : streamNumberprevGame, "P1: ", "0",
	    "  -  P2: ", p2Health, "  -  P2 Won!"
    end if

    for count : 1 .. prevGameLineCount
	put : streamNumberprevGame,
	    prevGameLine (count)
	exit when count = 9
    end for

    close : streamNumberprevGame

    % reset previous game information line count
    prevGameLineCount := 0

    % reset game variables
    left1 := 0
    right1 := 0
    left2 := 0
    right2 := 0
    p1Move := 0
    p2Move := 0
    p1MoveCount := 0
    p2MoveCount := 0
    p1HealthText := "P1 HEALTH: 100%"
    p2HealthText := "P2 HEALTH: 100%"
    p1Health := 100
    p2Health := 100
    winner := ""
    gameEnd := false
    curtainY := 0

end runGame



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Execution %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% exicute program
loop
    fork playBackgroundMusic
    runIntroGraphic
    runMenuSelection
    runGame
end loop

