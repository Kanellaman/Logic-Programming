makelist(L,X,N) :-
    X =:= N.
makelist(L,X,N) :-
    X =< N,
    append(L,[X],L1,K),
    X1 is X+1,
    writeln(L),
    makelist(L1,X1,N).

create_list(1, [1]).
create_list(N, [N|Rest]) :-
    N > 1,
    N1 is N - 1,
    create_list(N1, Rest).