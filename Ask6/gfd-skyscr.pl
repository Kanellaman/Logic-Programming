:- compile(skies).
:- lib(gfd).
:- lib(gfd_search).
:- import search/6 from gfd_search.

skyscr(P,Solution):-
    puzzle(P,Dim,L,R,U,D,Solution),
    cross(L,R,U,D,Dim,Solution),
    search(Solution,0,most_constrained,indomain,complete,[search_optimization(true)]),!.

transpose([], []).      % Transpose a 2dimensional List
transpose([[]|_], []).
transpose(Matrix, [Row|Rows]) :-
    transpose(Matrix, Row, RestMatrix),
    transpose(RestMatrix, Rows).

transpose([], [], []).
transpose([[X|Xs]|RestMatrix], [X|XValues], [Xs|RestRows]) :-
    transpose(RestMatrix, XValues, RestRows).

constraints([],[],[],_).
constraints([L|RestL],[R|RestR],[X|Rest],N):-
    
    (R\=0 -> visible(List1,X,_),    % Check visibility from the Right side
    nvalues(List1,(#=),R);
    true),

    (L\=0 ->reverse(X,RX),    % Check visibility from the Left side
    visible(List2,RX,_),
    nvalues(List2,(#=),L);
    true),

    alldifferent(X),
    constraints(RestL,RestR,Rest,N).
    
visible([X|[]],[X|[]],[X]).     % Determine visibility
visible([Y|RestY],[X|RestX],SoFar):-
    visible(RestY,RestX,Max),
    append(Max,[X],SoFar),
    Y #= max(SoFar).        % Store the maximum value from the previous ones

cross(L,R,U,D,Dim,Rows):-    % Make 2dimensional List to represent the puzzle
    subL(Dim,Rows),
    N is Dim,
    constraints(L,R,Rows,N),
    transpose(Rows,TRows),
    constraints(U,D,TRows,N).

subL(N,[]).
subL(N,[X|Rest]):-
    X #:: 1..N,
    subL(N,Rest).
