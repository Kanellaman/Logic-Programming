

goal_state(Pies) :-
    sort(0,@<,Pies, SortedPies),
    Pies = SortedPies.

valid_state(Pies) :- 
    length(Pies, N),
    N >= 1,
    N1 is N + 1,
    plate_diameter(Pies, Diameter),
    Diameter >= N1.

plate_diameter(Pies, Diameter) :- 
    length(Pies, N),
    Diameter is N + 1.

swap([Pie1,Pie2|Rest], [Pie2,Pie1|Rest]).

dfs(CurrentState, _, []) :- 
    goal_state(CurrentState).
dfs(CurrentState, VisitedStates, [Operator|Path]) :- 
    swap(CurrentState, NewState),
    valid_state(NewState),
    \+ member(NewState, VisitedStates),
    dfs(NewState, [NewState|VisitedStates], Path),
    Operator = swap(NewState, CurrentState).

solve(Pies, Path) :- 
    dfs(InitialState, [InitialState], Path),
    Pies = InitialState.
