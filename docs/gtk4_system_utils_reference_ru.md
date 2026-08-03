# GTK4 (system utilities, compact reference): WindowGroup / NativeDialog / AlertDialog / Builder / Settings / SizeGroup / KeyVal / GIO File / Misc / Tooltip

> **Импорт:** `import libGTK4`
> Часть 19 серии справочников по обёртке. **Формат этой и последующих частей — компактный**: сигнатура + одна строка описания, без развёрнутой прозы, рецептов и итоговой сводки — раздел большого объёма, где такой уровень детализации был бы избыточен для функций, каждая из которых уже интуитивно понятна опытному разработчику после предыдущих 18 частей. Группы `get`/`set` объединены в одну строку, где это очевидно (симметричные геттер/сеттер).

---

## GtkWindowGroup

Группирует несколько окон, чтобы модальность (`gtk_window_set_modal`) действовала только в пределах группы, а не блокировала вообще все окна приложения.

```nim
proc gtk_window_group_new*(): GtkWindowGroup
proc gtk_window_group_add_window*(windowGroup: GtkWindowGroup, window: GtkWindow)
proc gtk_window_group_remove_window*(windowGroup: GtkWindowGroup, window: GtkWindow)
proc gtk_window_group_list_windows*(windowGroup: GtkWindowGroup): pointer  # GList[GtkWindow]
```

- `new` — создать группу.
- `add_window`/`remove_window` — включить/исключить окно из группы.
- `list_windows` — список окон группы (`GList`, см. справочник по GLib-утилитам для работы со списками).

---

## GtkNativeDialog

Базовый интерфейс системных диалогов (`GtkFileChooserDialog`, `GtkColorChooserDialog`, `GtkFontChooserDialog` из предыдущих частей реализуют его), рисуемых напрямую операционной системой, а не средствами GTK.

```nim
proc gtk_native_dialog_show*(nativeDialog: GtkNativeDialog)
proc gtk_native_dialog_hide*(nativeDialog: GtkNativeDialog)
proc gtk_native_dialog_destroy*(nativeDialog: GtkNativeDialog)
proc gtk_native_dialog_get_visible*(nativeDialog: GtkNativeDialog): gboolean
proc gtk_native_dialog_set_modal*(nativeDialog: GtkNativeDialog, modal: gboolean)
proc gtk_native_dialog_get_modal*(nativeDialog: GtkNativeDialog): gboolean
proc gtk_native_dialog_set_title*(nativeDialog: GtkNativeDialog, title: cstring)
proc gtk_native_dialog_get_title*(nativeDialog: GtkNativeDialog): cstring
proc gtk_native_dialog_set_transient_for*(nativeDialog: GtkNativeDialog, parent: GtkWindow)
proc gtk_native_dialog_get_transient_for*(nativeDialog: GtkNativeDialog): GtkWindow
proc gtk_native_get_surface*(window: GtkWindow): pointer  # GdkSurface
```

- `show`/`hide`/`destroy` — показать/скрыть/уничтожить диалог.
- `set/get_modal`, `set/get_title`, `set/get_transient_for` — та же логика, что у `GtkWindow` (базовый справочник), применительно к системному диалогу.
- `gtk_native_get_surface` — низкоуровневая поверхность рендеринга окна (`GdkSurface`), нужна редко, для прямого взаимодействия с оконной системой в обход GTK.

---

## GtkAlertDialog

Современная (появившаяся позже `GtkMessageDialog`) облегчённая асинхронная альтернатива для простого диалога сообщения с кнопками — не наследует `GtkDialog`, использует шаблон `_choose`/`_choose_finish` в стиле GIO вместо сигнала `"response"`.

