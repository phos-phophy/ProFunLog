from solar_system.src.stars import SolarSystem, ObjectState


class ApplicationState(ObjectState):
    SCALE = 10 ** 6
    SCALE_CHANGE = 10 ** 4
    SCALE_MIN = 10 ** 4

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
        self._scale += self.SCALE_CHANGE

    def decrease_scale(self):
        self._scale = max(self._scale - self.SCALE_CHANGE, self.SCALE_MIN)

    def change_x_diff(self, value):
        self._x_diff += value

    def change_y_diff(self, value):
        self._y_diff += value

    def set_selected_body_info(self, v: int):
        self.selected_body_info = v

    def set_selected_body_cnv(self, v: int):
        self.selected_body_cnv = v


STATE = ApplicationState()
