# Справочник функций GTK4 — libGTK4_p1.nim

> Документация по файлу `libGTK4_p1.nim` — первой и основной части Nim-обёртки над библиотекой GTK4.  
> Файл содержит низкоуровневые привязки (`importc`) к функциям GTK/GDK/GLib/GIO: инициализацию, управление приложением, сигналы, виджеты, контейнеры, текстовый редактор, диалоги, меню и CSS.

---

## Содержание

1. [Типы данных](#1-типы-данных)
2. [Перечисления (enums)](#2-перечисления-enums)
3. [Константы](#3-константы)
4. [GTK — инициализация](#4-gtk--инициализация)
5. [GtkApplication](#5-gtkapplication)
6. [GApplication](#6-gapplication)
7. [Сигналы (GLib Signals)](#7-сигналы-glib-signals)
8. [Actions (GAction / GSimpleAction)](#8-actions-gaction--gsimpleaction)
9. [GMenu — модель меню](#9-gmenu--модель-меню)
10. [GtkWindow](#10-gtkwindow)
11. [GtkWidget — базовые функции](#11-gtkwidget--базовые-функции)
12. [GtkBox](#12-gtkbox)
13. [GtkGrid](#13-gtkgrid)
14. [GtkButton](#14-gtkbutton)
15. [GtkToggleButton](#15-gtktogglebutton)
16. [GtkCheckButton](#16-gtkcheckbutton)
17. [GtkSwitch](#17-gtkswitch)
18. [GtkLabel](#18-gtklabel)
19. [GtkEntry](#19-gtkentry)
20. [GtkPasswordEntry](#20-gtkpasswordentry)
21. [GtkSearchEntry](#21-gtksearchentry)
22. [GtkTextView](#22-gtktextview)
23. [GtkTextBuffer](#23-gtktextbuffer)
24. [GtkScrolledWindow](#24-gtkscrolledwindow)
25. [GtkFrame](#25-gtkframe)
26. [GtkSeparator](#26-gtkseparator)
27. [GtkImage](#27-gtkimage)
28. [GtkSpinner](#28-gtkspinner)
29. [GtkProgressBar](#29-gtkprogressbar)
30. [GtkSpinButton](#30-gtkspinbutton)
31. [GtkAdjustment](#31-gtkadjustment)
32. [GtkScale / GtkRange](#32-gtkscale--gtkrange)
33. [GtkComboBoxText / GtkComboBox (устаревшие)](#33-gtkcomboboxtext--gtkcombobox-устаревшие)
34. [GtkListBox](#34-gtklistbox)
35. [GtkNotebook](#35-gtknotebook)
36. [GtkPaned](#36-gtkpaned)
37. [GtkStack / GtkStackSwitcher](#37-gtkstack--gtkstackswitcher)
38. [GtkHeaderBar](#38-gtkheaderbar)
39. [GtkMessageDialog / GtkDialog](#39-gtkmessagedialog--gtkdialog)
40. [GtkFileChooser](#40-gtkfilechooser)
41. [GtkDrawingArea](#41-gtkdrawingarea)
42. [CSS Provider](#42-css-provider)
43. [StyleContext и Display](#43-stylecontext-и-display)
44. [GFile — базовые операции](#44-gfile--базовые-операции)
45. [GError](#45-gerror)
46. [GVariant](#46-gvariant)
47. [GObject](#47-gobject)
48. [GtkPopover](#48-gtkpopover)
49. [GtkMenuButton](#49-gtkmenubutton)

---

## 1. Типы данных

### GLib-типы (псевдонимы примитивов C)

| Nim-тип | C-тип | Описание |
|---|---|---|
| `gboolean` | `int32` | Логический тип GTK. Используй `TRUE`/`FALSE` из констант |
| `gint` | `int32` | 32-битное целое со знаком |
| `guint` | `uint32` | 32-битное целое без знака |
| `gint64` | `int64` | 64-битное целое со знаком |
| `guint64` | `uint64` | 64-битное целое без знака |
| `gfloat` | `float32` | Число с плавающей точкой одинарной точности |
| `gdouble` | `float64` | Число с плавающей точкой двойной точности |
| `gsize` | `uint` | Размер (аналог `size_t`) |
| `gssize` | `int` | Размер со знаком (аналог `ssize_t`) |
| `gpointer` | `pointer` | Универсальный указатель |
| `gunichar` | `uint32` | Unicode-символ |

### GTK/GDK-типы (указатели на непрозрачные структуры)

Все типы виджетов (`GtkWidget`, `GtkWindow`, `GtkButton` и т.д.) объявлены как `pointer`. Это означает, что Nim не проверяет безопасность типов на уровне компилятора — приведения через `cast[T]` полностью на ответственности разработчика.

**Ключевые типы-объекты (не указатели):**

- `GtkTextIter` — позиция в текстовом буфере (14 полей-заглушек, используй через `addr iter`)
- `GtkTreeIter` — позиция в TreeModel (4 поля)
- `GdkRectangle` — прямоугольник с полями `x, y, width, height: gint`

**Callback-типы:**

- `GSourceFunc = proc(userData: gpointer): gboolean {.cdecl.}` — для таймеров
- `GAsyncReadyCallback = proc(sourceObject, res, userData)` — для async-операций
- `GCallback = pointer` — универсальный указатель на функцию-обработчик

---

## 2. Перечисления (enums)

### Ориентация и выравнивание

| Тип | Значения |
|---|---|
| `GtkOrientation` | `GTK_ORIENTATION_HORIZONTAL = 0`, `GTK_ORIENTATION_VERTICAL = 1` |
| `GtkAlign` | `FILL=0`, `START=1`, `END=2`, `CENTER=3`, `BASELINE=4` |
| `GtkJustification` | `LEFT=0`, `RIGHT=1`, `CENTER=2`, `FILL=3` |
| `GtkBaselinePosition` | `TOP=0`, `CENTER=1`, `BOTTOM=2` |
| `GtkPositionType` | `LEFT=0`, `RIGHT=1`, `TOP=2`, `BOTTOM=3` |
| `GtkTextDirection` | `NONE`, `LTR`, `RTL` |

### Текст и ввод

| Тип | Назначение |
|---|---|
| `GtkWrapMode` | Перенос строк: `NONE`, `CHAR`, `WORD`, `WORD_CHAR` |
| `PangoWrapMode` | Перенос для Pango: `WORD`, `CHAR`, `WORD_CHAR` |
| `PangoEllipsizeMode` | Усечение текста: `NONE`, `START`, `MIDDLE`, `END` |
| `GtkNaturalWrapMode` | Естественный перенос: `INHERIT`, `NONE`, `WORD` |
| `GtkInputPurpose` | Назначение поля ввода: `FREE_FORM`, `DIGITS`, `URL`, `EMAIL`, `PASSWORD`, `PIN` и др. |
| `GtkInputHints` | Подсказки для IM: `SPELLCHECK`, `LOWERCASE`, `UPPERCASE_WORDS`, `EMOJI` и др. |

### Диалоги

| Тип | Назначение |
|---|---|
| `GtkMessageType` | `INFO`, `WARNING`, `QUESTION`, `ERROR`, `OTHER` |
| `GtkButtonsType` | Набор кнопок: `NONE`, `OK`, `CLOSE`, `CANCEL`, `YES_NO`, `OK_CANCEL` |
| `GtkResponseType` | Ответы диалога: `OK=-5`, `CANCEL=-6`, `YES=-8`, `NO=-9`, `CLOSE=-7` |

### Выделение и списки

| Тип | Значения |
|---|---|
| `GtkSelectionMode` | `NONE`, `SINGLE`, `BROWSE`, `MULTIPLE` |
| `GtkFileChooserAction` | `OPEN`, `SAVE`, `SELECT_FOLDER` |
| `GtkPolicyType` | Полосы прокрутки: `ALWAYS`, `AUTOMATIC`, `NEVER`, `EXTERNAL` |

### Сигналы и привязка свойств

| Тип | Назначение |
|---|---|
| `GtkArrowType` | `UP`, `DOWN`, `LEFT`, `RIGHT`, `NONE` — для кнопок со стрелкой |
| `GBindingFlags` | `DEFAULT`, `BIDIRECTIONAL`, `SYNC_CREATE`, `INVERT_BOOLEAN` |
| `GApplicationFlags` | Флаги приложения: `FLAGS_NONE`, `HANDLES_OPEN`, `NON_UNIQUE` и др. |
| `GSignalFlags` | `RUN_FIRST`, `RUN_LAST`, `RUN_CLEANUP`, `ACTION`, `DETAILED` |
| `GtkApplicationInhibitFlags` | `LOGOUT`, `SWITCH`, `SUSPEND`, `IDLE` |

### Стек (анимации переходов)

`GtkStackTransitionType` содержит 20 вариантов, в т.ч.:
- `CROSSFADE` — плавное исчезновение
- `SLIDE_LEFT/RIGHT/UP/DOWN` — скользящий переход
- `OVER_LEFT/RIGHT/UP/DOWN` — новая страница наплывает поверх
- `UNDER_*` — старая страница уходит под новую

---

## 3. Константы

### Логические значения

```nim
FALSE* = 0
TRUE*  = 1
```

### GType — базовые типы GLib

| Константа | Значение | Описание |
|---|---|---|
| `G_TYPE_BOOLEAN` | `5 shl 2` | Тип `gboolean` |
| `G_TYPE_INT` | `6 shl 2` | Тип `gint` |
| `G_TYPE_STRING` | `16 shl 2` | Тип `cstring` |
| `G_TYPE_OBJECT` | `20 shl 2` | Базовый GObject |
| `G_TYPE_VARIANT` | `21 shl 2` | GVariant |

### Приоритеты CSS

| Константа | Значение | Когда применять |
|---|---|---|
| `GTK_STYLE_PROVIDER_PRIORITY_FALLBACK` | 1 | Запасные стили |
| `GTK_STYLE_PROVIDER_PRIORITY_THEME` | 200 | Тема оформления |
| `GTK_STYLE_PROVIDER_PRIORITY_SETTINGS` | 400 | Системные настройки |
| `GTK_STYLE_PROVIDER_PRIORITY_APPLICATION` | 600 | Стили приложения ← обычно используй этот |
| `GTK_STYLE_PROVIDER_PRIORITY_USER` | 800 | Пользовательские правила (наивысший) |

### Тип окна

```nim
GTK_WINDOW_TOPLEVEL* = 0  # обычное окно
GTK_WINDOW_POPUP*    = 1  # всплывающее (без декорации)
```

### Флаги отладки GTK

`GTK_DEBUG_TEXT`, `GTK_DEBUG_TREE`, `GTK_DEBUG_LAYOUT`, `GTK_DEBUG_A11Y` и другие — для установки через `gtk_set_debug_flags`.

---

## 4. GTK — инициализация

### `gtk_init()`

**Что делает:** Инициализирует библиотеку GTK. Должна вызываться до создания любого виджета.

**Когда использовать:** При использовании GTK без `GtkApplication` (редко). В современных приложениях инициализация происходит автоматически при запуске `GtkApplication`.

**Пример:**
```nim
gtk_init()
# Теперь можно создавать виджеты
```

---

### `gtk_init_check(): gboolean`

**Что делает:** То же, что `gtk_init`, но возвращает `FALSE` если GTK не может инициализироваться (например, нет дисплея).

**Когда использовать:** В инструментах командной строки, которые могут работать и без GUI.

**Пример:**
```nim
if gtk_init_check() == FALSE:
  echo "GTK недоступен, работаем без GUI"
```

---

### Версионирование

```nim
proc gtk_get_major_version*(): cuint
proc gtk_get_minor_version*(): cuint
proc gtk_get_micro_version*(): cuint
```

### `gtk_check_version(major, minor, micro): cstring`

**Что делает:** Проверяет, соответствует ли установленная версия GTK минимальным требованиям. Возвращает `nil` при успехе или строку с описанием проблемы.

**Пример:**
```nim
let err = gtk_check_version(4, 12, 0)
if err != nil:
  echo "Требуется GTK 4.12+: ", $err
```

---

### `gtk_is_initialized(): gboolean`

**Что делает:** Проверяет, была ли GTK уже инициализирована.

---

### `gtk_set_debug_flags(flags)` / `gtk_get_debug_flags()`

**Что делает:** Включает флаги отладки GTK. Принимает комбинацию констант `GTK_DEBUG_*`.

**Пример:**
```nim
gtk_set_debug_flags(GTK_DEBUG_LAYOUT or GTK_DEBUG_SNAPSHOT)
```

---

## 5. GtkApplication

### `gtk_application_new(applicationId, flags): GtkApplication`

**Что делает:** Создаёт объект приложения GTK. `applicationId` должен быть уникальным DNS-подобным именем (например, `"com.example.MyApp"`).

**Когда использовать:** Всегда. `GtkApplication` — правильная точка входа в GTK4-приложение. Управляет жизненным циклом, единственным экземпляром, D-Bus.

**Пример:**
```nim
let app = gtk_application_new("com.example.myapp", G_APPLICATION_DEFAULT_FLAGS)
discard g_signal_connect(app, "activate", cast[GCallback](onActivate), nil)
let status = g_application_run(cast[GApplication](app), 0, nil)
```

---

### `gtk_application_window_new(application): GtkWindow`

**Что делает:** Создаёт окно, привязанное к приложению. Приложение завершается, когда закрывается последнее такое окно.

**Пример:**
```nim
proc onActivate(app: GtkApplication, data: pointer) {.cdecl.} =
  let win = gtk_application_window_new(app)
  gtk_window_set_title(win, "Моё приложение")
  gtk_window_set_default_size(win, 800, 600)
  gtk_window_present(win)
```

---

### `gtk_application_set_accels_for_action(app, detailedActionName, accels)`

**Что делает:** Регистрирует горячие клавиши для именованных действий.

**Пример:**
```nim
var saveAccels = ["<Control>S".cstring, nil]
gtk_application_set_accels_for_action(app, "app.save", addr saveAccels[0])
var quitAccels = ["<Control>Q".cstring, nil]
gtk_application_set_accels_for_action(app, "app.quit", addr quitAccels[0])
```

---

### `gtk_application_set_menubar(app, menubar)`

**Что делает:** Устанавливает меню-строку приложения (на macOS оно отображается в системной полосе меню, на Linux — в HeaderBar или отдельной полосе).

---

### `gtk_application_inhibit(app, window, flags, reason): cuint`

**Что делает:** Запрещает определённые системные действия (сон, выход из системы). Возвращает cookie для последующей отмены через `uninhibit`.

**Когда использовать:** При воспроизведении видео/аудио или активных загрузках — запрет перехода в сон.

**Пример:**
```nim
let cookie = gtk_application_inhibit(app, mainWin, 
  GTK_APPLICATION_INHIBIT_SUSPEND, "Идёт загрузка")
# После завершения:
gtk_application_uninhibit(app, cookie)
```

---

### `gtk_application_get_active_window(app): GtkWindow`

**Что делает:** Возвращает окно, которое в данный момент имеет фокус.

---

## 6. GApplication

Базовый класс для `GtkApplication`. Управляет запуском, жизненным циклом и D-Bus интеграцией.

### `g_application_run(app, argc, argv): gint`

**Что делает:** Запускает главный цикл приложения. Блокирует выполнение до завершения всех окон. Возвращает код завершения.

**Это главная функция, с которой начинается любое GTK4-приложение.**

**Пример:**
```nim
let exitCode = g_application_run(cast[GApplication](app), 0, nil)
echo "Код завершения: ", exitCode
```

---

### `g_application_quit(app)`

**Что делает:** Завершает приложение программно — закрывает все окна и останавливает главный цикл.

---

### `g_application_hold(app)` / `g_application_release(app)`

**Что делает:** Удерживает приложение от автоматического завершения. `hold` увеличивает счётчик, `release` — уменьшает. Когда счётчик достигает 0 и нет открытых окон — приложение завершается.

**Когда использовать:** Для фоновых сервисов, которые должны работать без окон.

---

### `g_application_mark_busy(app)` / `g_application_unmark_busy(app)`

**Что делает:** Помечает приложение как занятое (обновляет индикатор в taskbar/dock).

---

### `g_application_send_notification(app, id, notification)`

**Что делает:** Отправляет системное уведомление.

---

### `g_application_add_main_option(app, longName, shortName, flags, arg, description, argDescription)`

**Что делает:** Добавляет параметр командной строки. Обрабатывается до запуска главного цикла.

**Пример:**
```nim
g_application_add_main_option(app, "verbose", 'v', 
  G_OPTION_FLAG_NONE, G_OPTION_ARG_NONE,
  "Подробный вывод", nil)
```

---

### D-Bus интеграция

```nim
proc g_application_get_dbus_connection(app): pointer  # GDBusConnection
proc g_application_get_dbus_object_path(app): cstring
```

**Когда использовать:** Для межпроцессного взаимодействия — экспорта интерфейсов, получения методов от других приложений.

---

## 7. Сигналы (GLib Signals)

Система сигналов — основа событийно-ориентированного программирования в GTK. Сигналы — это именованные события объектов GLib.

### `g_signal_connect` (template)

**Что делает:** Подключает коллбэк к сигналу объекта. Это шаблон-обёртка над `g_signal_connect_data`.

**Сигнатура:** `g_signal_connect(instance, signal, callback, data) → gulong`

**Результат:** ID подключения (`gulong`). Используется для последующего отключения.

**Пример:**
```nim
proc onClicked(btn: GtkButton, data: pointer) {.cdecl.} =
  echo "Нажато!"

let handlerId = g_signal_connect(button, "clicked", 
                                  cast[GCallback](onClicked), nil)
```

---

### `g_signal_connect_data(instance, signal, handler, data, destroyData, connectFlags): gulong`

**Что делает:** Расширенная версия подключения сигнала. `connectFlags = 1` означает "вызвать после стандартных обработчиков" (аналог `connect_after`).

---

### `g_signal_handler_disconnect(instance, handlerId)`

**Что делает:** Полностью отсоединяет обработчик по ID. После этого коллбэк не будет вызываться.

---

### `g_signal_handler_block(instance, handlerId)` / `g_signal_handler_unblock`

**Что делает:** Временно блокирует/разблокирует обработчик без его удаления. Полезно для предотвращения рекурсивных вызовов при программном изменении виджета.

**Пример:**
```nim
# Изменяем значение без срабатывания onChanged:
g_signal_handler_block(spinButton, onChangedId)
gtk_spin_button_set_value(spinButton, 42.0)
g_signal_handler_unblock(spinButton, onChangedId)
```

---

### `g_signal_emit_by_name(instance, detailedSignal, ...)`

**Что делает:** Программно испускает сигнал, как будто он произошёл естественным образом.

**Пример:**
```nim
g_signal_emit_by_name(button, "clicked")  # Имитирует нажатие
```

---

### `g_signal_handler_find(instance, mask, signalId, detail, closure, func, data): gulong`

**Что делает:** Ищет существующий обработчик по критериям (функции, данным, сигналу). Возвращает его ID.

---

### `g_signal_handlers_block_by_func` / `g_signal_handlers_unblock_by_func` / `g_signal_handlers_disconnect_by_func`

**Что делает:** Блокирует/разблокирует/отсоединяет все обработчики, зарегистрированные с конкретным указателем на функцию.

---

### `g_signal_handlers_disconnect_by_data(instance, data)`

**Что делает:** Отсоединяет все обработчики, зарегистрированные с конкретным `data`-указателем. Удобно при уничтожении объекта данных.

---

### Информация о сигналах

```nim
proc g_signal_lookup(name, itype): cuint      # ID сигнала по имени
proc g_signal_name(signalId): cstring         # имя сигнала по ID
proc g_signal_list_ids(itype, nIds): ptr cuint # все сигналы типа
proc g_signal_query(signalId, query)          # детальная информация
```

---

### `g_signal_stop_emission_by_name(instance, detailedSignal)`

**Что делает:** Останавливает текущее распространение сигнала. Вызывается внутри обработчика для предотвращения обработки сигнала последующими обработчиками.

---

### `g_signal_new(signalName, itype, flags, classOffset, accumulator, accuData, marshaller, returnType, nParams, ...): cuint`

**Что делает:** Регистрирует новый пользовательский сигнал для типа GObject. Используется при создании собственных GObject-типов.

---

## 8. Actions (GAction / GSimpleAction)

Actions — именованные действия, которые можно активировать из меню, кнопок, клавиатурных сочетаний. Они правильно работают в многооконных приложениях.

### `g_simple_action_new(name, parameterType): GSimpleAction`

**Что делает:** Создаёт действие без состояния. `parameterType = nil` — действие без аргументов.

**Пример:**
```nim
let saveAction = g_simple_action_new("save", nil)
discard g_signal_connect(saveAction, "activate", cast[GCallback](onSave), nil)
g_action_map_add_action(cast[GActionMap](app), cast[GAction](saveAction))
# Теперь действие доступно как "app.save"
```

---

### `g_simple_action_new_stateful(name, parameterType, state): GSimpleAction`

**Что делает:** Создаёт действие с состоянием (для переключателей, выбора из списка).

**Пример:**
```nim
# Действие-переключатель (boolean state):
let darkModeAction = g_simple_action_new_stateful(
  "dark-mode", nil, g_variant_new_boolean(FALSE))
discard g_signal_connect(darkModeAction, "change-state", 
                         cast[GCallback](onDarkModeChanged), nil)
g_action_map_add_action(cast[GActionMap](app), cast[GAction](darkModeAction))
```

---

### `g_simple_action_set_enabled(action, enabled)` / `g_simple_action_set_state(action, value)`

**Что делает:** Включает/отключает действие (серая кнопка меню). `set_state` обновляет состояние без испускания `change-state`.

---

### `g_action_map_add_action(actionMap, action)`

**Что делает:** Добавляет действие в карту действий (`GApplication`, виджет, `GActionGroup`).

---

### `g_action_map_add_action_entries(actionMap, entries, nEntries, userData)`

**Что делает:** Массовое добавление действий из таблицы `GActionEntry`. Каждый элемент содержит имя, коллбэк активации и опционально тип параметра и коллбэк изменения состояния.

**Пример:**
```nim
var entries: array[2, GActionEntry] = [
  GActionEntry(name: "quit", 
               activate: proc(a: GSimpleAction, p: GVariant, d: gpointer) {.cdecl.} =
                 g_application_quit(cast[GApplication](app))),
  GActionEntry(name: "about",
               activate: proc(a: GSimpleAction, p: GVariant, d: gpointer) {.cdecl.} =
                 showAboutDialog())
]
g_action_map_add_action_entries(cast[GActionMap](app), addr entries[0], 2, nil)
```

---

### `g_property_action_new(name, obj, propertyName): GPropertyAction`

**Что делает:** Создаёт действие, которое автоматически привязывается к свойству GObject. Изменение свойства обновляет состояние действия и наоборот.

**Пример:**
```nim
# Кнопка "Показать боковую панель" ↔ свойство "visible" панели:
let showSidebar = g_property_action_new("show-sidebar", sidebarWidget, "visible")
g_action_map_add_action(cast[GActionMap](win), cast[GAction](showSidebar))
```

---

### `gtk_actionable_set_action_name(actionable, actionName)`

**Что делает:** Подключает виджет (кнопку, пункт меню) к именованному действию. Виджет должен реализовывать интерфейс `GtkActionable`.

**Пример:**
```nim
gtk_actionable_set_action_name(saveButton, "app.save")
# Кнопка теперь активирует действие "app.save" при нажатии
```

---

### `gtk_widget_insert_action_group(widget, name, group)`

**Что делает:** Регистрирует группу действий в дереве виджетов. Действия из группы становятся доступны с префиксом `name.`.

**Пример:**
```nim
let group = cast[GActionGroup](gtk_application_get_active_window(app))
gtk_widget_insert_action_group(headerBar, "win", group)
```

---

## 9. GMenu — модель меню

`GMenu` — декларативная модель данных для меню. Не является виджетом — только описание структуры.

### `g_menu_new(): GMenu`

**Что делает:** Создаёт пустое меню.

---

### `g_menu_append(menu, label, detailedAction)`

**Что делает:** Добавляет пункт меню в конец. `detailedAction` — строка вида `"app.save"` или `"win.close"`.

**Пример:**
```nim
let menu = g_menu_new()
g_menu_append(menu, "Открыть", "app.open")
g_menu_append(menu, "Сохранить", "app.save")
g_menu_append_section(menu, nil, separatorMenu)
g_menu_append(menu, "Выход", "app.quit")
gtk_application_set_menubar(app, cast[GMenuModel](menu))
```

---

### `g_menu_append_section(menu, label, section: GMenuModel)`

**Что делает:** Добавляет именованную (или безымянную при `label = nil`) секцию меню с разделителем.

---

### `g_menu_append_submenu(menu, label, submenu: GMenuModel)`

**Что делает:** Добавляет подменю.

**Пример:**
```nim
let viewMenu = g_menu_new()
g_menu_append(viewMenu, "Полный экран", "win.fullscreen")

let mainMenu = g_menu_new()
g_menu_append_submenu(mainMenu, "Вид", cast[GMenuModel](viewMenu))
```

---

### `g_menu_remove(menu, position)` / `g_menu_remove_all(menu)`

**Что делает:** Удаляет пункт по индексу или очищает меню полностью.

---

## 10. GtkWindow

### `gtk_window_new(): GtkWindow`

**Что делает:** Создаёт окно верхнего уровня без привязки к `GtkApplication`.

**Когда использовать:** Для вспомогательных окон, диалогов, управляемых вручную.

---

### `gtk_window_set_title(window, title)` / `gtk_window_get_title(window): cstring`

**Что делает:** Устанавливает/возвращает заголовок окна.

---

### `gtk_window_set_default_size(window, width, height)`

**Что делает:** Задаёт начальный размер окна. `-1` для любого из параметров означает «определить автоматически».

---

### `gtk_window_set_resizable(window, resizable)`

**Что делает:** Разрешает или запрещает пользователю изменять размер окна.

---

### `gtk_window_set_modal(window, modal)`

**Что делает:** При `TRUE` окно блокирует ввод в родительское окно.

---

### `gtk_window_set_transient_for(window, parent)`

**Что делает:** Устанавливает родительское окно. Это важно для модальных диалогов — они отображаются поверх родителя и центрируются относительно него.

---

### `gtk_window_set_child(window, child)` / `gtk_window_get_child`

**Что делает:** Устанавливает единственный дочерний виджет окна (например, `GtkBox` или `GtkGrid`).

---

### `gtk_window_set_titlebar(window, titlebar)`

**Что делает:** Устанавливает кастомный заголовок окна (обычно `GtkHeaderBar`), заменяя стандартный оконный декор.

---

### `gtk_window_present(window)`

**Что делает:** Показывает окно и выводит его на передний план. Предпочтительнее `gtk_widget_show` — корректно работает с управлением фокусом.

---

### Управление состоянием окна

```nim
gtk_window_close(window)        # Закрыть (испускает "delete-event")
gtk_window_destroy(window)      # Уничтожить немедленно
gtk_window_fullscreen(window)   # Полный экран
gtk_window_unfullscreen(window) # Выход из полного экрана
gtk_window_maximize(window)     # Развернуть
gtk_window_unmaximize(window)   # Восстановить
gtk_window_minimize(window)     # Свернуть
gtk_window_unminimize(window)   # Развернуть из панели задач
gtk_window_is_fullscreen(window): gboolean
```

---

### Иконки окна

```nim
gtk_window_set_default_icon_name("myapp-icon")  # Для всех окон
gtk_window_set_icon_name(win, "myapp-icon")     # Для конкретного окна
```

---

### `gtk_window_set_decorated(window, setting)`

**Что делает:** При `FALSE` убирает рамку и заголовок (нужен для splash-screen, панелей).

---

### `gtk_window_set_deletable(window, setting)`

**Что делает:** При `FALSE` скрывает кнопку закрытия. Используй осторожно — пользователь должен иметь способ закрыть окно.

---

## 11. GtkWidget — базовые функции

Эти функции работают с **любым** виджетом GTK (так как все типы виджетов — это `pointer`).

### Видимость и чувствительность

```nim
gtk_widget_show(widget)                        # Показать (устаревшее в GTK4, лучше set_visible)
gtk_widget_hide(widget)                        # Скрыть
gtk_widget_set_visible(widget, visible)        # Показать/скрыть
gtk_widget_get_visible(widget): gboolean       # Проверить видимость
gtk_widget_set_sensitive(widget, sensitive)    # Включить/отключить (серый)
gtk_widget_get_sensitive(widget): gboolean
```

### Размер и расположение

```nim
gtk_widget_set_size_request(widget, width, height)  # Мин. размер (-1 = авто)
gtk_widget_get_size_request(widget, addr w, addr h)
gtk_widget_set_hexpand(widget, TRUE)  # Расширяться по горизонтали
gtk_widget_set_vexpand(widget, TRUE)  # Расширяться по вертикали
gtk_widget_set_halign(widget, GTK_ALIGN_CENTER)
gtk_widget_set_valign(widget, GTK_ALIGN_START)
```

### Отступы

```nim
gtk_widget_set_margin_start(widget, 8)   # Левый отступ
gtk_widget_set_margin_end(widget, 8)     # Правый отступ
gtk_widget_set_margin_top(widget, 4)     # Верхний отступ
gtk_widget_set_margin_bottom(widget, 4)  # Нижний отступ
```

### Подсказки

```nim
gtk_widget_set_tooltip_text(widget, "Это кнопка сохранения")
gtk_widget_set_tooltip_markup(widget, "<b>Сохранить</b> (Ctrl+S)")
gtk_widget_set_has_tooltip(widget, TRUE)  # Для кастомных подсказок
```

### CSS-классы

```nim
gtk_widget_add_css_class(widget, "suggested-action")
gtk_widget_remove_css_class(widget, "destructive-action")
gtk_widget_has_css_class(widget, "active"): gboolean
gtk_widget_set_name(widget, "unique-id")  # Для CSS #unique-id { }
gtk_widget_get_name(widget): cstring
```

### Навигация по дереву виджетов

```nim
gtk_widget_get_parent(widget): GtkWidget      # Родительский контейнер
gtk_widget_get_first_child(widget): GtkWidget # Первый дочерний
gtk_widget_get_last_child(widget): GtkWidget  # Последний дочерний
gtk_widget_get_next_sibling(widget): GtkWidget # Следующий сосед
gtk_widget_get_prev_sibling(widget): GtkWidget # Предыдущий сосед
```

**Пример обхода дочерних элементов:**
```nim
var child = gtk_widget_get_first_child(container)
while child != nil:
  # Обработать child
  child = gtk_widget_get_next_sibling(child)
```

### Фокус

```nim
gtk_widget_grab_focus(widget): gboolean
gtk_widget_set_can_focus(widget, TRUE)
gtk_widget_get_can_focus(widget): gboolean
```

### Привязка действий к виджету

```nim
gtk_widget_insert_action_group(widget, "name", group)
gtk_widget_action_set_enabled(widget, "action-name", TRUE)
gtk_widget_get_ancestor(widget, widgetType): GtkWidget
gtk_widget_get_display(widget): GdkDisplay
gtk_widget_get_style_context(widget): GtkStyleContext
```

---

## 12. GtkBox

Линейный контейнер — размещает дочерние виджеты в ряд (горизонтально или вертикально).

### `gtk_box_new(orientation, spacing): GtkBox`

**Что делает:** Создаёт Box с заданной ориентацией и отступом между дочерними виджетами.

**Пример:**
```nim
let vbox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)
let hbox = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 4)
```

---

### Управление дочерними виджетами

```nim
gtk_box_append(box, child)                         # В конец
gtk_box_prepend(box, child)                        # В начало
gtk_box_remove(box, child)                         # Удалить
gtk_box_insert_child_after(box, child, sibling)    # После sibling
gtk_box_reorder_child_after(box, child, sibling)   # Переставить после sibling
```

### Настройки

```nim
gtk_box_set_spacing(box, 8)            # Отступ между элементами
gtk_box_set_homogeneous(box, TRUE)     # Одинаковый размер для всех
gtk_box_set_baseline_position(box, GTK_BASELINE_POSITION_CENTER)
gtk_box_set_baseline_child(box, 0)     # Виджет-ориентир для baseline (-1 = нет)
```

---

## 13. GtkGrid

Контейнер-сетка с произвольным размещением по строкам и столбцам.

### `gtk_grid_new(): GtkGrid`

**Что делает:** Создаёт пустую сетку.

---

### `gtk_grid_attach(grid, child, column, row, width, height)`

**Что делает:** Размещает виджет в ячейке с указанной позицией и размером (в единицах ячеек).

**Пример:**
```nim
let grid = gtk_grid_new()
gtk_grid_set_row_spacing(grid, 8)
gtk_grid_set_column_spacing(grid, 6)

gtk_grid_attach(grid, nameLabel, 0, 0, 1, 1)   # колонка 0, строка 0
gtk_grid_attach(grid, nameEntry, 1, 0, 2, 1)   # колонка 1, строка 0, ширина 2
gtk_grid_attach(grid, emailLabel, 0, 1, 1, 1)
gtk_grid_attach(grid, emailEntry, 1, 1, 2, 1)
```

---

### `gtk_grid_attach_next_to(grid, child, sibling, side, width, height)`

**Что делает:** Размещает виджет рядом с `sibling` со стороны `side` (`GTK_POS_LEFT/RIGHT/TOP/BOTTOM`).

---

### `gtk_grid_get_child_at(grid, column, row): GtkWidget`

**Что делает:** Возвращает виджет в ячейке с указанными координатами (или `nil`).

---

### Динамическое изменение структуры

```nim
gtk_grid_insert_row(grid, 2)     # Вставить строку перед позицией 2
gtk_grid_insert_column(grid, 1)  # Вставить колонку перед позицией 1
gtk_grid_remove_row(grid, 0)     # Удалить строку 0
gtk_grid_remove_column(grid, 2)  # Удалить колонку 2
gtk_grid_insert_next_to(grid, sibling, GTK_POS_BOTTOM)  # Вставить рядом
```

---

### `gtk_grid_query_child(grid, child, column, row, width, height)`

**Что делает:** Записывает в переданные указатели положение и размер виджета в сетке.

**Пример:**
```nim
var col, row, w, h: gint
gtk_grid_query_child(grid, myWidget, addr col, addr row, addr w, addr h)
echo "Виджет в колонке ", col, " строке ", row
```

---

### Spacing и homogeneous

```nim
gtk_grid_set_row_spacing(grid, 10)
gtk_grid_set_column_spacing(grid, 8)
gtk_grid_set_row_homogeneous(grid, FALSE)     # Все строки одной высоты
gtk_grid_set_column_homogeneous(grid, FALSE)  # Все колонки одной ширины
```

---

## 14. GtkButton

### `gtk_button_new_with_label(label): GtkButton`

**Что делает:** Создаёт кнопку с текстом. Самый распространённый вариант создания.

---

### `gtk_button_new_with_mnemonic(label): GtkButton`

**Что делает:** Создаёт кнопку с мнемоникой — подчёркнутый символ после `_` активирует кнопку по Alt+символ.

**Пример:**
```nim
let btn = gtk_button_new_with_mnemonic("_Сохранить")  # Alt+С
```

---

### `gtk_button_new_from_icon_name(iconName): GtkButton`

**Что делает:** Создаёт кнопку с иконкой из темы иконок.

**Пример:**
```nim
let closeBtn = gtk_button_new_from_icon_name("window-close")
let addBtn = gtk_button_new_from_icon_name("list-add")
```

---

### Управление содержимым

```nim
gtk_button_set_label(button, "Применить")
gtk_button_get_label(button): cstring
gtk_button_set_icon_name(button, "document-save")
gtk_button_set_child(button, customWidget)  # Произвольный виджет вместо текста
gtk_button_set_has_frame(button, FALSE)     # Убрать рамку (плоская кнопка)
gtk_button_set_can_shrink(button, TRUE)     # Разрешить сжатие меньше мин. размера
gtk_button_set_use_underline(button, TRUE)  # Активировать мнемоники
```

### Привязка к действию

```nim
gtk_button_set_action_name(button, "app.save")
# Кнопка автоматически активирует действие при нажатии
# и серая при отключённом действии
```

### Сигнал

```nim
discard g_signal_connect(button, "clicked", cast[GCallback](onClicked), nil)
```

---

## 15. GtkToggleButton

Кнопка с состоянием нажатия/отжатия.

### `gtk_toggle_button_new_with_label(label): GtkToggleButton`

---

### `gtk_toggle_button_set_active(toggle, isActive)` / `gtk_toggle_button_get_active`

**Что делает:** Устанавливает/читает состояние.

---

### `gtk_toggle_button_toggled(toggle)`

**Что делает:** Программно переключает кнопку (испускает сигнал `toggled`).

---

### `gtk_toggle_button_set_group(toggle, group)`

**Что делает:** Добавляет кнопку в группу — только одна из группы может быть нажата. Это создаёт поведение радиокнопки. Передача `nil` удаляет из группы.

**Пример:**
```nim
let rbDay = gtk_toggle_button_new_with_label("День")
let rbWeek = gtk_toggle_button_new_with_label("Неделя")
let rbMonth = gtk_toggle_button_new_with_label("Месяц")
gtk_toggle_button_set_group(rbWeek, rbDay)    # Та же группа, что rbDay
gtk_toggle_button_set_group(rbMonth, rbDay)   # Та же группа, что rbDay
gtk_toggle_button_set_active(rbDay, TRUE)     # Выбрать "День" по умолчанию
```

---

## 16. GtkCheckButton

В GTK4 `GtkCheckButton` объединяет функциональность чекбоксов и радиокнопок.

### `gtk_check_button_new_with_label(label): GtkCheckButton`

---

### `gtk_check_button_set_active(checkButton, setting)` / `gtk_check_button_get_active`

**Что делает:** Устанавливает/читает состояние отметки.

---

### `gtk_check_button_set_inconsistent(checkButton, inconsistent)`

**Что делает:** Устанавливает неопределённое состояние (чёрточка вместо галочки или пустоты). Используется для "некоторые из дочерних отмечены".

---

### `gtk_check_button_set_group(checkButton, group)`

**Что делает:** Группирует чекбоксы для поведения радиокнопок (GTK4-замена устаревшему `GtkRadioButton`).

**Пример:**
```nim
let cbA = gtk_check_button_new_with_label("Вариант A")
let cbB = gtk_check_button_new_with_label("Вариант B")
let cbC = gtk_check_button_new_with_label("Вариант C")
gtk_check_button_set_group(cbB, cbA)
gtk_check_button_set_group(cbC, cbA)
gtk_check_button_set_active(cbA, TRUE)

discard g_signal_connect(cbA, "toggled", cast[GCallback](onVariantChanged), nil)
```

---

## 17. GtkSwitch

Переключатель on/off с двумя различными состояниями: `active` (визуальное) и `state` (логическое).

### `gtk_switch_new(): GtkSwitch`

---

### `gtk_switch_set_active(sw, isActive)` / `gtk_switch_get_active`

**Что делает:** Немедленно меняет визуальное состояние и испускает сигналы.

---

### `gtk_switch_set_state(sw, state)` / `gtk_switch_get_state`

**Что делает:** Устанавливает логическое состояние без анимации. Используется в обработчике сигнала `state-set` для подтверждения или отклонения переключения.

**Когда использовать:** Когда переключение требует асинхронной операции (например, включение Bluetooth). Показываем анимацию сразу, а состояние подтверждаем после завершения операции.

**Пример:**
```nim
proc onStateSet(sw: GtkSwitch, newState: gboolean, data: pointer): gboolean {.cdecl.} =
  # Асинхронная операция (bluetooth.enable())
  # Сигнализируем, что мы сами установим state позже:
  return TRUE  # Вернуть TRUE означает "я управляю state вручную"

discard g_signal_connect(switch, "state-set", cast[GCallback](onStateSet), nil)
```

---

## 18. GtkLabel

### `gtk_label_new(str): GtkLabel`

---

### `gtk_label_set_text(label, str)` / `gtk_label_get_text`

**Что делает:** Устанавливает/возвращает обычный текст (без разметки).

---

### `gtk_label_set_markup(label, str)`

**Что делает:** Устанавливает текст с Pango-разметкой: `<b>`, `<i>`, `<span color="red">`, `<a href="...">` и т.д.

**Пример:**
```nim
gtk_label_set_markup(label, "<b>Жирный</b> и <span color='red'>красный</span>")
```

---

### `gtk_label_set_use_markup(label, setting)`

**Что делает:** Включает интерпретацию разметки в тексте, установленном через `set_text`.

---

### Перенос и усечение

```nim
gtk_label_set_wrap(label, TRUE)
gtk_label_set_wrap_mode(label, PANGO_WRAP_WORD_CHAR)
gtk_label_set_ellipsize(label, PANGO_ELLIPSIZE_END)
gtk_label_set_max_width_chars(label, 30)  # Макс. ширина в символах
gtk_label_set_lines(label, 3)            # Макс. количество строк
gtk_label_set_single_line_mode(label, TRUE)
```

---

### Выравнивание текста

```nim
gtk_label_set_justify(label, GTK_JUSTIFY_CENTER)
gtk_label_set_xalign(label, 0.0)  # 0.0=лево, 0.5=центр, 1.0=право
gtk_label_set_yalign(label, 0.5)
```

---

### Выделение

```nim
gtk_label_set_selectable(label, TRUE)           # Разрешить выделение мышью
gtk_label_select_region(label, 0, 5)            # Выделить символы 0..4
gtk_label_get_selection_bounds(label, addr s, addr e): gboolean
```

---

### Мнемоники

```nim
let label = gtk_label_new_with_mnemonic("_Имя пользователя:")
gtk_label_set_mnemonic_widget(label, usernameEntry)
# Alt+И переводит фокус на usernameEntry
```

---

### Pango-атрибуты

```nim
gtk_label_set_attributes(label, pangoAttrList)  # Стилизация через PangoAttrList
gtk_label_get_layout(label): PangoLayout        # Доступ к Pango layout для кастомной отрисовки
gtk_label_get_layout_offsets(label, addr x, addr y)
```

---

### Расширенные функции

```nim
gtk_label_set_natural_wrap_mode(label, GTK_NATURAL_WRAP_WORD)
gtk_label_set_extra_menu(label, menuModel)      # Кастомный контекст. меню
gtk_label_get_current_uri(label): cstring       # URI кликнутой ссылки
gtk_label_set_markup_with_mnemonic(label, str)  # Markup + мнемоника
```

---

## 19. GtkEntry

Однострочное поле ввода текста.

### `gtk_entry_new(): GtkEntry`

---

### Текст и placeholder

> ⚠️ В GTK4 `gtk_entry_get_text` / `gtk_entry_set_text` **удалены**. Используй `gtk_editable_get_text` / `gtk_editable_set_text` из интерфейса `GtkEditable`.

```nim
proc gtk_entry_set_placeholder_text*(entry, text)
proc gtk_entry_get_placeholder_text*(entry): cstring
```

---

### Базовые свойства

```nim
gtk_entry_set_visibility(entry, FALSE)         # Скрыть текст (режим пароля)
gtk_entry_set_max_length(entry, 100)           # Макс. длина текста
gtk_entry_set_has_frame(entry, TRUE)           # Показывать рамку
gtk_entry_set_alignment(entry, 0.5)            # Выравнивание текста (0.0–1.0)
gtk_entry_set_width_chars(entry, 20)           # Мин. ширина в символах
gtk_entry_set_max_width_chars(entry, 50)       # Макс. ширина в символах
gtk_entry_set_activates_default(entry, TRUE)   # Enter активирует кнопку по умолчанию
gtk_entry_get_text_length(entry): guint16      # Текущая длина текста
```

---

### Иконки

Поля ввода в GTK4 могут иметь иконки слева (`PRIMARY`) и справа (`SECONDARY`).

```nim
gtk_entry_set_icon_from_icon_name(entry, GTK_ENTRY_ICON_PRIMARY, "search")
gtk_entry_set_icon_from_icon_name(entry, GTK_ENTRY_ICON_SECONDARY, "edit-clear")
gtk_entry_set_icon_activatable(entry, GTK_ENTRY_ICON_SECONDARY, TRUE)
gtk_entry_set_icon_sensitive(entry, GTK_ENTRY_ICON_PRIMARY, TRUE)
gtk_entry_set_icon_tooltip_text(entry, GTK_ENTRY_ICON_SECONDARY, "Очистить")
```

Обработка нажатия на иконку:
```nim
proc onIconPress(entry: GtkEntry, iconPos: GtkEntryIconPosition, data: pointer) {.cdecl.} =
  if iconPos == GTK_ENTRY_ICON_SECONDARY:
    gtk_editable_set_text(entry, "")

discard g_signal_connect(entry, "icon-press", cast[GCallback](onIconPress), nil)
```

---

### Прогресс-бар в Entry

`GtkEntry` поддерживает встроенный индикатор прогресса (отображается как полоса внизу поля).

```nim
gtk_entry_set_progress_fraction(entry, 0.7)     # 70% заполнен
gtk_entry_progress_pulse(entry)                  # Пульсация (неопределённый прогресс)
gtk_entry_set_progress_pulse_step(entry, 0.1)   # Шаг пульсации
```

---

### Назначение поля и подсказки IM

```nim
gtk_entry_set_input_purpose(entry, GTK_INPUT_PURPOSE_EMAIL)
gtk_entry_set_input_hints(entry, GTK_INPUT_HINT_NO_SPELLCHECK)
```

---

### Автодополнение и буфер

```nim
proc gtk_entry_set_completion*(entry, completion: GtkEntryCompletion)
proc gtk_entry_set_buffer*(entry, buffer: GtkEntryBuffer)
proc gtk_entry_get_buffer*(entry): GtkEntryBuffer
proc gtk_entry_new_with_buffer*(buffer): GtkEntry
```

---

### Невидимый символ (пароль)

```nim
gtk_entry_set_invisible_char(entry, gunichar('•'))  # Символ маскировки
gtk_entry_unset_invisible_char(entry)               # Использовать системный
```

---

### Ключевые сигналы GtkEntry

| Сигнал | Когда испускается |
|---|---|
| `"activate"` | Пользователь нажал Enter |
| `"changed"` | Текст изменился |
| `"icon-press"` | Нажата иконка |
| `"icon-release"` | Отпущена иконка |

---

## 20. GtkPasswordEntry

Специализированный виджет для ввода паролей.

### `gtk_password_entry_new(): GtkPasswordEntry`

---

### `gtk_password_entry_set_show_peek_icon(entry, showPeekIcon)`

**Что делает:** При `TRUE` показывает кнопку «показать пароль» (иконка глаза) справа в поле.

**Пример:**
```nim
let pwd = gtk_password_entry_new()
gtk_password_entry_set_show_peek_icon(pwd, TRUE)
gtk_entry_set_placeholder_text(cast[GtkEntry](pwd), "Пароль")
```

---

### `gtk_password_entry_set_extra_menu(entry, model)`

**Что делает:** Добавляет пункты в контекстное меню поля.

---

## 21. GtkSearchEntry

Поле ввода с иконкой поиска и кнопкой очистки.

### `gtk_search_entry_new(): GtkSearchEntry`

---

### `gtk_search_entry_set_search_delay(entry, delay)`

**Что делает:** Устанавливает задержку (в миллисекундах) перед испусканием сигнала `search-changed` после последнего нажатия клавиши. Позволяет избежать поиска при каждом вводимом символе.

**Пример:**
```nim
let search = gtk_search_entry_new()
gtk_search_entry_set_search_delay(search, 300)  # 300 мс задержка
discard g_signal_connect(search, "search-changed", cast[GCallback](onSearch), nil)
```

---

### `gtk_search_entry_set_key_capture_widget(entry, widget)`

**Что делает:** Указывает виджет, чьи нажатия клавиш будут перехватываться и перенаправляться в поле поиска. Пользователь может начать печатать из любого места интерфейса, и текст попадёт в поле поиска.

**Пример:**
```nim
# Нажатие клавиш в окне → в поле поиска:
gtk_search_entry_set_key_capture_widget(searchEntry, mainWindow)
```

---

### Ключевые сигналы GtkSearchEntry

| Сигнал | Когда испускается |
|---|---|
| `"search-changed"` | Текст изменился (с задержкой) |
| `"activate"` | Нажат Enter |
| `"stop-search"` | Нажат Escape — скрыть поиск |
| `"search-started"` | Начат ввод поискового запроса |
| `"next-match"` / `"previous-match"` | Ctrl+G / Shift+Ctrl+G |

---

## 22. GtkTextView

Многострочный редактор текста с богатым форматированием.

### `gtk_text_view_new(): GtkTextView`

---

### `gtk_text_view_new_with_buffer(buffer): GtkTextView`

**Что делает:** Создаёт редактор с существующим буфером. Несколько `GtkTextView` могут разделять один `GtkTextBuffer`.

---

### `gtk_text_view_get_buffer(textView): GtkTextBuffer`

**Что делает:** Возвращает связанный буфер.

---

### Режим редактирования

```nim
gtk_text_view_set_editable(view, TRUE)
gtk_text_view_set_cursor_visible(view, TRUE)
gtk_text_view_set_overwrite(view, FALSE)      # Вставка vs замена
gtk_text_view_set_accepts_tab(view, TRUE)     # Tab вставляет символ \t
gtk_text_view_set_monospace(view, TRUE)       # Моноширинный шрифт
```

---

### Внешний вид и форматирование

```nim
gtk_text_view_set_wrap_mode(view, PANGO_WRAP_WORD)  # Перенос слов
gtk_text_view_set_justification(view, GTK_JUSTIFY_LEFT)
gtk_text_view_set_left_margin(view, 8)
gtk_text_view_set_right_margin(view, 8)
gtk_text_view_set_top_margin(view, 4)
gtk_text_view_set_bottom_margin(view, 4)
gtk_text_view_set_indent(view, 20)            # Отступ первой строки
gtk_text_view_set_pixels_above_lines(view, 2) # Интервал над строкой
gtk_text_view_set_pixels_below_lines(view, 2) # Интервал под строкой
```

---

### Прокрутка к позиции

```nim
# Прокрутить к маркеру:
gtk_text_view_scroll_to_mark(view, mark, 0.0, FALSE, 0.0, 0.0)

# Прокрутить к итератору:
gtk_text_view_scroll_to_iter(view, addr iter, 0.0, TRUE, 0.5, 0.5)

# Убедиться что маркер вставки (курсор) виден:
gtk_text_view_scroll_mark_onscreen(view, gtk_text_buffer_get_insert(buffer))
```

---

### Преобразование координат

```nim
# Буферные координаты → экранные:
gtk_text_view_buffer_to_window_coords(view, GTK_TEXT_WINDOW_TEXT,
                                      bufX, bufY, addr winX, addr winY)

# Итератор по экранным координатам (для кликов мышью):
gtk_text_view_get_iter_at_location(view, addr iter, x, y): gboolean

# Прямоугольник вокруг символа:
gtk_text_view_get_iter_location(view, addr iter, addr rect)
```

---

### Gutters (боковые области)

```nim
# Добавить нумерацию строк в левый gutter:
gtk_text_view_set_gutter(view, GTK_TEXT_WINDOW_LEFT, lineNumbersWidget)
```

---

### Встроенные виджеты

```nim
# Вставить виджет в поток текста через якорь:
let anchor = gtk_text_buffer_create_child_anchor(buffer, addr iter)
gtk_text_view_add_child_at_anchor(view, button, anchor)

# Оверлейный виджет (позиционируется абсолютно поверх текста):
gtk_text_view_add_overlay(view, infoBar, 10, 10)
```

---

### Навигация по display-строкам (со смягчённым переносом)

```nim
gtk_text_view_forward_display_line(view, addr iter)
gtk_text_view_backward_display_line(view, addr iter)
gtk_text_view_move_visually(view, addr iter, count)
```

---

## 23. GtkTextBuffer

Хранилище текста и форматирования. Не является виджетом — только данные.

### `gtk_text_buffer_new(table): GtkTextBuffer`

**Что делает:** Создаёт новый буфер. `table` — таблица тегов (`nil` → автоматическая).

---

### Установка и получение текста

```nim
gtk_text_buffer_set_text(buffer, text.cstring, -1)  # -1 = авто-длина

# Получить весь текст:
var startIter, endIter: GtkTextIter
gtk_text_buffer_get_bounds(buffer, addr startIter, addr endIter)
let text = $gtk_text_buffer_get_text(buffer, addr startIter, addr endIter, FALSE)

# Получить количество символов и строк:
let chars = gtk_text_buffer_get_char_count(buffer)
let lines = gtk_text_buffer_get_line_count(buffer)
```

---

### Вставка текста

```nim
# В позицию итератора:
gtk_text_buffer_insert(buffer, addr iter, "Hello", -1)

# В позицию курсора (insert mark):
gtk_text_buffer_insert_at_cursor(buffer, "World", -1)

# Markup (Pango HTML):
gtk_text_buffer_insert_markup(buffer, addr iter, "<b>Жирный</b>", -1)

# Изображение:
gtk_text_buffer_insert_paintable(buffer, addr iter, cast[GdkPaintable](texture))
```

---

### Получение итераторов

```nim
# Начало и конец:
gtk_text_buffer_get_start_iter(buffer, addr iter)
gtk_text_buffer_get_end_iter(buffer, addr iter)

# По строке (0-indexed):
gtk_text_buffer_get_iter_at_line(buffer, addr iter, lineNumber)

# По символьному смещению:
gtk_text_buffer_get_iter_at_offset(buffer, addr iter, charOffset)

# По строке + колонке:
gtk_text_buffer_get_iter_at_line_offset(buffer, addr iter, line, col)

# По маркеру:
gtk_text_buffer_get_iter_at_mark(buffer, addr iter, mark)
```

---

### Маркеры (закладки в тексте)

```nim
# Создать именованный маркер:
let mark = gtk_text_buffer_create_mark(buffer, "myMark", addr iter, FALSE)

# Переместить маркер:
gtk_text_buffer_move_mark(buffer, mark, addr newIter)

# Получить маркер курсора:
let insertMark = gtk_text_buffer_get_insert(buffer)

# Получить маркер конца выделения:
let selBound = gtk_text_buffer_get_selection_bound(buffer)

# Переместить курсор:
gtk_text_buffer_place_cursor(buffer, addr iter)
```

---

### Выделение

```nim
gtk_text_buffer_select_range(buffer, addr insertIter, addr boundIter)
gtk_text_buffer_get_selection_bounds(buffer, addr start, addr end): gboolean
gtk_text_buffer_get_has_selection(buffer): gboolean
gtk_text_buffer_delete_selection(buffer, TRUE, TRUE): gboolean
```

---

### Теги форматирования

```nim
# Применить тег к диапазону:
gtk_text_buffer_apply_tag(buffer, tag, addr startIter, addr endIter)
gtk_text_buffer_remove_tag(buffer, tag, addr startIter, addr endIter)
gtk_text_buffer_remove_all_tags(buffer, addr startIter, addr endIter)

# По имени:
gtk_text_buffer_apply_tag_by_name(buffer, "bold", addr s, addr e)
```

---

### Буфер обмена

```nim
let clip = gdk_display_get_clipboard(gdk_display_get_default())
gtk_text_buffer_copy_clipboard(buffer, clip)
gtk_text_buffer_cut_clipboard(buffer, clip, TRUE)
gtk_text_buffer_paste_clipboard(buffer, clip, nil, TRUE)
```

---

### Undo/Redo (встроенный в GTK4)

```nim
gtk_text_buffer_set_enable_undo(buffer, TRUE)
gtk_text_buffer_undo(buffer)
gtk_text_buffer_redo(buffer)
gtk_text_buffer_get_can_undo(buffer): gboolean
gtk_text_buffer_get_can_redo(buffer): gboolean
gtk_text_buffer_set_max_undo_levels(buffer, 50)

# Группировка операций для undo:
gtk_text_buffer_begin_user_action(buffer)
gtk_text_buffer_insert(buffer, addr iter, "первая часть", -1)
gtk_text_buffer_insert(buffer, addr iter, " вторая часть", -1)
gtk_text_buffer_end_user_action(buffer)
# Обе вставки отменяются одним Ctrl+Z

# Необратимые действия (не попадают в undo):
gtk_text_buffer_begin_irreversible_action(buffer)
# ... форматирование, которое нельзя отменить ...
gtk_text_buffer_end_irreversible_action(buffer)
```

---

### Modified flag

```nim
gtk_text_buffer_set_modified(buffer, FALSE)  # После сохранения файла
gtk_text_buffer_get_modified(buffer): gboolean  # Есть несохранённые изменения?
# Сигнал "modified-changed" испускается при изменении флага
```

---

## 24. GtkScrolledWindow

Контейнер с полосами прокрутки.

### `gtk_scrolled_window_new(): GtkScrolledWindow`

---

### `gtk_scrolled_window_set_child(scrolledWindow, child)`

**Что делает:** Устанавливает дочерний виджет для прокрутки.

---

### `gtk_scrolled_window_set_policy(scrolledWindow, hpolicy, vpolicy)`

**Что делает:** Управляет видимостью горизонтальной и вертикальной полос прокрутки.

| Значение | Поведение |
|---|---|
| `GTK_POLICY_ALWAYS` | Всегда показывать |
| `GTK_POLICY_AUTOMATIC` | Показывать только когда нужно |
| `GTK_POLICY_NEVER` | Никогда не показывать |
| `GTK_POLICY_EXTERNAL` | Управляется снаружи |

**Пример:**
```nim
let scr = gtk_scrolled_window_new()
gtk_scrolled_window_set_policy(scr, GTK_POLICY_NEVER, GTK_POLICY_AUTOMATIC)
gtk_scrolled_window_set_child(scr, textView)
gtk_scrolled_window_set_has_frame(scr, TRUE)  # Рамка вокруг
```

---

## 25. GtkFrame

Контейнер с необязательной подписью и видимой рамкой.

### `gtk_frame_new(label): GtkFrame`

**Параметр `label`:** строка подписи или `nil` (без подписи).

---

```nim
gtk_frame_set_label(frame, "Настройки сети")
gtk_frame_set_child(frame, content)
gtk_frame_set_label_align(frame, 0.0)   # 0.0=лево, 0.5=центр, 1.0=право
gtk_frame_set_label_widget(frame, customLabelWidget)  # Кастомный виджет-заголовок
```

---

## 26. GtkSeparator

### `gtk_separator_new(orientation): GtkSeparator`

**Что делает:** Создаёт горизонтальный или вертикальный разделитель.

**Пример:**
```nim
let hSep = gtk_separator_new(GTK_ORIENTATION_HORIZONTAL)
let vSep = gtk_separator_new(GTK_ORIENTATION_VERTICAL)
```

---

## 27. GtkImage

### `gtk_image_new_from_file(filename): GtkImage`

---

### `gtk_image_new_from_icon_name(iconName): GtkImage`

**Что делает:** Создаёт виджет с системной иконкой по имени (из текущей темы).

---

### `gtk_image_new_from_paintable(paintable): GtkImage`

**Что делает:** Создаёт виджет из `GdkPaintable` (текстура, анимация, кастомная отрисовка).

---

### Изменение изображения

```nim
gtk_image_set_from_file(image, "new_image.png")
gtk_image_set_from_icon_name(image, "dialog-information")
gtk_image_set_from_paintable(image, texture)
gtk_image_set_pixel_size(image, 48)  # Размер иконки в пикселях
gtk_image_get_pixel_size(image): gint
gtk_image_get_paintable(image): GdkPaintable  # Получить текущий GdkPaintable
```

---

## 28. GtkSpinner

Анимированный индикатор загрузки (крутящееся колесо).

### `gtk_spinner_new(): GtkSpinner`
### `gtk_spinner_start(spinner)` / `gtk_spinner_stop(spinner)`

**Пример:**
```nim
let spinner = gtk_spinner_new()
gtk_spinner_start(spinner)
# После завершения:
gtk_spinner_stop(spinner)
gtk_widget_set_visible(spinner, FALSE)
```

---

## 29. GtkProgressBar

### `gtk_progress_bar_new(): GtkProgressBar`

---

```nim
gtk_progress_bar_set_fraction(pbar, 0.75)    # 75% — значение от 0.0 до 1.0
gtk_progress_bar_get_fraction(pbar): gdouble
gtk_progress_bar_set_text(pbar, "Загрузка...") # Текст поверх полосы
gtk_progress_bar_set_show_text(pbar, TRUE)
gtk_progress_bar_pulse(pbar)                  # Анимация неопределённого прогресса
```

**Пример индикатора с таймером:**
```nim
proc onTimer(data: gpointer): gboolean {.cdecl.} =
  gtk_progress_bar_pulse(cast[GtkProgressBar](data))
  return TRUE  # Продолжать

discard g_timeout_add(100, cast[GSourceFunc](onTimer), progressBar)
```

---

## 30. GtkSpinButton

Числовой счётчик.

### `gtk_spin_button_new_with_range(min, max, step): GtkSpinButton`

**Самый удобный конструктор.**

---

### `gtk_spin_button_new(adjustment, climbRate, digits): GtkSpinButton`

**Что делает:** Полный конструктор с явным `GtkAdjustment`. `climbRate` — скорость изменения при удержании кнопки.

---

```nim
gtk_spin_button_set_value(spin, 42.0)
gtk_spin_button_get_value(spin): gdouble
gtk_spin_button_get_value_as_int(spin): gint
gtk_spin_button_set_digits(spin, 2)           # 2 знака после запятой
gtk_spin_button_set_range(spin, 0.0, 100.0)
gtk_spin_button_get_range(spin, addr min, addr max)
```

**Пример:**
```nim
let spin = gtk_spin_button_new_with_range(1.0, 10.0, 0.5)
gtk_spin_button_set_value(spin, 5.0)
gtk_spin_button_set_digits(spin, 1)  # "5.0"

discard g_signal_connect(spin, "value-changed", cast[GCallback](onValueChanged), nil)
```

---

## 31. GtkAdjustment

Объект, описывающий числовой диапазон. Разделяется между `GtkSpinButton`, `GtkScale`, `GtkScrolledWindow`.

### `gtk_adjustment_new(value, lower, upper, stepIncrement, pageIncrement, pageSize): GtkAdjustment`

| Параметр | Описание |
|---|---|
| `value` | Начальное значение |
| `lower` | Минимум |
| `upper` | Максимум |
| `stepIncrement` | Шаг при нажатии кнопок/клавиш |
| `pageIncrement` | Шаг при нажатии PgUp/PgDn |
| `pageSize` | Размер "страницы" (для полос прокрутки) |

**Пример:**
```nim
let adj = gtk_adjustment_new(0.0, 0.0, 100.0, 1.0, 10.0, 0.0)
let scale = gtk_scale_new(GTK_ORIENTATION_HORIZONTAL, adj)
let spin = gtk_spin_button_new(adj, 1.0, 0)
# scale и spin разделяют одно состояние через adj
```

---

## 32. GtkScale / GtkRange

### `gtk_scale_new_with_range(orientation, min, max, step): GtkScale`

---

```nim
gtk_scale_set_digits(scale, 0)                        # Целые значения
gtk_scale_set_draw_value(scale, TRUE)                  # Показывать текущее значение
gtk_scale_set_value_pos(scale, GTK_POS_BOTTOM)        # Позиция значения
gtk_range_set_value(cast[GtkRange](scale), 50.0)      # Установить значение
```

**Сигналы:**
```nim
discard g_signal_connect(scale, "value-changed", cast[GCallback](onValueChanged), nil)
```

---

## 33. GtkComboBoxText / GtkComboBox (устаревшие)

> ⚠️ Устарели в GTK4. Используй `GtkDropDown` + `GtkStringList`.

### `gtk_combo_box_text_new(): GtkComboBoxText`

---

```nim
gtk_combo_box_text_append(combo, "item1", "Первый")
gtk_combo_box_text_append(combo, "item2", "Второй")
gtk_combo_box_text_append_text(combo, "Только текст")
gtk_combo_box_text_remove(combo, 0)
gtk_combo_box_text_remove_all(combo)
let text = $gtk_combo_box_text_get_active_text(combo)

# Управление через GtkComboBox:
gtk_combo_box_set_active(combo, 0)
gtk_combo_box_get_active(combo): gint
gtk_combo_box_get_active_id(combo): cstring
discard gtk_combo_box_set_active_id(combo, "item2")
```

---

## 34. GtkListBox

Гибкий список с кастомными строками. Актуален в GTK4.

### `gtk_list_box_new(): GtkListBox`

---

### Добавление строк

```nim
gtk_list_box_append(box, widget)
gtk_list_box_prepend(box, widget)
gtk_list_box_insert(box, widget, position)
gtk_list_box_remove(box, widget)
```

---

### Выделение

```nim
gtk_list_box_set_selection_mode(box, GTK_SELECTION_SINGLE)
gtk_list_box_select_row(box, row)
gtk_list_box_unselect_row(box, row)
let selectedRow = gtk_list_box_get_selected_row(box)
```

---

### GtkListBoxRow

```nim
let row = gtk_list_box_row_new()
gtk_list_box_row_set_child(row, content)
gtk_list_box_row_get_child(row): GtkWidget
gtk_list_box_row_get_index(row): gint  # Индекс строки в списке
```

**Пример:**
```nim
let listBox = gtk_list_box_new()
gtk_list_box_set_selection_mode(listBox, GTK_SELECTION_SINGLE)

for item in items:
  let row = gtk_list_box_row_new()
  let label = gtk_label_new(item.cstring)
  gtk_label_set_xalign(label, 0.0)
  setMargins(label, 8, 8, 8, 12)
  gtk_list_box_row_set_child(row, label)
  gtk_list_box_append(listBox, row)

discard g_signal_connect(listBox, "row-activated", cast[GCallback](onRowActivated), nil)
```

---

## 35. GtkNotebook

Виджет вкладок (tabbed interface).

### `gtk_notebook_new(): GtkNotebook`

---

```nim
let idx = gtk_notebook_append_page(nb, pageWidget, tabLabel)
let idx = gtk_notebook_prepend_page(nb, pageWidget, tabLabel)
let idx = gtk_notebook_insert_page(nb, pageWidget, tabLabel, position)
gtk_notebook_remove_page(nb, pageNum)

gtk_notebook_get_current_page(nb): gint
gtk_notebook_set_current_page(nb, pageNum)
gtk_notebook_get_n_pages(nb): gint
gtk_notebook_get_nth_page(nb, pageNum): GtkWidget

gtk_notebook_set_tab_pos(nb, GTK_POS_TOP)   # Вкладки сверху/снизу/слева/справа
gtk_notebook_set_show_tabs(nb, TRUE)         # Показывать заголовки вкладок
gtk_notebook_set_scrollable(nb, TRUE)        # Прокрутка при большом числе вкладок
```

---

## 36. GtkPaned

Контейнер с перетаскиваемым разделителем.

### `gtk_paned_new(orientation): GtkPaned`

---

```nim
gtk_paned_set_start_child(paned, leftOrTopWidget)
gtk_paned_set_end_child(paned, rightOrBottomWidget)
gtk_paned_set_position(paned, 300)   # Позиция разделителя в пикселях
gtk_paned_get_position(paned): gint
```

**Пример:**
```nim
let paned = gtk_paned_new(GTK_ORIENTATION_HORIZONTAL)
gtk_paned_set_start_child(paned, fileTreeScroll)
gtk_paned_set_end_child(paned, editorScroll)
gtk_paned_set_position(paned, 250)
```

---

## 37. GtkStack / GtkStackSwitcher

### `gtk_stack_new(): GtkStack`

Переключение между страницами с анимацией.

---

```nim
# Добавить страницу с именем и заголовком:
gtk_stack_add_titled(stack, widget, "page1", "Основные")
gtk_stack_add_named(stack, widget, "settings")
gtk_stack_add_child(stack, widget)

# Переключение:
gtk_stack_set_visible_child_name(stack, "page1")
gtk_stack_set_visible_child(stack, widget)
gtk_stack_get_visible_child_name(stack): cstring
gtk_stack_get_child_by_name(stack, "settings"): GtkWidget

gtk_stack_remove(stack, widget)

# Анимация переходов:
gtk_stack_set_transition_type(stack, GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT_RIGHT)
gtk_stack_set_transition_duration(stack, 200)  # миллисекунды
gtk_stack_get_transition_type(stack)
gtk_stack_get_transition_duration(stack)
```

---

### GtkStackSwitcher

Автоматически генерирует кнопки переключения вкладок.

```nim
let switcher = gtk_stack_switcher_new()
gtk_stack_switcher_set_stack(switcher, stack)
# Поместить switcher в HeaderBar:
gtk_header_bar_set_title_widget(headerBar, switcher)
```

---

## 38. GtkHeaderBar

Заголовок окна в стиле GNOME с кнопками управления.

### `gtk_header_bar_new(): GtkHeaderBar`

---

```nim
gtk_header_bar_pack_start(bar, button)          # Кнопка слева
gtk_header_bar_pack_end(bar, menuButton)        # Кнопка справа
gtk_header_bar_remove(bar, widget)              # Удалить виджет

gtk_header_bar_set_title_widget(bar, stackSwitcher)  # Виджет в центре
gtk_header_bar_set_show_title_buttons(bar, TRUE)     # Кнопки закрытия/свёртки

# Расположение декоративных кнопок (close, minimize, maximize):
gtk_header_bar_set_decoration_layout(bar, "icon:minimize,maximize,close")
```

**Установка HeaderBar в окно:**
```nim
let headerBar = gtk_header_bar_new()
gtk_header_bar_pack_end(headerBar, menuButton)
gtk_window_set_titlebar(window, headerBar)
```

---

## 39. GtkMessageDialog / GtkDialog

> ⚠️ Устарели в GTK4. Для новых проектов используй `GtkAlertDialog`.

### `gtk_message_dialog_new(parent, flags, msgType, buttons, messageFormat, ...): GtkMessageDialog`

**Параметры:**
- `flags`: обычно `0`
- `msgType`: `GTK_MESSAGE_INFO`, `GTK_MESSAGE_ERROR`, `GTK_MESSAGE_QUESTION` и т.д.
- `buttons`: `GTK_BUTTONS_OK`, `GTK_BUTTONS_YES_NO`, `GTK_BUTTONS_OK_CANCEL` и т.д.

**Пример:**
```nim
let dlg = gtk_message_dialog_new(mainWindow, 0, GTK_MESSAGE_QUESTION,
                                  GTK_BUTTONS_YES_NO,
                                  "Сохранить изменения?")
gtk_message_dialog_set_markup(dlg, "Файл <b>doc.txt</b> был изменён.")
# При ответе:
discard g_signal_connect(dlg, "response", cast[GCallback](onDialogResponse), nil)
gtk_window_present(cast[GtkWindow](dlg))
```

---

### GtkDialog

```nim
let dlg = gtk_dialog_new()
gtk_window_set_transient_for(cast[GtkWindow](dlg), mainWindow)
gtk_window_set_modal(cast[GtkWindow](dlg), TRUE)
let okBtn = gtk_dialog_add_button(dlg, "OK", GTK_RESPONSE_OK.gint)
let cancelBtn = gtk_dialog_add_button(dlg, "Отмена", GTK_RESPONSE_CANCEL.gint)
gtk_dialog_set_default_response(dlg, GTK_RESPONSE_OK.gint)

# Добавить произвольный виджет в область контента:
let contentArea = gtk_dialog_get_content_area(dlg)
gtk_box_append(cast[GtkBox](contentArea), formWidget)

# Обработка ответа:
proc onResponse(dlg: GtkDialog, responseId: gint, data: pointer) {.cdecl.} =
  if responseId == GTK_RESPONSE_OK.gint:
    echo "OK нажат"
  gtk_window_destroy(cast[GtkWindow](dlg))

discard g_signal_connect(dlg, "response", cast[GCallback](onResponse), nil)
gtk_window_present(cast[GtkWindow](dlg))
```

---

## 40. GtkFileChooser

> ⚠️ `GtkFileChooserDialog` устарел. Используй `GtkFileDialog` (GTK 4.10+) или `GtkFileChooserNative`.

### `gtk_file_chooser_dialog_new(title, parent, action, firstButtonText, ...): GtkFileChooserDialog`

**Пример:**
```nim
let dlg = gtk_file_chooser_dialog_new(
  "Открыть файл", mainWindow, GTK_FILE_CHOOSER_ACTION_OPEN,
  "_Отмена", GTK_RESPONSE_CANCEL.gint,
  "_Открыть", GTK_RESPONSE_ACCEPT.gint,
  nil)

proc onResponse(dlg: GtkFileChooserDialog, responseId: gint, data: pointer) {.cdecl.} =
  if responseId == GTK_RESPONSE_ACCEPT.gint:
    let gfile = gtk_file_chooser_get_file(cast[GtkFileChooser](dlg))
    let path = $g_file_get_path(gfile)
    echo "Открываем: ", path
  gtk_window_destroy(cast[GtkWindow](dlg))

discard g_signal_connect(dlg, "response", cast[GCallback](onResponse), nil)
gtk_window_present(cast[GtkWindow](dlg))
```

---

```nim
gtk_file_chooser_set_current_name(chooser, "untitled.txt")  # Для диалога сохранения
gtk_file_chooser_get_file(chooser): GFile
gtk_file_chooser_set_file(chooser, file, nil)
gtk_file_chooser_set_current_folder(chooser, folder, nil)
```

---

## 41. GtkDrawingArea

Виджет для произвольного рисования через Cairo.

### `gtk_drawing_area_new(): GtkDrawingArea`

---

### `gtk_drawing_area_set_draw_func(area, drawFunc, userData, destroy)`

**Что делает:** Устанавливает функцию отрисовки. Вызывается при необходимости перерисовать виджет.

**Сигнатура функции отрисовки:**
```nim
proc myDraw(area: GtkDrawingArea, cr: cairo_t, 
             width, height: gint, data: gpointer) {.cdecl.} =
  # Cairo-рисование здесь
  cairo_set_source_rgb(cr, 0.2, 0.4, 0.8)
  cairo_rectangle(cr, 10.0, 10.0, float(width - 20), float(height - 20))
  cairo_fill(cr)
```

---

```nim
let area = gtk_drawing_area_new()
gtk_drawing_area_set_content_width(area, 400)
gtk_drawing_area_set_content_height(area, 300)
gtk_drawing_area_set_draw_func(area, myDraw, nil, nil)

# Запросить перерисовку:
gtk_widget_queue_draw(area)
```

---

## 42. CSS Provider

### `gtk_css_provider_new(): GtkCssProvider`

---

```nim
# Загрузка CSS из строки:
proc gtk_css_provider_load_from_data*(cssProvider, data: cstring, length: gssize)
proc gtk_css_provider_load_from_string*(cssProvider, string: cstring)  # Без длины

# Загрузка CSS из файла:
proc gtk_css_provider_load_from_path*(cssProvider, path: cstring)
proc gtk_css_provider_load_from_file*(cssProvider, file: GFile)
```

**Пример полного цикла применения CSS:**
```nim
let provider = gtk_css_provider_new()
gtk_css_provider_load_from_string(provider, """
  window { background: #1e1e2e; }
  button.primary {
    background: #89b4fa;
    color: #1e1e2e;
    border-radius: 6px;
    padding: 6px 12px;
    font-weight: bold;
  }
  button.primary:hover { background: #74c7ec; }
""")

let display = gdk_display_get_default()
gtk_style_context_add_provider_for_display(display, cast[pointer](provider), 
  GTK_STYLE_PROVIDER_PRIORITY_APPLICATION.guint)
```

---

## 43. StyleContext и Display

### `gtk_widget_get_style_context(widget): GtkStyleContext`

**Что делает:** Возвращает объект стилевого контекста конкретного виджета для локального применения CSS.

---

### `gtk_style_context_add_provider(context, provider, priority)`

**Что делает:** Добавляет CSS-провайдер к конкретному виджету.

**Пример:**
```nim
let provider = gtk_css_provider_new()
gtk_css_provider_load_from_string(provider, "entry { color: red; }")
let ctx = gtk_widget_get_style_context(myEntry)
gtk_style_context_add_provider(ctx, cast[pointer](provider), 
  GTK_STYLE_PROVIDER_PRIORITY_APPLICATION.guint)
```

---

### `gtk_style_context_add_provider_for_display(display, provider, priority)`

**Что делает:** Применяет CSS-провайдер глобально для всего дисплея.

---

### `gdk_display_get_default(): pointer`

**Что делает:** Возвращает дисплей по умолчанию (в большинстве случаев единственный).

### `gtk_widget_get_display(widget): GdkDisplay`

**Что делает:** Возвращает дисплей, на котором находится виджет.

---

## 44. GFile — базовые операции

### `g_file_new_for_path(path): GFile`

**Что делает:** Создаёт `GFile` из пути файловой системы.

**Пример:**
```nim
let configFile = g_file_new_for_path("/home/user/.config/app/settings.conf")
```

---

### `g_file_get_path(file): cstring` / `g_file_get_basename(file): cstring`

**Что делает:** Возвращает путь целиком или только имя файла. Результат нужно освободить через `g_free`.

**Пример:**
```nim
let gfile = gtk_file_chooser_get_file(chooser)
let path = g_file_get_path(gfile)
let name = g_file_get_basename(gfile)
echo "Файл: ", $name, " по пути: ", $path
g_free(cast[gpointer](path))
g_free(cast[gpointer](name))
```

---

## 45. GError

### `g_error_free(error)`

**Что делает:** Освобождает объект ошибки. Обязательно вызывать после обработки ошибки.

**Паттерн обработки ошибок в GTK:**
```nim
var err: GError = nil
let result = gtk_file_chooser_set_file(chooser, gfile, addr err)
if result == FALSE:
  if err != nil:
    echo "Ошибка: ", $cast[ptr tuple[domain: GQuark, code: gint, message: cstring]](err)[].message
    g_error_free(err)
```

---

## 46. GVariant

Типизированный контейнер для значений, используемый в GAction, D-Bus, GSettings.

### Создание

```nim
g_variant_new_string("hello"): GVariant
g_variant_new_boolean(TRUE): GVariant
g_variant_new_int32(42): GVariant
```

### Получение значения

```nim
g_variant_get_string(variant, nil): cstring  # nil = не нужна длина
g_variant_get_boolean(variant): gboolean
g_variant_get_int32(variant): gint32
```

**Пример — действие с параметром:**
```nim
let openAction = g_simple_action_new("open", cast[GVariantType](g_variant_type_new("s")))
# При активации:
proc onOpen(action: GSimpleAction, param: GVariant, data: gpointer) {.cdecl.} =
  let path = $g_variant_get_string(param, nil)
  echo "Открыть файл: ", path
discard g_signal_connect(openAction, "activate", cast[GCallback](onOpen), nil)

# Активировать с аргументом:
g_action_activate(cast[GAction](openAction), g_variant_new_string("/home/user/doc.txt"))
```

---

## 47. GObject

Базовая система типов GLib. Все GTK-виджеты наследуются от GObject.

### Управление ссылками

```nim
g_object_ref(obj): gpointer    # Увеличить счётчик ссылок
g_object_unref(obj)            # Уменьшить счётчик ссылок (освобождает при 0)
g_object_ref_sink(obj): gpointer  # ref + sink для floating references
g_object_is_floating(obj): gboolean  # Проверить: floating reference?
```

---

### Пользовательские данные

```nim
g_object_set_data(obj, "key", data)      # Привязать данные к объекту
g_object_get_data(obj, "key"): gpointer  # Получить данные
g_object_steal_data(obj, "key"): gpointer  # Извлечь и отвязать

# С функцией освобождения:
g_object_set_data_full(obj, "key", data, destroyFunc)
```

**Практический паттерн — привязка Nim-объекта к виджету:**
```nim
type AppState = ref object
  count: int
  name: string

let state = AppState(count: 0, name: "test")
GC_ref(state)  # Не позволить GC уничтожить объект
g_object_set_data(button, "app-state", cast[gpointer](state))

# В обработчике:
proc onClick(btn: GtkButton, data: pointer) {.cdecl.} =
  let state = cast[AppState](g_object_get_data(btn, "app-state"))
  inc state.count
```

---

### Свойства GObject

```nim
# Установить свойство (varargs: имя, значение, ..., nil):
g_object_set(obj, "font-size".cstring, 14.gint, nil)

# Получить свойство:
var fontSize: gint
g_object_get(obj, "font-size".cstring, addr fontSize, nil)
```

---

### Property Binding

```nim
# Однонаправленная привязка source.property → target.property:
discard g_object_bind_property(source, "value", progressBar, "fraction",
                                G_BINDING_DEFAULT)

# Двунаправленная с синхронизацией при создании:
discard g_object_bind_property(spinButton, "value", scale, "value",
                                G_BINDING_BIDIRECTIONAL or G_BINDING_SYNC_CREATE)

# С преобразованием значений:
discard g_object_bind_property_full(sourceEntry, "text", targetLabel, "label",
                                     G_BINDING_DEFAULT, 
                                     transformToFunc, transformFromFunc, 
                                     nil, nil)
```

---

### Слабые ссылки (Weak References)

```nim
# Слабая ссылка — не препятствует удалению объекта:
g_object_add_weak_pointer(obj, addr weakPtr)
# После удаления obj, weakPtr автоматически станет nil

# Callback-based:
g_object_weak_ref(obj, onObjectFinalized, userData)
```

---

### Информация о типе

```nim
g_object_get_type(): GType             # GType базового GObject
g_object_class_find_property(oclass, "name"): pointer  # GParamSpec свойства
g_object_class_list_properties(oclass, addr count): ptr pointer
```

---

### Уведомления об изменении свойств

```nim
proc onNotify(obj: GObject, pspec: pointer, data: pointer) {.cdecl.} =
  echo "Свойство изменилось"

discard g_signal_connect(widget, "notify::visible", cast[GCallback](onNotify), nil)

# Временно заморозить уведомления (batching):
g_object_freeze_notify(obj)
g_object_set(obj, "width".cstring, 100.gint, nil)
g_object_set(obj, "height".cstring, 200.gint, nil)
g_object_thaw_notify(obj)  # Одно уведомление вместо двух
```

---

## 48. GtkPopover

Всплывающее окно, привязанное к виджету.

### `gtk_popover_new(): GtkPopover`

---

```nim
gtk_popover_set_child(popover, contentWidget)
gtk_popover_set_parent(popover, parentWidget)  # К какому виджету привязан
gtk_popover_popup(popover)     # Показать
gtk_popover_popdown(popover)   # Скрыть
```

**Пример:**
```nim
let popover = gtk_popover_new()
let label = gtk_label_new("Всплывающая подсказка")
setMargins(label, 8)
gtk_popover_set_child(popover, label)
gtk_popover_set_parent(popover, triggerButton)
discard g_signal_connect(triggerButton, "clicked", 
                         cast[GCallback](proc(b,d:pointer){.cdecl.} = gtk_popover_popup(popover)), 
                         nil)
```

---

## 49. GtkMenuButton

Кнопка, открывающая меню или popover.

### `gtk_menu_button_new(): GtkMenuButton`

---

### Содержимое

```nim
# Текстовая метка:
gtk_menu_button_set_label(button, "Меню")
gtk_menu_button_set_use_underline(button, TRUE)  # _М -> Alt+М

# Иконка:
gtk_menu_button_set_icon_name(button, "open-menu")

# Произвольный виджет (вместо text/icon):
gtk_menu_button_set_child(button, customWidget)
```

---

### Привязка меню

```nim
# Через GMenuModel (декларативное меню):
gtk_menu_button_set_menu_model(button, menuModel)

# Через GtkPopover (произвольное содержимое):
gtk_menu_button_set_popover(button, popoverWidget)

# Кастомное создание через callback:
gtk_menu_button_set_create_popup_func(button, createPopupCallback, data, nil)
```

---

### Настройка поведения

```nim
gtk_menu_button_set_direction(button, GTK_ARROW_DOWN)  # Направление стрелки
gtk_menu_button_set_has_frame(button, FALSE)            # Без рамки (плоская)
gtk_menu_button_set_always_show_arrow(button, TRUE)     # Всегда показывать стрелку
gtk_menu_button_set_primary(button, TRUE)               # Главная кнопка меню приложения
gtk_menu_button_popup(button)    # Программно открыть
gtk_menu_button_popdown(button)  # Программно закрыть
```

**Типичный паттерн для hamburger menu:**
```nim
let menu = g_menu_new()
g_menu_append(menu, "Настройки", "app.preferences")
g_menu_append(menu, "О программе", "app.about")
g_menu_append(menu, "Выход", "app.quit")

let menuBtn = gtk_menu_button_new()
gtk_menu_button_set_icon_name(menuBtn, "open-menu-symbolic")
gtk_menu_button_set_menu_model(menuBtn, cast[GMenuModel](menu))

gtk_header_bar_pack_end(headerBar, menuBtn)
```

---

## Приложение A: Все перечисления — полная сводка

| Enum | Применение | Ключевые значения |
|---|---|---|
| `GtkOrientation` | Box, Grid, Scale | HORIZONTAL=0, VERTICAL=1 |
| `GtkAlign` | Выравнивание виджета | FILL, START, END, CENTER, BASELINE |
| `GtkJustification` | Текст Label/TextView | LEFT, RIGHT, CENTER, FILL |
| `GtkWrapMode` | Перенос в TextView | NONE, CHAR, WORD, WORD_CHAR |
| `PangoWrapMode` | Перенос (Pango) | WORD, CHAR, WORD_CHAR |
| `PangoEllipsizeMode` | Усечение Label | NONE, START, MIDDLE, END |
| `GtkNaturalWrapMode` | Натуральный перенос | INHERIT, NONE, WORD |
| `GtkPositionType` | Позиция (вкладки, шкала) | LEFT, RIGHT, TOP, BOTTOM |
| `GtkBaselinePosition` | Выравнивание в Box | TOP, CENTER, BOTTOM |
| `GtkMessageType` | Тип диалога-сообщения | INFO, WARNING, QUESTION, ERROR |
| `GtkButtonsType` | Кнопки диалога | NONE, OK, CLOSE, CANCEL, YES_NO, OK_CANCEL |
| `GtkResponseType` | Ответ диалога | OK=-5, CANCEL=-6, YES=-8, NO=-9 |
| `GtkSelectionMode` | Режим выделения | NONE, SINGLE, BROWSE, MULTIPLE |
| `GtkFileChooserAction` | Файловый диалог | OPEN, SAVE, SELECT_FOLDER |
| `GtkPolicyType` | Полосы прокрутки | ALWAYS, AUTOMATIC, NEVER, EXTERNAL |
| `GtkInputPurpose` | Назначение поля | FREE_FORM, DIGITS, EMAIL, URL, PASSWORD, PIN |
| `GtkInputHints` | Подсказки ввода | NONE, SPELLCHECK, LOWERCASE, UPPERCASE_WORDS |
| `GtkArrowType` | Направление MenuButton | UP, DOWN, LEFT, RIGHT, NONE |
| `GtkTextDirection` | Направление текста | NONE, LTR, RTL |
| `GtkStackTransitionType` | Анимация Stack | NONE, CROSSFADE, SLIDE_*, OVER_*, UNDER_* |
| `GtkApplicationInhibitFlags` | Ингибирование | LOGOUT, SWITCH, SUSPEND, IDLE |
| `GtkTextWindowType` | Область в TextView | WIDGET, TEXT, LEFT, RIGHT, TOP, BOTTOM |
| `GApplicationFlags` | Флаги приложения | FLAGS_NONE, HANDLES_OPEN, NON_UNIQUE |
| `GBindingFlags` | Привязка свойств | DEFAULT, BIDIRECTIONAL, SYNC_CREATE, INVERT_BOOLEAN |
| `GSignalFlags` | Флаги сигнала | RUN_FIRST, RUN_LAST, ACTION, DETAILED |
| `GtkEntryIconPosition` | Иконка в Entry | PRIMARY=0, SECONDARY=1 |
| `GtkImageType` | Тип содержимого Image | EMPTY, ICON_NAME, GICON, PAINTABLE |

---

## Приложение B: Важные сигналы виджетов

| Виджет | Сигнал | Прототип коллбэка |
|---|---|---|
| Любой виджет | `"notify::prop"` | `(obj, pspec, data)` |
| `GtkButton` | `"clicked"` | `(button, data)` |
| `GtkToggleButton` | `"toggled"` | `(toggle, data)` |
| `GtkCheckButton` | `"toggled"` | `(check, data)` |
| `GtkSwitch` | `"state-set"` | `(sw, state: gboolean, data) → gboolean` |
| `GtkEntry` | `"activate"` | `(entry, data)` |
| `GtkEntry` | `"changed"` | `(entry, data)` |
| `GtkEntry` | `"icon-press"` | `(entry, iconPos, data)` |
| `GtkSearchEntry` | `"search-changed"` | `(entry, data)` |
| `GtkSearchEntry` | `"stop-search"` | `(entry, data)` |
| `GtkSpinButton` | `"value-changed"` | `(spin, data)` |
| `GtkScale` | `"value-changed"` | `(scale, data)` |
| `GtkTextBuffer` | `"changed"` | `(buffer, data)` |
| `GtkTextBuffer` | `"modified-changed"` | `(buffer, data)` |
| `GtkListBox` | `"row-activated"` | `(box, row, data)` |
| `GtkListBox` | `"row-selected"` | `(box, row, data)` |
| `GtkNotebook` | `"switch-page"` | `(nb, page, pageNum, data)` |
| `GtkStack` | `"notify::visible-child"` | `(stack, pspec, data)` |
| `GtkWindow` | `"close-request"` | `(win, data) → gboolean` |
| `GApplication` | `"activate"` | `(app, data)` |
| `GApplication` | `"startup"` | `(app, data)` |
| `GApplication` | `"shutdown"` | `(app, data)` |
| `GApplication` | `"open"` | `(app, files, nFiles, hint, data)` |
| `GSimpleAction` | `"activate"` | `(action, param, data)` |
| `GSimpleAction` | `"change-state"` | `(action, value, data)` |
| `GtkDrawingArea` | (через `set_draw_func`) | `(area, cr, w, h, data)` |

---

*Справочник сгенерирован на основе `libGTK4_p1.nim`.*
