import tkinter as tk

from solar_system.src.stars import CelestialBody, SolarSystem

SCALE = 10 ** 6
DELAY = 1


class SolarGUI(tk.Tk):
    def __init__(self):
        super(SolarGUI, self).__init__()

        self._solar_system = SolarSystem(1000)
        self._simulate = False

        self.__configure_main_window()
        self.__configure_comet_frame()
        self.__configure_satellite_frame()
        self.__configure_button_frame()
        self.__configure_canvas()

        self.write()

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

    def start(self):
        if self._simulate is False:
            self._simulate = True
            self.on_timer()

    def stop(self):
        self._simulate = False

    def reset(self):
        self.cnv.delete(tk.ALL)
        self._solar_system.reset()

    def get_coordinates(self, body: CelestialBody):

        self.update()
        bounds = self.grid_bbox(row=0, column=0, col2=0, row2=2)

        w_center = (bounds[2] - bounds[0]) // 2
        h_center = (bounds[3] - bounds[1]) // 2

        radius = max(body.radius // SCALE, 1)
        x = body.x // SCALE
        y = body.y // SCALE

        return w_center - radius + x, h_center - radius + y, w_center + radius + x, h_center + radius + y

    def write(self):
        # self.cnv.delete(tk.ALL)

        star = self._solar_system.star
        self.cnv.create_oval(*self.get_coordinates(star), fill=star.color, outline=star.color)

        for planet in self._solar_system.planets:
            self.cnv.create_oval(*self.get_coordinates(planet), fill=planet.color, outline=planet.color)

    def on_timer(self):
        if self._simulate:
            self._solar_system.step()
            self.write()
            self.after(DELAY, self.on_timer)


if __name__ == '__main__':
    system = SolarGUI()
    system.mainloop()