```nim
proc gtk_alert_dialog_new*(format: cstring): GtkAlertDialog {.varargs.}
proc gtk_alert_dialog_get_message*(dialog: GtkAlertDialog): cstring
proc gtk_alert_dialog_set_message*(dialog: GtkAlertDialog, message: cstring)
proc gtk_alert_dialog_get_detail*(dialog: GtkAlertDialog): cstring
proc gtk_alert_dialog_set_detail*(dialog: GtkAlertDialog, detail: cstring)
proc gtk_alert_dialog_get_buttons*(dialog: GtkAlertDialog): ptr cstring
proc gtk_alert_dialog_set_buttons*(dialog: GtkAlertDialog, labels: ptr cstring)
proc gtk_alert_dialog_get_cancel_button*(dialog: GtkAlertDialog): gint
proc gtk_alert_dialog_set_cancel_button*(dialog: GtkAlertDialog, button: gint)
proc gtk_alert_dialog_get_default_button*(dialog: GtkAlertDialog): gint
proc gtk_alert_dialog_set_default_button*(dialog: GtkAlertDialog, button: gint)
proc gtk_alert_dialog_get_modal*(dialog: GtkAlertDialog): gboolean
proc gtk_alert_dialog_set_modal*(dialog: GtkAlertDialog, modal: gboolean)
proc gtk_alert_dialog_choose*(dialog: GtkAlertDialog, parent: GtkWindow, cancellable: pointer, callback: pointer, userData: gpointer)
proc gtk_alert_dialog_choose_finish*(dialog: GtkAlertDialog, result: pointer, error: ptr GError): gint
```

- `new` — создать диалог, `format` — `printf`-подобная строка сообщения (та же логика, что у `gtk_message_dialog_new`).
- `set/get_message`, `set/get_detail` — основной текст и дополнительный поясняющий текст помельче.
- `set/get_buttons` — массив подписей кнопок, завершённый `nil` (тот же протокол, что у `gtk_about_dialog_set_authors`).
- `set/get_cancel_button`, `set/get_default_button` — индекс кнопки-отмены и кнопки по умолчанию в массиве `buttons`.
- `choose`/`choose_finish` — асинхронный показ (стандартный GIO-паттерн `_async`/`_finish`, тот же, что у `gdk_clipboard_read_text_async`/`_finish` из справочника по диалогам и медиа) — `choose_finish` возвращает индекс нажатой кнопки.

```nim
let alert = gtk_alert_dialog_new("Удалить файл?")
var buttons = [cstring("Отмена"), cstring("Удалить"), nil]
gtk_alert_dialog_set_buttons(alert, addr buttons[0])
gtk_alert_dialog_set_cancel_button(alert, 0)

proc onChoiceReady(sourceObject: pointer, res: pointer, userData: gpointer) {.cdecl.} =
  var err: ptr GError = nil
  let chosenIndex = gtk_alert_dialog_choose_finish(cast[GtkAlertDialog](sourceObject), res, addr err)
  echo "Пользователь нажал кнопку с индексом ", chosenIndex

gtk_alert_dialog_choose(alert, mainWindow, nil, onChoiceReady, nil)
```

---

## GtkBuilder

Строит дерево виджетов из XML-разметки (декларативное описание интерфейса, альтернативное ручной сборке кодом, использованной во всех примерах этой серии справочников) — синтаксис самой XML-разметки `GtkBuilder` не входит в этот справочник.

