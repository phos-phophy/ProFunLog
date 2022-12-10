size(100).


figure(0, Box, Size):- new(Box, box(Size, Size)).
figure(1, Circle, Size):- new(Circle, circle(Size)).
figure(2, Triangle, Size):- new(Triangle, path), send_list(Triangle, append, [point(0, 0), point(Size / 2, -Size), point(Size, 0), point(0, 0)]).
figure(3, Triangle, Size):- new(Triangle, path), send_list(Triangle, append, [point(0, Size / 2), point(0, -Size / 2), point(Size, -Size / 2), point(0, Size / 2)]).
figure(4, Triangle, Size):- new(Triangle, path), send_list(Triangle, append, [point(0, -Size / 2), point(Size, -Size / 2), point(Size, Size / 2), point(0, -Size / 2)]).


:- dynamic answer/1.


% clean pictures and generate next question
next_question(PictureQ, PictureA, Comp):-
    send(PictureQ, clear),
    send(PictureA, clear),
    
    % forget the previos correct answer
    retract(answer(_)),

    generate_question(PictureQ, PictureA, Comp).


generate_question(PictureQ, PictureA, Comp):-

    From is 0,
    (Comp is 0 -> To is 3; To is 5),

    get_types(From, To, Type1, Type2, Type3, Type4, Type5, Type6, Type7, Type8),

    size(Size), pictureQHeight(HQ), HeightQ is HQ / 2 - Size / 2,

    add_simple_figure(PictureQ, Type1, Type2, 100, HeightQ),
    add_simple_figure(PictureQ, Type2, Type1, 250, HeightQ),
    add_simple_figure(PictureQ, Type3, Type4, 400, HeightQ),

    pictureAHeight(HA), HeightA is HA / 2 - Size / 2,

    locate_answer(X1, X2, X3),

    add_simple_figure(PictureA, Type4, Type3, X1, HeightA),
    add_simple_figure(PictureA, Type5, Type6, X2, HeightA),
    add_simple_figure(PictureA, Type7, Type8, X3, HeightA).
    

add_simple_figure(Picture, TypeBig, TypeSmall, X, Y):-
    size(Size),

    figure(TypeBig, BigFigure, Size),
    figure(TypeSmall, SmallFigure, Size / 2),
    
    send(Picture, display, BigFigure, point(X - Size / 2, Y)),
    send(Picture, display, SmallFigure, point(X - Size / 4, Y + Size / 4)).


% mix the possible asnwers and remember where the correct one is
locate_answer(X1, X2, X3):-
    random(0, 3, R),
    X1 is -50 + 150 * (R + 1),
    X2 is -50 + 150 * (mod((R + 1), 3) + 1),
    X3 is -50 + 150 * (mod((R + 2), 3) + 1),
    asserta(answer(R + 1)).

