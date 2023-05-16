:-compile(cross16).
crossword(Crossword,D,SolDom):-
    dimension(Dim),
    cross(Dim,Crossword),
    fill(Crossword,1),
    words(X),
    length(X,N),
    length(D,N),
    domain(D,X),
    ela(Crossword,[],F1),
    transpose(Crossword,New),
    ela(New,[],F2),
    append(F1,F2,F),
    doms(F,SolDom,D),
    generate(SolDom).

doms([],[],_).
doms([L-Z|Rest],[L-Z-Dom|R],D):-
    length(L,N),
    findall(X,(member(X,D),length(X,NX),N=NX),Dom),
    doms(Rest,R,D).

generate([]):-!.
generate([X - Pos - Doms|SolDom1]):-
    member(X,Doms),
    updates(X, Pos, SolDom1, New),
    generate(New).

updates(_, _, [], []).
updates(X, PosX, [Y - PosY - Domain1|SolDom1], [Y - PosY - Domain2|SolDom2]) :-
   update(X, PosX, PosY, Domain1, Domain2),
   updates(X, PosX, SolDom1, SolDom2).

update(X, PosX, PosY, Domain1, Domain2):-
   remove_if_exists(X,Domain1,Domain2),
   (member(I-J,PosX),member(I-J,PosY) -> mem2d(X, J, Domain2, [], Domain3);
   copy(Domain2,[],Domain3)).

mem2d(X, J, [], SoFar, SoFar).
mem2d(X, J, [Row|Rest], SoFar, Dom) :-
    (tr(X, J, Row,1) -> mem2d(X, J, Rest, SoFar, Dom); 
    append(SoFar, Row, New),
    mem2d(X, J, Rest, New, Dom)).

tr(X,H, [], _):- fail.
tr(X, J, [Elem|Rest],N):-
    (J=N ,X\=Elem -> true;
        (J=N->fail;
        New is N + 1,
        tr(X,J,Rest,New))),!.

copy([],SoFar,SoFar).
copy([H1|T1],SoFar,Copy):-
    append(SoFar,H1,New),
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
domain(_,[]).
domain([H|T],[Head|Tail]):-
    domain(T,Tail),
    name(Head,H).

print2d([]).
print2d([Head|Tail]):-
    printrow(Head),
    write('\n'),
    print2d(Tail).
printrow([]).
printrow([Head-I-J|Tail]):-
%    (\+ var(Head) -> write('###');write(' '),write(Head),write(' ')),
   (Head = -1 -> write('###');write(' '),put(Head),write(' ')),
    printrow(Tail).

ela([],SoFar,SoFar):-!.
ela([Head|Rest],SoFarWords,Words):-
    row(Head,[],Sec),
    append(SoFarWords,Sec,New),
    ela(Rest,New,Words).
empty([]).
empty(X):-length(X,1).
row([],SoFarWords,SoFarWords):-!.
row(L,SoFarWords,Words):-
    separate_list(L,One,Half,Sec),
    (empty(One)->row(Sec,SoFarWords,Words);
    append(SoFarWords,[One-Half],New),
    row(Sec,New,Words)).

separate_list([], [], [],[]).
separate_list([X-I-J|Rest], [], [], Rest):-
    \+var(X).
separate_list([X-I-J|Rest], [X|Before], [I-J|Bef], After) :-
    var(X),
    separate_list(Rest, Before, Bef, After).

transpose([], []).
transpose([[]|_], []).
transpose(Matrix, [Row|Rows]) :-
    transposeRow(Matrix, Row, RestMatrix),
    transpose(RestMatrix, Rows).

transposeRow([], [], []).
transposeRow([[X|Xs]|RestMatrix], [X|XValues], [Xs|RestRows]) :-
    transposeRow(RestMatrix, XValues, RestRows).

fill([],_).     % Fill the crossword with -1 if there is no letter there
fill([Row|Rest],N) :-
    fill(Row,N,1),
    New is N + 1,
    fill(Rest,New).

fill([],_,_).
fill([Elem-I-N|Rest],I,N) :-
    New is N + 1,
    (black(I,N)-> Elem = -1 ;true),
    fill(Rest,I,New).