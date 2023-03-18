from .state import State


class CelestialBody(State):
    def __init__(self, weight, radius, x, y, speed_x, speed_y):
        self._weight = weight
        self._radius = radius
        self.x = x
        self.y = y
        self.speed_x = speed_x
        self.speed_y = speed_y

        super(CelestialBody, self).__init__()

    @property
    def weight(self):
        return self._weight

    @property
    def radius(self):
        return self._radius
