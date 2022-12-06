complexity(0, 'Logic puzzle: Low complexity').
complexity(1, 'Logic puzzle: Medium complexity').
complexity(2, 'Logic puzzle: High complexity').


play_menu(Comp):-
    complexity(Comp, Title),
    new(Frame, frame(Title)),

    new(Dialog, dialog),
    add_question_sub_menu(Dialog),
    add_answer_sub_menu(Dialog),
    add_buttons(Dialog),

    send(Frame, append, Dialog),
    send(Frame, open).


add_question_sub_menu(Dialog):- 
    new(Question, dialog_group('Question')),
    send(Dialog, append, Question),

    new(Picture, picture),
    send(Picture, width(500)),
    send(Picture, height(350)),
    send(Question, append, Picture).


add_answer_sub_menu(Dialog):- 
    new(Answer, dialog_group('Possible answers')),
    send(Dialog, append, Answer),

    new(Pict_a, picture),
    send(Pict_a, width(500)),
    send(Pict_a, height(50)),
    send(Answer, append, Pict_a),

    new(Select, menu('Your answer')),
    send_list(Select, append, ['1', '2', '3', '4']),
    send(Answer, append, Select).


add_buttons(Dialog):- 
    new(Buttons, dialog_group('')),
    send(Buttons, gap, size(150, 8)),
    send(Dialog, append, Buttons),
    
    new(Button, button('Ok', message(Dialog, destroy))),
    send(Buttons, append, Button),

    new(Exit, button('Exit', and(message(Dialog, destroy), message(@prolog, start)))),
    send(Buttons, append, Exit).
