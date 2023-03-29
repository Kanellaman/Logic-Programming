pancakes_dfs(State1,Operators,States) :-
    dfs(State1,[State1],States,[],Operators).


dfs(State, States, States,Operators, Operators) :-
   final_state(State).
dfs(State1, SoFarStates, States,SoFarOperators, Operators) :-
   move(State1, State2,X),
   \+ member(State2, SoFarStates),
   append(SoFarStates, [State2], NewSoFarStates),
   append(SoFarOperators,[X],NewSoFarOperators),
   dfs(State2, NewSoFarStates, States,NewSoFarOperators,Operators).

final_state(state(1,2,3,4)).

move(state(Piex1,Piez1,Piey1,Piev1),state(Piex2,Piez2,Piey2,Piev2),X):-
    ((spatoylwse(Piex1),
    Piev1 = Piex2,
    Piey1 = Piez2,
    Piez1 = Piey2,
    Piex1 = Piev2,X is Piex1);
    (spatoylwse(Piez1),
    Piev1 = Piez2,
    Piey1 = Piey2,
    Piez1 = Piev2,
    Piex1 = Piex2,X is Piez1);
    (spatoylwse(Piey1),
    Piev1 = Piey2,
    Piey1 = Piev2,
    Piez1 = Piez2,
    Piex1 = Piex2,X is Piey1)).

create_list(1, [1]).
create_list(N, [N|Rest]) :-
    N > 1,
    N1 is N - 1,
    create_list(N1, Rest).


spatoylwse(1).
spatoylwse(2).
spatoylwse(3).
spatoylwse(4).
