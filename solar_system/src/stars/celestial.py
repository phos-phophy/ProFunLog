from typing import TypeVar

import numpy as np

from solar_system.src.stars.state import State

_CelestialBody = TypeVar('_CelestialBody', bound='CelestialBody')


class CelestialBody(State):
    def __init__(self, name: str, color: str, weight: int, radius: int, x: float, y: float, speed_x: float, speed_y: float):
        self._name = name
        self._color = color
        self._weight = weight
        self._radius = radius
        self.x = x
        self.y = y
        self.speed_x = speed_x
        self.speed_y = speed_y

        super(CelestialBody, self).__init__()

    @property
    def name(self):
        return self._name

    @property
    def color(self):
        return self._color

    @property
    def weight(self):
        return self._weight

    @property
    def radius(self):
        return self._radius

    def get_position(self):
        return np.array([self.x, self.y, self.speed_x, self.speed_y])

    def set_position(self, position: np.ndarray):
        self.x, self.y, self.speed_x, self.speed_y = position
