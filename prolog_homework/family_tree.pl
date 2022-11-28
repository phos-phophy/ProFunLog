man(artem).
man(igor).
man(arkadiy).
man(oleg).
man(albert).
man(gindulla).
man(vladimir).
woman(valentina).
woman(almira).
woman(alice).
woman(anna).
woman(anifa).
parent(arkadiy, artem).
parent(almira, artem).
parent(arkadiy, oleg).
parent(almira, oleg).
parent(arkadiy, alice).
parent(almira, alice).
parent(vladimir, arkadiy).
parent(valentina, arkadiy).
parent(gindulla, almira).
parent(anifa, almira).
parent(gindulla, albert).
parent(anifa, albert).
parent(igor, anna).
married(anifa, gindulla).
married(almira, arkadiy).
married(artem, anna).

/* Предикаты для установления фактов */

% X и Y находятся в браке
is_married(X, Y):- married(X, Y); married(Y, X).

% X является ребёнком Y
child(X, Y):- parent(Y, X).

% X является сыном Y
son(X, Y):- man(X), child(X, Y).

% X является дочерью Y
daughter(X, Y):- woman(X), child(X, Y).

% X является отцом Y
father(X, Y):- man(X), parent(X, Y).

% X является матерью Y
mother(X, Y):- woman(X), parent(X, Y).

% X является братом/сестрой Y
sibling(X, Y):- dif(X, Y), child(X, Z), child(Y, Z).

% X является братом Y
brother(X, Y):- man(X), sibling(X, Y).

% X является сестрой Y
sister(X, Y):- woman(X), sibling(X, Y).

% X является дедушкой Y
grandfather(X, Y):- father(X, Z), parent(Z, Y).

% X является бабушкой Y
grandfather(X, Y):- mother(X, Z), parent(Z, Y).

% X является внуком Y
grandson(X, Y):- son(X, Z), parent(Y, Z).

% X является внучкой Y
granddaugher(X, Y):- daughter(X, Z), parent(Y, Z).

% X является дядей Y
uncle(X, Y):- brother(X, Z), parent(Z, Y).

% X является племянником Y
nephew(X, Y):- son(X, Z), sibling(Z, Y). 

% X является тетей Y
aunt(X, Y):- sister(X, Z), parent(Z, Y).

% X является племянницей Y
niece(X, Y):- daughter(X, Z), sibling(Z, Y). 

% X является тестем Y
father_in_low1(X, Y):- man(Y), is_married(Y, Z), father(X, Z).

% X является тёщей Y
mother_in_low1(X, Y):- man(Y), is_married(Y, Z), mother(X, Z).

% X является свёкром Y
father_in_low2(X, Y):- woman(Y), is_married(Y, Z), father(X, Z).

% X является свекровью Y
mother_in_low2(X, Y):- woman(Y), is_married(Y, Z), mother(X, Z).
