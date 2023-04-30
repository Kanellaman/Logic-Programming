fc_nqueens(N, Queens) :-
   length(Queens, N),
   make_domain(N, Domain),
   combine_soldom(Queens, 1, Domain, SolDom),
   generate_solution(SolDom).

make_domain(1, [1]).
make_domain(N, Domain) :-
   N > 1,
   N1 is N - 1,
   make_domain(N1, RestDomain),
   append(RestDomain, [N], Domain).

combine_soldom([], _, _, []).
combine_soldom([X|Queens], I, Domain, [X-I-Domain|SolDom]) :-
   I1 is I + 1,
   combine_soldom(Queens, I1, Domain, SolDom).

generate_solution([]).
generate_solution([X-I-Domain|SolDom1]) :-
   member(X, Domain),
   update_domains(X, I, SolDom1, SolDom2),
   generate_solution(SolDom2).

update_domains(_, _, [], []).
update_domains(X, I1, [Y-I2-Domain1|SolDom1], [Y-I2-Domain2|SolDom2]) :-
   update_domain(X, I1, I2, Domain1, Domain2),
   update_domains(X, I1, SolDom1, SolDom2).

update_domain(X, I1, I2, Domain1, Domain4) :-
   remove_if_exists(X, Domain1, Domain2),
   XPlus is X + I2 - I1,
   remove_if_exists(XPlus, Domain2, Domain3),
   XMinus is X - I2 + I1,
   remove_if_exists(XMinus, Domain3, Domain4).

remove_if_exists(_, [], []).
remove_if_exists(X, [X|List], List) :-
   !.
remove_if_exists(X, [Y|List1], [Y|List2]) :-
   remove_if_exists(X, List1, List2).