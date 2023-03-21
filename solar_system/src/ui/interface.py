import tkinter as tk

from solar_system.src.ui.app_state import STATE
from solar_system.src.ui.canvas import Canvas
from solar_system.src.ui.comet import CometFrame
from solar_system.src.ui.satellite import SatelliteFrame

SCALE = 10 ** 6
SCALE_CHANGE = 10 ** 4
SCALE_MIN = 10 ** 4
DELAY = 1

MOVE_X = 3
MOVE_Y = 3

LEFT_CURSOR_KEY = "Left"
RIGHT_CURSOR_KEY = "Right"
UP_CURSOR_KEY = "Up"
DOWN_CURSOR_KEY = "Down"


class SolarGUI(tk.Tk):
    def __init__(self):
        super(SolarGUI, self).__init__()

        self.__configure_main_window()
        self.__configure_button_frame()

        self.frm_comet = CometFrame(self, 0, 1, 'news')
        self.frm_satellite = SatelliteFrame(self, 1, 1, 'news')
        self.cnv = Canvas(self, 0, 0, 'news', 3, 1)

        self.bind_all("<Key>", self.on_key_pressed)

        self.cnv.draw()

    def __configure_main_window(self):
        self.title('Solar system')

        self.rowconfigure(index=0, minsize=300, weight=1)
        self.rowconfigure(index=1, minsize=300, weight=1)
        self.rowconfigure(index=2, minsize=50, weight=0)

        self.columnconfigure(index=0, minsize=800, weight=1)
        self.columnconfigure(index=1, minsize=300, weight=0)

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

        tk.Button(master=self.master, text='+', width=1, command=self.decrease_scale).grid(row=0, column=0, sticky='ne')
        tk.Button(master=self.master, text='-', width=1, command=self.increase_scale).grid(row=0, column=0, sticky='ne', pady=30)

    def start(self):
        if STATE.simulate is False:
            STATE.simulate = True
            self.on_timer()

    @staticmethod
    def stop():
        STATE.simulate = False

    def reset(self):
        STATE.x_diff = 0
        STATE.y_diff = 0
        STATE.scale = SCALE
        STATE.solar_system.reset()
        self.cnv.draw()

    def increase_scale(self):
        STATE.scale += SCALE_CHANGE
        self.cnv.draw()

    def decrease_scale(self):
        STATE.scale = max(STATE.scale - SCALE_CHANGE, SCALE_MIN)
        self.cnv.draw()

    def on_timer(self):
        if STATE.simulate:
            STATE.solar_system.step()
            self.cnv.draw()
            self.after(DELAY, self.on_timer)

    def on_key_pressed(self, e):
        key = e.keysym

        if key == LEFT_CURSOR_KEY:
            STATE.x_diff += MOVE_X

        if key == RIGHT_CURSOR_KEY:
            STATE.x_diff -= MOVE_X

        if key == UP_CURSOR_KEY:
            STATE.y_diff += MOVE_Y

        if key == DOWN_CURSOR_KEY:
            STATE.y_diff -= MOVE_Y

        self.cnv.draw()
