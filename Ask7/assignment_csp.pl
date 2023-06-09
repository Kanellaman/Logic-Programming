:- compile(activities).
:- lib(gfd).
:- lib(gfd_search).
:- import search/6 from gfd_search.

assignment_csp(NP,MT,Workers,Flatten):-
    length(Workers,NP),
    subL(MT,Workers,NP,Flatten),
    alldifferent(Flatten),
    search(Workers,0,most_constrained,indomain,complete,[search_optimization(true)]),!.

subL(_,[],_,[]).
subL(MT,[X|Rest],NP,FLattened):-
    length(X, NP),
    X #:: 1..MT,
    subL(MT,Rest,NP,Flat),
    append(Flat,X,FLattened).