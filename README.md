# libGTK4
A full-featured wrapper for the GTK4 library in the Nim programming language

Полновесная обёртка для библиотек GTK4 на языке программирования Nim.


## How it looks on Fedora Linux
![How it looks on Fedora Linux](./images/Screen-01.png)

## How it looks on Windows 11
![How it looks on Windows](./images/Screen-02.png)


## Usage
`nimble install https://github.com/Balans097/libGTK4`


## Documentation

- [API Reference (English)](docs/gtk4_core_reference_en.md)
- [API Reference (Russian)](docs/gtk4_core_reference_ru.md)
- [Basic Controls Reference (Russian)](docs/gtk4_basic_controls_reference_ru.md)
- [Text Input Reference (Russian)](docs/gtk4_text_input_reference_ru.md)
- [Multiline Text Reference (Russian)](docs/gtk4_multiline_text_reference_ru.md)
- [GTK4 Signals (Russian)](<docs/Сигналы GTK4.md>)
- [Mouse and Keyboard Signals (Russian)](<docs/Сигналы мыши и клавиатуры.md>)

The documentation is a work in progress and will keep expanding.

## Examples

The `examples/` directory contains complete, runnable examples demonstrating various widgets and features:

- [`Test_1_Hello_world.nim`](examples/Test_1_Hello_world.nim) — minimal "Hello, World!" window with a button click handler
- [`Test_2_Text_editor.nim`](examples/Test_2_Text_editor.nim) — text editor with a header bar, Open/Save buttons and a file chooser dialog
- [`Test_3_Calculator.nim`](examples/Test_3_Calculator.nim) — four-operation calculator with a running display
- [`Test_4_Drawing.nim`](examples/Test_4_Drawing.nim) — freehand drawing on a `GtkDrawingArea` using a Cairo context and drag gestures
- [`Test_5_App.nim`](examples/Test_5_App.nim) — placeholder, not implemented yet
- [`Calculator/`](examples/Calculator) — addition calculator, built as a standalone binary
- [`GUI-0/`](examples/GUI-0) — toolbar/status bar demo with a text view, progress bar and custom CSS styling
- [`GUI-1/`](examples/GUI-1) — freehand drawing test using drag gestures and a Cairo context
- [`GUI-2/`](examples/GUI-2) — text editor split into modules (entry point, GUI layout, app state and actions/file I/O) to demonstrate structuring a larger app
- [`MenuApp/`](examples/MenuApp) — application menu and keyboard shortcuts built at runtime from a JSON menu definition
- [`Portable GUI for Windows/`](<examples/Portable GUI for Windows>) — calculator packaged as a portable Windows build, with a launcher that adds the bundled `libs/` directory to `PATH`
