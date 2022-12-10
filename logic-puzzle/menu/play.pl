complexity(0, 'Logic puzzle: Low complexity').
complexity(1, 'Logic puzzle: Medium complexity').
complexity(2, 'Logic puzzle: High complexity').


pictureQWidth(500).
pictureQHeight(250).
pictureAWidth(500).
pictureAHeight(150).


showAnswerText('Show answer').


% draw play menu interface: question submenu, answer submenu, control buttons
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


% draw submenu for questions
add_question_sub_menu(Dialog, Picture):-
    new(Question, dialog_group('Question')),
    send(Dialog, append, Question),

    pictureQWidth(W),
    pictureQHeight(H),

    new(Picture, picture),
    send(Picture, width(W)),
    send(Picture, height(H)),
    send(Question, append, Picture).


% draw submenu for answers
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


% draw buttons: 'Ok' and 'Main menu'
add_buttons(Dialog, PictureQ, PictureA, Select, Comp):-
    new(Buttons, dialog_group('')),
    send(Buttons, gap, size(150, 8)),
    send(Dialog, append, Buttons),

    new(Button, button('Ok', message(@prolog, ok_button, PictureQ, PictureA, Comp, Select))),
    send(Buttons, append, Button),

    new(MainMenu, button('Main menu', and(message(Dialog, destroy), message(@prolog, start)))),
    send(Buttons, append, MainMenu).


% 0 - display answers, 1 - generate next question
:- dynamic mode/1.
mode(0).


% select the suitable mode of work for 'Ok' button: highlight answers or generate next question
ok_button(PictureQ, PictureA, Comp, Select):-
    
    mode(0), 
    asserta(mode(1)),
    retract(mode(0)),
    display_answers(PictureA, Select);
    
    asserta(mode(0)),
    retract(mode(1)),
    next_question(PictureQ, PictureA, Comp).

