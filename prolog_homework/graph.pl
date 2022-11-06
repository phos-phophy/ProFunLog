/* Предикаты для работы с неявно заданными графами */

/* Пример графа:
   edge(a, c, 8).
   edge(a, b, 3).
   edge(c, d, 12).
   edge(b, d, 0).
   edge(e, d, 9). 
*/

/* path(X, Y, L): L - путь без петель между вершинами X и Y, т.е. список вершин между этими вершинами
  
Допустимые варианты использования:
* (i, i, i): проверяет, являетля ли L путем из вершины X в вершину Y
      true:
          * path(a, e, [b, d])
          * path(a, a, [])
          * path(a, b, [])
      false:
          * path(a, e, [d])
          * path(b, d, [c])
* (i, i, o): строит путь L
      ?- path(e, a, X)
      => X = [d, c]
      ?- path(b, c, X)
      => X = [d]
* (i, o, i): проверяет, возможно ли добраться из вершины X в последнюю вершину списка L
      ?- path(a, X, [c, d, b])
      => X = b
      ?- path(a, X, [c, b, d])
      => false
* (o, i, i): ищет вершину X, из которой по пути L можно добраться до Y (путь в данном случае может оказаться циклическим)
      ?- path(X, e, [d])
      => X = c
      ?- path(X, c, [d])
      => X = c
* (i, o, o):
      ?- path(a, Y, Z)
      => Y = a, Z = []
* (o, i, o):
      ?- path(X, a, Z)
      => X = a, Z = []
* (o, o, i): ищет вершину X, из которой можно добраться до последней вершины из L
      ?- path(X, Y, [b, d])
      => X = a, Y = d
      ?- path(X, Y, [d, b])
      => X = c, Y = b
* (o, o, o):
      ?- path(X, Y, Z) 
      => X = Y, Z = []
*/
path(X, Y, L):- path_(X, Y, L, []).
path_(Y, Y, [], _):-!.
path_(X, Y, [], _):- edge(X, Y, _), !; edge(Y, X, _), !.
path_(X, Y, [NextX|L], F):- edge(X, NextX, _), dif(X, NextX), not_in(NextX, F), path_(NextX, Y, L, [NextX|F]), !.
path_(X, Y, [NextX|L], F):- edge(NextX, X, _), dif(X, NextX), not_in(NextX, F), path_(NextX, Y, L, [NextX|F]).
not_in(_, []).
not_in(E, [H|T]):- dif(E, H), not_in(E, T).


/* cyclic: граф является циклическим, т.е. не является деревом */
cyclic:- get_nodes(L), check_nodes(L).
edge_(X, Y):- edge(X, Y, _); edge(Y, X, _).
get_nodes(L):- setof(A, B^edge_(A, B), L).
check_nodes([H|T]):- check_node(H), !; check_nodes(T).
check_node(N):- bagof(B, C^path1(N, B, C), L), not(no_doubles(L, L)).
path1(X, Y, L):- path1_(X, Y, L, [X]).
path1_(X, Y, [X, Y], F):- not_in(Y, F), edge(X, Y, _); not_in(Y, F), edge(Y, X, _).
path1_(X, Y, [X|L], F):- edge(X, NextX, _), dif(X, NextX), not_in(NextX, F), path1_(NextX, Y, L, [NextX|F]).
path1_(X, Y, [X|L], F):- edge(NextX, X, _), dif(X, NextX), not_in(NextX, F), path1_(NextX, Y, L, [NextX|F]).
not_in(_, []).
not_in(E, [H|T]):- dif(E, H), not_in(E, T).
no_doubles(L1, L2):- no_doubles_(L1, L2, []).
no_doubles_([E|T1], [E|T2], F):- not_in(E, F), !, no_doubles_(T1, T2, [E|F]).
no_doubles_([_|T1], L2, F):- no_doubles_(T1, L2, F).
no_doubles_([], [], _).


/* is_connected: граф является связанным (т.е. для любых двух его вершин существует связывающий их путь) */
is_connected:- get_nodes([H|T]), path_exists(H, T).
edge_(X, Y):- edge(X, Y, _); edge(Y, X, _).
get_nodes(L):- setof(A, B^edge_(A, B), L).
path_exists(_, []):- !.
path_exists(E, [H|T]):- path(E, H, _), path_exists(E, T).
