dimension(5).
black(1,3).
black(2,3).
black(3,2).
black(4,3).
black(5,1).
black(5,5).
words([adam,al,as,do,ik,lis,ma,oker,ore,pirus,po,so,ur]).
crossword(Crossword,D,SolDom,Test):-
    dimension(Dim),
    cross(Dim,Crossword),
    fill(Crossword,1),
    words(X),
    length(X,N),
    length(D,N),
    domain(D,X),
    cross(Dim,SolDom1),
    findall(1, between(1, Dim, _), Is),
    dom(1,1,Is,1,Crossword,SolDom1,Crossword,D,_),
    flatten_2d_list(SolDom1,SolDom),
%    findall(Y-I-J-Domain,(member(Y-I-J-Domain,SolDom),\+empty(Domain)),Test),
    generate(SolDom).
empty([]).
generate([]).
generate([X-I-J-Domain|SolDom1]):-
    (var(X)->member(X,Domain),updates(X,SolDom1,SolDom2),generate(SolDom2);generate(SolDom1)).
    %(var(X)->member(X,Domain);true),generate(SolDom1).
    %member(X,Domain),updates(X,SolDom1,SolDom2),generate(SolDom2).
updates(_,[],[]).
updates(X,[Y-I-J-Domain1|SolDom1],[Y-I-J-Domain2|SolDom2]):-
    update(X,Domain1,Domain2),
    updates(X,SolDom1,SolDom2).

update(X,Domain1,Domain2):-
    remove_if_exists(X, Domain1, Domain2).

remove_if_exists(_, [], []).
remove_if_exists(X, [X|List], List) :-!.
remove_if_exists(X, [Y|List1], [Y|List2]) :-
   remove_if_exists(X, List1, List2).

cross(N,L):-    % Make 2dimensional List to represent crossword
    length(L,N),
    subL(N,L).
member_2d(X, [Row|Rest]) :-
    member(X, Row);
    member_2d(X, Rest).
flatten_2d_list([], []).
flatten_2d_list([X|Xs], FlatList) :-
    flatten_2d_list(Xs, Rest),
    append(X, Rest, FlatList).
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
dom(J,[I|Is],JN,[Elem|Rest],[Elem-I-JN-Dom|R],L,D,[IN|IsN]):-
    (var(Elem) -> 
    (findall(X,member_2d(X,D),Dom)),JN2 is JN + 1,IN is I + 1 ;
    IN is 1,JN2 is 1, Dom= []),
    Jnew is J + 1,
    dom(Jnew,Is,JN2,Rest,R,L,D,IsN).
%(N1<N2->copy(Dom1,Dom);copy(Dom2,Dom))
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
    (black(I,N)-> Elem = -1 ;true),
    fill(Rest,I,New).
print2d([]).
print2d([Head|Tail]):-
    printrow(Head),
    write('\n'),
    print2d(Tail).
printrow([]).
printrow([Head|Tail]):-
%    (\+ var(Head) -> write('###');write(' '),write(Head),write(' ')),
   (Head = -1 -> write('###');write(' '),put(Head),write(' ')),
    printrow(Tail).

copy([],[]).
copy([H1|T1], [H2|T2]):-
    H2 is H1,
    copy(T1,T2).
pr([]).
pr([_-_-_-Dom|Rem]):-
    prin(Dom),
    write('\n'),
    pr(Rem).
prin([]).
prin([Head|Rem]):-
    put(Head),write(' '),prin(Rem).
between(I, J, I) :-
   I =< J.
between(I, J, X) :-
   I < J,
   I1 is I+1,
   between(I1, J, X).