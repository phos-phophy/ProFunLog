from typing import Callable

import numpy as np


class RungeKuttaMethod:

    @classmethod
    def solve(cls, x: float, y: np.ndarray, f: Callable[[float, np.ndarray], np.ndarray], h: float) -> np.ndarray:

        k1 = f(x, y)
        k2 = f(x + h / 2, y + h / 2 * k1)
        k3 = f(x + h / 2, y + h / 2 * k2)
        k4 = f(x + h, y + h * k3)

        return y + h * (k1 + 2 * k2 + 2 * k3 + k4) / 6
