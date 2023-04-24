dimension(5).
black(1,3).
black(2,3).
black(3,2).
black(4,3).
black(5,1).
black(5,5).
words([adam,al,as,do,ik,lis,ma,oker,ore,pirus,po,so,ur]).
crossword(Crossword):-
    words(X),
    length(X,N),
    length(D,N),
    domain(D,X),
    dimension(Dim),
    cross(Dim,Crossword),
    fill(Crossword,1),
    sol(Crossword,D).

sol([],_).
sol(Crossword,D):-
    sol(,D),
    member(X,D),
    .

match()    

domain(_,[]).
domain([H|T],[Head|Tail]):-
    domain(T,Tail),
    name(Head,H).
cross(N,L):-
    length(L,N),
    subL(N,L).

subL(_,[]).
subL(N,[X|L]):-
    length(X,N),
    subL(N,L).

fill([],_).
fill([Row|Rest],N) :-
    fill(Row,N,1),
    New is N + 1,
    fill(Rest,New).

fill([],_,_).
fill([Elem|Rest],I,N) :-
    New is N + 1,
    (black(I,N)-> Elem is -1;Elem is 5),
    fill(Rest,I,New).

print2d([]).
print2d([Head|Tail]):-
    printrow(Head),
    write('\n'),
    print2d(Tail).
printrow([]).
printrow([Head|Tail]):-
    (Head = -1-> write('###') ; write(' '),write(Head),write(' ')),
    printrow(Tail).

member_2d(X, [Row|Rest]) :-
    member(X, Row);
    member_2d(X, Rest).




bt_nqueens(N, Queens) :-
   make_tmpl(1, N, Queens),
   solution(N, Queens).

make_tmpl(N, N, [N/_]).
make_tmpl(I, N, [I/_|Rest]) :-
   I < N,
   I1 is I+1,
   make_tmpl(I1, N, Rest).

solution(_, []).
solution(N, [X/Y|Others]) :-
   solution(N, Others),
   between(1, N, Y),
   noattack(X/Y, Others).

between(I, J, I) :-
   I =< J.
between(I, J, X) :-
   I < J,
   I1 is I+1,
   between(I1, J, X).

noattack(_, []).
noattack(X/Y, [X1/Y1|Others]) :-
   Y =\= Y1,
   Y1-Y =\= X1-X,
   Y1-Y =\= X-X1,
   noattack(X/Y, Others).