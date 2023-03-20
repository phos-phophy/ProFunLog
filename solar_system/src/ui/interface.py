import tkinter as tk

import numpy as np

from solar_system.src.stars import CelestialBody, SolarSystem

SCALE = 10 ** 6
SCALE_CHANGE = 10 ** 4
SCALE_MIN = 10 ** 4
DELAY = 1


class SolarGUI(tk.Tk):
    def __init__(self):
        super(SolarGUI, self).__init__()

        self._solar_system = SolarSystem(1000)
        self._simulate = False
        self._scale = SCALE

        self.__configure_main_window()
        self.__configure_comet_frame()
        self.__configure_satellite_frame()
        self.__configure_button_frame()
        self.__configure_canvas()

        self._drawn_bodies_ids = {}
        self._drawn_bodies_coordinates = {}

        self.draw()

    def __configure_main_window(self):
        self.title('Solar system')

        self.rowconfigure(index=0, minsize=300, weight=1)
        self.rowconfigure(index=1, minsize=300, weight=1)
        self.rowconfigure(index=2, minsize=50, weight=0)

        self.columnconfigure(index=0, minsize=800, weight=1)
        self.columnconfigure(index=1, minsize=300, weight=0)

    def __configure_comet_frame(self):
        frm_comet = tk.Frame(master=self.master, relief=tk.SUNKEN, borderwidth=3)

        frm_comet.rowconfigure(index=0, minsize=50, weight=1)
        frm_comet.rowconfigure(index=1, minsize=50, weight=1)
        frm_comet.rowconfigure(index=2, minsize=50, weight=1)
        frm_comet.rowconfigure(index=3, minsize=50, weight=1)
        frm_comet.rowconfigure(index=4, minsize=50, weight=1)

        frm_comet.columnconfigure(index=0, minsize=100, weight=1)
        frm_comet.columnconfigure(index=1, minsize=150, weight=1)
        frm_comet.columnconfigure(index=2, minsize=50, weight=1)

        frm_comet.grid(row=0, column=1, sticky='news')

        tk.Label(master=frm_comet, text='Запуск кометы', font='bold').grid(row=0, column=0, columnspan=3)
        tk.Label(master=frm_comet, text='Масса').grid(row=1, column=0, sticky='e')
        tk.Label(master=frm_comet, text='Диаметр').grid(row=2, column=0, sticky='e')
        tk.Label(master=frm_comet, text='Скорость').grid(row=3, column=0, sticky='e')

        tk.Entry(master=frm_comet).grid(row=1, column=1, sticky='ew')
        tk.Entry(master=frm_comet).grid(row=2, column=1, sticky='ew')
        tk.Entry(master=frm_comet).grid(row=3, column=1, sticky='ew')

        tk.Label(master=frm_comet, text='кг').grid(row=1, column=2, sticky='w')
        tk.Label(master=frm_comet, text='км').grid(row=2, column=2, sticky='w')
        tk.Label(master=frm_comet, text='км/с').grid(row=3, column=2, sticky='w')

    def __configure_satellite_frame(self):
        frm_satellite = tk.Frame(master=self.master, relief=tk.SUNKEN, borderwidth=3)

        frm_satellite.rowconfigure(index=0, minsize=50, weight=1)
        frm_satellite.rowconfigure(index=1, minsize=50, weight=1)
        frm_satellite.rowconfigure(index=2, minsize=50, weight=1)
        frm_satellite.rowconfigure(index=3, minsize=50, weight=1)
        frm_satellite.rowconfigure(index=4, minsize=50, weight=1)

        frm_satellite.columnconfigure(index=0, minsize=100, weight=1)
        frm_satellite.columnconfigure(index=1, minsize=150, weight=1)
        frm_satellite.columnconfigure(index=2, minsize=50, weight=1)

        frm_satellite.grid(row=1, column=1, sticky='news')

        tk.Label(master=frm_satellite, text='Запуск спутника', font='bold').grid(row=0, column=0, columnspan=3)
        tk.Label(master=frm_satellite, text='Масса').grid(row=1, column=0, sticky='e')
        tk.Label(master=frm_satellite, text='Диаметр').grid(row=2, column=0, sticky='e')
        tk.Label(master=frm_satellite, text='Скорость').grid(row=3, column=0, sticky='e')

        tk.Entry(master=frm_satellite).grid(row=1, column=1, sticky='ew')
        tk.Entry(master=frm_satellite).grid(row=2, column=1, sticky='ew')
        tk.Entry(master=frm_satellite).grid(row=3, column=1, sticky='ew')

        tk.Label(master=frm_satellite, text='кг').grid(row=1, column=2, sticky='w')
        tk.Label(master=frm_satellite, text='км').grid(row=2, column=2, sticky='w')
        tk.Label(master=frm_satellite, text='км/с').grid(row=3, column=2, sticky='w')

    def __configure_button_frame(self):
        frm_button = tk.Frame(master=self.master, relief=tk.RAISED, borderwidth=2)

        frm_button.columnconfigure(index=0, minsize=100, weight=1)
        frm_button.columnconfigure(index=1, minsize=100, weight=1)
        frm_button.columnconfigure(index=2, minsize=100, weight=1)

        frm_button.rowconfigure(index=0, minsize=50, weight=1)

        frm_button.grid(row=2, column=1, sticky='news')

        tk.Button(master=frm_button, text='Начать', command=self.start).grid(row=0, column=0, sticky='news')
        tk.Button(master=frm_button, text='Остановить', command=self.stop).grid(row=0, column=1, sticky='news')
        tk.Button(master=frm_button, text='Сбросить', command=self.reset).grid(row=0, column=2, sticky='news')

    def __configure_canvas(self):
        self.cnv = tk.Canvas(master=self.master, background='black')
        self.cnv.grid(row=0, rowspan=3, column=0, sticky='news')

        tk.Button(master=self.master, text='+', width=1, command=self.decrease_scale).grid(row=0, column=0, sticky='ne')
        tk.Button(master=self.master, text='-', width=1, command=self.increase_scale).grid(row=0, column=0, sticky='ne', pady=30)

    def start(self):
        if self._simulate is False:
            self._simulate = True
            self.on_timer()

    def stop(self):
        self._simulate = False

    def reset(self):
        self._solar_system.reset()
        self.draw()

    def increase_scale(self):
        self._scale += SCALE_CHANGE
        self.draw()

    def decrease_scale(self):
        self._scale = max(self._scale - SCALE_CHANGE, SCALE_MIN)
        self.draw()

    def get_body_coordinates(self, body: CelestialBody, w_center: int, h_center: int):

        radius = max(body.radius // self._scale, 1)
        x = body.x // self._scale
        y = body.y // self._scale

        return w_center - radius + x, h_center - radius + y, w_center + radius + x, h_center + radius + y

    def get_body_trace_coordinates(self, body: CelestialBody, w_center: int, h_center: int):
        coordinates = np.array(list(map(lambda x: x // self._scale, body.trace)))
        coordinates[::2] += w_center
        coordinates[1::2] += h_center
        return tuple(coordinates)

    def draw(self):

        self.update()
        bounds = self.grid_bbox(row=0, column=0, col2=0, row2=2)

        w_center = (bounds[2] - bounds[0]) // 2
        h_center = (bounds[3] - bounds[1]) // 2

        self.draw_body(self._solar_system.star, w_center, h_center)

        for planet in self._solar_system.planets:
            self.draw_body(planet, w_center, h_center)
            self.draw_trace(planet, w_center, h_center)

    def draw_body(self, body: CelestialBody, w_center, h_center):
        coordinates = self.get_body_coordinates(body, w_center, h_center)
        if self._drawn_bodies_coordinates.get(body.name, []) != coordinates:
            body_id = self._drawn_bodies_ids.get(body.name, None)
            if body_id:
                self.cnv.delete(body_id)
            self._drawn_bodies_coordinates[body.name] = coordinates
            self._drawn_bodies_ids[body.name] = self.cnv.create_oval(*coordinates, fill=body.color, outline=body.color)

    def draw_trace(self, body: CelestialBody, w_center, h_center):
        name = f'{body.name}_trace'
        coordinates = self.get_body_trace_coordinates(body, w_center, h_center)
        old_coordinates = self._drawn_bodies_coordinates.get(name, tuple())
        if len(coordinates) != len(old_coordinates) or coordinates != old_coordinates:
            body_id = self._drawn_bodies_ids.get(name, None)
            if body_id:
                self.cnv.delete(body_id)
            if len(body.trace) > 2:
                self._drawn_bodies_coordinates[name] = coordinates
                self._drawn_bodies_ids[name] = self.cnv.create_line(coordinates, fill=body.color)

    def on_timer(self):
        if self._simulate:
            self._solar_system.step()
            self.draw()
            self.after(DELAY, self.on_timer)


if __name__ == '__main__':
    system = SolarGUI()
    system.mainloop()
