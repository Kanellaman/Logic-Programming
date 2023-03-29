:- compile(dfs).

initial_state(fwgc(l, l, l, l)).
final_state(fwgc(r, r, r, r)).

move(fwgc(F1, W1, G1, C1), fwgc(F2, W2, G2, C2)) :-
   opposite(F1, F2),
   ((W1 = W2, G1 = G2, C1 = C2) ;
    (opposite(W1, W2), G1 = G2, C1 = C2) ;
    (W1 = W2, opposite(G1, G2), C1 = C2) ;
    (W1 = W2, G1 = G2, opposite(C1, C2))),
   \+ illegal(fwgc(F2, W2, G2, C2)).

illegal(fwgc(F, W, G, C)) :-
   opposite(F, G),
   (G = W ; G = C).

opposite(l, r).
opposite(r, l). 