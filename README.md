# libGTK4

**A full-featured GTK4 wrapper for the Nim programming language.**
*Полновесная обёртка для библиотек GTK4 на языке программирования Nim.*

[![Nim](https://img.shields.io/badge/Nim-1.6%2B-ffc200?logo=nim&logoColor=black)](https://nim-lang.org)
[![GTK4](https://img.shields.io/badge/GTK-4.x-4a86cf?logo=gtk&logoColor=white)](https://www.gtk.org)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20Windows-informational)]()
[![License](https://img.shields.io/badge/license-see%20LICENSE-lightgrey)](LICENSE)
[![Docs](https://img.shields.io/badge/docs-EN%20%7C%20RU-blue)](#documentation)

---

## How it looks on Fedora

<p align="center">
  <img src="./images/Screen-01.png" alt="libGTK4 application running on Fedora Linux" width="700">
</p>

## How it looks on Windows

<p align="center">
  <img src="./images/Screen-02.png" alt="libGTK4 application running on Windows 11" width="700">
</p>

---

## What is GTK4?

[GTK4](https://www.gtk.org) is a mature, cross-platform toolkit for building graphical user interfaces, used by GNOME and countless desktop applications on Linux, Windows and macOS. It provides everything a native desktop app needs: a rich widget set (buttons, text entries, lists, trees, menus, dialogs), a scene-graph-based rendering pipeline, CSS-driven theming, an event/signal system built on GLib, drag-and-drop, accessibility support, and integration with Cairo for custom drawing. It's the toolkit behind applications like GIMP, Inkscape, and the entire GNOME desktop environment.

## What libGTK4 gives you

libGTK4 exposes this toolkit to Nim as a thin, idiomatic wrapper, so you can build native desktop GUIs without leaving the Nim ecosystem. It currently covers:

- **Core API** — application/window lifecycle, object system fundamentals, GLib main loop integration
- **Basic controls** — buttons, checkboxes, switches, sliders and other everyday widgets
- **Text input & multiline text** — entries, text views, and buffer manipulation
- **Numeric & choice widgets** — spin buttons, combo boxes, dropdowns
- **Multiview containers** — notebooks, stacks, paned views for organizing complex layouts
- **Display widgets** — labels, images, progress bars, and other read-only widgets
- **Drawing, style & GLib** — Cairo-based custom drawing on `GtkDrawingArea`, CSS styling, GLib utilities
- **Popups & auxiliary widgets** — popovers, tooltips, and other transient UI
- **Window chrome & dialogs** — header bars, file choosers, message dialogs
- **Bars & misc widgets** — toolbars, status bars, and related components
- **Signals** — a full reference for GTK4's signal system, plus a dedicated guide to mouse and keyboard signal handling

Every reference document is available in both English and Russian (see [Documentation](#documentation) below), and older material is preserved in [`docs/archive/`](docs/archive) for historical reference.

On top of the widget wrapper, the [examples](#examples) demonstrate real application patterns: multi-module app structure, JSON-driven runtime menu/shortcut construction, file I/O with dialogs, Cairo drawing with drag gestures, a GLib-timer-driven simulation (Conway's Game of Life), and packaging a portable build for Windows with bundled libraries.

---

## Installation

```bash
nimble install https://github.com/Balans097/libGTK4
```

## Quick Start

```nim
import libGTK4

# Minimal window with a button — see Test_1_Hello_world.nim for the full example
```

See [`examples/Test_1_Hello_world.nim`](examples/Test_1_Hello_world.nim) for a complete, runnable "Hello, World!".

---

## Documentation

The reference is organized by widget category, each available in English and Russian.

| Topic | English | Russian |
|---|---|---|
| Core API | [EN](docs/gtk4_core_reference_en.md) | [RU](docs/gtk4_core_reference_ru.md) |
| Basic Controls | [EN](docs/gtk4_basic_controls_reference_en.md) | [RU](docs/gtk4_basic_controls_reference_ru.md) |
| Text Input | [EN](docs/gtk4_text_input_reference_en.md) | [RU](docs/gtk4_text_input_reference_ru.md) |
| Multiline Text | [EN](docs/gtk4_multiline_text_reference_en.md) | [RU](docs/gtk4_multiline_text_reference_ru.md) |
| Numeric Choice | [EN](docs/gtk4_numeric_choice_reference_en.md) | [RU](docs/gtk4_numeric_choice_reference_ru.md) |
| Multiview Containers | [EN](docs/gtk4_multiview_containers_reference_en.md) | [RU](docs/gtk4_multiview_containers_reference_ru.md) |
| Display Widgets | [EN](docs/gtk4_display_widgets_reference_en.md) | [RU](docs/gtk4_display_widgets_reference_ru.md) |
| Drawing, Style & GLib | [EN](docs/gtk4_drawing_style_glib_reference_en.md) | [RU](docs/gtk4_drawing_style_glib_reference_ru.md) |
| Popups & Auxiliary | [EN](docs/gtk4_popups_auxiliary_reference_en.md) | [RU](docs/gtk4_popups_auxiliary_reference_ru.md) |
| Window Chrome & Dialogs | [EN](docs/gtk4_window_chrome_dialogs_reference_en.md) | [RU](docs/gtk4_window_chrome_dialogs_reference_ru.md) |
| Bars & Misc | — | [RU](docs/gtk4_bars_misc_reference_ru.md) |
| Signals | [EN](<docs/Signals in GTK4.md>) | [RU](<docs/Сигналы GTK4.md>) |
| Mouse & Keyboard Signals | [EN](docs/Mouse_and_Keyboard_Signals.md) | [RU](<docs/Сигналы мыши и клавиатуры.md>) |

Older, superseded reference material is kept for history in [`docs/archive/`](docs/archive).

> The documentation is a work in progress and will keep expanding.

---

## Examples

Complete, runnable examples live in [`examples/`](examples):

| Example | Description |
|---|---|
| [Test_1_Hello_world.nim](examples/Test_1_Hello_world.nim) | Minimal "Hello, World!" window with a button click handler |
| [Test_2_Text_editor.nim](examples/Test_2_Text_editor.nim) | Text editor with a header bar, Open/Save buttons and a file chooser dialog |
| [Test_3_Calculator.nim](examples/Test_3_Calculator.nim) | Four-operation calculator with a running display |
| [Test_4_Drawing.nim](examples/Test_4_Drawing.nim) | Freehand drawing on a `GtkDrawingArea` using a Cairo context and drag gestures |
| [Test_5_App.nim](examples/Test_5_App.nim) | Conway's Game of Life on a toroidal grid — click to toggle cells, Start/Stop/Step/Randomize/Clear controls, GLib timer-driven simulation |
| [Calculator/](examples/Calculator) | Addition calculator, built as a standalone binary |
| [GUI-0/](examples/GUI-0) | Toolbar/status bar demo with a text view, progress bar and custom CSS styling |
| [GUI-1/](examples/GUI-1) | Freehand drawing test using drag gestures and a Cairo context |
| [GUI-2/](examples/GUI-2) | Text editor split into modules (entry point, GUI layout, app state, actions/file I/O) — demonstrates structuring a larger app |
| [MenuApp/](examples/MenuApp) | Application menu and keyboard shortcuts built at runtime from a JSON menu definition |
| [Portable GUI for Windows/](<examples/Portable GUI for Windows>) | Calculator packaged as a portable Windows build, with a launcher that adds the bundled `libs/` directory to `PATH` |

---

## Reference Application

[`examples/ReferenceApp/`](examples/ReferenceApp) is the flagship, most complete example — a full desktop application split into dedicated modules:

| Module | Responsibility |
|---|---|
| [main.nim](examples/ReferenceApp/main.nim) | Application entry point |
| [gui.nim](examples/ReferenceApp/gui.nim) | GUI layout and widget construction |
| [config.nim](examples/ReferenceApp/config.nim) | Application configuration |
| [dialogs.nim](examples/ReferenceApp/dialogs.nim) | Dialog windows |
| [docmodel.nim](examples/ReferenceApp/docmodel.nim) | Document/data model |
| [fileio.nim](examples/ReferenceApp/fileio.nim) | File loading and saving |
| [i18n.nim](examples/ReferenceApp/i18n.nim) | Internationalization/localization |
| [actions.nim](examples/ReferenceApp/actions.nim) | Application actions |

See [`examples/ReferenceApp/README.md`](examples/ReferenceApp/README.md) for details. A packaged copy is also available as [`examples/ReferenceApp.7z`](examples/ReferenceApp.7z).

---

## License

See [LICENSE](LICENSE) for details.
