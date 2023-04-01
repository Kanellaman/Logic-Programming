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
    AIds = [a01, a02, a03, a04, a05, a06, a07, a08, a09, a10, a11, a12, a13, a14, a15]
    assign(AIds, NP, ASA).
assign([], _, []).
assign([AId|AIds], NP, [AId-PId|ASA]) :-
    assign(AIds, NP, ASA),
    between(1,NP,PId),
    activity(AId, act(Ab, Ae)),
    append(ASA,[AId],APIds),
    valid(Ab, Ae, APIds).
valid(_, _, []).
valid(Ab1, Ae1, [APId|APIds]) :-
    activity(APId, act(Ab2, Ae2)),
