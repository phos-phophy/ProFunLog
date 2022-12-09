complexity(0, 'Logic puzzle: Low complexity').
complexity(1, 'Logic puzzle: Medium complexity').
complexity(2, 'Logic puzzle: High complexity').


figure(0, Box, Size):- new(Box, box(Size, Size)).
figure(1, Circle, Size):- new(Circle, circle(Size)).
figure(2, Triangle, Size):- new(Triangle, path), send_list(Triangle, append, [point(0, 0), point(Size / 2, -Size), point(Size, 0), point(0, 0)]).


% 0 - give answer, 1 - see next question
:- dynamic mode/1.
mode(0).


play_menu(Comp):-
    complexity(Comp, Title),
    new(Frame, frame(Title)),

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

    new(Picture, picture),
    send(Picture, width(500)),
    send(Picture, height(250)),
    send(Question, append, Picture).


add_answer_sub_menu(Dialog, Picture, Select):- 
    new(Answer, dialog_group('Possible answers')),
    send(Dialog, append, Answer),

    new(Picture, picture),
    send(Picture, width(500)),
    send(Picture, height(150)),
    send(Answer, append, Picture),

    new(Select, menu('Your answer')),
    send_list(Select, append, ['1', '2', '3', '4']),
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

    generate_question(PictureQ, PictureA, Comp).


% Select?selection
% get(Select, selection, UserAnswer)
ok_button(PictureQ, PictureA, 0, Comp, Select):-
    % select right answer
    % select wrong answer

    asserta(mode(1)),
    retract(mode(0)).


generate_question(PictureQ, PictureA, _):-
    get_types(0, 3, Type1, Type2, Type3, Type4, Type5, Type6, Type7, Type8),

    Size is 100,
    get(PictureQ, size, SzQ), get(SzQ, height, HQ),
    HeightQ is HQ / 2 - Size / 2,

    add_simple_figure(PictureQ, Type1, Type2, 100, HeightQ, Size),
    add_simple_figure(PictureQ, Type2, Type1, 250, HeightQ, Size),
    add_simple_figure(PictureQ, Type3, Type4, 400, HeightQ, Size),

    get(PictureA, size, SzA), get(SzA, height, HA),
    HeightA is HA / 2 - Size / 2,

    add_simple_figure(PictureA, Type4, Type3, 100, HeightA, Size),
    add_simple_figure(PictureA, Type5, Type6, 250, HeightA, Size),
    add_simple_figure(PictureA, Type7, Type8, 400, HeightA, Size).


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
    

add_simple_figure(Picture, TypeBig, TypeSmall, X, Y, Size):-
    figure(TypeBig, BigFigure, Size),
    figure(TypeSmall, SmallFigure, Size / 2),
    
    send(Picture, display, BigFigure, point(X - Size / 2, Y)),
    send(Picture, display, SmallFigure, point(X - Size / 4, Y + Size / 4)).

