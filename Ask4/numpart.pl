w:- lib(ic_global).
:- lib(ic).
:- import alldifferent/1 from ic.
numpart(N, L1, L2):-
    New is N // 2,
    length(L1,New),
    L1 #:: 1..N,
    constrains(L1,N),
    search(L1, 0, occurence, indomain_middle, complete, [search_optimization(true)]),
    findall(X,(between(1,N,X),\+member(X,L1)),L2).

constrains(L1,N):-
    alldifferent(L1),
    ordered_sum(L1,F),
    member(1,L1),
    F #= N*(N+1)/4,
    Expression #= N*(N+1)*(2*N+1)/12,
    sum_list(L1, SquareSum),
    eval(SquareSum,Expression).

between(L,U,L):-
    L =< U.
between(L,U,X):-
    L < U,
    L1 is L + 1,
    between(L1,U,X).

sum_list([], 0).
sum_list([X|Xs], Sum) :-
    sum_list(Xs, RestSum),
    Sum #= (X*X)+RestSum.