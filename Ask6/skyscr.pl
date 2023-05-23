:- compile(skies).
:- lib(ic).
:- lib(ic_global).

skyscr(P,Solution):-
    puzzle(P,Dim,L,R,U,D,Board),
    transpose(Board,TBoard),
    cross(Dim,Solution).

transpose([], []).
transpose([[]|_], []).
transpose(Matrix, [Row|Rows]) :-
    transpose(Matrix, Row, RestMatrix),
    transpose(RestMatrix, Rows).

transpose([], [], []).
transpose([[X|Xs]|RestMatrix], [X|XValues], [Xs|RestRows]) :-
    transpose(RestMatrix, XValues, RestRows).

cross(N,L):-    % Make 2dimensional List to represent board
    length(L,N),
    subL(N,L).
subL(_,[]).
subL(N,[X|L]):-
    length(X,N),
    X #:: 1..N,
    subL(N,L).