tabuleiro([9,
	['-','-','-','b','b','b','-','-','-'],
	['-','-','-','b','b','-','-','-','-'],
	['-','-','b','-',w,w,'-','-','-'],
	['b','w','-','-',w,'-','-','-',b],
	[b,'-','-',w,'-','-','-',b,b],
	[b,'-','-','-',w,'-','-','-',b],
	['-','-','-','-',w,'-',w,'-','-'],
	['-',w,'-','-','-','-',k,'-','-'],
	['-','-','-',b,b,b,'-',b,'-']]).

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


getPieceFromLine([H|T],H,X,Y,X,Y).

getPieceFromLine([H|T],Piece,X,Y,Xcounter,Y):-
	NewXcounter is Xcounter+1,
	getPieceFromLine(T,Piece,X,Y,NewXcounter,Y).

getPiece([H|T],Piece,X,Y,Xcounter,Y):-
	getPieceFromLine(H,Piece,X,Y,Xcounter,Y).

getPiece([H|T],Piece,X,Y,Xcounter,Ycounter):-
	NewYcounter is Ycounter+1,
	getPiece(T,Piece,X,Y,Xcounter,NewYcounter).

choosePiece(Player,X,Y):-
	nl,
	write(Player),
	write(', choose the piece to move:(x-y)'),
	nl,
	read(X-Y).

chooseDest(Player,X,Y):-
		nl,
		write(Player),
		write(', choose the destination to move:(x-y)'),
		nl,
		read(X-Y).

	validatePiece(Player,Piece):-
		(Player = 'b',Piece='b');
		(Player='-',Piece='-');
		(Player = 'w',(Piece='w' ;Piece='k')).

	changePlayer(Player,NewPlayer):-
		(Player='b',NewPlayer is 'w');
		NewPlayer is 'b'.

		validMoveVertical(Board,X,Y,Y).

		validMoveVertical(Board,X,Yi,Yf):-
			getPiece(Board,Piece,X,Yi,1,1),
			Piece='-',
			Yi2 is Yi+1,
			validMoveVertical(Board,X,Yi2,Yf).

		validMoveHorizontal(Board,Y,X,X).

		validMoveHorizontal(Board,Y,Xi,Xf):-
			getPiece(Board,Piece,Xi,Y,1,1),
			Piece='-',
			Xi2 is Xi + 1,
			validMoveHorizontal(Board,Y,Xi2,Xf).

	validMove(Board,Xi,Yi,Xf,Yf):-
		((Xi = Xf,
			(Yi<Yf,
			Yi1 is Yi +1,
			validMoveVertical(Board,Xi,Yi1,Yf));
			(Yi>Yf,
			Yi1 is Yi -1,
			validMoveVertical(Board,Xi,Yf,Yi1)));
			((Yi = Yf,
				(Xi<Xf,
				Xi1 is Xi +1,
				validMoveHorizontal(Board,Yi,Xi1,Xf));
				(Xi>Xf,
				Xi1 is Xi -1,
				validMoveHorizontal(Board,Yi,Xf,Xi1))))).


replaceElement(Line, Column, NewValue, [H|T], [H|NewList]) :-
    Line > 1,
    Line1 is Line - 1,
    replaceElement(Line1, Column, NewValue, T, NewList).

replaceElement(1, Column, NewValue, [H|T],[H1|T]) :-
    replaceElementAux(Column, NewValue, H, H1).

replaceElementAux(Column, NewValue, [H|T], [H|T1]) :-
    Column > 1,
    Column1 is Column - 1,
    replaceElementAux(Column1, NewValue, T, T1).

replaceElementAux(1, NewValue, [_|T], [NewValue|T]).

copyList([H|T],[H|T]).

	move([H|T],NewBoard,Piece,X,Y,X2,Y2):-
			replaceElement(Y,X,'-',T,NewBoard2),
			replaceElement(Y2,X2,Piece,NewBoard2,NewBoard3),
			copyList([H|NewBoard3],NewBoard).

startGame([H|T]):-
	(choosePiece('b',X,Y),
	getPiece(T,Piece,X,Y,1,1),
	validatePiece('b',Piece),
	chooseDest('b',X2,Y2),
	getPiece(T,Piece2,X2,Y2,1,1),
	validatePiece('-',Piece2),
	validMove(T,X,Y,X2,Y2),
	%trace,
	move([H|T],NewBoard,Piece,X,Y,X2,Y2),
	printSboard(NewBoard));
	(write('Invalid Choice!'),nl,startGame([H|T])).


game:-
tabuleiro(Board),
printSboard(Board),
startGame(Board).
