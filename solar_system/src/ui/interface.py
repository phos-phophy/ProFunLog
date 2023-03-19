import tkinter as tk


def get_main_window():
    main_window = tk.Tk()
    main_window.title('Solar system')

    main_window.rowconfigure(index=0, minsize=300, weight=1)
    main_window.rowconfigure(index=1, minsize=300, weight=1)
    main_window.rowconfigure(index=2, minsize=50, weight=0)

    main_window.columnconfigure(index=0, minsize=800, weight=1)
    main_window.columnconfigure(index=1, minsize=300, weight=0)

    return main_window


def set_comet_frame(main_window):
    frm_comet = tk.Frame(master=main_window, relief=tk.SUNKEN, borderwidth=3)

    frm_comet.rowconfigure(index=0, minsize=50, weight=1)
    frm_comet.rowconfigure(index=1, minsize=50, weight=1)
    frm_comet.rowconfigure(index=2, minsize=50, weight=1)
    frm_comet.rowconfigure(index=3, minsize=50, weight=1)
    frm_comet.rowconfigure(index=4, minsize=50, weight=1)

    frm_comet.columnconfigure(index=0, minsize=100, weight=1)
    frm_comet.columnconfigure(index=1, minsize=150, weight=1)
    frm_comet.columnconfigure(index=2, minsize=50, weight=1)

    frm_comet.grid(row=0, column=1, sticky='news')

    tk.Label(master=frm_comet, text='Запуск кометы', font='bold').grid(row=0, column=0, columnspan=3)
    tk.Label(master=frm_comet, text='Масса').grid(row=1, column=0, sticky='e')
    tk.Label(master=frm_comet, text='Диаметр').grid(row=2, column=0, sticky='e')
    tk.Label(master=frm_comet, text='Скорость').grid(row=3, column=0, sticky='e')

    tk.Entry(master=frm_comet).grid(row=1, column=1, sticky='ew')
    tk.Entry(master=frm_comet).grid(row=2, column=1, sticky='ew')
    tk.Entry(master=frm_comet).grid(row=3, column=1, sticky='ew')

    tk.Label(master=frm_comet, text='кг').grid(row=1, column=2, sticky='w')
    tk.Label(master=frm_comet, text='км').grid(row=2, column=2, sticky='w')
    tk.Label(master=frm_comet, text='км/с').grid(row=3, column=2, sticky='w')


def set_satellite_frame(main_window):
    frm_satellite = tk.Frame(master=main_window, relief=tk.SUNKEN, borderwidth=3)

    frm_satellite.rowconfigure(index=0, minsize=50, weight=1)
    frm_satellite.rowconfigure(index=1, minsize=50, weight=1)
    frm_satellite.rowconfigure(index=2, minsize=50, weight=1)
    frm_satellite.rowconfigure(index=3, minsize=50, weight=1)
    frm_satellite.rowconfigure(index=4, minsize=50, weight=1)

    frm_satellite.columnconfigure(index=0, minsize=100, weight=1)
    frm_satellite.columnconfigure(index=1, minsize=150, weight=1)
    frm_satellite.columnconfigure(index=2, minsize=50, weight=1)

    frm_satellite.grid(row=1, column=1, sticky='news')

    tk.Label(master=frm_satellite, text='Запуск спутника', font='bold').grid(row=0, column=0, columnspan=3)
    tk.Label(master=frm_satellite, text='Масса').grid(row=1, column=0, sticky='e')
    tk.Label(master=frm_satellite, text='Диаметр').grid(row=2, column=0, sticky='e')
    tk.Label(master=frm_satellite, text='Скорость').grid(row=3, column=0, sticky='e')

    tk.Entry(master=frm_satellite).grid(row=1, column=1, sticky='ew')
    tk.Entry(master=frm_satellite).grid(row=2, column=1, sticky='ew')
    tk.Entry(master=frm_satellite).grid(row=3, column=1, sticky='ew')

    tk.Label(master=frm_satellite, text='кг').grid(row=1, column=2, sticky='w')
    tk.Label(master=frm_satellite, text='км').grid(row=2, column=2, sticky='w')
    tk.Label(master=frm_satellite, text='км/с').grid(row=3, column=2, sticky='w')


def set_button_frame(main_window):
    frm_button = tk.Frame(master=main_window, relief=tk.RAISED, borderwidth=2)

    frm_button.columnconfigure(index=0, minsize=100, weight=1)
    frm_button.columnconfigure(index=1, minsize=100, weight=1)
    frm_button.columnconfigure(index=2, minsize=100, weight=1)

    frm_button.rowconfigure(index=0, minsize=50, weight=1)

    frm_button.grid(row=2, column=1, sticky='news')

    tk.Button(master=frm_button, text='Начать').grid(row=0, column=0, sticky='news')
    tk.Button(master=frm_button, text='Остановить').grid(row=0, column=1, sticky='news')
    tk.Button(master=frm_button, text='Сбросить').grid(row=0, column=2, sticky='news')


if __name__ == '__main__':
    window = get_main_window()

    set_comet_frame(window)
    set_satellite_frame(window)
    set_button_frame(window)

    window.mainloop()
