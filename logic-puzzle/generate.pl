pictureQWidth(500).
pictureQHeight(250).
pictureAWidth(500).
pictureAHeight(150).


size(100).


showAnswerText('Show answer').


figure(0, Box, Size):- new(Box, box(Size, Size)).
figure(1, Circle, Size):- new(Circle, circle(Size)).
figure(2, Triangle, Size):- new(Triangle, path), send_list(Triangle, append, [point(0, 0), point(Size / 2, -Size), point(Size, 0), point(0, 0)]).
figure(3, Triangle, Size):- new(Triangle, path), send_list(Triangle, append, [point(0, Size / 2), point(0, -Size / 2), point(Size, -Size / 2), point(0, Size / 2)]).
figure(4, Triangle, Size):- new(Triangle, path), send_list(Triangle, append, [point(0, -Size / 2), point(Size, -Size / 2), point(Size, Size / 2), point(0, -Size / 2)]).


% 0 - give answer, 1 - see next question
:- dynamic mode/1.
mode(0).


:- dynamic answer/1.


play_menu(Comp):-
    new(Frame, frame('Logic puzzle')),

    new(Dialog, dialog),
    add_question_sub_menu(Dialog, PictureQ),
    add_answer_sub_menu(Dialog, PictureA, Select),
    add_buttons(Dialog, PictureQ, PictureA, Select, Comp),

    generate_question(PictureQ, PictureA, Comp),

    send(Frame, append, Dialog),
    send(Frame, open).


add_question_sub_menu(Dialog, Picture):- 
    new(Question, dialog_group('Question')),
    send(Dialog, append, Question),

    pictureQWidth(W),
    pictureQHeight(H),

    new(Picture, picture),
    send(Picture, width(W)),
    send(Picture, height(H)),
    send(Question, append, Picture).


add_answer_sub_menu(Dialog, Picture, Select):- 
    new(Answer, dialog_group('Possible answers')),
    send(Dialog, append, Answer),

    pictureAWidth(W),
    pictureAHeight(H),

    new(Picture, picture),
    send(Picture, width(W)),
    send(Picture, height(H)),
    send(Answer, append, Picture),

    showAnswerText(Text),

    new(Select, menu('Your answer')),
    send_list(Select, append, [1, 2, 3, Text]),
    send(Answer, append, Select).


add_buttons(Dialog, PictureQ, PictureA, Select, Comp):- 
    new(Buttons, dialog_group('')),
    send(Buttons, gap, size(150, 8)),
    send(Dialog, append, Buttons),
    
    new(Button, button('Ok', message(@prolog, ok_button_, PictureQ, PictureA, Comp, Select))),
    send(Buttons, append, Button),

    new(MainMenu, button('Main menu', and(message(Dialog, destroy), message(@prolog, start)))),
    send(Buttons, append, MainMenu).


ok_button_(PictureQ, PictureA, Comp, Select):-
    send(@prolog, mode, 0), send(@prolog, ok_button, PictureQ, PictureA, 0, Comp, Select);
    send(@prolog, ok_button, PictureQ, PictureA, 1, Comp, Select).


ok_button(PictureQ, PictureA, 1, Comp, _):-
    send(PictureQ, clear),
    send(PictureA, clear),
    
    asserta(mode(0)),
    retract(mode(1)),
    retract(answer(_)),

    generate_question(PictureQ, PictureA, Comp).


ok_button(_, PictureA, 0, _, Select):-
    get(Select, selection, UserAnswer),
    
    answer(RightAnswer),
    draw_line(RightAnswer, RightAnswer, PictureA),  % highlight correct answer
    draw_line(UserAnswer, RightAnswer, PictureA),  % highlight wrong answer if there is

    asserta(mode(1)),
    retract(mode(0)).


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
    

add_simple_figure(Picture, TypeBig, TypeSmall, X, Y):-
    size(Size),

    figure(TypeBig, BigFigure, Size),
    figure(TypeSmall, SmallFigure, Size / 2),
    
    send(Picture, display, BigFigure, point(X - Size / 2, Y)),
    send(Picture, display, SmallFigure, point(X - Size / 4, Y + Size / 4)).


locate_answer(X1, X2, X3):-
    random(0, 3, R),
    X1 is -50 + 150 * (R + 1),
    X2 is -50 + 150 * (mod((R + 1), 3) + 1),
    X3 is -50 + 150 * (mod((R + 2), 3) + 1),
    asserta(answer(R + 1)).


draw_line(Answer1, Answer2, Picture):-
    showAnswerText(Answer1);

    size(Size),
    Aside is Size / 2,
    Center is -50 + 150 * Answer1,
    pictureAHeight(H), Height is H / 2 + Size *3 / 4,

    new(Line, path),
    send_list(Line, append, [point(Center - Aside, Height), point(Center + Aside, Height)]),
    (Answer1 =:= Answer2 -> send(Line, colour, colour(green)) ; send(Line, colour, colour(red))),

    send(Picture, display, Line).
