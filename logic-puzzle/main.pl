:- consult('./generate.pl').
:- use_module(library(pce)). 
:- initialization start.

start:- 
    new(@dw, dialog('Logic puzzle')),
    send(@dw, width(700)),
    send(@dw, height(700)),

    send(@dw, append, bitmap('./logo.xpm')),

    new(@MainMenu, dialog_group('')),
    send(@dw, append, @MainMenu),
    send(@MainMenu, gap, size(250, 30)),

    new(@ComplexityButtons, dialog_group('Select complexity of puzzle')),
    send(@MainMenu, append, @ComplexityButtons),
    send(@ComplexityButtons, gap, size(60, 20)),
    send(@ComplexityButtons, append, button('Easy', message(@prolog, generate_level_, @dw, @MainMenu, 0))),
    send(@ComplexityButtons, append, button('Medium', message(@prolog, generate_level_, @dw, @MainMenu, 1)), next_row),
    send(@ComplexityButtons, append, button('Hard', message(@prolog, generate_level_, @dw, @MainMenu, 2)), next_row),
 
    send(@MainMenu, append, button('Exit', message(@dw, destroy))),

    send(@dw, open).

generate_level_(Frame, HideFrame, Complex):- send(HideFrame, destroy), generate_level(Frame, Complex).
