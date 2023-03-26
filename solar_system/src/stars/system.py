from typing import Callable

import numpy as np

from solar_system.src.runge_kutta import RungeKuttaMethod
from solar_system.src.stars.celestial import CelestialBody
from solar_system.src.stars.state import ObjectState

G = 6.67 * 10 ** (-20)  # 'cause we work with kilometers not meters

SUN = CelestialBody('Sun', 'yellow', 1.98 * 10 ** 30, 695.7 * 10 ** 3, 0, 0, 0, 0)  # https://en.wikipedia.org/wiki/Sun
MERCURY = CelestialBody('Mercury', 'grey', 0.33 * 10 ** 24, 2439, 47796525, -17396512, -18.27, -50.21)
VENUS = CelestialBody('Venus', 'white', 4.87 * 10 ** 24, 6052, 0, -107712000, -35.19, 0)
EARTH = CelestialBody('Earth', 'green', 5.972168 * 10 ** 24, 6371, 152097597, 0, 0, -30.2)  # https://en.wikipedia.org/wiki/Earth
MOON = CelestialBody('Moon', 'white', 0.073 * 10 ** 24, 1738, 152503097, 0, 0, -31.2)
# JUST = CelestialBody('Just', 'red', 5.972168 * 10 ** 24, 3000, 102097597, 0, -4, -3.2)


class SolarSystem(ObjectState):
    def __init__(self, step_size: float):

        super(SolarSystem, self).__init__()
        del self._states

        self._step_size = step_size
        self._prev_bodies = []
        self._g_weights = 0

        self._star = SUN
        self._planets = [MERCURY, VENUS, EARTH, MOON]
        self._comets = []

    @property
    def star(self):
        return self._star

    @property
    def planets(self):
        return self._planets

    @property
    def comets(self):
        return self._comets

    @property
    def bodies(self):
        return [self.star] + self.planets + self.comets

    @property
    def states(self):
        planet_states = {planet.name: planet.states for planet in self._planets}
        return {self._star.name: self._star.states, **planet_states}

    @property
    def g_weights(self):
        if self.bodies != self._prev_bodies:
            self._prev_bodies = self.bodies
            self._g_weights = G * np.array([body.weight for body in self.bodies])
        return self._g_weights

    def set_state(self, idx: int) -> None:
        for body in self.bodies:
            body.set_state(idx)

    def save_state(self) -> None:
        for body in self.bodies:
            body.save_state()

    def delete_state(self, idx: int) -> None:
        for body in self.bodies:
            body.delete_state(idx)

    def add_comet(self, comet: CelestialBody):
        self._comets.append(comet)

    def step(self):
        u = np.hstack([body.get_position() for body in self.bodies])

        u = RungeKuttaMethod.solve_4(0, u, self._get_f(), self._step_size)

        self._star.set_position(u[:4])

        bodies = self.bodies[1:]
        for body_idx, body in enumerate(bodies, start=1):
            body.set_position(u[4 * body_idx: 4 * body_idx + 4])

    def _get_f(self) -> Callable[[float, np.ndarray], np.ndarray]:

        def f(_: float, u: np.ndarray) -> np.ndarray:
            result = u.copy()
            result[0::4] = u[2::4]
            result[1::4] = u[3::4]

            x_pos = u[0::4]
            y_pos = u[1::4]
            pos = np.stack([x_pos, y_pos], axis=1)

            x_dists = x_pos[None, :] - x_pos[:, None]
            y_dists = y_pos[None, :] - y_pos[:, None]
            distances = np.linalg.norm(pos[:, None, :] - pos[None, :, :], axis=-1) ** 3

            matrix = np.divide(self.g_weights, distances, where=distances != 0)

            result[2::4] = np.sum(matrix * x_dists, axis=1)
            result[3::4] = np.sum(matrix * y_dists, axis=1)

            return result

        return f
