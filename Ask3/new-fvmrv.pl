:-compile(cross16).
crossword(Crossword,SolDom2,SolDom3):-
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
    doms(F1,SolDom1,D),
    doms(F2,SolDom2,D),
    doms(F,SolDom,D),
    generatehor(SolDom,SolDom2,SolDom3),!.

doms([],[],_).
doms([L-Z|Rest],[L-Z-Dom|R],D):-
    length(L,N),
    findall(X,(member(X,D),length(X,NX),N=NX),Dom),
    doms(Rest,R,D).

generatehor([],_,_):-!.
generatehor(SolDom1,SolDom3,Sol):-
    mrv_var(SolDom1,X - Pos - Doms,SolDom2),
    member(X,Doms),
    %updates(X, Pos, SolDom2, SolDom4),
    updates1(X, Pos, SolDom2, SolDom4),
    generatehor(SolDom4,SolDom5,Sol).

valid([_-_-[]|_]):-!.
valid([_-_-_|Rest]):-
valid(Rest).
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

updates1(_, _, [], []).
updates1(X, PosX, [Y - PosY - Domain1|SolDom1], [Y - PosY - Domain3|SolDom2]) :-
   update(X, Domain1, Domain2),
   (mem(I-J,PosX,X,Elem,1),position(I-J,PosY,1,P),length(Y,N),P=<N ->
   mem2d(Elem, P, Domain2, [], Domain3);
   copy(Domain2,[],Domain3)),
   (empty1(Domain3)->false;true),
   updates1(X, PosX, SolDom1, SolDom2).
empty1([]).
updates(_, _, [], []).
updates(X, PosX, [Y - PosY - Domain1|SolDom1], [Y - PosY - Domain2|SolDom2]) :-
   update(X, Domain1, Domain2),
   updates(X, PosX, SolDom1, SolDom2).

update(X, Domain1, Domain2):-
   remove_if_exists(X,Domain1,Domain2).

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