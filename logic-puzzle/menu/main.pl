% draw main menu interface
main_menu(Dialog):-

    new(Dialog, dialog),
    send(Dialog, width(700)),
    send(Dialog, height(700)),

    send(Dialog, append, bitmap('./resources/logo.xpm')),

    new(Menu, dialog_group('')),
    send(Dialog, append, Menu),
    send(Menu, gap, size(250, 30)),

    new(Buttons, dialog_group('Select complexity of puzzle')),
    send(Menu, append, Buttons),
    send(Buttons, gap, size(60, 20)),
    send(Buttons, append, button('Low', message(@prolog, play_menu_, Dialog, 0))),
    send(Buttons, append, button('Medium', message(@prolog, play_menu_, Dialog, 1)), next_row),
    send(Buttons, append, button('High', message(@prolog, play_menu_, Dialog, 2)), next_row),

    send(Menu, append, button('Exit', message(Dialog, destroy))).


% destroy main menu and call play_menu to draw play menu
play_menu_(Dialog, Complexity):- send(Dialog, destroy), play_menu(Complexity).

