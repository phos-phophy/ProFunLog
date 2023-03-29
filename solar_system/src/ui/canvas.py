import tkinter as tk
from typing import Optional

from solar_system.src.stars import CelestialBody
from solar_system.src.ui.abstract import AbstractGUI
from solar_system.src.ui.app_state import STATE

MOVE_X = 3
MOVE_Y = 3


class Canvas(tk.Canvas):
    def __init__(self, master: AbstractGUI, row: int, column: int, sticky: str, rowspan: int = 1, columnspan: int = 1):
        super(Canvas, self).__init__(master=master, background='black')

        self.master: AbstractGUI = master

        self.grid(row=row, rowspan=rowspan, column=column, columnspan=columnspan, sticky=sticky)

        self._drawn_bodies_ids = {}
        self._drawn_names_ids = {}
        self._drawn_bodies_coordinates = {}

        self.bind("<Key>", self._move_camera)
        self.bind('<Button-1>', self._focus_to_canvas)

        self._e: Optional[tk.Event] = None
        self._configure_submenu()

    def _configure_submenu(self):
        self._cnv_menu = tk.Menu(self, tearoff=0)

        def show_menu(e):
            self._e = e
            self._cnv_menu.tk_popup(e.x_root, e.y_root)

        def get_coordinates():
            w_center, h_center = self._get_center_coordinates()
            x = (self._e.x - w_center - STATE.x_diff) * STATE.scale
            y = (self._e.y - h_center - STATE.y_diff) * STATE.scale
            self.master.get_comet_coordinates(x, y)

        self._cnv_menu.add_separator()
        self._cnv_menu.add_command(label="Получить координаты", command=get_coordinates, compound='right')

        self.bind("<Button-3>", show_menu)

    @staticmethod
    def _get_body_coordinates(body: CelestialBody, w_center: int, h_center: int):

        radius = max(body.radius // STATE.scale, 1)
        x = body.x // STATE.scale + STATE.x_diff
        y = body.y // STATE.scale + STATE.y_diff

        return w_center - radius + x, h_center - radius + y, w_center + radius + x, h_center + radius + y

    def _get_center_coordinates(self):
        self.master.update()
        bounds = self.master.grid_bbox(row=0, column=0, col2=0, row2=2)

        w_center = (bounds[2] - bounds[0]) // 2
        h_center = (bounds[3] - bounds[1]) // 2

        return w_center, h_center

    def draw(self):
        w_center, h_center = self._get_center_coordinates()

        for body in STATE.solar_system.bodies:
            self._draw_body(body, w_center, h_center)

    def _draw_body(self, body: CelestialBody, w_center: int, h_center: int):
        coordinates = self._get_body_coordinates(body, w_center, h_center)

        if self._drawn_bodies_coordinates.get(body.name, []) != coordinates:
            body_id = self._drawn_bodies_ids.get(body.name, None)
            name_id = self._drawn_names_ids.get(body.name, None)

            if body_id:
                self.delete(body_id)
            if name_id:
                self.delete(name_id)

            self._drawn_bodies_coordinates[body.name] = coordinates
            self._drawn_bodies_ids[body.name] = self.create_oval(*coordinates, fill=body.color, outline=body.color)

            if STATE.show_names:
                text_coordinates = list(map(lambda x: x - 10, coordinates[:2]))
                self._drawn_names_ids[body.name] = self.create_text(*text_coordinates, text=body.name, fill='white')

    def _move_camera(self, e: tk.Event):

        actions = {
            "Left": lambda: STATE.change_x_diff(MOVE_X),
            "Right": lambda: STATE.change_x_diff(-MOVE_X),
            "Up": lambda: STATE.change_y_diff(MOVE_Y),
            "Down": lambda: STATE.change_y_diff(-MOVE_Y)
        }

        actions.get(e.keysym, lambda: None)()
        self.draw()

    def _focus_to_canvas(self, _):
        self.focus_set()
