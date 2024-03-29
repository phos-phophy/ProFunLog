/* Предикаты для работы со списками */

/* append(L1, L2, L3): список L3 является слиянием (конкатенацией) списков L1 и L2 

Допустимые варианты использования:
* (i, i, i): проверяет, является ли список L3 слиянием списков L1 и L2
* (i, i, o): возвращает список L3 = [L1|L2]
* (i, o, i): возвращает такой список L2, чтобы конкатенация L1 и L2 являлась списком L3
* (o, i, i): возвращает такой список L1, чтобы конкатенация L1 и L2 являлась списком L3 
* (i, o, o): возвращает единственный список L3 = [L1|L2], при этом L2 не определен
* (o, i, o): возвращает L1 и L2, такие что L3 = [L1|L2]
* (o, o, i): возвращает всевозможные варианты списков L1 и L2, чья конкатенация является списком L3
* (o, o, o): случайно генерирует списки L1, L2 и L3, такие что L3 = [L1|L2]
*/
append([], L1, L1).
append([X1|R1], L2, [X1|R3]):- append(R1, L2, R3).


/* reverse(L1, L2): L2 - перевернутый список L1 

Допустимые варианты использования:
* (i, i): проверяет, является ли список L2 перевернутым списком L1
* (i, o): возвращает список L2, являющийся перевернутым списком L1
* (o, i): возвращает список L1, являющийся перевернутым списком L2
* (o, o): возвращает 2 одинаковых списка из единственного элемента
*/
reverse(L1, L2):- rev(L1, [], L2).
rev([], L2, L2).
rev([X1|R1], Acc, L2):- rev(R1, [X1|Acc], L2),!.


/* delete_first(E, L1, L2): список L2 получен из L1 исключением первого вхождения объекта E 

Допустимые варианты использования:
* (i, i, i): проверяет, получен ли список L2 из списка L1 путем удаления первого вхождения элемента E
* (i, i, o): возвращает список L2, полученный из L1 путем удаления из него первого вхождения элемента L1
* (i, o, i): возвращает список L1, такой что L1 = [E|L2]
* (o, i, i): ищет объект такой объект E, чтобы список L2 получался из списка L1 путем удаления из него первого вхождениями объекта E
* (i, o, o): связывает E, L1, L2 следующим образом - L1=[E|L2] 
* (o, i, o): удаляет из списка L1 первый элемент
* (o, o, i): связывает E, L1, L2 следующим образом - L1=[E|L2] 
* (o, o, o): связывает E, L1, L2 следующим образом - L1=[E|L2]
*/
delete_first(E, [E|T], T):- !.
delete_first(E, [X1|T1], [X1|T2]):- delete_first(E, T1, T2).


/* delete_all(E, L1, L2): L2 - это список L1, из которого удалены все вхождения E 

Допустимые варианты использования:
* (i, i, i): проверяет, получен ли список L2 из списка L1 путем удаления всех вхождений элемента E
* (i, i, o): возвращает список L2, полученный из L1 путем удаления из него всех вхождений элемента L1
* (o, i, i): ищет объект такой объект E, чтобы список L2 получался из списка L1 путем удаления из него всех вхождений объекта E
* (i, o, o): возвращает L1 = L2 = [] 
* (o, i, o): удаляет из списка L1 все вхождения первого элемента
* (o, o, o): возвращает L1 = L2 = [], X пусто

Недопустимые варианты использования:
* (i, o, i): зацикливание и исчерпание стека
* (o, o, i): зацикливание и исчерпание стека
*/
delete_all(_, [], []):- !.
delete_all(E, [E|T1], T2):- !, delete_all(E, T1, T2).
delete_all(E, [X1|T1], [X1|T2]):- delete_all(E, T1, T2).


