tabuleiro([
	[0,0,0,1,1,1,0,0,0],
	[0,0,0,0,1,0,0,0,0],
	[0,0,1,0,2,2,0,0,0],
	[1,0,0,0,2,0,0,0,1],
	[1,0,0,2,0,0,0,1,1],
	[1,0,0,0,2,0,0,0,1],
	[0,0,0,0,2,0,2,0,0],
	[0,2,0,0,0,0,k,0,0],
	[0,0,0,1,1,1,0,1,0]]).

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

tabuleiro(Board),
printBoard(Board).
