from solar_system.src.stars import SolarSystem, ObjectState


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


class ApplicationState(ObjectState):
    def __init__(self):
        self._solar_system = SolarSystem(1000)
        self.simulate = False
        self.scale = SCALE
        self.x_diff = 0
        self.y_diff = 0

    @property
    def solar_system(self):
        return self._solar_system


STATE = ApplicationState()
