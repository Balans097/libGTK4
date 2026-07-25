# Документация обёртки GTK4 для Nim — Часть 2
## Инициализация, приложение, окна, сигналы, базовые виджеты

| Параметр | Значение |
|---|---|
| Версия обёртки | 1.2 |
| Дата обновления | 2026-02-15 |

---

## Содержание

1. [Инициализация GTK](#1-инициализация-gtk)
2. [GApplication и GtkApplication](#2-gapplication-и-gtkapplication)
3. [Сигналы GObject](#3-сигналы-gobject)
4. [GtkWindow — окно](#4-gtkwindow--окно)
5. [GtkWidget — базовые функции виджетов](#5-gtkwidget--базовые-функции-виджетов)
6. [GtkBox — линейный контейнер](#6-gtkbox--линейный-контейнер)
7. [GtkGrid — сеточный контейнер](#7-gtkgrid--сеточный-контейнер)
8. [GtkLabel — текстовая метка](#8-gtklabel--текстовая-метка)
9. [GtkButton — кнопки](#9-gtkbutton--кнопки)
10. [GtkEntry — поля ввода](#10-gtkentry--поля-ввода)
11. [GtkTextView и GtkTextBuffer](#11-gtktextview-и-gtktextbuffer)
12. [Действия (GAction / GSimpleAction)](#12-действия-gaction--gsimpleaction)
13. [Меню (GMenu / GMenuItem)](#13-меню-gmenu--gmenuitem)
14. [GObject — управление объектами](#14-gobject--управление-объектами)
15. [GLib — таймеры и idle](#15-glib--таймеры-и-idle)
16. [Практические примеры](#16-практические-примеры)

---

## 1. Инициализация GTK

### 1.1 Функции инициализации

```nim
proc gtk_init*() {.importc.}
  ## Инициализирует GTK. Вызывать до любых GTK-функций,
  ## если приложение НЕ использует GtkApplication.
  ## При использовании GtkApplication вызывается автоматически.

proc gtk_init_check*(): gboolean {.importc.}
  ## Как gtk_init(), но возвращает FALSE при неудаче
  ## (например, нет доступного дисплея — headless-среда).
```

> **Совет:** При использовании `GtkApplication` вызывать `gtk_init()` не нужно — инициализация происходит автоматически в `g_application_run()`.

### 1.2 Проверка версии

```nim
proc gtk_get_major_version*(): cuint {.importc.}
proc gtk_get_minor_version*(): cuint {.importc.}
proc gtk_get_micro_version*(): cuint {.importc.}
proc gtk_get_binary_age*():    cuint {.importc.}
proc gtk_get_interface_age*(): cuint {.importc.}

proc gtk_check_version*(
  requiredMajor: cuint,
  requiredMinor: cuint,
  requiredMicro: cuint
): cstring {.importc.}
  ## Возвращает nil если версия GTK >= требуемой,
  ## иначе строку с описанием несоответствия.
```

```nim
# Пример:
let err = gtk_check_version(4, 12, 0)
if err != nil:
  echo "GTK слишком старый: ", $err
else:
  echo "GTK ", gtk_get_major_version(), ".",
              gtk_get_minor_version(), ".",
              gtk_get_micro_version()
```

### 1.3 Отладка и диагностика

```nim
proc gtk_is_initialized*(): gboolean {.importc.}
  ## Проверяет, был ли GTK инициализирован.

proc gtk_set_debug_flags*(flags: cuint) {.importc.}
  ## Устанавливает флаги отладки (GTK_DEBUG_*).

proc gtk_get_debug_flags*(): cuint {.importc.}
  ## Возвращает текущие флаги отладки.

proc gtk_disable_setlocale*() {.importc.}
  ## Вызывать ДО gtk_init(), если приложение управляет
  ## локалью самостоятельно.

proc gtk_get_locale_direction*(): GtkTextDirection {.importc.}
  ## Возвращает направление текста текущей локали
  ## (GTK_TEXT_DIR_LTR или GTK_TEXT_DIR_RTL).

proc gtk_get_default_language*(): pointer {.importc.}
  ## Возвращает PangoLanguage* текущего языка.
```

```nim
# Включение Inspector при запуске из кода:
gtk_set_debug_flags(GTK_DEBUG_INTERACTIVE)

# Из командной строки:
# GTK_DEBUG=interactive ./myapp
```

---

## 2. GApplication и GtkApplication

### 2.1 Создание приложения

```nim
proc gtk_application_new*(
  applicationId: cstring,  # напр. "com.example.MyApp"
  flags: gint              # обычно G_APPLICATION_DEFAULT_FLAGS (0)
): GtkApplication {.importc.}
  ## Создаёт новое GTK-приложение.
  ## applicationId должен соответствовать формату обратного DNS
  ## и быть уникальным в системе.

proc g_application_run*(
  application: GApplication,
  argc: gint,
  argv: pointer
): gint {.importc.}
  ## Запускает главный цикл событий.
  ## Блокирует выполнение до завершения приложения.
  ## Возвращает код завершения (0 = успех).
```

**Минимальное приложение:**

```nim
import libGTK4

proc activate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  let win = gtk_application_window_new(app)
  gtk_window_set_title(cast[GtkWindow](win), "Привет, GTK4!")
  gtk_window_set_default_size(cast[GtkWindow](win), 400, 300)
  gtk_window_present(cast[GtkWindow](win))

let app = gtk_application_new("com.example.hello",
                               G_APPLICATION_DEFAULT_FLAGS.gint)
discard g_signal_connect(app, "activate", cast[GCallback](activate), nil)
let status = g_application_run(cast[GApplication](app), 0, nil)
g_object_unref(app)
quit(status)
```

### 2.2 Управление окнами

```nim
proc gtk_application_window_new*(
  application: GtkApplication
): GtkWindow {.importc.}
  ## Создаёт окно, привязанное к приложению.
  ## Когда все такие окна закрыты — приложение завершается.

proc gtk_application_add_window*(
  application: GtkApplication,
  window: GtkWindow
) {.importc.}
  ## Регистрирует существующее окно в приложении.

proc gtk_application_remove_window*(
  application: GtkApplication,
  window: GtkWindow
) {.importc.}
  ## Удаляет окно из приложения.

proc gtk_application_get_active_window*(
  application: GtkApplication
): GtkWindow {.importc.}
  ## Возвращает активное (верхнее) окно.

proc gtk_application_get_windows*(
  application: GtkApplication
): pointer {.importc.}
  ## Возвращает GList* всех окон приложения.
  ## Список принадлежит приложению — не освобождать.

proc gtk_application_get_window_by_id*(
  application: GtkApplication,
  id: cuint
): GtkWindow {.importc.}
  ## Поиск окна по числовому идентификатору.
```

### 2.3 Меню и акселераторы

```nim
proc gtk_application_set_menubar*(
  application: GtkApplication,
  menubar: GMenuModel
) {.importc.}
  ## Устанавливает главное меню (только для платформ с menubar).

proc gtk_application_get_menubar*(
  application: GtkApplication
): GMenuModel {.importc.}

proc gtk_application_get_menu_by_id*(
  application: GtkApplication,
  id: cstring
): GMenu {.importc.}
  ## Получить меню из UI-ресурсов по id.

proc gtk_application_set_accels_for_action*(
  application: GtkApplication,
  detailedActionName: cstring,  # напр. "app.quit" или "win.open"
  accels: ptr cstring           # NULL-terminated массив строк, напр. ["<Ctrl>Q", nil]
) {.importc.}

proc gtk_application_get_accels_for_action*(
  application: GtkApplication,
  detailedActionName: cstring
): ptr cstring {.importc.}

proc gtk_application_list_action_descriptions*(
  application: GtkApplication
): ptr cstring {.importc.}
  ## Все зарегистрированные действия приложения.
```

```nim
# Назначение горячих клавиш:
var accels = ["<Ctrl>Q", nil.cstring]
gtk_application_set_accels_for_action(app, "app.quit", addr accels[0])
```

### 2.4 Ингибирование (предотвращение сна и выхода)

```nim
proc gtk_application_inhibit*(
  application: GtkApplication,
  window: GtkWindow,
  flags: GtkApplicationInhibitFlags,
  reason: cstring               # Текст для системного диалога
): cuint {.importc.}
  ## Предотвращает системные события.
  ## Возвращает cookie для uninhibit(). 0 = неудача.

proc gtk_application_uninhibit*(
  application: GtkApplication,
  cookie: cuint
) {.importc.}

proc gtk_application_is_inhibited*(
  application: GtkApplication,
  flags: GtkApplicationInhibitFlags
): gboolean {.importc.}
```

```nim
# Предотвратить переход в спящий режим (напр. при воспроизведении видео):
let cookie = gtk_application_inhibit(
  app, win,
  GTK_APPLICATION_INHIBIT_SUSPEND,
  "Воспроизведение видео")
# Позже снять запрет:
gtk_application_uninhibit(app, cookie)
```

### 2.5 GApplication — базовые функции

```nim
proc g_application_quit*(application: GApplication) {.importc.}
  ## Завершает приложение (посылает сигнал "quit").

proc g_application_hold*(application: GApplication) {.importc.}
  ## Удерживает приложение живым (например, для фоновых задач).

proc g_application_release*(application: GApplication) {.importc.}
  ## Освобождает удержание.

proc g_application_activate*(application: GApplication) {.importc.}
  ## Активирует приложение программно (эмулирует запуск).

proc g_application_get_application_id*(
  application: GApplication
): cstring {.importc.}

proc g_application_set_application_id*(
  application: GApplication,
  applicationId: cstring
) {.importc.}

proc g_application_get_flags*(
  application: GApplication
): GApplicationFlags {.importc.}

proc g_application_set_flags*(
  application: GApplication,
  flags: GApplicationFlags
) {.importc.}

proc g_application_get_is_registered*(
  application: GApplication
): gboolean {.importc.}

proc g_application_get_is_remote*(
  application: GApplication
): gboolean {.importc.}
  ## TRUE = этот экземпляр является вторичным (первичный уже запущен).
```

### 2.6 Индикатор занятости

```nim
proc g_application_mark_busy*(application: GApplication) {.importc.}
  ## Устанавливает флаг "занят" (отображается в taskbar на некоторых DE).

proc g_application_unmark_busy*(application: GApplication) {.importc.}

proc g_application_get_is_busy*(application: GApplication): gboolean {.importc.}
```

### 2.7 Уведомления

```nim
proc g_application_send_notification*(
  application: GApplication,
  id: cstring,           # Идентификатор уведомления (для замены/отзыва)
  notification: pointer  # GNotification*
) {.importc.}

proc g_application_withdraw_notification*(
  application: GApplication,
  id: cstring
) {.importc.}
```

### 2.8 Командная строка

```nim
proc g_application_add_main_option*(
  application: GApplication,
  longName: cstring,        # --long-name
  shortName: char,          # -s (0 = без короткой формы)
  flags: GOptionFlags,
  arg: GOptionArg,
  description: cstring,
  argDescription: cstring
) {.importc.}

proc g_application_set_option_context_summary*(
  application: GApplication,
  summary: cstring
) {.importc.}
```

### 2.9 Сигналы GtkApplication / GApplication

| Сигнал | Прототип | Описание |
|---|---|---|
| `"activate"` | `proc(app: GtkApplication, data: gpointer)` | Приложение активировано (первый запуск без файлов) |
| `"startup"` | `proc(app: GtkApplication, data: gpointer)` | Первичный запуск — инициализация ресурсов |
| `"shutdown"` | `proc(app: GtkApplication, data: gpointer)` | Перед завершением приложения |
| `"open"` | `proc(app, files, n, hint, data)` | Открыть файлы (если `G_APPLICATION_HANDLES_OPEN`) |
| `"command-line"` | `proc(app, cmdline, data): gint` | Обработка командной строки вторичного экземпляра |
| `"window-added"` | `proc(app: GtkApplication, win: GtkWindow, data: gpointer)` | Добавлено окно |
| `"window-removed"` | `proc(app: GtkApplication, win: GtkWindow, data: gpointer)` | Удалено окно |

---

## 3. Сигналы GObject

Система сигналов GTK обеспечивает слабосвязанные события между объектами.

### 3.1 Подключение сигналов

```nim
proc g_signal_connect_data*(
  instance: gpointer,
  detailedSignal: cstring,
  cHandler: GCallback,
  data: gpointer,
  destroyData: GClosureNotify,  # nil или proc для освобождения data
  connectFlags: gint            # 0 = обычное, 1 = after (G_CONNECT_AFTER)
): gulong {.importc.}
  ## Полная форма подключения. Возвращает ID обработчика.

template g_signal_connect*(instance, signal, callback, data: untyped): untyped =
  ## Сокращённый шаблон (connectFlags = 0).
  g_signal_connect_data(instance, signal, cast[GCallback](callback), data, nil, 0)
```

```nim
# Обычное подключение:
proc onClicked(btn: GtkButton, data: gpointer) {.cdecl.} =
  echo "Кнопка нажата!"

let hid = g_signal_connect(button, "clicked",
                            cast[GCallback](onClicked), nil)

# С данными:
var counter = 0
proc onClickedCount(btn: GtkButton, data: gpointer) {.cdecl.} =
  inc cast[ptr int](data)[]
  echo "Нажато раз: ", cast[ptr int](data)[]

discard g_signal_connect(button, "clicked",
                          cast[GCallback](onClickedCount),
                          addr counter)

# После основного обработчика:
discard g_signal_connect_data(button, "clicked",
  cast[GCallback](onClicked), nil, nil, 1)  # 1 = G_CONNECT_AFTER
```

### 3.2 Управление обработчиками

```nim
proc g_signal_handler_disconnect*(
  instance: gpointer,
  handlerId: gulong
) {.importc.}
  ## Полностью отключает обработчик.

proc g_signal_handler_block*(
  instance: gpointer,
  handlerId: gulong
) {.importc.}
  ## Временно блокирует — обработчик не вызывается,
  ## но остаётся подключённым.

proc g_signal_handler_unblock*(
  instance: gpointer,
  handlerId: gulong
) {.importc.}

proc g_signal_handler_is_connected*(
  instance: gpointer,
  handlerId: gulong
): gboolean {.importc.}
  ## Проверяет, подключён ли обработчик.
```

```nim
# Паттерн блокировка/разблокировка:
let hid = g_signal_connect(entry, "changed",
                            cast[GCallback](onChange), nil)

# Изменить текст без вызова "changed":
g_signal_handler_block(entry, hid)
gtk_editable_set_text(entry, "новый текст")
g_signal_handler_unblock(entry, hid)
```

### 3.3 Массовое управление обработчиками

```nim
proc g_signal_handlers_block_by_func*(
  instance: gpointer,
  `func`: gpointer,
  data: gpointer
) {.importc.}
  ## Блокирует все обработчики с данной функцией и данными.

proc g_signal_handlers_unblock_by_func*(
  instance: gpointer,
  `func`: gpointer,
  data: gpointer
) {.importc.}

proc g_signal_handlers_disconnect_by_func*(
  instance: gpointer,
  `func`: gpointer,
  data: gpointer
) {.importc.}

proc g_signal_handlers_disconnect_by_data*(
  instance: gpointer,
  data: gpointer
) {.importc.}
  ## Отключает все обработчики с данным указателем data.
```

### 3.4 Эмиссия сигналов

```nim
proc g_signal_emit_by_name*(
  instance: gpointer,
  detailedSignal: cstring
) {.importc, varargs.}
  ## Программно запускает сигнал.

proc g_signal_stop_emission_by_name*(
  instance: gpointer,
  detailedSignal: cstring
) {.importc.}
  ## Останавливает текущую эмиссию сигнала.
  ## Вызывать только внутри обработчика этого сигнала.

proc g_signal_emit*(
  instance: gpointer,
  signalId: cuint,
  detail: GQuark
) {.importc, varargs.}
```

```nim
# Программное нажатие кнопки:
g_signal_emit_by_name(cast[gpointer](button), "clicked")

# Остановка default-обработчика клавиши:
proc onKeyPressed(ctrl: pointer, keyval: guint, keycode: guint,
                  state: guint, data: gpointer): gboolean {.cdecl.} =
  if keyval == 65307:  # GDK_KEY_Escape
    g_signal_stop_emission_by_name(ctrl, "key-pressed")
    return TRUE
  return FALSE
```

### 3.5 Информация о сигналах

```nim
proc g_signal_lookup*(name: cstring, itype: GType): cuint {.importc.}
  ## Получить числовой ID сигнала по имени и типу объекта.

proc g_signal_name*(signalId: cuint): cstring {.importc.}
  ## Получить имя сигнала по ID.

proc g_signal_list_ids*(itype: GType, nIds: ptr cuint): ptr cuint {.importc.}
  ## Список ID всех сигналов типа.

proc g_signal_query*(signalId: cuint, query: ptr GSignalQuery) {.importc.}
  ## Получить подробную информацию о сигнале.

proc g_signal_has_handler_pending*(
  instance: gpointer,
  signalId: cuint,
  detail: GQuark,
  mayBeBlocked: gboolean
): gboolean {.importc.}
```

```nim
# Интроспекция: узнать все сигналы GtkButton:
let btnType = g_type_from_name("GtkButton")
var nIds: cuint
let ids = g_signal_list_ids(btnType, addr nIds)
for i in 0 ..< nIds.int:
  echo "Сигнал: ", g_signal_name(ids[i])
```

### 3.6 Emission hooks

```nim
proc g_signal_add_emission_hook*(
  signalId: cuint,
  detail: GQuark,
  hookFunc: pointer,
  hookData: gpointer,
  dataDestroy: pointer
): gulong {.importc.}
  ## Глобальный перехватчик — вызывается для ВСЕХ эмиссий данного сигнала.

proc g_signal_remove_emission_hook*(
  signalId: cuint,
  hookId: gulong
) {.importc.}
```

### 3.7 Часто используемые сигналы

| Объект | Сигнал | Прототип callback |
|---|---|---|
| `GtkApplication` | `"activate"` | `proc(app: GtkApplication, data: gpointer)` |
| `GtkApplication` | `"startup"` | `proc(app: GtkApplication, data: gpointer)` |
| `GtkApplication` | `"shutdown"` | `proc(app: GtkApplication, data: gpointer)` |
| `GtkWindow` | `"close-request"` | `proc(win: GtkWindow, data: gpointer): gboolean` |
| `GtkButton` | `"clicked"` | `proc(btn: GtkButton, data: gpointer)` |
| `GtkToggleButton` | `"toggled"` | `proc(btn: GtkToggleButton, data: gpointer)` |
| `GtkCheckButton` | `"toggled"` | `proc(btn: GtkCheckButton, data: gpointer)` |
| `GtkSwitch` | `"state-set"` | `proc(sw: GtkSwitch, state: gboolean, data: gpointer): gboolean` |
| `GtkEntry` | `"changed"` | `proc(entry: GtkEntry, data: gpointer)` |
| `GtkEntry` | `"activate"` | `proc(entry: GtkEntry, data: gpointer)` |
| `GtkEntry` | `"icon-press"` | `proc(entry: GtkEntry, pos: GtkEntryIconPosition, data: gpointer)` |
| `GtkSearchEntry` | `"search-changed"` | `proc(entry: GtkSearchEntry, data: gpointer)` |
| `GtkSearchEntry` | `"stop-search"` | `proc(entry: GtkSearchEntry, data: gpointer)` |
| `GtkTextBuffer` | `"changed"` | `proc(buf: GtkTextBuffer, data: gpointer)` |
| `GtkTextBuffer` | `"insert-text"` | `proc(buf, iter, text, len, data)` |
| `GtkTextBuffer` | `"delete-range"` | `proc(buf, start, end, data)` |
| `GtkAdjustment` | `"value-changed"` | `proc(adj: GtkAdjustment, data: gpointer)` |
| `GtkSpinButton` | `"value-changed"` | `proc(btn: GtkSpinButton, data: gpointer)` |
| `GtkScale` | `"value-changed"` | `proc(scale: GtkScale, data: gpointer)` |
| `GtkComboBox` | `"changed"` | `proc(combo: GtkComboBox, data: gpointer)` |
| `GtkListBox` | `"row-selected"` | `proc(box: GtkListBox, row: GtkListBoxRow, data: gpointer)` |
| `GtkListBox` | `"row-activated"` | `proc(box: GtkListBox, row: GtkListBoxRow, data: gpointer)` |
| `GSimpleAction` | `"activate"` | `proc(action: GSimpleAction, param: GVariant, data: gpointer)` |
| `GSimpleAction` | `"change-state"` | `proc(action: GSimpleAction, value: GVariant, data: gpointer)` |
| `GObject` | `"notify::prop"` | `proc(obj: GObject, pspec: pointer, data: gpointer)` |

> **Сигнал `"notify"`:** Префикс `notify::` с именем свойства позволяет следить за изменением конкретного свойства GObject. Например: `"notify::active"` для `GtkSwitch`.

---

## 4. GtkWindow — окно

### 4.1 Создание

```nim
proc gtk_window_new*(): GtkWindow {.importc.}
  ## Создаёт новое пустое окно верхнего уровня.
  ## Для приложений предпочтительнее gtk_application_window_new().
```

### 4.2 Заголовок и размер

```nim
proc gtk_window_set_title*(window: GtkWindow, title: cstring) {.importc.}
proc gtk_window_get_title*(window: GtkWindow): cstring {.importc.}

proc gtk_window_set_default_size*(
  window: GtkWindow,
  width: gint,   # -1 = не задан
  height: gint   # -1 = не задан
) {.importc.}
  ## Начальный размер окна. Пользователь может изменить.

proc gtk_window_get_default_size*(
  window: GtkWindow,
  width: ptr gint,
  height: ptr gint
) {.importc.}

proc gtk_window_set_resizable*(window: GtkWindow, resizable: gboolean) {.importc.}
proc gtk_window_get_resizable*(window: GtkWindow): gboolean {.importc.}
```

### 4.3 Модальность и связь с родителем

```nim
proc gtk_window_set_modal*(window: GtkWindow, modal: gboolean) {.importc.}
  ## TRUE = блокирует взаимодействие с другими окнами приложения.

proc gtk_window_get_modal*(window: GtkWindow): gboolean {.importc.}

proc gtk_window_set_transient_for*(
  window: GtkWindow,
  parent: GtkWindow
) {.importc.}
  ## Делает window дочерним по отношению к parent.
  ## Обязательно для диалогов — позиционирование и поведение.

proc gtk_window_get_transient_for*(window: GtkWindow): GtkWindow {.importc.}
```

### 4.4 Отображение и состояние окна

```nim
proc gtk_window_present*(window: GtkWindow) {.importc.}
  ## Показывает окно и поднимает на передний план.
  ## Предпочтительнее gtk_widget_show() для окон.

proc gtk_window_close*(window: GtkWindow) {.importc.}
  ## Запрашивает закрытие окна (вызывает "close-request").

proc gtk_window_destroy*(window: GtkWindow) {.importc.}
  ## Немедленно уничтожает окно без вопросов.

proc gtk_window_fullscreen*(window: GtkWindow) {.importc.}
proc gtk_window_unfullscreen*(window: GtkWindow) {.importc.}
proc gtk_window_is_fullscreen*(window: GtkWindow): gboolean {.importc.}

proc gtk_window_maximize*(window: GtkWindow) {.importc.}
proc gtk_window_unmaximize*(window: GtkWindow) {.importc.}
proc gtk_window_is_maximized*(window: GtkWindow): gboolean {.importc.}

proc gtk_window_minimize*(window: GtkWindow) {.importc.}
proc gtk_window_unminimize*(window: GtkWindow) {.importc.}
```

### 4.5 Содержимое и оформление

```nim
proc gtk_window_set_child*(window: GtkWindow, child: GtkWidget) {.importc.}
  ## Устанавливает единственный дочерний виджет окна.

proc gtk_window_get_child*(window: GtkWindow): GtkWidget {.importc.}

proc gtk_window_set_titlebar*(window: GtkWindow, titlebar: GtkWidget) {.importc.}
  ## Заменяет стандартный заголовок на пользовательский виджет
  ## (напр. GtkHeaderBar).

proc gtk_window_get_titlebar*(window: GtkWindow): GtkWidget {.importc.}

proc gtk_window_set_decorated*(window: GtkWindow, setting: gboolean) {.importc.}
  ## FALSE = окно без рамки и заголовка (для splash screens, виджетов).

proc gtk_window_get_decorated*(window: GtkWindow): gboolean {.importc.}

proc gtk_window_set_deletable*(window: GtkWindow, setting: gboolean) {.importc.}
  ## FALSE = кнопка [X] скрыта/заблокирована.

proc gtk_window_get_deletable*(window: GtkWindow): gboolean {.importc.}
```

### 4.6 Иконки

```nim
proc gtk_window_set_default_icon_name*(name: cstring) {.importc.}
  ## Иконка по умолчанию для всех окон приложения.
  ## Берётся из текущей темы иконок.

proc gtk_window_set_icon_name*(window: GtkWindow, name: cstring) {.importc.}
  ## Иконка конкретного окна по имени из темы.

proc gtk_window_get_icon_name*(window: GtkWindow): cstring {.importc.}

proc gtk_window_set_icon_paintable*(
  window: GtkWindow,
  paintable: pointer  # GdkPaintable*
) {.importc.}
  ## Иконка из GdkPaintable (текстура, рисованная иконка).
```

### 4.7 Перехват закрытия окна

```nim
# Сигнал "close-request" позволяет перехватить нажатие [X]:
proc onCloseRequest(win: GtkWindow, data: gpointer): gboolean {.cdecl.} =
  # Показать диалог подтверждения...
  # Вернуть TRUE = отменить закрытие (GTK не закрывает окно)
  # Вернуть FALSE = разрешить закрытие (окно закроется)
  return TRUE  # отменить

discard g_signal_connect(win, "close-request",
                          cast[GCallback](onCloseRequest), nil)
```

---

## 5. GtkWidget — базовые функции виджетов

Все виджеты GTK наследуют интерфейс `GtkWidget`. Эти функции работают с любым виджетом.

### 5.1 Видимость и состояние

```nim
proc gtk_widget_show*(widget: GtkWidget) {.importc.}
  ## Показывает виджет. В GTK4 виджеты видимы по умолчанию
  ## (кроме окон верхнего уровня — используйте gtk_window_present).

proc gtk_widget_hide*(widget: GtkWidget) {.importc.}

proc gtk_widget_set_visible*(widget: GtkWidget, visible: gboolean) {.importc.}
proc gtk_widget_get_visible*(widget: GtkWidget): gboolean {.importc.}

proc gtk_widget_set_sensitive*(widget: GtkWidget, sensitive: gboolean) {.importc.}
  ## FALSE = виджет серый (неактивный, не принимает ввод).

proc gtk_widget_get_sensitive*(widget: GtkWidget): gboolean {.importc.}

proc gtk_widget_is_sensitive*(widget: GtkWidget): gboolean {.importc.}
  ## TRUE только если виджет и все его предки чувствительны.
```

### 5.2 Фокус

```nim
proc gtk_widget_set_can_focus*(widget: GtkWidget, canFocus: gboolean) {.importc.}
proc gtk_widget_get_can_focus*(widget: GtkWidget): gboolean {.importc.}

proc gtk_widget_grab_focus*(widget: GtkWidget): gboolean {.importc.}
  ## Перемещает клавиатурный фокус на виджет.
  ## Возвращает TRUE если фокус успешно перенесён.

proc gtk_widget_has_focus*(widget: GtkWidget): gboolean {.importc.}
proc gtk_widget_is_focus*(widget: GtkWidget): gboolean {.importc.}

proc gtk_widget_set_focus_on_click*(
  widget: GtkWidget,
  focusOnClick: gboolean
) {.importc.}
  ## Управляет, получает ли виджет фокус при клике мышью.
```

### 5.3 Размеры и расположение

```nim
proc gtk_widget_set_size_request*(
  widget: GtkWidget,
  width: gint,   # Минимальная ширина. -1 = не задана.
  height: gint   # Минимальная высота. -1 = не задана.
) {.importc.}

proc gtk_widget_get_size_request*(
  widget: GtkWidget,
  width: ptr gint,
  height: ptr gint
) {.importc.}

proc gtk_widget_get_allocated_width*(widget: GtkWidget): gint {.importc.}
  ## Фактическая выделенная ширина (после layout).

proc gtk_widget_get_allocated_height*(widget: GtkWidget): gint {.importc.}

proc gtk_widget_set_hexpand*(widget: GtkWidget, expand: gboolean) {.importc.}
  ## TRUE = растягивается горизонтально в контейнере.

proc gtk_widget_get_hexpand*(widget: GtkWidget): gboolean {.importc.}

proc gtk_widget_set_vexpand*(widget: GtkWidget, expand: gboolean) {.importc.}
  ## TRUE = растягивается вертикально.

proc gtk_widget_get_vexpand*(widget: GtkWidget): gboolean {.importc.}

proc gtk_widget_set_hexpand_set*(widget: GtkWidget, set: gboolean) {.importc.}
  ## TRUE = использовать локальное значение hexpand (не наследовать).
```

### 5.4 Выравнивание

```nim
proc gtk_widget_set_halign*(widget: GtkWidget, align: GtkAlign) {.importc.}
proc gtk_widget_get_halign*(widget: GtkWidget): GtkAlign {.importc.}

proc gtk_widget_set_valign*(widget: GtkWidget, align: GtkAlign) {.importc.}
proc gtk_widget_get_valign*(widget: GtkWidget): GtkAlign {.importc.}
```

```nim
# Центрирование виджета:
gtk_widget_set_halign(cast[GtkWidget](btn), GTK_ALIGN_CENTER)
gtk_widget_set_valign(cast[GtkWidget](btn), GTK_ALIGN_CENTER)

# Прижать к правому нижнему углу:
gtk_widget_set_halign(cast[GtkWidget](btn), GTK_ALIGN_END)
gtk_widget_set_valign(cast[GtkWidget](btn), GTK_ALIGN_END)
```

### 5.5 Отступы (margin)

```nim
proc gtk_widget_set_margin_start*(widget: GtkWidget, margin: gint) {.importc.}
  ## Левый отступ (или правый в RTL-локалях).

proc gtk_widget_get_margin_start*(widget: GtkWidget): gint {.importc.}

proc gtk_widget_set_margin_end*(widget: GtkWidget, margin: gint) {.importc.}
  ## Правый отступ (или левый в RTL).

proc gtk_widget_get_margin_end*(widget: GtkWidget): gint {.importc.}

proc gtk_widget_set_margin_top*(widget: GtkWidget, margin: gint) {.importc.}
proc gtk_widget_get_margin_top*(widget: GtkWidget): gint {.importc.}

proc gtk_widget_set_margin_bottom*(widget: GtkWidget, margin: gint) {.importc.}
proc gtk_widget_get_margin_bottom*(widget: GtkWidget): gint {.importc.}
```

```nim
# Хелпер из библиотеки — все отступы одним вызовом:
proc setMargins*(widget: GtkWidget, top, right, bottom, left: int)
proc setMargins*(widget: GtkWidget, all: int)

# Использование:
setMargins(cast[GtkWidget](btn), 12)        # 12px со всех сторон
setMargins(cast[GtkWidget](lbl), 4, 8, 4, 8) # top right bottom left
```

### 5.6 CSS-классы и имя виджета

```nim
proc gtk_widget_add_css_class*(widget: GtkWidget, cssClass: cstring) {.importc.}
proc gtk_widget_remove_css_class*(widget: GtkWidget, cssClass: cstring) {.importc.}
proc gtk_widget_has_css_class*(
  widget: GtkWidget,
  cssClass: cstring
): gboolean {.importc.}

proc gtk_widget_get_css_classes*(widget: GtkWidget): ptr cstring {.importc.}
  ## Возвращает NULL-terminated массив CSS-классов виджета.

proc gtk_widget_set_css_classes*(
  widget: GtkWidget,
  classes: ptr cstring
) {.importc.}

proc gtk_widget_set_name*(widget: GtkWidget, name: cstring) {.importc.}
  ## Устанавливает имя для CSS-селектора #name.

proc gtk_widget_get_name*(widget: GtkWidget): cstring {.importc.}
```

```nim
# CSS-таргетирование:
gtk_widget_set_name(cast[GtkWidget](btn), "save-button")
gtk_widget_add_css_class(cast[GtkWidget](btn), "suggested-action")

# В CSS:
# #save-button { ... }
# .suggested-action { background: #3584e4; }
```

### 5.7 Подсказки (tooltip)

```nim
proc gtk_widget_set_tooltip_text*(widget: GtkWidget, text: cstring) {.importc.}
  ## Простой текстовый tooltip.

proc gtk_widget_get_tooltip_text*(widget: GtkWidget): cstring {.importc.}

proc gtk_widget_set_tooltip_markup*(widget: GtkWidget, markup: cstring) {.importc.}
  ## Tooltip с Pango-разметкой.

proc gtk_widget_get_tooltip_markup*(widget: GtkWidget): cstring {.importc.}
```

### 5.8 Обход дерева виджетов

```nim
proc gtk_widget_get_parent*(widget: GtkWidget): GtkWidget {.importc.}
  ## Возвращает родительский виджет или nil.

proc gtk_widget_get_first_child*(widget: GtkWidget): GtkWidget {.importc.}
proc gtk_widget_get_last_child*(widget: GtkWidget): GtkWidget {.importc.}
proc gtk_widget_get_next_sibling*(widget: GtkWidget): GtkWidget {.importc.}
proc gtk_widget_get_prev_sibling*(widget: GtkWidget): GtkWidget {.importc.}

proc gtk_widget_get_ancestor*(
  widget: GtkWidget,
  widget_type: GType
): GtkWidget {.importc.}
  ## Ищет ближайшего предка заданного типа.
```

```nim
# Итерация по детям виджета:
var child = gtk_widget_get_first_child(cast[GtkWidget](box))
while child != nil:
  # обработка child
  child = gtk_widget_get_next_sibling(child)
```

### 5.9 Система стилей и дисплей

```nim
proc gtk_widget_get_style_context*(
  widget: GtkWidget
): GtkStyleContext {.importc.}

proc gtk_widget_get_pango_context*(widget: GtkWidget): PangoContext {.importc.}
  ## Контекст шрифтов для рисования текста.

proc gtk_widget_get_display*(widget: GtkWidget): GdkDisplay {.importc.}
  ## Дисплей, на котором отображается виджет.

proc gtk_widget_get_settings*(widget: GtkWidget): pointer {.importc.}
  ## GtkSettings* — настройки темы и системные параметры.

proc gtk_widget_get_clipboard*(widget: GtkWidget): GdkClipboard {.importc.}
  ## Буфер обмена для виджета.
```

### 5.10 Контроллеры событий

```nim
proc gtk_widget_add_controller*(
  widget: GtkWidget,
  controller: GtkEventController
) {.importc.}
  ## Добавляет контроллер событий (мышь, клавиатура, жесты).

proc gtk_widget_remove_controller*(
  widget: GtkWidget,
  controller: GtkEventController
) {.importc.}

proc gtk_widget_insert_action_group*(
  widget: GtkWidget,
  name: cstring,          # Префикс для действий (напр. "win")
  group: GActionGroup
) {.importc.}
  ## Присоединяет группу действий. Виджет становится
  ## точкой поиска для действий с данным префиксом.

proc gtk_widget_action_set_enabled*(
  widget: GtkWidget,
  action_name: cstring,
  enabled: gboolean
) {.importc.}
```

### 5.11 Прочие полезные функции

```nim
proc gtk_widget_queue_draw*(widget: GtkWidget) {.importc.}
  ## Запрашивает перерисовку виджета (в следующем фрейме).

proc gtk_widget_queue_resize*(widget: GtkWidget) {.importc.}
  ## Запрашивает пересчёт размеров.

proc gtk_widget_get_root*(widget: GtkWidget): pointer {.importc.}
  ## GtkRoot* — корневой виджет (обычно GtkWindow).

proc gtk_widget_unparent*(widget: GtkWidget) {.importc.}
  ## Удаляет виджет из родителя (для создания custom виджетов).

proc gtk_widget_get_realized*(widget: GtkWidget): gboolean {.importc.}
proc gtk_widget_get_mapped*(widget: GtkWidget): gboolean {.importc.}
```

---

## 6. GtkBox — линейный контейнер

Размещает дочерние виджеты в одну строку или столбец.

### 6.1 Создание

```nim
proc gtk_box_new*(
  orientation: GtkOrientation,  # GTK_ORIENTATION_HORIZONTAL или _VERTICAL
  spacing: gint                 # Промежуток между детьми в пикселях
): GtkBox {.importc.}
```

```nim
# Хелперы из библиотеки:
proc createHBox*(spacing = 0, homogeneous = false): GtkBox
proc createVBox*(spacing = 0, homogeneous = false): GtkBox

# Пример:
let hbox = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 6)
let vbox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 12)
```

### 6.2 Добавление и удаление детей

```nim
proc gtk_box_append*(box: GtkBox, child: GtkWidget) {.importc.}
  ## Добавить в конец.

proc gtk_box_prepend*(box: GtkBox, child: GtkWidget) {.importc.}
  ## Добавить в начало.

proc gtk_box_remove*(box: GtkBox, child: GtkWidget) {.importc.}
  ## Удалить дочерний виджет.

proc gtk_box_insert_child_after*(
  box: GtkBox,
  child: GtkWidget,
  sibling: GtkWidget  # nil = вставить в начало
) {.importc.}
  ## Вставить child после sibling.

proc gtk_box_reorder_child_after*(
  box: GtkBox,
  child: GtkWidget,
  sibling: GtkWidget  # nil = переместить в начало
) {.importc.}
  ## Переместить child после sibling.
```

```nim
# Хелпер:
proc addChildren*(box: GtkBox, children: varargs[GtkWidget])

# Пример:
let box = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 8)
gtk_box_append(box, cast[GtkWidget](label))
gtk_box_append(box, cast[GtkWidget](entry))
gtk_box_append(box, cast[GtkWidget](button))
```

### 6.3 Настройка

```nim
proc gtk_box_set_spacing*(box: GtkBox, spacing: gint) {.importc.}
proc gtk_box_get_spacing*(box: GtkBox): gint {.importc.}

proc gtk_box_set_homogeneous*(box: GtkBox, homogeneous: gboolean) {.importc.}
  ## TRUE = все дети получают одинаковое пространство.

proc gtk_box_get_homogeneous*(box: GtkBox): gboolean {.importc.}

proc gtk_box_set_baseline_position*(
  box: GtkBox,
  position: GtkBaselinePosition
) {.importc.}
proc gtk_box_get_baseline_position*(box: GtkBox): GtkBaselinePosition {.importc.}

proc gtk_box_set_baseline_child*(box: GtkBox, child: gint) {.importc.}
  ## Индекс дочернего виджета для выравнивания по базовой линии (-1 = нет).

proc gtk_box_get_baseline_child*(box: GtkBox): gint {.importc.}
```

### 6.4 Типичные паттерны использования GtkBox

```nim
# Кнопочная панель (горизонтальный box с кнопками справа):
let btnBox = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 8)
gtk_widget_set_halign(cast[GtkWidget](btnBox), GTK_ALIGN_END)
gtk_box_append(btnBox, cast[GtkWidget](cancelBtn))
gtk_box_append(btnBox, cast[GtkWidget](okBtn))

# Вертикальная форма (метки и поля):
let formBox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 12)
setMargins(cast[GtkWidget](formBox), 24)
gtk_box_append(formBox, cast[GtkWidget](nameLabel))
gtk_box_append(formBox, cast[GtkWidget](nameEntry))
gtk_box_append(formBox, cast[GtkWidget](emailLabel))
gtk_box_append(formBox, cast[GtkWidget](emailEntry))

# "Резиновый" разделитель между виджетами:
let spacer = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0)
gtk_widget_set_hexpand(cast[GtkWidget](spacer), TRUE)
gtk_box_append(toolbar, cast[GtkWidget](leftBtn))
gtk_box_append(toolbar, cast[GtkWidget](spacer))  # растягивается
gtk_box_append(toolbar, cast[GtkWidget](rightBtn))
```

---

## 7. GtkGrid — сеточный контейнер

Размещает виджеты в строках и колонках. Виджеты могут занимать несколько ячеек.

### 7.1 Создание

```nim
proc gtk_grid_new*(): GtkGrid {.importc.}
```

```nim
# Хелпер:
proc createGrid*(
  rowSpacing = 0,
  columnSpacing = 0,
  homogeneous = false
): GtkGrid
```

### 7.2 Добавление виджетов

```nim
proc gtk_grid_attach*(
  grid: GtkGrid,
  child: GtkWidget,
  column: gint,  # Позиция колонки (начало с 0)
  row: gint,     # Позиция строки (начало с 0)
  width: gint,   # Количество занимаемых колонок
  height: gint   # Количество занимаемых строк
) {.importc.}

proc gtk_grid_attach_next_to*(
  grid: GtkGrid,
  child: GtkWidget,
  sibling: GtkWidget,        # Соседний виджет
  side: GtkPositionType,     # GTK_POS_LEFT/RIGHT/TOP/BOTTOM
  width: gint,
  height: gint
) {.importc.}
  ## Прикрепить child рядом с sibling.

proc gtk_grid_remove*(grid: GtkGrid, child: GtkWidget) {.importc.}

proc gtk_grid_get_child_at*(
  grid: GtkGrid,
  column: gint,
  row: gint
): GtkWidget {.importc.}
  ## Получить виджет в данной ячейке (nil если пусто).
```

```nim
# Хелпер:
proc attachGrid*(
  grid: GtkGrid,
  child: GtkWidget,
  x = 0, y = 0,
  width = 1, height = 1
)

# Пример — форма с меткой и полем:
let grid = gtk_grid_new()
gtk_grid_set_row_spacing(grid, 8)
gtk_grid_set_column_spacing(grid, 12)

gtk_grid_attach(grid, cast[GtkWidget](nameLabel),  0, 0, 1, 1)
gtk_grid_attach(grid, cast[GtkWidget](nameEntry),  1, 0, 1, 1)
gtk_grid_attach(grid, cast[GtkWidget](emailLabel), 0, 1, 1, 1)
gtk_grid_attach(grid, cast[GtkWidget](emailEntry), 1, 1, 1, 1)
# Кнопка занимает обе колонки:
gtk_grid_attach(grid, cast[GtkWidget](submitBtn),  0, 2, 2, 1)
```

### 7.3 Настройка сетки

```nim
proc gtk_grid_set_row_spacing*(grid: GtkGrid, spacing: guint) {.importc.}
proc gtk_grid_get_row_spacing*(grid: GtkGrid): guint {.importc.}

proc gtk_grid_set_column_spacing*(grid: GtkGrid, spacing: guint) {.importc.}
proc gtk_grid_get_column_spacing*(grid: GtkGrid): guint {.importc.}

proc gtk_grid_set_row_homogeneous*(
  grid: GtkGrid,
  homogeneous: gboolean
) {.importc.}
  ## TRUE = все строки одинаковой высоты.

proc gtk_grid_get_row_homogeneous*(grid: GtkGrid): gboolean {.importc.}

proc gtk_grid_set_column_homogeneous*(
  grid: GtkGrid,
  homogeneous: gboolean
) {.importc.}
  ## TRUE = все колонки одинаковой ширины.

proc gtk_grid_get_column_homogeneous*(grid: GtkGrid): gboolean {.importc.}
```

### 7.4 Динамическое изменение

```nim
proc gtk_grid_insert_row*(grid: GtkGrid, position: gint) {.importc.}
  ## Вставить пустую строку на позицию position.

proc gtk_grid_insert_column*(grid: GtkGrid, position: gint) {.importc.}

proc gtk_grid_remove_row*(grid: GtkGrid, position: gint) {.importc.}
proc gtk_grid_remove_column*(grid: GtkGrid, position: gint) {.importc.}

proc gtk_grid_insert_next_to*(
  grid: GtkGrid,
  sibling: GtkWidget,
  side: GtkPositionType
) {.importc.}
  ## Вставить строку или колонку рядом с виджетом.

proc gtk_grid_query_child*(
  grid: GtkGrid,
  child: GtkWidget,
  column: ptr gint,
  row: ptr gint,
  width: ptr gint,
  height: ptr gint
) {.importc.}
  ## Узнать позицию и размер дочернего виджета в сетке.
```

### 7.5 Baseline в Grid

```nim
proc gtk_grid_set_baseline_row*(grid: GtkGrid, row: gint) {.importc.}
proc gtk_grid_get_baseline_row*(grid: GtkGrid): gint {.importc.}

proc gtk_grid_set_row_baseline_position*(
  grid: GtkGrid,
  row: gint,
  pos: GtkBaselinePosition
) {.importc.}
proc gtk_grid_get_row_baseline_position*(
  grid: GtkGrid,
  row: gint
): GtkBaselinePosition {.importc.}
```

---

## 8. GtkLabel — текстовая метка

### 8.1 Создание

```nim
proc gtk_label_new*(str: cstring): GtkLabel {.importc.}
  ## str = nil создаёт пустую метку.

proc gtk_label_new_with_mnemonic*(str: cstring): GtkLabel {.importc.}
  ## Символ '_' обозначает мнемоник (напр. "_Открыть" → Alt+О).
```

```nim
# Хелпер:
proc createLabel*(text: string, markup = false): GtkLabel
```

### 8.2 Текст и разметка Pango

```nim
proc gtk_label_set_text*(label: GtkLabel, str: cstring) {.importc.}
proc gtk_label_get_text*(label: GtkLabel): cstring {.importc.}

proc gtk_label_set_markup*(label: GtkLabel, str: cstring) {.importc.}
  ## Устанавливает текст с Pango-разметкой:
  ## <b>Жирный</b>  <i>Курсив</i>  <u>Подчёркнутый</u>
  ## <span color="red">Красный</span>
  ## <span font="Monospace">Моноширинный</span>
  ## <tt>Телетайп</tt>  <big>Большой</big>  <small>Маленький</small>
  ## <sup>Верхний</sup>  <sub>Нижний</sub>  <s>Зачёркнутый</s>

proc gtk_label_set_use_markup*(label: GtkLabel, setting: gboolean) {.importc.}
  ## TRUE = интерпретировать текст как Pango markup.

proc gtk_label_set_markup_with_mnemonic*(label: GtkLabel, str: cstring) {.importc.}

proc gtk_label_set_label*(label: GtkLabel, str: cstring) {.importc.}
  ## Устанавливает исходную строку (с мнемониками и разметкой).
proc gtk_label_get_label*(label: GtkLabel): cstring {.importc.}
```

```nim
# Примеры Pango markup:
gtk_label_set_markup(lbl, "<b>Жирный текст</b>")
gtk_label_set_markup(lbl, "<span color='#3584e4' font='16'>Синий, 16px</span>")
gtk_label_set_markup(lbl, "Обычный <i>курсив</i> и <b><u>жирный подчёркнутый</u></b>")
```

### 8.3 Форматирование

```nim
proc gtk_label_set_justify*(label: GtkLabel, jtype: GtkJustification) {.importc.}
  ## Выравнивание текста внутри метки.

proc gtk_label_set_wrap*(label: GtkLabel, wrap: gboolean) {.importc.}
  ## TRUE = переносить текст при нехватке ширины.

proc gtk_label_set_wrap_mode*(label: GtkLabel, wrapMode: PangoWrapMode) {.importc.}
  ## Режим переноса: PANGO_WRAP_WORD, _CHAR, _WORD_CHAR.

proc gtk_label_set_ellipsize*(label: GtkLabel, mode: PangoEllipsizeMode) {.importc.}
  ## Добавляет "…" при обрезании:
  ## PANGO_ELLIPSIZE_START / MIDDLE / END.

proc gtk_label_set_width_chars*(label: GtkLabel, nChars: gint) {.importc.}
  ## Минимальная ширина в символах.

proc gtk_label_set_max_width_chars*(label: GtkLabel, nChars: gint) {.importc.}
  ## Максимальная ширина в символах. -1 = без ограничения.

proc gtk_label_set_lines*(label: GtkLabel, lines: gint) {.importc.}
  ## Максимальное число строк. -1 = неограниченно.

proc gtk_label_set_single_line_mode*(
  label: GtkLabel,
  single_line_mode: gboolean
) {.importc.}
  ## TRUE = принудительно одна строка.

proc gtk_label_set_xalign*(label: GtkLabel, xalign: cfloat) {.importc.}
  ## Горизонтальное выравнивание контента: 0.0=левое, 0.5=центр, 1.0=правое.

proc gtk_label_set_yalign*(label: GtkLabel, yalign: cfloat) {.importc.}
  ## Вертикальное выравнивание: 0.0=верх, 0.5=центр, 1.0=низ.
```

### 8.4 Выбор текста

```nim
proc gtk_label_set_selectable*(label: GtkLabel, setting: gboolean) {.importc.}
  ## TRUE = пользователь может выделять текст мышью и копировать.

proc gtk_label_get_selectable*(label: GtkLabel): gboolean {.importc.}

proc gtk_label_select_region*(
  label: GtkLabel,
  start_offset: gint,
  end_offset: gint      # -1 = до конца
) {.importc.}

proc gtk_label_get_selection_bounds*(
  label: GtkLabel,
  start: ptr gint,
  `end`: ptr gint
): gboolean {.importc.}
  ## Возвращает TRUE если есть активное выделение.
```

### 8.5 Ссылки в метках

```nim
proc gtk_label_set_use_underline*(label: GtkLabel, setting: gboolean) {.importc.}
  ## TRUE = интерпретировать _ как мнемоник.

proc gtk_label_set_mnemonic_widget*(
  label: GtkLabel,
  widget: GtkWidget
) {.importc.}
  ## Виджет, которому передаётся фокус при нажатии мнемоника.

proc gtk_label_get_mnemonic_widget*(label: GtkLabel): GtkWidget {.importc.}
```

---

## 9. GtkButton — кнопки

### 9.1 GtkButton

```nim
proc gtk_button_new*(): GtkButton {.importc.}
  ## Пустая кнопка — задайте дочерний виджет через set_child.

proc gtk_button_new_with_label*(label: cstring): GtkButton {.importc.}
  ## Кнопка с текстовой меткой.

proc gtk_button_new_with_mnemonic*(label: cstring): GtkButton {.importc.}
  ## Кнопка с мнемоником (символ _ = горячая клавиша Alt+).

proc gtk_button_new_from_icon_name*(icon_name: cstring): GtkButton {.importc.}
  ## Кнопка с иконкой из темы (напр. "document-open").

proc gtk_button_set_label*(button: GtkButton, label: cstring) {.importc.}
proc gtk_button_get_label*(button: GtkButton): cstring {.importc.}

proc gtk_button_set_icon_name*(button: GtkButton, iconName: cstring) {.importc.}
proc gtk_button_get_icon_name*(button: GtkButton): cstring {.importc.}

proc gtk_button_set_child*(button: GtkButton, child: GtkWidget) {.importc.}
  ## Произвольный дочерний виджет вместо текста/иконки.

proc gtk_button_get_child*(button: GtkButton): GtkWidget {.importc.}

proc gtk_button_set_has_frame*(button: GtkButton, hasFrame: gboolean) {.importc.}
  ## FALSE = кнопка без рамки (для панелей инструментов).

proc gtk_button_get_has_frame*(button: GtkButton): gboolean {.importc.}

proc gtk_button_set_can_shrink*(button: GtkButton, can_shrink: gboolean) {.importc.}
  ## TRUE = метка может сжиматься с ellipsis.
```

```nim
# Хелпер:
proc createButton*(
  label: string,
  onClick: GCallback = nil,
  data: pointer = nil
): GtkButton

# Стандартные CSS-классы кнопок:
# "suggested-action" — синяя кнопка (действие по умолчанию)
# "destructive-action" — красная кнопка (опасное действие)
# "flat" — плоская кнопка без рамки
# "circular" — круглая кнопка
# "pill" — кнопка-таблетка

let okBtn = gtk_button_new_with_label("Сохранить")
gtk_widget_add_css_class(cast[GtkWidget](okBtn), "suggested-action")

let delBtn = gtk_button_new_with_label("Удалить")
gtk_widget_add_css_class(cast[GtkWidget](delBtn), "destructive-action")
```

**Сигналы:** `"clicked"`, `"activate"`

### 9.2 GtkToggleButton

```nim
proc gtk_toggle_button_new*(): GtkToggleButton {.importc.}
proc gtk_toggle_button_new_with_label*(label: cstring): GtkToggleButton {.importc.}
proc gtk_toggle_button_new_with_mnemonic*(label: cstring): GtkToggleButton {.importc.}

proc gtk_toggle_button_set_active*(
  toggleButton: GtkToggleButton,
  isActive: gboolean
) {.importc.}
proc gtk_toggle_button_get_active*(toggleButton: GtkToggleButton): gboolean {.importc.}

proc gtk_toggle_button_set_group*(
  toggle_button: GtkToggleButton,
  group: GtkToggleButton  # nil = убрать из группы
) {.importc.}
  ## Группировка: только одна кнопка активна в группе.
  ## Поведение радиокнопок через ToggleButton.
```

**Сигналы:** `"toggled"`

```nim
# Группа кнопок (только одна нажата):
let btn1 = gtk_toggle_button_new_with_label("День")
let btn2 = gtk_toggle_button_new_with_label("Неделя")
let btn3 = gtk_toggle_button_new_with_label("Месяц")
gtk_toggle_button_set_group(btn2, btn1)
gtk_toggle_button_set_group(btn3, btn1)
gtk_toggle_button_set_active(btn1, TRUE)  # Начально нажат первый
```

### 9.3 GtkCheckButton

В GTK4 `GtkCheckButton` используется и как флажок, и как радиокнопка через `set_group`.

```nim
proc gtk_check_button_new*(): GtkCheckButton {.importc.}
proc gtk_check_button_new_with_label*(label: cstring): GtkCheckButton {.importc.}
proc gtk_check_button_new_with_mnemonic*(label: cstring): GtkCheckButton {.importc.}

proc gtk_check_button_set_active*(
  checkButton: GtkCheckButton,
  setting: gboolean
) {.importc.}
proc gtk_check_button_get_active*(checkButton: GtkCheckButton): gboolean {.importc.}

proc gtk_check_button_set_inconsistent*(
  checkButton: GtkCheckButton,
  inconsistent: gboolean
) {.importc.}
  ## Третье состояние флажка ("неопределено") — квадрат внутри.

proc gtk_check_button_get_inconsistent*(checkButton: GtkCheckButton): gboolean {.importc.}

proc gtk_check_button_set_group*(
  check_button: GtkCheckButton,
  group: GtkCheckButton  # nil = убрать из группы
) {.importc.}
  ## Радиокнопка: только одна активна.

proc gtk_check_button_set_label*(checkButton: GtkCheckButton, label: cstring) {.importc.}
proc gtk_check_button_get_label*(checkButton: GtkCheckButton): cstring {.importc.}

proc gtk_check_button_set_child*(checkButton: GtkCheckButton, child: GtkWidget) {.importc.}
```

```nim
# Хелпер:
proc createCheckButton*(label: string, active = false): GtkCheckButton

# Пример радиокнопок:
let rb1 = gtk_check_button_new_with_label("Вариант А")
let rb2 = gtk_check_button_new_with_label("Вариант Б")
let rb3 = gtk_check_button_new_with_label("Вариант В")
gtk_check_button_set_group(rb2, rb1)
gtk_check_button_set_group(rb3, rb1)
gtk_check_button_set_active(rb1, TRUE)
```

**Сигналы:** `"toggled"`, `"activate"`

### 9.4 GtkSwitch

Имеет два независимых состояния: **active** (визуальное/анимированное) и **state** (логическое). Разделение позволяет показать диалог подтверждения перед фактическим переключением.

```nim
proc gtk_switch_new*(): GtkSwitch {.importc.}

proc gtk_switch_set_active*(sw: GtkSwitch, isActive: gboolean) {.importc.}
  ## Визуальное состояние переключателя.

proc gtk_switch_get_active*(sw: GtkSwitch): gboolean {.importc.}

proc gtk_switch_set_state*(sw: GtkSwitch, state: gboolean) {.importc.}
  ## Логическое состояние. Обычно устанавливается в "state-set".

proc gtk_switch_get_state*(sw: GtkSwitch): gboolean {.importc.}
```

**Сигнал `"state-set"`:** возвращает `gboolean`.
- `TRUE` = обработчик управляет state самостоятельно (GTK не устанавливает state).
- `FALSE` = GTK автоматически синхронизирует state с active.

```nim
# Хелпер:
proc createSwitch*(active = false): GtkSwitch

# Пример с диалогом подтверждения:
proc onStateSet(sw: GtkSwitch, state: gboolean, data: gpointer): gboolean {.cdecl.} =
  if state:
    # Показать диалог подтверждения...
    # Если пользователь согласился:
    gtk_switch_set_state(sw, TRUE)
  else:
    gtk_switch_set_state(sw, FALSE)
  return TRUE  # мы управляем state сами

discard g_signal_connect(sw, "state-set",
                          cast[GCallback](onStateSet), nil)
```

### 9.5 GtkLinkButton

```nim
proc gtk_link_button_new*(uri: cstring): GtkLinkButton {.importc.}
  ## Кнопка, открывающая URI в браузере.

proc gtk_link_button_new_with_label*(
  uri: cstring,
  label: cstring
): GtkLinkButton {.importc.}

proc gtk_link_button_get_uri*(link_button: pointer): cstring {.importc.}
proc gtk_link_button_set_uri*(link_button: pointer, uri: cstring) {.importc.}
proc gtk_link_button_get_visited*(link_button: pointer): gboolean {.importc.}
proc gtk_link_button_set_visited*(link_button: pointer, visited: gboolean) {.importc.}
```

### 9.6 GtkMenuButton

```nim
proc gtk_menu_button_new*(): GtkMenuButton {.importc.}

proc gtk_menu_button_set_popover*(
  menu_button: GtkMenuButton,
  popover: GtkPopover
) {.importc.}

proc gtk_menu_button_set_menu_model*(
  menu_button: GtkMenuButton,
  menu_model: GMenuModel
) {.importc.}

proc gtk_menu_button_set_label*(menu_button: GtkMenuButton, label: cstring) {.importc.}
proc gtk_menu_button_set_icon_name*(menu_button: GtkMenuButton, iconName: cstring) {.importc.}
proc gtk_menu_button_set_direction*(menu_button: GtkMenuButton, direction: GtkArrowType) {.importc.}
proc gtk_menu_button_set_always_show_arrow*(menu_button: GtkMenuButton, alwaysShowArrow: gboolean) {.importc.}
proc gtk_menu_button_popup*(menu_button: GtkMenuButton) {.importc.}
proc gtk_menu_button_popdown*(menu_button: GtkMenuButton) {.importc.}
```

---

## 10. GtkEntry — поля ввода

### 10.1 GtkEntry (однострочное поле)

```nim
proc gtk_entry_new*(): GtkEntry {.importc.}
proc gtk_entry_new_with_buffer*(buffer: GtkEntryBuffer): GtkEntry {.importc.}
```

**Текст (через GtkEditable API):**

```nim
# В GTK4 GtkEntry реализует интерфейс GtkEditable
proc gtk_editable_get_text*(editable: pointer): cstring {.importc.}
proc gtk_editable_set_text*(editable: pointer, text: cstring) {.importc.}
```

**Настройки:**

```nim
proc gtk_entry_set_placeholder_text*(entry: GtkEntry, text: cstring) {.importc.}
  ## Текст-подсказка, отображаемый в пустом поле.

proc gtk_entry_get_placeholder_text*(entry: GtkEntry): cstring {.importc.}

proc gtk_entry_set_visibility*(entry: GtkEntry, visible: gboolean) {.importc.}
  ## FALSE = скрыть ввод (режим пароля с bullet-символами).

proc gtk_entry_get_visibility*(entry: GtkEntry): gboolean {.importc.}

proc gtk_entry_set_max_length*(entry: GtkEntry, max: gint) {.importc.}
  ## Максимальное число символов. 0 = без ограничения.

proc gtk_entry_get_max_length*(entry: GtkEntry): gint {.importc.}

proc gtk_entry_set_has_frame*(entry: GtkEntry, setting: gboolean) {.importc.}
  ## FALSE = поле без рамки.

proc gtk_entry_set_alignment*(entry: GtkEntry, xalign: gfloat) {.importc.}
  ## Горизонтальное выравнивание текста: 0.0=левое, 1.0=правое.

proc gtk_entry_set_activates_default*(
  entry: GtkEntry,
  setting: gboolean
) {.importc.}
  ## TRUE = нажатие Enter активирует кнопку по умолчанию в диалоге.

proc gtk_entry_get_text_length*(entry: GtkEntry): guint16 {.importc.}
  ## Длина введённого текста в символах.
```

**Прогресс:**

```nim
proc gtk_entry_set_progress_fraction*(entry: GtkEntry, fraction: gdouble) {.importc.}
  ## Показывает прогресс-бар внутри поля [0.0 – 1.0].

proc gtk_entry_get_progress_fraction*(entry: GtkEntry): gdouble {.importc.}

proc gtk_entry_set_progress_pulse_step*(entry: GtkEntry, fraction: gdouble) {.importc.}

proc gtk_entry_progress_pulse*(entry: GtkEntry) {.importc.}
  ## Анимация "пульса" (для задач с неизвестной длительностью).
```

**Иконки:**

```nim
proc gtk_entry_set_icon_from_icon_name*(
  entry: GtkEntry,
  icon_pos: GtkEntryIconPosition,  # GTK_ENTRY_ICON_PRIMARY или _SECONDARY
  icon_name: cstring               # nil = убрать иконку
) {.importc.}

proc gtk_entry_set_icon_from_paintable*(
  entry: GtkEntry,
  icon_pos: GtkEntryIconPosition,
  paintable: GdkPaintable
) {.importc.}

proc gtk_entry_set_icon_tooltip_text*(
  entry: GtkEntry,
  icon_pos: GtkEntryIconPosition,
  tooltip: cstring
) {.importc.}

proc gtk_entry_set_icon_activatable*(
  entry: GtkEntry,
  icon_pos: GtkEntryIconPosition,
  activatable: gboolean
) {.importc.}
  ## TRUE = иконка кликабельна (испускает "icon-press").

proc gtk_entry_set_icon_sensitive*(
  entry: GtkEntry,
  icon_pos: GtkEntryIconPosition,
  sensitive: gboolean
) {.importc.}
```

```nim
# Хелпер:
proc createEntry*(placeholder = "", maxLength = 0): GtkEntry

# Поле поиска с иконкой:
let entry = gtk_entry_new()
gtk_entry_set_placeholder_text(entry, "Поиск...")
gtk_entry_set_icon_from_icon_name(entry, GTK_ENTRY_ICON_PRIMARY,
                                   "system-search-symbolic")
gtk_entry_set_icon_from_icon_name(entry, GTK_ENTRY_ICON_SECONDARY,
                                   "edit-clear-symbolic")
gtk_entry_set_icon_activatable(entry, GTK_ENTRY_ICON_SECONDARY, TRUE)

# Очистка по клику на иконку:
proc onIconPress(e: GtkEntry, pos: GtkEntryIconPosition,
                 data: gpointer) {.cdecl.} =
  if pos == GTK_ENTRY_ICON_SECONDARY:
    gtk_editable_set_text(cast[pointer](e), "")

discard g_signal_connect(entry, "icon-press",
                          cast[GCallback](onIconPress), nil)
```

**Сигналы:** `"changed"`, `"activate"`, `"icon-press"`, `"icon-release"`

### 10.2 GtkPasswordEntry

```nim
proc gtk_password_entry_new*(): GtkPasswordEntry {.importc.}

proc gtk_password_entry_set_show_peek_icon*(
  entry: GtkPasswordEntry,
  showPeekIcon: gboolean
) {.importc.}
  ## TRUE = показывать кнопку "👁 показать пароль".

proc gtk_password_entry_get_show_peek_icon*(
  entry: GtkPasswordEntry
): gboolean {.importc.}
```

```nim
# Хелпер:
proc createPasswordEntry*(placeholder = ""): GtkPasswordEntry
```

### 10.3 GtkSearchEntry

```nim
proc gtk_search_entry_new*(): GtkSearchEntry {.importc.}

proc gtk_search_entry_set_placeholder_text*(
  entry: GtkSearchEntry,
  text: cstring
) {.importc.}

proc gtk_search_entry_get_placeholder_text*(
  entry: GtkSearchEntry
): cstring {.importc.}

proc gtk_search_entry_set_search_delay*(
  entry: GtkSearchEntry,
  delay: guint  # Миллисекунды. 0 = немедленно.
) {.importc.}
  ## Задержка перед эмиссией "search-changed".
  ## Позволяет не запускать поиск после каждого нажатия клавиши.

proc gtk_search_entry_get_search_delay*(entry: GtkSearchEntry): guint {.importc.}

proc gtk_search_entry_set_key_capture_widget*(
  entry: GtkSearchEntry,
  widget: GtkWidget
) {.importc.}
  ## Виджет, нажатия клавиш которого перенаправляются в поле поиска.
  ## Позволяет начать поиск без явного клика на поле.
```

**Сигналы:** `"search-changed"`, `"search-started"`, `"stop-search"`, `"next-match"`, `"previous-match"`

### 10.4 GtkEditable — интерфейс редактируемого текста

Реализуется всеми полями ввода (`GtkEntry`, `GtkSearchEntry`, `GtkSpinButton` и др.):

```nim
proc gtk_editable_get_text*(editable: pointer): cstring {.importc.}
proc gtk_editable_set_text*(editable: pointer, text: cstring) {.importc.}

proc gtk_editable_get_chars*(
  editable: pointer,
  startPos: gint,
  endPos: gint      # -1 = до конца
): cstring {.importc.}

proc gtk_editable_insert_text*(
  editable: pointer,
  text: cstring,
  length: gint,     # Число байт. -1 = авто.
  position: ptr gint  # Позиция вставки (изменяется после вставки)
) {.importc.}

proc gtk_editable_delete_text*(
  editable: pointer,
  startPos: gint,
  endPos: gint
) {.importc.}

proc gtk_editable_select_region*(
  editable: pointer,
  startPos: gint,
  endPos: gint    # -1 = до конца
) {.importc.}

proc gtk_editable_get_selection_bounds*(
  editable: pointer,
  startPos: ptr gint,
  endPos: ptr gint
): gboolean {.importc.}
  ## Возвращает TRUE если есть выделение.

proc gtk_editable_set_position*(editable: pointer, position: gint) {.importc.}
proc gtk_editable_get_position*(editable: pointer): gint {.importc.}

proc gtk_editable_set_editable*(editable: pointer, isEditable: gboolean) {.importc.}
proc gtk_editable_get_editable*(editable: pointer): gboolean {.importc.}

proc gtk_editable_set_enable_undo*(editable: pointer, enableUndo: gboolean) {.importc.}
proc gtk_editable_get_enable_undo*(editable: pointer): gboolean {.importc.}

proc gtk_editable_get_alignment*(editable: pointer): gfloat {.importc.}
proc gtk_editable_set_alignment*(editable: pointer, xalign: gfloat) {.importc.}

proc gtk_editable_get_max_width_chars*(editable: pointer): gint {.importc.}
proc gtk_editable_set_max_width_chars*(editable: pointer, nChars: gint) {.importc.}

proc gtk_editable_get_width_chars*(editable: pointer): gint {.importc.}
proc gtk_editable_set_width_chars*(editable: pointer, nChars: gint) {.importc.}
```

---

## 11. GtkTextView и GtkTextBuffer

Многострочный редактор текста. Разделение модель/представление: данные в `GtkTextBuffer`, отображение в `GtkTextView`.

### 11.1 GtkTextView — создание

```nim
proc gtk_text_view_new*(): GtkTextView {.importc.}
  ## Создаёт TextView с новым пустым буфером.

proc gtk_text_view_new_with_buffer*(buffer: GtkTextBuffer): GtkTextView {.importc.}
  ## Создаёт TextView с существующим буфером.
  ## Один буфер может обслуживать несколько TextView (split-view).
```

### 11.2 GtkTextView — буфер и содержимое

```nim
proc gtk_text_view_get_buffer*(textView: GtkTextView): GtkTextBuffer {.importc.}
proc gtk_text_view_set_buffer*(textView: GtkTextView, buffer: GtkTextBuffer) {.importc.}
```

### 11.3 GtkTextView — настройки редактирования

```nim
proc gtk_text_view_set_editable*(textView: GtkTextView, setting: gboolean) {.importc.}
proc gtk_text_view_get_editable*(textView: GtkTextView): gboolean {.importc.}

proc gtk_text_view_set_wrap_mode*(
  textView: GtkTextView,
  wrap_mode: PangoWrapMode
) {.importc.}
proc gtk_text_view_get_wrap_mode*(textView: GtkTextView): PangoWrapMode {.importc.}

proc gtk_text_view_set_cursor_visible*(
  textView: GtkTextView,
  setting: gboolean
) {.importc.}
proc gtk_text_view_get_cursor_visible*(textView: GtkTextView): gboolean {.importc.}

proc gtk_text_view_set_monospace*(textView: GtkTextView, monospace: gboolean) {.importc.}
  ## TRUE = использовать моноширинный шрифт.

proc gtk_text_view_get_monospace*(textView: GtkTextView): gboolean {.importc.}

proc gtk_text_view_set_overwrite*(textView: GtkTextView, overwrite: gboolean) {.importc.}
  ## TRUE = режим перезаписи (Insert).

proc gtk_text_view_set_accepts_tab*(textView: GtkTextView, acceptsTab: gboolean) {.importc.}
  ## TRUE = Tab вставляет символ табуляции (не переключает фокус).
```

### 11.4 GtkTextView — отступы и форматирование

```nim
proc gtk_text_view_set_left_margin*(textView: GtkTextView, leftMargin: gint) {.importc.}
proc gtk_text_view_get_left_margin*(textView: GtkTextView): gint {.importc.}

proc gtk_text_view_set_right_margin*(textView: GtkTextView, rightMargin: gint) {.importc.}
proc gtk_text_view_get_right_margin*(textView: GtkTextView): gint {.importc.}

proc gtk_text_view_set_top_margin*(textView: GtkTextView, topMargin: gint) {.importc.}
proc gtk_text_view_get_top_margin*(textView: GtkTextView): gint {.importc.}

proc gtk_text_view_set_bottom_margin*(textView: GtkTextView, bottomMargin: gint) {.importc.}
proc gtk_text_view_get_bottom_margin*(textView: GtkTextView): gint {.importc.}

proc gtk_text_view_set_indent*(textView: GtkTextView, indent: gint) {.importc.}
  ## Отступ первой строки абзаца. Отрицательное = выступающий абзац.

proc gtk_text_view_set_pixels_above_lines*(textView: GtkTextView, pixelsAboveLines: gint) {.importc.}
proc gtk_text_view_set_pixels_below_lines*(textView: GtkTextView, pixelsBelowLines: gint) {.importc.}
proc gtk_text_view_set_pixels_inside_wrap*(textView: GtkTextView, pixelsInsideWrap: gint) {.importc.}

proc gtk_text_view_set_justification*(textView: GtkTextView, justification: GtkJustification) {.importc.}
proc gtk_text_view_get_justification*(textView: GtkTextView): GtkJustification {.importc.}
```

### 11.5 GtkTextView — прокрутка

```nim
proc gtk_text_view_scroll_to_mark*(
  textView: GtkTextView,
  mark: GtkTextMark,
  within_margin: gdouble,  # Запас от края [0.0–0.5]
  use_align: gboolean,     # TRUE = использовать xalign/yalign
  xalign: gdouble,         # Горизонтальное выравнивание [0.0–1.0]
  yalign: gdouble          # Вертикальное выравнивание [0.0–1.0]
) {.importc.}

proc gtk_text_view_scroll_mark_onscreen*(
  textView: GtkTextView,
  mark: GtkTextMark
) {.importc.}
  ## Прокрутить так, чтобы mark был виден.

proc gtk_text_view_scroll_to_iter*(
  textView: GtkTextView,
  iter: ptr GtkTextIter,
  within_margin: gdouble,
  use_align: gboolean,
  xalign, yalign: gdouble
): gboolean {.importc.}

proc gtk_text_view_place_cursor_onscreen*(textView: GtkTextView): gboolean {.importc.}
  ## Прокручивает к курсору. Возвращает TRUE если прокрутка произошла.
```

### 11.6 GtkTextView — контекст RTL/LTR

```nim
proc gtk_text_view_get_ltr_context*(textView: GtkTextView): PangoContext {.importc.}
proc gtk_text_view_get_rtl_context*(textView: GtkTextView): PangoContext {.importc.}
```

### 11.7 GtkTextBuffer — создание

```nim
proc gtk_text_buffer_new*(table: GtkTextTagTable): GtkTextBuffer {.importc.}
  ## table = nil → автоматически создаётся пустая таблица тегов.
```

### 11.8 GtkTextBuffer — текст

```nim
proc gtk_text_buffer_set_text*(
  buffer: GtkTextBuffer,
  text: cstring,
  len: gint  # -1 для строк с нулевым завершением
) {.importc.}

proc gtk_text_buffer_get_text*(
  buffer: GtkTextBuffer,
  start: ptr GtkTextIter,
  `end`: ptr GtkTextIter,
  include_hidden_chars: gboolean  # TRUE = включить скрытый текст
): cstring {.importc.}
  ## Результат нужно освободить через g_free().

proc gtk_text_buffer_get_char_count*(buffer: GtkTextBuffer): gint {.importc.}
proc gtk_text_buffer_get_line_count*(buffer: GtkTextBuffer): gint {.importc.}

proc gtk_text_buffer_get_modified*(buffer: GtkTextBuffer): gboolean {.importc.}
  ## TRUE = буфер изменён после последнего gtk_text_buffer_set_modified(FALSE).

proc gtk_text_buffer_set_modified*(buffer: GtkTextBuffer, setting: gboolean) {.importc.}
```

### 11.9 GtkTextBuffer — вставка

```nim
proc gtk_text_buffer_insert*(
  buffer: GtkTextBuffer,
  iter: ptr GtkTextIter,  # Позиция вставки (iter обновляется после вставки)
  text: cstring,
  len: gint               # -1 = авто
) {.importc.}

proc gtk_text_buffer_insert_at_cursor*(
  buffer: GtkTextBuffer,
  text: cstring,
  len: gint
) {.importc.}

proc gtk_text_buffer_insert_with_tags_by_name*(
  buffer: GtkTextBuffer,
  iter: ptr GtkTextIter,
  text: cstring,
  len: gint,
  firstTagName: cstring   # Затем varargs с именами тегов, завершить nil
) {.importc, varargs.}

proc gtk_text_buffer_insert_markup*(
  buffer: GtkTextBuffer,
  iter: ptr GtkTextIter,
  markup: cstring,
  len: gint
) {.importc.}
  ## Вставка текста с Pango markup (форматирование применяется автоматически).

proc gtk_text_buffer_delete*(
  buffer: GtkTextBuffer,
  start: ptr GtkTextIter,
  `end`: ptr GtkTextIter
) {.importc.}
```

### 11.10 GtkTextBuffer — итераторы

```nim
proc gtk_text_buffer_get_start_iter*(
  buffer: GtkTextBuffer,
  iter: ptr GtkTextIter
) {.importc.}

proc gtk_text_buffer_get_end_iter*(
  buffer: GtkTextBuffer,
  iter: ptr GtkTextIter
) {.importc.}

proc gtk_text_buffer_get_bounds*(
  buffer: GtkTextBuffer,
  start: ptr GtkTextIter,
  `end`: ptr GtkTextIter
) {.importc.}
  ## Одновременно получить начало и конец буфера.

proc gtk_text_buffer_get_iter_at_line*(
  buffer: GtkTextBuffer,
  iter: ptr GtkTextIter,
  line_number: gint  # Нумерация с 0
) {.importc.}

proc gtk_text_buffer_get_iter_at_offset*(
  buffer: GtkTextBuffer,
  iter: ptr GtkTextIter,
  char_offset: gint   # Позиция в символах от начала буфера
) {.importc.}

proc gtk_text_buffer_get_iter_at_mark*(
  buffer: GtkTextBuffer,
  iter: ptr GtkTextIter,
  mark: GtkTextMark
) {.importc.}
```

### 11.11 GtkTextBuffer — курсор и выделение

```nim
proc gtk_text_buffer_place_cursor*(
  buffer: GtkTextBuffer,
  where: ptr GtkTextIter
) {.importc.}

proc gtk_text_buffer_get_insert*(buffer: GtkTextBuffer): GtkTextMark {.importc.}
  ## Метка курсора (позиция вставки).

proc gtk_text_buffer_get_selection_bound*(buffer: GtkTextBuffer): GtkTextMark {.importc.}
  ## Метка начала/конца выделения.

proc gtk_text_buffer_get_selection_bounds*(
  buffer: GtkTextBuffer,
  start: ptr GtkTextIter,
  `end`: ptr GtkTextIter
): gboolean {.importc.}
  ## Возвращает TRUE если есть выделение, итераторы устанавливаются.

proc gtk_text_buffer_select_range*(
  buffer: GtkTextBuffer,
  ins: ptr GtkTextIter,     # Позиция курсора
  bound: ptr GtkTextIter    # Конец выделения
) {.importc.}

proc gtk_text_buffer_delete_selection*(
  buffer: GtkTextBuffer,
  interactive: gboolean,
  default_editable: gboolean
): gboolean {.importc.}

proc gtk_text_buffer_copy_clipboard*(
  buffer: GtkTextBuffer,
  clipboard: GdkClipboard
) {.importc.}

proc gtk_text_buffer_cut_clipboard*(
  buffer: GtkTextBuffer,
  clipboard: GdkClipboard,
  default_editable: gboolean
) {.importc.}

proc gtk_text_buffer_paste_clipboard*(
  buffer: GtkTextBuffer,
  clipboard: GdkClipboard,
  override_location: ptr GtkTextIter,  # nil = вставить в позицию курсора
  default_editable: gboolean
) {.importc.}
```

### 11.12 GtkTextBuffer — Undo/Redo

```nim
proc gtk_text_buffer_set_enable_undo*(
  buffer: GtkTextBuffer,
  enable_undo: gboolean
) {.importc.}

proc gtk_text_buffer_get_enable_undo*(buffer: GtkTextBuffer): gboolean {.importc.}

proc gtk_text_buffer_get_can_undo*(buffer: GtkTextBuffer): gboolean {.importc.}
proc gtk_text_buffer_get_can_redo*(buffer: GtkTextBuffer): gboolean {.importc.}

proc gtk_text_buffer_undo*(buffer: GtkTextBuffer) {.importc.}
proc gtk_text_buffer_redo*(buffer: GtkTextBuffer) {.importc.}

proc gtk_text_buffer_get_max_undo_levels*(buffer: GtkTextBuffer): gint {.importc.}
proc gtk_text_buffer_set_max_undo_levels*(
  buffer: GtkTextBuffer,
  max_undo_levels: gint  # -1 = без ограничения
) {.importc.}

proc gtk_text_buffer_begin_irreversible_action*(buffer: GtkTextBuffer) {.importc.}
  ## Начать блок действий, которые не попадут в Undo.
proc gtk_text_buffer_end_irreversible_action*(buffer: GtkTextBuffer) {.importc.}
```

### 11.13 GtkTextBuffer — теги и форматирование

```nim
proc gtk_text_buffer_create_tag*(
  buffer: GtkTextBuffer,
  tagName: cstring,           # nil = анонимный тег
  firstPropertyName: cstring  # Свойства: varargs пары "свойство", значение, nil
): GtkTextTag {.importc, varargs.}
  ## Создать тег с форматированием.
  ## Примеры свойств: "weight" (700=bold), "style" (1=italic),
  ## "foreground" ("red"), "background" ("#ff0000"),
  ## "font" ("Monospace 12"), "underline" (1), "size-points" (14.0)

proc gtk_text_buffer_apply_tag*(
  buffer: GtkTextBuffer,
  tag: GtkTextTag,
  start: ptr GtkTextIter,
  `end`: ptr GtkTextIter
) {.importc.}

proc gtk_text_buffer_apply_tag_by_name*(
  buffer: GtkTextBuffer,
  name: cstring,
  start: ptr GtkTextIter,
  `end`: ptr GtkTextIter
) {.importc.}

proc gtk_text_buffer_remove_tag*(
  buffer: GtkTextBuffer,
  tag: GtkTextTag,
  start: ptr GtkTextIter,
  `end`: ptr GtkTextIter
) {.importc.}

proc gtk_text_buffer_remove_all_tags*(
  buffer: GtkTextBuffer,
  start: ptr GtkTextIter,
  `end`: ptr GtkTextIter
) {.importc.}
```

```nim
# Пример форматирования:
let buf = gtk_text_buffer_new(nil)
discard gtk_text_buffer_create_tag(buf, "bold", "weight", 700, nil)
discard gtk_text_buffer_create_tag(buf, "red-text",
  "foreground", "red", nil)
discard gtk_text_buffer_create_tag(buf, "code",
  "font", "Monospace", "background", "#f0f0f0", nil)

var s, e: GtkTextIter
gtk_text_buffer_get_bounds(buf, addr s, addr e)
gtk_text_buffer_apply_tag_by_name(buf, "bold", addr s, addr e)
```

### 11.14 GtkTextBuffer — метки (Marks)

```nim
proc gtk_text_buffer_create_mark*(
  buffer: GtkTextBuffer,
  mark_name: cstring,      # nil = анонимная метка
  where: ptr GtkTextIter,
  left_gravity: gboolean   # TRUE = при вставке текста рядом метка остаётся слева
): GtkTextMark {.importc.}

proc gtk_text_buffer_delete_mark*(buffer: GtkTextBuffer, mark: GtkTextMark) {.importc.}
proc gtk_text_buffer_delete_mark_by_name*(buffer: GtkTextBuffer, name: cstring) {.importc.}

proc gtk_text_buffer_get_mark*(buffer: GtkTextBuffer, name: cstring): GtkTextMark {.importc.}

proc gtk_text_buffer_move_mark*(
  buffer: GtkTextBuffer,
  mark: GtkTextMark,
  where: ptr GtkTextIter
) {.importc.}
```

---

## 12. Действия (GAction / GSimpleAction)

Действия — команды с именем, опциональным параметром и состоянием. Отделяют логику от UI. Поддерживают горячие клавиши через `gtk_application_set_accels_for_action`.

### 12.1 Создание действий

```nim
proc g_simple_action_new*(
  name: cstring,
  parameterType: GVariantType  # nil = без параметра
): GSimpleAction {.importc.}
  ## Простое действие без состояния.

proc g_simple_action_new_stateful*(
  name: cstring,
  parameterType: GVariantType,
  state: GVariant  # Начальное состояние
): GSimpleAction {.importc.}
  ## Действие с состоянием (булево для checkmark в меню).

proc g_simple_action_set_enabled*(
  simple: GSimpleAction,
  enabled: gboolean
) {.importc.}
  ## FALSE = действие недоступно (пункт меню затенён).

proc g_simple_action_set_state*(
  simple: GSimpleAction,
  value: GVariant
) {.importc.}
  ## Установить состояние напрямую (без emit change-state).

proc g_simple_action_set_state_hint*(
  simple: GSimpleAction,
  stateHint: GVariant
) {.importc.}
```

### 12.2 Карта действий (GActionMap)

```nim
proc g_action_map_add_action*(
  actionMap: GActionMap,
  action: GAction
) {.importc.}

proc g_action_map_add_action_entries*(
  action_map: GActionMap,
  entries: ptr GActionEntry,
  n_entries: gint,
  user_data: gpointer
) {.importc.}
  ## Массовое добавление действий из статического массива GActionEntry.

proc g_action_map_remove_action*(
  actionMap: GActionMap,
  actionName: cstring
) {.importc.}

proc g_action_map_lookup_action*(
  actionMap: GActionMap,
  actionName: cstring
): GAction {.importc.}
```

### 12.3 Интерфейс GAction

```nim
proc g_action_get_name*(action: GAction): cstring {.importc.}
proc g_action_get_enabled*(action: GAction): gboolean {.importc.}
proc g_action_get_state*(action: GAction): GVariant {.importc.}
proc g_action_get_state_type*(action: GAction): GVariantType {.importc.}
proc g_action_get_parameter_type*(action: GAction): GVariantType {.importc.}

proc g_action_activate*(action: GAction, parameter: GVariant) {.importc.}
proc g_action_change_state*(action: GAction, value: GVariant) {.importc.}
proc g_action_name_is_valid*(action_name: cstring): gboolean {.importc.}
```

### 12.4 GPropertyAction

```nim
proc g_property_action_new*(
  name: cstring,
  obj: gpointer,        # GObject с нужным свойством
  property_name: cstring
): GPropertyAction {.importc.}
  ## Действие, которое автоматически привязано к свойству GObject.
  ## Смена состояния = смена свойства объекта.
```

### 12.5 GActionGroup

```nim
proc g_action_group_list_actions*(action_group: GActionGroup): ptr cstring {.importc.}
proc g_action_group_has_action*(action_group: GActionGroup, action_name: cstring): gboolean {.importc.}
proc g_action_group_get_action_enabled*(action_group: GActionGroup, action_name: cstring): gboolean {.importc.}
proc g_action_group_get_action_state*(action_group: GActionGroup, action_name: cstring): GVariant {.importc.}
proc g_action_group_activate_action*(action_group: GActionGroup, action_name: cstring, parameter: GVariant) {.importc.}
proc g_action_group_change_action_state*(action_group: GActionGroup, action_name: cstring, value: GVariant) {.importc.}
```

```nim
# Пример — полная настройка действий приложения:
proc onQuit(action: GSimpleAction, param: GVariant,
            data: gpointer) {.cdecl.} =
  g_application_quit(cast[GApplication](data))

proc onToggleDark(action: GSimpleAction, param: GVariant,
                  data: gpointer) {.cdecl.} =
  let state = g_action_get_state(cast[GAction](action))
  # Инвертировать булево состояние:
  # g_simple_action_set_state(action, g_variant_new_boolean(...))

# Добавление через GActionEntry:
var entries = [
  GActionEntry(name: "quit",
               activate: onQuit),
  GActionEntry(name: "about",
               activate: onAbout),
]
g_action_map_add_action_entries(cast[GActionMap](app),
                                addr entries[0], 2, app)

# Горячие клавиши:
var quitAccels = ["<Ctrl>Q", nil.cstring]
gtk_application_set_accels_for_action(app, "app.quit",
                                       addr quitAccels[0])
```

---

## 13. Меню (GMenu / GMenuItem)

### 13.1 Создание и наполнение GMenu

```nim
proc g_menu_new*(): GMenu {.importc.}

proc g_menu_append*(
  menu: GMenu,
  label: cstring,
  detailedAction: cstring  # напр. "app.quit", "win.open", "win.zoom(2)"
) {.importc.}

proc g_menu_prepend*(
  menu: GMenu,
  label: cstring,
  detailedAction: cstring
) {.importc.}

proc g_menu_insert*(
  menu: GMenu,
  position: gint,
  label: cstring,
  detailedAction: cstring
) {.importc.}

proc g_menu_remove*(menu: GMenu, position: gint) {.importc.}
proc g_menu_remove_all*(menu: GMenu) {.importc.}
```

### 13.2 Секции и подменю

```nim
proc g_menu_append_section*(
  menu: GMenu,
  label: cstring,         # nil = без заголовка секции
  section: GMenuModel
) {.importc.}

proc g_menu_prepend_section*(
  menu: GMenu,
  label: cstring,
  section: GMenuModel
) {.importc.}

proc g_menu_insert_section*(
  menu: GMenu,
  position: gint,
  label: cstring,
  section: GMenuModel
) {.importc.}

proc g_menu_append_submenu*(
  menu: GMenu,
  label: cstring,
  submenu: GMenuModel
) {.importc.}

proc g_menu_prepend_submenu*(menu: GMenu, label: cstring, submenu: GMenuModel) {.importc.}
proc g_menu_insert_submenu*(menu: GMenu, position: gint, label: cstring, submenu: GMenuModel) {.importc.}
```

### 13.3 GMenuItem

```nim
proc g_menu_item_new*(
  label: cstring,
  detailedAction: cstring  # nil = без действия
): GMenuItem {.importc.}

proc g_menu_item_new_section*(
  label: cstring,
  section: GMenuModel
): GMenuItem {.importc.}

proc g_menu_item_new_submenu*(
  label: cstring,
  submenu: GMenuModel
): GMenuItem {.importc.}

proc g_menu_item_set_label*(menuItem: GMenuItem, label: cstring) {.importc.}
proc g_menu_item_set_detailed_action*(menuItem: GMenuItem, detailedAction: cstring) {.importc.}
proc g_menu_item_set_action_and_target_value*(menuItem: GMenuItem, action: cstring, targetValue: GVariant) {.importc.}
proc g_menu_item_set_icon*(menuItem: GMenuItem, icon: pointer) {.importc.}
  ## icon: GIcon* (например, g_themed_icon_new("document-open"))

proc g_menu_item_set_attribute_value*(menuItem: GMenuItem, attribute: cstring, value: GVariant) {.importc.}

proc g_menu_append_item*(menu: GMenu, item: GMenuItem) {.importc.}
proc g_menu_prepend_item*(menu: GMenu, item: GMenuItem) {.importc.}
proc g_menu_insert_item*(menu: GMenu, position: gint, item: GMenuItem) {.importc.}
```

### 13.4 GMenuModel

```nim
proc g_menu_model_get_n_items*(model: GMenuModel): gint {.importc.}
proc g_menu_model_is_mutable*(model: GMenuModel): gboolean {.importc.}
proc g_menu_model_get_item_attribute_value*(
  model: GMenuModel,
  itemIndex: gint,
  attribute: cstring,
  expectedType: GVariantType
): GVariant {.importc.}
proc g_menu_model_get_item_link*(
  model: GMenuModel,
  itemIndex: gint,
  link: cstring  # G_MENU_LINK_SECTION или G_MENU_LINK_SUBMENU
): GMenuModel {.importc.}
```

### 13.5 PopoverMenu

```nim
proc gtk_popover_menu_new_from_model*(model: GMenuModel): GtkPopoverMenu {.importc.}

proc gtk_popover_menu_set_menu_model*(
  popover: GtkPopoverMenu,
  model: GMenuModel
) {.importc.}

proc gtk_popover_menu_get_menu_model*(popover: GtkPopoverMenu): GMenuModel {.importc.}
```

```nim
# Пример — полное меню приложения:
proc buildMenuBar(app: GtkApplication) =
  # Меню Файл:
  let fileSection1 = g_menu_new()
  g_menu_append(fileSection1, "Открыть…", "app.open")
  g_menu_append(fileSection1, "Сохранить", "app.save")
  g_menu_append(fileSection1, "Сохранить как…", "app.save-as")

  let fileSection2 = g_menu_new()
  g_menu_append(fileSection2, "Выход", "app.quit")

  let fileMenu = g_menu_new()
  g_menu_append_section(fileMenu, nil, cast[GMenuModel](fileSection1))
  g_menu_append_section(fileMenu, nil, cast[GMenuModel](fileSection2))

  # Меню Вид:
  let viewMenu = g_menu_new()
  g_menu_append(viewMenu, "Полный экран", "win.fullscreen")
  g_menu_append(viewMenu, "Тёмная тема", "app.dark-theme")

  # Строка меню:
  let menuBar = g_menu_new()
  g_menu_append_submenu(menuBar, "Файл", cast[GMenuModel](fileMenu))
  g_menu_append_submenu(menuBar, "Вид", cast[GMenuModel](viewMenu))

  gtk_application_set_menubar(app, cast[GMenuModel](menuBar))
```

---

## 14. GObject — управление объектами

### 14.1 Счётчик ссылок

```nim
proc g_object_ref*(obj: gpointer): gpointer {.importc.}
  ## Увеличить счётчик ссылок. Возвращает тот же объект.

proc g_object_unref*(obj: gpointer) {.importc.}
  ## Уменьшить счётчик. При 0 объект уничтожается.

proc g_object_ref_sink*(obj: gpointer): gpointer {.importc.}
  ## Для "плавающих" ссылок (floating ref) — присвоение.
  ## Виджеты GTK имеют floating ref при создании.
```

```nim
# Вспомогательные функции обёртки:
proc safeUnref*[T](obj: var T) =
  ## Безопасный unref: уменьшает счётчик и обнуляет переменную.
  if obj != nil:
    g_object_unref(obj)
    obj = nil

proc safeRef*[T](obj: T): T =
  ## Увеличивает счётчик ссылок, nil-безопасно.
  if obj != nil:
    result = cast[T](g_object_ref(obj))
  else:
    result = nil
```

### 14.2 Свойства GObject

```nim
proc g_object_get_property*(
  obj: GObject,
  propertyName: cstring,
  value: ptr GValue
) {.importc.}

proc g_object_set_property*(
  obj: GObject,
  propertyName: cstring,
  value: ptr GValue
) {.importc.}

proc g_object_get*(obj: GObject, firstPropertyName: cstring) {.importc, varargs.}
  ## Получить несколько свойств: g_object_get(obj, "prop", addr val, nil)

proc g_object_set*(obj: GObject, firstPropertyName: cstring) {.importc, varargs.}
  ## Установить несколько свойств: g_object_set(obj, "prop", value, nil)
```

### 14.3 Привязка свойств

```nim
proc g_object_bind_property*(
  source: GObject,
  source_property: cstring,
  target: GObject,
  target_property: cstring,
  flags: GBindingFlags
): pointer {.importc.}
  ## Односторонняя или двусторонняя привязка свойств.
  ## Флаги: G_BINDING_DEFAULT, BIDIRECTIONAL, SYNC_CREATE, INVERT_BOOLEAN.
```

```nim
# Пример: синхронизация активности Switch и чувствительности кнопки:
discard g_object_bind_property(
  cast[GObject](sw), "active",
  cast[GObject](btn), "sensitive",
  G_BINDING_SYNC_CREATE)
```

### 14.4 Пользовательские данные объекта

```nim
proc g_object_set_data*(
  obj: GObject,
  key: cstring,
  data: gpointer
) {.importc.}
  ## Присоединить произвольные данные к объекту по ключу.

proc g_object_get_data*(
  obj: GObject,
  key: cstring
): gpointer {.importc.}
  ## Получить данные по ключу.

proc g_object_set_data_full*(
  obj: GObject,
  key: cstring,
  data: gpointer,
  destroy: GDestroyNotify
) {.importc.}
  ## С функцией уничтожения данных при удалении объекта.
```

```nim
# Хранение указателя на структуру с данными в объекте:
type MyWidgetData = object
  counter: int
  name: string

let d = cast[ptr MyWidgetData](alloc0(sizeof(MyWidgetData)))
d.name = "моя кнопка"

proc freeData(p: gpointer) {.cdecl.} = dealloc(p)

g_object_set_data_full(cast[GObject](btn), "my-data",
                        d, cast[GDestroyNotify](freeData))

# Позже получить:
let data = cast[ptr MyWidgetData](
  g_object_get_data(cast[GObject](btn), "my-data"))
echo data.name
```

### 14.5 Тип объекта

```nim
proc g_type_from_name*(name: cstring): GType {.importc.}
  ## Получить GType по имени ("GtkButton", "GtkWindow", …).

proc g_type_name*(type_id: GType): cstring {.importc.}
  ## Имя типа по его ID.

proc g_type_check_instance_is_a*(
  instance: gpointer,
  iface_type: GType
): gboolean {.importc.}
  ## Проверить тип объекта (аналог GTK_IS_BUTTON).
```

---

## 15. GLib — таймеры и idle

### 15.1 Одноразовые и повторяющиеся таймеры

```nim
proc g_timeout_add*(
  interval: guint,          # Интервал в миллисекундах
  function: GSourceFunc,    # proc(data: gpointer): gboolean {.cdecl.}
  data: gpointer
): guint {.importc.}
  ## Запускает function каждые interval мс.
  ## Callback возвращает: TRUE = продолжать, FALSE = удалить таймер.

proc g_timeout_add_once*(
  interval: guint,
  function: pointer,  # proc(data: gpointer) {.cdecl.}
  data: gpointer
): guint {.importc.}
  ## Запускает function один раз через interval мс. GTK 4.2+.

proc g_source_remove*(tag: guint): gboolean {.importc.}
  ## Отменить таймер или idle-источник по его ID.
```

### 15.2 Idle (в главном цикле)

```nim
proc g_idle_add*(
  function: GSourceFunc,
  data: gpointer
): guint {.importc.}
  ## Запускает function при каждом "простое" главного цикла.
  ## Использовать для фоновой работы без блокировки UI.

proc g_idle_add_once*(
  function: pointer,
  data: gpointer
): guint {.importc.}
  ## Запускает function один раз в idle. GTK 4.2+.
```

```nim
# Таймер каждую секунду:
var tickCount = 0

proc onTick(data: gpointer): gboolean {.cdecl.} =
  inc tickCount
  let lbl = cast[GtkLabel](data)
  gtk_label_set_text(lbl, ($tickCount & " сек").cstring)
  return TRUE  # продолжать

let timerId = g_timeout_add(1000, onTick, cast[gpointer](label))

# Остановить таймер:
discard g_source_remove(timerId)

# Однократный таймер через 3 секунды:
proc onDelay(data: gpointer): gboolean {.cdecl.} =
  echo "3 секунды прошло"
  return FALSE  # удалить таймер

discard g_timeout_add(3000, onDelay, nil)

# Idle для длинной операции:
var progress = 0

proc doWorkStep(data: gpointer): gboolean {.cdecl.} =
  inc progress
  # Обновить UI...
  if progress >= 100:
    echo "Готово!"
    return FALSE  # удалить idle
  return TRUE

discard g_idle_add(doWorkStep, nil)
```

### 15.3 GLib строки и память

```nim
proc g_free*(mem: gpointer) {.importc.}
  ## Освободить память, выделенную GLib (g_malloc, g_strdup и т.д.).

proc g_strdup*(str: cstring): cstring {.importc.}
  ## Дублировать C-строку (результат освобождать через g_free).

proc g_strdup_printf*(format: cstring): cstring {.importc, varargs.}
  ## printf в GLib-строку (освобождать через g_free).

proc g_strsplit*(str, delimiter: cstring, max_tokens: gint): ptr cstring {.importc.}
  ## Разбить строку по разделителю.

proc g_strjoinv*(separator: cstring, strArray: ptr cstring): cstring {.importc.}
  ## Объединить массив строк.

proc g_strfreev*(strArray: ptr cstring) {.importc.}
  ## Освободить NULL-terminated массив строк (результат g_strsplit).
```

---

## 16. Практические примеры

### 16.1 Приложение с заголовочной панелью и меню

```nim
import libGTK4

proc buildUI(app: GtkApplication, data: gpointer) {.cdecl.} =
  let win = gtk_application_window_new(app)
  gtk_window_set_default_size(cast[GtkWindow](win), 600, 400)

  # HeaderBar вместо стандартного заголовка:
  let header = gtk_header_bar_new()
  gtk_window_set_titlebar(cast[GtkWindow](win),
                           cast[GtkWidget](header))

  # Кнопки в заголовке:
  let openBtn = gtk_button_new_from_icon_name("document-open-symbolic")
  gtk_widget_set_tooltip_text(cast[GtkWidget](openBtn), "Открыть файл")
  gtk_header_bar_pack_start(header, cast[GtkWidget](openBtn))

  let menuBtn = gtk_menu_button_new()
  gtk_menu_button_set_icon_name(menuBtn, "open-menu-symbolic")
  gtk_header_bar_pack_end(header, cast[GtkWidget](menuBtn))

  # Главный контент:
  let vbox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0)
  gtk_window_set_child(cast[GtkWindow](win), cast[GtkWidget](vbox))

  let sw = gtk_scrolled_window_new()
  gtk_widget_set_vexpand(cast[GtkWidget](sw), TRUE)
  gtk_box_append(vbox, cast[GtkWidget](sw))

  let tv = gtk_text_view_new()
  gtk_text_view_set_monospace(tv, TRUE)
  gtk_text_view_set_left_margin(tv, 12)
  gtk_text_view_set_right_margin(tv, 12)
  gtk_scrolled_window_set_child(cast[pointer](sw), cast[GtkWidget](tv))

  gtk_window_present(cast[GtkWindow](win))

let app = gtk_application_new("com.example.editor",
                               G_APPLICATION_DEFAULT_FLAGS.gint)
discard g_signal_connect(app, "activate", cast[GCallback](buildUI), nil)
quit(g_application_run(cast[GApplication](app), 0, nil))
```

### 16.2 Форма с валидацией

```nim
proc buildForm(app: GtkApplication, data: gpointer) {.cdecl.} =
  let win = gtk_application_window_new(app)
  gtk_window_set_title(cast[GtkWindow](win), "Регистрация")
  gtk_window_set_default_size(cast[GtkWindow](win), 360, 280)

  let grid = gtk_grid_new()
  gtk_grid_set_row_spacing(grid, 8)
  gtk_grid_set_column_spacing(grid, 12)
  setMargins(cast[GtkWidget](grid), 24)
  gtk_window_set_child(cast[GtkWindow](win), cast[GtkWidget](grid))

  # Метки и поля:
  let nameLbl = gtk_label_new("Имя:")
  gtk_widget_set_halign(cast[GtkWidget](nameLbl), GTK_ALIGN_END)
  let nameEntry = gtk_entry_new()
  gtk_entry_set_placeholder_text(nameEntry, "Введите имя")
  gtk_widget_set_hexpand(cast[GtkWidget](nameEntry), TRUE)

  let emailLbl = gtk_label_new("Email:")
  gtk_widget_set_halign(cast[GtkWidget](emailLbl), GTK_ALIGN_END)
  let emailEntry = gtk_entry_new()
  gtk_entry_set_input_purpose(emailEntry, GTK_INPUT_PURPOSE_EMAIL)
  gtk_entry_set_placeholder_text(emailEntry, "user@example.com")

  let passLbl = gtk_label_new("Пароль:")
  gtk_widget_set_halign(cast[GtkWidget](passLbl), GTK_ALIGN_END)
  let passEntry = gtk_password_entry_new()
  gtk_password_entry_set_show_peek_icon(passEntry, TRUE)

  # Кнопки:
  let btnBox = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 8)
  gtk_widget_set_halign(cast[GtkWidget](btnBox), GTK_ALIGN_END)
  let cancelBtn = gtk_button_new_with_label("Отмена")
  let submitBtn = gtk_button_new_with_label("Зарегистрироваться")
  gtk_widget_add_css_class(cast[GtkWidget](submitBtn), "suggested-action")
  gtk_box_append(btnBox, cast[GtkWidget](cancelBtn))
  gtk_box_append(btnBox, cast[GtkWidget](submitBtn))

  # Размещение в Grid:
  gtk_grid_attach(grid, cast[GtkWidget](nameLbl),   0, 0, 1, 1)
  gtk_grid_attach(grid, cast[GtkWidget](nameEntry), 1, 0, 1, 1)
  gtk_grid_attach(grid, cast[GtkWidget](emailLbl),  0, 1, 1, 1)
  gtk_grid_attach(grid, cast[GtkWidget](emailEntry),1, 1, 1, 1)
  gtk_grid_attach(grid, cast[GtkWidget](passLbl),   0, 2, 1, 1)
  gtk_grid_attach(grid, cast[GtkWidget](passEntry), 1, 2, 1, 1)
  gtk_grid_attach(grid, cast[GtkWidget](btnBox),    0, 3, 2, 1)

  gtk_window_present(cast[GtkWindow](win))
```

### 16.3 Текстовый редактор с Undo/Redo

```nim
proc buildEditor(app: GtkApplication, data: gpointer) {.cdecl.} =
  let win = gtk_application_window_new(app)
  gtk_window_set_default_size(cast[GtkWindow](win), 800, 600)

  # Буфер с Undo:
  let buf = gtk_text_buffer_new(nil)
  gtk_text_buffer_set_enable_undo(buf, TRUE)

  let tv = gtk_text_view_new_with_buffer(buf)
  gtk_text_view_set_wrap_mode(tv, PANGO_WRAP_WORD_CHAR)
  gtk_text_view_set_monospace(tv, TRUE)
  gtk_text_view_set_left_margin(tv, 8)
  gtk_text_view_set_top_margin(tv, 8)
  gtk_text_view_set_accepts_tab(tv, TRUE)

  # Прокрутка:
  let sw = gtk_scrolled_window_new()
  gtk_widget_set_hexpand(cast[GtkWidget](sw), TRUE)
  gtk_widget_set_vexpand(cast[GtkWidget](sw), TRUE)
  gtk_scrolled_window_set_child(cast[pointer](sw), cast[GtkWidget](tv))

  gtk_window_set_child(cast[GtkWindow](win), cast[GtkWidget](sw))

  # Действия Undo/Redo:
  proc onUndo(action: GSimpleAction, p: GVariant,
              d: gpointer) {.cdecl.} =
    if gtk_text_buffer_get_can_undo(cast[GtkTextBuffer](d)):
      gtk_text_buffer_undo(cast[GtkTextBuffer](d))

  proc onRedo(action: GSimpleAction, p: GVariant,
              d: gpointer) {.cdecl.} =
    if gtk_text_buffer_get_can_redo(cast[GtkTextBuffer](d)):
      gtk_text_buffer_redo(cast[GtkTextBuffer](d))

  let undoAction = g_simple_action_new("undo", nil)
  let redoAction = g_simple_action_new("redo", nil)
  discard g_signal_connect(undoAction, "activate",
                            cast[GCallback](onUndo), buf)
  discard g_signal_connect(redoAction, "activate",
                            cast[GCallback](onRedo), buf)
  g_action_map_add_action(cast[GActionMap](win),
                           cast[GAction](undoAction))
  g_action_map_add_action(cast[GActionMap](win),
                           cast[GAction](redoAction))

  var undoAccels = ["<Ctrl>Z", nil.cstring]
  var redoAccels = ["<Ctrl><Shift>Z", nil.cstring]
  gtk_application_set_accels_for_action(app, "win.undo",
                                         addr undoAccels[0])
  gtk_application_set_accels_for_action(app, "win.redo",
                                         addr redoAccels[0])

  gtk_window_present(cast[GtkWindow](win))
```

### 16.4 Перехват закрытия окна

```nim
type AppState = object
  modified: bool
  win: GtkWindow

var state = AppState(modified: false)

proc onCloseRequest(win: GtkWindow, data: gpointer): gboolean {.cdecl.} =
  let s = cast[ptr AppState](data)
  if not s.modified:
    return FALSE  # Закрыть

  # Показать диалог подтверждения (упрощённо):
  echo "Есть несохранённые изменения!"
  # В реальном коде — GtkAlertDialog или gtk_message_dialog_new
  return TRUE  # Пока отменяем закрытие

discard g_signal_connect(win, "close-request",
                          cast[GCallback](onCloseRequest), addr state)
```

### 16.5 Сигнал notify::active

```nim
# Реакция на изменение свойства через notify:
proc onActiveChanged(obj: GObject, pspec: pointer,
                     data: gpointer) {.cdecl.} =
  let sw = cast[GtkSwitch](obj)
  echo "Переключатель: ", if gtk_switch_get_active(sw): "ON" else: "OFF"

discard g_signal_connect(mySwitch, "notify::active",
                          cast[GCallback](onActiveChanged), nil)
```

---

*Следующая часть: [Часть 3 — Контейнеры, диалоги, CSS, изображения, специализированные виджеты](gtk4_nim_docs_part3.md)*
