occur([],L):-!.
occur([X|T],Cal):-
    occur(T,NCal).

add([X-N|Rest],[X-New|Rest],X):-
    New is N + 1, !.
add([X-N|T1],[X-N|T2],Y):-
   add(T1,T2,Y).

update([],L,L).
update([X|T],L,G):-
    lis(X,L,F),
    update(T,F,G).

lis([],L,L).
lis([X|T],L,G):-
    Elem is abs(X),
    add(L,F,Elem),
    lis(T,F,G).


between(L,U,L):-
    L =< U.
between(L,U,X):-
    L < U,
    L1 is L + 1,
    between(L1,U,X).  