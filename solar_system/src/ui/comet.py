import tkinter as tk

from solar_system.src.stars.celestial import CelestialBody
from solar_system.src.ui.abstract import AbstractGUI
from solar_system.src.ui.app_state import STATE


class CometFrame(tk.Frame):
    def __init__(self, master: AbstractGUI, row: int, column: int, sticky: str):
        super(CometFrame, self).__init__(master=master, relief=tk.SUNKEN, borderwidth=3, padx=10)

        self._configure_grid()
        self.grid(row=row, column=column, sticky=sticky)

        self._add_interface()
        self._add_button()

    def _configure_grid(self):
        self.rowconfigure(index=0, minsize=40, weight=0)

        self.rowconfigure(index=1, minsize=30, weight=0)
        self.rowconfigure(index=2, minsize=30, weight=0)
        self.rowconfigure(index=3, minsize=10, weight=0)

        self.rowconfigure(index=4, minsize=90, weight=0)
        self.rowconfigure(index=5, minsize=10, weight=0)

        self.rowconfigure(index=6, minsize=90, weight=0)
        self.rowconfigure(index=7, minsize=10, weight=0)

        self.rowconfigure(index=8, minsize=30, weight=0)
        self.rowconfigure(index=9, minsize=5, weight=0)

        self.columnconfigure(index=0, minsize=60, weight=1)
        self.columnconfigure(index=1, minsize=170, weight=1)
        self.columnconfigure(index=2, minsize=50, weight=1)

    def _add_interface(self):
        self._add_info_interface()
        self._add_speed_interface()
        self._add_position_interface()

    def _add_info_interface(self):
        tk.Label(master=self, text='Запуск кометы', font='bold').grid(row=0, column=0, columnspan=3)

        self._weight = tk.Entry(master=self)
        self._radius = tk.Entry(master=self)

        self._weight.grid(row=1, column=1, sticky='ew')
        self._radius.grid(row=2, column=1, sticky='ew')

        tk.Label(master=self, text='Масса').grid(row=1, column=0, sticky='w', ipadx=10)
        tk.Label(master=self, text='Радиус').grid(row=2, column=0, sticky='w', ipadx=10)
        tk.Label(master=self, text='кг').grid(row=1, column=2, sticky='ew')
        tk.Label(master=self, text='км').grid(row=2, column=2, sticky='ew')

    def _add_speed_interface(self):
        speed_frame = tk.LabelFrame(master=self, text='Скорость:')

        speed_frame.rowconfigure(index=0, minsize=30, weight=0)
        speed_frame.rowconfigure(index=1, minsize=30, weight=0)

        speed_frame.columnconfigure(index=0, minsize=80, weight=1)
        speed_frame.columnconfigure(index=1, minsize=170, weight=1)
        speed_frame.columnconfigure(index=2, minsize=50, weight=1)

        self._speed_x = tk.Entry(master=speed_frame)
        self._speed_y = tk.Entry(master=speed_frame)
        self._speed_x.grid(row=0, column=1, sticky='ew')
        self._speed_y.grid(row=1, column=1, sticky='ew')

        tk.Label(master=speed_frame, text='по X').grid(row=0, column=0, ipadx=10, sticky='e')
        tk.Label(master=speed_frame, text='по Y').grid(row=1, column=0, ipadx=10, sticky='e')
        tk.Label(master=speed_frame, text='км/с').grid(row=0, column=2, sticky='ew')
        tk.Label(master=speed_frame, text='км/с').grid(row=1, column=2, sticky='ew')

        speed_frame.grid(row=4, column=0, columnspan=3, sticky='news')

    def _add_position_interface(self):
        position_frame = tk.LabelFrame(master=self, text='Расстояние от Солнца:')

        position_frame.rowconfigure(index=0, minsize=30, weight=0)
        position_frame.rowconfigure(index=1, minsize=30, weight=0)
        position_frame.columnconfigure(index=0, minsize=80, weight=1)
        position_frame.columnconfigure(index=1, minsize=170, weight=1)
        position_frame.columnconfigure(index=2, minsize=50, weight=1)

        self._x = tk.Entry(master=position_frame)
        self._y = tk.Entry(master=position_frame)
        self._x.grid(row=0, column=1, sticky='ew')
        self._y.grid(row=1, column=1, sticky='ew')

        tk.Label(master=position_frame, text='по X').grid(row=0, column=0, ipadx=10, sticky='e')
        tk.Label(master=position_frame, text='по Y').grid(row=1, column=0, ipadx=10, sticky='e')
        tk.Label(master=position_frame, text='км').grid(row=0, column=2, sticky='ew')
        tk.Label(master=position_frame, text='км').grid(row=1, column=2, sticky='ew')

        position_frame.grid(row=6, column=0, columnspan=3, sticky='news')

    def _add_button(self):
        tk.Button(master=self, text='Старт', command=self._add_celectial_body).grid(row=8, column=1, sticky='news')

    def _add_celectial_body(self):
        try:
            weight = int(self._weight.get())
            radius = int(self._radius.get())
            speed_x = float(self._speed_x.get())
            speed_y = float(self._speed_y.get())
            x = float(self._x.get()) + STATE.solar_system.star.x
            y = float(self._y.get()) + STATE.solar_system.star.y

            comet = CelestialBody('', 'white', weight, radius, x, y, speed_x, speed_y)

            STATE.solar_system.add_comet(comet)

            self._delete_text()
        except ValueError:
            pass

    def _delete_text(self):
        self._weight.delete(0, tk.END)
        self._radius.delete(0, tk.END)
        self._speed_x.delete(0, tk.END)
        self._speed_y.delete(0, tk.END)
        self._x.delete(0, tk.END)
        self._y.delete(0, tk.END)

    def get_coordinates(self, x: float, y: float):
        self._x.delete(0, tk.END)
        self._y.delete(0, tk.END)

        self._x.insert(0, str(x))
        self._y.insert(0, str(y))
