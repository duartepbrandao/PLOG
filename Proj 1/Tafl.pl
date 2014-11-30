tabuleiro([9,
	['-','-','-','b','b','b','-','-','-'],
	['-','-','-','-','b','-','-','-','-'],
	['-','-','-','-','w','-','-','-','-'],
	['b','-','-','-','w','-','-','-','b'],
	['b','b','w','w','-','w','w','b','b'],
	['b','-','-','-','w','-','-','-','b'],
	['-','-','-','-','w','-','-','-','-'],
	['-','b','-','-','b','-','-','k','-'],
	['-','-','-','b','b','b','-','-','-']]).

:- op(1000,xfy,'or').

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

getPieceFromLine([],_,_,_,_,_):-
	!,fail.

getPieceFromLine([H|T],H,X,Y,X,Y).

getPieceFromLine([H|T],Piece,X,Y,Xcounter,Y):-
	NewXcounter is Xcounter+1,
	getPieceFromLine(T,Piece,X,Y,NewXcounter,Y).

getPiece([],_,_,_,_,_):-
	!,fail.

getPiece([H|T],Piece,X,Y,Xcounter,Y):-
	(getPieceFromLine(H,Piece,X,Y,Xcounter,Y));
	(!,fail).

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
		((Player = 'w';Player='k'),(Piece='w' ;Piece='k'));
		(!,fail).

	changePlayer(Player,NewPlayer):-
		(Player='b',NewPlayer= 'w');
		NewPlayer = 'b'.

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

indexOf([Element|_], Element, 1):- !.
indexOf([_|Tail], Element, Index):-
  indexOf(Tail, Element, Index1),
  !,
  Index is Index1+1.

getPos([],X,Y,Xcounter,Ycounter):-
	X=0,
	Y=0.

getPos([H|T],X,Y,Xcounter,Ycounter):-
	(indexOf(H,'k',X),Y is Ycounter+1,!);
	(
	Ycounter2 is Ycounter +1,getPos(T,X,Y,Xcounter,Ycounter2)).

getKing([H|T],X,Y):-
	getPos(T,X,Y,1,1),
	write(X),write(Y),
	nl.

gameOver(Player):-
	nl,
	write(Player),
	write(' has won!!!'),break.


assessPosition(Size,0,0):-
	gameOver('b').

assessPosition(Size,1,_):-
	gameOver('a').

assessPosition(Size,Size,_):-
	gameOver('a').


assessPosition(Size,_,1):-
gameOver('a').


assessPosition(Size,_,Size):-
gameOver('a').

assessPosition(Size,X,Y).



checkEnd([H|T]):-
	getKing(T,X,Y),
	(assessPosition(H,X,Y)).

capture(Board,NewBoard,Player,X,Y,X3,Y3):-
	getPiece(Board,Piece,X,Y,1,1),
	changePlayer(Player,NewPlayer),
	validatePiece(Piece,NewPlayer),
	getPiece(Board,Piece2,X3,Y3,1,1),
	validatePiece(Piece2,Player),
	replaceElement(Y,X,'-',Board,NewBoard).


captures([H|T],NewBoard2,Player,X2,Y2):-
	(YN is Y2-1,
	YS is Y2+1,
	XW is X2-1,
	XE is X2+1,
	YN2 is Y2-2,
	YS2 is Y2+2,
	XW2 is X2-2,
	XE2 is X2+2),
	((capture(T,Temp1,Player,X2,YN,X2,YN2);copyList(T,Temp1)),
	(capture(Temp1,Temp2,Player,X2,YS,X2,YS2);copyList(Temp1,Temp2)),
	(capture(Temp2,Temp3,Player,XW,Y2,XW2,Y2);copyList(Temp2,Temp3)),
	(capture(Temp3,Temp4,Player,XE,Y2,XE2,Y2);copyList(Temp3,Temp4)),
	copyList([H|Temp4], NewBoard2)).


gameCicle([H|T],Player):-
	(choosePiece(Player,X,Y),
	getPiece(T,Piece,X,Y,1,1),
	validatePiece(Player,Piece),
	chooseDest(Player,X2,Y2),
	getPiece(T,Piece2,X2,Y2,1,1),
	validatePiece('-',Piece2),
	validMove(T,X,Y,X2,Y2),
	move([H|T],NewBoard,Piece,X,Y,X2,Y2),
	captures(NewBoard,NewBoard2,Player,X2,Y2),
printSboard(NewBoard2),
	checkEnd(NewBoard2),
	changePlayer(Player,NewPlayer),
	gameCicle(NewBoard2,NewPlayer));
	(write('Invalid Choice!'),nl,gameCicle([H|T],Player)).



game:-
tabuleiro(Board),
printSboard(Board),
gameCicle(Board,'b').
