:- compile(skies).
:- lib(ic_global).
:- lib(ic).
:- import alldifferent/1 from ic.

skyscr(P,Solution):-
    puzzle(P,Dim,L,R,U,D,Solution),
    cross(L,R,U,D,Dim,Solution),
    search(Solution,0,occurence,indomain,complete,[search_optimization(true)]),!.

transpose([], []).
transpose([[]|_], []).
transpose(Matrix, [Row|Rows]) :-
    transpose(Matrix, Row, RestMatrix),
    transpose(RestMatrix, Rows).

transpose([], [], []).
transpose([[X|Xs]|RestMatrix], [X|XValues], [Xs|RestRows]) :-
    transpose(RestMatrix, XValues, RestRows).

constraints([],[],[],_).
constraints([L|RestL],[R|RestR],[X|Rest],N):-
    
    (R\=0 -> visible(List3,X,_),
    nvalue(R,List3);true),

    (L\=0 ->reverse(X,RX),
    visible(List4,RX,_),
    nvalue(L,List4);true),

    alldifferent(X),
    constraints(RestL,RestR,Rest,N).
    
visible([X|[]],[X|[]],[X]).
visible([Y|RestY],[X|RestX],SoFar):-
    visible(RestY,RestX,Max),
    append(Max,[X],SoFar),
    Y #= max(SoFar).

cross(L,R,U,D,Dim,Rows):-    % Make 2dimensional List to represent board
    subL(Dim,Rows),
    N is Dim,
    constraints(L,R,Rows,N),
    transpose(Rows,TRows),
    constraints(U,D,TRows,N).

subL(N,[]).
subL(N,[X|Rest]):-
    X #:: 1..N,
    subL(N,Rest).