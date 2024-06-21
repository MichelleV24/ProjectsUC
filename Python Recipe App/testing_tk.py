import tkinter as tk

# Initialize the main window
root = tk.Tk()
root.title("Tkinter Test")

# Create a label widget with some text
label = tk.Label(root, text="Tkinter is working!", font=('Helvetica', 16), padx=10, pady=10)

# Pack the label widget into the window
label.pack(expand=True)

# Run the main loop
root.mainloop()
