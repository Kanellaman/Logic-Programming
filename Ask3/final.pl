:-compile(cross10).
crossword(Res):-
    preprocessign(Crossword,Domains,Horizontal,Vertical),
    append(Horizontal,Vertical,Total), 
    doms(Total,SolDom,Domains), % SolDom contains all variables with their domains
    generatehor(SolDom),!, % Find the solution
    result(SolDom,Res), % Store the solution in a readable list
    print2d(Crossword). % Print the crossword

preprocessign(Crossword,Domains,Horizontal,Vertical):-
    dimension(Dim),
    cross(Dim,Crossword),
    fill(Crossword,1),
    words(X),
    length(X,N),
    length(Domains,N),
    domain(Domains,X),
    ela(Crossword,[],Horizontal),
    transpose(Crossword,New),
    ela(New,[],Vertical).

doms([],[],_).
doms([L-Z|Rest],[L-Z-Dom|R],D):-
    length(L,N),
    findall(X,(member(X,D),length(X,NX),N=NX),Dom),
    doms(Rest,R,D).

generatehor([]):-!.
generatehor(SolDom1):-
    mrv_var(SolDom1,X - Pos - Doms,SolDom2),
    member(X,Doms),
    updates1(X, Pos, SolDom2, SolDom3),
    generatehor(SolDom3).

mrv_var([X-Pos-Doms],X-Pos-Doms,[]).
mrv_var([X1-Pos1-Doms1|SolDom1],X-Pos-Doms,SolDom3):-
    mrv_var(SolDom1,X2-Pos2-Doms2,SolDom2),
    length(Doms1,N1),
    length(Doms2,N2),
    ((N1 < N2 ; (N1=N2,
    length(X1,N3),
    length(X2,N4),N3>N4))->
%    (N1 < N2 ->
    (X = X1,
    Pos=Pos1,
    Doms = Doms1,
    SolDom3 = SolDom1);
    (X = X2,
    Pos=Pos2,
    Doms = Doms2,
    SolDom3 = [X1-Pos1-Doms1|SolDom2])).

updates1(_, _, [], []).
updates1(X, PosX, [Y - PosY - Domain1|SolDom1], [Y - PosY - Domain3|SolDom2]) :-
   remove_if_exists(X,Domain1,Domain2),
   (mem(I-J,PosX,X,Elem,1),position(I-J,PosY,1,P),length(Y,N),P=<N ->
   mem2d(Elem, P, Domain2, [], Domain3);
   copy(Domain2,[],Domain3)),
   updates1(X, PosX, SolDom1, SolDom2).



mem(I-J,[I-J|Rest],[Elem|Tail],Elem,Position).
mem(I-J,[_-_|Rest],[_|Tail],Elem,CurrentPos):-
    NewPosition is CurrentPos + 1,
    mem(I-J,Rest,Tail,Elem,NewPosition).

position(I-J,[I-J|T],Pos,Pos):-!.
position(I-J,[_|T],CurrentPos,Pos):-
    NewPos is CurrentPos + 1,
    position(I-J,T,NewPos,Pos).

mem2d(_, _, [], SoFar, SoFar).
mem2d(X, J, [Row|Rest], SoFar, Dom) :-
    (tr(X, J, Row,1) -> mem2d(X, J, Rest, SoFar, Dom); 
    append(SoFar, [Row], New),
    mem2d(X, J, Rest, New, Dom)).

tr(_, _, [], _):- fail.
tr(X, J, [Elem|Rest],N):-
    (J=N ,X\=Elem -> true;
        (J=N->fail;
        New is N + 1,
        tr(X,J,Rest,New))),!.

copy([],Copy,Copy).
copy([H1|T1],SoFar,Copy):-
    append(SoFar,[H1],New),
    copy(T1,New,Copy).
remove_if_exists(_, [], []).
remove_if_exists(X, [X|List], List) :-
   !.
remove_if_exists(X, [Y|List1], [Y|List2]) :-
   remove_if_exists(X, List1, List2).

cross(N,L):-    % Make 2dimensional List to represent crossword
    length(L,N),
    subL(N,L).
subL(_,[]).
subL(N,[X|L]):-
    length(X,N),
    subL(N,L).

domain(_,[]).   % Make all words arithmetic values
domain([H|T],[Head|Tail]):-
    domain(T,Tail),
    name(Head,H).

ela([],SoFar,SoFar):-!.
ela([Head|Rest],SoFarWords,Words):-
    row(Head,[],Sec),
    append(SoFarWords,Sec,New),
    ela(Rest,New,Words).

empty([]).
empty(X):-length(X,1).

separate([],SoFarWords,SoFarWords):-!.  % Separate a List to smaller lists that contain only variable elements
separate(L,SoFarWords,Words):-
    separate_list(L,One,Half,Sec),
    (empty(One)->row(Sec,SoFarWords,Words);
    append(SoFarWords,[One-Half],New),
    separate(Sec,New,Words)).

separate_list([], [], [],[]).   % Separate a list when ###(non variable) is found
separate_list([X-I-J|Rest], [], [], Rest):-
    \+var(X).
separate_list([X-I-J|Rest], [X|Before], [I-J|Bef], After) :-
    var(X),
    separate_list(Rest, Before, Bef, After).

transpose([], []).
transpose([[]|_], []).
transpose(Matrix, [Row|Rows]) :-
    transpose(Matrix, Row, RestMatrix),
    transpose(RestMatrix, Rows).

transpose([], [], []).
transpose([[X|Xs]|RestMatrix], [X|XValues], [Xs|RestRows]) :-
    transpose(RestMatrix, XValues, RestRows).

fill([],_).     % Fill the crossword with ### and i,j positions
fill([Row|Rest],N):-
    fill(Row,N,1),
    New is N + 1,
    fill(Rest,New).

fill([],_,_).   % Fill each row with ### and the i,j position in the crossword
fill([Elem-I-N|Rest],I,N) :-
    New is N + 1,
    (black(I,N)-> Elem = ### ;true),
    fill(Rest,I,New).

result([],[]).
result([Elem-_-_|Tail],[X|T]):-
    name(X,Elem),
    result(Tail,T).

print2d([]).
print2d([Head|Tail]):-
    printrow(Head),
    write('\n'),
    print2d(Tail).
printrow([]).
printrow([Head-_-_|Tail]):-
%    (\+ var(Head) -> write('###');write(' '),write(Head),write(' ')),
   (Head = ### -> write(Head);write(' '),put(Head),write(' ')),
    printrow(Tail).
