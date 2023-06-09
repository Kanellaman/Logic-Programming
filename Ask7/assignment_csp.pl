:- compile(activities).
:- lib(gfd).
:- lib(gfd_search).
:- import search/6 from gfd_search.

assignment_csp(NP,MT,ASP,ASA):-
    findall(AId, activity(AId, _), AIds),
    length(AIds,N),
    length(Assignments,N),
    length(Duration,N),
    Assignments #:: 1..NP,
    overlap(AIds,Assignments,Duration),
    /* length(Workers,NP),
    subL(MT,Workers,NP,Flatten),
    alldifferent(Flatten), */
    search(Assignments,0,most_constrained,indomain,complete,[search_optimization(true)]),
    results(AIds,Assignments,ASA),
    makeASP(NP,ASP,0,ASA).

subL(_,[],_,[]).
subL(MT,[X|Rest],NP,FLattened):-
    length(X, NP),
    X #:: 1..MT,
    subL(MT,Rest,NP,Flat),
    append(Flat,X,FLattened).

overlap([],[],[]).
overlap([AId|RestAids],[Var|RestVars],[Duration|RestDurations]):-
    % write(AId),write('       '),
    activity(AId, act(Ab, Ae)),
    Duration is Ae - Ab,
    check(AId,RestAids,Var,RestVars),
    % write('\n'),
    overlap(RestAids,RestVars,RestDurations).

check(_,[],_,[]).
check(AId,[X|RestAids],Var,[XVar|RestVars]):-
    activity(AId, act(Ab1, Ae1)),
    activity(X, act(Ab2, Ae2)),
    ((Ab1 > Ae2; Ae1 < Ab2) -> true;
    Var #\= XVar/* ,write(X) */),
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