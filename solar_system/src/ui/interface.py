from solar_system.src.ui.abstract import AbstractGUI
from solar_system.src.ui.app_state import STATE
from solar_system.src.ui.buttons import ButtonsFrame
from solar_system.src.ui.info import InformationFrame
from solar_system.src.ui.canvas import Canvas
from solar_system.src.ui.comet import CometFrame

DELAY = 1

MOVE_X = 3
MOVE_Y = 3


class SolarGUI(AbstractGUI):
    def __init__(self):
        super(SolarGUI, self).__init__()

        self._configure_main_window()

        self._cnv = Canvas(self, 0, 0, 'news', 3, 2)
        self._info = InformationFrame(self, 1, 1, 'news')
        self._frm_comet = CometFrame(self, 0, 1, 'news')
        self._buttons_frame = ButtonsFrame(self, 2, 1, 'news')

        self._cnv.draw()
        self._info.update_info()

    def _configure_main_window(self):
        self.title('Solar system')

        self.rowconfigure(index=0, minsize=300, weight=1)
        self.rowconfigure(index=1, minsize=250, weight=1)
        self.rowconfigure(index=2, minsize=100, weight=0)

        self.columnconfigure(index=0, minsize=800, weight=1)
        self.columnconfigure(index=1, minsize=300, weight=0)

    def draw(self):
        self._cnv.draw()

    def on_timer(self):
        if STATE.simulate:
            STATE.solar_system.step()
            self._info.update_info()
            self._cnv.draw()
            self.after(DELAY, self.on_timer)

    def get_comet_coordinates(self, x: float, y: float):
        self._frm_comet.get_coordinates(x, y)
