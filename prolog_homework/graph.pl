/* Предикаты для работы с неявно заданными графами */

/* Пример графа:
   edge(a, c, 8).
   edge(a, b, 3).
   edge(c, d, 12).
   edge(b, d, 0).
   edge(e, d, 9). 
*/

/* Вспомогательные функции */
edge_(X, Y, Z):- edge(X, Y, Z); edge(Y, X, Z).
get_nodes(L):- setof(A, C^B^edge_(A, B, C), L).  % находит все вершины графа
% Находит все пути от X до Y с их полной стоимостью и количеством перемещений
full_path(X, Y, [X, Y], F, Cost, NumMove, PartCost, PartNumMove):- not_in(Y, F), edge_(X, Y, Z), Cost is PartCost + Z, NumMove is PartNumMove + 1.
full_path(X, Y, [X|L], F, Cost, NumMove, PartCost, PartNumMove):- edge_(X, NextX, Z), dif(X, NextX), not_in(NextX, F), 
    NextPartCost is PartCost + Z, NextNumMove is PartNumMove + 1, full_path(NextX, Y, L, [NextX|F], Cost, NumMove, NextPartCost, NextNumMove).
% проверяет, что элемент не находится в списке
not_in(_, []).
not_in(E, [H|T]):- dif(E, H), not_in(E, T).
% ищет минимальное значение
min_value([_/Value], Value):- !.
min_value([_/Value|T], MinValue):- min_value(T, MinV), MinValue is min(Value, MinV).


/* path(X, Y, L): L - путь без петель между вершинами X и Y, т.е. список вершин между этими вершинами
  
Допустимые варианты использования:
* (i, i, i): проверяет, является ли L путем из вершины X в вершину Y
      true:
          * path(a, e, [a, c, d, e])
          * path(a, b, [a, b])
      false:
          * path()
          * path(a, e, [a, d, e])
* (i, i, o): строит все пути L из вершины X в вершину Y
      ?- path(e, a, X)
      => X = [e, d, c, a]
      => X = [e, d, b, a]
      => false
      ?- path(b, c, X)
      => X = [b, d, c]
      => X = [b, a, c]
      => false
* (i, o, i): проверяет, возможно ли добраться из вершины X в последнюю вершину списка L
      ?- path(a, X, [a, c, d, b])
      => X = b
      => false
      ?- path(a, X, [a, c, b, d])
      => false
* (o, i, i): проверяет, возможно ли добраться из первой вершины пути L до последней
      ?- path(X, c, [d, b, a, c])
      => X = d
      => false
      ?- path(X, c, [b, c])
      => false
* (i, o, o): находит все вершины, до которых можно добраться из X
      ?- path(a, Y, Z)
      => Y = с, Z = [a, c]
      => Y = b, Z = [a, b]
      => Y = d, Z = [a, c, d]
      => Y = b, Z = [a, c, d, b]
      => Y = e, Z = [a, c, d, e]
      => Y = d, Z = [a, b, d]
      => Y = b, Z = [a, b, d, b]
      => Y = e, Z = [a, b, d, e]
      => false
* (o, i, o): находит все вершины, из которых можно добраться до Y
      ?- path(X, a, Z)
      => X = c, Z = [c, a]
      => X = b, Z = [b, a]
      => X = c, Z = [c, d, b, a]
      => X = b, Z = [b, d, c, a]
      => X = e, Z = [e, d, c, a]
      => X = e, Z = [e, d, b, a]
      => X = d, Z = [d, c, a]
      => X = d, Z = [d, b, a]
      => false
* (o, o, i): проверяет, возможно ли из первой вершины списка L по заданному пути попасть в последнюю вершину
      ?- path(X, Y, [a, b, d])
      => X = a, Y = d
      => false
      ?- path(X, Y, [d, b])
      => X = d, Y = b
      => false
* (o, o, o): находит абсолютно все маршруты в графе
*/
path(X, Y, L):- full_path(X, Y, L, [X], _, _, 0, 0).


