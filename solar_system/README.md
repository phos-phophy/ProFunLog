# Solar System

It's a simple simulator of Solar system with all planets and some of their satellites

---

## 1. How to use?

### 1.1 Create a virtual environment

`python3 -m venv ./venv`

### 1.2 Install the requirements

`pip install -r requirements.txt`

### 1.3 Run the simulator

`python3 src/main.py`

## 2. Class diagram

### 2.1 Celestial bodies, application state and Runge-Kutta method

* `ObjectState` - a base class that implements an idea of the object versions by managing its states
* `CelestialBody` - a base class for all celestial bodies
* `SolarSystem` - a base class that describes our Solar system with all planets and implements the `step` method to simulate it 
* `RungeKuttaMethod` - a utility class that solves a system of first-degree differential equations. It's used by `SolarSystem` to solve 
the equations of the `CelestialBody`'s motion
* `ApplicationState` - a base class that stores the complete internal state of the application

```mermaid
classDiagram
direction TB

    class ObjectState {
        +states: List[dict]
        +set_state(self, idx: int)
        +save_state(self)
        +delete_state(self, idx: int)
        +reset(self)
    }
    
    ObjectState <|-- CelestialBody
    
    class CelestialBody {
        +name: str
        +color: str
        +weight: int
        +radius: int
        +x: float
        +y: float
        +speed_x: float
        +speed_y: float
        +get_position(self)  np ndarray
        +set_position(self, position: np.ndarray)
    }
    
    ObjectState <|-- SolarSystem
    CelestialBody --o SolarSystem
    RungeKuttaMethod ..> SolarSystem
    
    class SolarSystem {
        +step_size: float
        +star: CelestialBody
        +planets: List[CelestialBody]
        +comets: List[CelestialBody]
        +bodies: List[CelestialBody]
        +step(self)
        #_get_f(self)
    }
    
    class RungeKuttaMethod{
        +solve_2(cls, x: float, u: np.ndarray, f: Callable, h: float) np ndarray
        +solve_4(cls, x: float, u: np.ndarray, f: Callable, h: float) np ndarray
    }
    
    ObjectState <|-- ApplicationState
    SolarSystem --o ApplicationState
    
    class ApplicationState{
        +solar_system: SolarSystem
        +simulate: bool
        +show_names: bool
        +selected_body_cnv: int
        +selected_body_info: int
        +scale: int
        +x_diff: int
        +y_diff: int
        #_get_params(self)
        +increase_scale(self)
        +decrease_scale(self)
        +change_x_diff(self)
        +change_y_diff(self)
        +set_selected_body_info(self, v: int)
        +set_selected_body_cnv(self, v: int)
    }
```

### 2.2 Interface

* `AbstractGUI` - an abstract class that describes basic methods for 
* `SolarGUI` - a base class that describes the application interface
* `CometFrame` - a utility class that implements an interface to launch comets
* `ButtonsFrame` - a utility class that implements an interface for basic buttons
* `InformationFrame` - a utility class that implements an interface to show a `CelestualBody`'s information
* `Canvas` - a utility class that displays our Solar system 

Almost all of these classes (except the `AbstractGUI`) use a single global instance of the `ApplicationState` class. In addition, 
`InformationFrame` and `Canvas` classes use an instances of the `CelestialBody` class. 

```mermaid
classDiagram
direction TB

    class AbstractGUI{
        <<Abstract>>
        +get_comet_coordinates(self, x: float, y: float)
        +draw(self)
        +on_timer(self)
    }
    
    AbstractGUI <|-- SolarGUI
    
    class SolarGUI{
        #_cnv: Canvas
        #_frm_info: InformationFrame
        #_frm_comet: CometFrame
        #_frm_buttons: ButtonsFrame
        #_configure_main_window(self)
    }
    
    SolarGUI -- CometFrame
    SolarGUI -- ButtonsFrame
    SolarGUI -- InformationFrame
    SolarGUI -- Canvas
    
    class CometFrame{
        #_configure_grid(self)
        #_add_interface(self)
        #_add_button(self)
        #_add_info_interface(self)
        #_add_speed_interface(self)
        #_add_position_interface(self)
        #_add_celectial_body(self)
        #_delete_text(self)
        +get_coordinates(self, x: float, y: float)
    }
    
     class ButtonsFrame{
        +master: AbstractGUI
        #_configure_grid(self)
        #_add_buttons(self)
        #_add_time_controller(self)
        #_start(self)
        #_stop(self)
        #_reset(self)
        #_increase_scale(self)
        #_decrease_scale(self)
        #_change_step(val)
    }
    
    class InformationFrame{
        #_configure_grid(self)
        #_configure_info(self)
        +update_info(self)
    }
    
    class Canvas{
        +master: AbstractGUI
        #_drawn_bodies_ids: dict
        #_drawn_names_ids: dict
        #_drawn_bodies_coordinates: dict
        #_e: tk.Event
        #_configure_submenu(self)
        #_get_body_coordinates(body: CelestialBody, w_center: int, h_center: int)
        #_get_center_coordinates(self)
        +draw(self)
        #_draw_body(self, body: CelestialBody, w_center: int, h_center: int)
        #_move_camera(self, e: tk.Event)
        #_focus_to_canvas(self, _)
    }
    
    SolarGUI <.. ApplicationSTATE
    CometFrame <.. ApplicationSTATE
    ButtonsFrame <.. ApplicationSTATE
    InformationFrame <.. ApplicationSTATE
    Canvas <.. ApplicationSTATE
    
    InformationFrame <.. CelestialBody
    Canvas <.. CelestialBody
```
