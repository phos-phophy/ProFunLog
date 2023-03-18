from typing import Callable

import numpy as np


class RungeKuttaMethod:

    @classmethod
    def solve(cls, x: float, u: np.ndarray, f: Callable[[float, np.ndarray], np.ndarray], h: float) -> np.ndarray:

        k1 = f(x, u)
        k2 = f(x + h / 2, u + h / 2 * k1)
        k3 = f(x + h / 2, u + h / 2 * k2)
        k4 = f(x + h, u + h * k3)

        return u + h * (k1 + 2 * k2 + 2 * k3 + k4) / 6
