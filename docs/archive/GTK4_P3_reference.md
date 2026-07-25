# Справочник функций GTK4 — обёртка на языке Nim

> **Файл:** `libGTK4_p3.nim`  
> **Платформа:** Linux / Windows (GTK 4.x)  
> **Язык обёртки:** Nim  
> **Назначение:** Низкоуровневые привязки к библиотеке GTK4, GLib, GDK, Cairo, Pango через механизм `importc`

---

## Содержание

1. [Базовые типы данных](#1-базовые-типы-данных)
2. [Перечисления (Enums)](#2-перечисления-enums)
3. [Константы](#3-константы)
4. [Цвета — GdkRGBA утилиты](#4-цвета--gdkrgba-утилиты)
5. [Таймеры и idle-функции](#5-таймеры-и-idle-функции)
6. [Буфер обмена (Clipboard)](#6-буфер-обмена-clipboard)
7. [Работа с файлами — GFile](#7-работа-с-файлами--gfile)
8. [GtkApplication](#8-gtkapplication)
9. [GtkWindow и GtkApplicationWindow](#9-gtkwindow-и-gtkapplicationwindow)
10. [Виджеты — общие свойства](#10-виджеты--общие-свойства)
11. [Контейнеры — GtkBox, GtkGrid, GtkPaned](#11-контейнеры--gtkbox-gtkgrid-gtkpaned)
12. [Стек и переключатель — GtkStack / GtkStackSwitcher](#12-стек-и-переключатель--gtkstack--gtkstackswitcher)
13. [Записная книжка — GtkNotebook](#13-записная-книжка--gtknotebook)
14. [Прокрутка — GtkScrolledWindow](#14-прокрутка--gtkscrolledwindow)
15. [Кнопки](#15-кнопки)
16. [Текстовые метки — GtkLabel](#16-текстовые-метки--gtklabel)
17. [Однострочный ввод — GtkEntry](#17-однострочный-ввод--gtkentry)
18. [Многострочный редактор — GtkTextView / GtkTextBuffer](#18-многострочный-редактор--gtktextview--gtktextbuffer)
19. [Выпадающий список — GtkComboBoxText](#19-выпадающий-список--gtkcomboboxtext)
20. [Список — GtkListBox](#20-список--gtklistbox)
21. [Таблица — GtkTreeView / GtkListStore](#21-таблица--gtktreeview--gtkliststore)
22. [Изображения — GtkImage, GtkPicture](#22-изображения--gtkimage-gtkpicture)
23. [Прогресс и уровень — GtkProgressBar, GtkLevelBar](#23-прогресс-и-уровень--gtkprogressbar-gtklevelbar)
24. [Числовой ввод — GtkSpinButton, GtkScale](#24-числовой-ввод--gtkspinbutton-gtkscale)
25. [Диалоги](#25-диалоги)
26. [Заголовок окна — GtkHeaderBar](#26-заголовок-окна--gtkheaderbar)
27. [Панель действий — GtkActionBar](#27-панель-действий--gtkactionbar)
28. [Поиск — GtkSearchBar, GtkSearchEntry](#28-поиск--gtksearchbar-gtksearchentry)
29. [Всплывающее меню — GtkPopover, GtkPopoverMenu](#29-всплывающее-меню--gtkpopover-gtkpopovermenu)
30. [Рисование — GtkDrawingArea + Cairo](#30-рисование--gtkdrawingarea--cairo)
31. [CSS стилизация](#31-css-стилизация)
32. [Сигналы GObject — g_signal_*](#32-сигналы-gobject--g_signal_)
33. [Управление памятью — g_object_ref / unref](#33-управление-памятью--g_object_ref--unref)
34. [GtkBuilder — загрузка UI из XML](#34-gtkbuilder--загрузка-ui-из-xml)
35. [Жесты и контроллеры событий](#35-жесты-и-контроллеры-событий)
36. [Меню и действия — GMenu, GAction](#36-меню-и-действия--gmenu-gaction)
37. [Настройки приложения — GtkSettings](#37-настройки-приложения--gtksettings)
38. [Утилиты отладки](#38-утилиты-отладки)
39. [GtkCalendar](#39-gtkcalendar)
40. [GtkExpander, GtkFrame, GtkOverlay](#40-gtkexpander-gtkframe-gtkoverlay)
41. [Шаблоны и вспомогательные конструкции](#41-шаблоны-и-вспомогательные-конструкции)
42. [Roaring Bitmap API](#42-roaring-bitmap-api)
43. [GTK Inspector API](#43-gtk-inspector-api)
44. [Доступность (Accessibility) — AT-SPI / AT-Context](#44-доступность-accessibility--at-spi--at-context)
45. [Печать — GtkPrintDialog, GtkPrintSettings](#45-печать--gtkprintdialog-gtksettings)
46. [Быстрые рецепты (Recipes)](#46-быстрые-рецепты-recipes)

---

## 1. Базовые типы данных

Обёртка вводит псевдонимы для всех C-типов GLib/GTK, чтобы сохранить совместимость с `importc`.

| Nim-тип | C-эквивалент | Описание |
|---------|-------------|----------|
| `gboolean` | `gint` / `int32` | Булевый тип GTK (0=FALSE, 1=TRUE) |
| `gint` | `int32` | Целое со знаком 32 бит |
| `guint` | `uint32` | Целое без знака 32 бит |
| `gchar` | `char` | Символ |
| `gdouble` | `float64` | Число с плавающей точкой 64 бит |
| `gfloat` | `float32` | Число с плавающей точкой 32 бит |
| `gpointer` | `pointer` | Обобщённый указатель |
| `gunichar` | `uint32` | Юникод-символ |
| `GtkWidget` | `pointer` | Базовый виджет |
| `GtkWindow` | `pointer` | Окно |
| `GtkTextIter` | struct (14 полей) | Итератор позиции в тексте |
| `GtkTreeIter` | struct (4 поля) | Итератор строки дерева/списка |
| `GdkRGBA` | struct {r,g,b,a: float64} | Цвет |
| `GdkRectangle` | struct {x,y,w,h: gint} | Прямоугольник |
| `cairo_t` | `pointer` | Контекст рисования Cairo |

**Важно:** Большинство типов виджетов — это просто `pointer`. Это означает, что тип-проверка на уровне компилятора ограничена. Разработчик сам отвечает за передачу правильного объекта.

---

## 2. Перечисления (Enums)

### `GtkOrientation`
Направление компоновки виджета.

| Значение | Число | Применение |
|----------|-------|-----------|
| `GTK_ORIENTATION_HORIZONTAL` | 0 | Горизонтально (GtkBox, Paned и др.) |
| `GTK_ORIENTATION_VERTICAL` | 1 | Вертикально |

```nim
let box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 6)
```

### `GtkAlign`
Выравнивание виджета внутри контейнера.

| Значение | Число | Описание |
|----------|-------|---------|
| `GTK_ALIGN_FILL` | 0 | Растянуть по всей доступной площади |
| `GTK_ALIGN_START` | 1 | Прижать к началу (left/top) |
| `GTK_ALIGN_END` | 2 | Прижать к концу (right/bottom) |
| `GTK_ALIGN_CENTER` | 3 | Центрировать |
| `GTK_ALIGN_BASELINE` | 4 | По базовой линии текста |

```nim
gtk_widget_set_halign(label, GTK_ALIGN_CENTER)
gtk_widget_set_valign(label, GTK_ALIGN_START)
```

### `GtkJustification`
Выравнивание текста внутри метки или буфера.

| Значение | Описание |
|----------|---------|
| `GTK_JUSTIFY_LEFT` | По левому краю |
| `GTK_JUSTIFY_RIGHT` | По правому краю |
| `GTK_JUSTIFY_CENTER` | По центру |
| `GTK_JUSTIFY_FILL` | По ширине (justify) |

### `GtkWrapMode`
Режим переноса строк.

| Значение | Описание |
|----------|---------|
| `GTK_WRAP_NONE` | Без переноса |
| `GTK_WRAP_CHAR` | Перенос по символам |
| `GTK_WRAP_WORD` | Перенос по словам |
| `GTK_WRAP_WORD_CHAR` | По словам, затем по символам |

### `GtkResponseType`
Коды ответа диалогового окна.

| Значение | Число | Смысл |
|----------|-------|-------|
| `GTK_RESPONSE_OK` | -5 | Нажата кнопка OK |
| `GTK_RESPONSE_CANCEL` | -6 | Нажата Отмена |
| `GTK_RESPONSE_CLOSE` | -7 | Закрытие |
| `GTK_RESPONSE_YES` | -8 | Да |
| `GTK_RESPONSE_NO` | -9 | Нет |
| `GTK_RESPONSE_DELETE_EVENT` | -4 | Закрытие через крестик |

### `GtkFileChooserAction`
Режим диалога выбора файлов.

| Значение | Описание |
|----------|---------|
| `GTK_FILE_CHOOSER_ACTION_OPEN` | Открыть файл |
| `GTK_FILE_CHOOSER_ACTION_SAVE` | Сохранить файл |
| `GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER` | Выбрать папку |

### `GtkSelectionMode`
Режим выбора элементов в списке.

| Значение | Описание |
|----------|---------|
| `GTK_SELECTION_NONE` | Выбор запрещён |
| `GTK_SELECTION_SINGLE` | Только один элемент |
| `GTK_SELECTION_BROWSE` | Один элемент, всегда выбранный |
| `GTK_SELECTION_MULTIPLE` | Несколько элементов |

### `GtkStackTransitionType`
Эффекты перехода для GtkStack (19 вариантов).

```nim
gtk_stack_set_transition_type(stack, GTK_STACK_TRANSITION_TYPE_CROSSFADE)
gtk_stack_set_transition_type(stack, GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT)
gtk_stack_set_transition_type(stack, GTK_STACK_TRANSITION_TYPE_OVER_UP)
```

### `GApplicationFlags`
Флаги режима работы GApplication.

| Значение | Описание |
|----------|---------|
| `G_APPLICATION_FLAGS_NONE` | Стандартный режим |
| `G_APPLICATION_HANDLES_OPEN` | Приложение обрабатывает открытие файлов |
| `G_APPLICATION_NON_UNIQUE` | Допускает несколько экземпляров |

### `GBindingFlags`
Флаги привязки свойств GObject.

| Значение | Описание |
|----------|---------|
| `G_BINDING_DEFAULT` | Однонаправленная |
| `G_BINDING_BIDIRECTIONAL` | Двунаправленная |
| `G_BINDING_SYNC_CREATE` | Синхронизировать сразу при создании |
| `G_BINDING_INVERT_BOOLEAN` | Инвертировать булево значение |

---

## 3. Константы

### G_TYPE_* — типы GObject

Используются при создании GtkListStore и передаче типов колонок.

```nim
const
  G_TYPE_BOOLEAN* = 5 shl 2   # 20
  G_TYPE_INT*     = 6 shl 2   # 24
  G_TYPE_DOUBLE*  = 15 shl 2  # 60
  G_TYPE_STRING*  = 16 shl 2  # 64
  G_TYPE_OBJECT*  = 20 shl 2  # 80
```

**Пример:**
```nim
let store = gtk_list_store_newv(3, [G_TYPE_STRING, G_TYPE_INT, G_TYPE_BOOLEAN][0].addr)
```

### GTK_STYLE_PROVIDER_PRIORITY_*
Приоритеты CSS-провайдеров.

| Константа | Значение | Описание |
|-----------|---------|---------|
| `GTK_STYLE_PROVIDER_PRIORITY_FALLBACK` | 1 | Самый низкий (запасные стили) |
| `GTK_STYLE_PROVIDER_PRIORITY_THEME` | 200 | Стили темы |
| `GTK_STYLE_PROVIDER_PRIORITY_SETTINGS` | 400 | Стили из настроек |
| `GTK_STYLE_PROVIDER_PRIORITY_APPLICATION` | 600 | Стили приложения |
| `GTK_STYLE_PROVIDER_PRIORITY_USER` | 800 | Пользовательские стили |

### Стандартные иконки

```nim
ICON_DOCUMENT_NEW*    = "document-new"
ICON_DOCUMENT_OPEN*   = "document-open"
ICON_DOCUMENT_SAVE*   = "document-save"
ICON_EDIT_COPY*       = "edit-copy"
ICON_EDIT_CUT*        = "edit-cut"
ICON_EDIT_PASTE*      = "edit-paste"
ICON_EDIT_UNDO*       = "edit-undo"
ICON_EDIT_REDO*       = "edit-redo"
ICON_LIST_ADD*        = "list-add"
ICON_LIST_REMOVE*     = "list-remove"
ICON_DIALOG_ERROR*    = "dialog-error"
ICON_DIALOG_WARNING*  = "dialog-warning"
ICON_DIALOG_INFORMATION* = "dialog-information"
```

**Применение:**
```nim
let btn = gtk_button_new_from_icon_name(ICON_DOCUMENT_SAVE)
```

---

## 4. Цвета — GdkRGBA утилиты

### `parseColor(colorStr: string): GdkRGBA`
**Что делает:** Разбирает строку цвета в структуру GdkRGBA.  
**Когда использовать:** Когда цвет задаётся пользователем или хранится в конфиге как строка.  
**Поддерживаемые форматы:** `"red"`, `"#FF0000"`, `"rgb(255,0,0)"`, `"rgba(255,0,0,0.5)"`.  
**Результат:** Структура `GdkRGBA`.

```nim
let red = parseColor("#FF0000")
let transparentBlue = parseColor("rgba(0,0,255,0.5)")
let namedColor = parseColor("darkgreen")
```

### `rgba(r, g, b: float, a = 1.0): GdkRGBA`
**Что делает:** Создаёт цвет из компонентов в диапазоне `0.0..1.0`.  
**Когда использовать:** Когда компоненты уже вычислены в нормализованном диапазоне.  
**Результат:** `GdkRGBA`.

```nim
let semiTransparent = rgba(0.0, 0.5, 1.0, 0.8)  # голубой 80% непрозрачный
let opaque = rgba(1.0, 0.0, 0.0)                 # чисто красный
```

### `rgb(r, g, b: int): GdkRGBA`
**Что делает:** Создаёт непрозрачный цвет из компонентов `0..255`.  
**Когда использовать:** Удобно при работе с HTML-цветами или значениями из пипетки.  
**Результат:** `GdkRGBA` с `alpha = 1.0`.

```nim
let crimson = rgb(220, 20, 60)
let forestGreen = rgb(34, 139, 34)
```

---

## 5. Таймеры и idle-функции

### `addTimeout(interval: int, callback: GSourceFunc, data: pointer = nil): guint`
**Что делает:** Регистрирует периодически вызываемую функцию (в миллисекундах).  
**Когда использовать:** Обновление данных/UI через заданный интервал, анимации, мониторинг.  
**Результат:** ID таймера типа `guint` — используется для его отмены.  
**Важно:** Callback должен возвращать `TRUE` (1) чтобы продолжить, `FALSE` (0) чтобы остановить.

```nim
proc onTick(data: gpointer): gboolean {.cdecl.} =
  echo "Тик каждую секунду"
  result = 1  # продолжить

let timerId = addTimeout(1000, onTick)
```

### `addTimeoutSeconds(interval: int, callback: GSourceFunc, data: pointer = nil): guint`
**Что делает:** Аналог `addTimeout`, но интервал в **секундах**.  
**Когда использовать:** Более экономичный вариант для редких обновлений (экономит CPU).

```nim
let saveId = addTimeoutSeconds(30, autoSaveCallback)
```

### `removeTimeout(timeoutId: guint): bool`
**Что делает:** Останавливает и удаляет таймер по его ID.  
**Когда использовать:** При уничтожении окна, изменении состояния приложения.  
**Результат:** `true` если таймер был найден и удалён.

```nim
if not removeTimeout(timerId):
  echo "Таймер уже завершён"
```

### `addIdle(callback: GSourceFunc, data: pointer = nil): guint`
**Что делает:** Регистрирует функцию, вызываемую когда главный цикл GTK свободен.  
**Когда использовать:** Фоновые задачи, обновление UI после длительной операции, ленивая инициализация.  
**Результат:** ID источника событий.

```nim
proc doBackground(data: gpointer): gboolean {.cdecl.} =
  processNextChunk()
  result = if moreWork(): 1 else: 0

discard addIdle(doBackground)
```

---

## 6. Буфер обмена (Clipboard)

### `setClipboardText(text: string)`
**Что делает:** Копирует строку в системный буфер обмена.  
**Когда использовать:** При нажатии Ctrl+C, кнопки "Копировать", после генерации текста.  
**Результат:** Нет. Текст доступен в любом приложении системы.

```nim
proc onCopyClick(btn: GtkButton, data: pointer) {.cdecl.} =
  setClipboardText("Скопированный текст")
```

### `getClipboardText(callback: GAsyncReadyCallback, userData: pointer = nil)`
**Что делает:** Асинхронно читает текст из буфера обмена.  
**Когда использовать:** При вставке — операция асинхронна из-за возможного межпроцессного взаимодействия.  
**Как использовать результат:** В колбеке вызовите `gdk_clipboard_read_text_finish(clipboard, res, nil)`.

```nim
proc onPasteReady(obj: pointer, res: pointer, userData: gpointer) {.cdecl.} =
  let display = gdk_display_get_default()
  let clipboard = gdk_display_get_clipboard(display)
  let text = gdk_clipboard_read_text_finish(clipboard, res, nil)
  if text != nil:
    echo "Из буфера: ", $text

getClipboardText(onPasteReady)
```

---

## 7. Работа с файлами — GFile

### `createFile(path: string): GFile`
**Что делает:** Создаёт объект GFile из строки пути файловой системы.  
**Когда использовать:** Открытие/сохранение файлов, работа с GIO API.  
**Результат:** `GFile` (указатель). Нужно освободить через `g_object_unref`.

```nim
let file = createFile("/home/user/document.txt")
defer: g_object_unref(file)
```

### `getFilePath(file: GFile): string`
**Что делает:** Извлекает строку пути из объекта GFile.  
**Когда использовать:** После выбора файла в диалоге FileChooser.  
**Результат:** Строка пути Nim, или пустая строка если путь не доступен (например, для URI).

```nim
let path = getFilePath(selectedFile)
if path.len > 0:
  writeFile(path, content)
```

---

## 8. GtkApplication

### `gtk_application_new(appId: cstring, flags: GApplicationFlags): GtkApplication`
**Что делает:** Создаёт главный объект GTK-приложения.  
**Когда использовать:** Всегда — это точка входа любого GTK4 приложения.  
**Параметры:**
- `appId` — обратный DNS-идентификатор: `"com.example.MyApp"`
- `flags` — обычно `G_APPLICATION_DEFAULT_FLAGS` (= 0)

**Результат:** Объект `GtkApplication`.

```nim
let app = gtk_application_new("com.mycompany.app", G_APPLICATION_DEFAULT_FLAGS)
```

### `g_application_run(app: GApplication, argc: cint, argv: cstringArray): cint`
**Что делает:** Запускает главный цикл событий GTK.  
**Когда использовать:** После создания приложения и подключения сигнала `"activate"`.  
**Результат:** Код выхода приложения (0 = успех).

```nim
proc onActivate(app: GtkApplication, data: pointer) {.cdecl.} =
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Моё приложение")
  gtk_window_set_default_size(window, 800, 600)
  gtk_widget_show(window)

discard g_signal_connect(app, "activate", cast[GCallback](onActivate), nil)
let status = g_application_run(cast[GApplication](app), 0, nil)
```

### `gtk_application_window_new(app: GtkApplication): GtkWidget`
**Что делает:** Создаёт главное окно, связанное с приложением.  
**Когда использовать:** Вместо `gtk_window_new` — автоматически регистрируется в приложении.  
**Результат:** `GtkWidget` (GtkApplicationWindow).

```nim
let window = gtk_application_window_new(app)
```

---

## 9. GtkWindow и GtkApplicationWindow

### `gtk_window_new(): GtkWidget`
**Что делает:** Создаёт новое независимое окно верхнего уровня.  
**Когда использовать:** Для дополнительных окон (не главного).

### `gtk_window_set_title(window: GtkWindow, title: cstring)`
**Что делает:** Устанавливает заголовок окна в строке заголовка.  
**Результат:** Нет возвращаемого значения.

```nim
gtk_window_set_title(window, "Редактор документов")
```

### `gtk_window_set_default_size(window: GtkWindow, width: gint, height: gint)`
**Что делает:** Задаёт начальный размер окна в пикселях.  
**Важно:** Это желаемый размер, пользователь может изменить его. Для фиксированного размера используйте `gtk_window_set_resizable(window, FALSE)`.

```nim
gtk_window_set_default_size(window, 1024, 768)
```

### `gtk_window_set_resizable(window: GtkWindow, resizable: gboolean)`
**Что делает:** Запрещает или разрешает изменение размера окна.

```nim
gtk_window_set_resizable(window, FALSE)
```

### `gtk_window_maximize(window: GtkWindow)` / `gtk_window_minimize(window: GtkWindow)`
**Что делает:** Разворачивает/сворачивает окно.

```nim
gtk_window_maximize(mainWindow)
```

### `gtk_window_present(window: GtkWindow)`
**Что делает:** Поднимает окно на передний план и показывает его.  
**Когда использовать:** При повторном открытии уже существующего окна.

### `gtk_window_destroy(window: GtkWindow)`
**Что делает:** Закрывает и уничтожает окно и все его дочерние виджеты.  
**Когда использовать:** Принудительное закрытие окна программно.

### `gtk_window_set_modal(window: GtkWindow, modal: gboolean)`
**Что делает:** Делает окно модальным (блокирует родительское окно).

```nim
let dialog = gtk_window_new()
gtk_window_set_modal(dialog, TRUE)
gtk_window_set_transient_for(dialog, parentWindow)
```

### `gtk_window_set_transient_for(window, parent: GtkWindow)`
**Что делает:** Связывает окно с родительским — они держатся вместе, диалог центрируется над родителем.

### `gtk_application_window_get_id(window: pointer): pointer`
**Что делает:** Возвращает числовой ID окна в рамках приложения.

---

## 10. Виджеты — общие свойства

Все функции этого раздела применимы к **любому** виджету GTK4.

### `gtk_widget_show(widget: GtkWidget)`
**Что делает:** Делает виджет видимым.  
**В GTK4:** Виджеты видимы по умолчанию после `gtk_window_present`. Но дочерние виджеты могут быть скрыты явно.

### `gtk_widget_hide(widget: GtkWidget)`
**Что делает:** Скрывает виджет, сохраняя место в компоновке (в большинстве контейнеров).

### `gtk_widget_set_visible(widget: GtkWidget, visible: gboolean)`
**Что делает:** Устанавливает видимость виджета.

```nim
gtk_widget_set_visible(statusBar, if showStatus: TRUE else: FALSE)
```

### `gtk_widget_get_visible(widget: GtkWidget): gboolean`
**Что делает:** Возвращает текущую видимость виджета.

### `gtk_widget_set_sensitive(widget: GtkWidget, sensitive: gboolean)`
**Что делает:** Включает или отключает виджет.  
**Когда использовать:** Блокировать кнопки когда действие недоступно.

```nim
gtk_widget_set_sensitive(saveButton, if hasChanges: TRUE else: FALSE)
```

### `gtk_widget_get_sensitive(widget: GtkWidget): gboolean`
**Что делает:** Возвращает активно ли взаимодействие с виджетом.

### `gtk_widget_set_size_request(widget: GtkWidget, width: gint, height: gint)`
**Что делает:** Устанавливает минимальный размер виджета.  
**Передайте -1** чтобы оставить размер автоматическим по одной или обеим осям.

```nim
gtk_widget_set_size_request(button, 120, 40)
gtk_widget_set_size_request(canvas, 800, -1)  # только ширина
```

### `gtk_widget_get_size_request(widget: GtkWidget, width, height: ptr gint)`
**Что делает:** Читает текущий запрошенный размер.

```nim
var w, h: gint
gtk_widget_get_size_request(widget, addr w, addr h)
echo "Минимум: ", w, "x", h
```

### `gtk_widget_set_halign(widget: GtkWidget, align: GtkAlign)` / `gtk_widget_set_valign`
**Что делает:** Устанавливает горизонтальное/вертикальное выравнивание виджета.

```nim
gtk_widget_set_halign(label, GTK_ALIGN_CENTER)
gtk_widget_set_valign(label, GTK_ALIGN_CENTER)
```

### `gtk_widget_set_hexpand(widget: GtkWidget, expand: gboolean)` / `gtk_widget_set_vexpand`
**Что делает:** Разрешает виджету расширяться горизонтально/вертикально при наличии свободного места.

```nim
gtk_widget_set_hexpand(textView, TRUE)
gtk_widget_set_vexpand(textView, TRUE)
```

### `gtk_widget_set_margin_start / _end / _top / _bottom`
**Что делает:** Устанавливает поля вокруг виджета в пикселях.

```nim
gtk_widget_set_margin_start(widget, 12)
gtk_widget_set_margin_end(widget, 12)
gtk_widget_set_margin_top(widget, 6)
gtk_widget_set_margin_bottom(widget, 6)
```

### `gtk_widget_add_css_class(widget: GtkWidget, cssClass: cstring)`
**Что делает:** Добавляет CSS-класс к виджету для стилизации.

```nim
gtk_widget_add_css_class(button, "suggested-action")  # синяя кнопка
gtk_widget_add_css_class(button, "destructive-action") # красная кнопка
```

### `gtk_widget_get_name(widget: GtkWidget): cstring`
**Что делает:** Возвращает имя виджета (задаётся через `gtk_widget_set_name`).

### `gtk_widget_set_name(widget: GtkWidget, name: cstring)`
**Что делает:** Присваивает имя виджету — используется в CSS (`#myButton { color: red; }`).

### `gtk_widget_get_first_child(widget: GtkWidget): GtkWidget` / `gtk_widget_get_next_sibling`
**Что делает:** Обходит дерево виджетов — первый дочерний, следующий сосед.

```nim
var child = gtk_widget_get_first_child(container)
while child != nil:
  doSomething(child)
  child = gtk_widget_get_next_sibling(child)
```

### `gtk_widget_add_controller(widget: GtkWidget, controller: GtkEventController)`
**Что делает:** Подключает контроллер событий к виджету.  
**Используется с:** жестами (GtkGestureClick), клавиатурой (GtkEventControllerKey), движением мыши.

---

## 11. Контейнеры — GtkBox, GtkGrid, GtkPaned

### GtkBox — линейный контейнер

#### `gtk_box_new(orientation: GtkOrientation, spacing: gint): GtkWidget`
**Что делает:** Создаёт вертикальный или горизонтальный ящик для компоновки.  
**Параметры:**
- `orientation` — `GTK_ORIENTATION_HORIZONTAL` или `GTK_ORIENTATION_VERTICAL`
- `spacing` — расстояние в пикселях между дочерними виджетами

```nim
let vbox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 6)
let hbox = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 12)
```

#### `gtk_box_append(box: GtkBox, child: GtkWidget)`
**Что делает:** Добавляет виджет в конец ящика.

```nim
gtk_box_append(vbox, label)
gtk_box_append(vbox, entry)
gtk_box_append(vbox, button)
```

#### `gtk_box_prepend(box: GtkBox, child: GtkWidget)`
**Что делает:** Добавляет виджет в начало ящика.

#### `gtk_box_set_spacing(box: GtkBox, spacing: gint)`
**Что делает:** Устанавливает расстояние между дочерними виджетами.

#### `gtk_box_set_homogeneous(box: GtkBox, homogeneous: gboolean)`
**Что делает:** При TRUE все дочерние виджеты получают одинаковый размер.

---

### GtkGrid — сеточный контейнер

#### `gtk_grid_new(): GtkWidget`
**Что делает:** Создаёт сетку для компоновки по строкам и столбцам.

#### `gtk_grid_attach(grid: GtkGrid, child: GtkWidget, column, row, width, height: gint)`
**Что делает:** Размещает виджет в ячейке сетки.  
**Параметры:** `column`, `row` — координаты ячейки; `width`, `height` — количество ячеек, которые занимает виджет.

```nim
let grid = gtk_grid_new()
gtk_grid_set_column_spacing(grid, 12)
gtk_grid_set_row_spacing(grid, 6)

let nameLabel = gtk_label_new("Имя:")
let nameEntry = gtk_entry_new()
gtk_grid_attach(grid, nameLabel, 0, 0, 1, 1)  # колонка 0, строка 0, 1x1
gtk_grid_attach(grid, nameEntry, 1, 0, 2, 1)  # колонка 1, строка 0, 2x1
```

#### `gtk_grid_set_column_spacing(grid: GtkGrid, spacing: guint)` / `gtk_grid_set_row_spacing`
**Что делает:** Задаёт расстояние между колонками/строками.

---

### GtkPaned — разделённый контейнер

#### `gtk_paned_new(orientation: GtkOrientation): GtkWidget`
**Что делает:** Создаёт контейнер с перетаскиваемым разделителем.  
**Когда использовать:** Боковые панели, разделение рабочей области.

#### `gtk_paned_set_start_child(paned: GtkPaned, child: GtkWidget)` / `gtk_paned_set_end_child`
**Что делает:** Задаёт виджеты для первой и второй панелей.

#### `gtk_paned_set_position(paned: GtkPaned, position: gint)`
**Что делает:** Устанавливает положение разделителя в пикселях.

```nim
let paned = gtk_paned_new(GTK_ORIENTATION_HORIZONTAL)
gtk_paned_set_start_child(paned, sidebarScrolled)
gtk_paned_set_end_child(paned, mainArea)
gtk_paned_set_position(paned, 250)
```

---

## 12. Стек и переключатель — GtkStack / GtkStackSwitcher

### `gtk_stack_new(): GtkWidget`
**Что делает:** Создаёт стек — контейнер, показывающий только одну "страницу" за раз.  
**Когда использовать:** Вкладки без панели вкладок, онбординг-экраны, мастер-диалоги.

### `gtk_stack_add_named(stack: GtkStack, child: GtkWidget, name: cstring)`
**Что делает:** Добавляет страницу в стек с заданным именем.

### `gtk_stack_add_titled(stack: GtkStack, child: GtkWidget, name, title: cstring): GtkStackPage`
**Что делает:** Добавляет страницу с именем и заголовком (используется GtkStackSwitcher).

### `gtk_stack_set_visible_child_name(stack: GtkStack, name: cstring)`
**Что делает:** Переключает видимую страницу по имени с анимацией.

### `gtk_stack_set_transition_type(stack: GtkStack, transition: GtkStackTransitionType)`
**Что делает:** Устанавливает тип анимации перехода между страницами.

### `gtk_stack_switcher_new(): GtkWidget`
**Что делает:** Создаёт панель кнопок для переключения страниц стека.

### `gtk_stack_switcher_set_stack(switcher: GtkStackSwitcher, stack: GtkStack)`
**Что делает:** Связывает переключатель со стеком.

```nim
let stack = gtk_stack_new()
gtk_stack_set_transition_type(stack, GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT_RIGHT)
gtk_stack_set_transition_duration(stack, 300)

discard gtk_stack_add_titled(stack, homePage, "home", "Главная")
discard gtk_stack_add_titled(stack, settingsPage, "settings", "Настройки")

let switcher = gtk_stack_switcher_new()
gtk_stack_switcher_set_stack(switcher, stack)

# Показать главную страницу
gtk_stack_set_visible_child_name(stack, "home")
```

---

## 13. Записная книжка — GtkNotebook

### `gtk_notebook_new(): GtkWidget`
**Что делает:** Создаёт виджет вкладок (notebook).

### `gtk_notebook_append_page(notebook: GtkNotebook, child, tabLabel: GtkWidget): gint`
**Что делает:** Добавляет страницу с заданным виджетом-вкладкой.  
**Результат:** Индекс новой страницы.

### `gtk_notebook_set_current_page(notebook: GtkNotebook, pageNum: gint)`
**Что делает:** Переключает на страницу по индексу.

### `gtk_notebook_get_current_page(notebook: GtkNotebook): gint`
**Что делает:** Возвращает индекс текущей страницы.

### `gtk_notebook_remove_page(notebook: GtkNotebook, pageNum: gint)`
**Что делает:** Удаляет страницу по индексу.

```nim
let notebook = gtk_notebook_new()
gtk_notebook_set_tab_pos(notebook, GTK_POS_TOP)

let tab1Label = gtk_label_new("Вкладка 1")
let content1  = gtk_label_new("Содержимое вкладки 1")
discard gtk_notebook_append_page(notebook, content1, tab1Label)
```

---

## 14. Прокрутка — GtkScrolledWindow

### `gtk_scrolled_window_new(): GtkWidget`
**Что делает:** Создаёт контейнер с полосами прокрутки.  
**Когда использовать:** Вокруг GtkTextView, GtkTreeView, GtkListBox, больших изображений.

### `gtk_scrolled_window_set_child(scrolled: GtkScrolledWindow, child: GtkWidget)`
**Что делает:** Задаёт виджет внутри прокручиваемой области.

### `gtk_scrolled_window_set_policy(scrolled: GtkScrolledWindow, hPolicy, vPolicy: GtkPolicyType)`
**Что делает:** Управляет видимостью полос прокрутки.

| GtkPolicyType | Описание |
|---------------|---------|
| `GTK_POLICY_ALWAYS` | Полоса всегда видна |
| `GTK_POLICY_AUTOMATIC` | Автоматически при необходимости |
| `GTK_POLICY_NEVER` | Никогда не показывать |

```nim
let scrolled = gtk_scrolled_window_new()
gtk_scrolled_window_set_policy(scrolled, GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
gtk_scrolled_window_set_child(scrolled, textView)
gtk_widget_set_size_request(scrolled, -1, 300)
```

---

## 15. Кнопки

### `gtk_button_new(): GtkWidget`
**Что делает:** Создаёт пустую кнопку.

### `gtk_button_new_with_label(label: cstring): GtkWidget`
**Что делает:** Создаёт кнопку с текстом.

```nim
let okBtn = gtk_button_new_with_label("Сохранить")
```

### `gtk_button_new_with_mnemonic(label: cstring): GtkWidget`
**Что делает:** Кнопка с клавишей быстрого доступа (символ `_` перед буквой = Alt+буква).

```nim
let saveBtn = gtk_button_new_with_mnemonic("_Сохранить")  # Alt+С
```

### `gtk_button_new_from_icon_name(iconName: cstring): GtkWidget`
**Что делает:** Кнопка с иконкой из темы.

```nim
let addBtn = gtk_button_new_from_icon_name(ICON_LIST_ADD)
```

### `gtk_button_set_label(button: GtkButton, label: cstring)`
**Что делает:** Меняет текст на кнопке.

### `gtk_toggle_button_new_with_label(label: cstring): GtkWidget`
**Что делает:** Кнопка-переключатель (toggle) — остаётся нажатой.

### `gtk_toggle_button_get_active(button: GtkToggleButton): gboolean`
**Что делает:** Возвращает текущее состояние toggle-кнопки.

### `gtk_check_button_new_with_label(label: cstring): GtkWidget`
**Что делает:** Чекбокс с подписью.

```nim
let darkModeCheck = gtk_check_button_new_with_label("Тёмная тема")
```

### `gtk_check_button_get_active(button: GtkCheckButton): gboolean`
**Что делает:** Проверяет, отмечен ли чекбокс.

### `gtk_check_button_set_active(button: GtkCheckButton, setting: gboolean)`
**Что делает:** Программно устанавливает состояние чекбокса.

### `gtk_switch_new(): GtkWidget`
**Что делает:** Виджет-переключатель (iOS-стиль On/Off).

### `gtk_switch_get_active(sw: GtkSwitch): gboolean` / `gtk_switch_set_active`
**Что делает:** Читает/устанавливает состояние переключателя.

### `gtk_link_button_new(uri: cstring): GtkWidget`
**Что делает:** Кнопка-гиперссылка.

```nim
let docBtn = gtk_link_button_new("https://docs.gtk.org")
```

---

## 16. Текстовые метки — GtkLabel

### `gtk_label_new(str: cstring): GtkWidget`
**Что делает:** Создаёт текстовую метку.

```nim
let heading = gtk_label_new("Добро пожаловать")
```

### `gtk_label_new_with_mnemonic(str: cstring): GtkWidget`
**Что делает:** Метка с подчёркнутой клавишей (для виджетов рядом с ней).

### `gtk_label_set_text(label: GtkLabel, str: cstring)`
**Что делает:** Меняет текст метки (без разметки).

### `gtk_label_get_text(label: GtkLabel): cstring`
**Что делает:** Читает текущий текст метки.

### `gtk_label_set_markup(label: GtkLabel, str: cstring)`
**Что делает:** Устанавливает текст с Pango-разметкой (жирный, курсив, цвет и т.д.).

```nim
gtk_label_set_markup(label, "<b>Жирный</b> и <i>курсив</i>")
gtk_label_set_markup(label, "<span color='red' size='large'>Ошибка!</span>")
gtk_label_set_markup(label, "<tt>Моноширинный код</tt>")
```

### `gtk_label_set_use_markup(label: GtkLabel, setting: gboolean)`
**Что делает:** Включает/выключает интерпретацию разметки.

### `gtk_label_set_justify(label: GtkLabel, jtype: GtkJustification)`
**Что делает:** Выравнивание многострочного текста.

### `gtk_label_set_wrap(label: GtkLabel, wrap: gboolean)`
**Что делает:** Включает перенос строк.

### `gtk_label_set_wrap_mode(label: GtkLabel, wrapMode: GtkWrapMode)`
**Что делает:** Определяет как переносить строки.

### `gtk_label_set_selectable(label: GtkLabel, setting: gboolean)`
**Что делает:** Разрешает пользователю выделять и копировать текст метки.

### `gtk_label_set_ellipsize(label: GtkLabel, mode: PangoEllipsizeMode)`
**Что делает:** Обрезает длинный текст с многоточием.

```nim
gtk_label_set_ellipsize(filenameLabel, PANGO_ELLIPSIZE_MIDDLE)
# "очень_длинный...путь/файл.txt"
```

### `gtk_label_set_lines(label: GtkLabel, lines: gint)`
**Что делает:** Ограничивает количество отображаемых строк.

### `gtk_label_get_label(self: pointer): pointer`
**Что делает:** Внутренняя версия получения текста с разметкой.

---

## 17. Однострочный ввод — GtkEntry

### `gtk_entry_new(): GtkWidget`
**Что делает:** Создаёт однострочное текстовое поле ввода.

### `gtk_entry_new_with_buffer(buffer: GtkEntryBuffer): GtkWidget`
**Что делает:** Создаёт entry с заданным буфером (полезно для совместного использования текста).

### `gtk_entry_get_text(entry: GtkEntry): cstring`
**Что делает:** Возвращает текущее содержимое поля.

```nim
let userText = $gtk_entry_get_text(nameEntry)
```

### `gtk_entry_set_text(entry: GtkEntry, text: cstring)`
**Что делает:** Программно устанавливает текст в поле.

### `gtk_entry_set_placeholder_text(entry: GtkEntry, text: cstring)`
**Что делает:** Устанавливает подсказку (placeholder), видимую когда поле пустое.

```nim
gtk_entry_set_placeholder_text(searchEntry, "Введите поисковый запрос...")
```

### `gtk_entry_set_visibility(entry: GtkEntry, visible: gboolean)`
**Что делает:** При `FALSE` скрывает текст звёздочками (режим пароля).

```nim
gtk_entry_set_visibility(passwordEntry, FALSE)
```

### `gtk_entry_set_max_length(entry: GtkEntry, max: gint)`
**Что делает:** Ограничивает максимальное количество символов.

### `gtk_entry_set_input_purpose(entry: GtkEntry, purpose: GtkInputPurpose)`
**Что делает:** Подсказывает тип вводимых данных (влияет на экранную клавиатуру).

```nim
gtk_entry_set_input_purpose(phoneEntry, GTK_INPUT_PURPOSE_PHONE)
gtk_entry_set_input_purpose(emailEntry, GTK_INPUT_PURPOSE_EMAIL)
```

### `gtk_entry_set_icon_from_icon_name(entry: GtkEntry, iconPos: GtkEntryIconPosition, iconName: cstring)`
**Что делает:** Добавляет иконку внутри поля ввода (слева или справа).

```nim
gtk_entry_set_icon_from_icon_name(searchEntry, GTK_ENTRY_ICON_PRIMARY, "system-search-symbolic")
```

### `gtk_editable_select_region(editable: GtkWidget, startPos, endPos: gint)`
**Что делает:** Выделяет текст в указанном диапазоне позиций.

---

## 18. Многострочный редактор — GtkTextView / GtkTextBuffer

### `gtk_text_view_new(): GtkWidget`
**Что делает:** Создаёт многострочный текстовый редактор.

### `gtk_text_view_new_with_buffer(buffer: GtkTextBuffer): GtkWidget`
**Что делает:** Создаёт редактор с явно заданным буфером.

### `gtk_text_view_get_buffer(textView: GtkTextView): GtkTextBuffer`
**Что делает:** Возвращает буфер текстового виджета.

```nim
let textView = gtk_text_view_new()
let buffer = gtk_text_view_get_buffer(textView)
```

### `gtk_text_buffer_new(table: GtkTextTagTable): GtkTextBuffer`
**Что делает:** Создаёт буфер текста (обычно с `nil` в качестве таблицы тегов).

### `gtk_text_buffer_set_text(buffer: GtkTextBuffer, text: cstring, len: gint)`
**Что делает:** Полностью заменяет содержимое буфера.

```nim
gtk_text_buffer_set_text(buffer, "Текст документа", -1)  # -1 = автоопределение длины
```

### `gtk_text_buffer_get_text(buffer: GtkTextBuffer, start, end: ptr GtkTextIter, includeHidden: gboolean): cstring`
**Что делает:** Извлекает текст между двумя итераторами.

```nim
var startIter, endIter: GtkTextIter
gtk_text_buffer_get_start_iter(buffer, addr startIter)
gtk_text_buffer_get_end_iter(buffer, addr endIter)
let allText = $gtk_text_buffer_get_text(buffer, addr startIter, addr endIter, FALSE)
```

### `gtk_text_buffer_insert(buffer: GtkTextBuffer, iter: ptr GtkTextIter, text: cstring, len: gint)`
**Что делает:** Вставляет текст в позицию итератора.

### `gtk_text_buffer_insert_at_cursor(buffer: GtkTextBuffer, text: cstring, len: gint)`
**Что делает:** Вставляет текст в текущую позицию курсора.

```nim
gtk_text_buffer_insert_at_cursor(buffer, "\nНовая строка\n", -1)
```

### `gtk_text_buffer_delete(buffer: GtkTextBuffer, start, end: ptr GtkTextIter)`
**Что делает:** Удаляет текст между двумя итераторами.

### `gtk_text_buffer_get_start_iter / get_end_iter`
**Что делает:** Устанавливает итератор на начало/конец буфера.

### `gtk_text_buffer_get_iter_at_offset(buffer, iter: pointer, charOffset: gint)`
**Что делает:** Позиционирует итератор на заданное смещение в символах.

### `gtk_text_buffer_create_tag(buffer: GtkTextBuffer, tagName: cstring, ...): GtkTextTag`
**Что делает:** Создаёт именованный тег форматирования.

```nim
let boldTag = gtk_text_buffer_create_tag(buffer, "bold", 
  "weight", PANGO_WEIGHT_BOLD, nil)
let colorTag = gtk_text_buffer_create_tag(buffer, "red-text",
  "foreground", "red", nil)
```

### `gtk_text_buffer_apply_tag(buffer, tag: GtkTextTag, start, end: ptr GtkTextIter)`
**Что делает:** Применяет тег к диапазону текста.

```nim
gtk_text_buffer_apply_tag_by_name(buffer, "bold", addr startIter, addr endIter)
```

### `gtk_text_buffer_get_modified(buffer: GtkTextBuffer): gboolean`
**Что делает:** Возвращает TRUE если буфер был изменён с момента последнего вызова `gtk_text_buffer_set_modified`.

### `gtk_text_view_set_editable(textView: GtkTextView, setting: gboolean)`
**Что делает:** Разрешает или запрещает редактирование.

### `gtk_text_view_set_wrap_mode(textView: GtkTextView, wrapMode: GtkWrapMode)`
**Что делает:** Устанавливает режим переноса строк.

### `gtk_text_view_set_monospace(textView: GtkTextView, monospace: gboolean)`
**Что делает:** Переключает на моноширинный шрифт.

```nim
# Простой пример текстового редактора
let textView = gtk_text_view_new()
let buffer = gtk_text_view_get_buffer(textView)
gtk_text_view_set_wrap_mode(textView, GTK_WRAP_WORD_CHAR)
gtk_text_buffer_set_text(buffer, "Начальный текст...", -1)

let scrolled = gtk_scrolled_window_new()
gtk_scrolled_window_set_child(scrolled, textView)
gtk_widget_set_vexpand(scrolled, TRUE)
```

---

## 19. Выпадающий список — GtkComboBoxText

### `gtk_combo_box_text_new(): GtkWidget`
**Что делает:** Создаёт простой выпадающий список из строк.

### `gtk_combo_box_text_append_text(comboBox: GtkComboBoxText, text: cstring)`
**Что делает:** Добавляет строку в конец списка.

### `gtk_combo_box_text_insert_text(comboBox: GtkComboBoxText, position: gint, text: cstring)`
**Что делает:** Вставляет строку на заданную позицию.

### `gtk_combo_box_text_remove(comboBox: GtkComboBoxText, position: gint)`
**Что делает:** Удаляет элемент по позиции.

### `gtk_combo_box_text_remove_all(comboBox: GtkComboBoxText)`
**Что делает:** Очищает весь список.

### `gtk_combo_box_text_get_active_text(comboBox: GtkComboBoxText): cstring`
**Что делает:** Возвращает текст выбранного элемента.

### `gtk_combo_box_get_active(comboBox: GtkComboBox): gint`
**Что делает:** Возвращает индекс выбранного элемента (-1 если ничего не выбрано).

### `gtk_combo_box_set_active(comboBox: GtkComboBox, index: gint)`
**Что делает:** Программно выбирает элемент по индексу.

```nim
let combo = gtk_combo_box_text_new()
gtk_combo_box_text_append_text(combo, "Опция A")
gtk_combo_box_text_append_text(combo, "Опция B")
gtk_combo_box_text_append_text(combo, "Опция C")
gtk_combo_box_set_active(combo, 0)  # выбрать первый

# Получение выбранного
let selected = $gtk_combo_box_text_get_active_text(combo)
```

---

## 20. Список — GtkListBox

### `gtk_list_box_new(): GtkWidget`
**Что делает:** Создаёт список с произвольными виджетами в качестве строк.  
**Когда использовать:** Более гибкий чем GtkTreeView, для красивых списков с иконками, кнопками.

### `gtk_list_box_append(box: GtkListBox, child: GtkWidget)`
**Что делает:** Добавляет виджет как строку списка.

### `gtk_list_box_prepend(box: GtkListBox, child: GtkWidget)`
**Что делает:** Добавляет виджет в начало.

### `gtk_list_box_remove(box: GtkListBox, child: GtkWidget)`
**Что делает:** Удаляет строку из списка.

### `gtk_list_box_remove_all(box: pointer)`
**Что делает:** Очищает весь список.

### `gtk_list_box_get_selected_row(box: GtkListBox): GtkListBoxRow`
**Что делает:** Возвращает выбранную строку (или nil).

### `gtk_list_box_set_selection_mode(box: GtkListBox, mode: GtkSelectionMode)`
**Что делает:** Режим выбора строк.

### `gtk_list_box_set_filter_func(box: GtkListBox, filterFunc, userData, destroy: pointer)`
**Что делает:** Задаёт функцию фильтрации строк (прячет не подходящие).

### `gtk_list_box_invalidate_filter(box: pointer)`
**Что делает:** Принудительно переприменяет фильтрацию.

```nim
let listBox = gtk_list_box_new()
gtk_list_box_set_selection_mode(listBox, GTK_SELECTION_SINGLE)

for item in ["Элемент 1", "Элемент 2", "Элемент 3"]:
  let row = gtk_list_box_row_new()
  let label = gtk_label_new(item)
  gtk_widget_set_halign(label, GTK_ALIGN_START)
  gtk_list_box_row_set_child(row, label)
  gtk_list_box_append(listBox, row)
```

---

## 21. Таблица — GtkTreeView / GtkListStore

> **Предупреждение:** GtkTreeView объявлен устаревшим в GTK4. Рекомендуется GtkColumnView с новым API списков. В обёртке предусмотрена условная компиляция через `when not defined(GTK_DISABLE_DEPRECATED)`.

### `createListStore(columnTypes: varargs[GType]): GtkListStore`
**Что делает:** Создаёт хранилище данных для таблицы с указанными типами колонок.  
**Результат:** `GtkListStore`.

```nim
let store = createListStore(G_TYPE_STRING, G_TYPE_INT, G_TYPE_BOOLEAN)
```

### `createTreeView(model: GtkTreeModel = nil): GtkTreeView`
**Что делает:** Создаёт виджет таблицы, опционально связывая с моделью данных.

```nim
let treeView = createTreeView(store)
```

### `addColumn(treeView: GtkTreeView, title: string, columnIndex: int): GtkTreeViewColumn`
**Что делает:** Добавляет текстовую колонку с заголовком, привязанную к колонке данных.

```nim
discard addColumn(treeView, "Имя", 0)
discard addColumn(treeView, "Возраст", 1)
```

### `appendRow(listStore: GtkListStore): GtkTreeIter`
**Что делает:** Добавляет новую строку в хранилище.  
**Результат:** Итератор на новую строку для последующего заполнения данными.

```nim
var iter = appendRow(store)
gtk_list_store_set_value(store, addr iter, 0, "Иван")  # колонка 0
```

---

## 22. Изображения — GtkImage, GtkPicture

### GtkImage — иконки и небольшие изображения

#### `gtk_image_new(): GtkWidget`
**Что делает:** Создаёт пустой виджет изображения.

#### `gtk_image_new_from_file(filename: cstring): GtkWidget`
**Что делает:** Загружает изображение из файла.

```nim
let img = gtk_image_new_from_file("/path/to/logo.png")
```

#### `gtk_image_new_from_icon_name(iconName: cstring): GtkWidget`
**Что делает:** Создаёт изображение из системной иконки темы.

```nim
let warningIcon = gtk_image_new_from_icon_name("dialog-warning-symbolic")
```

#### `gtk_image_new_from_resource(resourcePath: cstring): pointer`
**Что делает:** Загружает изображение из встроенного ресурса GResource.

#### `gtk_image_set_from_file(image: GtkImage, filename: cstring)`
**Что делает:** Меняет изображение на другой файл.

#### `gtk_image_set_pixel_size(image: GtkImage, pixelSize: gint)`
**Что делает:** Устанавливает размер иконки в пикселях (для тематических иконок).

#### `gtk_image_clear(image: pointer)`
**Что делает:** Очищает изображение (показывает пустой виджет).

---

### GtkPicture — масштабируемые изображения

#### `gtk_picture_new(): GtkWidget`
**Что делает:** Создаёт масштабируемый виджет для отображения изображений.  
**Отличие от GtkImage:** GtkPicture масштабирует изображение под доступное пространство.

#### `gtk_picture_new_for_file(file: GFile): GtkWidget`
**Что делает:** Загружает изображение из GFile.

#### `gtk_picture_new_for_filename(filename: cstring): GtkWidget`
**Что делает:** Загружает изображение из пути.

#### `gtk_picture_new_for_pixbuf(pixbuf: pointer): ptr GtkWidget`
**Что делает:** Создаёт виджет из GdkPixbuf.

#### `gtk_picture_get_keep_aspect_ratio(self: pointer): gboolean`
**Что делает:** Проверяет, сохраняется ли соотношение сторон.

---

## 23. Прогресс и уровень — GtkProgressBar, GtkLevelBar

### GtkProgressBar

#### `gtk_progress_bar_new(): GtkWidget`
**Что делает:** Создаёт полосу прогресса.

#### `gtk_progress_bar_set_fraction(pbar: GtkProgressBar, fraction: gdouble)`
**Что делает:** Устанавливает прогресс в диапазоне 0.0..1.0.

```nim
gtk_progress_bar_set_fraction(progressBar, 0.75)  # 75%
```

#### `gtk_progress_bar_pulse(pbar: GtkProgressBar)`
**Что делает:** Анимирует полосу "туда-обратно" (для неопределённого прогресса).

```nim
# Вызывать регулярно из таймера
gtk_progress_bar_pulse(progressBar)
```

#### `gtk_progress_bar_set_text(pbar: GtkProgressBar, text: cstring)`
**Что делает:** Устанавливает текст поверх полосы прогресса.

#### `gtk_progress_bar_set_show_text(pbar: GtkProgressBar, show: gboolean)`
**Что делает:** Показывает/скрывает текст на полосе.

### GtkLevelBar

#### `gtk_level_bar_new(): GtkWidget`
**Что делает:** Создаёт индикатор уровня (батарея, громкость, качество сигнала).

#### `gtk_level_bar_set_value(self: GtkLevelBar, value: gdouble)`
**Что делает:** Устанавливает текущее значение.

#### `gtk_level_bar_set_min_value / set_max_value`
**Что делает:** Задаёт диапазон допустимых значений.

---

## 24. Числовой ввод — GtkSpinButton, GtkScale

### GtkAdjustment — диапазон значений

#### `gtk_adjustment_new(value, lower, upper, stepIncrement, pageIncrement, pageSize: gdouble): GtkAdjustment`
**Что делает:** Создаёт объект диапазона с начальным значением, минимумом, максимумом и шагами.

```nim
let adj = gtk_adjustment_new(50.0, 0.0, 100.0, 1.0, 10.0, 0.0)
```

### GtkSpinButton

#### `gtk_spin_button_new(adjustment: GtkAdjustment, climbRate: gdouble, digits: guint): GtkWidget`
**Что делает:** Создаёт спиннер (числовое поле с кнопками ±).

```nim
let adj = gtk_adjustment_new(0.0, -100.0, 100.0, 1.0, 10.0, 0.0)
let spin = gtk_spin_button_new(adj, 1.0, 0)
```

#### `gtk_spin_button_get_value(spinButton: GtkSpinButton): gdouble`
**Что делает:** Возвращает текущее значение.

#### `gtk_spin_button_set_value(spinButton: GtkSpinButton, value: gdouble)`
**Что делает:** Программно устанавливает значение.

#### `gtk_spin_button_get_value_as_int(spinButton: GtkSpinButton): gint`
**Что делает:** Возвращает текущее значение как целое число.

### GtkScale

#### `gtk_scale_new(orientation: GtkOrientation, adjustment: GtkAdjustment): GtkWidget`
**Что делает:** Создаёт слайдер (ползунок).

#### `gtk_scale_new_with_range(orientation: GtkOrientation, min, max, step: gdouble): GtkWidget`
**Что делает:** Создаёт слайдер с автоматически создаваемым диапазоном.

```nim
let scale = gtk_scale_new_with_range(GTK_ORIENTATION_HORIZONTAL, 0.0, 100.0, 1.0)
```

#### `gtk_range_get_value(range: pointer): pointer`
**Что делает:** Возвращает текущее значение слайдера (через GtkRange).

#### `gtk_scale_set_draw_value(scale: GtkScale, drawValue: gboolean)`
**Что делает:** Показывает/скрывает числовое значение рядом со слайдером.

#### `gtk_scale_add_mark(scale: GtkScale, value: gdouble, position: GtkPositionType, markup: cstring)`
**Что делает:** Добавляет метку на шкале слайдера.

---

## 25. Диалоги

### `gtk_message_dialog_new(parent: GtkWindow, flags: gint, type: GtkMessageType, buttons: GtkButtonsType, messageFormat: cstring): GtkWidget`
**Что делает:** Создаёт простой информационный диалог с кнопками.  
**Когда использовать:** Предупреждения, ошибки, подтверждения.

```nim
let dialog = gtk_message_dialog_new(
  mainWindow, 0,
  GTK_MESSAGE_QUESTION,
  GTK_BUTTONS_YES_NO,
  "Сохранить изменения перед закрытием?"
)
let response = gtk_dialog_run(dialog)
gtk_widget_destroy(dialog)

if response == ord(GTK_RESPONSE_YES):
  saveDocument()
```

### `gtk_dialog_run(dialog: GtkDialog): gint`
**Что делает:** Запускает диалог модально и ждёт ответа.  
**Результат:** Код ответа (`GtkResponseType`).

### `gtk_about_dialog_new(): GtkWidget`
**Что делает:** Создаёт стандартный диалог "О программе".

```nim
let about = gtk_about_dialog_new()
gtk_about_dialog_set_program_name(about, "МояПрограмма")
gtk_about_dialog_set_version(about, "1.0.0")
gtk_about_dialog_set_comments(about, "Текстовый редактор")
gtk_about_dialog_set_license_type(about, GTK_LICENSE_GPL_3_0)
gtk_about_dialog_set_authors(about, ["Иван Иванов", nil])
gtk_window_present(about)
```

### GtkFileChooserDialog — диалог выбора файлов

```nim
let dialog = gtk_file_chooser_dialog_new(
  "Открыть файл",
  mainWindow,
  GTK_FILE_CHOOSER_ACTION_OPEN,
  "_Отмена", GTK_RESPONSE_CANCEL,
  "_Открыть", GTK_RESPONSE_ACCEPT,
  nil
)
let response = gtk_dialog_run(dialog)
if response == ord(GTK_RESPONSE_ACCEPT):
  let filename = gtk_file_chooser_get_filename(dialog)
  openFile($filename)
gtk_widget_destroy(dialog)
```

---

## 26. Заголовок окна — GtkHeaderBar

### `gtk_header_bar_new(): GtkWidget`
**Что делает:** Создаёт заголовок окна в стиле GNOME (заменяет стандартную строку заголовка).

### `gtk_header_bar_set_title_widget(bar: GtkHeaderBar, titleWidget: GtkWidget)`
**Что делает:** Устанавливает виджет в центр заголовка (например, заголовок стека).

### `gtk_header_bar_pack_start(bar: GtkHeaderBar, child: GtkWidget)`
**Что делает:** Добавляет виджет в левую часть заголовка.

### `gtk_header_bar_pack_end(bar: GtkHeaderBar, child: GtkWidget)`
**Что делает:** Добавляет виджет в правую часть заголовка.

### `gtk_window_set_titlebar(window: GtkWindow, titlebar: GtkWidget)`
**Что делает:** Устанавливает кастомный заголовок вместо стандартного.

```nim
let headerBar = gtk_header_bar_new()

let openBtn = gtk_button_new_from_icon_name(ICON_DOCUMENT_OPEN)
let saveBtn = gtk_button_new_from_icon_name(ICON_DOCUMENT_SAVE)

gtk_header_bar_pack_start(headerBar, openBtn)
gtk_header_bar_pack_start(headerBar, saveBtn)

let menuBtn = gtk_menu_button_new()
gtk_header_bar_pack_end(headerBar, menuBtn)

gtk_window_set_titlebar(window, headerBar)
```

---

## 27. Панель действий — GtkActionBar

### `gtk_action_bar_new(): GtkWidget`
**Что делает:** Создаёт горизонтальную панель снизу для кнопок действий.

### `gtk_action_bar_pack_start(bar: GtkActionBar, child: GtkWidget)`
**Что делает:** Добавляет виджет в левую часть панели.

### `gtk_action_bar_pack_end(bar: GtkActionBar, child: GtkWidget)`
**Что делает:** Добавляет виджет в правую часть панели.

### `gtk_action_bar_set_center_widget(bar: GtkActionBar, widget: GtkWidget)`
**Что делает:** Устанавливает центральный виджет.

---

## 28. Поиск — GtkSearchBar, GtkSearchEntry

### `gtk_search_bar_new(): GtkWidget`
**Что делает:** Создаёт скрывающуюся панель поиска (появляется при нажатии Ctrl+F).

### `gtk_search_bar_set_child(bar: GtkSearchBar, child: GtkWidget)`
**Что делает:** Устанавливает виджет (обычно GtkSearchEntry) внутрь панели поиска.

### `gtk_search_bar_set_show_close_button(bar: GtkSearchBar, visible: gboolean)`
**Что делает:** Показывает кнопку закрытия панели поиска.

### `gtk_search_entry_new(): GtkWidget`
**Что делает:** Создаёт поле поиска с иконкой лупы.

### `gtk_search_bar_connect_entry(bar: GtkSearchBar, entry: GtkEditable)`
**Что делает:** Связывает поле ввода с панелью поиска.

```nim
let searchBar = gtk_search_bar_new()
let searchEntry = gtk_search_entry_new()
gtk_search_bar_set_child(searchBar, searchEntry)
gtk_search_bar_set_show_close_button(searchBar, TRUE)
gtk_search_bar_connect_entry(searchBar, searchEntry)

# Показать/скрыть панель
gtk_search_bar_set_search_mode(searchBar, TRUE)
```

---

## 29. Всплывающее меню — GtkPopover, GtkPopoverMenu

### `gtk_popover_new(): GtkWidget`
**Что делает:** Создаёт всплывающий контейнер над или рядом с виджетом.

### `gtk_popover_set_child(popover: GtkPopover, child: GtkWidget)`
**Что делает:** Устанавливает содержимое поповера.

### `gtk_popover_popup(popover: GtkPopover)` / `gtk_popover_popdown`
**Что делает:** Показывает/скрывает поповер.

### `gtk_popover_menu_new_from_model(model: GMenuModel): GtkWidget`
**Что делает:** Создаёт меню из модели GMenu.

### `gtk_menu_button_new(): GtkWidget`
**Что делает:** Создаёт кнопку, открывающую поповер/меню по нажатию.

### `gtk_menu_button_set_popover(menuButton: GtkMenuButton, popover: GtkWidget)`
**Что делает:** Привязывает поповер к кнопке меню.

### `gtk_menu_button_set_menu_model(menuButton: GtkMenuButton, menuModel: GMenuModel)`
**Что делает:** Привязывает GMenuModel к кнопке меню.

```nim
let menu = g_menu_new()
g_menu_append(menu, "Новый", "app.new")
g_menu_append(menu, "Открыть", "app.open")
g_menu_append(menu, "Сохранить", "app.save")

let menuBtn = gtk_menu_button_new()
gtk_menu_button_set_menu_model(menuBtn, menu)
gtk_menu_button_set_icon_name(menuBtn, "open-menu-symbolic")
```

---

## 30. Рисование — GtkDrawingArea + Cairo

### `gtk_drawing_area_new(): GtkWidget`
**Что делает:** Создаёт холст для произвольного рисования через Cairo.

### `gtk_drawing_area_set_draw_func(drawingArea: GtkDrawingArea, drawFunc, userData, destroyNotify: pointer)`
**Что делает:** Регистрирует функцию рисования, вызываемую при обновлении виджета.

```nim
proc drawCallback(area: GtkWidget, cr: cairo_t, width, height: gint, data: pointer) {.cdecl.} =
  # Заливка фона
  cairo_set_source_rgb(cr, 0.95, 0.95, 0.95)
  cairo_paint(cr)
  
  # Рисование линии
  cairo_set_source_rgb(cr, 0.2, 0.4, 0.8)
  cairo_set_line_width(cr, 2.0)
  cairo_move_to(cr, 10.0, 10.0)
  cairo_line_to(cr, 200.0, 150.0)
  cairo_stroke(cr)

let canvas = gtk_drawing_area_new()
gtk_drawing_area_set_content_width(canvas, 400)
gtk_drawing_area_set_content_height(canvas, 300)
gtk_drawing_area_set_draw_func(canvas, drawCallback, nil, nil)
```

### Cairo функции

#### `cairo_set_source_rgb(cr: cairo_t, red, green, blue: cdouble)`
**Что делает:** Устанавливает текущий цвет рисования (компоненты 0.0..1.0).

#### `cairo_paint(cr: cairo_t)`
**Что делает:** Заливает весь контекст текущим цветом/паттерном.

#### `cairo_set_line_width(cr: cairo_t, width: cdouble)`
**Что делает:** Устанавливает толщину линии в пикселях.

#### `cairo_move_to(cr: cairo_t, x, y: cdouble)`
**Что делает:** Перемещает "перо" в точку без рисования.

#### `cairo_line_to(cr: cairo_t, x, y: cdouble)`
**Что делает:** Рисует линию от текущей точки до (x, y).

#### `cairo_stroke(cr: cairo_t)`
**Что делает:** Применяет (отрисовывает) накопленный путь как линию.

```nim
# Рисование прямоугольника
proc drawRect(cr: cairo_t, x, y, w, h: float) =
  cairo_move_to(cr, x, y)
  cairo_line_to(cr, x + w, y)
  cairo_line_to(cr, x + w, y + h)
  cairo_line_to(cr, x, y + h)
  cairo_line_to(cr, x, y)
  cairo_stroke(cr)
```

---

## 31. CSS стилизация

### `gtk_css_provider_new(): GtkCssProvider`
**Что делает:** Создаёт провайдер CSS-стилей.

### `gtk_css_provider_load_from_string(provider: GtkCssProvider, data: cstring)`
**Что делает:** Загружает CSS из строки.

### `gtk_css_provider_load_from_file(provider: GtkCssProvider, file: GFile)`
**Что делает:** Загружает CSS из файла.

### `gtk_style_context_add_provider_for_display(display: GdkDisplay, provider: GtkStyleProvider, priority: guint)`
**Что делает:** Применяет CSS-провайдер глобально для всего дисплея.

```nim
let cssProvider = gtk_css_provider_new()
gtk_css_provider_load_from_string(cssProvider, """
  window {
    background-color: #1e1e1e;
    color: #ffffff;
  }
  button.suggested-action {
    background: #3584e4;
    color: white;
    border-radius: 6px;
    padding: 8px 16px;
  }
  entry {
    font-size: 14px;
    border: 1px solid #cccccc;
  }
""")

let display = gdk_display_get_default()
gtk_style_context_add_provider_for_display(
  display,
  cast[GtkStyleProvider](cssProvider),
  GTK_STYLE_PROVIDER_PRIORITY_APPLICATION
)
```

### `gtk_css_provider_to_string(provider: pointer): pointer`
**Что делает:** Сериализует провайдер обратно в строку CSS (для отладки).

---

## 32. Сигналы GObject — g_signal_*

### `g_signal_connect(instance: pointer, signal: cstring, handler: GCallback, data: pointer): gulong`
**Что делает:** Подключает обработчик к сигналу виджета.  
**Результат:** ID соединения для последующего отключения.  
**Важно:** Callback должен иметь атрибут `{.cdecl.}`.

```nim
proc onButtonClick(button: GtkButton, data: pointer) {.cdecl.} =
  echo "Кнопка нажата!"

let handlerId = g_signal_connect(button, "clicked", cast[GCallback](onButtonClick), nil)
```

### `g_signal_connect_data(instance, signal: pointer, handler: GCallback, data, destroyData: pointer, flags: gint): gulong`
**Что делает:** Расширенная версия connect с контролем момента вызова и деструктором данных.

### `g_signal_connect_after` (шаблон)
**Что делает:** Подключает обработчик, который вызывается ПОСЛЕ стандартных обработчиков.

```nim
g_signal_connect_after(widget, "draw", cast[GCallback](afterDraw), nil)
```

### `g_signal_connect_swapped` (шаблон)
**Что делает:** Меняет местами instance и data при вызове обработчика.

### `g_signal_disconnect(instance: pointer, handlerId: gulong)`
**Что делает:** Отключает обработчик по его ID.

### `g_signal_handler_block(instance: pointer, handlerId: gulong)`
**Что делает:** Временно блокирует обработчик (не удаляет).

### `g_signal_handler_unblock(instance: pointer, handlerId: gulong)`
**Что делает:** Снимает блокировку обработчика.

### `withSignalBlock` (шаблон)
**Что делает:** Удобная обёртка — блокирует сигнал на время выполнения блока кода.

```nim
# Изменить значение без срабатывания обработчика
withSignalBlock(spinButton, handlerId):
  gtk_spin_button_set_value(spinButton, newValue)
```

### `connectSimple` (шаблон)
**Что делает:** Упрощённое подключение сигнала с inline-кодом и обработкой ошибок.

```nim
let id = connectSimple(button, "clicked"):
  echo "Нажато!"
  doSomeAction()
```

### Часто используемые сигналы

| Виджет | Сигнал | Когда вызывается |
|--------|--------|-----------------|
| GtkButton | `"clicked"` | Нажатие кнопки |
| GtkEntry | `"changed"` | Изменение текста |
| GtkEntry | `"activate"` | Нажатие Enter |
| GtkTextBuffer | `"changed"` | Изменение текста |
| GtkWindow | `"destroy"` | Уничтожение окна |
| GtkWindow | `"close-request"` | Запрос закрытия |
| GtkToggleButton | `"toggled"` | Переключение |
| GtkComboBox | `"changed"` | Выбор элемента |
| GtkApplication | `"activate"` | Запуск приложения |
| GtkSpinButton | `"value-changed"` | Изменение числа |
| GtkScale | `"value-changed"` | Движение ползунка |

---

## 33. Управление памятью — g_object_ref / unref

### `g_object_ref(object: gpointer): gpointer`
**Что делает:** Увеличивает счётчик ссылок GObject на 1.  
**Когда использовать:** При хранении объекта дольше его стандартного срока жизни.

### `g_object_unref(object: gpointer)`
**Что делает:** Уменьшает счётчик ссылок. При достижении 0 — объект уничтожается.  
**Когда использовать:** Освобождение объектов созданных с суффиксом `_new`.

### `safeUnref[T](obj: var T)`
**Что делает:** Безопасно уменьшает счётчик и устанавливает указатель в nil.

```nim
var myImage = gtk_image_new_from_file("photo.png")
# ... использование ...
safeUnref(myImage)  # освобождение + myImage = nil
```

### `safeRef[T](obj: T): T`
**Что делает:** Увеличивает счётчик ссылок, возвращает тот же объект.

```nim
let sharedBuffer = safeRef(buffer)  # теперь у нас есть своя ссылка
```

### `g_object_set_data(object: GObject, key: cstring, data: gpointer)`
**Что делает:** Присваивает произвольные данные объекту по ключу.

### `g_object_get_data(object: GObject, key: cstring): gpointer`
**Что делает:** Читает ранее присвоенные данные.

```nim
# Хранение пользовательских данных в виджете
g_object_set_data(button, "file-path", cast[gpointer](allocCStringArray(["/path/file"])))
let path = cast[cstringArray](g_object_get_data(button, "file-path"))
```

### `g_free(mem: gpointer)`
**Что делает:** Освобождает память, выделенную функциями GLib (cstring от GTK API).  
**Важно:** Используйте только для строк возвращённых GTK, не для Nim-строк.

---

## 34. GtkBuilder — загрузка UI из XML

### `loadBuilder(filename: string): GtkBuilder`
**Что делает:** Загружает описание интерфейса из файла `.ui` (Glade/GTK XML).  
**Когда использовать:** Отделение дизайна UI от логики, дизайнеры могут работать отдельно.

```nim
let builder = loadBuilder("ui/main_window.ui")
```

### `loadBuilderFromString(uiDefinition: string): GtkBuilder`
**Что делает:** Загружает UI из строки с XML-описанием.  
**Когда использовать:** Встроенные UI-определения прямо в коде.

```nim
const UI = """
<?xml version="1.0" encoding="UTF-8"?>
<interface>
  <object class="GtkWindow" id="mainWindow">
    <property name="title">Моё окно</property>
    <child>
      <object class="GtkButton" id="myButton">
        <property name="label">Нажми меня</property>
      </object>
    </child>
  </object>
</interface>
"""
let builder = loadBuilderFromString(UI)
```

### `getWidget(builder: GtkBuilder, name: string): GtkWidget`
**Что делает:** Получает виджет из builder по ID, указанному в XML.

```nim
let window = getWidget(builder, "mainWindow")
let button = getWidget(builder, "myButton")
```

### `getObject[T](builder: GtkBuilder, name: string): T`
**Что делает:** Получает объект с приведением типа.

```nim
let listStore = getObject[GtkListStore](builder, "myListStore")
```

---

## 35. Жесты и контроллеры событий

### `addClickGesture(widget: GtkWidget, button = 1'u): GtkGestureClick`
**Что делает:** Добавляет обработчик кликов мыши к виджету.  
**Параметр button:** 1=левая кнопка, 2=средняя, 3=правая.

```nim
let gesture = addClickGesture(canvas, 1)  # левый клик
discard g_signal_connect(gesture, "pressed", cast[GCallback](onCanvasClick), nil)
```

### `addDragGesture(widget: GtkWidget): GtkGestureDrag`
**Что делает:** Добавляет обработчик перетаскивания мышью.

```nim
let drag = addDragGesture(canvas)
discard g_signal_connect(drag, "drag-begin", cast[GCallback](onDragBegin), nil)
discard g_signal_connect(drag, "drag-update", cast[GCallback](onDragUpdate), nil)
```

### `addKeyController(widget: GtkWidget): GtkEventControllerKey`
**Что делает:** Добавляет обработчик клавиатуры к виджету.

```nim
let keyCtrl = addKeyController(window)
discard g_signal_connect(keyCtrl, "key-pressed", cast[GCallback](onKeyPress), nil)
```

### `gtk_event_controller_get_current_event(controller: pointer): pointer`
**Что делает:** Возвращает текущее событие во время обработки.

### `gtk_gesture_click_new(): GtkGestureClick`
**Что делает:** Низкоуровневое создание жеста клика.

### `gtk_gesture_click_set_button(gesture: GtkGestureClick, button: guint)`
**Что делает:** Устанавливает кнопку мыши для отслеживания (0 = любая).

### `gtk_gesture_drag_new(): GtkGestureDrag`
**Что делает:** Создаёт жест перетаскивания.

### `gtk_event_controller_key_new(): GtkEventControllerKey`
**Что делает:** Создаёт контроллер клавиатуры.

### `gtk_event_controller_motion_new(): pointer`
**Что делает:** Создаёт контроллер движения мыши.

---

## 36. Меню и действия — GMenu, GAction

### `g_menu_new(): GMenu`
**Что делает:** Создаёт модель меню.

### `g_menu_append(menu: GMenu, label, detailedAction: cstring)`
**Что делает:** Добавляет элемент меню с заголовком и действием.

```nim
let menu = g_menu_new()
g_menu_append(menu, "Новый документ", "app.new")
g_menu_append(menu, "Открыть...", "app.open")
g_menu_append(menu, "Сохранить", "app.save")
```

### `g_menu_append_section(menu: GMenu, label: cstring, section: GMenuModel)`
**Что делает:** Добавляет секцию (подменю) в меню.

### `g_menu_append_submenu(menu: GMenu, label: cstring, submenu: GMenuModel)`
**Что делает:** Добавляет подменю.

### `g_simple_action_new(name: cstring, parameterType: GVariantType): GSimpleAction`
**Что делает:** Создаёт простое действие с именем.

### `g_action_map_add_action(actionMap: GActionMap, action: GAction)`
**Что делает:** Регистрирует действие в карте действий (приложении или окне).

### `g_action_map_add_action_entries(actionMap: GActionMap, entries: ptr GActionEntry, nEntries: gint, userData: gpointer)`
**Что делает:** Массовая регистрация действий через массив `GActionEntry`.

```nim
var actions = [
  GActionEntry(
    name: "open",
    activate: proc(a: GSimpleAction, p: GVariant, data: gpointer) {.cdecl.} =
      openFileDialog()
  ),
  GActionEntry(
    name: "save",
    activate: proc(a: GSimpleAction, p: GVariant, data: gpointer) {.cdecl.} =
      saveDocument()
  ),
]
g_action_map_add_action_entries(
  cast[GActionMap](app), 
  addr actions[0], 
  2, 
  nil
)
```

---

## 37. Настройки приложения — GtkSettings

### `getDefaultSettings(): GtkSettings`
**Что делает:** Возвращает объект системных настроек GTK.  
**Когда использовать:** Проверка системной темы, настроек шрифтов.

```nim
let settings = getDefaultSettings()
```

### `gtk_settings_get_default(): GtkSettings`
**Что делает:** Низкоуровневая версия получения настроек.

### `isDarkTheme(): bool`
**Что делает:** Возвращает true если включена тёмная тема (в текущей реализации — заглушка).

---

## 38. Утилиты отладки

### `printWidgetTree(widget: GtkWidget, indent = 0)`
**Что делает:** Рекурсивно выводит в консоль иерархию дочерних виджетов.  
**Когда использовать:** Отладка компоновки, поиск потерянных виджетов.

```nim
printWidgetTree(mainWindow)
# Вывод:
# GtkApplicationWindow
#   GtkBox
#     GtkHeaderBar
#     GtkPaned
#       GtkScrolledWindow
#       GtkTextView
```

### `dumpWidgetInfo(widget: GtkWidget)`
**Что делает:** Выводит подробную информацию о конкретном виджете: имя, видимость, чувствительность, размер.

```nim
dumpWidgetInfo(myButton)
# Widget Info:
#   Name: GtkButton
#   Visible: 1
#   Sensitive: 1
#   Can Focus: 1
#   Size Request: 120x40
```

---

## 39. GtkCalendar

### `gtk_calendar_new(): GtkWidget`
**Что делает:** Создаёт виджет календаря.

### `gtk_calendar_get_date(self: pointer): pointer`
**Что делает:** Возвращает выбранную дату как GDateTime.

### `gtk_calendar_get_day / get_month / get_year`
**Что делает:** Возвращают отдельные компоненты текущей даты.

```nim
let cal = gtk_calendar_new()
discard g_signal_connect(cal, "day-selected", cast[GCallback](onDateSelected), nil)

# В обработчике:
proc onDateSelected(cal: GtkCalendar, data: pointer) {.cdecl.} =
  let day   = gtk_calendar_get_day(cal)
  let month = gtk_calendar_get_month(cal)
  let year  = gtk_calendar_get_year(cal)
  echo "Выбрана дата: ", day, ".", month + 1, ".", year
```

---

## 40. GtkExpander, GtkFrame, GtkOverlay

### GtkExpander

#### `gtk_expander_new(label: cstring): GtkWidget`
**Что делает:** Создаёт разворачиваемый контейнер с заголовком.

#### `gtk_expander_set_child(expander: GtkExpander, child: GtkWidget)`
**Что делает:** Устанавливает скрываемое содержимое.

#### `gtk_expander_get_expanded(expander: GtkExpander): gboolean`
**Что делает:** Возвращает состояние (развёрнут/свёрнут).

### GtkFrame

#### `gtk_frame_new(label: cstring): GtkWidget`
**Что делает:** Создаёт контейнер с рамкой и необязательным заголовком.

#### `gtk_frame_set_child(frame: GtkFrame, child: GtkWidget)`
**Что делает:** Устанавливает содержимое фрейма.

### GtkOverlay

#### `gtk_overlay_new(): GtkWidget`
**Что делает:** Контейнер для наложения виджетов поверх основного содержимого.

#### `gtk_overlay_set_child(overlay: GtkOverlay, child: GtkWidget)`
**Что делает:** Устанавливает основной виджет.

#### `gtk_overlay_add_overlay(overlay: GtkOverlay, widget: GtkWidget)`
**Что делает:** Добавляет виджет поверх основного.

---

## 41. Шаблоны и вспомогательные конструкции

### `withSignalBlock(widget, handlerId, body)`
**Что делает:** Шаблон — блокирует сигнал, выполняет body, разблокирует (безопасный try/finally).  
**Когда использовать:** Программное изменение значений виджетов без рекурсивных срабатываний.

```nim
# Обновление позиции ползунка без лишних сигналов
withSignalBlock(scaleWidget, scaleSignalId):
  gtk_range_set_value(scaleWidget, newPosition)
```

### `connectSimple(widget, signal, code)`
**Что делает:** Inline-подключение сигнала без необходимости объявлять отдельную процедуру.

```nim
let closeId = connectSimple(window, "destroy"):
  gtk_main_quit()  # или g_application_quit

let btnId = connectSimple(applyBtn, "clicked"):
  applySettings()
  showToast("Настройки применены")
```

### `g_signal_connect_after(instance, signal, callback, data)`
**Что делает:** Шаблон — подключает обработчик, вызываемый после стандартных обработчиков GTK.

### `g_signal_connect_swapped(instance, signal, callback, data)`
**Что делает:** Шаблон — при вызове аргументы instance и data меняются местами.

---

## 42. Roaring Bitmap API

Обёртка включает привязки к библиотеке [CRoaring](https://github.com/RoaringBitmap/CRoaring) — сжатых битовых множеств.

### Базовые операции (32-бит)

#### `roaring_bitmap_create_with_capacity(): pointer`
**Что делает:** Создаёт пустой битмап с начальной ёмкостью.

#### `roaring_bitmap_add(r: pointer, x: pointer): pointer`
**Что делает:** Добавляет значение в битмап.

#### `roaring_bitmap_remove(r: pointer, x: pointer): pointer`
**Что делает:** Удаляет значение.

#### `roaring_bitmap_contains(r: pointer, val: pointer): pointer`
**Что делает:** Проверяет принадлежность значения.

#### `roaring_bitmap_get_cardinality(r: pointer): pointer`
**Что делает:** Возвращает количество элементов.

#### `roaring_bitmap_run_optimize(r: pointer): pointer`
**Что делает:** Оптимизирует хранение данных для сжатия.

#### `roaring_bitmap_free(r: pointer): pointer`
**Что делает:** Освобождает память битмапа.

### 64-бит версия

Аналогичный API с префиксом `roaring64_bitmap_*`.

---

## 43. GTK Inspector API

Внутренние функции инспектора GTK (обычно не используются в прикладном коде).

### `gtk_inspector_window_get_type(): pointer`
**Что делает:** Возвращает GType окна инспектора.

### `gtk_inspector_is_recording(widget: GtkWidget): gboolean`
**Что делает:** Проверяет, ведётся ли запись событий.

### `gtk_inspector_handle_event(event: pointer): gboolean`
**Что делает:** Обрабатывает событие инспектора.

### `gtk_inspector_window_select_widget_under_pointer(iw: pointer)`
**Что делает:** Выбирает виджет под курсором мыши для инспекции.

---

## 44. Доступность (Accessibility) — AT-SPI / AT-Context

### `gtk_accessible_get_accessible_role(self: pointer): pointer`
**Что делает:** Возвращает WAI-ARIA роль виджета (button, textbox, listitem и т.д.).

### `gtk_accessible_should_present(self: pointer): gboolean`
**Что делает:** Определяет, должен ли виджет быть виден вспомогательным технологиям.

### `gtk_accessible_bounds_changed(self: pointer)`
**Что делает:** Уведомляет AT об изменении границ виджета.

### `gtk_at_context_get_name(self: pointer): cstring`
**Что делает:** Возвращает доступное имя виджета (для скрин-ридеров).

### `gtk_at_context_get_description(self: pointer): cstring`
**Что делает:** Возвращает описание виджета для скрин-ридеров.

---

## 45. Печать — GtkPrintDialog, GtkPrintSettings

### `gtk_print_dialog_new(): pointer`
**Что делает:** Создаёт диалог печати (GTK4 API).

### `gtk_print_dialog_get_title(self: pointer): pointer`
**Что делает:** Возвращает заголовок диалога.

### `gtk_print_settings_get_printer(settings: pointer): pointer`
**Что делает:** Возвращает имя выбранного принтера.

### `gtk_print_settings_get_n_copies(settings: pointer): pointer`
**Что делает:** Возвращает количество копий.

### `gtk_printer_get_name(printer: pointer): pointer`
**Что делает:** Имя принтера.

### `gtk_printer_is_active(printer: pointer): pointer`
**Что делает:** Проверяет активен ли принтер.

---

## 46. Быстрые рецепты (Recipes)

### Минимальное GTK4-приложение

```nim
import libGTK4_p3

proc onActivate(app: GtkApplication, data: pointer) {.cdecl.} =
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Hello GTK4")
  gtk_window_set_default_size(window, 400, 300)
  
  let label = gtk_label_new("Привет, мир!")
  gtk_window_set_child(window, label)
  gtk_window_present(window)

let app = gtk_application_new("com.example.hello", G_APPLICATION_DEFAULT_FLAGS)
discard g_signal_connect(app, "activate", cast[GCallback](onActivate), nil)
let status = g_application_run(cast[GApplication](app), 0, nil)
g_object_unref(app)
```

---

### Форма с валидацией

```nim
proc buildForm(app: GtkApplication, data: pointer) {.cdecl.} =
  let window = gtk_application_window_new(app)
  
  let grid = gtk_grid_new()
  gtk_grid_set_column_spacing(grid, 12)
  gtk_grid_set_row_spacing(grid, 6)
  gtk_widget_set_margin_start(grid, 24)
  gtk_widget_set_margin_end(grid, 24)
  gtk_widget_set_margin_top(grid, 24)
  gtk_widget_set_margin_bottom(grid, 24)
  
  let nameLabel = gtk_label_new("Имя:")
  let nameEntry = gtk_entry_new()
  gtk_entry_set_placeholder_text(nameEntry, "Введите ваше имя")
  
  let emailLabel = gtk_label_new("Email:")
  let emailEntry = gtk_entry_new()
  gtk_entry_set_input_purpose(emailEntry, GTK_INPUT_PURPOSE_EMAIL)
  gtk_entry_set_placeholder_text(emailEntry, "user@example.com")
  
  gtk_widget_set_halign(nameLabel, GTK_ALIGN_END)
  gtk_widget_set_halign(emailLabel, GTK_ALIGN_END)
  
  gtk_grid_attach(grid, nameLabel,  0, 0, 1, 1)
  gtk_grid_attach(grid, nameEntry,  1, 0, 2, 1)
  gtk_grid_attach(grid, emailLabel, 0, 1, 1, 1)
  gtk_grid_attach(grid, emailEntry, 1, 1, 2, 1)
  
  let submitBtn = gtk_button_new_with_label("Отправить")
  gtk_widget_add_css_class(submitBtn, "suggested-action")
  gtk_grid_attach(grid, submitBtn, 2, 2, 1, 1)
  
  discard connectSimple(submitBtn, "clicked"):
    let name  = $gtk_entry_get_text(nameEntry)
    let email = $gtk_entry_get_text(emailEntry)
    if name.len == 0 or email.len == 0:
      echo "Заполните все поля!"
    else:
      echo "Форма отправлена: ", name, " <", email, ">"
  
  gtk_window_set_child(window, grid)
  gtk_window_present(window)
```

---

### Текстовый редактор с сохранением

```nim
var currentFile = ""
var textBuf: GtkTextBuffer

proc saveToFile(path: string) =
  var s, e: GtkTextIter
  gtk_text_buffer_get_start_iter(textBuf, addr s)
  gtk_text_buffer_get_end_iter(textBuf, addr e)
  let content = $gtk_text_buffer_get_text(textBuf, addr s, addr e, FALSE)
  writeFile(path, content)
  gtk_text_buffer_set_modified(textBuf, FALSE)

proc buildEditor(app: GtkApplication, data: pointer) {.cdecl.} =
  let window = gtk_application_window_new(app)
  gtk_window_set_default_size(window, 800, 600)
  
  let headerBar = gtk_header_bar_new()
  
  let openBtn = gtk_button_new_from_icon_name(ICON_DOCUMENT_OPEN)
  let saveBtn = gtk_button_new_from_icon_name(ICON_DOCUMENT_SAVE)
  gtk_header_bar_pack_start(headerBar, openBtn)
  gtk_header_bar_pack_start(headerBar, saveBtn)
  gtk_window_set_titlebar(window, headerBar)
  
  let textView = gtk_text_view_new()
  textBuf = gtk_text_view_get_buffer(textView)
  gtk_text_view_set_wrap_mode(textView, GTK_WRAP_WORD_CHAR)
  gtk_text_view_set_monospace(textView, TRUE)
  
  let scrolled = gtk_scrolled_window_new()
  gtk_scrolled_window_set_child(scrolled, textView)
  gtk_widget_set_vexpand(scrolled, TRUE)
  
  gtk_window_set_child(window, scrolled)
  
  discard connectSimple(saveBtn, "clicked"):
    if currentFile.len > 0:
      saveToFile(currentFile)
    else:
      echo "Нет файла для сохранения"
  
  gtk_window_present(window)
```

---

### Приложение с CSS стилями

```nim
const DARK_CSS = """
window, .background {
  background-color: #1e1e2e;
  color: #cdd6f4;
}
button {
  background: #313244;
  color: #cdd6f4;
  border: 1px solid #45475a;
  border-radius: 8px;
  padding: 6px 14px;
  font-size: 13px;
}
button:hover {
  background: #45475a;
}
button.suggested-action {
  background: #89b4fa;
  color: #1e1e2e;
  border: none;
}
entry {
  background: #313244;
  color: #cdd6f4;
  border: 1px solid #45475a;
  border-radius: 6px;
  caret-color: #89b4fa;
}
"""

proc applyTheme() =
  let provider = gtk_css_provider_new()
  gtk_css_provider_load_from_string(provider, DARK_CSS)
  let display = gdk_display_get_default()
  gtk_style_context_add_provider_for_display(
    display,
    cast[GtkStyleProvider](provider),
    GTK_STYLE_PROVIDER_PRIORITY_APPLICATION
  )
```

---

*Справочник создан на основе анализа файла `libGTK4_p3.nim`. Охватывает публичные функции, Nim-утилиты, шаблоны и вспомогательный API. Для работы требуется установленная библиотека GTK4 и утилита `pkg-config`.*
