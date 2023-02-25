how_to_change(How, 0):- random(0, 2, How).
how_to_change(How, _):- random(0, 6, How).


% change 1 parameter of figure (Desc11, Desc12) and get another one (Desc21, Desc22)
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

    not(same(BColourInd, IColourInd11)),
    not(same(BColourInd11, BColourInd));

    change_desc_(Desc11, Desc12, Desc21, Desc12, 2, Comp).
% change second bourder colour
change_desc_(Desc11, Desc12, Desc11, Desc22, 3, Comp):-
    generate_bourder_colour(BColourInd, Comp),

    Desc12 = [Type12, BColourInd12, IColourInd12],
    Desc22 = [Type12, BColourInd, IColourInd12],

    not(same(BColourInd, IColourInd12)),
    not(same(BColourInd12, BColourInd));

    change_desc_(Desc11, Desc12, Desc11, Desc22, 3, Comp).
% change first inner colour
change_desc_(Desc11, Desc12, Desc21, Desc12, 4, Comp):-
    generate_inner_colour(IColourInd, Comp),

    Desc11 = [Type11, BColourInd11, IColourInd11],
    Desc21 = [Type11, BColourInd11, IColourInd],

    not(same(BColourInd11, IColourInd)),
    not(same(IColourInd11, IColourInd));

    change_desc_(Desc11, Desc12, Desc21, Desc12, 4, Comp).
% change second inner colour
change_desc_(Desc11, Desc12, Desc11, Desc22, 5, Comp):-
    generate_inner_colour(IColourInd, Comp),

    Desc12 = [Type12, BColourInd12, IColourInd12],
    Desc22 = [Type12, BColourInd12, IColourInd],
    
    not(same(IColourInd, BColourInd12)),
    not(same(IColourInd12, IColourInd));

    change_desc_(Desc11, Desc12, Desc11, Desc22, 5, Comp).

