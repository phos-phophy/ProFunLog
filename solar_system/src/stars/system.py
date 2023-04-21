from typing import Callable

import numpy as np

from solar_system.src.runge_kutta import RungeKuttaMethod
from solar_system.src.stars.celestial import CelestialBody
from solar_system.src.stars.state import ObjectState

G = 6.67 * 10 ** (-20)  # 'cause we work with kilometers not meters

# For more details about the planets, please refer to https://nssdc.gsfc.nasa.gov/planetary/factsheet/marsfact.html

SUN = CelestialBody('Sun', 'yellow', 1.98 * 10 ** 30, 695.7 * 10 ** 3, 0, 0, 0, 0)  # https://en.wikipedia.org/wiki/Sun
MERCURY = CelestialBody('Mercury', 'grey', 0.33 * 10 ** 24, 2439, 47796525, -17396512, -18.27, -50.21)
VENUS = CelestialBody('Venus', 'white', 4.87 * 10 ** 24, 6052, 0, -107712000, -35.19, 0)

EARTH = CelestialBody('Earth', 'green', 5.972168 * 10 ** 24, 6371, 152097597, 0, 0, -29.78)  # https://en.wikipedia.org/wiki/Earth
MOON = CelestialBody('Moon', 'white', 0.073 * 10 ** 24, 1738, 152503097, 0, 0, -30.78)

MARS = CelestialBody('Mars', 'red', 6.42 * 10 ** 23, 3390, 249232000, 0, 0, -21.97)  # https://en.wikipedia.org/wiki/Mars
PHOBOS = CelestialBody('Phobos', 'white', 1.072 * 10 ** 16, 11, 249241376, 0, 0, -24.1)
DEIMOS = CelestialBody('Deimos', 'white', 1.4762 * 10 ** 15, 6, 249208538, 0, 0, -20.6187)

JUPITER = CelestialBody('Jupiter', 'orange', 1.8982 * 10 ** 27, 71492, -740595000, 0, 0, 13.72)  # https://en.wikipedia.org/wiki/Jupiter
SATURN = CelestialBody('Saturn', '#F5F5DC', 5.6834 * 10 ** 26, 58232, 0, -1506527000, -9.14, 0)  # https://en.wikipedia.org/wiki/Saturn
URANUS = CelestialBody('Uranus', 'blue', 86.811 * 10 ** 24, 25559, 0, 2732696000, 7.13, 0)  # https://en.wikipedia.org/wiki/Uranus
NEPTUNE = CelestialBody('Neptune', '#00008B', 102.409 * 10 ** 24, 24764, 0, 4471050000, 5.47, 0)  # https://en.wikipedia.org/wiki/Neptune


class SolarSystem(ObjectState):
    """ A base class that describes our Solar system with all planets """

    def __init__(self, step_size: float):

        super(SolarSystem, self).__init__()
        del self._states

        self._step_size = step_size
        self._prev_bodies = []
        self._g_weights = 0

        self._star = SUN
        self._planets = [MERCURY, VENUS, EARTH, MOON, MARS, PHOBOS, DEIMOS, JUPITER, SATURN, URANUS, NEPTUNE]
        self._comets = []

    @property
    def step_size(self):
        """ Returns a size of the simulating step """
        return self._step_size

    @property
    def star(self):
        """ Returns a system's star """
        return self._star

    @property
    def planets(self):
        """ Returns a list of solar system's planets """
        return self._planets

    @property
    def comets(self):
        """ Returns a list of solar system's comets """
        return self._comets

    @property
    def bodies(self):
        """ Returns a list of all solar system's celestial bodies """
        return [self.star] + self.planets + self.comets

    @property
    def states(self):
        """ Returns a list of the solar system's versions """
        planet_states = {planet.name: planet.states for planet in self._planets}
        return {self._star.name: self._star.states, **planet_states}

    @property
    def g_weights(self):
        """ Returns a list of (G * body.weight) values """
        if self.bodies != self._prev_bodies:
            self._prev_bodies = self.bodies
            self._g_weights = G * np.array([body.weight for body in self.bodies])
        return self._g_weights

    @step_size.setter
    def step_size(self, val: float):
        """ Sets a size of the simulating step """
        self._step_size = val

    def set_state(self, idx: int) -> None:
        """ Checkouts to the specified version of the solar system """
        for body in self.bodies:
            body.set_state(idx)

    def save_state(self) -> None:
        """ Saves the current state of the solar system """
        for body in self.bodies:
            body.save_state()

    def delete_state(self, idx: int) -> None:
        """ Deletes the specified version of the solar system """
        for body in self.bodies:
            body.delete_state(idx)

    def add_comet(self, name: str, color: str, weight: int, radius: int, x: float, y: float, speed_x: float, speed_y: float):
        """ Adds new comet in the solar system """
        comet = CelestialBody(name, color, weight, radius, x, y, speed_x, speed_y)
        self._comets.append(comet)

    def step(self):
        """ Calculates new positions and  velocities of system's celestial bodies based on previous values """

        u = np.hstack([body.get_position() for body in self.bodies])

        u = RungeKuttaMethod.solve_4(0, u, self._get_f(), self._step_size)

        self._star.set_position(u[:4])

        bodies = self.bodies[1:]
        for body_idx, body in enumerate(bodies, start=1):
            body.set_position(u[4 * body_idx: 4 * body_idx + 4])

    # check theory.ipynb for detailed information
    def _get_f(self) -> Callable[[float, np.ndarray], np.ndarray]:
        """ Returns a derivative of the function u """

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