/* min_path(X, Y, L): L - путь между вершинами X и Y, имеющий минимальную стоимость (стоимость пути равна сумме стоимостей входящих в него ребер)

Допустимые варианты использования:
* (i, i, i): проверяет, является ли L минимальным путем от X до Y
      true:
        * min_path(c, d, [c, a, b, d])
      false:
        * min_path(c, d, [c, d])
* (i, i, o): ищет минимальные по стоимости путь от X до Y
      ?- min_path(c, d, X)
      => X = [c, a, b, d]
* (i, o, o): ищет вершины Y, путь до которых от X будет самым минимальным
      ?- min_path(d, Y, Z)
      => Z = [d, b]
      => false
      ?- min_path(a, Y, Z)
      => Z = [a, b]
      => Z = [a, b, d]
      => false
* (o, i, o): ищет вершины X, путь от которых до Y будет самым минимальным
      ?- min_path(X, c, Z)
      => Z = [a, c]
      => false
      ?- min_path(X, d, Z)
      => Z = [b, d]
      => false
* (o, o, o): ищет самые минимальные по стоимости пути в графе
      ?- min_path(X, Y, Z)
      => Z = [b, d]
      => Z = [d, b]
      => false

Недопустимые варианты использования:
* (i, o, i)
* (o, i, i)
* (o, o, i)
*/
min_path(X, Y, L):- findall(Way/Cost, full_path(X, Y, Way, [X], Cost, _, 0, 0), AllWays), min_value(AllWays, MinCost), member(L/MinCost, AllWays).


/* short_path(X, Y, L): L - самый короткий путь между вершинами X и Y (длина пути равна количеству ребер, входящих в него)

Допустимые варианты использования:
* (i, i, i): проверяет, является ли L кратчайшим путем от X до Y
      true:
        * short_path(c, d, [c, d])
      false:
        * short_path(c, d, [c, a, b, d])
* (i, i, o): ищет кратчайшие пути от X до Y
      ?- short_path(c, d, X)
      => X = [c, a, b, d]
* (i, o, o): ищет вершины Y, путь до которых от X будет самым коротким
      ?- short_path(d, Y, Z)
      => Z = [d, c]
      => Z = [d, b]
      => Z = [d, r]
      => false
      ?- short_path(a, Y, Z)
      => Z = [a, c]
      => Z = [a, b]]
      => false
* (o, i, o): ищет вершины X, путь от которых до Y будет самым коротким
      ?- short_path(X, c, Z)
      => Z = [a, c]
      => Z = [d, c]
      => false
      ?- short_path(X, d, Z)
      => Z = [c, d]
      => Z = [b, d]
      => Z = [e, d]
      => false
* (o, o, o): ищет самые минимальные по стоимости пути в графе
      ?- min_path(X, Y, Z)
      => Z = [a, c]
      => Z = [a, b]
      => Z = [c, d]
      => Z = [b, d]
      => Z = [e, d]
      => Z = [c, a]
      => Z = [b, a]
      => Z = [d, c]
      => Z = [d, b]
      => Z = [d, e]

Недопустимые варианты использования:
* (i, o, i)
* (o, i, i)
* (o, o, i)
*/
short_path(X, Y, L):- findall(Way/NumM, full_path(X, Y, Way, [X], _, NumM, 0, 0), AllWays), min_value(AllWays, MinNumM), member(L/MinNumM, AllWays).


/* cyclic: граф является циклическим, т.е. не является деревом */
cyclic:- get_nodes(L), check_nodes(L).
check_nodes([H|T]):- check_node(H), !; check_nodes(T).
check_node(N):- bagof(B, C^path(N, B, C), L), not(no_doubles(L, L)).
no_doubles(L1, L2):- no_doubles_(L1, L2, []).
no_doubles_([E|T1], [E|T2], F):- not_in(E, F), !, no_doubles_(T1, T2, [E|F]).
no_doubles_([_|T1], L2, F):- no_doubles_(T1, L2, F).
no_doubles_([], [], _).


/* is_connected: граф является связанным (т.е. для любых двух его вершин существует связывающий их путь) */
is_connected:- get_nodes([H|T]), path_exists(H, T).
path_exists(_, []):- !.
path_exists(E, [H|T]):- path(E, H, _), path_exists(E, T).
