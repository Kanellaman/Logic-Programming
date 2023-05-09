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
generate(SolDom1):-
    mrv_var(SolDom1,X - Pos - Doms,SolDom2),
    member(X,Doms),
    updates(X, Pos, SolDom2, New),
    generate(New).

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


updates(_, _, [], []).
updates(X, PosX, [Y - PosY - Domain1|SolDom1], [Y - PosY - Domain2|SolDom2]) :-
   update(X, PosX, PosY,Y, Domain1, Domain2),
   updates(X, PosX, SolDom1, SolDom2).

update(X, PosX, PosY,Y, Domain1, Domain3):-
   remove_if_exists(X,Domain1,Domain2),
   (xor(PosX,PosY),member(I-J,PosX),member(I-J,PosY),length(X,N1),length(Y,N),(N1<N;N1=N) -> mem2d(Elem, J, Domain2, [], Domain3);copy(Domain2,[],Domain3)).

check([X - _, X - _ | _]).
xor(PosX, PosY) :-
    (   check(PosX), \+ check(PosY)
    ;   check(PosY), \+ check(PosX)
    ).
mem2d(_, _, [], SoFar, SoFar).
mem2d(X, J, [Row|Rest], SoFar, Dom) :-
    (tr(X, J, Row,1) -> mem2d(X, J, Rest, SoFar, Dom); 
    append(SoFar, [Row], New),
    mem2d(X, J, Rest, New, Dom)).

get_element_at([], _, _) :- fail.  % Base case: list is empty, element not found.
get_element_at([Element|_], 1, Element).  % Base case: index is 0, return the element.
get_element_at([_|Tail], Index, Element) :-
    Index > 0,
    NewIndex is Index - 1,
    get_element_at(Tail, NewIndex, Element).
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
printrow([Head-_-_|Tail]):-
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