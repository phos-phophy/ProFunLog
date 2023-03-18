import numpy as np
from celestial import CelestialBody
from solar_system.src.runge_kutta import RungeKuttaMethod
from state import State

G = 6.67 * 10 ** (-11)

SUN = CelestialBody('Sun', 1.98 * 10 ** 30, 695.7 * 10 ** 6, 0, 0, 0, 0)  # https://en.wikipedia.org/wiki/Sun
EARTH = CelestialBody('Earth', 5.972168 * 10 ** 24, 6371 * 10 ** 3, 1, 1, 1, 1)  # https://en.wikipedia.org/wiki/Earth


class SolarSystem(State):
    def __init__(self, step_size: float):

        self._star = SUN
        self._planets = [EARTH]

        self._step_size = step_size

        super(SolarSystem, self).__init__()
        del self._states

    @property
    def states(self):
        planet_states = {planet.name: planet.states for planet in self._planets}
        return {self._star.name: self._star.states, **planet_states}

    def set_state(self, idx: int) -> None:
        self._star.set_state(idx)
        for planet in self._planets:
            planet.set_state(idx)

    def save_state(self) -> None:
        self._star.save_state()
        for planet in self._planets:
            planet.save_state()

    def delete_state(self, idx: int) -> None:
        if idx < len(self._states):
            del self._star._states[idx]
            for planet in self._planets:
                del planet._states[idx]

    def step(self):
        u = np.hstack([self._star.get_position(), *[planet.get_position() for planet in self._planets]])
        u = RungeKuttaMethod.solve(0, u, move_function, self._step_size)

        self._star.set_position(u[:4])
        for planet_idx, planet in enumerate(self._planets, start=1):
            planet.set_position(u[4 * planet_idx: 4 * planet_idx + 4])


def move_function(_: float, u: np.ndarray) -> np.ndarray:
    pass


if __name__ == '__main__':
    system = SolarSystem(10)
    system.step()
