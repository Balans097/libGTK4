# libGTK4

**Полновесная обёртка библиотек GTK4 для языка программирования Nim.**
*A full-featured GTK4 wrapper for the Nim programming language.*

[![Nim](https://img.shields.io/badge/Nim-1.6%2B-ffc200?logo=nim&logoColor=black)](https://nim-lang.org)
[![GTK4](https://img.shields.io/badge/GTK-4.x-4a86cf?logo=gtk&logoColor=white)](https://www.gtk.org)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20Windows-informational)]()
[![License](https://img.shields.io/badge/license-see%20LICENSE-lightgrey)](LICENSE)
[![Docs](https://img.shields.io/badge/docs-EN%20%7C%20RU-blue)](#документация)

---

## Как это выглядит на Fedora

<p align="center">
  <img src="./images/Screen-01.png" alt="Приложение на libGTK4 в Fedora Linux" width="700">
</p>

## Как это выглядит на Windows

<p align="center">
  <img src="./images/Screen-02.png" alt="Приложение на libGTK4 в Windows 11" width="700">
</p>

---

## Что такое GTK4?

[GTK4](https://www.gtk.org) — зрелый кроссплатформенный тулкит для создания графических интерфейсов, на котором построен GNOME и множество десктопных приложений на Linux, Windows и macOS. Он предоставляет всё необходимое для нативного приложения: богатый набор виджетов (кнопки, текстовые поля, списки, деревья, меню, диалоги), рендеринг на основе сцен, тематизацию через CSS, систему событий/сигналов на базе GLib, drag-and-drop, поддержку доступности и интеграцию с Cairo для собственной отрисовки. Это тулкит, на котором работают такие приложения, как GIMP, Inkscape, и всё окружение GNOME.

## Что даёт libGTK4

libGTK4 предоставляет этот тулкит в Nim в виде тонкой, идиоматичной обёртки — можно строить нативные десктопные GUI, не выходя за пределы экосистемы Nim. На данный момент покрыто:

- **Core API** — жизненный цикл приложения/окна, основы объектной системы, интеграция с главным циклом GLib
- **Базовые элементы управления** — кнопки, чекбоксы, переключатели, слайдеры и другие повседневные виджеты
- **Текстовый ввод и многострочный текст** — поля ввода, текстовые области и работа с буферами
- **Числовой ввод и выбор** — spin-кнопки, комбобоксы, выпадающие списки
- **Многовидовые контейнеры** — notebook'и, стеки, paned-виджеты для организации сложных макетов
- **Виджеты отображения** — метки, изображения, прогресс-бары и другие виджеты только для чтения
- **Отрисовка, стиль и GLib** — собственная отрисовка на `GtkDrawingArea` через Cairo, стилизация через CSS, утилиты GLib
- **Всплывающие и вспомогательные виджеты** — попаверы, тултипы и другой временный UI
- **Оформление окна и диалоги** — header bar'ы, диалоги выбора файлов, диалоги сообщений
- **Панели и разное** — тулбары, статус-бары и связанные компоненты
- **Сигналы** — полный справочник по системе сигналов GTK4, а также отдельное руководство по обработке сигналов мыши и клавиатуры

Каждый справочный документ доступен на английском и русском языках (см. [Документацию](#документация) ниже), а более старые материалы сохранены для истории в [`docs/archive/`](docs/archive).

Помимо самой обёртки виджетов, [примеры](#примеры) демонстрируют реальные паттерны построения приложений: модульную структуру приложения, построение меню и горячих клавиш во время выполнения из JSON, файловый ввод-вывод с диалогами, отрисовку через Cairo с drag-жестами, симуляцию на таймере GLib (игра «Жизнь» Конвея), а также упаковку portable-сборки для Windows с встроенными библиотеками.

---

## Установка

```bash
nimble install https://github.com/Balans097/libGTK4
```

## Быстрый старт

```nim
import libGTK4

# Минимальное окно с кнопкой — полный пример см. в Test_1_Hello_world.nim
```

Полноценный рабочий пример «Hello, World!» см. в [`examples/Test_1_Hello_world.nim`](examples/Test_1_Hello_world.nim).

---

## Документация

Справочник организован по категориям виджетов, каждая доступна на английском и русском языках.

| Раздел | English | Русский |
|---|---|---|
| Core API | [EN](docs/gtk4_core_reference_en.md) | [RU](docs/gtk4_core_reference_ru.md) |
| Базовые элементы управления | [EN](docs/gtk4_basic_controls_reference_en.md) | [RU](docs/gtk4_basic_controls_reference_ru.md) |
| Текстовый ввод | [EN](docs/gtk4_text_input_reference_en.md) | [RU](docs/gtk4_text_input_reference_ru.md) |
| Многострочный текст | [EN](docs/gtk4_multiline_text_reference_en.md) | [RU](docs/gtk4_multiline_text_reference_ru.md) |
| Числовой выбор | [EN](docs/gtk4_numeric_choice_reference_en.md) | [RU](docs/gtk4_numeric_choice_reference_ru.md) |
| Многовидовые контейнеры | [EN](docs/gtk4_multiview_containers_reference_en.md) | [RU](docs/gtk4_multiview_containers_reference_ru.md) |
| Виджеты отображения | [EN](docs/gtk4_display_widgets_reference_en.md) | [RU](docs/gtk4_display_widgets_reference_ru.md) |
| Отрисовка, стиль и GLib | [EN](docs/gtk4_drawing_style_glib_reference_en.md) | [RU](docs/gtk4_drawing_style_glib_reference_ru.md) |
| Всплывающие и вспомогательные виджеты | [EN](docs/gtk4_popups_auxiliary_reference_en.md) | [RU](docs/gtk4_popups_auxiliary_reference_ru.md) |
| Оформление окна и диалоги | [EN](docs/gtk4_window_chrome_dialogs_reference_en.md) | [RU](docs/gtk4_window_chrome_dialogs_reference_ru.md) |
| Панели и разное | — | [RU](docs/gtk4_bars_misc_reference_ru.md) |
| Сигналы | [EN](<docs/Signals in GTK4.md>) | [RU](<docs/Сигналы GTK4.md>) |
| Сигналы мыши и клавиатуры | [EN](docs/Mouse_and_Keyboard_Signals.md) | [RU](<docs/Сигналы мыши и клавиатуры.md>) |

Более старые, устаревшие справочные материалы сохранены для истории в [`docs/archive/`](docs/archive).

> Документация находится в процессе написания и будет пополняться.

---

## Примеры

Полноценные рабочие примеры находятся в [`examples/`](examples):

| Пример | Описание |
|---|---|
| [Test_1_Hello_world.nim](examples/Test_1_Hello_world.nim) | Минимальное окно «Hello, World!» с обработчиком клика по кнопке |
| [Test_2_Text_editor.nim](examples/Test_2_Text_editor.nim) | Текстовый редактор с header bar'ом, кнопками Open/Save и диалогом выбора файла |
| [Test_3_Calculator.nim](examples/Test_3_Calculator.nim) | Калькулятор с четырьмя операциями и текущим дисплеем |
| [Test_4_Drawing.nim](examples/Test_4_Drawing.nim) | Свободное рисование на `GtkDrawingArea` с использованием контекста Cairo и drag-жестов |
| [Test_5_App.nim](examples/Test_5_App.nim) | Игра «Жизнь» Конвея на тороидальной сетке — переключение клеток кликом, элементы управления Start/Stop/Step/Randomize/Clear, симуляция на таймере GLib |
| [Calculator/](examples/Calculator) | Калькулятор сложения, собранный как отдельный бинарник |
| [GUI-0/](examples/GUI-0) | Демонстрация тулбара/статус-бара с текстовым полем, прогресс-баром и кастомной стилизацией через CSS |
| [GUI-1/](examples/GUI-1) | Тест свободного рисования с использованием drag-жестов и контекста Cairo |
| [GUI-2/](examples/GUI-2) | Текстовый редактор, разбитый на модули (точка входа, GUI-разметка, состояние приложения, действия/файловый ввод-вывод) — демонстрирует структурирование более крупного приложения |
| [MenuApp/](examples/MenuApp) | Меню приложения и горячие клавиши, построенные во время выполнения из JSON-описания меню |
| [Portable GUI for Windows/](<examples/Portable GUI for Windows>) | Калькулятор, упакованный как portable-сборка под Windows, с launcher'ом, добавляющим встроенную папку `libs/` в `PATH` |

---

## Референсное приложение

[`examples/ReferenceApp/`](examples/ReferenceApp) — самый полный, флагманский пример: полноценное десктопное приложение, разбитое на отдельные модули:

| Модуль | Назначение |
|---|---|
| [main.nim](examples/ReferenceApp/main.nim) | Точка входа приложения |
| [gui.nim](examples/ReferenceApp/gui.nim) | Разметка GUI и построение виджетов |
| [config.nim](examples/ReferenceApp/config.nim) | Конфигурация приложения |
| [dialogs.nim](examples/ReferenceApp/dialogs.nim) | Диалоговые окна |
| [docmodel.nim](examples/ReferenceApp/docmodel.nim) | Модель документа/данных |
| [fileio.nim](examples/ReferenceApp/fileio.nim) | Загрузка и сохранение файлов |
| [i18n.nim](examples/ReferenceApp/i18n.nim) | Интернационализация/локализация |
| [actions.nim](examples/ReferenceApp/actions.nim) | Действия приложения |

Подробности см. в [`examples/ReferenceApp/README.md`](examples/ReferenceApp/README.md). Упакованная копия также доступна в виде [`examples/ReferenceApp.7z`](examples/ReferenceApp.7z).

---

## Лицензия

См. [LICENSE](LICENSE).
