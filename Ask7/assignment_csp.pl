:- compile(activities).
:- lib(gfd).
:- lib(gfd_search).
:- import search/6 from gfd_search.

assignment_csp(NP,MT,ASP,ASA):-
    /* Data in Lists */
    findall(AId, activity(AId, _), AIds),
    length(AIds,N),
    length(Assignments,N),
    length(Duration,N),

    /* Constraints */
    Assignments #:: 1..NP,
    overlap(AIds,Assignments,Durations),
    max_time(NP, Durations, 0, MT),

    search(Assignments,0,most_constrained,indomain,complete,[search_optimization(true)]),
    results(AIds,Assignments,ASA),
    makeASP(NP,ASP,0,ASA).

overlap([],[],[]).
overlap([AId|RestAids],[Var|RestVars],[Var-Duration|RestDurations]):-
    activity(AId, act(Ab, Ae)),
    Duration is Ae - Ab,
    check(AId,RestAids,Var,RestVars),
    overlap(RestAids,RestVars,RestDurations).

check(_,[],_,[]).
check(AId,[X|RestAids],Var,[XVar|RestVars]):-
    activity(AId, act(Ab1, Ae1)),
    activity(X, act(Ab2, Ae2)),
    ((Ab1 > Ae2; Ae1 < Ab2) -> true;
    Var #\= XVar),
    check(AId,RestAids,Var,RestVars).

results([],[],[]).
results([AId|RestAids],[Var|RestVars],[AId-Var|RestASA]):-
    results(RestAids,RestVars,RestASA).

makeASP(NP,[],NP,_).
makeASP(NP,[New-AIds|Rest],N,ASA):-
    NP > N,
    New is N + 1,
    findall(AId, (member(Element, ASA), match(New, Element, AId)), AIds),
    makeASP(NP,Rest,New,ASA).

match(Worker, AId-Worker, AId).

max_time(NP, _, NP, _).
max_time(NP, Durations, N, MT):-
    NP > N,
    New is N + 1,
    constraints(Durations,New,Sum),
    Sum #< MT + 1,
    writeln(Sum),
    max_time(NP, Durations, New, MT).

constraints([],_,0).
constraints([Var-Duration|RestDurations],N,Sum):-
    constraints(RestDurations,N,S),
    Sum #= S + (Var #= N)*Duration.