assignment(NP, MT, ASP, ASA) :-
    findall(AId, activity(AId, _), AIds),
    assign(AIds, NP, ASA, MT),
    findall(A,em(A,ASA,AIds,NP),ASP).

assign([], _, [], _).
assign([AId|AIds], NP, [AId-PId|ASA], MT) :-
    assign(AIds, NP, ASA, MT),
    findall(PId, member(APId-PId, ASA), PIds),
    length(PIds,N),
    (N = 0 -> F is 0; max(PIds,F)),
    (F < NP-> Bound is F + 1; Bound is NP),
    between(1,Bound,PId),
    activity(AId, act(Ab, Ae)),
    findall(APId, (member(APId, AIds), APId \= AId, member(APId-PId, ASA)), APIds),
    MT1 is MT - (Ae - Ab),
    valid(Ab, Ae, APIds, MT1,M).

valid(_, _, [], MT,M):- M is MT.
valid(Ab1, Ae1, [APId|APIds], MT,M) :-
    activity(APId, act(Ab2, Ae2)),
    MT1 is MT - (Ae2 - Ab2),
    MT1 >= 0,
    (Ab1 > Ae2; Ae1 < Ab2),
    valid(Ab1, Ae1, APIds, MT1,M).

between(L,U,L):-
    L =< U.
between(L,U,X):-
    L < U,
    L1 is L + 1,
    between(L1,U,X).  

em(PId-ASP-M,ASA,AIds,NP):-
    between(1,NP,PId),findall(APId, (member(APId-PId, ASA)), ASP),
    sum_list(ASP,M).

sum_list([], 0).
sum_list([Head|Tail], Sum) :-
    sum_list(Tail, Rest),
    activity(Head,act(A,B)),
    Sum is (B-A) + Rest.