# GTK4 (drawing, styling & low-level utilities: DrawingArea / CssProvider / GFile / GVariant / GObject) — справочник модуля

> **Импорт:** `import libGTK4`
> **Область применения:** произвольная отрисовка через Cairo, программная стилизация через CSS, и низкоуровневые утилиты GLib/GObject, лежащие в основе всей остальной обёртки (файлы, ошибки, вариантные значения, свойства объектов, счётчик ссылок). Девятая часть серии справочников по обёртке; предполагает знакомство с предыдущими частями, особенно с `gtk4_core_reference_ru.md` (компоновка, `GtkWidget`).

Этот справочник отличается от предыдущих по характеру: `GtkDrawingArea` и `GtkCssProvider` — по-прежнему виджет/GTK-специфичный API, но `GFile`, `GVariant` и особенно `GObject` — это уже не GTK, а нижележащий слой GLib/GObject, на котором построена сама GTK и, транзитивно, вся эта обёртка. Функции `GObject` применимы не только к виджетам, а к любому GObject-совместимому объекту, встречавшемуся в предыдущих справочниках (`GtkApplication`, `GtkTextBuffer`, `GMenuModel` и т.д.).

---

## Оглавление

I. [GtkDrawingArea](#gtkdrawingarea)
&nbsp;&nbsp;1. [`gtk_drawing_area_new`](#gtk_drawing_area_new)
&nbsp;&nbsp;2. [`gtk_drawing_area_set_content_width` / `get_content_width` / `set_content_height` / `get_content_height`](#gtk_drawing_area_set_content_width--get_content_width--set_content_height--get_content_height)
&nbsp;&nbsp;3. [`gtk_drawing_area_set_draw_func`](#gtk_drawing_area_set_draw_func)

II. [Стилизация: GtkCssProvider и GtkStyleContext](#стилизация-gtkcssprovider-и-gtkstylecontext)
&nbsp;&nbsp;1. [`gtk_css_provider_new`](#gtk_css_provider_new)
&nbsp;&nbsp;2. [`gtk_css_provider_load_from_data` / `_from_file` / `_from_path` / `_from_string`](#gtk_css_provider_load_from_data--_from_file--_from_path--_from_string)
&nbsp;&nbsp;3. [`gtk_widget_get_style_context` / `gtk_style_context_add_provider`](#gtk_widget_get_style_context--gtk_style_context_add_provider)
&nbsp;&nbsp;4. [`gtk_style_context_add_provider_for_display` / `gtk_widget_get_display` / `gdk_display_get_default`](#gtk_style_context_add_provider_for_display--gtk_widget_get_display--gdk_display_get_default)

III. [GFile и GError](#gfile-и-gerror)
&nbsp;&nbsp;1. [`g_file_new_for_path` / `g_file_get_path` / `g_file_get_basename`](#g_file_new_for_path--g_file_get_path--g_file_get_basename)
&nbsp;&nbsp;2. [`g_error_free`](#g_error_free)

IV. [GVariant](#gvariant)
&nbsp;&nbsp;1. [`g_variant_new_string` / `g_variant_new_boolean` / `g_variant_new_int32`](#g_variant_new_string--g_variant_new_boolean--g_variant_new_int32)
&nbsp;&nbsp;2. [`g_variant_get_string` / `g_variant_get_boolean` / `g_variant_get_int32`](#g_variant_get_string--g_variant_get_boolean--g_variant_get_int32)

V. [GObject](#gobject)
&nbsp;&nbsp;1. [Счётчик ссылок: `g_object_ref` / `g_object_unref` / `g_object_ref_sink` / `g_object_is_floating`](#счётчик-ссылок-g_object_ref--g_object_unref--g_object_ref_sink--g_object_is_floating)
&nbsp;&nbsp;2. [`g_object_set` / `g_object_get`](#g_object_set--g_object_get)
&nbsp;&nbsp;3. [`g_object_set_property` / `g_object_get_property`](#g_object_set_property--g_object_get_property)
&nbsp;&nbsp;4. [Уведомления об изменении: `g_object_notify` и родственные](#уведомления-об-изменении-g_object_notify-и-родственные)
&nbsp;&nbsp;5. [Произвольные данные по строковому ключу: `g_object_set_data` и родственные](#произвольные-данные-по-строковому-ключу-g_object_set_data-и-родственные)
&nbsp;&nbsp;6. [Слабые ссылки: `g_object_weak_ref` и родственные](#слабые-ссылки-g_object_weak_ref-и-родственные)
&nbsp;&nbsp;7. [Toggle references: `g_object_add_toggle_ref`](#toggle-references-g_object_add_toggle_ref)
&nbsp;&nbsp;8. [Информация о типе: `g_object_get_type` и родственные](#информация-о-типе-g_object_get_type-и-родственные)
&nbsp;&nbsp;9. [Создание объектов: `g_object_new` / `g_object_newv`](#создание-объектов-g_object_new--g_object_newv)
&nbsp;&nbsp;10. [Данные по GQuark: `g_object_set_qdata` и родственные](#данные-по-gquark-g_object_set_qdata-и-родственные)
&nbsp;&nbsp;11. [Связывание свойств: `g_object_bind_property`](#связывание-свойств-g_object_bind_property)
&nbsp;&nbsp;12. [`g_quark_from_string` / `g_quark_to_string` / `g_quark_try_string`](#g_quark_from_string--g_quark_to_string--g_quark_try_string)

VI. [Практические рецепты](#практические-рецепты)
&nbsp;&nbsp;1. [Простой рисунок на GtkDrawingArea через Cairo](#простой-рисунок-на-gtkdrawingarea-через-cairo)
&nbsp;&nbsp;2. [Загрузка глобальной CSS-темы приложения](#загрузка-глобальной-css-темы-приложения)
&nbsp;&nbsp;3. [Привязка чувствительности кнопки к состоянию флажка без единой строки кода в обработчике](#привязка-чувствительности-кнопки-к-состоянию-флажка-без-единой-строки-кода-в-обработчике)
&nbsp;&nbsp;4. [Прикрепление собственных данных к виджету по строковому ключу](#прикрепление-собственных-данных-к-виджету-по-строковому-ключу)
&nbsp;&nbsp;5. [Передача составного значения через GVariant в обработчик действия](#передача-составного-значения-через-gvariant-в-обработчик-действия)

VII. [Краткая таблица](#краткая-таблица)

VIII. [Сводка: какую процедуру выбрать](#сводка-какую-процедуру-выбрать)

---

## GtkDrawingArea

`GtkDrawingArea` — пустой холст: виджет без собственного визуального представления, который вызывает предоставленную вами функцию рисования каждый раз, когда его нужно перерисовать. Функция рисования получает контекст Cairo — низкоуровневый API для 2D-графики (линии, фигуры, текст, изображения), не входящий в этот справочник как отдельная тема, но упоминаемый здесь в объёме, необходимом для базового использования `GtkDrawingArea`.

### `gtk_drawing_area_new`

```nim
proc gtk_drawing_area_new*(): GtkDrawingArea
```

**Что делает.** Создаёт пустую область рисования без функции отрисовки — саму функцию нужно назначить отдельно через `gtk_drawing_area_set_draw_func`, без неё область остаётся визуально пустой.

- Параметров нет.

```nim
let canvas = gtk_drawing_area_new()
echo "Пустая область рисования создана"
```

---

### `gtk_drawing_area_set_content_width` / `get_content_width` / `set_content_height` / `get_content_height`

```nim
proc gtk_drawing_area_set_content_width*(area: GtkDrawingArea, width: gint)
proc gtk_drawing_area_get_content_width*(area: GtkDrawingArea): gint
proc gtk_drawing_area_set_content_height*(area: GtkDrawingArea, height: gint)
proc gtk_drawing_area_get_content_height*(area: GtkDrawingArea): gint
```

**Что делает.** Задают предпочитаемый размер содержимого холста — то, какого размера область рисования запрашивает себе место у системы компоновки (аналог `gtk_widget_set_size_request` из базового справочника, но именно для содержимого рисования, а не общий минимум виджета). Реальный размер, который область получит на экране, всё равно зависит от родительского контейнера и настроек `hexpand`/`vexpand` — эти два значения лишь предпочтение.

- `area` — область рисования.
- `width`, `height` — предпочитаемый размер содержимого в пикселях.

```nim
gtk_drawing_area_set_content_width(canvas, 300)
gtk_drawing_area_set_content_height(canvas, 200)
echo "Область рисования запрашивает себе 300×200 пикселей"
```

---

### `gtk_drawing_area_set_draw_func`

```nim
proc gtk_drawing_area_set_draw_func*(area: GtkDrawingArea, drawFunc: pointer, userData: gpointer, destroy: GDestroyNotify)
```

**Что делает.** Назначает функцию, которую GTK вызывает каждый раз, когда область рисования должна быть перерисована (при первом показе, изменении размера, или по явному запросу перерисовки через `gtk_widget_queue_draw` из базового справочника). `drawFunc` — указатель на C-совместимую функцию с сигнатурой `proc(area: GtkDrawingArea, cr: pointer, width, height: gint, userData: gpointer) {.cdecl.}`, где `cr` — контекст Cairo, в который и производится вся отрисовка функциями `cairo_*` (не входят в этот справочник). `destroy` — необязательная функция очистки `userData`, вызываемая, когда область рисования уничтожается или функция рисования заменяется другой (можно передать `nil`, если `userData` не требует освобождения).

- `area` — область рисования.
- `drawFunc` — указатель на функцию отрисовки.
- `userData` — произвольные пользовательские данные, передаваемые в `drawFunc`.
- `destroy` — функция очистки `userData`, либо `nil`.

```nim
proc onDraw(area: GtkDrawingArea, cr: pointer, width: gint, height: gint, userData: gpointer) {.cdecl.} =
  # Здесь используются функции cairo_* (cairo_set_source_rgb, cairo_rectangle,
  # cairo_fill и т.п.) для рисования в контексте cr — API Cairo не входит
  # в этот справочник.
  echo "Отрисовка холста размером ", width, "×", height

gtk_drawing_area_set_draw_func(canvas, onDraw, nil, nil)
echo "Функция отрисовки назначена холсту"
```

---

## Стилизация: GtkCssProvider и GtkStyleContext

CSS в GTK4 — основной механизм визуальной кастомизации: цвета, отступы, шрифты, границы задаются в CSS-синтаксисе (похожем, но не идентичном веб-CSS) и применяются к виджетам через селекторы по имени (`gtk_widget_set_name`, справочник по базовым элементам управления), CSS-классу (`gtk_widget_add_css_class`) или типу виджета. `GtkCssProvider` загружает правила стилей из разных источников; `GtkStyleContext` определяет, к какой области действия (конкретный виджет или всё приложение целиком) эти правила применяются.

### `gtk_css_provider_new`

```nim
proc gtk_css_provider_new*(): GtkCssProvider
```

**Что делает.** Создаёт пустой провайдер стилей, ещё не содержащий никаких CSS-правил, — сами правила загружаются одним из вызовов следующего подраздела.

- Параметров нет.

```nim
let cssProvider = gtk_css_provider_new()
echo "Провайдер стилей создан"
```

---

### `gtk_css_provider_load_from_data` / `_from_file` / `_from_path` / `_from_string`

```nim
proc gtk_css_provider_load_from_data*(cssProvider: GtkCssProvider, data: cstring, length: gssize)
proc gtk_css_provider_load_from_file*(cssProvider: GtkCssProvider, file: GFile)
proc gtk_css_provider_load_from_path*(cssProvider: GtkCssProvider, path: cstring)
proc gtk_css_provider_load_from_string*(cssProvider: GtkCssProvider, str: cstring)
```

**Что делает.** Четыре источника загрузки CSS-правил в уже созданный провайдер. `load_from_data` — из буфера байт заданной длины (`length = -1` для `NUL`-терминированной строки). `load_from_file` — из объекта `GFile` (раздел III). `load_from_path` — короче, сразу из строки пути к файлу на диске, без промежуточного создания `GFile`. `load_from_string` — из готовой Nim-строки CSS, встроенной прямо в код программы (например, для нескольких строк CSS, не заслуживающих отдельного файла).

- `cssProvider` — провайдер стилей.
- `data` / `str` — CSS-текст.
- `length` (для `load_from_data`) — длина в байтах, либо `-1`.
- `file` — объект `GFile`, указывающий на CSS-файл.
- `path` — путь к CSS-файлу.

```nim
gtk_css_provider_load_from_string(cssProvider, """
  .danger-button { background-color: #c0392b; }
  .rounded-panel { border-radius: 12px; }
""")
echo "CSS-правила загружены из встроенной в код строки"
```

---

### `gtk_widget_get_style_context` / `gtk_style_context_add_provider`

```nim
proc gtk_widget_get_style_context*(widget: GtkWidget): GtkStyleContext
proc gtk_style_context_add_provider*(context: GtkStyleContext, provider: pointer, priority: guint)
```

**Что делает.** Применяют провайдер стилей только к одному конкретному виджету (и, автоматически, ко всем его дочерним виджетам, поскольку стили в CSS каскадно наследуются) — получают контекст стиля через `gtk_widget_get_style_context`, затем добавляют в него провайдер. `priority` определяет порядок применения при конфликте правил из разных провайдеров одного и того же виджета — при равном специфичности CSS-селектора выигрывает провайдер с большим числовым приоритетом; для собственных стилей приложения обычно используется значение `GTK_STYLE_PROVIDER_PRIORITY_APPLICATION` (константа, не заведённая в этой обёртке отдельным именем — на практике эквивалентна числу `600`, которое можно передать напрямую).

- `widget` — виджет, к которому применяется стиль.
- `context` — контекст стиля, полученный от `get_style_context`.
- `provider` — провайдер стилей (`GtkCssProvider`, приводится к `pointer`).
- `priority` — числовой приоритет.

```nim
let context = gtk_widget_get_style_context(dangerButton)
gtk_style_context_add_provider(context, cast[pointer](cssProvider), 600)
gtk_widget_add_css_class(dangerButton, "danger-button")
echo "Собственный CSS-класс применён только к этой кнопке (и её потомкам)"
```

---

### `gtk_style_context_add_provider_for_display` / `gtk_widget_get_display` / `gdk_display_get_default`

```nim
proc gtk_style_context_add_provider_for_display*(display: pointer, provider: pointer, priority: guint)
proc gtk_widget_get_display*(widget: GtkWidget): GdkDisplay
proc gdk_display_get_default*(): pointer
```

**Что делает.** `gtk_style_context_add_provider_for_display` применяет провайдер стилей глобально — ко всем виджетам всех окон, показанных на данном дисплее (`GdkDisplay` — абстракция экрана/сессии показа, в терминах X11/Wayland), а не только к одному виджету и его потомкам, как `gtk_style_context_add_provider`. Именно так загружается общая CSS-тема приложения (см. раздел VI, «Загрузка глобальной CSS-темы»). Дисплей, к которому применить стили, получают либо от конкретного уже существующего виджета через `gtk_widget_get_display`, либо, если ни одного виджета/окна ещё не создано, через `gdk_display_get_default()` — дисплей по умолчанию для текущей сессии.

- `display` — объект дисплея (`GdkDisplay`, приводится к `pointer`).
- `provider` — провайдер стилей.
- `priority` — числовой приоритет.

```nim
let display = gdk_display_get_default()
gtk_style_context_add_provider_for_display(display, cast[pointer](cssProvider), 600)
echo "CSS-провайдер применён глобально ко всем окнам приложения на этом дисплее"
```

---

## GFile и GError

`GFile` — абстракция файла или папки в GIO, представляющая путь без немедленного обращения к файловой системе (в отличие от простой строки пути, `GFile` также умеет работать с сетевыми и виртуальными файловыми системами — но в этой обёртке доступны только базовые операции для локальных путей). `GError` — стандартный способ передачи информации об ошибке из C-функций GLib/GTK, встречавшийся уже в предыдущих справочниках как параметр `ptr GError` во многих функциях (например, `gtk_file_chooser_set_file`).

### `g_file_new_for_path` / `g_file_get_path` / `g_file_get_basename`

```nim
proc g_file_new_for_path*(path: cstring): GFile
proc g_file_get_path*(file: GFile): cstring
proc g_file_get_basename*(file: GFile): cstring
```

**Что делает.** `g_file_new_for_path` создаёт объект `GFile` из обычной строки локального пути — самый частый способ получить `GFile` для передачи в функции, которые его ожидают (например, `gtk_css_provider_load_from_file`, `gtk_file_chooser_set_current_folder` из предыдущих справочников). `g_file_get_path` — обратная операция, извлекает строку пути обратно (может вернуть `nil` для `GFile`, не представляющих локальный путь — например, для сетевых ресурсов, что в этой обёртке не актуально, так как единственный способ создания `GFile` здесь — именно из локального пути). `g_file_get_basename` возвращает только имя файла без пути к папке (последний компонент пути).

- `path` — строка локального пути (абсолютного или относительного).
- `file` — объект `GFile`.

```nim
let configFile = g_file_new_for_path("/home/user/.config/myapp/settings.json")
echo "Имя файла: ", $g_file_get_basename(configFile)  # выводит "Имя файла: settings.json"
echo "Полный путь: ", $g_file_get_path(configFile)
```

---

### `g_error_free`

```nim
proc g_error_free*(error: GError)
```

**Что делает.** Освобождает память, занятую объектом `GError`, полученным от функции, принимавшей параметр `ptr GError` (после того как значение по этому указателю было заполнено функцией и текст ошибки уже прочитан/обработан вызывающим кодом). `GError` не управляется автоматически сборщиком ссылок GObject (это отдельная структура GLib, не GObject) — если функция вернула ошибку через `ptr GError`, ответственность за освобождение памяти лежит на вызывающем коде.

- **Реализация.** Забытый вызов `g_error_free` для каждой полученной ошибки — источник утечек памяти при длительной работе приложения, особенно в коде, где ошибки возникают часто (например, при периодических сетевых операциях) — стоит вызывать его в обеих ветках (и при обработке ошибки, и сразу после того, как выяснилось, что ошибка есть, но она проигнорирована). Обратите внимание: в этой обёртке `GError` типизирован как непрозрачный `pointer` (а не как структура с полями), поэтому напрямую прочитать текст ошибки (поле `message` реальной C-структуры `GError`) через обычный доступ к полю Nim нельзя — для этого потребовался бы отдельный accessor-биндинг, не входящий в текущий набор функций; данная обёртка позволяет только проверить сам факт наличия ошибки и корректно освободить память.

- `error` — объект ошибки.

```nim
var err: ptr GError = nil
if gtk_file_chooser_set_file(chooser, someFile, addr err) == 0.gboolean:
  if not isNil(err):
    echo "Не удалось установить файл — получена ошибка"
    g_error_free(err[])  # err — ptr GError, err[] — сам объект GError
```

---

## GVariant

`GVariant` — типобезопасный контейнер для значения произвольного типа (строка, число, булево, а также вложенные структуры и массивы — в этой обёртке доступны только три базовых скалярных типа) с информацией о собственном типе, встроенной в само значение. Используется там, где GTK/GIO нужен универсальный способ передать значение без привязки к конкретному языку/ABI — в первую очередь для параметров действий (Actions, справочник по window chrome в контексте `gtk_actionable_set_action_target_value`) и для сериализации настроек через `GSettings` (не входит в эту обёртку).

### `g_variant_new_string` / `g_variant_new_boolean` / `g_variant_new_int32`

```nim
proc g_variant_new_string*(str: cstring): GVariant
proc g_variant_new_boolean*(value: gboolean): GVariant
proc g_variant_new_int32*(value: gint32): GVariant
```

**Что делает.** Оборачивают обычное Nim/C-значение (строку, булево, 32-битное целое) в типизированный `GVariant`. Созданный `GVariant` "знает" свой тип самостоятельно — при последующем чтении через `g_variant_get_*` (следующий подраздел) важно использовать функцию, соответствующую тому типу, которым значение было создано, иначе поведение не определено.

- `str` — строка (для `new_string`).
- `value` — булево (для `new_boolean`) или 32-битное целое (для `new_int32`).

```nim
let targetValue = g_variant_new_string("grid")
gtk_actionable_set_action_target_value(viewModeButton, targetValue)
echo "GVariant со строкой 'grid' создан и передан как параметр действия"
```

---

### `g_variant_get_string` / `g_variant_get_boolean` / `g_variant_get_int32`

```nim
proc g_variant_get_string*(value: GVariant, length: ptr gsize): cstring
proc g_variant_get_boolean*(value: GVariant): gboolean
proc g_variant_get_int32*(value: GVariant): gint32
```

**Что делает.** Извлекают обратно значение соответствующего типа из `GVariant`. `g_variant_get_string` дополнительно может вернуть длину строки через `length` (в байтах, без учёта завершающего нуля) — передача `nil` вместо `length`, если длина не нужна, допустима, поскольку строка и так `NUL`-терминирована.

- `value` — объект `GVariant`.
- `length` (только для `get_string`) — указатель для длины строки, либо `nil`.

```nim
proc onActionActivated(action: pointer, parameter: GVariant, userData: gpointer) {.cdecl.} =
  let requestedMode = $g_variant_get_string(parameter, nil)
  echo "Запрошен режим отображения: ", requestedMode
```

---

## GObject

`GObject` — базовый класс объектной системы, на которой построена вся GTK: подсчёт ссылок, система свойств, сигналы (справочник по window chrome вскользь их использует, полноценный разбор — в отдельном справочнике). Функции этого раздела применимы к любому объекту, встречавшемуся в предыдущих справочниках, — окну, кнопке, буферу текста, приложению — поскольку все они, в конечном счёте, наследуются от `GObject`. В этой обёртке параметр типа `GObject` принимает `gpointer`/любой из более специфичных типов виджетов напрямую, без явного приведения.

### Счётчик ссылок: `g_object_ref` / `g_object_unref` / `g_object_ref_sink` / `g_object_is_floating`

```nim
proc g_object_ref*(obj: gpointer): gpointer
proc g_object_unref*(obj: gpointer)
proc g_object_ref_sink*(obj: gpointer): gpointer
proc g_object_is_floating*(obj: GObject): gboolean
proc g_object_force_floating*(obj: GObject)
```

**Что делает.** GObject управляет временем жизни объектов подсчётом ссылок: `g_object_ref` увеличивает счётчик на единицу (объект не будет уничтожен, пока счётчик больше нуля) и возвращает тот же объект — удобно для использования в цепочке присваивания. `g_object_unref` уменьшает счётчик; когда он достигает нуля, объект уничтожается. Виджеты GTK при создании находятся в особом "плавающем" состоянии (`floating`) — их не нужно явно `ref`'ить сразу после создания, поскольку контейнер, в который виджет добавляется (`gtk_box_append` и подобные функции из предыдущих справочников), сам "забирает" плавающую ссылку через `g_object_ref_sink` внутри себя; `g_object_is_floating` проверяет текущее состояние, `g_object_force_floating` принудительно переводит объект обратно в плавающее состояние (специализированный сценарий, почти никогда не требуется в прикладном коде).

- **Реализация.** Для виджетов, добавленных в контейнер обычным образом (`gtk_box_append`, `gtk_window_set_child` и т.п. из предыдущих справочников), вызывающему коду в норме вообще не требуется вручную управлять счётчиком ссылок — плавающая ссылка передаётся контейнеру автоматически. Явный `g_object_ref`/`unref` нужен в первую очередь для объектов, которые нужно сохранить "живыми" дольше, чем ими владеет единственный контейнер (например, чтобы временно вынуть виджет из одного контейнера и переставить в другой, не дав ему быть уничтоженным в промежутке).

- `obj` — объект.

```nim
let keepAliveRef = g_object_ref(someWidget)
gtk_box_remove(oldContainer, someWidget)
gtk_box_append(newContainer, someWidget)
g_object_unref(keepAliveRef)  # временная защитная ссылка больше не нужна
echo "Виджет безопасно перемещён между контейнерами без риска быть уничтоженным в процессе"
```

---

### `g_object_set` / `g_object_get`

```nim
proc g_object_set*(obj: GObject, firstPropertyName: cstring) {.varargs.}
proc g_object_get*(obj: GObject, firstPropertyName: cstring) {.varargs.}
```

**Что делает.** Устанавливают/читают сразу несколько именованных свойств GObject-объекта за один вызов — универсальный механизм, работающий для любого свойства любого GObject-класса (в том числе тех, для которых в этой обёртке не заведено отдельной типобезопасной пары `get_X`/`set_X`), но требующий передачи имени свойства строкой и без проверки типов на этапе компиляции. Список аргументов — чередующиеся пары "имя свойства" / "значение", завершённые обязательным `nil`, — тот же C-протокол вариативных аргументов, что и у `gtk_file_chooser_dialog_new` из справочника по диалогам.

- **Реализация.** Для свойств, у которых в этой обёртке уже есть специальная типобезопасная пара функций (например, `gtk_window_set_title`/`get_title`), предпочтительнее использовать именно её — она проверяется компилятором Nim и не требует помнить точное строковое имя свойства и его C-тип. `g_object_set`/`get` — запасной вариант для доступа к свойствам, не покрытым остальной обёрткой явно.

- `obj` — объект.
- `firstPropertyName`, далее пары (имя, значение), завершённые `nil`.

```nim
g_object_set(cast[GObject](someButton), "sensitive".cstring, 0.gboolean, nil)
echo "Свойство 'sensitive' изменено напрямую через g_object_set, минуя типобезопасную обёртку"
```

---

### `g_object_set_property` / `g_object_get_property`

```nim
proc g_object_set_property*(obj: GObject, propertyName: cstring, value: pointer)
proc g_object_get_property*(obj: GObject, propertyName: cstring, value: pointer)
```

**Что делает.** Устанавливают/читают **одно** свойство по имени через объект `GValue` (типизированный контейнер значения GObject, отдельный от `GVariant` из раздела IV, хотя и похожий по назначению) — более низкоуровневая альтернатива `g_object_set`/`get`, требующая самостоятельно подготовить и инициализировать `GValue` нужного типа (функции работы с `GValue` не входят в этот справочник). На практике `g_object_set`/`get` из предыдущего подраздела удобнее для большинства случаев — эта пара нужна в первую очередь при написании обобщённого кода, работающего со свойствами произвольного типа через интроспекцию, не знающего заранее, с каким конкретно типом значения имеет дело.

- `obj` — объект.
- `propertyName` — имя свойства.
- `value` — указатель на подготовленный `GValue` (не сырое значение напрямую).

```nim
# gvalue должен быть заранее инициализирован через g_value_init с нужным GType
g_object_get_property(cast[GObject](someWidget), "visible", addr gvalue)
echo "Значение свойства 'visible' прочитано в GValue"
```

---

### Уведомления об изменении: `g_object_notify` и родственные

```nim
proc g_object_notify*(obj: GObject, propertyName: cstring)
proc g_object_notify_by_pspec*(obj: GObject, pspec: pointer)
proc g_object_freeze_notify*(obj: GObject)
proc g_object_thaw_notify*(obj: GObject)
```

**Что делает.** `g_object_notify` вручную эмитирует сигнал `"notify::имя-свойства"` для указанного свойства — GTK делает это автоматически при изменении свойства через штатные сеттеры, явный вызов нужен только при реализации собственных GObject-подклассов с собственными свойствами (тема, выходящая за рамки этого справочника, ориентированного на использование готовых виджетов GTK, а не создание новых классов). `g_object_notify_by_pspec` — то же самое, но по уже полученному объекту спецификации свойства (`GParamSpec`, представленному здесь как `pointer`) вместо строкового имени — быстрее при частых вызовах, поскольку не требует поиска свойства по имени заново каждый раз. `g_object_freeze_notify`/`thaw_notify` временно приостанавливают эмиссию всех уведомлений `"notify::*"` для объекта (полезно при массовом изменении сразу нескольких свойств через `g_object_set`, чтобы подписчики получили одно результирующее уведомление после `thaw_notify`, а не по одному на каждое промежуточное изменение) — вызовы должны быть строго парными.

- `obj` — объект.
- `propertyName` — имя свойства (для `notify`).
- `pspec` — объект спецификации свойства (для `notify_by_pspec`).

```nim
g_object_freeze_notify(cast[GObject](configObject))
g_object_set(cast[GObject](configObject), "width".cstring, 800.cint, "height".cstring, 600.cint, nil)
g_object_thaw_notify(cast[GObject](configObject))
echo "Оба свойства изменены, подписчики получат уведомления одним пакетом после thaw_notify"
```

---

### Произвольные данные по строковому ключу: `g_object_set_data` и родственные

```nim
proc g_object_set_data*(obj: GObject, key: cstring, data: gpointer)
proc g_object_get_data*(obj: GObject, key: cstring): gpointer
proc g_object_set_data_full*(obj: GObject, key: cstring, data: gpointer, destroy: pointer)
proc g_object_steal_data*(obj: GObject, key: cstring): gpointer
```

**Что делает.** Прикрепляют к любому GObject-объекту произвольные данные приложения по строковому ключу — способ связать с существующим виджетом дополнительную информацию, для которой у самого класса виджета нет предназначенного свойства (например, привязать к строке `GtkListBoxRow` идентификатор записи в базе данных, из которой эта строка была построена). `set_data_full` — то же самое, но с функцией `destroy`, которая будет вызвана автоматически, когда объект уничтожается или когда те же данные по тому же ключу перезаписываются новыми, — нужна, если `data` сама владеет ресурсами, которые надо освободить (например, указатель на выделенную в куче Nim-структуру, зарегистрированную через `GC_ref`, — вне рамок этого справочника). `get_data` читает данные, оставляя их прикреплёнными; `steal_data` читает и одновременно отсоединяет данные от объекта, не вызывая функцию `destroy`, даже если она была задана через `set_data_full`, — то есть передаёт ответственность за данные вызывающему коду.

- `obj` — объект.
- `key` — строковый ключ.
- `data` — произвольные данные (`gpointer`).
- `destroy` (для `set_data_full`) — функция очистки данных.

```nim
g_object_set_data(cast[GObject](contactRow), "contact-id", cast[gpointer](contactId))
# ... позже, например в обработчике клика по строке ...
let storedId = g_object_get_data(cast[GObject](contactRow), "contact-id")
echo "Идентификатор контакта, прикреплённый к строке списка, получен"
```

---

### Слабые ссылки: `g_object_weak_ref` и родственные

```nim
proc g_object_weak_ref*(obj: GObject, notify: pointer, data: gpointer)
proc g_object_weak_unref*(obj: GObject, notify: pointer, data: gpointer)
proc g_object_add_weak_pointer*(obj: GObject, weakPointerLocation: ptr gpointer)
proc g_object_remove_weak_pointer*(obj: GObject, weakPointerLocation: ptr gpointer)
```

**Что делает.** Слабая ссылка не увеличивает счётчик ссылок объекта (в отличие от `g_object_ref`) и поэтому не мешает объекту быть уничтоженным, но позволяет узнать **момент** его уничтожения. `g_object_weak_ref` регистрирует функцию обратного вызова `notify` (C-совместимую, вызываемую с `data` и указателем на уничтожаемый объект), срабатывающую именно в момент уничтожения объекта, — полезно, чтобы, например, очистить внешнюю структуру данных, ссылающуюся на этот объект, не дожидаясь явного уведомления откуда-то ещё. `g_object_add_weak_pointer` — более простой вариант: не функция обратного вызова, а просто адрес Nim/C-переменной (`weakPointerLocation`), которую GTK сама обнулит (`nil`) в момент уничтожения объекта, — удобно, когда единственное, что нужно, — не дать переменной содержать "болтающийся" указатель на уже уничтоженный объект.

- `obj` — объект.
- `notify` — функция обратного вызова (для `weak_ref`).
- `data` — произвольные данные, передаваемые в `notify`.
- `weakPointerLocation` — адрес переменной-указателя, которую нужно обнулить при уничтожении.

```nim
var widgetPointer: gpointer = cast[gpointer](temporaryPopover)
g_object_add_weak_pointer(cast[GObject](temporaryPopover), addr widgetPointer)
# ... после того как всплывающее окно может быть уничтожено где-то в другом месте кода ...
if isNil(widgetPointer):
  echo "Всплывающее окно уже уничтожено — не пытаемся обращаться к нему повторно"
```

---

### Toggle references: `g_object_add_toggle_ref`

```nim
proc g_object_add_toggle_ref*(obj: GObject, notify: pointer, data: gpointer)
proc g_object_remove_toggle_ref*(obj: GObject, notify: pointer, data: gpointer)
```

**Что делает.** Специализированный механизм отслеживания, когда счётчик ссылок объекта переходит между значением "1" и "больше 1" в любую сторону, — предназначен почти исключительно для реализации биндингов GObject к другим языкам (в том числе, косвенно, для механизмов, похожих на то, чем является сама эта обёртка — Nim-биндинг к GTK), позволяя языку с собственным сборщиком мусора синхронизировать время жизни своего Nim/managed-объекта-обёртки с реальным временем жизни GObject-объекта. Для прикладного кода, использующего готовые виджеты GTK через эту обёртку, toggle references практически никогда не нужны напрямую — упомянуты здесь для полноты, поскольку функции присутствуют в наборе.

- `obj` — объект.
- `notify` — функция обратного вызова, получающая флаг, стал ли счётчик равен `1` или больше.
- `data` — произвольные данные, передаваемые в `notify`.

```nim
# Специализированный сценарий — типовому прикладному коду эта пара функций не требуется.
```

---

### Информация о типе: `g_object_get_type` и родственные

```nim
proc g_object_get_type*(): GType
proc g_object_class_find_property*(oclass: pointer, propertyName: cstring): pointer
proc g_object_class_list_properties*(oclass: pointer, nProperties: ptr cuint): ptr pointer
```

**Что делает.** `g_object_get_type` возвращает `GType` — числовой идентификатор типа `GObject` в системе типов GLib (базовый тип, от которого наследуются все остальные GObject-классы; аналогичные `_get_type`-функции существуют почти у каждого класса GTK, например `gtk_button_get_type`, хотя и не заведены отдельно в этой обёртке для каждого виджета). `g_object_class_find_property`/`g_object_class_list_properties` — интроспекция: поиск описания конкретного свойства класса и получение полного списка всех свойств класса по объекту класса (`GObjectClass*`, получаемому через отдельные функции системы типов, не входящие в эту обёртку) — используются при написании обобщённого кода инспекции объектов (например, автоматического построения формы редактирования по списку свойств произвольного объекта), не для повседневной работы с конкретными известными виджетами.

- `oclass` — указатель на структуру класса.
- `propertyName` — имя свойства (для `find_property`).
- `nProperties` — указатель, в который будет записано количество найденных свойств (для `list_properties`).

```nim
echo "GType базового класса GObject: ", g_object_get_type()
```

---

### Создание объектов: `g_object_new` / `g_object_newv`

```nim
proc g_object_new*(objectType: GType, firstPropertyName: cstring): gpointer {.varargs.}
proc g_object_newv*(objectType: GType, nParameters: cuint, parameters: pointer): gpointer
```

**Что делает.** Создают новый экземпляр GObject-класса по его `GType`, сразу устанавливая часть свойств через конструктор, — универсальный низкоуровневый способ создания объекта, лежащий в основе того, как под капотом устроены все специализированные конструкторы вроде `gtk_button_new`/`gtk_window_new` из предыдущих справочников. `g_object_new` принимает свойства как чередующиеся пары (имя, значение) вариативным списком, завершённым `nil` — тот же протокол, что у `g_object_set`. `g_object_newv` — версия с явным массивом параметров вместо вариативного списка (используется реже, в основном при динамическом построении списка свойств во время выполнения, когда их количество заранее не известно на этапе написания кода).

- **Реализация.** Для всех виджетов, для которых в этой обёртке уже есть специализированный конструктор (`gtk_button_new`, `gtk_label_new` и т.д.), нет практической причины использовать `g_object_new` напрямую — специализированные конструкторы проще, типобезопаснее и покрывают всё, что нужно прикладному коду; `g_object_new` актуален для GObject-классов вне GTK-виджетов, не имеющих отдельного конструктора в этой обёртке.

- `objectType` — `GType` создаваемого класса.
- `firstPropertyName`, далее пары (имя, значение), завершённые `nil`.

```nim
# Пример условный — для реальных виджетов GTK предпочтительны специализированные
# конструкторы вроде gtk_button_new, а не прямой вызов g_object_new.
let obj = g_object_new(someCustomType, "some-property".cstring, 42.cint, nil)
echo "Объект создан напрямую через систему типов GObject"
```

---

### Данные по GQuark: `g_object_set_qdata` и родственные

```nim
proc g_object_set_qdata*(obj: GObject, quark: GQuark, data: gpointer)
proc g_object_get_qdata*(obj: GObject, quark: GQuark): gpointer
proc g_object_set_qdata_full*(obj: GObject, quark: GQuark, data: gpointer, destroy: pointer)
proc g_object_steal_qdata*(obj: GObject, quark: GQuark): gpointer
```

**Что делает.** Функционально идентичны `g_object_set_data`/`get_data`/`set_data_full`/`steal_data` (см. выше), но используют предварительно интернированный `GQuark` (раздел про кварки ниже) вместо строки в качестве ключа — быстрее при частых обращениях по одному и тому же ключу, поскольку сравнение целых чисел `GQuark` быстрее сравнения строк, но требует сначала получить сам `GQuark` через `g_quark_from_string`. Оправдано в горячих участках кода с частыми обращениями к прикреплённым данным; для разового или редкого использования разница непринципиальна, и строковый вариант проще.

- `obj` — объект.
- `quark` — интернированный идентификатор ключа.
- `data` — произвольные данные.
- `destroy` (для `set_qdata_full`) — функция очистки данных.

```nim
let contactIdQuark = g_quark_from_string("contact-id")
g_object_set_qdata(cast[GObject](contactRow), contactIdQuark, cast[gpointer](contactId))
echo "Данные прикреплены по предварительно интернированному ключу"
```

---

### Связывание свойств: `g_object_bind_property`

```nim
proc g_object_bind_property*(source: GObject, sourceProperty: cstring, target: GObject, targetProperty: cstring, flags: GBindingFlags): pointer
proc g_object_bind_property_full*(source: GObject, sourceProperty: cstring, target: GObject, targetProperty: cstring, flags: GBindingFlags, transformTo: pointer, transformFrom: pointer, userData: gpointer, notify: pointer): pointer
```

**Что делает.** Автоматически синхронизируют свойство одного объекта со свойством другого, без необходимости вручную подключать сигнал `"notify::свойство"` и писать код синхронизации самостоятельно, — например, чтобы чувствительность кнопки автоматически следовала за состоянием флажка (см. раздел VI, «Привязка чувствительности кнопки»). `flags` определяет режим: `G_BINDING_DEFAULT` — при изменении `source` обновляется `target`, один раз в момент создания привязки синхронизация не выполняется; `G_BINDING_SYNC_CREATE` — дополнительно сразу синхронизировать `target` со значением `source` при создании привязки (используется почти всегда вместе с остальными флагами); `G_BINDING_BIDIRECTIONAL` — синхронизация в обе стороны, а не только от `source` к `target`; `G_BINDING_INVERT_BOOLEAN` — для булевых свойств инвертирует значение при синхронизации (`target` получает `not source`). `g_object_bind_property_full` — расширенный вариант с произвольными функциями преобразования значения между несовместимыми типами свойств (`transformTo`/`transformFrom`) — обычная `bind_property` работает только когда оба свойства одного типа или GTK умеет преобразовать их автоматически (например, `gint`↔`gdouble`).

- `source`, `target` — связываемые объекты.
- `sourceProperty`, `targetProperty` — имена свойств.
- `flags` — битовая маска `GBindingFlags`.

```nim
discard g_object_bind_property(cast[GObject](enableFeatureCheck), "active",
                                cast[GObject](featureOptionsBox), "sensitive",
                                G_BINDING_SYNC_CREATE)
echo "Область настроек функции автоматически включается/выключается вместе с флажком"
```

---

### `g_quark_from_string` / `g_quark_to_string` / `g_quark_try_string`

```nim
proc g_quark_from_string*(str: cstring): GQuark
proc g_quark_to_string*(quark: GQuark): cstring
proc g_quark_try_string*(str: cstring): GQuark
```

**Что делает.** `GQuark` — целочисленный идентификатор, взаимно однозначно соответствующий строке, "интернированной" (зарегистрированной) в глобальной таблице GLib один раз за всё время работы процесса, — используется вместо строк там, где важна скорость сравнения (см. `g_object_set_qdata` выше, а также домены ошибок `GError`, не входящие в отдельный разбор в этом справочнике). `g_quark_from_string` возвращает существующий `GQuark` для строки, если она уже была интернирована ранее где-либо в процессе, либо создаёт новую запись — вызывать можно многократно с одной и той же строкой, результат всегда один и тот же числовой идентификатор. `g_quark_to_string` — обратная операция. `g_quark_try_string` отличается от `from_string` тем, что **не создаёт** новую запись, если строка ещё не была интернирована, а возвращает `0` — полезно, когда нужно только проверить, встречалась ли строка раньше, не создавая новую запись впустую.

- `str` — строка.
- `quark` — идентификатор `GQuark`.

```nim
let quark1 = g_quark_from_string("contact-id")
let quark2 = g_quark_from_string("contact-id")
echo "Оба обращения вернули один и тот же идентификатор: ", quark1 == quark2  # выводит "true"
```

---

## Практические рецепты

### Простой рисунок на GtkDrawingArea через Cairo

Минимальная область рисования, закрашивающая себя фоном и рисующая круг — только показывает, куда встраивается код Cairo, не разбирая сам API Cairo подробно.

```nim
proc onDrawCircle(area: GtkDrawingArea, cr: pointer, width: gint, height: gint, userData: gpointer) {.cdecl.} =
  # Здесь используются функции cairo_* для рисования в контексте cr:
  # cairo_set_source_rgb(cr, ...), cairo_arc(cr, ...), cairo_fill(cr) и т.п.
  echo "Рисуем круг в области ", width, "×", height

proc buildSimpleCanvas(): GtkDrawingArea =
  result = gtk_drawing_area_new()
  gtk_drawing_area_set_content_width(result, 200)
  gtk_drawing_area_set_content_height(result, 200)
  gtk_drawing_area_set_draw_func(result, onDrawCircle, nil, nil)
  echo "Холст 200×200 с функцией отрисовки круга готов"

let canvas = buildSimpleCanvas()
```

---

### Загрузка глобальной CSS-темы приложения

Типичное место для загрузки CSS — сразу после инициализации GTK, до показа первого окна, чтобы стили сразу применялись ко всем последующим виджетам.

```nim
proc loadApplicationTheme() =
  let provider = gtk_css_provider_new()
  gtk_css_provider_load_from_path(provider, "/usr/share/myapp/theme.css")
  let display = gdk_display_get_default()
  gtk_style_context_add_provider_for_display(display, cast[pointer](provider), 600)
  echo "Глобальная тема приложения загружена и применена ко всем окнам"

proc onActivate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  loadApplicationTheme()
  # ... создание главного окна ...
```

---

### Привязка чувствительности кнопки к состоянию флажка без единой строки кода в обработчике

`g_object_bind_property` заменяет ручное подключение сигнала `"toggled"` и написание синхронизирующего обработчика.

```nim
proc buildAutoLinkedControls(): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)

  let enableCheck = gtk_check_button_new_with_label("Включить уведомления по email")
  let emailEntry = gtk_entry_new()
  gtk_entry_set_placeholder_text(emailEntry, "you@example.com")

  discard g_object_bind_property(cast[GObject](enableCheck), "active",
                                  cast[GObject](emailEntry), "sensitive",
                                  G_BINDING_SYNC_CREATE)

  gtk_box_append(result, enableCheck)
  gtk_box_append(result, emailEntry)
  echo "Поле email автоматически доступно только при включённом флажке — без ручного обработчика"

let notificationSettings = buildAutoLinkedControls()
```

---

### Прикрепление собственных данных к виджету по строковому ключу

Строка списка контактов хранит идентификатор записи в базе данных, извлекаемый позже в обработчике клика.

```nim
proc buildContactRow(contactId: int, name: string): GtkWidget =
  result = gtk_label_new(name.cstring)
  g_object_set_data(cast[GObject](result), "contact-id", cast[gpointer](contactId))

proc onRowActivated(box: GtkListBox, row: GtkListBoxRow, userData: gpointer) {.cdecl.} =
  let rowChild = gtk_list_box_row_get_child(row)
  let storedId = g_object_get_data(cast[GObject](rowChild), "contact-id")
  echo "Активирована строка с прикреплённым id контакта: ", cast[int](storedId)

let contactsList = gtk_list_box_new()
gtk_list_box_append(contactsList, buildContactRow(42, "Анна Иванова"))
discard g_signal_connect(contactsList, "row-activated", onRowActivated, nil)
```

---

### Передача составного значения через GVariant в обработчик действия

Действие с параметром (например, переключение режима отображения), где выбранный вариант передаётся как строковый `GVariant`.

```nim
proc onSetViewMode(action: pointer, parameter: GVariant, userData: gpointer) {.cdecl.} =
  let mode = $g_variant_get_string(parameter, nil)
  echo "Переключение режима отображения на: ", mode

# Само действие регистрируется через g_action_map_add_action (справочник ACTIONS),
# здесь показано только чтение переданного через GVariant параметра.

let gridModeTarget = g_variant_new_string("grid")
gtk_actionable_set_action_target_value(gridViewButton, gridModeTarget)
echo "Кнопка переключения на сетку передаёт действию строковый параметр 'grid'"
```

---

## Краткая таблица

| Процедура(ы) | Категория | Что делает вкратце |
|---|---|---|
| `gtk_drawing_area_new` | DrawingArea | Создать пустой холст |
| `gtk_drawing_area_set/get_content_width/height` | DrawingArea | Предпочитаемый размер содержимого |
| `gtk_drawing_area_set_draw_func` | DrawingArea | Назначить функцию отрисовки через Cairo |
| `gtk_css_provider_new` | CssProvider | Создать провайдер стилей |
| `gtk_css_provider_load_from_data/file/path/string` | CssProvider | Загрузить CSS из разных источников |
| `gtk_widget_get_style_context`, `gtk_style_context_add_provider` | StyleContext | Применить стили к одному виджету и его потомкам |
| `gtk_style_context_add_provider_for_display`, `gtk_widget_get_display`, `gdk_display_get_default` | StyleContext/Display | Применить стили глобально ко всем окнам дисплея |
| `g_file_new_for_path`, `get_path`, `get_basename` | GFile | Создать объект файла из пути / прочитать путь и имя |
| `g_error_free` | GError | Освободить объект ошибки |
| `g_variant_new_string/boolean/int32` | GVariant | Обернуть значение в типизированный контейнер |
| `g_variant_get_string/boolean/int32` | GVariant | Извлечь значение обратно |
| `g_object_ref`, `unref`, `ref_sink`, `is_floating`, `force_floating` | GObject | Счётчик ссылок и плавающее состояние |
| `g_object_set`, `get` | GObject | Несколько свойств по именам за один вызов |
| `g_object_set/get_property` | GObject | Одно свойство через GValue |
| `g_object_notify`, `notify_by_pspec`, `freeze/thaw_notify` | GObject | Уведомления об изменении свойств |
| `g_object_set/get_data`, `set_data_full`, `steal_data` | GObject | Произвольные данные по строковому ключу |
| `g_object_weak_ref/unref`, `add/remove_weak_pointer` | GObject | Отслеживание уничтожения объекта без владения им |
| `g_object_add/remove_toggle_ref` | GObject | Специализированная синхронизация для языковых биндингов |
| `g_object_get_type`, `class_find_property`, `class_list_properties` | GObject | Интроспекция типа и его свойств |
| `g_object_new`, `newv` | GObject | Низкоуровневое создание объекта по GType |
| `g_object_set/get_qdata`, `set_qdata_full`, `steal_qdata` | GObject | Произвольные данные по GQuark (быстрее строк) |
| `g_object_bind_property`, `bind_property_full` | GObject | Автоматическая синхронизация свойств двух объектов |
| `g_quark_from_string`, `to_string`, `try_string` | GObject | Интернированные строковые идентификаторы |

---

## Сводка: какую процедуру выбрать

- **Произвольная графика, не выражаемая готовыми виджетами** (графики, кастомные визуализации, игровое поле) → `GtkDrawingArea` + `gtk_drawing_area_set_draw_func`, а не пытаться собрать нужный вид из комбинации существующих виджетов.
- **Стилизовать один конкретный виджет** (и его потомков) → `gtk_widget_get_style_context` + `gtk_style_context_add_provider`. **Стилизовать всё приложение целиком** (общая тема) → `gtk_style_context_add_provider_for_display`, вызванный один раз при старте приложения, а не повторение первого способа для каждого окна вручную.
- **Свойство виджета, у которого уже есть типобезопасная пара `set_X`/`get_X` в этой обёртке** → всегда предпочитать её. **Свойство, для которого специализированной пары нет** (редкие или специфичные для отдельных версий GTK свойства) → `g_object_set`/`get` по строковому имени как запасной вариант.
- **Нужно синхронизировать состояние двух виджетов** (чувствительность, видимость, значение) → `g_object_bind_property` вместо ручного подключения сигнала `"notify::..."` и написания кода синхронизации — особенно если синхронизация должна быть двунаправленной (`G_BINDING_BIDIRECTIONAL`) или с инверсией булева значения (`G_BINDING_INVERT_BOOLEAN`).
- **Прикрепить дополнительные данные приложения к существующему виджету** → `g_object_set_data`/`get_data` для разового/нечастого использования по понятному строковому ключу; `g_object_set_qdata`/`get_qdata` с предварительно полученным `GQuark` — если один и тот же ключ используется очень часто и важна скорость сравнения.
- **Нужно знать, когда объект будет уничтожен, не владея им самим** (не мешая его уничтожению) → `g_object_add_weak_pointer` для простого случая "обнулить переменную"; `g_object_weak_ref` — если нужна произвольная логика в момент уничтожения, а не только обнуление указателя.
- **Виджет создаётся и сразу добавляется в контейнер обычным способом** → управлять счётчиком ссылок вручную (`g_object_ref`/`unref`) не требуется — контейнер сам заберёт плавающую ссылку. Ручное управление нужно только когда объект должен пережить временное отсутствие владельца-контейнера.
