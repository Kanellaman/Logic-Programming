:- compile(activities).
:- lib(ic).

assignment_csp(NP,MT,Assignments,Flatten):-
    findall(AId, activity(AId, _), AIds),
    writeln(AIds),
    length(AIds,N),
    length(Assignments,N),
    Assignments #:: 1..NP,
    overlap(AIds,Assignments),
    /* length(Workers,NP),
    subL(MT,Workers,NP,Flatten),
    alldifferent(Flatten), */
    search(Assignments,0,most_constrained,indomain,complete,[search_optimization(true)]),!.

subL(_,[],_,[]).
subL(MT,[X|Rest],NP,FLattened):-
    length(X, NP),
    X #:: 1..MT,
    subL(MT,Rest,NP,Flat),
    append(Flat,X,FLattened).

overlap([_|[]],[_|[]]).
overlap([AId|RestAids],[Var|RestVar]):-
    % write(AId),write('       '),
    check(AId,RestAids,Var,RestVar),
    % write('\n'),
    overlap(RestAids,RestVar).

check(_,[],_,[]).
check(AId,[X|RestAids],Var,[XVar|RestVar]):-
    activity(AId, act(Ab1, Ae1)),
    activity(X, act(Ab2, Ae2)),
    ((Ab1 > Ae2; Ae1 < Ab2) -> true;
    Var #\= XVar/* ,write(X) */),
    check(AId,RestAids,Var,RestVar).