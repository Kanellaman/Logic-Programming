:- compile(dfs).

initial_state(state(3, 3, left)).
final_state(state(3, 3, right)).

move(state(MB1, CB1, B1), state(MB2, CB2, B2)) :-
   opposite(B1, B2),
   travel(MT, CT),
   MT =< MB1,
   CT =< CB1,
   MB2 is 3-MB1+MT,
   CB2 is 3-CB1+CT,
   (MB2 = 0 ;
    MB2 = 3 ;
    MB2 \= 0, MB2 \= 3, MB2 = CB2).

opposite(left, right).
opposite(right, left).

travel(1, 0).
travel(0, 1).
travel(1, 1).
travel(2, 0).
travel(0, 2).