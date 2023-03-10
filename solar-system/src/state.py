from typing import List


class State:
    def __init__(self):
        self._states: List[dict] = []
        self.save_state()

    @property
    def states(self):
        return self._states

    def set_state(self, idx: int) -> None:
        for attr, value in self._states[idx].items():
            self.__setattr__(attr, value)

    def save_state(self) -> None:
        state = self.__dict__
        state.pop('_states')
        self._states.append(state)

    def delete_state(self, idx: int) -> None:
        if idx < len(self._states):
            del self._states[idx]

    def reset(self) -> None:
        self.set_state(0)
