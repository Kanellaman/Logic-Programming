:- compile(dfs).

initial_state(jugs(0, 0)).
final_state(jugs(0, 4)).

move(jugs(V1, V2), jugs(W1, W2)) :-
   C1 = 8, C2 = 5, L is V1+V2,
   ((V1 < C1, W1 = C1, W2 = V2) ;
    (V2 < C2, W1 = V1, W2 = C2) ;
    (V1 > 0, W1 = 0, W2 = V2) ;
    (V2 > 0, W1 = V1, W2 = 0) ;
    (minimum(L, C2, W2), W1 is L-W2) ;
    (minimum(L, C1, W1), W2 is L-W1)).

minimum(X, Y, X) :- X =< Y.
minimum(X, Y, Y) :- X > Y.