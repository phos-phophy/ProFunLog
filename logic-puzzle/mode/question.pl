:- dynamic answer/1.


% clean pictures and generate next question
next_question(PictureQ, PictureA, Comp):-
    send(PictureQ, clear),
    send(PictureA, clear),
    
    % forget the previos correct answer
    retract(answer(_)),

    generate_question(PictureQ, PictureA, Comp).


% generate question and draw it
generate_question(PictureQ, PictureA, Comp):-
    
    get_descs(Desc1, Desc2, Desc3, Desc4, Desc5, Desc6, Desc7, Desc8, Comp),

    size(Size), pictureQHeight(HQ), HeightQ is HQ / 2 - Size / 2,

    draw_figure(PictureQ, Desc1, Desc2, 63, HeightQ),  % draw first figure 
    draw_figure(PictureQ, Desc2, Desc1, 188, HeightQ),  % draw second figure
    draw_figure(PictureQ, Desc3, Desc4, 313, HeightQ),  % draw third figure
    draw_question_sign(PictureQ, 438, HeightQ),

    pictureAHeight(HA), HeightA is HA / 2 - Size / 2,

    locate_answer(X1, X2, X3),

    draw_figure(PictureA, Desc4, Desc3, X1, HeightA),  % draw fourth figure
    draw_figure(PictureA, Desc5, Desc6, X2, HeightA),  % draw fifth figure
    draw_figure(PictureA, Desc7, Desc8, X3, HeightA).  % draw sixth figure


% mix the possible asnwers and remember where the correct one is
locate_answer(X1, X2, X3):-
    random(0, 3, R),
    X1 is -50 + 150 * (R + 1),
    X2 is -50 + 150 * (mod((R + 1), 3) + 1),
    X3 is -50 + 150 * (mod((R + 2), 3) + 1),
    asserta(answer(R + 1)).


% draw figure in the specified location
draw_figure(Picture, DescB, DescS, X, Y):-
    size(Size),

    get_single_figure(BigFigure, DescB, Size),
    get_single_figure(SmallFigure, DescS, Size / 2),

    send(Picture, display, BigFigure, point(X - Size / 2, Y)),
    send(Picture, display, SmallFigure, point(X - Size / 4, Y + Size / 4)).


draw_question_sign(Picture, X, Y):- 
    new(Sign, path),
    send_list(Sign, append, [point(0, 20), point(0, 10), point(10, 0), point(40, 0), point(50, 10), point(50, 35), point(30, 50), point(25, 60), point(25, 80)]),

    new(Circ, circle(10)),

    send(Picture, display, Sign, point(X - 25, Y)),
    send(Picture, display, Circ, point(X - 3, Y + 90)).
