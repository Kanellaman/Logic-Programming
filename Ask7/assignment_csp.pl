:- compile(activities).
:- lib(ic).

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
    first(Assignments, First, Rest),
    symmetric(Rest, [First]),

    /* Search-Solutions */
    search(Assignments, 0, input_order, indomain, complete, [search_optimization(true)]),
    results(AIds, Assignments, ASA),
    makeASP(ASP, ASA, Sums).
first([X|Rest],X,Rest).

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
    ((Ab1 > Ae2; Ae1 < Ab2) -> true;
    Var #\= XVar),
    check(AId, RestAids, Var, RestVars).

results([], [], []).
results([AId|RestAids], [Var|RestVars], [AId-Var|RestASA]) :-
    results(RestAids, RestVars, RestASA).

makeASP([], _, []).
makeASP([N-AIds-Sum|Rest], ASA, [N-Sum|RestSums]) :-
    findall(AId, (member(Element, ASA), match(N, Element, AId)), AIds),
    makeASP(Rest, ASA, RestSums).

match(Worker, AId-Worker, AId).

max_time(NP, _, NP, _, Sums, Sums).
max_time(NP, Durations, N, MT, SoFar, Sums) :-
    NP > N,
    New is N + 1,
    constraints(Durations, New, Sum),
    Sum #< MT + 1,
    append(SoFar, [New-Sum], S),
    max_time(NP, Durations, New, MT, S, Sums).

constraints([], _, 0).
constraints([Var-Duration|RestDurations], N, Sum) :-
    constraints(RestDurations, N, S),
    Sum #= S + (Var #= N)*Duration.

symmetric([], _).
symmetric([Var|RestVars], SoFar) :-
    Var #=< max(SoFar) + 1,
    append(SoFar, [Var], Max),
    symmetric(RestVars, Max).
