complexity(0, 'Logic puzzle: Low complexity').
complexity(1, 'Logic puzzle: Medium complexity').
complexity(2, 'Logic puzzle: High complexity').


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
    send(Picture, height(350)),
    send(Question, append, Picture).


add_answer_sub_menu(Dialog, Picture, Select):- 
    new(Answer, dialog_group('Possible answers')),
    send(Dialog, append, Answer),

    new(Picture, picture),
    send(Picture, width(500)),
    send(Picture, height(50)),
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

    new(Exit, button('Exit', and(message(Dialog, destroy), message(@prolog, start)))),
    send(Buttons, append, Exit).


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


generate_question(PictureQ, _, _):-
    random(10, 100, R),
    random(100, 200, X),
    random(100, 200, Y),
    send(PictureQ, display, new(_, circle(R)), point(X, Y)).
