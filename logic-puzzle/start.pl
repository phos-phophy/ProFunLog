:- use_module(library(pce)). 
:- consult('./menu/main.pl').
:- consult('./menu/play.pl').
:- consult('./mode/question.pl').
:- consult('./mode/answer.pl').
:- consult('./utils.pl').
:- consult('./figures.pl').
:- initialization start.


% main function that starts application
start:- 
    new(Frame, frame('Logic puzzle')),

    main_menu(Dialog),

    send(Frame, append, Dialog),
    send(Frame, open).

