/* Предикаты для работы с деревьями */

/* tree_depth(T, N): N - глубина дерева (т.е. количество ребер в самой длинной ветвки дерева)

Допустимые варианты использования:
* (i, i): проверяет, является ли N глубинной дерева
      true:
          * tree_depth(nil, -1)
          * tree_depth(tree(nil, nil, a), 0)
          * tree_depth(tree(tree(nil, nil, b), nil, a), 1)
      false:
          * tree_depth(tree(tree(nil, nil, b), tree(nil, nil, c), a), 2)
* (i, o): ищет глубину дерева
* (o, o): возвращает дерево tree(nil, nil, <любое число>) глубины 0

Недопустимые варианты использования:
* (o, i): возвращает false при N > 1
*/
tree_depth(tree(nil, nil, _), 0):- !.
tree_depth(nil, -1):- !.
tree_depth(tree(T1, T2, _), N):- tree_depth(T1, N1), tree_depth(T2, N2), N is max(N1, N2) + 1.


/* sub_tree(T1, T2): дерево T1 является непустым поддеревом дерева T2

Допустимые вварианты использования:
* (i, i): проверет, является ли T1 поддеревом дерева T2
      true:
          * sub_tree(tree(nil, nil, d), tree(tree(tree(nil, nil, d), nil, b), tree(nil, nil, c), a))
          * sub_tree(tree(tree(nil, nil, d), nil, b), tree(tree(tree(nil, nil, d), nil, b), tree(nil, nil, c), a))
      false:
          * sub_tree(tree(nil, nil, a), tree(tree(tree(nil, nil, d), nil, b), tree(nil, nil, c), a))
* (o, i): выводит все поддеревья
      ?- sub_tree(X, tree(tree(tree(nil, nil, d), nil, b), tree(nil, nil, c), a))
      => tree(tree(tree(nil, nil, d), nil, b), tree(nil, nil, c), a)
      => tree(tree(nil, nil, d), nil, b)
      => tree(nil, nil, d)
      => tree(nil, nil, c)
      => false
* (o, o): генерируются случайные правые деревья (без левых ветвей)

Недопустимые варианты использования:
* (i, o): выводит все деревья T2, содержащие T1, но вместо правых ветвей в этом поддереве генерируются числа
*/
sub_tree(T1, tree(T21, T22, S2)):- check(T1, tree(T21, T22, S2)); sub_tree(T1, T21); sub_tree(T1, T22).
check(nil, nil).
check(tree(T11, T12, S), tree(T21, T22, S)):- check(T11, T21), check(T12, T22).


/* flatten_tree(T, L): L - список меток всех узлов дерева ("выровненное" дерево)

Допустимые варианты использования:
* (i, i): проверяет, является ли L списком меток всех узлов дерева
* (i, o): возвращает список меток
* (o, o): T = nil, L = []

Недопустимые варианты использования:
* (o, i): зацикливание и исчерпание стека
*/
flatten_tree(T, L):- flat(T, L, []).
flat(nil, Res, Res):-!.
flat(tree(T1, T2, S), Res, Acc):- !, flat(T1, Res1, Acc), flat(T2, Res2, Res1), flat(S, Res, Res2).
flat(X, [X|Res], Res).


/* substitute(T1, V, T, T2): T2 - дерево, полученное путем замены всех вхождений V в дереве T1 на терм T

Допустимые варианты использования:
* (i, i, i, i): проверяет, получено ли дерево T2 из T1 путем замены всех вхождений V на T
      true:
          * substitute(tree(nil, nil, a), a, b, tree(nil, nil, b))
          * substitute(tree(nil, tree(nil, nil, c), a), c, d, tree(nil, tree(nil, nil, d), a))
      false:
          * substitute(tree(nil, tree(nil, nil, b), b), b, a, tree(nil, tree(nil, nil, a), b))
* (i, i, i, o): строит дерево T2
      ?- substitute(tree(tree(nil, nil, 35), tree(tree(tree(nil, nil, 35), nil, 0), tree(nil, nil, 35), b), a), 35, 70, X)
      => tree(tree(nil, nil, 70), tree(tree(tree(nil, nil, 70), nil, 0), tree(nil, nil, 70), b), a)
* (i, i, o, i): ищет T
      ?- substitute(tree(nil, tree(nil, nil, b), b), b, X, tree(nil, tree(nil, nil, a), a))
      => X = a
* (i, o, i, i): ищет V
      ?- substitute(tree(nil, tree(nil, nil, b), b), X, a, tree(nil, tree(nil, nil, a), a))
      => X = b
      ?- substitute(tree(nil, tree(nil, nil, b), b), X, a, tree(nil, tree(nil, nil, a), c))
      => false
* (o, i, i, i): строит T1 (обратная замена)
      ?- substitute(X, b, a, tree(nil, tree(nil, nil, a), c))
      => tree(nil, tree(nil, nil, b), c)
*/
substitute(nil, _, _, nil):- !.
substitute(tree(T1, T2, V), V, T, tree(TT1, TT2, T)):- !, substitute(T1, V, T, TT1), substitute(T2, V, T, TT2).
substitute(tree(T1, T2, K), V, T, tree(TT1, TT2, K)):- dif(K, V), substitute(T1, V, T, TT1), substitute(T2, V, T, TT2).
