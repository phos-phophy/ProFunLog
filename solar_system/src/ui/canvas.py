import tkinter as tk
from functools import partial
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

        self._axis_ids = None
        self._axis_coordinates = None

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

        base_solar_system = STATE.solar_system.bodies

        submenu_cnv = tk.Menu(self._cnv_menu)
        submenu_info = tk.Menu(self._cnv_menu)

        def set_cnv(idx):
            STATE.set_selected_body_cnv(idx)

        def set_info(idx):
            STATE.set_selected_body_info(idx)

        def show_names():
            STATE.show_names = not STATE.show_names
            self._show_names.set(STATE.show_names)

        for body_idx, body in enumerate(base_solar_system):
            submenu_cnv.add_command(label=body.name, command=partial(set_cnv, idx=body_idx))
            submenu_info.add_command(label=body.name, command=partial(set_info, idx=body_idx))

        self._show_names = tk.BooleanVar()
        self._show_names.set(STATE.show_names)

        self._cnv_menu.add_checkbutton(label="Названия планет", onvalue=1, offvalue=0, variable=self._show_names, command=show_names)
        self._cnv_menu.add_separator()
        self._cnv_menu.add_command(label="Получить координаты", command=get_coordinates, compound='right')
        self._cnv_menu.add_separator()
        self._cnv_menu.add_cascade(label="Зафиксировать камеру на...", menu=submenu_cnv, underline=0)
        self._cnv_menu.add_cascade(label="Вывести информацию о...", menu=submenu_info, underline=0)

        self.bind("<Button-3>", show_menu)

    @staticmethod
    def _get_body_coordinates(body: CelestialBody, w_center: int, h_center: int):

        selected_body = STATE.solar_system.bodies[STATE.selected_body_cnv]

        radius = max(body.radius // STATE.scale, 1)
        x = (body.x - selected_body.x) // STATE.scale + STATE.x_diff
        y = (body.y - selected_body.y) // STATE.scale + STATE.y_diff

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

        self._draw_axis(w_center, h_center)

    def _draw_axis(self, w_center: int, h_center: int):
        star = STATE.solar_system.star
        coordinates = self._get_body_coordinates(star, w_center, h_center)
        if self._axis_coordinates != coordinates:
            self._axis_coordinates = coordinates

            x = coordinates[0] + (coordinates[2] - coordinates[0]) / 2
            y = coordinates[1] + (coordinates[3] - coordinates[1]) / 2

            if self._axis_ids:
                self.coords(self._axis_ids['x_text'], x + 35, y - 10)
                self.coords(self._axis_ids['x'], x, y, x + 40, y)
                self.coords(self._axis_ids['x_'], x + 40, y, x + 35, y + 5)
                self.coords(self._axis_ids['_x'], x + 40, y, x + 35, y - 5)

                self.coords(self._axis_ids['y_text'], x - 10, y + 35)
                self.coords(self._axis_ids['y'], x, y, x, y + 40)
                self.coords(self._axis_ids['y_'], x, y + 40, x - 5, y + 35)
                self.coords(self._axis_ids['_y'], x, y + 40, x + 5, y + 35)
            else:
                self._axis_ids = {
                    'x_text': self.create_text(x + 35, y - 10, text='x', fill='red'),
                    'x': self.create_line(x, y, x + 40, y, fill='red'),
                    'x_': self.create_line(x + 40, y, x + 35, y + 5, fill='red'),
                    '_x': self.create_line(x + 40, y, x + 35, y - 5, fill='red'),

                    'y_text': self.create_text(x - 10, y + 35, text='y', fill='red'),
                    'y': self.create_line(x, y, x, y + 40, fill='red'),
                    'y_': self.create_line(x, y + 40, x - 5, y + 35, fill='red'),
                    '_y': self.create_line(x, y + 40, x + 5, y + 35, fill='red')
                }

    def _draw_body(self, body: CelestialBody, w_center: int, h_center: int):

        body_id = self._drawn_bodies_ids.get(body.name, None)
        name_id = self._drawn_names_ids.get(body.name, None)

        coordinates = self._get_body_coordinates(body, w_center, h_center)
        text_coordinates = list(map(lambda x: x - 10, coordinates[:2]))

        change_position = self._drawn_bodies_coordinates.get(body.name, []) != coordinates

        if change_position:
            self._drawn_bodies_coordinates[body.name] = coordinates
            if body_id:
                self.coords(body_id, *coordinates)
            else:
                self._drawn_bodies_ids[body.name] = self.create_oval(*coordinates, fill=body.color, outline=body.color)

        if name_id and not STATE.show_names:
            self.delete(name_id)
            self._drawn_names_ids.pop(body.name)
        elif STATE.show_names:
            if change_position and name_id:
                self.coords(name_id, *text_coordinates)
            elif change_position:
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
