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

flatten([], []) :- !.
flatten([X|L], F) :- !,
    flatten(X, FX),
    flatten(L, FL),
    append(FX, FL, F).
flatten(X, [X]).

intersection([],_,[]).
intersection([X|L1],L2,[X|L]) :-
    member(X,L2),
    intersection(L1,L2,L).
intersection([_|L1],L2,L):-intersection(L1,L2,L).
