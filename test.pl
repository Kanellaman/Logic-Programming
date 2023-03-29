allbetween(L,U,[]):- L>U.
allbetween(L,U,[L|X]):-
    L =< U,
    L1 is L+1,
    allbetween(L1,U,X).


kane(State,NewState,S):-
    length(State,N),
    S < N,
    L is N-S+2,
    reverse(State,RState),
    em(State,L,N,New1),
    em(RState,S,N,New2),
    append(New1,New2,NewState).

em(_,S,N,[]) :-
    S > N.

em([X1|Y1],S,N,[X1|A]):-
    N1 is N - 1,
    S =< N,
    writeln(X1),
    em(Y1,S,N1,A),!.

