from solar_system.src.stars import SolarSystem, ObjectState


class Singleton(type):
    """ A utility metaclass that implements the Singleton pattern by ensuring that only one instance of each subclass is created """
    _instances = {}

    def __call__(cls, *args, **kwargs):
        """ Returns the singleton instance of the class. If it doesn't exist yet, it creates it """
        if cls not in cls._instances:
            cls._instances[cls] = super(Singleton, cls).__call__(*args, **kwargs)
        return cls._instances[cls]


class ApplicationState(ObjectState, metaclass=Singleton):
    """ A base class that stores the complete internal state of the application """

    SCALE = 10 ** 2 * 2 ** 13
    SCALE_DIV = 2
    SCALE_MIN = 10 ** 2

    STEP_SIZE_MAX = 1000
    STEP_SIZE_MIN = 10

    def __init__(self):
        super(ApplicationState, self).__init__()

        self._solar_system: SolarSystem = SolarSystem(self.STEP_SIZE_MAX)
        self.simulate: bool = False
        self.show_names: bool = True
        self.selected_body_cnv: int = 0
        self.selected_body_info: int = 0
        self._scale: int = self.SCALE
        self._x_diff: int = 0
        self._y_diff: int = 0

        self.save_state()

    @property
    def solar_system(self):
        return self._solar_system

    @property
    def scale(self):
        return self._scale

    @property
    def x_diff(self):
        return self._x_diff

    @property
    def y_diff(self):
        return self._y_diff

    def _get_params(self):
        return {'simulate': self.simulate, '_scale': self.scale, '_x_diff': self.x_diff, '_y_diff': self.y_diff}

    def save_state(self) -> None:
        self.solar_system.save_state()
        self._states.append(self._get_params())

    def set_state(self, idx: int) -> None:
        self.solar_system.set_state(idx)
        super(ApplicationState, self).set_state(idx)

    def delete_state(self, idx: int) -> None:
        self.solar_system.delete_state(idx)
        super(ApplicationState, self).delete_state(idx)

    def increase_scale(self):
        self._scale *= self.SCALE_DIV

    def decrease_scale(self):
        self._scale = max(self._scale / self.SCALE_DIV, self.SCALE_MIN)

    def change_x_diff(self, value):
        self._x_diff += value

    def change_y_diff(self, value):
        self._y_diff += value

    def set_selected_body_info(self, v: int):
        self.selected_body_info = v

    def set_selected_body_cnv(self, v: int):
        self.selected_body_cnv = v


STATE = ApplicationState()
