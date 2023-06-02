:- compile(skies).
:- lib(ic_global).
:- lib(ic).
:- import alldifferent/1 from ic.

skyscr(P,Solution):-
    puzzle(P,Dim,L,R,U,D,Board),
    Solution = Board,
    %fill(Board,1),
    cross(L,R,U,D,Dim,Solution),
    search(Solution,0,occurence,indomain,complete,[search_optimization(true)]).

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
    alldifferent(X),
    (L=0,R=0->constraints(RestL,RestR,Rest,N);
    length(List,N),
    (L=0->reverse(X,Elements),E#=R;Elements=X,E#=L),
    writeln(Elements),
    first(Elements,X1,RestX),
    visible(List,RestX,[X1],Sum),
    eval(Sum,E),
    constraints(RestL,RestR,Rest,N)).

first([X|Rest],X,Rest).

visible([],[],_,1).
visible([Y|RestY],[X|RestX],SoFar,Sum):-
    Y #= ( X #> max(SoFar) ),
    append(SoFar,[X],New),
    visible(RestY,RestX,New,PrevSum),
    Sum #= PrevSum + Y.

cross(L,R,U,D,Dim,Rows):-    % Make 2dimensional List to represent board
    subL(Dim,Rows),
    print2d(Rows),
    write('\n'),
    N is Dim - 1,
    constraints(L,R,Rows,N),
    transpose(Rows,TRows),
    constraints(U,D,TRows,N).

subL(N,[]).
subL(N,[X|Rest]):-
    X #:: 1..N,
    subL(N,Rest).

fill([],_).     % Fill the crossword with i,j positions
fill([Row|Rest],N):-
    fill(Row,N,1),
    New is N + 1,
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