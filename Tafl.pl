tabuleiro([9,
	['_','_','_',b,b,b,'_','_','_'],
	['_','_','_','_',b,'_','_','_','_'],
	['_','_',b,'_',w,w,'_','_','_'],
	[b,'_','_','_',w,'_','_','_',b],
	[b,'_','_',w,'_','_','_',b,b],
	[b,'_','_','_',w,'_','_','_',b],
	['_','_','_','_',w,'_',w,'_','_'],
	['_',w,'_','_','_','_',k,'_','_'],
	['_','_','_',b,b,b,'_',b,'_']]).


printtopline(X,X):-
	write(X),
	nl.

printtopline(X,Y):-
	write(Y),
	write(' '),
	YW is Y+1,
	printtopline(X,YW).

printSideLine(X):-
	write(X),
	write(' ').

printSboard([X|Y]):-
	printtopline(X,0),
	printBoard(Y,1).

printBoard([]).

printBoard([H],C) :-
		printSideLine(C),
		printLine(H).

printBoard([X|Y],C) :-
		printSideLine(C),
		printLine(X),
		nl,
		NC is C+1,
		printBoard(Y,NC).

printLine([]).
printLine([H]) :-
write(H).

printLine([X|Y]):-
		write(X),
		write(' '),
		printLine(Y).

game:-

tabuleiro(Board),
printSboard(Board).
