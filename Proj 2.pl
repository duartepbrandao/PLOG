problem([5,
        ['-','0','-','-','-'],
        ['-','-','X','-','-'],
        ['-','-','1','-','-'],
        ['-','-','-','-','-'],
        ['-','-','2','-','-']]).


printLine([]).
printLine([H|T]):-
  write(H),
  write(' '),
  printLine(T).

printBoard([]).
printBoard([H|T]):-
  printLine(H),
  nl,
  printBoard(T).

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


getLine([H|T],H,1).
getLine([H|T],Line,N):-
  N1 is N-1,
  getLine(T,Line,N1).

getElement([H|T],H,1).
getElement([H|T],Element,N):-
  N1 is N-1,
  getElement(T,Element,N1).


getColumn([],[],_).
getColumn([Line|T],[Element|R],N):-
  getElement(Line,Element,N),
  getColumn(T,R,N).


getLightBulbs(Matrix,X,Y,Number).


solve:-
  problem([Size|Matrix]),
  getPiece(Matrix,Piece,2,1,1,1),
  write(Piece),
  nl,
  nl,
  printBoard(Matrix).