```nim
proc gtk_builder_new*(): GtkBuilder
proc gtk_builder_new_from_file*(filename: cstring): GtkBuilder
proc gtk_builder_new_from_resource*(resourcePath: cstring): GtkBuilder
proc gtk_builder_new_from_string*(str: cstring, length: gssize): GtkBuilder
proc gtk_builder_add_from_file*(builder: GtkBuilder, filename: cstring, error: ptr GError): gboolean
proc gtk_builder_add_from_resource*(builder: GtkBuilder, resourcePath: cstring, error: ptr GError): gboolean
proc gtk_builder_add_from_string*(builder: GtkBuilder, buffer: cstring, length: gssize, error: ptr GError): gboolean
proc gtk_builder_add_objects_from_file*(builder: GtkBuilder, filename: cstring, objectIds: ptr cstring, error: ptr GError): gboolean
proc gtk_builder_add_objects_from_resource*(builder: GtkBuilder, resourcePath: cstring, objectIds: ptr cstring, error: ptr GError): gboolean
proc gtk_builder_add_objects_from_string*(builder: GtkBuilder, buffer: cstring, length: gssize, objectIds: ptr cstring, error: ptr GError): gboolean
proc gtk_builder_extend_with_template*(builder: GtkBuilder, obj: GObject, templateType: GType, buffer: cstring, length: gssize, error: ptr GError): gboolean
proc gtk_builder_get_object*(builder: GtkBuilder, name: cstring): GObject
proc gtk_builder_get_objects*(builder: GtkBuilder): pointer  # GSList
proc gtk_builder_expose_object*(builder: GtkBuilder, name: cstring, obj: GObject)
proc gtk_builder_get_current_object*(builder: GtkBuilder): GObject
proc gtk_builder_set_current_object*(builder: GtkBuilder, currentObject: GObject)
proc gtk_builder_get_type_from_name*(builder: GtkBuilder, typeName: cstring): GType
proc gtk_builder_value_from_string*(builder: GtkBuilder, pspec: pointer, str: cstring, value: GValue, error: ptr GError): gboolean
proc gtk_builder_value_from_string_type*(builder: GtkBuilder, contentType: GType, str: cstring, value: GValue, error: ptr GError): gboolean
proc gtk_builder_set_scope*(builder: GtkBuilder, scope: pointer)
proc gtk_builder_get_scope*(builder: GtkBuilder): pointer
proc gtk_builder_set_translation_domain*(builder: GtkBuilder, domain: cstring)
proc gtk_builder_get_translation_domain*(builder: GtkBuilder): cstring
proc gtk_builder_create_closure*(builder: GtkBuilder, functionName: cstring, flags: gint, obj: GObject, error: ptr GError): pointer
```

- `new`/`new_from_file`/`new_from_resource`/`new_from_string` — создать построитель сразу с разметкой из соответствующего источника; `new` создаёт пустой, разметка добавляется через `add_from_*`.
- `add_from_file`/`_resource`/`_string` — добавить разметку в уже существующий построитель.
- `add_objects_from_*` — то же самое, но строит только объекты с перечисленными в `objectIds` (`NULL`-терминированный массив) идентификаторами, а не всю иерархию из разметки.
- `extend_with_template` — механизм шаблонных виджетов (собственный подкласс `GtkWidget` с частью структуры, заданной XML-шаблоном) — специализированный сценарий создания составных виджетов, а не просто разбора разметки.
- `get_object` — найти построенный объект по его `id` из разметки — основной способ получить доступ к виджетам после разбора.
- `get_objects` — все построенные объекты сразу (`GSList`).
- `expose_object` — обратная операция: сделать существующий объект доступным внутри разметки под именем, как если бы он был описан в самой разметке.
- `get/set_current_object` — объект-контекст для разметки, где не всё дерево виджетов строится с нуля, а расширяется существующий объект (используется вместе с `extend_with_template`).
- `get_type_from_name` — разрешить строковое имя типа (как оно пишется в XML) в `GType`.
- `value_from_string`/`_type` — низкоуровневый разбор строкового значения свойства в `GValue` по спецификации свойства/типу — то, что `GtkBuilder` делает внутри себя при разборе атрибутов разметки.
- `set/get_scope` — область поиска обработчиков сигналов, объявленных в разметке через атрибут `handler=` (позволяет разметке ссылаться на функции обратного вызова по имени).
- `set/get_translation_domain` — домен локализации (gettext) для строк разметки, помеченных как переводимые.
- `create_closure` — создать `GClosure` (низкоуровневый вызываемый объект GObject) по имени функции — используется внутренне механизмом `scope`.

---

## GtkSettings

Общесистемные и специфичные для конкретного дисплея настройки GTK (тема оформления, размер шрифта по умолчанию, скорость двойного клика и т.п.) — сами конкретные настройки читаются/пишутся универсальным `g_object_get`/`set` (справочник по рисованию, стилям и GLib-утилитам) по имени свойства (например, `"gtk-theme-name"`), а не отдельными типобезопасными функциями.

