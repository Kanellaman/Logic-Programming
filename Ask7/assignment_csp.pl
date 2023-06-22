:- compile(activities).
:- lib(gfd).
:- lib(gfd_search).
:- import search/6 from gfd_search.

assignment_csp(NP, MT, ASP, ASA) :-
    /* Data in Lists */
    findall(AId, activity(AId, _), AIds),
    length(AIds, N),
    length(Assignments, N),
    length(Durations, N),

    /* Constraints */
    Assignments #:: 1..NP,
    overlap(AIds, Assignments, Durations),
    max_time(NP, Durations, 0, MT, [], Sums),
    Assignments= [ First | Rest],
    First #= 1,
    symmetric(Rest, [First]),

    /* Search-Solutions */
    search(Assignments, 0, input_order, indomain, complete, []),
    results(AIds, Assignments, ASA),
    makeASP(ASP, ASA, Sums).

overlap([], [], []).
overlap([AId|RestAids], [Var|RestVars], [Var-Duration|RestDurations]) :-
    activity(AId, act(Ab, Ae)),
    Duration is Ae - Ab,
    check(AId, RestAids, Var, RestVars),
    overlap(RestAids, RestVars, RestDurations).

check(_, [], _, []).
check(AId, [X|RestAids], Var, [XVar|RestVars]) :-
    activity(AId, act(Ab1, Ae1)),
    activity(X, act(Ab2, Ae2)),
    (( Ae2 - Ab1 =< 1; Ab2-Ae1 >= 1) -> true;
    Var #\= XVar),
    check(AId, RestAids, Var, RestVars).

max_time(NP, _, N, _, Sums, Sums):-
    N >= NP,!.
max_time(NP, Durations, N, MT, SoFar, Sums) :-
    New is N + 1,
    constraints(Durations, New, 0, Sum),
    Sum #=< MT,
    append(SoFar, [New-Sum], S),
    max_time(NP, Durations, New, MT, S, Sums).

constraints([Var-Duration], N, Sum, S):-
    S #= Sum + (Var #= N)*Duration.
constraints([Var-Duration|RestDurations], N, F, S) :-
    Sum #= F + (Var #= N)*Duration,
    constraints(RestDurations, N, Sum, S).

symmetric([], _).
symmetric([Var|RestVars], SoFar) :-
    Var #=< max(SoFar) + 1,
    append(SoFar, [Var], Miax),
    symmetric(RestVars, Miax).

results([], [], []).
results([AId|RestAids], [Var|RestVars], [AId-Var|RestASA]) :-
    results(RestAids, RestVars, RestASA).

makeASP([], _, []).
makeASP([N-AIds-Sum|Rest], ASA, [N-Sum|RestSums]) :-
    findall(AId, (member(Element, ASA), match(N, Element, AId)), AIds),
    makeASP(Rest, ASA, RestSums).

match(Worker, AId-Worker, AId).