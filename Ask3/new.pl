dimension(6).

black(_,_) :- fail.

words([asides,asides,caress,caress,devoir,devoir,isolde,isolde,odessa,odessa,
       zodiac,zodiac]).

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


generate([]):-!.
generate([X-Doms|Rest]):-
    member(X,Doms),
    updates(X, Rest, New),
    generate(New).

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
    separate_list(L,One,Sec),
    (empty(One)->row(Sec,SoFarWords,Words);
    append(SoFarWords,[One],New),
    row(Sec,New,Words)).

separate_list([], [], []).
separate_list([X|Rest], [], Rest):-
    \+var(X).
separate_list([X|Rest], [X|Before], After) :-
    var(X),
    separate_list(Rest, Before, After).

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