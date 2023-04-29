dimension(5).
black(1,3).
black(2,3).
black(3,2).
black(4,3).
black(5,1).
black(5,5).
words([adam,al,as,do,ik,lis,ma,oker,ore,pirus,po,so,ur]).
crossword(Crossword,D,F,Is):-
    words(X),
    length(X,N),
    length(D,N),
    domain(D,X),
    dimension(Dim),
    cross(Dim,Crossword),
    fill(Crossword,1),
    % get(1,1,2,D,El),
    cross(Dim,F),
    findall(1, between(1, Dim, _), Is),
    dom(1,1,Is,1,Crossword,F,Crossword,D,_).

domain(_,[]).
domain([H|T],[Head|Tail]):-
    domain(T,Tail),
    name(Head,H).

get(I,J,N,[Row|Rest],El):-
    get(J,N,Row,El).
get(I,J,N,[Row|Rest],El):-
    Inew is I + 1,
    get(Inew,J,N,Rest,El).
    
get(J,N,[Head|Tail],El):-
    (J = N -> El is Head; Jnew is J + 1,get(Jnew,N,Tail,El)).
    
dom(_,_,_,_,[],_,_,_,_).
dom(I,J,Is,JN,[Head|Tail],[H|T],L,D,_):- % 1,1,1,1
    dom(J,Is,1,Head,H,L,D,IsN),
    Inew is I + 1,
dom(Inew,J,IsN,JN,Tail,T,L,D,_).

dom(_,_,_,[],_,_,_,_).
dom(J,[I|Is],JN,[Elem|Rest],[Elem - I - JN - Dom|R],L,D,[IN|IsN]):-
    (var(Elem) -> (I=JN ->findall(X,get(1,1,JN,D,X),Dom);findall(Y,get(1,1,I,D,Y);get(1,1,JN,D,Y),Dom)),JN2 is JN + 1,IN is I +1 ; IN is 1,JN2 is 1, Dom= [] ),
    Jnew is J + 1,
    dom(Jnew,Is,JN2,Rest,R,L,D,IsN).

is_var(I,J,[Row|Rest],N,El):-
    (N = I -> is_var(J,Row,1,El);
    New is N + 1, is_var(I,J,Rest,New,El)).

is_var(J,[Elem|Rest],N,Elem):-
    (N = J -> (var(Elem) -> true; false); New is N + 1,is_var(J,Rest,New,Elem)).

cross(N,L):-    % Make 2dimensional List to represent crossword
    length(L,N),
    subL(N,L).

subL(_,[]).
subL(N,[X|L]):-
    length(X,N),
    subL(N,L).

fill([],_).     % Fill the crossword with -1 if there is no letter there
fill([Row|Rest],N) :-
    fill(Row,N,1),
    New is N + 1,
    fill(Rest,New).

fill([],_,_).
fill([Elem|Rest],I,N) :-
    New is N + 1,
    (black(I,N)-> Elem is -1;true),
    fill(Rest,I,New).

print2d([]).
print2d([Head|Tail]):-
    printrow(Head),
    write('\n'),
    print2d(Tail).
printrow([]).
printrow([Head|Tail]):-
    (var(Head) ->  write(' '),write(Head),write(' ');write('###')),
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