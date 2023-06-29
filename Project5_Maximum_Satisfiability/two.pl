:- lib(ic).
:- lib(branch_and_bound).
maxsat(NV,NC,D,F,S,M):-
   create_formula(NV, NC, D, F),
   length(S,NV),
   S #:: 0..1,
   exprs(F,S,Cost),
   M #= NC - Cost,
   bb_min(search(S, 0, occurence, indomain, complete, [search_optimization(true)]), Cost, bb_options{strategy:dichotomic, from:0}),!.

exprs([],_,0).    % Build the "constraints" between variables
exprs([X|T],S,Cost):-
   exprs(T,S,SoFarCost),
   or_list(X,Xc,S),
   Cost #= SoFarCost + (Xc#=0).     % Build the cost

test([X|_],X,1):-!.
test([X|T],Y,Counter):-
   New is Counter - 1,
   test(T,Y,New).

or_list([], 0,_).
or_list([X|Xs], Or, S) :-
   or_list(Xs, RestOr,S),
   (X > 0 -> 
   test(S,Y,X),Or #= (RestOr or Y);
   N is abs(X),test(S,Y,N),Or #= (RestOr or (neg Y))      % Or statements
   ).