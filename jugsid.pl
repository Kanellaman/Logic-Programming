solve_jugs(JugC1, JugC2, JugF, States) :-
   InitialState = jugs(0,0),
   solve_jugs_iter(JugC1, JugC2, JugF, 0, InitialState, States).

solve_jugs_iter(JugC1, JugC2, JugF, Lim, InitialState, States) :-
   ldfs(JugC1, JugC2, JugF, Lim, InitialState, [InitialState],  States),
   !.
solve_jugs_iter(JugC1, JugC2, JugF, Lim, InitialState, States) :-
   Lim1 is Lim+1,
   solve_jugs_iter(JugC1, JugC2, JugF, Lim1, InitialState, States).

ldfs(_, _, JugF, _, jugs(0,JugF), States, States).
ldfs(JugC1, JugC2, JugF, Lim, State1, SoFarStates, States) :-
   Lim > 0,
   Lim1 is Lim - 1,
   move(JugC1, JugC2, State1, State2),
   \+ member(State2, SoFarStates),
   append(SoFarStates, [State2], NewSoFarStates),
   ldfs(JugC1, JugC2, JugF, Lim1, State2, NewSoFarStates, States).

move(JugC1, JugC2, jugs(V1, V2), jugs(W1, W2)) :-
   L is V1+V2,
   ((V1 < JugC1, W1 = JugC1, W2 = V2) ;
    (V2 < JugC2, W1 = V1, W2 = JugC2) ;
    (V1 > 0, W1 = 0, W2 = V2) ;
    (V2 > 0, W1 = V1, W2 = 0) ;
    (minimum(L, JugC2, W2), W1 is L-W2) ;
    (minimum(L, JugC1, W1), W2 is L-W1)).

minimum(X, Y, X) :- X =< Y.
minimum(X, Y, Y) :- X > Y. 