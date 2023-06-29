pancakes_ids(State1,Operators,States) :-
    length(State1,N),
    create_list(N,L),
    valid(State1,L),
    reverse(L,RL),
    solve_ids(State1,States,Operators,RL,0).

solve_ids(State, States, Operators,L,Lim) :-
    idfs(State, [State], States, [], Operators, L, Lim),!.
solve_ids(State, States, Operators, L, Lim) :-
    Lim1 is Lim + 1,
    solve_ids(State, States, Operators, L, Lim1).

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
    member(S,State),
    kane(State,NewState,S).

kane(State,NewState,S):-
    em(State,S,ToFlip),
    reverse(ToFlip,Flipped),
    em1(State,S,NoFlipped),
    append(Flipped,NoFlipped,NewState).

em([X|Y],X,[X]).
em([X|Y],S,[X|A]):-
    em(Y,S,A).

em1([X|Y],X,Y).
em1([X|Y],S,A):-
    em1(Y,S,A).

create_list(1, [1]).
create_list(N, [N|Rest]) :-
    N > 1,
    N1 is N - 1,
    create_list(N1, Rest).

are_same([], []).
are_same([H1|T1], [H1|T2]) :-
  H1 = H1,
  are_same(T1, T2).

valid([],_).
valid([X|Y],L):-
    member(X,L),
    \+ member(X,Y),
    valid(Y,L).