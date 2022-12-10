get_types(From, To, Type1, Type2, Type3, Type4, Type5, Type6, Type7, Type8):-
    random(From, To, Type1), random(From, To, Type2), random(From, To, Type3), random(From, To, Type4),
    random(From, To, Type5), random(From, To, Type6), random(From, To, Type7), random(From, To, Type8),

    % guarantee that other answers will not match the correct one
    diff_pair(Type5, Type6, Type4, Type3),
    diff_pair(Type7, Type8, Type4, Type3),
    check_types(Type1, Type2, Type3, Type4, Type5, Type6, Type7, Type8);

    get_types(From, To, Type1, Type2, Type3, Type4, Type5, Type6, Type7, Type8).


diff_pair(Type1, Type2, NotType1, NotType2):-
    not(Type1 is NotType1);
    not(Type2 is NotType2).


check_types(Type1, Type2, Type3, Type4, Type5, Type6, Type7, Type8):-
    not(Type1 is Type2);
    diff_pair(Type5, Type6, Type3, Type4),
    diff_pair(Type7, Type8, Type3, Type4).

