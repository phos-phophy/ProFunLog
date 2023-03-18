from .state import State


class CelestialBody(State):
    def __init__(self, name: str, weight: int, radius: int, x: float, y: float, speed_x: float, speed_y: float):
        self._name = name
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
    def weight(self):
        return self._weight

    @property
    def radius(self):
        return self._radius