```nim
proc gtk_settings_get_default*(): GtkSettings
proc gtk_settings_get_for_display*(display: pointer): GtkSettings
proc gtk_settings_reset_property*(settings: GtkSettings, name: cstring)
```

- `get_default` — объект настроек для дисплея по умолчанию.
- `get_for_display` — объект настроек для конкретного `GdkDisplay`.
- `reset_property` — сбросить конкретное свойство настроек к системному значению (отменяет ранее сделанное программой переопределение через `g_object_set`).

```nim
let settings = gtk_settings_get_default()
g_object_set(cast[GObject](settings), "gtk-application-prefer-dark-theme".cstring, 1.gboolean, nil)
echo "Приложение переключено на тёмную тему независимо от системной настройки"
```

---

## GtkSizeGroup

Синхронизирует размер (ширину и/или высоту) нескольких независимых виджетов, не связанных общим контейнером напрямую, — типичное применение: подписи в форме из нескольких `GtkGrid`, которые должны иметь одинаковую ширину для визуального выравнивания полей ввода, хотя сами подписи находятся в разных строках/контейнерах.

```nim
type
  GtkSizeGroupMode* = enum
    GTK_SIZE_GROUP_NONE = 0, GTK_SIZE_GROUP_HORIZONTAL = 1,
    GTK_SIZE_GROUP_VERTICAL = 2, GTK_SIZE_GROUP_BOTH = 3

proc gtk_size_group_new*(mode: GtkSizeGroupMode): GtkSizeGroup
proc gtk_size_group_set_mode*(sizeGroup: GtkSizeGroup, mode: GtkSizeGroupMode)
proc gtk_size_group_get_mode*(sizeGroup: GtkSizeGroup): GtkSizeGroupMode
proc gtk_size_group_add_widget*(sizeGroup: GtkSizeGroup, widget: GtkWidget)
proc gtk_size_group_remove_widget*(sizeGroup: GtkSizeGroup, widget: GtkWidget)
proc gtk_size_group_get_widgets*(sizeGroup: GtkSizeGroup): pointer  # GSList
```

- `new` — создать группу с режимом синхронизации (`HORIZONTAL`/`VERTICAL`/`BOTH`/`NONE`).
- `set/get_mode` — изменить режим уже после создания.
- `add_widget`/`remove_widget` — включить/исключить виджет из группы (все виджеты группы получают наибольший из своих естественных размеров по указанной оси).
- `get_widgets` — список виджетов, входящих в группу (`GSList`).

```nim
let labelGroup = gtk_size_group_new(GTK_SIZE_GROUP_HORIZONTAL)
gtk_size_group_add_widget(labelGroup, nameLabel)
gtk_size_group_add_widget(labelGroup, emailLabel)
echo "Подписи 'Имя' и 'Email' теперь одной ширины, даже находясь в разных строках сетки"
```

---

## GDK KeyVal

Утилиты для работы с кодами клавиш (`keyval` — те же числовые коды, что приходят в сигнал `"key-pressed"` контроллера `GtkEventControllerKey` из справочника по вводу и Drag-and-Drop).

```nim
proc gdk_keyval_from_name*(keyvalName: cstring): guint
proc gdk_keyval_name*(keyval: guint): cstring
proc gdk_keyval_to_unicode*(keyval: guint): gunichar
proc gdk_unicode_to_keyval*(wc: gunichar): guint
proc gdk_keyval_to_upper*(keyval: guint): guint
proc gdk_keyval_to_lower*(keyval: guint): guint
proc gdk_keyval_is_upper*(keyval: guint): gboolean
proc gdk_keyval_is_lower*(keyval: guint): gboolean
```

