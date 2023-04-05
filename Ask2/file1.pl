activity(a01, act(0,3)).
activity(a02, act(0,4)).
activity(a03, act(1,5)).
activity(a04, act(4,6)).
activity(a05, act(6,8)).
activity(a06, act(6,9)).
activity(a07, act(9,10)).
activity(a08, act(9,13)).
activity(a09, act(11,14)).
activity(a10, act(12,15)).
activity(a11, act(14,17)).
activity(a12, act(16,18)).
activity(a13, act(17,19)).
activity(a14, act(18,20)).
activity(a15, act(19,20)).

assignment(NP, MT, ASP, ASA) :-
    findall(AId, activity(AId, _), AIds),
    assign(AIds, NP, ASA, MT).

assign([], _, [], MT).
assign([AId|AIds], NP, [AId-PId|ASA], MT) :-
    assign(AIds, NP, ASA, MT),
    between(1,NP,PId),
    activity(AId, act(Ab, Ae)),
    findall(APId, (member(APId, AIds), APId \= AId, member(APId-PId, ASA)), APIds),
    MT1 is MT - (Ae - Ab),
    valid(Ab, Ae, APIds, MT1).

valid(_, _, [], _).
valid(Ab1, Ae1, [APId|APIds], MT) :-
    activity(APId, act(Ab2, Ae2)),
    MT1 is MT - (Ae2 - Ab2),
    MT1 >= 0,
    (Ab1 > Ae2; Ae1 < Ab2),
    valid(Ab1, Ae1, APIds, MT1).

between(L,U,L):-
    L =< U.
between(L,U,X):-
    L < U,
    L1 is L + 1,
    between(L1,U,X).  
