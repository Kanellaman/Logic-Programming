:- compile(skies).
:- lib(ic).
:- lib(ic_global).

skyscr(P,Solution):-
    puzzle(P,Dim,L,R,U,D,Board),
    transpose(Board,TBoard),
    cross(Dim,Solution),
    fill(Board,1).

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

fill([],_).     % Fill the crossword with i,j positions
fill([Row|Rest],N):-
    fill(Row,N,1),
    New is N + 1,
    writeln(Row),
    fill(Rest,New).

fill([],_,_).   % Fill each row with i,j position in the crossword
fill([Elem|Rest],I,N) :-
    New is N + 1,
    (var(Elem) ->Elem = _-I-N;
    true),           % Skip filling if the cell is already filled
    fill(Rest,I,New).

print2d([]).
print2d([Head|Tail]):-
    printrow(Head),
    write('\n'),
    print2d(Tail).
printrow([]).
printrow([Head|Tail]):-
    write(Head),
    printrow(Tail).