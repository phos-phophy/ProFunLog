import tkinter as tk

from solar_system.src.stars.celestial import CelestialBody
from solar_system.src.ui.abstract import AbstractGUI
from solar_system.src.ui.app_state import STATE


class InformationFrame(tk.Frame):
    def __init__(self, master: AbstractGUI, row: int, column: int, sticky: str):
        super(InformationFrame, self).__init__(master=master, relief=tk.SUNKEN, borderwidth=3, padx=10)

        self._configure_grid()
        self._configure_info()
        self.grid(row=row, column=column, sticky=sticky)

    def _configure_grid(self):
        self.rowconfigure(index=0, minsize=40, weight=0)
        self.rowconfigure(index=1, minsize=30, weight=0)
        self.rowconfigure(index=2, minsize=30, weight=0)
        self.rowconfigure(index=3, minsize=10, weight=0)
        self.rowconfigure(index=4, minsize=30, weight=0)
        self.rowconfigure(index=5, minsize=30, weight=0)
        self.rowconfigure(index=6, minsize=10, weight=0)
        self.rowconfigure(index=7, minsize=30, weight=0)
        self.rowconfigure(index=8, minsize=30, weight=0)
        self.rowconfigure(index=9, minsize=10, weight=0)

        self.columnconfigure(index=0, minsize=300, weight=0)

    def _configure_info(self):

        self._info = tk.StringVar()
        self._weight = tk.StringVar()
        self._radius = tk.StringVar()
        self._speed_x = tk.StringVar()
        self._speed_y = tk.StringVar()
        self._x = tk.StringVar()
        self._y = tk.StringVar()

        tk.Label(master=self, textvariable=self._info, font='bond').grid(row=0, column=0, sticky='nws')
        tk.Label(master=self, textvariable=self._weight).grid(row=1, column=0, sticky='nws')
        tk.Label(master=self, textvariable=self._radius).grid(row=2, column=0, sticky='nws')

        tk.Label(master=self, textvariable=self._speed_x).grid(row=4, column=0, sticky='nws')
        tk.Label(master=self, textvariable=self._speed_y).grid(row=5, column=0, sticky='nws')

        tk.Label(master=self, textvariable=self._x).grid(row=7, column=0, sticky='nws')
        tk.Label(master=self, textvariable=self._y).grid(row=8, column=0, sticky='nws')

    def update_info(self):
        system = STATE.solar_system
        body: CelestialBody = system.bodies[STATE.selected_body_info]

        star: CelestialBody = system.star

        self._info.set(f'Информация о {body.name}')
        self._weight.set(f'Масса:   {body.weight}   кг')
        self._radius.set(f'Радиус:   {body.radius:.0f}   км')
        self._speed_x.set(f'Скорость по X:   {body.speed_x:.0f}   км/с')
        self._speed_y.set(f'Скорость по Y:   {body.speed_y:.0f}   км/с')
        self._x.set(f'Расстояние от Солнца по X:   {body.x - star.x:.0f}   км')
        self._y.set(f'Расстояние от Солнца по Y:   {body.y - star.y:.0f}   км')
