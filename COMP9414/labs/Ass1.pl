% QUESTION 1:
% sumsq_div3or5(Numbers, Sum) :- Sums squares of only numbers divisible by 5
% or by 3, in a list of (positive or negative) whole numbers

% Using higher-order predicates and defined predicates of div and sqr in
% list with more than one element, first we filter numbers in list Numbers
% that is divisible by 3 and 5 using the include function into list L3 and
% list L5, as well as our defined predicate div, then merge the 2 lists into
% LF using append function. Then utilise the map function to square all the
% elements in list LF using our defined predicate which is sqr into list LF2, 
% then add all the elements in list LF2 using the sumlist function 

sumsq_div3or5(Numbers, Sum) :-
    include(div(3), Numbers, L3),
    include(div(5), Numbers, L5),
    append(L3, L5, LF),
    maplist(sqr, LF, LF2),
    sumlist(LF2, Sum).

div(N,M) :-
    0 is M mod N.

sqr(X,Y) :-
Y is X * X.






% Q2:
% same_name(Person1, Person2) :- Both persons are sharing the same family name
%
% Person1 and Person2 have the same father
same_name(Person1, Person2) :-
    parent(Parent, Person1),
    parent(Parent, Person2),
    male(Parent),
    Person1 \= Person2.

% Person1 is the father of Person2
same_name(Person1, Person2) :-
    parent(Person1, Person2),
    male(Person1),
    Person1 \= Person2.

% Person2 is the father of Person1
same_name(Person1, Person2) :-
    parent(Person2, Person1),
    male(Person2),
    Person1 \= Person2.

% Person1 is the father of X, who
% is the father of Person2 
same_name(Person1, Person2) :-
    parent(Person1, X),
    parent(X, Person2),
    male(Person1),
    male(X),
    Person1 \= Person2.

% Person2 is the father of X, who
% is the father of Person1
same_name(Person1, Person2) :-
    parent(Person2, X),
    parent(X, Person1),
    male(Person2),
    male(X),
    Person1 \= Person2.



% Q4
% function_table(+N, +M, +Function, -Result)
% Binds Result to a list containing elements of the form [X, Y] where Y is
% Function(X). The Xs in the list start at N and decrease by one until they
% Reach M.
% M is required to be less than or equal to N.
%
% Assignment comment:
% A cut in the N, N case would be better than the N=\=M check in the other.
function_table(N, N, Function, [[N, Result]]) :-
    Temp =.. [Function, N],
    Result is Temp.
function_table(N, M, Function, [[N, Result]|RestResult]) :-
    N =\= M,
    Temp =.. [Function, N],
    Result is Temp,
    NewN is N-1,
function_table(NewN, M, Function, RestResult).
