% Program:  family.pl
% Source:   Prolog
%
% Purpose:  This is the sample program for the Prolog Lab in COMP9414/9814.
%           It is a simple Prolog program to demonstrate how prolog works.
%           See lab.html for a full description.
%
% History:  18-Feb-1999   Original code    Barry Drake


% parent(Parent, Child)
%
parent(albert, jim).
parent(albert, peter).
parent(jim, brian).
parent(john, darren).
parent(peter, lee).
parent(peter, sandra).
parent(peter, james).
parent(peter, kate).
parent(peter, kyle).
parent(brian, jenny).
parent(irene, jim).
parent(irene, peter).
parent(pat, brian).
parent(pat, darren).
parent(amanda, jenny).


% female(Person)
%
female(irene).
female(pat).
female(lee).
female(sandra).
female(jenny).
female(amanda).
female(kate).

% male(Person)
%
male(albert).
male(jim).
male(peter).
male(brian).
male(john).
male(darren).
male(james).
male(kyle).


% yearOfBirth(Person, Year).
%
yearOfBirth(irene, 1923).
yearOfBirth(pat, 1954).
yearOfBirth(lee, 1970).
yearOfBirth(sandra, 1973).
yearOfBirth(jenny, 1996).
yearOfBirth(amanda, 1979).
yearOfBirth(albert, 1926).
yearOfBirth(jim, 1949).
yearOfBirth(peter, 1945).
yearOfBirth(brian, 1974).
yearOfBirth(john, 1955).
yearOfBirth(darren, 1976).
yearOfBirth(james, 1969).
yearOfBirth(kate, 1975).
yearOfBirth(kyle, 1976).

% rules
grandParent(Grandparent, GrandChild) :-
	parent(Grandparent, Child),
	parent(Child, GrandChild).

% older(Person1, Person2) :- Person1 is oldwer than Person 2
% 
older(Person1, Person2) :-
	yearOfBirth(Person1, Year1),
	yearOfBirth(Person2, Year2),
	Year2 > Year1.

% siblings(Person1, Person2) :- Do they share a parent?
%
siblings(Person1, Person2) :-
	parent(Parent, Person1),
	parent(Parent, Person2),
	not(Person1 = Person2).

olderBrother(OlderBro, Younger) :-
	yearOfBirth(OlderBro, Year1),
	yearOfBirth(Younger, Year2),
	Year1 < Year2,
	male(OlderBro),
	siblings(OlderBro, Younger).

descendant(Person, Descendant) :-
	parent(Person, Descendant).
descendant(Person, Descendant) :-
	parent(Person, Child),
	descendant(Child, Descendant).

ancestor(Person, Ancestor) :-
	parent(Ancestor, Person).
ancestor(Person, Ancestor) :-
	parent(Ancestor, Parent),
	ancestor(Person, Parent).

% children(Parent, ChildList), 
%	where ChildList is the list of children of Parent
children(Parent, ChildList) :-
	findall(Child, parent(Parent, Child), ChildList).

% Retuen a list of siblings
%
sibling_list(Person, Siblings) :-
	setof(S, siblings(Person, S), Siblings).

% Count the number of items in a list
%
listCount([], 0).
listCount([_|Tail], Count) :-
	listCount(Tail, SubCount),
	Count is SubCount + 1.

% calculates how many descendants Person has.
%
countDescendants(Person, Count) :-
	findall(D, descendant(Person, D), DescendantList),
	listCount(DescendantList, Count).

% counts all elements in the list and embedded lists.
%
deepListCount([], 0).
deepListCount([Head|Tail], Count) :-
	deepListCount(Head, HeadSubTotal),
	deepListCount(Tail, TailSubTotal),
	!,
	Count is HeadSubTotal + TailSubTotal.
deepListCount(_, Count) :-
	Count is 1.
