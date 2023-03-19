from typing import Callable

import numpy as np

from solar_system.src.runge_kutta import RungeKuttaMethod
from solar_system.src.stars.celestial import CelestialBody
from solar_system.src.stars.state import State

G = 6.67 * 10 ** (-20)  # 'cause we work with kilometers not meters

SUN = CelestialBody('Sun', 'yellow', 1.98 * 10 ** 30, 695.7 * 10 ** 3, 0, 0, 0, 0)  # https://en.wikipedia.org/wiki/Sun
EARTH = CelestialBody('Earth', 'green', 5.972168 * 10 ** 24, 6371, 152097597, 0, 0, -30.2)  # https://en.wikipedia.org/wiki/Earth


class SolarSystem(State):
    def __init__(self, step_size: float):

        self._star = SUN
        self._planets = [EARTH]

        self._step_size = step_size

        super(SolarSystem, self).__init__()
        del self._states

    @property
    def star(self):
        return self._star

    @property
    def planets(self):
        return self._planets

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
        u = np.hstack([self._star.get_position(), *[planet.get_position() for planet in self.planets]])

        u = RungeKuttaMethod.solve(0, u, self.get_f(), self._step_size)

        self._star.set_position(u[:4])
        for planet_idx, planet in enumerate(self.planets, start=1):
            planet.set_position(u[4 * planet_idx: 4 * planet_idx + 4])

    def get_f(self) -> Callable[[float, np.ndarray], np.ndarray]:

        def f(_: float, u: np.ndarray) -> np.ndarray:
            result = u.copy()
            result[0::4] = u[2::4]
            result[1::4] = u[3::4]

            bodies = [self.star] + self.planets

            dists = [[0] * len(bodies) for _ in range(len(bodies))]
            x_dists = [[0] * len(bodies) for _ in range(len(bodies))]
            y_dists = [[0] * len(bodies) for _ in range(len(bodies))]

            for i, body_1 in enumerate(bodies):
                for j, body_2 in enumerate(bodies[i + 1:], start=i + 1):
                    dists[i][j] = body_1.distance_to(body_2)
                    dists[j][i] = dists[i][j]

                    x_dists[i][j] = (body_2.x - body_1.x)
                    x_dists[j][i] = -x_dists[i][j]

                    y_dists[i][j] = (body_2.y - body_1.y)
                    y_dists[j][i] = -y_dists[i][j]

            x_dists = np.array(x_dists)
            y_dists = np.array(y_dists)
            distances: np.ndarray = np.array(dists) ** 3

            weights = np.array([body.weight for body in bodies])
            matrix = np.divide(G * weights, distances, where=distances != 0)

            result[2::4] = np.sum(matrix * x_dists, axis=1)
            result[3::4] = np.sum(matrix * y_dists, axis=1)

            return result

        return f
