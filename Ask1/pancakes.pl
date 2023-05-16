pancakes_dfs(State1,Operators,States) :-
    length(State1,N),
    create_list(N,L),
    valid(State1,L),
    reverse(L,RL),
    dfs(State1, [State1], States,[], Operators, RL).

dfs(State, States, States, Operators, Operators, L) :-
    are_same(L,State).
dfs(State1, SoFarStates, States, SoFarOperators, Operators, L) :-
   move(State1, State2, S),
   \+ member(State2, SoFarStates),
   append(SoFarStates, [State2], NewSoFarStates),
   append(SoFarOperators, [S], NewSoFarOperators),
   dfs(State2, NewSoFarStates, States, NewSoFarOperators, Operators, L).


move(State,NewState,S):-
    length(State,N),
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
    member(X,L),    % Element out of range
    \+ member(X,Y), % Duplicates
    valid(Y,L).