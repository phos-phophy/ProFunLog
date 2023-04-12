from copy import deepcopy
from typing import List


class ObjectState:
    """ A base class that implements an idea of the object versions by managing its states """
    def __init__(self):
        self._states: List[dict] = []

    @property
    def states(self):
        """ Returns a list of the object's versions """
        return self._states

    def set_state(self, idx: int) -> None:
        """ Checkouts to the specified version of the object """
        if idx < len(self._states):
            self.__dict__.update(self._states[idx])

    def save_state(self) -> None:
        """ Saves the current state of the object """
        state = deepcopy(self.__dict__)
        state.pop('_states')
        self._states.append(state)

    def delete_state(self, idx: int) -> None:
        """ Deletes the specified version of the object """
        if idx < len(self._states):
            del self._states[idx]

    def reset(self) -> None:
        """ Checkouts to the default (init) version og the object """
        self.set_state(0)
