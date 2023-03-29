pancakes_ids(State1,Operators,States,K) :-
    length(State1,N),
    create_list(N,L),
    reverse(L,RL),
    solve_ids(State1,States,Operators,RL,0,K).

solve_ids(State, States, Operators,L,Lim,K) :-
    idfs(State, [State], States, [], Operators, L, Lim),!.
solve_ids(State, States, Operators, L, Lim,K) :-
    Lim1 is Lim + 1,
    solve_ids(State, States, Operators, L, Lim1,K),writeln(K).

idfs(State, States, States, Operators, Operators,L,Lim):-
    are_same(L,State).
idfs(State1, SoFarStates, States, SoFarOperators, Operators,L,Lim) :-
   Lim > 0,
   Lim1 is Lim - 1,
   move(State1, State2,S),
   \+ member(State2, SoFarStates),
   append(SoFarStates, [State2], NewSoFarStates),
   append(SoFarOperators,[S],NewSoFarOperators),
   idfs(State2, NewSoFarStates, States,NewSoFarOperators,Operators,L,Lim1).

move(State,NewState,S):-
    length(State,N),
    between(1,N,S),
    kane(State,NewState,S).

kane(State,NewState,S):-
    length(State,N),
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
    em(Y1,S,N1,A),!.

create_list(1, [1]).
create_list(N, [N|Rest]) :-
    N > 1,
    N1 is N - 1,
    create_list(N1, Rest).

between(L,U,L):-
    L=<U.
between(L,U,X):-
    L<U,
    L1 is L+1,
    between(L1,U,X).

are_same([], []).
are_same([H1|T1], [H1|T2]) :-
  H1 = H1,
  are_same(T1, T2).