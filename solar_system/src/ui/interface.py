import tkinter as tk

from solar_system.src.ui.abstract import AbstractGUI
from solar_system.src.ui.app_state import STATE
from solar_system.src.ui.info import InformationFrame
from solar_system.src.ui.canvas import Canvas
from solar_system.src.ui.comet import CometFrame

DELAY = 1

MOVE_X = 3
MOVE_Y = 3


class SolarGUI(AbstractGUI):
    def __init__(self):
        super(SolarGUI, self).__init__()

        self._configure_main_window()

        self._cnv = Canvas(self, 0, 0, 'news', 3, 2)
        self._info = InformationFrame(self, 1, 1, 'news')
        self._frm_comet = CometFrame(self, 0, 1, 'news')

        self._configure_button_frame()

        self._cnv.draw()
        self._info.update_info()

    def _configure_main_window(self):
        self.title('Solar system')

        self.rowconfigure(index=0, minsize=300, weight=1)
        self.rowconfigure(index=1, minsize=250, weight=1)
        self.rowconfigure(index=2, minsize=50, weight=0)

        self.columnconfigure(index=0, minsize=800, weight=1)
        self.columnconfigure(index=1, minsize=300, weight=0)

    def _configure_button_frame(self):
        frm_button = tk.Frame(master=self.master, relief=tk.RAISED, borderwidth=2)

        frm_button.columnconfigure(index=0, minsize=100, weight=1)
        frm_button.columnconfigure(index=1, minsize=100, weight=1)
        frm_button.columnconfigure(index=2, minsize=100, weight=1)

        frm_button.rowconfigure(index=0, minsize=50, weight=1)

        frm_button.grid(row=2, column=1, sticky='news')

        tk.Button(master=frm_button, text='Начать', command=self._start).grid(row=0, column=0, sticky='news')
        tk.Button(master=frm_button, text='Остановить', command=self._stop).grid(row=0, column=1, sticky='news')
        tk.Button(master=frm_button, text='Сбросить', command=self._reset).grid(row=0, column=2, sticky='news')

        tk.Button(master=self.master, text='+', width=1, command=self._decrease_scale).grid(row=0, column=0, sticky='ne')
        tk.Button(master=self.master, text='-', width=1, command=self._increase_scale).grid(row=0, column=0, sticky='ne', pady=30)

    def _start(self):
        if STATE.simulate is False:
            STATE.simulate = True
            self._on_timer()

    @staticmethod
    def _stop():
        STATE.simulate = False

    def _reset(self):
        STATE.reset()
        self._cnv.draw()

    def _increase_scale(self):
        STATE.increase_scale()
        self._cnv.draw()

    def _decrease_scale(self):
        STATE.decrease_scale()
        self._info.update_info()
        self._cnv.draw()

    def _on_timer(self):
        if STATE.simulate:
            STATE.solar_system.step()
            self._info.update_info()
            self._cnv.draw()
            self.after(DELAY, self._on_timer)

    def get_comet_coordinates(self, x: float, y: float):
        self._frm_comet.get_coordinates(x, y)
