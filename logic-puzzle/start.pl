:- use_module(library(pce)). 
:- consult('./menu/main.pl').
:- consult('./menu/play.pl').
:- consult('./figure/__init__.pl').
:- consult('./menu/__init__.pl').
:- consult('./mode/__init__.pl').
:- consult('./utils.pl').
:- initialization start.


% main function that starts application
start:- 
    new(Frame, frame('Logic puzzle')),

    main_menu(Dialog),

    send(Frame, append, Dialog),
    send(Frame, open).