/* delete_one(E, L1, L2): L2 - это список L1, из которого удалено одно любое вхождение элемента E 

Допустимые варианты использования:
* (i, i, i): проверяет, получен ли список L2 из списка L1 путем удаления одного любого вхождения элемента E
* (i, i, o): возвращает всевозможные списки L2, полученные из L1 путем удаления из него любого вхождения элемента L1
* (i, o, i): возвращает всевозможные списки L1, полученные из L2 путем добавления E в любое место
* (o, i, i): ищет объект такой объект E, чтобы список L2 получался из списка L1 путем удаления из него одного любого вхождения объекта E
* (i, o, o): возвращает такие списки L1 и L2, что L1 = [X,1|Y], L2 = [X|Y]
* (o, i, o): возвращает всевозможные списки L2, полученные из L1 путем удаления любого из его элементов
* (o, o, i): возвращает всевозможные списки L1, полученные из L2 путем добавления E (E не определен) в любое место
* (o, o, o): возвращает такие списки L1 и L2, что L1 = [X,E|Y], L2 = [X|Y]
*/
delete_one(E, [E|T1], T1).
delete_one(E, [X1|T1], [X1|T2]):- delete_one(E, T1, T2).


/* no_doubles(L1, L2): L2 - это список, являющийся результатом удаления из L1 всех повторяющихся элементов

Допустимые варианты использования:
* (i, i): проверяет, является ли список L2 результатом удаления из L1 всех повторяющихся элементов
* (i, o): возвращает L2

Недопустимые варианты использования:
* (o, i): зацикливание и исчерпание стека
* (o, o): зацикливание ({"code":500, "message":"Arguments are not sufficiently instantiated"})
*/
no_doubles(L1, L2):- no_doubles_(L1, L2, []).
no_doubles_([E|T1], [E|T2], F):- not_in(E, F), !, no_doubles_(T1, T2, [E|F]).
no_doubles_([_|T1], L2, F):- no_doubles_(T1, L2, F).
no_doubles_([], [], _).
not_in(_, []).
not_in(E, [X1|T1]):- dif(E, X1), not_in(E, T1).


/* sublist(L1, L2): L2 - любой подсписок списка L1, т.е. непустой отрезок из подряд идущих элементов L2

Допустимые варианты использования:
* (i, i): проверяет, является ли L2 подсписком списка L1
* (i, o): возвращает всевозможные подсписки L2 списка L1

Недопустимые варианты использования:
* (o, i): зацикливание и исчерпание стека
* (o, o): зацикливание и исчерпание стека
*/
sublist(L1, L2):- sublist_(L1, L2, 0);sublist_(L1, L2, 1).
sublist_([_|T1], T2, 0):- sublist_(T1, T2, 0);sublist_(T1, T2, 1).
sublist_([X1|T1], [X1|T2], 1):- sublist_(T1, T2, 1);sublist_(T1, T2, 2).
sublist_(_, [], 2).


/* number(E, N, L): N - порядковый номер элемента E в списке L

Допустимые варианты использования:
* (i, i, i): проверяет, является ли N порядковым номером элемента E в списке L
* (i, i, 0): возвращает список случайно сгенерированный список из 3 элементов, в котором элемент E находится на N месте
* (i, o, i): ищет порядковый номер первого вхождения элемента E в списке L
* (o, i, i): ищет элемент E на N месте в списке L
* (i, o, o): N = 0, L = [E|случайное число]
* (o, o, i): возвращает 1-ый элемент списка (N = 0)
* (o, o, o): N = 0, L = [E|случайное число], E - неопределенно

Недопустимые варианты использования:
* (o, i, o): когда N равен 0 или 1 возвращает список L, в котором элемент E (неопределен) находится на соответсвующем месте, в остальных случаях возвращается false
*/
number(E, 0, [E|_]):- !.
number(E, N, [_|T]):- number(E, N1, T), N is N1 + 1.


/* sort(L1, L2): L2 - отсортированный по неубыванию список чисел из L1

Допустимые варианты использования:
* (i, i): проверяет, является ли L2 отсортированный по неубыванию списком чисел из L1
* (i, o): возвращает отсортированный по неубыванию список L2
* (o, o): возвращает пустые списки

Недопустимые варианты использования:
* (o, i): возвращает false
*/
quick_sort([], []):- !.
quick_sort([H|T], L):- 
    left(H, T, NL1), right(H, T, NL2), 
    quick_sort(NL1, L1), quick_sort(NL2, L2), 
    append(L1, [H|L2], L).
left(_, [], []):- !.
left(E, [H|T], [H|Acc]):- E > H, !, left(E, T, Acc).
left(E, [_|T], Acc):- left(E, T, Acc).
right(_, [], []):- !.
right(E, [H|T], [H|Acc]):- E =< H, !, right(E, T, Acc).
right(E, [_|T], Acc):- right(E, T, Acc).
