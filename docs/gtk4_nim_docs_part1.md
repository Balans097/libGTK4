# Документация обёртки GTK4 для Nim — Часть 1
## Обзор, базовые типы, перечисления, константы

| Параметр | Значение |
|---|---|
| Версия обёртки | 1.2 |
| Дата обновления | 2026-02-15 |
| Автор | Balans097 (vasil.minsk@yahoo.com) |
| Тип привязки | Прямые FFI-вызовы к C API |
| Зависимость | GTK4 (pkg-config) |

---

## Содержание

1. [Общее описание библиотеки](#1-общее-описание-библиотеки)
2. [Установка и конфигурация](#2-установка-и-конфигурация)
3. [Базовые типы GLib](#3-базовые-типы-glib)
4. [Типы виджетов GTK](#4-типы-виджетов-gtk)
5. [Типы GIO, Cairo, GDK](#5-типы-gio-cairo-gdk)
6. [Типы callback-функций](#6-типы-callback-функций)
7. [Перечисления (Enums)](#7-перечисления-enums)
8. [Константы](#8-константы)
9. [Практические примеры](#9-практические-примеры)
10. [Приложение A. Сводные таблицы](#приложение-a-сводные-таблицы)
11. [Приложение B. Диагностика и отладка](#приложение-b-диагностика-и-отладка)

---

## 1. Общее описание библиотеки

**libGTK4.nim** — полная низкоуровневая обёртка GTK4 для языка программирования Nim, предоставляющая прямые привязки к C API через FFI (Foreign Function Interface). Библиотека охватывает всё публичное API GTK4, включая виджеты, сигналы, GObject, GIO, GLib, Cairo, GSK, GDK и расширенные API инспектора.

### Архитектура

Обёртка использует три подхода для объявления привязок:

- **Псевдонимы `pointer`** — все типы виджетов GTK объявлены как `= pointer`. Это прямое отражение GObject, где все объекты — указатели в куче. Безопасность типов не гарантируется компилятором.
- **Объектные структуры** — `GtkTextIter`, `GtkTreeIter`, `GdkRectangle`, `GdkRGBA` — объявлены как `object` для корректной передачи по значению.
- **Перечисления** — `enum` с `{.size: sizeof(cint).}` для бинарной совместимости с C.

### История версий

| Версия | Дата | Изменения |
|---|---|---|
| 1.2 | 2026-02-15 | Добавлено ~1780 функций: Inspector API, Accessible API, Action API, Builder API, Constraint API, Graph/Bitset/Roaring, GSK (GskRenderNode, GskTransform), GDK (события, дисплей, устройства) |
| 1.1 | 2026-02-05 | Исправлены критические ошибки: `createListStore` (gtk_list_store_newv), `g_timeout_add`/`g_idle_add` (правильный GSourceFunc), `getClipboardText` (GAsyncReadyCallback), `gtk_text_view_get_rtl/ltr_context` (PangoContext\*), добавлены флаги `GTK_DISABLE_DEPRECATED` |
| 1.0 | 2026-01-20 | Начальная реализация |

### Устаревшие виджеты GTK3

При компиляции с флагом `-d:GTK_DISABLE_DEPRECATED` следующие API отключаются:

| Устаревший виджет | Рекомендуемая замена в GTK4 |
|---|---|
| `GtkTreeView` + `GtkListStore` | `GtkListView` + `GtkColumnView` + `GListModel` |
| `GtkTreeStore` | `GtkTreeListModel` |
| `GtkCellRenderer*` | `GtkListItemFactory` / `GtkBuilderListItemFactory` |
| `GtkInfoBar` | `GtkRevealer` + `GtkLabel` + `GtkButton` |
| `GtkStatusbar` | `GtkLabel` в `GtkActionBar` |
| `GtkRadioButton` | `GtkCheckButton` с `group` |
| `GtkDialog` | `GtkWindow` + custom layout (рекомендуется) |

---

## 2. Установка и конфигурация

### Linux / macOS

```bash
# Ubuntu/Debian:
sudo apt install libgtk-4-dev

# Fedora:
sudo dnf install gtk4-devel

# macOS (Homebrew):
brew install gtk4

# Проверка:
pkg-config --modversion gtk4  # должно вывести 4.x.x
```

### Windows (MSYS2)

```bash
# В терминале MSYS2 UCRT64:
pacman -S mingw-w64-ucrt-x86_64-gtk4

# Компиляция через Nim (из MSYS2 UCRT64):
nim c -r myapp.nim
```

### Компиляция Nim-проекта

```bash
# Стандартная компиляция (Linux/macOS):
nim c -r myapp.nim

# С отключением устаревших API GTK3:
nim c -d:GTK_DISABLE_DEPRECATED -r myapp.nim

# Release-сборка:
nim c -d:release -r myapp.nim
```

### Внутренняя конфигурация pkg-config

Заголовки и флаги линкера подставляются автоматически через pragma `passC`/`passL`:

```nim
when defined(windows):
  {.passC: gorge("pkg-config --cflags gtk4").}
  {.passL: gorge("bash -c 'pkg-config --libs gtk4 | tr -d \"\\n\"'").}
else:
  {.passC: gorge("pkg-config --cflags gtk4").}
  {.passL: gorge("pkg-config --libs gtk4").}
```

> **Примечание:** `gorge()` выполняется во время компиляции. На Windows удаляется символ `\n` из вывода pkg-config — иначе линкер получает некорректные параметры.

### Минимальный пример приложения

```nim
import libGTK4

proc activate(app: GtkApplication, data: gpointer) {.cdecl.} =
  let win = gtk_application_window_new(app)
  gtk_window_set_title(cast[GtkWindow](win), "Hello GTK4")
  gtk_window_set_default_size(cast[GtkWindow](win), 400, 300)
  gtk_widget_show(cast[GtkWidget](win))

proc main() =
  let app = gtk_application_new("org.example.App",
                                G_APPLICATION_DEFAULT_FLAGS.gint)
  discard g_signal_connect(app, "activate", activate, nil)
  let status = g_application_run(cast[GApplication](app), 0, nil)
  g_object_unref(app)
  quit(status)

main()
```

---

## 3. Базовые типы GLib

Все типы GLib точно соответствуют C-эквивалентам. Используйте их в сигнатурах функций для FFI-совместимости.

### 3.1 Целочисленные типы

| Nim-тип | C-эквивалент | Размер | Описание |
|---|---|---|---|
| `gboolean` | `gint` / `int32` | 4 байта | Логический тип. `FALSE=0`, `TRUE=`любое ненулевое значение |
| `gint` | `int` | 4 байта | 32-битное целое со знаком |
| `guint` | `unsigned int` | 4 байта | 32-битное целое без знака |
| `gshort` | `short` | 2 байта | 16-битное целое со знаком |
| `gushort` | `unsigned short` | 2 байта | 16-битное целое без знака |
| `glong` | `long` | платформа | Длинное целое (32 или 64 бита) |
| `gulong` | `unsigned long` | платформа | Длинное беззнаковое |
| `gint8` | `gint8` | 1 байт | 8-битное со знаком |
| `guint8` | `guint8` | 1 байт | 8-битное без знака |
| `gint16` | `gint16` | 2 байта | 16-битное со знаком |
| `guint16` | `guint16` | 2 байта | 16-битное без знака |
| `gint32` | `gint32` | 4 байта | 32-битное со знаком |
| `guint32` | `guint32` | 4 байта | 32-битное без знака |
| `gint64` | `gint64` | 8 байт | 64-битное со знаком |
| `guint64` | `guint64` | 8 байт | 64-битное без знака |

### 3.2 Типы с плавающей точкой и символьные

| Nim-тип | C-эквивалент | Nim-аналог | Описание |
|---|---|---|---|
| `gfloat` | `float` | `float32` | 32-битное число с плавающей точкой IEEE 754 |
| `gdouble` | `double` | `float64` | 64-битное число с плавающей точкой IEEE 754 |
| `gchar` | `char` | `char` | Символ (байт), не обязательно ASCII |
| `guchar` | `unsigned char` | `uint8` | Беззнаковый символ/байт |
| `gunichar` | `guint32` | `uint32` | Unicode-символ (UTF-32 code point) |

### 3.3 Типы размеров и указателей

| Nim-тип | C-эквивалент | Описание |
|---|---|---|
| `gsize` | `size_t` | Беззнаковый размер (платформозависимо: 32 или 64 бита) |
| `gssize` | `ssize_t` | Знаковый размер |
| `goffset` | `gint64` | Смещение файла (всегда 64-битное) |
| `gpointer` | `void*` | Универсальный нетипизированный указатель |
| `gconstpointer` | `const void*` | Константный нетипизированный указатель |

> **Примечание:** `gpointer` и `gconstpointer` в Nim объявлены как `pointer` — различие `const`/`non-const` существует только концептуально.

### 3.4 Конвертеры bool / gboolean

Обёртка предоставляет автоматические конвертеры для прозрачной работы с `bool`:

```nim
# Встроенные конвертеры (определены в libGTK4.nim):
converter boolToGboolean*(b: bool): gboolean = gboolean(b)
converter gbooleanToBool*(g: gboolean): bool = g != 0

# Благодаря конвертерам можно писать:
gtk_widget_set_visible(btn, true)     # вместо gboolean(1)
if gtk_widget_get_sensitive(btn):     # вместо != 0
  echo "виджет активен"
```

### 3.5 Структуры GLib

#### GdkRectangle

```nim
type GdkRectangle* {.bycopy.} = object
  x*:      gint  # X-координата левого верхнего угла
  y*:      gint  # Y-координата левого верхнего угла
  width*:  gint  # Ширина в пикселях
  height*: gint  # Высота в пикселях
```

Прямоугольная область экрана. Используется в функциях координат, позиционирования, `gtk_widget_get_allocation`, cairo clip regions. Атрибут `{.bycopy.}` гарантирует передачу по значению.

#### GdkRGBA

```nim
type GdkRGBA* = object
  red*:   gdouble  # Красный   [0.0 – 1.0]
  green*: gdouble  # Зелёный   [0.0 – 1.0]
  blue*:  gdouble  # Синий     [0.0 – 1.0]
  alpha*: gdouble  # Прозрачность [0.0 = прозрачный, 1.0 = непрозрачный]
```

Цвет в формате RGBA. Применяется в CSS-провайдерах, `GtkColorButton`, cairo-функциях.

```nim
# Конструирование вручную:
var blue = GdkRGBA(red: 0.0, green: 0.3, blue: 0.9, alpha: 1.0)

# Парсинг из CSS-строки:
var color: GdkRGBA
if gdk_rgba_parse(addr color, "#3498db") != FALSE:
  echo "R=", color.red, " G=", color.green, " B=", color.blue

# Конвертация в CSS-строку:
let cssStr = gdk_rgba_to_string(addr color)
```

#### GtkTextIter

```nim
type GtkTextIter* = object
  # 14 непрозрачных полей (dummy1..dummy14)
  # Не обращайтесь к полям напрямую!
  dummy1, dummy2:             pointer
  dummy3, dummy4, dummy5,
  dummy6, dummy7, dummy8:     gint
  dummy9, dummy10:            pointer
  dummy11, dummy12, dummy13:  gint
  dummy14:                    pointer
```

Итератор позиции в `GtkTextBuffer`. Передаётся по значению или как `var` для изменяемых операций. Используйте только функции `gtk_text_iter_*`.

```nim
var startIter, endIter: GtkTextIter
gtk_text_buffer_get_bounds(buffer, addr startIter, addr endIter)
let text = gtk_text_buffer_get_text(buffer, addr startIter, addr endIter, FALSE)
```

#### GtkTreeIter

```nim
type GtkTreeIter* = object
  stamp:     gint      # Магическое число для проверки достоверности
  userData:  gpointer  # Данные итератора (специфичны для модели)
  userData2: gpointer
  userData3: gpointer
```

> **Устарело:** `GtkTreeIter` устарел в GTK4. Для новых проектов используйте `GtkListView` или `GtkColumnView` с `GListModel`. TreeView доступен только без флага `-d:GTK_DISABLE_DEPRECATED`.

#### GList / GSList

```nim
# Двусвязный список GLib:
type GList* = object
  data*: gpointer    # Указатель на данные элемента
  next*: ptr GList   # Следующий элемент
  prev*: ptr GList   # Предыдущий элемент

# Односвязный список GLib:
type GSList* = object
  data*: gpointer    # Указатель на данные
  next*: ptr GSList  # Следующий элемент
```

`GList`/`GSList` возвращаются многими функциями GTK (например, `gtk_application_get_windows`). После использования освобождайте через `g_list_free()` или `g_list_free_full()`.

```nim
# Итерация по GList:
var node = gtk_application_get_windows(app)
while node != nil:
  let win = cast[GtkWindow](node.data)
  gtk_window_present(win)
  node = node.next
```

#### GSignalQuery

```nim
type GSignalQuery* {.pure, final.} = object
  signalId*:    cuint         # Числовой ID сигнала
  signalName*:  cstring       # Имя сигнала (напр. "clicked")
  itype*:       GType         # GType объекта-владельца
  signalFlags*: GSignalFlags  # Флаги сигнала
  returnType*:  GType         # Тип возвращаемого значения
  nParams*:     cuint         # Количество параметров
  paramTypes*:  ptr GType     # Типы параметров
```

Используется с `g_signal_query()` для инспекции метаданных сигналов во время выполнения.

#### GActionEntry

```nim
type GActionEntry* = object
  name*:          cstring  # Имя действия (напр. "open", "quit")
  activate*:      proc(action: GSimpleAction, parameter: GVariant,
                       user_data: gpointer) {.cdecl.}
  parameter_type*: cstring  # Строка GVariantType ("s", "i", nil)
  state*:          cstring  # Начальное состояние (для stateful actions)
  change_state*:   proc(action: GSimpleAction, value: GVariant,
                        user_data: gpointer) {.cdecl.}
```

Используется с `g_action_map_add_action_entries()` для массового добавления действий.

```nim
var entries = [
  GActionEntry(
    name: "quit",
    activate: proc(a: GSimpleAction, p: GVariant, d: gpointer) {.cdecl.} =
      g_application_quit(cast[GApplication](d))
  ),
]
g_action_map_add_action_entries(cast[GActionMap](app),
                                addr entries[0], 1, app)
```

---

## 4. Типы виджетов GTK

> **Важно:** Все типы виджетов объявлены как псевдонимы `pointer`. Безопасность типов не обеспечивается компилятором — используйте только правильные функции для каждого типа.

### 4.1 Окна и диалоги

| Тип | Описание |
|---|---|
| `GtkWidget` | Базовый тип для всех виджетов. Все `cast` выполняются к/от этого типа |
| `GtkWindow` | Обычное окно верхнего уровня |
| `GtkApplicationWindow` | Окно приложения (связанное с `GtkApplication`). Реализует `GActionMap` |
| `GtkDialog` | Базовый тип диалогового окна (устаревает в GTK4) |
| `GtkAboutDialog` | Стандартный диалог "О программе" |
| `GtkMessageDialog` | Информационный диалог с кнопками (устаревает в GTK4) |
| `GtkFileChooserDialog` | Диалог выбора файлов (устаревает → используйте `GtkFileDialog`) |
| `GtkColorChooserDialog` | Диалог выбора цвета (устаревает → используйте `GtkColorDialog`) |
| `GtkFontChooserDialog` | Диалог выбора шрифта (устаревает → используйте `GtkFontDialog`) |
| `GtkStackPage` | Страница в `GtkStack` (метаданные вкладки) |

### 4.2 Контейнеры

| Тип | Описание |
|---|---|
| `GtkBox` | Горизонтальный или вертикальный линейный контейнер |
| `GtkGrid` | Сеточный контейнер с произвольным размещением виджетов |
| `GtkFixed` | Контейнер с фиксированными координатами (нерекомендуется для адаптивных интерфейсов) |
| `GtkPaned` | Разделяемый контейнер (сплиттер) с регулируемым разделителем |
| `GtkStack` | Контейнер с переключаемыми страницами (по одной за раз) |
| `GtkStackSwitcher` | Переключатель страниц для `GtkStack` (кнопочная панель) |
| `GtkNotebook` | Контейнер с вкладками в стиле Notebook |
| `GtkExpander` | Раскрывающийся/скрывающийся контейнер |
| `GtkFrame` | Контейнер с рамкой и необязательным заголовком |
| `GtkAspectFrame` | Контейнер с заданным соотношением сторон |
| `GtkOverlay` | Контейнер с наложениями поверх основного виджета |
| `GtkScrolledWindow` | Прокручиваемый контейнер (добавляет scrollbar) |
| `GtkViewport` | Адаптер для прокрутки виджетов без нативной поддержки |
| `GtkCenterBox` | Контейнер с тремя слотами: start, center, end |

### 4.3 Кнопки

| Тип | Описание |
|---|---|
| `GtkButton` | Обычная кнопка. Поддерживает иконку, метку, произвольный дочерний виджет |
| `GtkToggleButton` | Кнопка с двумя состояниями (нажата / не нажата) |
| `GtkCheckButton` | Флажок. В GTK4 также используется вместо `GtkRadioButton` (через `group`) |
| `GtkRadioButton` | Радиокнопка (устарела в GTK4 — используйте `GtkCheckButton`) |
| `GtkLinkButton` | Кнопка-гиперссылка, открывающая URL в браузере |
| `GtkMenuButton` | Кнопка, открывающая всплывающее меню или Popover |
| `GtkLockButton` | Кнопка блокировки для управления полномочиями (`GPermission`) |
| `GtkSwitch` | Переключатель вкл/выкл в стиле iOS |
| `GtkScaleButton` | Кнопка с выдвигающимся ползунком |
| `GtkVolumeButton` | Специализированный `GtkScaleButton` для регулировки громкости |

### 4.4 Текстовые виджеты

| Тип | Описание |
|---|---|
| `GtkLabel` | Текстовая метка. Поддерживает Pango markup, перенос, эллипсис |
| `GtkEntry` | Однострочное поле ввода текста. Поддерживает иконки, прогресс |
| `GtkPasswordEntry` | Поле ввода пароля со скрытием символов и кнопкой показа |
| `GtkSearchEntry` | Поле поиска с иконкой и кнопкой очистки |
| `GtkTextView` | Многострочное текстовое поле с расширенным форматированием |
| `GtkTextBuffer` | Модель данных для `GtkTextView` (хранит текст) |
| `GtkTextMark` | Именованная позиция/якорь в `GtkTextBuffer` |
| `GtkTextTag` | Тег форматирования для фрагментов текста (шрифт, цвет и т.д.) |
| `GtkTextTagTable` | Таблица тегов, разделяемая несколькими буферами |
| `GtkTextChildAnchor` | Якорь для встроенных виджетов внутри `GtkTextView` |
| `GtkInscription` | GTK 4.8+: Label с улучшенной обрезкой текста |

### 4.5 Выбор и списки

| Тип | Описание |
|---|---|
| `GtkDropDown` | Современный выпадающий список GTK4 (работает с `GListModel`) |
| `GtkListBox` | Вертикальный список с `GtkListBoxRow`. Поддерживает фильтрацию и сортировку |
| `GtkListBoxRow` | Строка в `GtkListBox` |
| `GtkFlowBox` | Контейнер с перетекающей компоновкой (как `flex-wrap` в CSS) |
| `GtkFlowBoxChild` | Дочерний элемент `GtkFlowBox` |
| `GtkListView` | Высокопроизводительный список (виртуализация) для `GListModel` |
| `GtkColumnView` | Таблица с колонками для `GListModel` (замена `GtkTreeView`) |
| `GtkComboBox` | Выпадающий список (устарел — используйте `GtkDropDown`) |
| `GtkComboBoxText` | Упрощённый ComboBox только для текстовых элементов (устарел) |
| `GtkTreeView` | Дерево/таблица (устарел — используйте `GtkColumnView`) |
| `GtkTreeModel` | Интерфейс модели данных для TreeView (устарел) |
| `GtkListStore` | Простое хранилище данных для TreeView (устарел) |
| `GtkTreeStore` | Иерархическое хранилище для TreeView (устарел) |
| `GtkTreeSelection` | Управление выделением в TreeView (устарел) |
| `GtkTreePath` | Путь к строке в TreeModel (устарел) |
| `GtkTreeViewColumn` | Колонка TreeView (устарел) |
| `GtkCellRenderer` | Отрисовщик ячейки TreeView (устарел) |
| `GtkCellRendererText` | Текстовый CellRenderer (устарел) |
| `GtkCellRendererToggle` | Чекбокс-CellRenderer (устарел) |
| `GtkCellRendererPixbuf` | Изображение-CellRenderer (устарел) |

### 4.6 Отображение

| Тип | Описание |
|---|---|
| `GtkImage` | Отображение иконки или изображения (по имени иконки, `GIcon`, `Paintable`) |
| `GtkPicture` | Отображение `GdkPaintable` с сохранением соотношения сторон |
| `GtkSpinner` | Анимированный индикатор загрузки |
| `GtkProgressBar` | Полоса прогресса (горизонтальная или вертикальная) |
| `GtkLevelBar` | Индикатор уровня (заряд батареи, громкость) |
| `GtkStatusbar` | Строка состояния (устарела — используйте `GtkLabel` в `GtkActionBar`) |
| `GtkInfoBar` | Информационная панель (устарела — используйте `GtkRevealer`) |
| `GtkSeparator` | Горизонтальный или вертикальный разделитель |

### 4.7 Ввод чисел и диапазонов

| Тип | Описание |
|---|---|
| `GtkSpinButton` | Поле ввода числа с кнопками +/- и прокруткой |
| `GtkScale` | Ползунок для выбора значения из диапазона |
| `GtkRange` | Базовый тип для `GtkScrollbar` и `GtkScale` |
| `GtkAdjustment` | Модель числового диапазона (value, min, max, step, page) |

### 4.8 Меню, панели, поповеры

| Тип | Описание |
|---|---|
| `GtkHeaderBar` | Заголовочная панель окна в стиле GNOME (замена titlebar) |
| `GtkActionBar` | Нижняя панель действий |
| `GtkSearchBar` | Выдвигающаяся панель поиска |
| `GtkPopover` | Всплывающий контейнер над целевым виджетом |
| `GtkPopoverMenu` | Всплывающее меню на основе `GMenuModel` |
| `GtkMenuBar` | Горизонтальная строка меню (устарела — используйте `GtkPopoverMenuBar`) |
| `GtkToolbar` | Панель инструментов (устарела — используйте `GtkBox` + `GtkButton`) |

### 4.9 Рисование и GL

| Тип | Описание |
|---|---|
| `GtkDrawingArea` | Область для пользовательского рисования через Cairo или snapshot |
| `GtkGLArea` | Область для рендеринга OpenGL |

### 4.10 Прочие и интерфейсы

| Тип | Описание |
|---|---|
| `GtkCalendar` | Виджет выбора даты |
| `GtkFileChooser` | Интерфейс выбора файлов |
| `GtkColorChooser` | Интерфейс выбора цвета |
| `GtkFontChooser` | Интерфейс выбора шрифта |
| `GtkRecentChooser` | Интерфейс выбора недавних файлов (устарел) |
| `GtkAppChooser` | Интерфейс выбора приложения для открытия файла (устарел) |

---

## 5. Типы GIO, Cairo, GDK

### 5.1 GIO — приложение и действия

| Тип | Описание |
|---|---|
| `GApplication` | Базовый тип приложения GIO. Управляет жизненным циклом и D-Bus |
| `GtkApplication` | GTK-приложение, расширяет `GApplication`. Управляет окнами и меню |
| `GMenu` | Изменяемое иерархическое меню (реализует `GMenuModel`) |
| `GMenuItem` | Элемент меню с атрибутами (метка, действие, иконка) |
| `GMenuModel` | Интерфейс модели меню (только для чтения). Используется с `PopoverMenu` |
| `GSimpleAction` | Конкретная реализация `GAction`. Может быть stateful |
| `GAction` | Интерфейс действия (имя, параметр, состояние, enabled) |
| `GActionMap` | Интерфейс карты действий. Реализуется `GApplication` и `GtkWidget` |
| `GActionGroup` | Интерфейс группы действий. Уведомляет об изменениях |
| `GSimpleActionGroup` | Простая реализация `GActionGroup` |
| `GPropertyAction` | Действие, связанное со свойством GObject |
| `GFile` | Абстракция файла или URI (локальный, удалённый, ресурс) |
| `GBytes` | Неизменяемый буфер байт с подсчётом ссылок |

### 5.2 GDK — дисплей, события, буфер обмена

| Тип | Описание |
|---|---|
| `GdkDisplay` | Дисплей (X11/Wayland/Win32). Точка доступа к экрану и устройствам |
| `GdkPixbuf` | Буфер пикселей в памяти. Для загрузки изображений и создания текстур |
| `GdkTexture` | Текстура GPU для GDK/GSK. Создаётся из `GdkPixbuf` или файла |
| `GdkPaintable` | Интерфейс объекта, который умеет рисовать себя (Paintable pattern) |
| `GdkClipboard` | Буфер обмена или drag-and-drop область |
| `GdkEvent` | Нетипизированное событие GDK (клавиша, мышь, сенсор) |
| `GdkEventType` | Тип события GDK (в обёртке — `pointer`, использовать `gdk_event_get_event_type`) |
| `GdkRectangle` | Прямоугольная область (struct, не pointer) |
| `GdkRGBA` | Цвет в формате RGBA (struct, не pointer) |

### 5.3 Cairo — рисование

| Тип | Описание |
|---|---|
| `cairo_t` | Контекст рисования Cairo (получается в draw callback) |
| `cairo_surface_t` | Поверхность Cairo (экран, изображение, PDF и т.д.) |

Cairo-типы в обёртке объявлены как `pointer`. Функции `cairo_*` находятся в конце `libGTK4.nim` с атрибутом `{.importc, cdecl.}`.

```nim
# Доступные Cairo-функции в обёртке:
proc cairo_set_source_rgb*(cr: cairo_t, r, g, b: cdouble)
proc cairo_paint*(cr: cairo_t)
proc cairo_set_line_width*(cr: cairo_t, width: cdouble)
proc cairo_move_to*(cr: cairo_t, x, y: cdouble)
proc cairo_line_to*(cr: cairo_t, x, y: cdouble)
proc cairo_stroke*(cr: cairo_t)

# Использование в DrawingArea:
proc drawCb(area: GtkDrawingArea, cr: cairo_t,
            w, h: gint, data: gpointer) {.cdecl.} =
  cairo_set_source_rgb(cr, 0.2, 0.6, 0.9)
  cairo_paint(cr)
  cairo_set_source_rgb(cr, 1.0, 0.0, 0.0)
  cairo_set_line_width(cr, 2.0)
  cairo_move_to(cr, 10.0, 10.0)
  cairo_line_to(cr, 100.0, 100.0)
  cairo_stroke(cr)
```

### 5.4 Стили и CSS

| Тип | Описание |
|---|---|
| `GtkStyleContext` | Контекст стилей виджета (query CSS classes, state) |
| `GtkCssProvider` | Поставщик CSS-стилей. Загружает CSS из строки или файла |
| `GtkStyleProvider` | Интерфейс поставщика стилей (реализуется `GtkCssProvider`) |

### 5.5 GObject / GLib

| Тип | Описание |
|---|---|
| `GObject` | Базовый тип GObject. Все виджеты GTK наследуют от него |
| `GType` | Числовой идентификатор типа в системе типов GLib (`uint`) |
| `GValue` | Универсальный контейнер для хранения значений любого `GType` |
| `GVariant` | Тип-значение GLib (используется в D-Bus, GAction, GSettings) |
| `GVariantType` | Описание типа GVariant в виде строки (`"s"`, `"i"`, `"(si)"`, etc.) |
| `GError` | Структура ошибки GLib (с domain, code, message) |
| `GQuark` | `uint32` — интернированная строка GLib для быстрого сравнения |

### 5.6 Pango-типы

| Тип | Описание |
|---|---|
| `PangoAttrList` | Список атрибутов разметки (`distinct pointer`). Применяется к `GtkLabel` |
| `PangoLayout` | Разметка текстового блока (`distinct pointer`). Используется Cairo |
| `PangoTabArray` | Массив позиций табуляции (`distinct pointer`) |
| `PangoContext` | Контекст шрифтовой системы (`distinct pointer`). Возвращается `gtk_widget_get_pango_context` |

> **Примечание:** Pango-типы объявлены как `distinct pointer`. Это предотвращает случайное смешение Pango-указателей с другими `pointer`-переменными на уровне компилятора.

### 5.7 Типы Entry

| Тип | Описание |
|---|---|
| `GtkEntryBuffer` | Модель данных для `GtkEntry` (хранит текст и его позицию) |
| `GtkEntryCompletion` | Автодополнение для `GtkEntry` (устарело в GTK4) |
| `GIcon` | Интерфейс иконки (может быть themed, file, emblem) |

---

## 6. Типы callback-функций

> **Важно:** Все callback-функции для GTK должны иметь атрибут `{.cdecl.}`. Без него поведение на некоторых платформах (особенно Windows) непредсказуемо.

### 6.1 Базовые типы

| Тип | Сигнатура | Применение |
|---|---|---|
| `GCallback` | `pointer` | Универсальный указатель на callback. Используется в `g_signal_connect` |
| `GDestroyNotify` | `pointer` | Функция освобождения: `proc(data: gpointer) {.cdecl.}` |
| `GClosureNotify` | `pointer` | Уведомление о закрытии замыкания сигнала |
| `GSourceFunc` | `proc(userData: gpointer): gboolean {.cdecl.}` | Для `g_timeout_add`, `g_idle_add`. Возврат `FALSE` = удалить источник |
| `GAsyncReadyCallback` | `proc(src, res: pointer, data: gpointer) {.cdecl.}` | Завершение асинхронной операции (clipboard, file I/O) |

### 6.2 Правила написания callback-функций

```nim
# ОБЯЗАТЕЛЬНО: все callback должны иметь атрибут {.cdecl.}

# Обработчик сигнала "clicked":
proc onClicked(btn: GtkButton, data: gpointer) {.cdecl.} =
  echo "Кнопка нажата"

# Обработчик сигнала "activate" приложения:
proc onActivate(app: GtkApplication, data: gpointer) {.cdecl.} =
  let win = gtk_application_window_new(app)
  gtk_widget_show(cast[GtkWidget](win))

# Таймер (TRUE = продолжать, FALSE = остановить):
proc onTimer(data: gpointer): gboolean {.cdecl.} =
  echo "Тик!"
  return TRUE  # конвертер автоматически

# Подключение:
discard g_signal_connect(btn, "clicked", onClicked, nil)
discard g_timeout_add(1000, onTimer, nil)  # каждую секунду
```

### 6.3 Передача данных в callback

```nim
# Способ 1: передача указателя на Nim-объект через gpointer
type MyData = object
  counter: int
  label:   GtkLabel

var data = MyData(counter: 0, label: lbl)

proc onClick(btn: GtkButton, userData: gpointer) {.cdecl.} =
  let d = cast[ptr MyData](userData)
  inc d.counter
  gtk_label_set_text(d.label, ($d.counter).cstring)

discard g_signal_connect(btn, "clicked", onClick, addr data)
# ВАЖНО: data должна жить всё время работы callback!

# Способ 2: heap-выделение с GDestroyNotify
let heapData = cast[ptr MyData](alloc0(sizeof(MyData)))
heapData[] = MyData(counter: 0, label: lbl)

proc destroyData(d: gpointer) {.cdecl.} = dealloc(d)

discard g_signal_connect_data(btn, "clicked", onClick,
                               heapData, destroyData, 0)
```

### 6.4 Специализированные callback

```nim
# GtkDrawingArea draw function:
proc drawFunc(area: GtkDrawingArea, cr: cairo_t,
              width, height: gint, data: gpointer) {.cdecl.} =
  cairo_set_source_rgb(cr, 0.0, 0.5, 1.0)
  cairo_paint(cr)

gtk_drawing_area_set_draw_func(drawArea, drawFunc, nil, nil)

# GtkListBox filter function:
proc filterFunc(row: GtkListBoxRow, data: gpointer): gboolean {.cdecl.} =
  return TRUE  # TRUE = показать строку

# GtkFileDialog callback (асинхронный):
proc fileChosen(src: pointer, res: pointer, data: gpointer) {.cdecl.} =
  var err: GError
  let file = gtk_file_dialog_open_finish(
    cast[pointer](src), res, addr err)
  if file != nil:
    let path = g_file_get_path(cast[GFile](file))
    echo "Выбран файл: ", $path
```

---

## 7. Перечисления (Enums)

Все перечисления объявлены с `{.size: sizeof(cint).}` для совместимости с C-ABI.

### 7.1 Ориентация, выравнивание, позиционирование

#### GtkOrientation

```nim
type GtkOrientation* {.size: sizeof(cint).} = enum
  GTK_ORIENTATION_HORIZONTAL = 0  # Горизонтальная (слева направо)
  GTK_ORIENTATION_VERTICAL   = 1  # Вертикальная (сверху вниз)
```

```nim
let hbox = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 6)
let vbox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 12)
```

#### GtkAlign

```nim
type GtkAlign* {.size: sizeof(cint).} = enum
  GTK_ALIGN_FILL     = 0  # Заполнить всё доступное пространство
  GTK_ALIGN_START    = 1  # По началу (левый/верхний край)
  GTK_ALIGN_END      = 2  # По концу (правый/нижний край)
  GTK_ALIGN_CENTER   = 3  # По центру
  GTK_ALIGN_BASELINE = 4  # По базовой линии текста
```

#### GtkJustification

```nim
type GtkJustification* {.size: sizeof(cint).} = enum
  GTK_JUSTIFY_LEFT   = 0  # По левому краю
  GTK_JUSTIFY_RIGHT  = 1  # По правому краю
  GTK_JUSTIFY_CENTER = 2  # По центру
  GTK_JUSTIFY_FILL   = 3  # По ширине (justify)
```

#### GtkPositionType

```nim
type GtkPositionType* {.size: sizeof(cint).} = enum
  GTK_POS_LEFT   = 0  # Слева (метки Scale, Tab в Notebook)
  GTK_POS_RIGHT  = 1  # Справа
  GTK_POS_TOP    = 2  # Над виджетом
  GTK_POS_BOTTOM = 3  # Под виджетом
```

#### GtkBaselinePosition

```nim
type GtkBaselinePosition* {.size: sizeof(cint).} = enum
  GTK_BASELINE_POSITION_TOP    = 0  # Базовая линия у верхнего края
  GTK_BASELINE_POSITION_CENTER = 1  # По середине
  GTK_BASELINE_POSITION_BOTTOM = 2  # У нижнего края
```

#### GtkTextDirection

```nim
type GtkTextDirection* {.size: sizeof(cint).} = enum
  GTK_TEXT_DIR_NONE  # Не задано (используется системное)
  GTK_TEXT_DIR_LTR   # Слева направо (латиница, кириллица)
  GTK_TEXT_DIR_RTL   # Справа налево (арабский, иврит)
```

### 7.2 Текст и перенос строк

#### GtkWrapMode

```nim
type GtkWrapMode* {.size: sizeof(cint).} = enum
  GTK_WRAP_NONE      = 0  # Без переноса (текст обрезается)
  GTK_WRAP_CHAR      = 1  # Перенос по символам
  GTK_WRAP_WORD      = 2  # Перенос по словам
  GTK_WRAP_WORD_CHAR = 3  # По словам; если не помещается — по символам
```

#### PangoWrapMode

```nim
type PangoWrapMode* {.size: sizeof(cint).} = enum
  PANGO_WRAP_WORD      = 0  # По словам
  PANGO_WRAP_CHAR      = 1  # По символам
  PANGO_WRAP_WORD_CHAR = 2  # По словам, затем по символам
```

#### PangoEllipsizeMode

```nim
type PangoEllipsizeMode* {.size: sizeof(cint).} = enum
  PANGO_ELLIPSIZE_NONE   = 0  # Без эллипсиса (обрезать)
  PANGO_ELLIPSIZE_START  = 1  # "…текст"
  PANGO_ELLIPSIZE_MIDDLE = 2  # "нач…конец"
  PANGO_ELLIPSIZE_END    = 3  # "текст…"
```

#### GtkNaturalWrapMode

```nim
type GtkNaturalWrapMode* {.size: sizeof(cint).} = enum
  GTK_NATURAL_WRAP_INHERIT = 0  # Унаследовать от GtkLabel
  GTK_NATURAL_WRAP_NONE    = 1  # Не переносить при вычислении natural size
  GTK_NATURAL_WRAP_WORD    = 2  # По словам при вычислении natural size
```

### 7.3 Выделение, диалоги, файлы

#### GtkSelectionMode

```nim
type GtkSelectionMode* {.size: sizeof(cint).} = enum
  GTK_SELECTION_NONE     = 0  # Выделение запрещено
  GTK_SELECTION_SINGLE   = 1  # Не более одного элемента
  GTK_SELECTION_BROWSE   = 2  # Всегда один выбранный (нельзя снять)
  GTK_SELECTION_MULTIPLE = 3  # Несколько элементов (Ctrl/Shift)
```

#### GtkResponseType

> Отрицательные значения зарезервированы GTK. Пользовательские ответы должны быть `>= 0`.

```nim
type GtkResponseType* {.size: sizeof(cint).} = enum
  GTK_RESPONSE_HELP         = -11  # Кнопка "Справка"
  GTK_RESPONSE_APPLY        = -10  # Кнопка "Применить"
  GTK_RESPONSE_NO           = -9   # Кнопка "Нет"
  GTK_RESPONSE_YES          = -8   # Кнопка "Да"
  GTK_RESPONSE_CLOSE        = -7   # Кнопка "Закрыть"
  GTK_RESPONSE_CANCEL       = -6   # Кнопка "Отмена"
  GTK_RESPONSE_OK           = -5   # Кнопка "ОК"
  GTK_RESPONSE_DELETE_EVENT = -4   # Закрыт через Esc или кнопку X
  GTK_RESPONSE_ACCEPT       = -3   # Принять (для внутреннего использования)
  GTK_RESPONSE_REJECT       = -2   # Отклонить
  GTK_RESPONSE_NONE         = -1   # Нет ответа (начальное состояние)
```

#### GtkMessageType

```nim
type GtkMessageType* {.size: sizeof(cint).} = enum
  GTK_MESSAGE_INFO     = 0  # Информационное сообщение
  GTK_MESSAGE_WARNING  = 1  # Предупреждение
  GTK_MESSAGE_QUESTION = 2  # Вопрос пользователю
  GTK_MESSAGE_ERROR    = 3  # Сообщение об ошибке
  GTK_MESSAGE_OTHER    = 4  # Другой тип (без иконки)
```

#### GtkButtonsType

```nim
type GtkButtonsType* {.size: sizeof(cint).} = enum
  GTK_BUTTONS_NONE      = 0  # Без кнопок (добавлять вручную)
  GTK_BUTTONS_OK        = 1  # "OK"
  GTK_BUTTONS_CLOSE     = 2  # "Закрыть"
  GTK_BUTTONS_CANCEL    = 3  # "Отмена"
  GTK_BUTTONS_YES_NO    = 4  # "Да" + "Нет"
  GTK_BUTTONS_OK_CANCEL = 5  # "OK" + "Отмена"
```

#### GtkFileChooserAction

```nim
type GtkFileChooserAction* {.size: sizeof(cint).} = enum
  GTK_FILE_CHOOSER_ACTION_OPEN          = 0  # Открыть существующий файл
  GTK_FILE_CHOOSER_ACTION_SAVE          = 1  # Сохранить файл
  GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER = 2  # Выбрать папку
```

### 7.4 Прокрутка и анимации

#### GtkPolicyType

```nim
type GtkPolicyType* {.size: sizeof(cint).} = enum
  GTK_POLICY_ALWAYS    = 0  # Полоса всегда видима
  GTK_POLICY_AUTOMATIC = 1  # Появляется при необходимости
  GTK_POLICY_NEVER     = 2  # Никогда не показывается
  GTK_POLICY_EXTERNAL  = 3  # Управление внешним кодом
```

#### GtkStackTransitionType

```nim
type GtkStackTransitionType* = enum
  GTK_STACK_TRANSITION_TYPE_NONE             = 0   # Без анимации
  GTK_STACK_TRANSITION_TYPE_CROSSFADE        = 1   # Плавное растворение
  GTK_STACK_TRANSITION_TYPE_SLIDE_RIGHT      = 2   # Скольжение вправо
  GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT       = 3   # Скольжение влево
  GTK_STACK_TRANSITION_TYPE_SLIDE_UP         = 4   # Скольжение вверх
  GTK_STACK_TRANSITION_TYPE_SLIDE_DOWN       = 5   # Скольжение вниз
  GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT_RIGHT = 6   # Влево или вправо (по направлению)
  GTK_STACK_TRANSITION_TYPE_SLIDE_UP_DOWN    = 7   # Вверх или вниз
  GTK_STACK_TRANSITION_TYPE_OVER_UP          = 8   # Новая страница накрывает снизу вверх
  GTK_STACK_TRANSITION_TYPE_OVER_DOWN        = 9   # Накрывает сверху вниз
  GTK_STACK_TRANSITION_TYPE_OVER_LEFT        = 10  # Накрывает справа налево
  GTK_STACK_TRANSITION_TYPE_OVER_RIGHT       = 11  # Накрывает слева направо
  GTK_STACK_TRANSITION_TYPE_UNDER_UP         = 12  # Старая уходит вниз
  GTK_STACK_TRANSITION_TYPE_UNDER_DOWN       = 13  # Старая уходит вверх
  GTK_STACK_TRANSITION_TYPE_UNDER_LEFT       = 14  # Старая уходит вправо
  GTK_STACK_TRANSITION_TYPE_UNDER_RIGHT      = 15  # Старая уходит влево
  GTK_STACK_TRANSITION_TYPE_OVER_UP_DOWN     = 16  # Вверх или вниз
  GTK_STACK_TRANSITION_TYPE_OVER_DOWN_UP     = 17  # Вниз или вверх
  GTK_STACK_TRANSITION_TYPE_OVER_LEFT_RIGHT  = 18  # Влево или вправо
  GTK_STACK_TRANSITION_TYPE_OVER_RIGHT_LEFT  = 19  # Вправо или влево
```

#### GtkRevealerTransitionType

```nim
type GtkRevealerTransitionType* {.size: sizeof(cint).} = enum
  GTK_REVEALER_TRANSITION_TYPE_NONE        = 0  # Без анимации
  GTK_REVEALER_TRANSITION_TYPE_CROSSFADE   = 1  # Плавное появление/исчезновение
  GTK_REVEALER_TRANSITION_TYPE_SLIDE_RIGHT = 2  # Выдвижение вправо
  GTK_REVEALER_TRANSITION_TYPE_SLIDE_LEFT  = 3  # Выдвижение влево
  GTK_REVEALER_TRANSITION_TYPE_SLIDE_UP    = 4  # Выдвижение вверх
  GTK_REVEALER_TRANSITION_TYPE_SLIDE_DOWN  = 5  # Выдвижение вниз
  GTK_REVEALER_TRANSITION_TYPE_SWING_RIGHT = 6  # Качание вправо
  GTK_REVEALER_TRANSITION_TYPE_SWING_LEFT  = 7  # Качание влево
  GTK_REVEALER_TRANSITION_TYPE_SWING_UP    = 8  # Качание вверх
  GTK_REVEALER_TRANSITION_TYPE_SWING_DOWN  = 9  # Качание вниз
```

### 7.5 Ввод

#### GtkInputPurpose

```nim
type GtkInputPurpose* {.size: sizeof(cint).} = enum
  GTK_INPUT_PURPOSE_FREE_FORM = 0   # Произвольный текст (по умолчанию)
  GTK_INPUT_PURPOSE_ALPHA     = 1   # Только буквы
  GTK_INPUT_PURPOSE_DIGITS    = 2   # Только цифры
  GTK_INPUT_PURPOSE_NUMBER    = 3   # Число (цифры, точка, знак)
  GTK_INPUT_PURPOSE_PHONE     = 4   # Телефонный номер
  GTK_INPUT_PURPOSE_URL       = 5   # URL-адрес
  GTK_INPUT_PURPOSE_EMAIL     = 6   # Email-адрес
  GTK_INPUT_PURPOSE_NAME      = 7   # Имя человека
  GTK_INPUT_PURPOSE_PASSWORD  = 8   # Пароль (скрыть символы)
  GTK_INPUT_PURPOSE_PIN       = 9   # PIN-код
  GTK_INPUT_PURPOSE_TERMINAL  = 10  # Терминальный ввод
```

#### GtkInputHints

Битовые флаги, комбинируются через `or`:

```nim
type GtkInputHints* {.size: sizeof(cint).} = enum
  GTK_INPUT_HINT_NONE                = 0     # Без подсказок
  GTK_INPUT_HINT_SPELLCHECK          = 1     # Проверка орфографии
  GTK_INPUT_HINT_NO_SPELLCHECK       = 2     # Отключить орфографию
  GTK_INPUT_HINT_WORD_COMPLETION     = 4     # Автодополнение по словам
  GTK_INPUT_HINT_LOWERCASE           = 8     # Строчные буквы
  GTK_INPUT_HINT_UPPERCASE_CHARS     = 16    # Прописные буквы
  GTK_INPUT_HINT_UPPERCASE_WORDS     = 32    # Первая буква слова — прописная
  GTK_INPUT_HINT_UPPERCASE_SENTENCES = 64    # Первая буква предложения — прописная
  GTK_INPUT_HINT_INHIBIT_OSK         = 128   # Не показывать экранную клавиатуру
  GTK_INPUT_HINT_VERTICAL_WRITING    = 256   # Вертикальный режим письма
  GTK_INPUT_HINT_EMOJI               = 512   # Разрешить emoji
  GTK_INPUT_HINT_NO_EMOJI            = 1024  # Запретить emoji
  GTK_INPUT_HINT_PRIVATE             = 2048  # Приватный ввод (не кэшировать)
```

#### GtkEntryIconPosition

```nim
type GtkEntryIconPosition* {.size: sizeof(cint).} = enum
  GTK_ENTRY_ICON_PRIMARY   = 0  # Иконка слева (начало)
  GTK_ENTRY_ICON_SECONDARY = 1  # Иконка справа (конец)
```

#### GtkImageType

```nim
type GtkImageType* {.size: sizeof(cint).} = enum
  GTK_IMAGE_EMPTY     = 0  # GtkImage пустой
  GTK_IMAGE_ICON_NAME = 1  # Именованная иконка из темы
  GTK_IMAGE_GICON     = 2  # GIcon
  GTK_IMAGE_PAINTABLE = 3  # GdkPaintable
```

### 7.6 Приложение и действия

#### GApplicationFlags

```nim
type GApplicationFlags* {.size: sizeof(cint).} = enum
  G_APPLICATION_FLAGS_NONE           = 0        # Стандартный режим (один экземпляр)
  G_APPLICATION_IS_SERVICE           = 1 shl 0  # D-Bus сервис
  G_APPLICATION_IS_LAUNCHER          = 1 shl 1  # Только запускает другие экземпляры
  G_APPLICATION_HANDLES_OPEN         = 1 shl 2  # Обрабатывает сигнал "open" (файлы)
  G_APPLICATION_HANDLES_COMMAND_LINE = 1 shl 3  # Обрабатывает "command-line"
  G_APPLICATION_SEND_ENVIRONMENT     = 1 shl 4  # Отправлять переменные окружения
  G_APPLICATION_NON_UNIQUE           = 1 shl 5  # Разрешить несколько экземпляров
  G_APPLICATION_CAN_OVERRIDE_APP_ID  = 1 shl 6  # ID приложения можно переопределить
  G_APPLICATION_ALLOW_REPLACEMENT    = 1 shl 7  # Позволить заменить себя
  G_APPLICATION_REPLACE              = 1 shl 8  # Заменить существующий экземпляр
```

#### GtkApplicationInhibitFlags

```nim
type GtkApplicationInhibitFlags* {.size: sizeof(cint).} = enum
  GTK_APPLICATION_INHIBIT_LOGOUT  = 1 shl 0  # Запретить выход из системы
  GTK_APPLICATION_INHIBIT_SWITCH  = 1 shl 1  # Запретить смену пользователя
  GTK_APPLICATION_INHIBIT_SUSPEND = 1 shl 2  # Запретить спящий режим
  GTK_APPLICATION_INHIBIT_IDLE    = 1 shl 3  # Запретить автоблокировку
```

### 7.7 Сигналы — служебные перечисления

#### GSignalMatchType

```nim
type GSignalMatchType* {.size: sizeof(cint).} = enum
  G_SIGNAL_MATCH_ID         = 1 shl 0  # По числовому ID сигнала
  G_SIGNAL_MATCH_DETAIL     = 1 shl 1  # По детали (GQuark)
  G_SIGNAL_MATCH_CLOSURE    = 1 shl 2  # По замыканию
  G_SIGNAL_MATCH_FUNC       = 1 shl 3  # По callback-функции
  G_SIGNAL_MATCH_DATA       = 1 shl 4  # По пользовательским данным
  G_SIGNAL_MATCH_UNBLOCKED  = 1 shl 5  # Только незаблокированные
```

#### GSignalFlags

```nim
type GSignalFlags* {.size: sizeof(cint).} = enum
  G_SIGNAL_RUN_FIRST            = 1 shl 0   # Обработчик класса вызывается первым
  G_SIGNAL_RUN_LAST             = 1 shl 1   # Обработчик класса вызывается последним
  G_SIGNAL_RUN_CLEANUP          = 1 shl 2   # Вызывается для очистки
  G_SIGNAL_NO_RECURSE           = 1 shl 3   # Без рекурсии
  G_SIGNAL_DETAILED             = 1 shl 4   # Поддерживает "notify::property"
  G_SIGNAL_ACTION               = 1 shl 5   # Является действием (горячая клавиша)
  G_SIGNAL_NO_HOOKS             = 1 shl 6   # Emission hooks не поддерживаются
  G_SIGNAL_MUST_COLLECT         = 1 shl 7   # Должен собирать возвращаемые значения
  G_SIGNAL_DEPRECATED           = 1 shl 8   # Сигнал устарел
  G_SIGNAL_ACCUMULATOR_FIRST_RUN = 1 shl 17 # Аккумулятор запускается первым
```

#### GBindingFlags

```nim
type GBindingFlags* {.size: sizeof(cint).} = enum
  G_BINDING_DEFAULT        = 0  # Односторонняя привязка (source → target)
  G_BINDING_BIDIRECTIONAL  = 1  # Двусторонняя привязка
  G_BINDING_SYNC_CREATE    = 2  # Синхронизировать при создании
  G_BINDING_INVERT_BOOLEAN = 4  # Инвертировать булево значение
```

### 7.8 Прочие перечисления

#### GtkSizeGroupMode

```nim
type GtkSizeGroupMode* {.size: sizeof(cint).} = enum
  GTK_SIZE_GROUP_NONE       = 0  # Без группировки
  GTK_SIZE_GROUP_HORIZONTAL = 1  # Выровнять ширину
  GTK_SIZE_GROUP_VERTICAL   = 2  # Выровнять высоту
  GTK_SIZE_GROUP_BOTH       = 3  # Выровнять оба размера
```

#### GtkArrowType

```nim
type GtkArrowType* {.size: sizeof(cint).} = enum
  GTK_ARROW_UP    # Стрелка вверх
  GTK_ARROW_DOWN  # Стрелка вниз
  GTK_ARROW_LEFT  # Стрелка влево
  GTK_ARROW_RIGHT # Стрелка вправо
  GTK_ARROW_NONE  # Без стрелки
```

#### GtkTextWindowType

```nim
type GtkTextWindowType* {.size: sizeof(cint).} = enum
  GTK_TEXT_WINDOW_WIDGET = 1  # Весь виджет GtkTextView
  GTK_TEXT_WINDOW_TEXT   = 2  # Область текста
  GTK_TEXT_WINDOW_LEFT   = 3  # Левое поле
  GTK_TEXT_WINDOW_RIGHT  = 4  # Правое поле
  GTK_TEXT_WINDOW_TOP    = 5  # Верхнее поле
  GTK_TEXT_WINDOW_BOTTOM = 6  # Нижнее поле
```

#### GOptionFlags / GOptionArg

```nim
type GOptionFlags* {.size: sizeof(cint).} = enum
  G_OPTION_FLAG_NONE         = 0
  G_OPTION_FLAG_HIDDEN       = 1 shl 0  # Скрыть опцию в --help
  G_OPTION_FLAG_IN_MAIN      = 1 shl 1  # Показывать в главной группе
  G_OPTION_FLAG_REVERSE      = 1 shl 2  # Инвертировать булево значение
  G_OPTION_FLAG_NO_ARG       = 1 shl 3  # Опция без аргумента
  G_OPTION_FLAG_FILENAME     = 1 shl 4  # Аргумент — путь к файлу
  G_OPTION_FLAG_OPTIONAL_ARG = 1 shl 5  # Необязательный аргумент
  G_OPTION_FLAG_NOALIAS      = 1 shl 6  # Без псевдонимов

type GOptionArg* {.size: sizeof(cint).} = enum
  G_OPTION_ARG_NONE           # Без аргумента (флаг)
  G_OPTION_ARG_STRING         # Строковый аргумент
  G_OPTION_ARG_INT            # Целочисленный аргумент
  G_OPTION_ARG_CALLBACK       # Пользовательский callback
  G_OPTION_ARG_FILENAME       # Путь к файлу
  G_OPTION_ARG_STRING_ARRAY   # Массив строк
  G_OPTION_ARG_FILENAME_ARRAY # Массив путей
  G_OPTION_ARG_DOUBLE         # Число с плавающей точкой
  G_OPTION_ARG_INT64          # 64-битное целое
```

---

## 8. Константы

### 8.1 Булевые значения

```nim
const
  FALSE* = 0
  TRUE*  = 1
```

> **Примечание:** GTK использует `gboolean` (`int32`), а не `bool` Nim. Конвертеры `boolToGboolean` и `gbooleanToBool` позволяют прозрачно использовать обычные `bool`. При прямых FFI-вызовах с явным типом `gboolean` используйте `FALSE`/`TRUE` или явное приведение.

### 8.2 Типы GType

| Константа | Значение | Описание |
|---|---|---|
| `G_TYPE_INVALID` | `0 shl 2` = 0 | Недопустимый тип (ошибка) |
| `G_TYPE_NONE` | `1 shl 2` = 4 | Тип "ничего" (void) |
| `G_TYPE_INTERFACE` | `2 shl 2` = 8 | Тип интерфейса GLib |
| `G_TYPE_CHAR` | `3 shl 2` = 12 | `gchar` |
| `G_TYPE_UCHAR` | `4 shl 2` = 16 | `guchar` |
| `G_TYPE_BOOLEAN` | `5 shl 2` = 20 | `gboolean` |
| `G_TYPE_INT` | `6 shl 2` = 24 | `gint` |
| `G_TYPE_UINT` | `7 shl 2` = 28 | `guint` |
| `G_TYPE_LONG` | `8 shl 2` = 32 | `glong` |
| `G_TYPE_ULONG` | `9 shl 2` = 36 | `gulong` |
| `G_TYPE_INT64` | `10 shl 2` = 40 | `gint64` |
| `G_TYPE_UINT64` | `11 shl 2` = 44 | `guint64` |
| `G_TYPE_ENUM` | `12 shl 2` = 48 | Тип перечисления |
| `G_TYPE_FLAGS` | `13 shl 2` = 52 | Тип битовых флагов |
| `G_TYPE_FLOAT` | `14 shl 2` = 56 | `gfloat` |
| `G_TYPE_DOUBLE` | `15 shl 2` = 60 | `gdouble` |
| `G_TYPE_STRING` | `16 shl 2` = 64 | `gchar*` (C-строка) |
| `G_TYPE_POINTER` | `17 shl 2` = 68 | `gpointer` |
| `G_TYPE_BOXED` | `18 shl 2` = 72 | Boxed-тип (копируемый указатель) |
| `G_TYPE_PARAM` | `19 shl 2` = 76 | `GParamSpec` |
| `G_TYPE_OBJECT` | `20 shl 2` = 80 | `GObject` (корень иерархии) |
| `G_TYPE_VARIANT` | `21 shl 2` = 84 | `GVariant` |

```nim
# Использование GType-констант:
let store = gtk_list_store_new(3,
  G_TYPE_STRING,   # Колонка 0: строка
  G_TYPE_INT,      # Колонка 1: целое
  G_TYPE_BOOLEAN)  # Колонка 2: bool
```

### 8.3 Типы окон

```nim
const
  GTK_WINDOW_TOPLEVEL* = 0  # Обычное окно верхнего уровня с декорациями
  GTK_WINDOW_POPUP*    = 1  # Всплывающее окно без декораций
```

### 8.4 Приоритеты CSS-провайдеров

Провайдер с большим приоритетом перекрывает меньший:

```nim
const
  GTK_STYLE_PROVIDER_PRIORITY_FALLBACK*    = 1    # Резервный (наименьший)
  GTK_STYLE_PROVIDER_PRIORITY_THEME*       = 200  # Тема GTK (Adwaita, Arc и т.д.)
  GTK_STYLE_PROVIDER_PRIORITY_SETTINGS*    = 400  # Настройки GtkSettings
  GTK_STYLE_PROVIDER_PRIORITY_APPLICATION* = 600  # CSS приложения (рекомендуется)
  GTK_STYLE_PROVIDER_PRIORITY_USER*        = 800  # Пользовательский CSS (наивысший)
```

```nim
# Применение CSS-стилей приложения:
let provider = gtk_css_provider_new()
gtk_css_provider_load_from_string(provider,
  "button { background: #2196F3; color: white; }")
let display = gdk_display_get_default()
gtk_style_context_add_provider_for_display(
  display, cast[GtkStyleProvider](provider),
  GTK_STYLE_PROVIDER_PRIORITY_APPLICATION)
```

### 8.5 Флаги отладки GTK

Устанавливаются через `GTK_DEBUG=flags` или `gtk_set_debug_flags()`. Комбинируются через `or`:

```nim
const
  GTK_DEBUG_TEXT*           = 1 shl 0   # Отладка GtkTextView
  GTK_DEBUG_TREE*           = 1 shl 1   # Отладка TreeView
  GTK_DEBUG_KEYBINDINGS*    = 1 shl 2   # Отладка горячих клавиш
  GTK_DEBUG_MODULES*        = 1 shl 3   # Отладка загрузки модулей
  GTK_DEBUG_GEOMETRY*       = 1 shl 4   # Отладка геометрии виджетов
  GTK_DEBUG_ICONTHEME*      = 1 shl 5   # Отладка тем иконок
  GTK_DEBUG_PRINTING*       = 1 shl 6   # Отладка печати
  GTK_DEBUG_BUILDER*        = 1 shl 7   # Отладка GtkBuilder
  GTK_DEBUG_SIZE_REQUEST*   = 1 shl 8   # Отладка запросов размеров
  GTK_DEBUG_NO_CSS_CACHE*   = 1 shl 9   # Отключить кэш CSS
  GTK_DEBUG_INTERACTIVE*    = 1 shl 10  # Включить GTK Inspector при запуске
  GTK_DEBUG_TOUCHSCREEN*    = 1 shl 11  # Эмулировать сенсорный экран
  GTK_DEBUG_ACTIONS*        = 1 shl 12  # Отладка GAction
  GTK_DEBUG_LAYOUT*         = 1 shl 13  # Отладка layout-менеджеров
  GTK_DEBUG_SNAPSHOT*       = 1 shl 14  # Отладка snapshot/рендеринга
  GTK_DEBUG_CONSTRAINTS*    = 1 shl 15  # Отладка GtkConstraint
  GTK_DEBUG_BUILDER_OBJECTS* = 1 shl 16 # Отладка объектов Builder
  GTK_DEBUG_A11Y*           = 1 shl 17  # Отладка доступности (Accessible)
  GTK_DEBUG_ICONFALLBACK*   = 1 shl 18  # Отладка запасных иконок
```

```nim
# Включение из командной строки:
# GTK_DEBUG=interactive,layout ./myapp

# Из кода:
gtk_set_debug_flags(GTK_DEBUG_INTERACTIVE or GTK_DEBUG_LAYOUT)

# Проверка текущих флагов:
let flags = gtk_get_debug_flags()
if (flags and GTK_DEBUG_INTERACTIVE.cuint) != 0:
  echo "Inspector включён"
```

### 8.6 Прочие константы

```nim
const
  G_APPLICATION_DEFAULT_FLAGS* = 0  # Псевдоним G_APPLICATION_FLAGS_NONE (новый API GLib)
```

---

## 9. Практические примеры

### 9.1 Приведение типов (cast)

```nim
# Основное правило: все виджеты хранятся как pointer,
# приводите через cast[] только вдоль иерархии наследования.

let btn = gtk_button_new_with_label("Нажми меня")

# Вверх по иерархии (всегда безопасно):
gtk_widget_set_sensitive(cast[GtkWidget](btn), TRUE)

# GtkApplicationWindow → GtkWindow:
let win = gtk_application_window_new(app)
gtk_window_set_title(cast[GtkWindow](win), "Заголовок")

# GtkApplication → GApplication:
g_application_quit(cast[GApplication](app))

# GtkApplicationWindow → GActionMap (для действий):
g_action_map_add_action(cast[GActionMap](win),
                         cast[GAction](myAction))
```

### 9.2 Работа с gboolean

```nim
# Конвертеры работают автоматически:
gtk_widget_set_visible(btn, true)   # bool → gboolean

# В явных gboolean-контекстах:
let result: gboolean = gtk_widget_get_sensitive(btn)
if result != FALSE:
  echo "активен"

# Через конвертер:
if gtk_widget_get_sensitive(btn):
  echo "активен"
```

### 9.3 GtkAdjustment — числовой диапазон

```nim
# gtk_adjustment_new(value, lower, upper,
#                    step_increment, page_increment, page_size)
let adj = gtk_adjustment_new(50.0, 0.0, 100.0, 1.0, 10.0, 0.0)

# Использование в Scale:
let scale = gtk_scale_new(GTK_ORIENTATION_HORIZONTAL,
                           cast[GtkAdjustment](adj))

# Использование в SpinButton:
let spin = gtk_spin_button_new(cast[GtkAdjustment](adj), 1.0, 0)

# Реакция на изменение:
discard g_signal_connect(adj, "value-changed",
  proc(a: GtkAdjustment, d: gpointer) {.cdecl.} =
    echo "Значение: ", gtk_adjustment_get_value(a)
  , nil)
```

### 9.4 Перебор дочерних виджетов

```nim
# GTK4: цепочка get_first_child / get_next_sibling
proc forEachChild(parent: GtkWidget,
                  cb: proc(w: GtkWidget) {.cdecl.}) =
  var child = gtk_widget_get_first_child(parent)
  while child != nil:
    cb(child)
    child = gtk_widget_get_next_sibling(child)

forEachChild(cast[GtkWidget](box),
  proc(w: GtkWidget) {.cdecl.} =
    echo "Виджет: ", gtk_widget_get_name(w))
```

### 9.5 GList — итерация

```nim
var node = gtk_application_get_windows(app)
while node != nil:
  let win = cast[GtkWindow](node.data)
  echo "Окно: ", gtk_window_get_title(win)
  node = node.next
# Освобождать не нужно — список принадлежит приложению
```

### 9.6 GdkRGBA — работа с цветом

```nim
# Конструирование вручную:
var red = GdkRGBA(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)

# Парсинг из CSS-строки:
var color: GdkRGBA
if gdk_rgba_parse(addr color, "#3498db") != FALSE:
  echo "R=", color.red, " G=", color.green, " B=", color.blue

# Конвертация в строку:
let cssStr = gdk_rgba_to_string(addr color)
# Вернёт "rgb(52,152,219)"
```

### 9.7 Иерархия наследования GTK4

```
GObject
  └── GInitiallyUnowned
        └── GtkWidget           ← базовый класс виджетов
              ├── GtkWindow
              │     └── GtkApplicationWindow
              ├── GtkBox
              ├── GtkGrid
              ├── GtkButton
              │     ├── GtkToggleButton
              │     │     └── GtkCheckButton
              │     └── GtkMenuButton
              ├── GtkLabel
              ├── GtkEntry
              ├── GtkRange
              │     └── GtkScale
              ├── GtkListBox
              ├── GtkListView
              ├── GtkColumnView
              ├── GtkDrawingArea
              └── ...
```

> Приведение **вверх** по иерархии всегда безопасно. Приведение **вниз** (downcasting) допустимо только если тип точно известен — неверный `cast` приводит к аварийному завершению.

---

## Приложение A. Сводные таблицы

### A.1 Все pointer-типы обёртки

| Тип | Категория | Примечание |
|---|---|---|
| `GtkWidget` | Базовый | Базовый тип для всех cast |
| `GtkWindow` | Окно | |
| `GtkApplicationWindow` | Окно | Реализует GActionMap |
| `GtkDialog` | Диалог | Устаревает в GTK4 |
| `GtkAboutDialog` | Диалог | |
| `GtkMessageDialog` | Диалог | Устаревает в GTK4 |
| `GtkFileChooserDialog` | Диалог | Устаревает → GtkFileDialog |
| `GtkColorChooserDialog` | Диалог | Устаревает → GtkColorDialog |
| `GtkFontChooserDialog` | Диалог | Устаревает → GtkFontDialog |
| `GtkBox` | Контейнер | H/V через GtkOrientation |
| `GtkGrid` | Контейнер | Сетка col×row |
| `GtkFixed` | Контейнер | Фиксированные координаты |
| `GtkPaned` | Контейнер | Сплиттер |
| `GtkStack` | Контейнер | Переключаемые страницы |
| `GtkStackSwitcher` | Контейнер | Кнопки переключения Stack |
| `GtkNotebook` | Контейнер | Вкладки |
| `GtkExpander` | Контейнер | Раскрывается |
| `GtkFrame` | Контейнер | С рамкой |
| `GtkAspectFrame` | Контейнер | Фиксированное соотношение сторон |
| `GtkScrolledWindow` | Контейнер | Прокрутка |
| `GtkViewport` | Контейнер | Адаптер прокрутки |
| `GtkOverlay` | Контейнер | Наложения |
| `GtkCenterBox` | Контейнер | 3 слота: start/center/end |
| `GtkButton` | Кнопка | |
| `GtkToggleButton` | Кнопка | 2 состояния |
| `GtkCheckButton` | Кнопка | Флажок / радио |
| `GtkSwitch` | Кнопка | On/Off |
| `GtkMenuButton` | Кнопка | Открывает Popover |
| `GtkLinkButton` | Кнопка | Открывает URL |
| `GtkScaleButton` | Кнопка | Со ползунком |
| `GtkVolumeButton` | Кнопка | Громкость |
| `GtkLabel` | Текст | Markup, ellipsis |
| `GtkEntry` | Текст | Однострочный ввод |
| `GtkPasswordEntry` | Текст | Скрывает символы |
| `GtkSearchEntry` | Текст | С кнопкой очистки |
| `GtkTextView` | Текст | Многострочный |
| `GtkTextBuffer` | Текст | Модель TextVIew |
| `GtkTextMark` | Текст | Якорь в буфере |
| `GtkTextTag` | Текст | Форматирование |
| `GtkTextTagTable` | Текст | Таблица тегов |
| `GtkInscription` | Текст | GTK 4.8+, улучшенная обрезка |
| `GtkDropDown` | Список | Выпадающий GTK4 |
| `GtkListBox` | Список | С фильтром/сортировкой |
| `GtkListBoxRow` | Список | Строка в ListBox |
| `GtkFlowBox` | Список | Перетекающий |
| `GtkFlowBoxChild` | Список | Элемент FlowBox |
| `GtkListView` | Список | Виртуализация GTK4 |
| `GtkColumnView` | Список | Таблица GTK4 |
| `GtkTreeView` | Список | Устарел в GTK4 |
| `GtkListStore` | Список | Устарел в GTK4 |
| `GtkTreeStore` | Список | Устарел в GTK4 |
| `GtkImage` | Отображение | Иконка/изображение |
| `GtkPicture` | Отображение | GdkPaintable |
| `GtkProgressBar` | Отображение | Прогресс |
| `GtkLevelBar` | Отображение | Уровень |
| `GtkSpinner` | Отображение | Анимация загрузки |
| `GtkSeparator` | Отображение | Разделитель |
| `GtkDrawingArea` | Рисование | Cairo/snapshot |
| `GtkGLArea` | Рисование | OpenGL |
| `GtkSpinButton` | Числа | Ввод с кнопками |
| `GtkScale` | Числа | Ползунок |
| `GtkAdjustment` | Числа | Диапазон значений |
| `GtkCalendar` | Прочее | Выбор даты |
| `GtkHeaderBar` | Панель | Заголовок окна |
| `GtkActionBar` | Панель | Нижняя панель |
| `GtkSearchBar` | Панель | Поиск |
| `GtkPopover` | Всплывающее | Произвольный контент |
| `GtkPopoverMenu` | Всплывающее | На основе GMenuModel |
| `GtkCssProvider` | Стиль | Загружает CSS |
| `GtkStyleContext` | Стиль | Контекст стилей |
| `GtkApplication` | GIO | Приложение GTK |
| `GApplication` | GIO | Базовое приложение |
| `GMenu` | GIO | Изменяемое меню |
| `GMenuItem` | GIO | Элемент меню |
| `GMenuModel` | GIO | Интерфейс модели меню |
| `GSimpleAction` | GIO | Конкретный GAction |
| `GAction` | GIO | Интерфейс действия |
| `GActionMap` | GIO | Карта действий |
| `GActionGroup` | GIO | Группа действий |
| `GFile` | GIO | Файл или URI |
| `GBytes` | GIO | Буфер байт |
| `GdkDisplay` | GDK | Дисплей системы |
| `GdkTexture` | GDK | GPU-текстура |
| `GdkPixbuf` | GDK | Пиксельный буфер |
| `GdkClipboard` | GDK | Буфер обмена |
| `cairo_t` | Cairo | Контекст рисования |
| `cairo_surface_t` | Cairo | Поверхность Cairo |

### A.2 Struct-типы (передаются по значению)

| Тип | Поля | Использование |
|---|---|---|
| `GdkRectangle` | `x, y, width, height: gint` | Координаты, области виджетов |
| `GdkRGBA` | `red, green, blue, alpha: gdouble` [0.0–1.0] | Цвет в RGBA |
| `GtkTextIter` | 14 непрозрачных полей | Позиция в TextBuffer |
| `GtkTreeIter` | `stamp: gint`, `userData: gpointer` ×3 | Строка в TreeModel (устарел) |
| `GList` | `data: gpointer`, `next/prev: ptr GList` | Двусвязный список GLib |
| `GSList` | `data: gpointer`, `next: ptr GSList` | Односвязный список GLib |
| `GSignalQuery` | `signalId, signalName, itype, flags, returnType, nParams, paramTypes` | Метаданные сигнала |
| `GActionEntry` | `name, activate, parameter_type, state, change_state` | Запись действия |

### A.3 Distinct pointer типы (типобезопасные)

| Тип | Описание |
|---|---|
| `PangoAttrList` | Список атрибутов Pango |
| `PangoLayout` | Разметка текста Pango |
| `PangoTabArray` | Позиции табуляции |
| `PangoContext` | Контекст шрифтов |
| `GtkEntryBuffer` | Буфер Entry |
| `GtkEntryCompletion` | Автодополнение Entry (устарело) |
| `GIcon` | Иконка GIO |

### A.4 Шпаргалка cast-приведений

```nim
# К GtkWidget (вверх — всегда безопасно):
cast[GtkWidget](btn)
cast[GtkWidget](lbl)
cast[GtkWidget](win)

# К конкретному типу (вниз — только если тип известен):
cast[GtkButton](widget)
cast[GtkWindow](widget)
cast[GtkLabel](widget)

# К GApplication:
cast[GApplication](app)           # GtkApplication → GApplication

# К GActionMap (для добавления действий):
cast[GActionMap](win)             # GtkApplicationWindow → GActionMap
cast[GActionMap](app)             # GtkApplication → GActionMap

# К GActionGroup:
cast[GActionGroup](win)

# Nim-тип из gpointer:
cast[ptr MyType](userData)
cast[cstring](userData)
```

---

## Приложение B. Диагностика и отладка

### B.1 GTK Inspector

GTK Inspector — встроенный инструмент визуальной отладки GTK4. Позволяет инспектировать дерево виджетов, CSS, действия и рендеринг.

```bash
# Запуск из командной строки:
GTK_DEBUG=interactive ./myapp

# Горячие клавиши в работающем приложении:
# Ctrl+Shift+D — открыть Inspector
# Ctrl+Shift+I — выбрать виджет под курсором
```

```nim
# Из кода:
gtk_set_debug_flags(GTK_DEBUG_INTERACTIVE)
```

### B.2 Проверка версии GTK

```nim
import libGTK4

proc checkVersion() =
  let major = gtk_get_major_version()
  let minor = gtk_get_minor_version()
  let micro = gtk_get_micro_version()
  echo "GTK версия: ", major, ".", minor, ".", micro

  # Проверить минимальную версию:
  let err = gtk_check_version(4, 12, 0)
  if err != nil:
    echo "Предупреждение: ", $err

  # Проверить инициализацию:
  if gtk_is_initialized() != FALSE:
    echo "GTK инициализирован"
```

### B.3 Управление памятью

```nim
# Увеличить счётчик ссылок:
let r = g_object_ref(obj)      # возвращает тот же объект

# Уменьшить счётчик ссылок:
g_object_unref(obj)

# Вспомогательные функции обёртки:
safeUnref(myWidget)    # уменьшает счётчик и обнуляет переменную
let r = safeRef(obj)   # увеличивает счётчик, nil-безопасно

# Типичные ошибки памяти:
# 1. Двойной unref → crash (SIGSEGV)
# 2. Использование после unref → use-after-free
# 3. Забыть unref → утечка памяти

# GTK автоматически управляет памятью виджетов:
# - Виджеты, добавленные в контейнер, принадлежат контейнеру
# - При уничтожении родителя дочерние виджеты освобождаются
```

### B.4 Переменные окружения GTK

| Переменная | Пример | Описание |
|---|---|---|
| `GTK_DEBUG` | `interactive,layout` | Флаги отладки GTK |
| `GTK_THEME` | `Adwaita:dark` | Принудительная тема |
| `GTK_PATH` | `/usr/lib/gtk-4.0` | Дополнительные пути поиска |
| `GDK_BACKEND` | `wayland`, `x11`, `win32` | Принудительный бэкенд |
| `GDK_SCALE` | `2` | Масштаб HiDPI |
| `G_MESSAGES_DEBUG` | `all` | Вывод отладочных сообщений GLib |

---

*Следующая часть: [Часть 2 — Инициализация, приложение, окна, сигналы, базовые виджеты](gtk4_nim_docs_part2.md)*
