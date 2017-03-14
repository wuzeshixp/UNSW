is_a_list([]).
is_a_list(.(Head, Tail)) :-
	is_a_list(Tail).

head_tail(.(Head, Tail), Head, Tail).

% base case
is_member(Element, list(Element, _)).
% recursive case
is_member(Element, list(_,Tail)) :-
	is_member(Element, Tail).
