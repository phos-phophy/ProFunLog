import tkinter as tk


class CometFrame(tk.Frame):
    def __init__(self, master, row, column, sticky):
        super(CometFrame, self).__init__(master=master, relief=tk.SUNKEN, borderwidth=3)

        self.rowconfigure(index=0, minsize=30, weight=1)
        self.rowconfigure(index=1, minsize=30, weight=1)
        self.rowconfigure(index=2, minsize=30, weight=1)
        self.rowconfigure(index=3, minsize=30, weight=1)
        self.rowconfigure(index=4, minsize=180, weight=1)

        self.columnconfigure(index=0, minsize=100, weight=1)
        self.columnconfigure(index=1, minsize=150, weight=1)
        self.columnconfigure(index=2, minsize=50, weight=1)

        self.grid(row=row, column=column, sticky=sticky)

        tk.Label(master=self, text='Запуск кометы', font='bold').grid(row=0, column=0, columnspan=3)
        tk.Label(master=self, text='Масса').grid(row=1, column=0, sticky='e')
        tk.Label(master=self, text='Диаметр').grid(row=2, column=0, sticky='e')
        tk.Label(master=self, text='Скорость').grid(row=3, column=0, sticky='e')

        tk.Entry(master=self).grid(row=1, column=1, sticky='ew')
        tk.Entry(master=self).grid(row=2, column=1, sticky='ew')
        tk.Entry(master=self).grid(row=3, column=1, sticky='ew')

        tk.Label(master=self, text='кг').grid(row=1, column=2, sticky='w')
        tk.Label(master=self, text='км').grid(row=2, column=2, sticky='w')
        tk.Label(master=self, text='км/с').grid(row=3, column=2, sticky='w')