from typing import Callable

import numpy as np


class RungeKuttaMethod:
    """ A utility class that solves a system of first-degree differential equations u`(x) = f(x, u(x)). It's used by `SolarSystem` to solve
    the equations of the `CelestialBody`'s motion """

    @classmethod
    def solve_2(cls, x: float, u: np.ndarray, f: Callable[[float, np.ndarray], np.ndarray], h: float) -> np.ndarray:
        """ Solves a system of first-degree differential equations u`(x) = f(x, u(x)) by RK2

        :param x: A given parameter value
        :param u: A given function
        :param f: A derivative of the function u
        :param h: A step size
        :return: A function value at point x + h
        """

        k1 = f(x, u)
        k2 = f(x + h, u + h * k1)

        return u + h * (k1 + k2) / 2

    @classmethod
    def solve_4(cls, x: float, u: np.ndarray, f: Callable[[float, np.ndarray], np.ndarray], h: float) -> np.ndarray:
        """ Solves a system of first-degree differential equations u`(x) = f(x, u(x)) by RK4

        :param x: A given parameter value
        :param u: A given function
        :param f: A derivative of the function u
        :param h: A step size
        :return: A function value at point x + h
        """

        k1 = f(x, u)
        k2 = f(x + h / 2, u + h / 2 * k1)
        k3 = f(x + h / 2, u + h / 2 * k2)
        k4 = f(x + h, u + h * k3)

        return u + h * (k1 + 2 * k2 + 2 * k3 + k4) / 6
