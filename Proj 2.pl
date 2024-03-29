:-use_module(library(lists)).
:-use_module(library(clpfd)).

problem([5,
        [1,_,_,_,_],
        [_,2,_,_,_],
        [_,_,_,_,_],
        [_,_,_,_,_],
        [_,_,_,_,1]]).

myprint(-1):-
  write('O').
myprint(0):-
  write('-').
myprint(5):-
  write('X').
myprint(H):-
  write(H).

printLine([]).
printLine([H|T]):-
  myprint(H),
  write(' '),
  printLine(T).

printBoard([]).
printBoard([H|T]):-
  printLine(H),
  nl,
  printBoard(T).

getLine([H|T],H,1).
getLine([H|T],Line,N):-
  N1 is N-1,
  getLine(T,Line,N1).

getLine(Matrix,Line,N):-
  nth1(N,Matrix,Line).

getElement([H|T],H,1).
getElement([H|T],Element,N):-
  N1 is N-1,
  getElement(T,Element,N1).

getElement(Line,Element,N):-
  nth1(N,Line,Element).


getColumn([],[],_).
getColumn([Line|T],[Element|R],N):-
  getElement(Line,Element,N),
  getColumn(T,R,N).

getPiece(Board,X,Y,Piece):-
  getLine(Board,Line,Y),
  getElement(Line,Piece,X).

copy(L,L).

getLightBulbs(Matrix,X,Y,L):-
  Left is X-1, Right is X+1,
  Top is Y-1, Bot is Y+1,
  (getPiece(Matrix,Left,Y,LeftPiece),append([],[LeftPiece],L1);copy([],L1)),
  (getPiece(Matrix,Right,Y,RightPiece),append(L1,[RightPiece],L2);copy(L1,L2)),
  (getPiece(Matrix,X,Top,TopPiece),append(L2,[TopPiece],L3);copy(L2,L3)),
  (getPiece(Matrix,X,Bot,BotPiece),append(L3,[BotPiece],L);copy(L3,L)).

restringeBlocos(Board,Size):-
  restringeBlocos(Board,Size,1,1).

restringeBlocos(Board,Size,Size1,Size1):-
  Size1 is Size+1.
restringeBlocos(Board,Size,Size1,Y):-
  Size1 is Size+1,
  Y1 is Y+1,
  restringeBlocos(Board,Size,0,Y1).
restringeBlocos(Board,Size,X,Y):-
  ((getPiece(Board,X,Y,Piece),nonvar(Piece),getLightBulbs(Board,X,Y,L),
  Piece<5,Val is 0-Piece, sum(L,#=,Val));true),
  (X1 is X+1, restringeBlocos(Board,Size,X1,Y)).


getBlocos([],[]).
getBlocos([[]|T],L):-
  getBlocos(T,L).
getBlocos([[Elem|R]|T],[Elem|T2]):-
  nonvar(Elem),
getBlocos([R|T],T2).
getBlocos([[Elem|R]|T],T2):-
  getBlocos([R|T],T2).

getSectionsLines([],[]).
getSectionsLines([Line|R],[LineSecs|T]):-
  getSectionsLine(Line,LineSecs),
  getSectionsLines(R,T).

getSectionsLine([],[]).
getSectionsLine(Line,T):-
  getSectionsLineAux(Line,Section,R),
  Section=[],
  getSectionsLine(R,T).
getSectionsLine(Line,[Section|T]):-
  getSectionsLineAux(Line,Section,R),
  getSectionsLine(R,T).

getSectionsLineAux([],[],[]).
getSectionsLineAux([Element|R],[],R):-
  nonvar(Element).
getSectionsLineAux([Element|R],[Element|T],X):-
  var(Element), getSectionsLineAux(R,T,X).

restringeLinhas([]).
restringeLinhas([[]|T]):-
  restringeLinhas(T).
restringeLinhas([[LineSec|R]|T]):-
  sum(LineSec,#=,-1),
  restringeLinhas([R|T]).

getFirst([First|_],First).

getLuzes([],[]).
getLuzes([[]|T],L):-
  getLuzes(T,L).
getLuzes([[Elem|R]|T],[Elem|T2]):-
  var(Elem),
  getLuzes([R|T],T2).
getLuzes([[Elem|R]|T],T2):-
  getLuzes([R|T],T2).

getTudo([],[]).
getTudo([[]|T],L):-
  getTudo(T,L).
getTudo([[Elem|R]|T],[Elem|T2]):-
  getTudo([R|T],T2).

getAllCols([Size|Matrix],NewMatrix):-
  getAllCols([Size|Matrix],NewMatrix,1).

getAllCols([Size|_],[],Size1):-
  Size1 is Size+1.
getAllCols([Size|Matrix],[Column|R],N):-
  getColumn(Matrix,Column,N),
  N1 is N+1,
  getAllCols([Size|Matrix],R,N1).


restringe([Size|Board]):-
  getLuzes(Board,Luzes),
  domain(Luzes,-1,0),
  restringeBlocos(Board,Size),
  getSectionsLines(Board,Secs),
  restringeLinhas(Secs),
  getAllCols([Size|Board],Cols),
  getSectionsLines(Cols,ColSecs),
  restringeLinhas(ColSecs),
  getTudo(Board,Vars),
  labeling([],Vars).

teste:-
  problem([Size|Matrix]),
  getLine(Matrix,Linha,1),
  copy([],A),
  getSectionsLineAux(Linha,A,[]),nl,nl,
  write(A).

solve:-
  problem([Size|Matrix]),
  restringe([Size|Matrix]),
  printBoard(Matrix).
