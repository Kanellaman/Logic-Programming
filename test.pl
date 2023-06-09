add(nil, X, t(nil,X,nil)).
add(t(L, X, R), X, t(L, X, R)).
add(t(L, Y, R), X, t(NewL, Y, R)):-
    X < Y,
    add(L, X, NewL).

add(t(L, Y, R), X, t(L, Y, NewR)):-
    X > Y,
    add(R, X, NewR).

del(t(nil, X, R), X, R).
del(t(L, X, nil), X, L).
del(t(L, X, R), X, t(L, Y, NR)):-
    delmin(R, Y, NR).
del(t(L, Y, R), X, t(NewL, Y, R)):-
    X < Y,
    del(L, X, NewL).
del(t(L, Y, R), X, t(L, Y, NewR)):-
    X > Y,
    del(R, X, NewR).
delmin(t(nil, X, R), X, R).
delmin(t(L, X, R), Y, t(NL, X, R)):-
    delmin(L, Y, NL).
addroot(nil, X, t(nil, X, nil)).
addroot(t(L, Y, R), X, t(L1, X, t(L2, Y, R))) :-
    X<Y,
    addroot(L, X, t(L1, X, L2)).
addroot(t(L, Y, R), X, t(t(L, Y, R1), X, R2)) :-
    X>Y,
    addroot(R, X, t(R1, X, R2)).