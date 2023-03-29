import tkinter as tk

from solar_system.src.ui.abstract import AbstractGUI
from solar_system.src.ui.app_state import STATE


class ButtonsFrame(tk.Frame):
    def __init__(self, master: AbstractGUI, row: int, column: int, sticky: str):
        super(ButtonsFrame, self).__init__(master=master, relief=tk.RAISED, borderwidth=2)

        self.master: AbstractGUI = master

        self._configure_grid()
        self._add_buttons()
        self._add_time_controller()
        self.grid(row=row, column=column, sticky=sticky)

    def _configure_grid(self):
        self.columnconfigure(index=0, minsize=100, weight=1)
        self.columnconfigure(index=1, minsize=100, weight=1)
        self.columnconfigure(index=2, minsize=100, weight=1)

        self.rowconfigure(index=0, minsize=50, weight=1)
        self.rowconfigure(index=1, minsize=50, weight=1)

    def _add_buttons(self):
        tk.Button(master=self, text='Начать', command=self._start).grid(row=1, column=0, sticky='news')
        tk.Button(master=self, text='Остановить', command=self._stop).grid(row=1, column=1, sticky='news')
        tk.Button(master=self, text='Сбросить', command=self._reset).grid(row=1, column=2, sticky='news')

        tk.Button(master=self.master, text='+', width=1, command=self._decrease_scale).grid(row=0, column=0, sticky='ne')
        tk.Button(master=self.master, text='-', width=1, command=self._increase_scale).grid(row=0, column=0, sticky='ne', pady=30)

    def _add_time_controller(self):
        from_ = STATE.STEP_SIZE_MIN
        to = STATE.STEP_SIZE_MAX
        tk.Label(master=self, text='Шаг (км):').grid(row=0, column=0, sticky='news')
        self._scale = tk.Scale(master=self, from_=from_, to=to, orient='horizontal', command=self._change_step)
        self._scale.set(STATE.solar_system.step_size)
        self._scale.grid(row=0, column=1, columnspan=2, sticky='news')

    def _start(self):
        if STATE.simulate is False:
            STATE.simulate = True
            self.master.on_timer()

    @staticmethod
    def _stop():
        STATE.simulate = False

    def _reset(self):
        STATE.reset()
        self.master.draw()

    def _increase_scale(self):
        STATE.increase_scale()
        self.master.draw()

    def _decrease_scale(self):
        STATE.decrease_scale()
        self.master.draw()

    @staticmethod
    def _change_step(val):
        STATE.solar_system.step_size = int(val)
