% define possible figures; S - size
figure(0, Box, S):- new(Box, box(S, S)).
figure(1, Circle, S):- new(Circle, circle(S)).
figure(2, Triangle, S):- new(Triangle, path), send_list(Triangle, append, [point(0, 0), point(S / 2, -S), point(S, 0), point(0, 0)]).
figure(3, Triangle, S):- new(Triangle, path), send_list(Triangle, append, [point(0, S / 2), point(0, -S / 2), point(S, -S / 2), point(0, S / 2)]).
figure(4, Triangle, S):- new(Triangle, path), send_list(Triangle, append, [point(0, -S / 2), point(S, -S / 2), point(S, S / 2), point(0, -S / 2)]).


% define possible colours
colour(ColourInd, Colour):-
    Colours = [black, red, green, blue, white],
    by_index(Colour, Colours, ColourInd).


% Desc: Type - figure description
generate_desc(Desc, Comp):-
    generate_type(Type, Comp),
    generate_bourder_colour(BColourInd, Comp),
    generate_inner_colour(IColourInd, Comp),

    Desc = [Type, BColourInd, IColourInd].


% low - 3 types of shape
% medium - 3 types of shape
% high - 5 types of shape
generate_type(Type, 2):- random(0, 5, Type).
generate_type(Type, _):- random(0, 3, Type).


% low - only white colour
% medium and high - 4 types of colour
generate_bourder_colour(0, 0).
generate_bourder_colour(ColourInd, _):- random(0, 4, ColourInd).


generate_inner_colour(4, 0).
generate_inner_colour(ColourInd, _):- random(0, 5, ColourInd).


how_to_change(How, 0):- random(0, 2, How).
how_to_change(How, _):- random(0, 6, How).


change_desc(Desc11, Desc12, Desc21, Desc22, Comp):-
    how_to_change(How, Comp),
    change_desc_(Desc11, Desc12, Desc21, Desc22, How, Comp),

    check_desc(Desc21, Desc22);

    change_desc(Desc11, Desc12, Desc21, Desc22, Comp).


% change first type
change_desc_(Desc11, Desc12, Desc21, Desc12, 0, Comp):-
    generate_type(Type, Comp),

    Desc11 = [Type11, BColourInd11, IColourInd11],
    Desc21 = [Type, BColourInd11, IColourInd11],

    not(same(Type11, Type));

    change_desc_(Desc11, Desc12, Desc21, Desc12, 0, Comp).
% change second type
change_desc_(Desc11, Desc12, Desc11, Desc22, 1, Comp):-
    generate_type(Type, Comp),

    Desc12 = [Type12, BColourInd12, IColourInd12],
    Desc22 = [Type, BColourInd12, IColourInd12],

    not(same(Type12, Type));

    change_desc_(Desc11, Desc12, Desc11, Desc22, 1, Comp).
% change first bourder colour
change_desc_(Desc11, Desc12, Desc21, Desc12, 2, Comp):-
    generate_bourder_colour(BColourInd, Comp),

    Desc11 = [Type11, BColourInd11, IColourInd11],
    Desc21 = [Type11, BColourInd, IColourInd11],

    not(same(BColourInd11, BColourInd));

    change_desc_(Desc11, Desc12, Desc21, Desc12, 2, Comp).
% change second bourder colour
change_desc_(Desc11, Desc12, Desc11, Desc22, 3, Comp):-
    generate_bourder_colour(BColourInd, Comp),

    Desc12 = [Type12, BColourInd12, IColourInd12],
    Desc22 = [Type12, BColourInd, IColourInd12],

    not(same(BColourInd12, BColourInd));

    change_desc_(Desc11, Desc12, Desc11, Desc22, 3, Comp).
% change first inner colour
change_desc_(Desc11, Desc12, Desc21, Desc12, 4, Comp):-
    generate_inner_colour(IColourInd, Comp),

    Desc11 = [Type11, BColourInd11, IColourInd11],
    Desc21 = [Type11, BColourInd11, IColourInd],

    not(same(IColourInd11, IColourInd));

    change_desc_(Desc11, Desc12, Desc21, Desc12, 4, Comp).
% change second inner colour
change_desc_(Desc11, Desc12, Desc11, Desc22, 5, Comp):-
    generate_inner_colour(IColourInd, Comp),

    Desc12 = [Type12, BColourInd12, IColourInd12],
    Desc22 = [Type12, BColourInd12, IColourInd],

    not(same(IColourInd12, IColourInd));

    change_desc_(Desc11, Desc12, Desc11, Desc22, 5, Comp).


generate_figure_desc(Desc1, Desc2, Comp):- 
    generate_desc(Desc1, Comp),
    generate_desc(Desc2, Comp),
    
    check_desc(Desc1, Desc2);

    generate_figure_desc(Desc1, Desc2, Comp).


check_desc(Desc1, Desc2):- 
    Desc1 = [_, BColourInd1, IColourInd1], 
    Desc2 = [_, BColourInd2, IColourInd2],

    not(same(BColourInd1, IColourInd2)),
    not(same(BColourInd2, IColourInd1)).


get_descs(Desc1, Desc2, Desc3, Desc4, Desc5, Desc6, Desc7, Desc8, Comp):- 
    generate_figure_desc(Desc1, Desc2, Comp),
    generate_figure_desc(Desc3, Desc4, Comp), 

    change_desc(Desc4, Desc3, Desc5, Desc6, Comp),
    change_desc(Desc4, Desc3, Desc7, Desc8, Comp).


get_single_figure(Figure, Desc, Size):-

    Desc = [Type, BColourInd, IColourInd],

    figure(Type, Figure, Size),

    colour(BColourInd, BColour),
    colour(IColourInd, IColour),

    send(Figure, colour, colour(BColour)),
    send(Figure, fill_pattern, colour(IColour)).

