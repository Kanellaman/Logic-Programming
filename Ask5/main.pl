:- compile(given).
:- lib(ic).
:- lib(branch_and_bound).
maxsat(NV,NC,D,F,S,M):-
   create_formula(NV, NC, D, F),
   length(S,NV),
   S #:: 0..1,
   length(C,NC),
   C #:: 0..1,
   exprs(F,S,C,Cost),
   M #= NC - Cost,
   bb_min(search(S, 0, occurence, indomain, complete, [search_optimization(true)]), Cost, bb_options{strategy:restart}),!.

exprs([],_,[],0).
exprs([X|T],S,[Xc|Tc],Cost):-
   exprs(T,S,Tc,SoFarCost),
   and_list(X,Xc,S),
   Cost #= SoFarCost + (Xc#=0).

test([X|_],X,1):-!.
test([X|T],Y,Counter):-
   New is Counter - 1,
   test(T,Y,New).

or_list([], 0,_).
or_list([X|Xs], Or, S) :-
   or_list(Xs, RestOr,S),
   (X > 0 -> 
   test(S,Y,X),Or #= (RestOr or Y);
   N is abs(X),test(S,Y,N),Or #= (RestAnd or (neg Y))
   ).