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
- [GTK4 Signals (Russian)](<docs/Сигналы GTK4.md>)
- [Mouse and Keyboard Signals (Russian)](<docs/Сигналы мыши и клавиатуры.md>)

The documentation is a work in progress and will keep expanding.

## Examples

The `examples/` directory contains complete, runnable examples demonstrating various widgets and features:

- [`Test_1_Hello_world.nim`](examples/Test_1_Hello_world.nim) — minimal "Hello, World!" window
- [`Test_2_Text_editor.nim`](examples/Test_2_Text_editor.nim) — simple text editor
- [`Test_3_Calculator.nim`](examples/Test_3_Calculator.nim) — basic calculator
- [`Test_4_Drawing.nim`](examples/Test_4_Drawing.nim) — drawing/canvas widget
- [`Test_5_App.nim`](examples/Test_5_App.nim) — small full application example
- [`Calculator/`](examples/Calculator) — calculator app with a standalone build
- [`GUI-0/`](examples/GUI-0) — general widget/GUI test
- [`GUI-1/`](examples/GUI-1) — general widget/GUI test
- [`GUI-2/`](examples/GUI-2) — GUI example with actions and a menu
- [`MenuApp/`](examples/MenuApp) — application menu built from a JSON menu definition
- [`Portable GUI for Windows/`](<examples/Portable GUI for Windows>) — self-contained portable build for Windows (with bundled libraries and screenshots)