- `from_name`/`name` — преобразование между символьным именем клавиши (например, `"Return"`, `"F1"`, `"a"`) и числовым кодом.
- `to_unicode`/`from_unicode` (`unicode_to_keyval`) — преобразование между кодом клавиши и символом Unicode, если клавиша соответствует печатаемому символу.
- `to_upper`/`to_lower`, `is_upper`/`is_lower` — регистр буквенных клавиш.

```nim
echo "Код клавиши Return: ", gdk_keyval_from_name("Return")
echo "Имя клавиши с кодом 65 (A): ", $gdk_keyval_name(65)
```

---

## GIO — операции с файлами (расширение справочника по рисованию и GLib-утилитам)

Дополнительные функции `GFile` сверх базовых (`g_file_new_for_path`, `get_path`, `get_basename`), уже описанных в справочнике по рисованию, стилям и GLib-утилитам.

```nim
proc g_file_new_for_uri*(uri: cstring): GFile
proc g_file_new_for_commandline_arg*(arg: cstring): GFile
proc g_file_new_tmp*(tmpl: cstring, iostream: pointer, error: ptr GError): GFile
proc g_file_parse_name*(parseName: cstring): GFile
proc g_file_dup*(file: GFile): GFile
proc g_file_hash*(file: GFile): guint
proc g_file_equal*(file1: GFile, file2: GFile): gboolean
proc g_file_get_uri*(file: GFile): cstring
proc g_file_get_parse_name*(file: GFile): cstring
proc g_file_get_parent*(file: GFile): GFile
proc g_file_has_parent*(file: GFile, parent: GFile): gboolean
proc g_file_get_child*(file: GFile, name: cstring): GFile
proc g_file_get_child_for_display_name*(file: GFile, displayName: cstring, error: ptr GError): GFile
proc g_file_has_prefix*(file: GFile, prefix: GFile): gboolean
proc g_file_get_relative_path*(parent: GFile, descendant: GFile): cstring
proc g_file_resolve_relative_path*(file: GFile, relativePath: cstring): GFile
proc g_file_is_native*(file: GFile): gboolean
proc g_file_has_uri_scheme*(file: GFile, uriScheme: cstring): gboolean
proc g_file_get_uri_scheme*(file: GFile): cstring
proc g_file_query_exists*(file: GFile, cancellable: pointer): gboolean
proc g_file_query_file_type*(file: GFile, flags: gint, cancellable: pointer): gint
```

- `new_for_uri` — создать `GFile` из URI (`"file:///..."`, но также `"http://..."` и другие GIO-схемы) вместо локального пути.
- `new_for_commandline_arg` — создать `GFile` из строки аргумента командной строки (учитывает как пути, так и URI, набранные пользователем).
- `new_tmp` — создать временный файл с уникальным именем по шаблону.
- `parse_name` — создать `GFile` из "человекочитаемого" представления пути (может включать `~` для домашней папки и т.п.).
- `dup` — независимая копия объекта `GFile` (сам объект неизменяем, но иногда нужна отдельная ссылка).
- `hash`/`equal` — сравнение двух `GFile` на равенство (по тому, на один ли реальный файл они указывают, а не по идентичности объектов).
- `get_uri`/`get_parse_name` — представление пути как URI / как человекочитаемой строки.
- `get_parent`/`has_parent` — родительская папка.
- `get_child`/`get_child_for_display_name` — дочерний путь по имени (второй вариант — по отображаемому, возможно не файловой-системному, имени, с обработкой ошибки).
- `has_prefix`/`get_relative_path`/`resolve_relative_path` — операции с относительными путями.
- `is_native` — находится ли файл в "родной" файловой системе (локальный диск), а не в виртуальной (архив, сетевой протокол).
- `has_uri_scheme`/`get_uri_scheme` — схема URI (`"file"`, `"http"`, `"trash"` и т.п.).
- `query_exists` — существует ли файл (синхронная проверка).
- `query_file_type` — тип файла (обычный/папка/симлинк и т.п., значения `GFileType`, не заведённые именованным enum в этой обёртке).

---

## Разные утилиты (Miscellaneous)

