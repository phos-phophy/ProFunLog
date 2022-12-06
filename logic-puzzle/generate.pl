complexity(0, 'Logic puzzle: Low complexity').
complexity(1, 'Logic puzzle: Medium complexity').
complexity(2, 'Logic puzzle: High complexity').

generate_level(Comp):-
    complexity(Comp, Title),
    new(Frame, frame(Title)),

    new(Dialog, dialog),
    new(Question, dialog_group('Question')),
    new(Answer, dialog_group('Possible answers')),
    
    new(Pict_q, picture),
    send(Pict_q, width(500)),
    send(Pict_q, height(350)),
    send(Question, append, Pict_q),

    new(Pict_a, picture),
    send(Pict_a, width(500)),
    send(Pict_a, height(50)),
    send(Answer, append, Pict_a),

    new(Answer_select, menu('Your answer')),
    send_list(Answer_select, append, ['1', '2', '3', '4']),
    send(Answer, append, Answer_select),

    send(Dialog, append, Question),
    send(Dialog, append, Answer),

    new(Buttons, dialog_group('')),
    send(Buttons, gap, size(150, 10)),
    send(Dialog, append, Buttons),
    
    new(Button, button('Ok', message(Dialog, destroy))),
    send(Buttons, append, Button),

    new(Exit, button('Exit', and(message(Dialog, destroy), message(@prolog, start)))),
    send(Buttons, append, Exit),

    send(Frame, append, Dialog),
    send(Frame, open).
