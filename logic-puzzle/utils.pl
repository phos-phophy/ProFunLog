by_index(E, [E|_], 0).
by_index(A, [_|T], N1):- N2 is N1 - 1, by_index(A, T, N2).


same(T, T).
