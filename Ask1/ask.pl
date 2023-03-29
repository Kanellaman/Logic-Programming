
dfs(States) :-
   initial_state(State),
   dfs(State, [State], States).

dfs(State, States, States) :-
   final_state(State).
dfs(State1, SoFarStates, States) :-
   move(State1, State2),
   \+ member(State2, SoFarStates),
   append(SoFarStates, [State2], NewSoFarStates),
   dfs(State2, NewSoFarStates, States).

initial_state(state(3,2,4,1)).
final_state(state(1,2,3,4)).

move(state(Piex1,Piez1,Piey1,Piev1),state(Piex2,Piez2,Piey2,Piev2)):-
    ((spatoylwse(Piex1),
    Piev1 = Piex2,
    Piey1 = Piez2,
    Piez1 = Piey2,
    Piex1 = Piev2);
    (spatoylwse(Piez1),
    Piev1 = Piez2,
    Piey1 = Piey2,
    Piez1 = Piev2,
    Piex1 = Piex2);
    (spatoylwse(Piey1),
    Piev1 = Piey2,
    Piey1 = Piev2,
    Piez1 = Piez2,
    Piex1 = Piex2)).

spatoylwse(1).
spatoylwse(2).
spatoylwse(3).
spatoylwse(4).
