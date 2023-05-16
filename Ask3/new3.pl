:-compile(cross01).
crossword(Crossword,D,F1):-
    dimension(Dim),
    cross(Dim,Crossword),
    fill(Crossword,1),
    words(X),
    length(X,N),
    length(D,N),
    domain(D,X),
    ela(Crossword,[],F1,1),
%    transpose(Crossword,New),
%    ela(New,[],F2,1),
%    append(F1,F2,F),
%    doms(F,SolDom,D).
%    generate(SolDom).

generate([]):-!.
generate(SolDom1):-
    mrv_var(SolDom1,X-Doms,SolDom2),
    member(X,Doms),
    updates(X, SolDom2, New),
    generate(New).

mrv_var([X-Doms],X-Doms,[]).
mrv_var([X1-Doms1|SolDom1],X-Doms,SolDom3):-
    mrv_var(SolDom1,X2-Doms2,SolDom2),
    length(Doms1,N1),
    length(Doms2,N2),
    length(X1,N3),
    length(X2,N4),
%    ((N1 < N2 ; (N1=N2,N3>N4))->
    (N1 < N2 ->
    (X = X1,
    Doms = Doms1,
    SolDom3 = SolDom1);
    (X = X2,
    Doms = Doms2,
    SolDom3 = [X1-Doms1|SolDom2])).

updates(_, [], []).
updates(X, [Y-Domain1|SolDom1], [Y-Domain2|SolDom2]) :-
   remove_if_exists(X,Domain1,Domain2),
   updates(X, SolDom1, SolDom2).

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

fill([],_).     % Fill the crossword with -1 if there is no letter there
fill([Row|Rest],N) :-
    fill(Row,N,1),
    New is N + 1,
    fill(Rest,New).

fill([],_,_).
fill([Elem|Rest],I,N) :-
    New is N + 1,
    (black(I,N)-> Elem = -1 ;true),
    fill(Rest,I,New).
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
printrow([Head|Tail]):-
    (\+ var(Head) -> write('###');write(' '),write(Head),write(' ')),
%   (Head = -1 -> write('###');write(' '),put(Head),write(' ')),
    printrow(Tail).

empty([]).
empty(X):-length(X,1).

ela([],SoFar,SoFar,I):-!.
ela([Head|Rest],SoFarWords,Words,I):-
    row(Head,[],Sec,I),
    append(SoFarWords,Sec,New),
    IN is I + 1,
    ela(Rest,New,Words,IN).

row([],SoFarWords,SoFarWords,I):-!.
row(L,SoFarWords,Words,I):-
    separate_list(L,One,Sec,I),
    (empty(One)->row(Sec,SoFarWords,Words,I);
    append(SoFarWords,[One],New),
    row(Sec,New,Words,I)).

separate_list([], [], [], I).
separate_list([X|Rest], [], Rest, I):-
    \+var(X).
separate_list([X|Rest], [X|Before], After, I) :-
    var(X),
    separate_list(Rest, Before, After, I).

transpose([], []).
transpose([[]|_], []).
transpose(Matrix, [Row|Rows]) :-
    transposeRow(Matrix, Row, RestMatrix),
    transpose(RestMatrix, Rows).

transposeRow([], [], []).
transposeRow([[X|Xs]|RestMatrix], [X|XValues], [Xs|RestRows]) :-
    transposeRow(RestMatrix, XValues, RestRows).

doms([],[],_).
doms([L|Rest],[L-Dom|R],D):-
    length(L,N),
    findall(X,(member(X,D),length(X,NX),N=NX),Dom),
    doms(Rest,R,D).