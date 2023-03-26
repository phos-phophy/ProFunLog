import tkinter as tk

from solar_system.src.stars import CelestialBody
from solar_system.src.ui.app_state import STATE


class Canvas(tk.Canvas):
    def __init__(self, master, row, column, sticky, rowspan=1, columnspan=1):
        super(Canvas, self).__init__(master=master, background='black')

        self.grid(row=row, rowspan=rowspan, column=column, columnspan=columnspan, sticky=sticky)

        self._drawn_bodies_ids = {}
        self._drawn_names_ids = {}
        self._drawn_bodies_coordinates = {}

    @staticmethod
    def get_body_coordinates(body: CelestialBody, w_center: int, h_center: int):

        radius = max(body.radius // STATE.scale, 1)
        x = body.x // STATE.scale + STATE.x_diff
        y = body.y // STATE.scale + STATE.y_diff

        return w_center - radius + x, h_center - radius + y, w_center + radius + x, h_center + radius + y

    def draw(self):

        self.master.update()
        bounds = self.master.grid_bbox(row=0, column=0, col2=0, row2=2)

        w_center = (bounds[2] - bounds[0]) // 2
        h_center = (bounds[3] - bounds[1]) // 2

        self.draw_body(STATE.solar_system.star, w_center, h_center)

        for planet in STATE.solar_system.planets:
            self.draw_body(planet, w_center, h_center)

    def draw_body(self, body: CelestialBody, w_center, h_center):
        coordinates = self.get_body_coordinates(body, w_center, h_center)

        if self._drawn_bodies_coordinates.get(body.name, []) != coordinates:
            body_id = self._drawn_bodies_ids.get(body.name, None)
            name_id = self._drawn_names_ids.get(body.name, None)

            if body_id:
                self.delete(body_id)
            if name_id:
                self.delete(name_id)

            self._drawn_bodies_coordinates[body.name] = coordinates
            self._drawn_bodies_ids[body.name] = self.create_oval(*coordinates, fill=body.color, outline=body.color)

            text_coordinates = list(map(lambda x: x - 10, coordinates[:2]))
            self._drawn_names_ids[body.name] = self.create_text(*text_coordinates, text=body.name, fill='white')