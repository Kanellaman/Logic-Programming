:- compile(given).
:- lib(ic).
:- lib(branch_and_bound).

maxsat(NV,NC,D,F,S,M):-
   create_formula(NV, NC, D, F),
   findall(K-X,(member(X,F),length(X,K)), T),
   msort(T,New),
   normalize(New,FNew),
   length(S,NV),
   length(Clauses,NC),
   Clauses #:: 0..1,
   exprs(FNew,Clauses,S,Cost),
   M #= NC - Cost,
   bb_min(search(Clauses, 0, input_order, indomain_reverse_split, complete, [search_optimization(true)]), Cost, bb_options{strategy:dichotomic, from:0}),fill(S),!.

fill([]).  % Fill the unassigned values with 0 to avoid late goals 
fill([X|Rest]):-
  (var(X)->X=0;true),
  fill(Rest).

exprs([],_,_,0).    % Build the "constraints" between variables
exprs([X|T],[Xc|Rest],S,Cost):-
   exprs(T,Rest,S,SoFarCost),
   or_list(X,Xc,S),
   Cost #= SoFarCost + (Xc#=0).     % Build the cost

test([X|_],X,1):-!.     % Find the n-th variable of the List and return it
test([X|T],Y,Counter):-
   New is Counter - 1,
   test(T,Y,New).

or_list([], 0,_).
or_list([X|Xs], Or, S) :-
   or_list(Xs, RestOr,S),
   (X > 0 -> 
   test(S,Y,X),Or #= (RestOr or Y);    % Or statements where X positive
   N is abs(X),test(S,Y,N),Or #= (RestOr or (neg Y))      % Or statements where X negative
   ).

normalize([],[]).
normalize([_-X|T], [X|R]):-
   normalize(T,R).