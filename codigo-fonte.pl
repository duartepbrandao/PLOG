teste
tabuleiro([9,
	[0,0,0,1,1,1,0,0,0],
	[0,0,0,0,1,0,0,0,0],
	[0,0,1,0,2,2,0,0,0],
	[1,0,0,0,2,0,0,0,1],
	[1,0,0,2,0,0,0,1,1],
	[1,0,0,0,2,0,0,0,1],
	[0,0,0,0,2,0,2,0,0],
	[0,2,0,0,0,0,k,0,0],
	[0,0,0,1,1,1,0,1,0]]).

positions([
		[00,01,02,03,04,05,06,07,08]]).

printtopline(X,X).

printtopline(X,Y):-
	write(X),
	write(' '),
	Y2 is Y+1,
	printtopline(X,Y2).

printSboard([X|Y]):-
	printtopline(X,0),
	printBoard(Y).

printBoard([]).

printBoard([H]) :-
		printLine(H).

printBoard([X|Y]) :-
		printLine(X),
		nl,
		printBoard(Y).

printLine([]).
printLine([H]) :-
write(H).

printLine([X|Y]):-
		write(X),
		write(' '),
		printLine(Y).

game:-

tabuleiro(Board), printSboard(Board).
