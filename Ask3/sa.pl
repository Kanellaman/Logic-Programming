dimension(5).
black(1,3).
black(2,3).
black(3,2).
black(4,3).
black(5,1).
black(5,5).
words([adam,al,as,do,ik,lis,ma,oker,ore,pirus,po,so,ur]).
crossword(Crossword,D,SolDom1):-
    dimension(Dim),
    cross(Dim,Crossword),
    fill(Crossword,1),
    words(X),
    length(X,N),
    length(D,N),
    domain(D,X),
    cross(Dim,SolDom1).

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
member2d(X, [Row|Rest]) :-
    member(X, Row);
    member2d(X, Rest).