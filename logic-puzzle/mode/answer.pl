% display answers
display_answers(PictureA, Select):-
    get(Select, selection, UserAnswer),

    answer(RightAnswer),
    highlight(RightAnswer, RightAnswer, PictureA),  % highlight correct answer
    highlight(UserAnswer, RightAnswer, PictureA).  % highlight wrong answer if there is


highlight(Answer1, Answer2, Picture):-
    % if one wants to see correct answer, don't highlight 4 position
    showAnswerText(Answer1);

    size(Size),
    Aside is Size / 2,
    Center is -50 + 150 * Answer1,
    pictureAHeight(H), Height is H / 2 + Size * 3 / 4,

    new(Line, path),
    send_list(Line, append, [point(Center - Aside, Height), point(Center + Aside, Height)]),
    (Answer1 =:= Answer2 -> send(Line, colour, colour(green)) ; send(Line, colour, colour(red))),

    send(Picture, display, Line).

