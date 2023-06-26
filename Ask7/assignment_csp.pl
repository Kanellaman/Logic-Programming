:- compile(activitiesbig).
:- lib(gfd).
:- lib(gfd_search).
:- lib(branch_and_bound).
:- import search/6 from gfd_search.

assignment_csp(NP, MT, ASP, ASA) :-
    /* Data in Lists */
    findall(AId, activity(AId, _), AIds),  % Collect all activity IDs into a list
    length(AIds, N),  % Get the total number of activities
    length(Assignments, N),  % Create a list of assignment variables with the same length as activities
    length(Durations, N),  % Create a list of duration variables with the same length as activities

    /* Constraints */
    Assignments #:: 1..NP,
    overlap(AIds, Assignments, Durations),  % Apply the overlap constraint between activities and assignments
    max_time(NP, Durations, 0, MT, [], Sums),  % Calculate the maximum time spent by each worker and collect the sums
    Assignments= [ First | Rest],
    First #= 1,  % The first assignment must be worker 1
    symmetric(Rest, [First]),  % Enforce symmetry in the assignments

    /* Search-Solutions */
    search(Assignments, 0, input_order, indomain, complete, []),
    results(AIds, Assignments, ASA),  % Collect the final assignment results
    makeASP(ASP, ASA, Sums).  % Generate an answer set program based on the assignment results

assignment_opt(NF, NP, MT, F, T, ASP, ASA, Cost):-
    
    /* Data in Lists */
    findall(AId, activity(AId, _), AIdsAll),  % Collect all activity IDs into a list
    length(AIdsAll, N1),  % Get the total number of activities
    ( (NF = 0; NF > N1) -> N = N1, AIds = AIdsAll;  % If the number of fixed activities is 0 or greater than the total number of activities, use all activities
    length(AIds, NF),  % Otherwise, use the specified number of fixed activities
    N = NF,
    append(AIds, _, AIdsAll)),  % Extract the first NF activities from the list

    findall(Time, (member(AId, AIds), activity(AId, act(A,B)), Time is B - A), Durs),  % Calculate the durations of the selected activities
    sum_list(Durs, D),  % Calculate the total duration of the selected activities
    length(Assignments, N),  % Create a list of assignment variables with the same length as activities
    length(Durations, N),  % Create a list of duration variables with the same length as activities

    /* Constraints */
    Assignments #:: 1..NP,
    overlap(AIds, Assignments, Durations),
    max_time(NP, Durations, 0, MT, [], Sums),
    Assignments= [ First | Rest],
    First #= 1,
    symmetric(Rest, [First]),

    /* Cost */
    rnd(D, NP, A),  % Calculate the round division of D by NP
    sum_cost(A, Sums, [], C),  % Calculate the cost based on the assignments and sums

    Cost #= sum(C),  % The total cost is the sum of individual costs

    Bound is abs(D - A*NP),
        
    /* Search-Solutions */
    bb_min(search(Assignments, 0, most_constrained, indomain, complete, []), Cost,
    bb_options{strategy:dichotomic,timeout:T,factor:F,from:Bound}),
    
    results(AIds, Assignments, ASA),
    makeASP(ASP, ASA, Sums).

overlap([], [], []).
overlap([AId | RestAids], [Var | RestVars], [Var - Duration | RestDurations]) :-
    activity(AId, act(Ab, Ae)),  % Get the start and end times of the activity
    Duration is Ae - Ab,  % Calculate the duration of the activity
    check(AId, RestAids, Var, RestVars),  % Check for overlap with other activities
    overlap(RestAids, RestVars, RestDurations).

check(_, [], _, []).
check(AId, [X|RestAids], Var, [XVar|RestVars]) :-
    activity(AId, act(Ab1, Ae1)),  % Get the start and end times of the current activity
    activity(X, act(Ab2, Ae2)),  % Get the start and end times of the other activity
    ((Ae2 - Ab1 =< 1; Ab2 - Ae1 >= 1) -> true;  % If the activities don't overlap in time, they are valid
    Var #\= XVar),  % Otherwise, the assignments must be different
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
    Var #=< max(SoFar) + 1,  % The current assignment must be less than or equal to the maximum assignment so far plus 1
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

sum_list([], 0).
sum_list([Head|Tail], Sum) :-
  sum_list(Tail, TailSum),
  Sum is Head + TailSum.

/* Cost predicates */

rnd(Dividend, Divisor, Result) :-       /* Round Division to Nearest Integer */
    Quotient is Dividend / Divisor,
    Div is Dividend div Divisor,
    Decimal is Quotient - Div,
    (Decimal < 0.5 -> Result = Div;
    Result is Div + 1).

sum_cost(_, [], Cost, Cost).
sum_cost(A, [_-W|Rest], SoFar, Cost):-
    Temp #=  (A - W)^2,
    append(SoFar, [Temp], Sum),
    sum_cost(A, Rest, Sum, Cost).