```nim
proc gtk_show_uri*(parent: GtkWindow, uri: cstring, timestamp: guint32, error: ptr GError)
proc gtk_show_uri_full*(parent: GtkWindow, uri: cstring, timestamp: guint32, cancellable: pointer, callback: pointer, userData: gpointer)
proc gtk_show_uri_full_finish*(parent: GtkWindow, result: pointer, error: ptr GError): gboolean
```

- `gtk_show_uri` — открыть URI в системном приложении по умолчанию (браузере, почтовом клиенте и т.п.) — синхронный, устаревающий в пользу асинхронной версии. `timestamp` — метка времени пользовательского события, инициировавшего открытие (для корректной передачи фокуса окну открывшегося приложения; можно передать `0`, если недоступна).
- `gtk_show_uri_full`/`_finish` — та же операция в асинхронном GIO-стиле (`_async`/`_finish`), предпочтительный вариант.

```nim
proc onUriOpened(sourceObject: pointer, res: pointer, userData: gpointer) {.cdecl.} =
  var err: ptr GError = nil
  discard gtk_show_uri_full_finish(cast[GtkWindow](sourceObject), res, addr err)

gtk_show_uri_full(mainWindow, "https://example.com", 0, nil, onUriOpened, nil)
echo "Ссылка открывается в браузере по умолчанию"
```

---

## GtkTooltip

Объект, представляющий саму всплывающую подсказку **изнутри** обработчика сигнала `"query-tooltip"` виджета (продвинутая альтернатива простому `gtk_widget_set_tooltip_text` из базового справочника — нужна, когда содержимое подсказки должно динамически зависеть от того, над какой именно частью виджета находится курсор, например, разные подсказки для разных ячеек самодельного канваса).

```nim
proc gtk_tooltip_set_markup*(tooltip: GtkTooltip, markup: cstring)
proc gtk_tooltip_set_text*(tooltip: GtkTooltip, text: cstring)
proc gtk_tooltip_set_icon*(tooltip: GtkTooltip, paintable: pointer)
proc gtk_tooltip_set_icon_from_icon_name*(tooltip: GtkTooltip, iconName: cstring)
proc gtk_tooltip_set_icon_from_gicon*(tooltip: GtkTooltip, gicon: pointer)
proc gtk_tooltip_set_custom*(tooltip: GtkTooltip, customWidget: GtkWidget)
proc gtk_tooltip_set_tip_area*(tooltip: GtkTooltip, rect: pointer)  # GdkRectangle
```

- `set_markup`/`set_text` — содержимое подсказки, та же логика разметки/обычного текста, что у `gtk_label_set_markup`/`set_text`.
- `set_icon*` — иконка внутри подсказки, тремя способами (готовое изображение, имя из темы, `GIcon`) — та же логика выбора источника, что у `gtk_image_new_from_*`.
- `set_custom` — полностью произвольный виджет вместо текста и иконки.
- `set_tip_area` — ограничивает область виджета (`GdkRectangle`), за которую отвечает эта конкретная подсказка, — нужен для того, чтобы GTK не запрашивала повторно `"query-tooltip"` при движении курсора в пределах уже описанной области (актуально для канвасов с множеством логических "ячеек" под одним физическим виджетом).

```nim
proc onQueryTooltip(widget: GtkWidget, x: gint, y: gint, keyboardMode: gboolean,
                     tooltip: GtkTooltip, userData: gpointer): gboolean {.cdecl.} =
  gtk_tooltip_set_text(tooltip, "Подсказка для точки (" & $x & ", " & $y & ")")
  result = 1.gboolean  # 1 — показать подсказку

discard g_signal_connect(canvasWidget, "query-tooltip", onQueryTooltip, nil)
# В этой обёртке есть только gtk_widget_get_has_tooltip (геттер) — сеттера нет,
# включить свойство "has-tooltip" нужно через g_object_set:
g_object_set(cast[GObject](canvasWidget), "has-tooltip".cstring, 1.gboolean, nil)
```
