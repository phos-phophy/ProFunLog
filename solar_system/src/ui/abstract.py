import tkinter as tk
from abc import abstractmethod


class AbstractGUI(tk.Tk, tk.Misc):

    @abstractmethod
    def get_comet_coordinates(self, x: float, y: float):
        pass

    @abstractmethod
    def draw(self):
        pass

    @abstractmethod
    def on_timer(self):
        pass
