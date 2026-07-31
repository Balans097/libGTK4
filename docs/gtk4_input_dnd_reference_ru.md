# GTK4 (input: GtkEventController / gestures / Drag-and-Drop) — справочник модуля

> **Импорт:** `import libGTK4`
> **Область применения:** современная система обработки ввода в GTK4 — контроллеры событий и жесты (замена устаревших сигналов вроде `"button-press-event"` из GTK3), плюс перетаскивание объектов между виджетами (Drag-and-Drop). Пятнадцатая часть серии справочников по обёртке; предполагает знакомство с `gtk4_core_reference_ru.md` (`GtkWidget`, `g_signal_connect`).

В GTK4 обработка ввода строится вокруг **контроллеров** (`GtkEventController` и его подтипы) — объектов, которые присоединяются к виджету через `gtk_widget_add_controller` и подписываются на определённый класс событий (клики, перетаскивание мышью, нажатия клавиш, движение курсора, прокрутка). Жесты (`GtkGesture` и его подтипы — `GtkGestureClick`, `GtkGestureDrag` и т.д.) — это специализированные контроллеры, распознающие составные многошаговые взаимодействия (не просто "кнопка нажата", а "кнопка нажата, затем отпущена в пределах небольшого времени и небольшого смещения — это клик").

**Важное ограничение для параметров этого раздела:** в этой обёртке `GtkPropagationPhase`, `GtkPropagationLimit`, действия Drag-and-Drop (`GdkDragAction`) и флаги прокрутки не заведены именованными enum-типами — соответствующие параметры (`phase`, `limit`, `actions`, `flags`) передаются как обычные `gint`/`cint`, и точные числовые значения нужно сверять с реальными заголовками GTK4 (например, `GTK_PHASE_BUBBLE = 1` — фаза распространения событий по умолчанию, `GDK_ACTION_COPY = 1` — действие копирования при перетаскивании). В примерах ниже такие значения указаны там, где это принципиально для работы примера, с пояснением в комментарии.

---

## Оглавление

I. [GtkEventController (общий базовый интерфейс)](#gtkeventcontroller-общий-базовый-интерфейс)
&nbsp;&nbsp;1. [`gtk_widget_add_controller` / `gtk_widget_remove_controller`](#gtk_widget_add_controller--gtk_widget_remove_controller)
&nbsp;&nbsp;2. [`gtk_event_controller_get_widget`](#gtk_event_controller_get_widget)
&nbsp;&nbsp;3. [`gtk_event_controller_set/get_propagation_phase`](#gtk_event_controller_setget_propagation_phase)
&nbsp;&nbsp;4. [`gtk_event_controller_set/get_propagation_limit`](#gtk_event_controller_setget_propagation_limit)
&nbsp;&nbsp;5. [`gtk_event_controller_set/get_name`](#gtk_event_controller_setget_name)
&nbsp;&nbsp;6. [`gtk_event_controller_reset`](#gtk_event_controller_reset)

II. [GtkGesture (общий базовый интерфейс жестов)](#gtkgesture-общий-базовый-интерфейс-жестов)
&nbsp;&nbsp;1. [`gtk_gesture_is_active` / `gtk_gesture_is_recognized`](#gtk_gesture_is_active--gtk_gesture_is_recognized)
&nbsp;&nbsp;2. [`gtk_gesture_get_point` / `gtk_gesture_get_bounding_box`, `_center`](#gtk_gesture_get_point--gtk_gesture_get_bounding_box-_center)
&nbsp;&nbsp;3. [`gtk_gesture_set_state` / `gtk_gesture_get_sequence_state`, `set_sequence_state`](#gtk_gesture_set_state--gtk_gesture_get_sequence_state-set_sequence_state)
&nbsp;&nbsp;4. [`gtk_gesture_group` / `gtk_gesture_ungroup` / `gtk_gesture_is_grouped_with`](#gtk_gesture_group--gtk_gesture_ungroup--gtk_gesture_is_grouped_with)

III. [GtkGestureSingle (общий интерфейс однопользовательских жестов)](#gtkgesturesingle-общий-интерфейс-однопользовательских-жестов)
&nbsp;&nbsp;1. [`gtk_gesture_single_set/get_button`](#gtk_gesture_single_setget_button)
&nbsp;&nbsp;2. [`gtk_gesture_single_set/get_touch_only`](#gtk_gesture_single_setget_touch_only)
&nbsp;&nbsp;3. [`gtk_gesture_single_set/get_exclusive`](#gtk_gesture_single_setget_exclusive)

IV. [Конкретные жесты](#конкретные-жесты)
&nbsp;&nbsp;1. [`gtk_gesture_click_new`](#gtk_gesture_click_new)
&nbsp;&nbsp;2. [`gtk_gesture_drag_new`, `get_start_point`, `get_offset`](#gtk_gesture_drag_new-get_start_point-get_offset)
&nbsp;&nbsp;3. [`gtk_gesture_long_press_new`, `set/get_delay_factor`](#gtk_gesture_long_press_new-setget_delay_factor)
&nbsp;&nbsp;4. [`gtk_gesture_swipe_new`, `get_velocity`](#gtk_gesture_swipe_new-get_velocity)
&nbsp;&nbsp;5. [`gtk_gesture_rotate_new`, `get_angle_delta`](#gtk_gesture_rotate_new-get_angle_delta)
&nbsp;&nbsp;6. [`gtk_gesture_zoom_new`, `get_scale_delta`](#gtk_gesture_zoom_new-get_scale_delta)

V. [Конкретные контроллеры (не жесты)](#конкретные-контроллеры-не-жесты)
&nbsp;&nbsp;1. [`gtk_event_controller_key_new` и родственные](#gtk_event_controller_key_new-и-родственные)
&nbsp;&nbsp;2. [`gtk_event_controller_focus_new`, `contains_focus`, `is_focus`](#gtk_event_controller_focus_new-contains_focus-is_focus)
&nbsp;&nbsp;3. [`gtk_event_controller_motion_new`, `contains_pointer`, `is_pointer`](#gtk_event_controller_motion_new-contains_pointer-is_pointer)
&nbsp;&nbsp;4. [`gtk_event_controller_scroll_new` и родственные](#gtk_event_controller_scroll_new-и-родственные)

VI. [Drag-and-Drop: GtkDragSource](#drag-and-drop-gtkdragsource)
&nbsp;&nbsp;1. [`gtk_drag_source_new`](#gtk_drag_source_new)
&nbsp;&nbsp;2. [`gtk_drag_source_set/get_content`](#gtk_drag_source_setget_content)
&nbsp;&nbsp;3. [`gtk_drag_source_set/get_actions`](#gtk_drag_source_setget_actions)
&nbsp;&nbsp;4. [`gtk_drag_source_set_icon`](#gtk_drag_source_set_icon)
&nbsp;&nbsp;5. [`gtk_drag_source_drag_cancel` / `gtk_drag_source_get_drag`](#gtk_drag_source_drag_cancel--gtk_drag_source_get_drag)

VII. [Drag-and-Drop: GtkDropTarget](#drag-and-drop-gtkdroptarget)
&nbsp;&nbsp;1. [`gtk_drop_target_new`](#gtk_drop_target_new)
&nbsp;&nbsp;2. [`gtk_drop_target_set/get_gtypes`](#gtk_drop_target_setget_gtypes)
&nbsp;&nbsp;3. [`gtk_drop_target_set/get_actions`](#gtk_drop_target_setget_actions)
&nbsp;&nbsp;4. [`gtk_drop_target_set/get_preload`](#gtk_drop_target_setget_preload)
&nbsp;&nbsp;5. [`gtk_drop_target_get_value` / `get_drop` / `get_current_drop` / `get_formats` / `reject`](#gtk_drop_target_get_value--get_drop--get_current_drop--get_formats--reject)

VIII. [Практические рецепты](#практические-рецепты)
&nbsp;&nbsp;1. [Клик правой кнопкой мыши для контекстного меню](#клик-правой-кнопкой-мыши-для-контекстного-меню)
&nbsp;&nbsp;2. [Перетаскивание виджета мышью внутри области](#перетаскивание-виджета-мышью-внутри-области)
&nbsp;&nbsp;3. [Долгое нажатие для мобильного жеста контекстного меню](#долгое-нажатие-для-мобильного-жеста-контекстного-меню)
&nbsp;&nbsp;4. [Перетаскивание текста из одного поля в другое](#перетаскивание-текста-из-одного-поля-в-другое)
&nbsp;&nbsp;5. [Реакция на наведение курсора (hover) на карточку](#реакция-на-наведение-курсора-hover-на-карточку)

IX. [Краткая таблица](#краткая-таблица)

X. [Сводка: какую процедуру выбрать](#сводка-какую-процедуру-выбрать)

---

## GtkEventController (общий базовый интерфейс)

Все конкретные контроллеры и жесты этого справочника — подтипы `GtkEventController`. Функции этого раздела применимы к любому из них напрямую (в этой обёртке параметр типа `GtkEventController` принимает `pointer`, поэтому конкретный жест/контроллер передаётся без явного приведения типов).

### `gtk_widget_add_controller` / `gtk_widget_remove_controller`

```nim
proc gtk_widget_add_controller*(widget: GtkWidget, controller: GtkEventController)
proc gtk_widget_remove_controller*(widget: GtkWidget, controller: GtkEventController)
```

**Что делает.** Присоединяют/отсоединяют контроллер к виджету — без этого созданный жест/контроллер ни на что не влияет, он должен быть явно добавлен к виджету, события которого должен обрабатывать. Один виджет может иметь несколько разных контроллеров одновременно (например, отдельно `GtkGestureClick` для кликов и `GtkEventControllerMotion` для наведения).

- `widget` — виджет, к которому добавляется/от которого убирается контроллер.
- `controller` — жест или контроллер (любой из подтипов `GtkEventController`).

```nim
let clickGesture = gtk_gesture_click_new()
gtk_widget_add_controller(someWidget, clickGesture)
echo "Жест клика присоединён к виджету"
```

---

### `gtk_event_controller_get_widget`

```nim
proc gtk_event_controller_get_widget*(controller: GtkEventController): GtkWidget
```

**Что делает.** Возвращает виджет, к которому присоединён контроллер, — обратная операция к `add_controller`, полезна внутри обработчика сигнала контроллера, когда сам виджет не был явно передан через `userData`.

- `controller` — контроллер/жест.

```nim
let owningWidget = gtk_event_controller_get_widget(clickGesture)
echo "Виджет, к которому присоединён жест, получен"
```

---

### `gtk_event_controller_set/get_propagation_phase`

```nim
proc gtk_event_controller_set_propagation_phase*(controller: GtkEventController, phase: gint)
proc gtk_event_controller_get_propagation_phase*(controller: GtkEventController): gint
```

**Что делает.** Задают, на каком этапе распространения события по дереву виджетов срабатывает контроллер — GTK4 распространяет события в три фазы: сначала "сверху вниз" от окна к целевому виджету (`GTK_PHASE_CAPTURE = 0`), затем непосредственно на самом целевом виджете, затем "снизу вверх" обратно к окну (`GTK_PHASE_BUBBLE = 1` — значение по умолчанию для большинства контроллеров). `GTK_PHASE_NONE = 2` отключает автоматическое срабатывание вовсе — контроллер реагирует только на события, явно перенаправленные ему вручную (например, через `gtk_event_controller_key_forward`, раздел V). Фаза capture нужна, когда родительский контейнер должен перехватить событие раньше, чем оно дойдёт до дочернего виджета — например, для реализации собственных горячих клавиш, которые должны срабатывать даже когда фокус находится в текстовом поле.

- `controller` — контроллер/жест.
- `phase` — числовое значение фазы (`0` = capture, `1` = bubble, `2` = none — именованных констант в этой обёртке нет).

```nim
gtk_event_controller_set_propagation_phase(clickGesture, 1)  # 1 = GTK_PHASE_BUBBLE, значение по умолчанию
echo "Жест будет реагировать на обычной фазе всплытия события"
```

---

### `gtk_event_controller_set/get_propagation_limit`

```nim
proc gtk_event_controller_set_propagation_limit*(controller: GtkEventController, limit: gint)
proc gtk_event_controller_get_propagation_limit*(controller: GtkEventController): gint
```

**Что делает.** Ограничивают, насколько далеко за пределы виджета, к которому присоединён контроллер, может распространяться срабатывающее событие — `GTK_LIMIT_NONE = 0` (без ограничений, значение по умолчанию) или `GTK_LIMIT_SAME_NATIVE = 1` (событие не пересекает границу "нативного" окна — актуально в первую очередь для встраиваемых поповеров/всплывающих окон с собственной системной поверхностью). Специализированная настройка, для большинства прикладного кода значение по умолчанию не требует изменения.

- `controller` — контроллер/жест.
- `limit` — числовое значение ограничения (`0`/`1` — именованных констант в этой обёртке нет).

```nim
echo "Текущий предел распространения: ", gtk_event_controller_get_propagation_limit(clickGesture)
```

---

### `gtk_event_controller_set/get_name`

```nim
proc gtk_event_controller_set_name*(controller: GtkEventController, name: cstring)
proc gtk_event_controller_get_name*(controller: GtkEventController): cstring
```

**Что делает.** Задают и читают произвольное строковое имя контроллера — чисто для удобства отладки/диагностики (например, чтобы отличить друг от друга несколько похожих контроллеров, присоединённых к одному виджету, при логировании), не влияет на поведение.

- `controller` — контроллер/жест.
- `name` — произвольное имя.

```nim
gtk_event_controller_set_name(clickGesture, "primary-click-gesture")
echo "Контроллер получил отладочное имя: ", $gtk_event_controller_get_name(clickGesture)
```

---

### `gtk_event_controller_reset`

```nim
proc gtk_event_controller_reset*(controller: GtkEventController)
```

**Что делает.** Принудительно сбрасывает внутреннее состояние контроллера в исходное — например, для жеста перетаскивания это отменит текущее незавершённое перетаскивание, как если бы пользователь отпустил кнопку мыши. Нужен в редких случаях программного вмешательства в незавершённое взаимодействие (например, если виджет программно скрывается посреди перетаскивания и нужно явно "остановить" жест, а не оставить его в подвешенном состоянии).

- `controller` — контроллер/жест.

```nim
gtk_event_controller_reset(dragGesture)
echo "Состояние жеста перетаскивания сброшено"
```

---

## GtkGesture (общий базовый интерфейс жестов)

Функции этого раздела применимы к любому конкретному жесту как к общему `GtkGesture`.

### `gtk_gesture_is_active` / `gtk_gesture_is_recognized`

```nim
proc gtk_gesture_is_active*(gesture: GtkGesture): gboolean
proc gtk_gesture_is_recognized*(gesture: GtkGesture): gboolean
```

**Что делает.** `is_active` сообщает, отслеживает ли жест прямо сейчас хотя бы одну активную последовательность касаний/нажатий, независимо от того, распознан ли уже сам жест. `is_recognized` — распознан ли жест как таковой; жест может быть активным, но пока не распознанным.

- `gesture` — жест.

```nim
if gtk_gesture_is_recognized(longPressGesture) != 0.gboolean:
  echo "Долгое нажатие распознано"
```

---

### `gtk_gesture_get_point` / `gtk_gesture_get_bounding_box`, `_center`

```nim
proc gtk_gesture_get_point*(gesture: GtkGesture, sequence: pointer, x: ptr gdouble, y: ptr gdouble): gboolean
proc gtk_gesture_get_bounding_box*(gesture: GtkGesture, rect: pointer): gboolean
proc gtk_gesture_get_bounding_box_center*(gesture: GtkGesture, x: ptr gdouble, y: ptr gdouble): gboolean
```

**Что делает.** `get_point` возвращает текущую координату конкретной последовательности касания (`sequence` — идентификатор для мультитач-жестов; `nil` для единственной активной последовательности). `get_bounding_box`/`_center` возвращают прямоугольник (`GdkRectangle`, приведённый к `pointer`), охватывающий все активные точки жеста одновременно.

- `gesture` — жест.
- `sequence` — идентификатор последовательности касания, либо `nil`.
- `x`, `y` — указатели для координат.
- `rect` — указатель на структуру `GdkRectangle`.

```nim
var x, y: gdouble
if gtk_gesture_get_point(clickGesture, nil, addr x, addr y) != 0.gboolean:
  echo "Точка клика: (", x, ", ", y, ")"
```

---

### `gtk_gesture_set_state` / `gtk_gesture_get_sequence_state`, `set_sequence_state`

```nim
proc gtk_gesture_set_state*(gesture: GtkGesture, state: gint): gboolean
proc gtk_gesture_get_sequence_state*(gesture: GtkGesture, sequence: pointer): gint
proc gtk_gesture_set_sequence_state*(gesture: GtkGesture, sequence: pointer, state: gint): gboolean
```

**Что делает.** Управляют тем, заявляет ли жест эксклюзивное владение последовательностью касания (`GTK_EVENT_SEQUENCE_CLAIMED = 1`) — актуально, когда несколько жестов на разных виджетах могли бы претендовать на одно и то же взаимодействие: жест с `CLAIMED` "выигрывает" у остальных, переходящих в `GTK_EVENT_SEQUENCE_DENIED = 2`. `GTK_EVENT_SEQUENCE_NONE = 0` — состояние по умолчанию. `set_state` применяет состояние ко всем последовательностям жеста, `set_sequence_state` — к одной конкретной.

- `gesture` — жест.
- `state` — числовое значение состояния (именованных констант в этой обёртке нет).
- `sequence` — идентификатор конкретной последовательности.

```nim
discard gtk_gesture_set_state(dragGesture, 1)  # 1 = GTK_EVENT_SEQUENCE_CLAIMED
echo "Жест перетаскивания заявил эксклюзивное владение текущим взаимодействием"
```

---

### `gtk_gesture_group` / `gtk_gesture_ungroup` / `gtk_gesture_is_grouped_with`

```nim
proc gtk_gesture_group*(groupGesture: GtkGesture, gesture: GtkGesture)
proc gtk_gesture_ungroup*(gesture: GtkGesture)
proc gtk_gesture_is_grouped_with*(gesture: GtkGesture, other: GtkGesture): gboolean
```

**Что делает.** Объединяют несколько жестов в группу — сгруппированные жесты обрабатывают одни и те же последовательности касаний совместно, ни один не блокирует остальные автоматически.

- `groupGesture`, `gesture` — жесты для объединения.
- `other` — жест, с которым проверяется группировка.

```nim
gtk_gesture_group(rotateGesture, zoomGesture)
echo "Жесты вращения и масштабирования объединены в группу, срабатывают совместно"
```

---

## GtkGestureSingle (общий интерфейс однопользовательских жестов)

`GtkGestureSingle` — база для жестов, обрабатывающих ровно одну точку взаимодействия одновременно (`GtkGestureClick`, `GtkGestureDrag`, `GtkGestureLongPress`).

### `gtk_gesture_single_set/get_button`

```nim
proc gtk_gesture_single_set_button*(gesture: GtkGestureSingle, button: guint)
proc gtk_gesture_single_get_button*(gesture: GtkGestureSingle): guint
```

**Что делает.** Задают, на какую кнопку мыши реагирует жест — `0` означает "любая кнопка" (по умолчанию), `1` — левая, `2` — средняя, `3` — правая.

- `gesture` — жест.
- `button` — номер кнопки, `0` для любой.

```nim
gtk_gesture_single_set_button(contextMenuGesture, 3)
echo "Жест настроен на правую кнопку мыши для контекстного меню"
```

---

### `gtk_gesture_single_set/get_touch_only`

```nim
proc gtk_gesture_single_set_touch_only*(gesture: GtkGestureSingle, touchOnly: gboolean)
proc gtk_gesture_single_get_touch_only*(gesture: GtkGestureSingle): gboolean
```

**Что делает.** Ограничивают жест реакцией только на касания сенсорного экрана, игнорируя мышь/тачпад.

- `gesture` — жест.
- `touchOnly` — `1.gboolean`, чтобы реагировать только на касания.

```nim
gtk_gesture_single_set_touch_only(swipeGesture, 1.gboolean)
echo "Жест свайпа реагирует только на сенсорный экран, не на мышь"
```

---

### `gtk_gesture_single_set/get_exclusive`

```nim
proc gtk_gesture_single_set_exclusive*(gesture: GtkGestureSingle, exclusive: gboolean)
proc gtk_gesture_single_get_exclusive*(gesture: GtkGestureSingle): gboolean
```

**Что делает.** Включают режим, в котором жест игнорируется целиком, если в момент начала уже была активна другая точка касания.

- `gesture` — жест.
- `exclusive` — `1.gboolean` для эксклюзивного режима одной точки.

```nim
gtk_gesture_single_set_exclusive(clickGesture, 1.gboolean)
echo "Жест клика теперь игнорируется полностью, если уже была вторая точка касания"
```

---

## Конкретные жесты

### `gtk_gesture_click_new`

```nim
proc gtk_gesture_click_new*(): GtkGestureClick
```

**Что делает.** Создаёт жест распознавания клика — эмитирует `"pressed"` при нажатии и `"released"` при отпускании, оба с координатами и числом кликов подряд. Управление кнопкой — через `gtk_gesture_single_set_button` из раздела III.

- Параметров нет.

```nim
let clickGesture = gtk_gesture_click_new()

proc onPressed(gesture: GtkGestureClick, nPress: gint, x: gdouble, y: gdouble, userData: gpointer) {.cdecl.} =
  echo "Клик #", nPress, " по координатам (", x, ", ", y, ")"

discard g_signal_connect(clickGesture, "pressed", onPressed, nil)
gtk_widget_add_controller(someWidget, clickGesture)
```

---

### `gtk_gesture_drag_new`, `get_start_point`, `get_offset`

```nim
proc gtk_gesture_drag_new*(): GtkGestureDrag
proc gtk_gesture_drag_get_start_point*(gesture: GtkGestureDrag, x: ptr gdouble, y: ptr gdouble): gboolean
proc gtk_gesture_drag_get_offset*(gesture: GtkGestureDrag, x: ptr gdouble, y: ptr gdouble): gboolean
```

**Что делает.** Распознаёт перетаскивание мышью — эмитирует `"drag-begin"`, `"drag-update"`, `"drag-end"`. `get_start_point` — координата начала перетаскивания. `get_offset` — смещение относительно начальной точки на текущий момент.

- `gesture` — жест перетаскивания.
- `x`, `y` — указатели для координат/смещения.

```nim
proc onDragUpdate(gesture: GtkGestureDrag, offsetX: gdouble, offsetY: gdouble, userData: gpointer) {.cdecl.} =
  echo "Смещение от начала перетаскивания: (", offsetX, ", ", offsetY, ")"

let dragGesture = gtk_gesture_drag_new()
discard g_signal_connect(dragGesture, "drag-update", onDragUpdate, nil)
```

---

### `gtk_gesture_long_press_new`, `set/get_delay_factor`

```nim
proc gtk_gesture_long_press_new*(): GtkGestureLongPress
proc gtk_gesture_long_press_set_delay_factor*(gesture: GtkGestureLongPress, delayFactor: gdouble)
proc gtk_gesture_long_press_get_delay_factor*(gesture: GtkGestureLongPress): gdouble
```

**Что делает.** Распознаёт долгое нажатие без движения — эмитирует `"pressed"` при достаточной задержке. `delay_factor` — множитель к системному стандартному времени (`1.0` — стандартное, `2.0` — вдвое дольше).

- `gesture` — жест долгого нажатия.
- `delayFactor` — множитель к стандартному времени ожидания.

```nim
let longPressGesture = gtk_gesture_long_press_new()
gtk_gesture_long_press_set_delay_factor(longPressGesture, 1.5)
echo "Долгое нажатие срабатывает в полтора раза медленнее стандартного"
```

---

### `gtk_gesture_swipe_new`, `get_velocity`

```nim
proc gtk_gesture_swipe_new*(): GtkGestureSwipe
proc gtk_gesture_swipe_get_velocity*(gesture: GtkGestureSwipe, velocityX: ptr gdouble, velocityY: ptr gdouble): gboolean
```

**Что делает.** Распознаёт быстрый смахивающий жест — эмитирует `"swipe"` по завершении с итоговой скоростью. `get_velocity` — тот же результат вне обработчика сигнала.

- `gesture` — жест свайпа.
- `velocityX`, `velocityY` — указатели для компонент скорости.

```nim
proc onSwipe(gesture: GtkGestureSwipe, velocityX: gdouble, velocityY: gdouble, userData: gpointer) {.cdecl.} =
  if velocityX > 0:
    echo "Свайп вправо со скоростью ", velocityX
  else:
    echo "Свайп влево со скоростью ", -velocityX

let swipeGesture = gtk_gesture_swipe_new()
discard g_signal_connect(swipeGesture, "swipe", onSwipe, nil)
```

---

### `gtk_gesture_rotate_new`, `get_angle_delta`

```nim
proc gtk_gesture_rotate_new*(): GtkGestureRotate
proc gtk_gesture_rotate_get_angle_delta*(gesture: GtkGestureRotate): gdouble
```

**Что делает.** Распознаёт жест вращения двумя пальцами — `get_angle_delta` возвращает накопленный угол поворота в радианах.

- `gesture` — жест вращения.

```nim
let rotateGesture = gtk_gesture_rotate_new()
proc onRotateChanged(gesture: GtkGestureRotate, angle: gdouble, angleDelta: gdouble, userData: gpointer) {.cdecl.} =
  echo "Изображение повёрнуто на ", angleDelta, " радиан от начала жеста"
discard g_signal_connect(rotateGesture, "angle-changed", onRotateChanged, nil)
```

---

### `gtk_gesture_zoom_new`, `get_scale_delta`

```nim
proc gtk_gesture_zoom_new*(): GtkGestureZoom
proc gtk_gesture_zoom_get_scale_delta*(gesture: GtkGestureZoom): gdouble
```

**Что делает.** Распознаёт жест масштабирования "щипок" двумя пальцами — `get_scale_delta` возвращает коэффициент масштаба относительно начала жеста.

- `gesture` — жест масштабирования.

```nim
let zoomGesture = gtk_gesture_zoom_new()
proc onZoomChanged(gesture: GtkGestureZoom, scale: gdouble, userData: gpointer) {.cdecl.} =
  echo "Текущий коэффициент масштаба: ", scale
discard g_signal_connect(zoomGesture, "scale-changed", onZoomChanged, nil)
```

---

## Конкретные контроллеры (не жесты)

### `gtk_event_controller_key_new` и родственные

```nim
proc gtk_event_controller_key_new*(): GtkEventControllerKey
proc gtk_event_controller_key_set_im_context*(controller: GtkEventControllerKey, imContext: pointer)
proc gtk_event_controller_key_get_im_context*(controller: GtkEventControllerKey): pointer
proc gtk_event_controller_key_forward*(controller: GtkEventControllerKey, widget: GtkWidget): gboolean
proc gtk_event_controller_key_get_group*(controller: GtkEventControllerKey): guint
```

**Что делает.** `gtk_event_controller_key_new` создаёт контроллер нажатий клавиш — эмитирует сигналы `"key-pressed"`/`"key-released"` с кодом клавиши и модификаторами. `set/get_im_context` связывают контроллер с методом ввода (Input Method, для языков со сложным вводом — тот же механизм, что упоминался в `gtk_entry_reset_im_context` из справочника по вводу текста) — специализированная настройка для кастомных текстовых виджетов. `key_forward` перенаправляет событие клавиши другому виджету — полезно, когда контроллер перехватил событие в фазе capture (раздел I), но должен передать необработанное событие дальше конкретному виджету. `get_group` возвращает номер группы раскладки клавиатуры (актуально для раскладок с альтернативными группами символов, например, переключаемых через `AltGr`).

- `controller` — контроллер клавиш.
- `imContext` — объект метода ввода.
- `widget` — виджет, которому перенаправляется событие (для `key_forward`).

```nim
let keyController = gtk_event_controller_key_new()

proc onKeyPressed(controller: GtkEventControllerKey, keyval: guint, keycode: guint, state: gint, userData: gpointer): gboolean {.cdecl.} =
  echo "Нажата клавиша с кодом ", keyval
  result = 0.gboolean  # 0 — не считать событие полностью обработанным, дать распространяться дальше

discard g_signal_connect(keyController, "key-pressed", onKeyPressed, nil)
gtk_widget_add_controller(mainWindow, keyController)
```

---

### `gtk_event_controller_focus_new`, `contains_focus`, `is_focus`

```nim
proc gtk_event_controller_focus_new*(): GtkEventControllerFocus
proc gtk_event_controller_focus_contains_focus*(controller: GtkEventControllerFocus): gboolean
proc gtk_event_controller_focus_is_focus*(controller: GtkEventControllerFocus): gboolean
```

**Что делает.** Отслеживает изменения клавиатурного фокуса относительно виджета, к которому присоединён. `is_focus` — фокус находится именно на этом виджете. `contains_focus` — фокус находится на этом виджете **или на любом из его дочерних виджетов** (актуально для составных контейнеров, где важно знать, что фокус "где-то внутри", а не обязательно на самом контейнере). Эмитирует сигналы `"enter"`/`"leave"` при получении/потере фокуса.

- `controller` — контроллер фокуса.

```nim
let focusController = gtk_event_controller_focus_new()
gtk_widget_add_controller(formContainer, focusController)
echo "Фокус где-то внутри формы: ", gtk_event_controller_focus_contains_focus(focusController) != 0.gboolean
```

---

### `gtk_event_controller_motion_new`, `contains_pointer`, `is_pointer`

```nim
proc gtk_event_controller_motion_new*(): GtkEventControllerMotion
proc gtk_event_controller_motion_contains_pointer*(controller: GtkEventControllerMotion): gboolean
proc gtk_event_controller_motion_is_pointer*(controller: GtkEventControllerMotion): gboolean
```

**Что делает.** Отслеживает движение курсора мыши над виджетом — эмитирует `"enter"`/`"leave"`/`"motion"` (последний — с текущими координатами при каждом движении внутри виджета). `is_pointer`/`contains_pointer` — та же логика "сам виджет / виджет или потомки", что у `GtkEventControllerFocus`, но для наведения курсора, а не клавиатурного фокуса. Основной способ реализовать эффект наведения (hover) — подсветку карточки, показ дополнительных элементов при наведении и т.п.

- `controller` — контроллер движения курсора.

```nim
let motionController = gtk_event_controller_motion_new()

proc onEnter(controller: GtkEventControllerMotion, x: gdouble, y: gdouble, userData: gpointer) {.cdecl.} =
  gtk_widget_add_css_class(cast[GtkWidget](userData), "hovered")

proc onLeave(controller: GtkEventControllerMotion, userData: gpointer) {.cdecl.} =
  gtk_widget_remove_css_class(cast[GtkWidget](userData), "hovered")

discard g_signal_connect(motionController, "enter", onEnter, cast[gpointer](cardWidget))
discard g_signal_connect(motionController, "leave", onLeave, cast[gpointer](cardWidget))
gtk_widget_add_controller(cardWidget, motionController)
```

---

### `gtk_event_controller_scroll_new` и родственные

```nim
proc gtk_event_controller_scroll_new*(flags: gint): GtkEventControllerScroll
proc gtk_event_controller_scroll_set_flags*(controller: GtkEventControllerScroll, flags: gint)
proc gtk_event_controller_scroll_get_flags*(controller: GtkEventControllerScroll): gint
proc gtk_event_controller_scroll_get_unit*(controller: GtkEventControllerScroll): gint
```

**Что делает.** Создаёт контроллер прокрутки колесом мыши/тачпадом — эмитирует сигнал `"scroll"` с величиной прокрутки по каждой оси. `flags` определяет, какие оси и режимы отслеживать: `GTK_EVENT_CONTROLLER_SCROLL_VERTICAL = 1`, `_HORIZONTAL = 2`, `_BOTH_AXES = 3` (сумма обеих), `_DISCRETE = 4` (только дискретные "щелчки" колеса, без плавной прокрутки тачпада), `_KINETIC = 8` (с поддержкой инерционной прокрутки). `get_unit` сообщает, в каких единицах пришло последнее событие прокрутки — пикселях (плавная прокрутка тачпада) или "щелчках" колеса.

- `flags` — битовая маска режимов (именованных констант в этой обёртке нет).
- `controller` — контроллер прокрутки.

```nim
let scrollController = gtk_event_controller_scroll_new(3)  # 3 = VERTICAL | HORIZONTAL

proc onScroll(controller: GtkEventControllerScroll, dx: gdouble, dy: gdouble, userData: gpointer): gboolean {.cdecl.} =
  echo "Прокрутка на (", dx, ", ", dy, ")"
  result = 0.gboolean

discard g_signal_connect(scrollController, "scroll", onScroll, nil)
gtk_widget_add_controller(canvasWidget, scrollController)
```

---

## Drag-and-Drop: GtkDragSource

`GtkDragSource` — контроллер, превращающий виджет в источник перетаскиваемых данных: пользователь может начать перетаскивание содержимого этого виджета мышью и отпустить его над другим виджетом, содержащим `GtkDropTarget` (раздел VII).

### `gtk_drag_source_new`

```nim
proc gtk_drag_source_new*(): GtkDragSource
```

**Что делает.** Создаёт источник перетаскивания без содержимого — само перетаскиваемое содержимое задаётся через `set_content` (следующий подраздел), а сам источник, как и любой контроллер, должен быть присоединён к виджету через `gtk_widget_add_controller`.

- Параметров нет.

```nim
let dragSource = gtk_drag_source_new()
echo "Источник перетаскивания создан"
```

---

### `gtk_drag_source_set/get_content`

```nim
proc gtk_drag_source_set_content*(source: GtkDragSource, content: pointer)
proc gtk_drag_source_get_content*(source: GtkDragSource): pointer
```

**Что делает.** Задают, что именно передаётся при перетаскивании, — объект `GdkContentProvider` (в этой обёртке — непрозрачный `pointer`; построение самого `GdkContentProvider` из текста, файла или произвольных данных — функции `gdk_content_provider_*`, не входящие в этот справочник, но концептуально похожие на подготовку `GVariant`/`GBytes` из предыдущих справочников).

- `source` — источник перетаскивания.
- `content` — объект `GdkContentProvider`.

```nim
# textContent строится заранее через gdk_content_provider_new_for_value с GValue-строкой
gtk_drag_source_set_content(dragSource, textContent)
echo "Источник теперь передаёт при перетаскивании текстовое содержимое"
```

---

### `gtk_drag_source_set/get_actions`

```nim
proc gtk_drag_source_set_actions*(source: GtkDragSource, actions: gint)
proc gtk_drag_source_get_actions*(source: GtkDragSource): gint
```

**Что делает.** Задают допустимые действия при перетаскивании — битовая маска `GDK_ACTION_COPY = 1`, `_MOVE = 2`, `_LINK = 4` (можно комбинировать через `or`, если источник допускает несколько вариантов, и позволить пользователю выбрать конкретное действие модификатором клавиатуры во время перетаскивания — например, `Ctrl` для копирования вместо перемещения, поведение, привычное по файловым менеджерам).

- `source` — источник перетаскивания.
- `actions` — битовая маска допустимых действий.

```nim
gtk_drag_source_set_actions(dragSource, 1 or 2)  # GDK_ACTION_COPY | GDK_ACTION_MOVE
echo "Источник допускает и копирование, и перемещение при перетаскивании"
```

---

### `gtk_drag_source_set_icon`

```nim
proc gtk_drag_source_set_icon*(source: GtkDragSource, paintable: pointer, hotX: gint, hotY: gint)
```

**Что делает.** Задаёт изображение, которое следует за курсором во время перетаскивания (по умолчанию GTK показывает автоматически сгенерированный снимок самого перетаскиваемого виджета) — `paintable` (тот же интерфейс `GdkPaintable`, что и у `GdkTexture` из справочника по диалогам и медиа), `hotX`/`hotY` — точка внутри изображения, которая должна находиться точно под курсором (например, `0, 0` — верхний левый угол изображения следует прямо за курсором).

- `source` — источник перетаскивания.
- `paintable` — изображение-курсор перетаскивания.
- `hotX`, `hotY` — "горячая точка" изображения относительно курсора.

```nim
gtk_drag_source_set_icon(dragSource, cast[pointer](thumbnailTexture), 0, 0)
echo "Во время перетаскивания за курсором будет следовать миниатюра"
```

---

### `gtk_drag_source_drag_cancel` / `gtk_drag_source_get_drag`

```nim
proc gtk_drag_source_drag_cancel*(source: GtkDragSource)
proc gtk_drag_source_get_drag*(source: GtkDragSource): pointer
```

**Что делает.** `drag_cancel` программно отменяет текущее выполняющееся перетаскивание (если оно есть) — например, если во время перетаскивания обнаружилось, что данные больше не актуальны. `get_drag` возвращает объект текущего перетаскивания (`GdkDrag`, как `pointer`) — `nil`, если перетаскивание сейчас не выполняется.

- `source` — источник перетаскивания.

```nim
if not isNil(gtk_drag_source_get_drag(dragSource)):
  gtk_drag_source_drag_cancel(dragSource)
  echo "Текущее перетаскивание отменено программно"
```

---

## Drag-and-Drop: GtkDropTarget

`GtkDropTarget` — контроллер, превращающий виджет в место, куда можно отпустить перетаскиваемое содержимое из `GtkDragSource`.

### `gtk_drop_target_new`

```nim
proc gtk_drop_target_new*(contentType: GType, actions: gint): GtkDropTarget
```

**Что делает.** Создаёт цель для перетаскивания, принимающую содержимое одного конкретного `GType` и допускающую указанные действия (та же битовая маска `GDK_ACTION_*`, что у `gtk_drag_source_set_actions`).

- `contentType` — принимаемый тип содержимого (`GType`).
- `actions` — битовая маска допустимых действий.

```nim
let dropTarget = gtk_drop_target_new(G_TYPE_STRING, 1)  # 1 = GDK_ACTION_COPY
echo "Цель перетаскивания принимает текстовое содержимое, только копирование"
```

---

### `gtk_drop_target_set/get_gtypes`

```nim
proc gtk_drop_target_set_gtypes*(target: GtkDropTarget, types: ptr GType, nTypes: gsize)
proc gtk_drop_target_get_gtypes*(target: GtkDropTarget, nTypes: ptr gsize): ptr GType
```

**Что делает.** Задают набор из нескольких допустимых типов содержимого одновременно вместо единственного типа из конструктора — например, приём и текста, и файлов.

- `target` — цель перетаскивания.
- `types` — массив допустимых `GType`.
- `nTypes` — количество элементов в массиве.

```nim
var acceptedTypes = [G_TYPE_STRING, gFileGType]
gtk_drop_target_set_gtypes(dropTarget, addr acceptedTypes[0], csize_t(acceptedTypes.len))
echo "Цель теперь принимает и текст, и файлы"
```

---

### `gtk_drop_target_set/get_actions`

```nim
proc gtk_drop_target_set_actions*(target: GtkDropTarget, actions: gint)
proc gtk_drop_target_get_actions*(target: GtkDropTarget): gint
```

**Что делает.** Изменяют допустимые действия уже после создания цели.

- `target` — цель перетаскивания.
- `actions` — битовая маска допустимых действий.

```nim
gtk_drop_target_set_actions(dropTarget, 1 or 2)
echo "Цель теперь допускает и копирование, и перемещение"
```

---

### `gtk_drop_target_set/get_preload`

```nim
proc gtk_drop_target_set_preload*(target: GtkDropTarget, preload: gboolean)
proc gtk_drop_target_get_preload*(target: GtkDropTarget): gboolean
```

**Что делает.** Включают предварительную загрузку содержимого во время перетаскивания, до фактического отпускания, — позволяет показать предпросмотр. Выключено по умолчанию.

- `target` — цель перетаскивания.
- `preload` — `1.gboolean`, чтобы включить предзагрузку.

```nim
gtk_drop_target_set_preload(dropTarget, 1.gboolean)
echo "Предзагрузка содержимого при наведении включена"
```

---

### `gtk_drop_target_get_value` / `get_drop` / `get_current_drop` / `get_formats` / `reject`

```nim
proc gtk_drop_target_get_value*(target: GtkDropTarget): GValue
proc gtk_drop_target_get_drop*(target: GtkDropTarget): pointer
proc gtk_drop_target_get_current_drop*(target: GtkDropTarget): pointer
proc gtk_drop_target_get_formats*(target: GtkDropTarget): pointer
proc gtk_drop_target_reject*(target: GtkDropTarget)
```

**Что делает.** `get_value` возвращает фактически перетащенное значение как `GValue` (доступно внутри `"drop"`). `get_drop`/`get_current_drop` — низкоуровневый объект операции (`GdkDrop`). `get_formats` — какие форматы доступны в текущем перетаскивании. `reject` явно отклоняет перетаскивание, даже если тип формально подходит.

- `target` — цель перетаскивания.

```nim
proc onDrop(target: GtkDropTarget, value: GValue, x: gdouble, y: gdouble, userData: gpointer): gboolean {.cdecl.} =
  echo "Что-то отпущено над целью в координатах (", x, ", ", y, ")"
  result = 1.gboolean

discard g_signal_connect(dropTarget, "drop", onDrop, nil)
gtk_widget_add_controller(dropZoneWidget, dropTarget)
```

---

## Практические рецепты

### Клик правой кнопкой мыши для контекстного меню

```nim
proc onRightClick(gesture: GtkGestureClick, nPress: gint, x: gdouble, y: gdouble, userData: gpointer) {.cdecl.} =
  let contextPopover = cast[GtkPopover](userData)
  gtk_popover_popup(contextPopover)
  echo "Контекстное меню открыто по правому клику в точке (", x, ", ", y, ")"

proc attachContextMenu(widget: GtkWidget, popover: GtkPopover) =
  let rightClickGesture = gtk_gesture_click_new()
  gtk_gesture_single_set_button(rightClickGesture, 3)
  discard g_signal_connect(rightClickGesture, "pressed", onRightClick, cast[gpointer](popover))
  gtk_widget_add_controller(widget, rightClickGesture)
  echo "Контекстное меню привязано к правому клику по виджету"
```

---

### Перетаскивание виджета мышью внутри области

```nim
proc buildDraggableCard(canvas: GtkFixed, startX, startY: float): GtkWidget =
  result = gtk_button_new_with_label("Перетащи меня")
  gtk_fixed_put(canvas, result, startX, startY)

  let dragGesture = gtk_gesture_drag_new()

  proc onDragUpdate(gesture: GtkGestureDrag, offsetX: gdouble, offsetY: gdouble, userData: gpointer) {.cdecl.} =
    let card = cast[GtkWidget](userData)
    var beginX, beginY: gdouble
    discard gtk_gesture_drag_get_start_point(gesture, addr beginX, addr beginY)
    gtk_fixed_move(canvas, card, beginX + offsetX, beginY + offsetY)

  discard g_signal_connect(dragGesture, "drag-update", onDragUpdate, cast[gpointer](result))
  gtk_widget_add_controller(result, dragGesture)
  echo "Карточка теперь свободно перетаскивается мышью внутри области"

let canvas = gtk_fixed_new()
let card = buildDraggableCard(canvas, 20.0, 20.0)
```

---

### Долгое нажатие для мобильного жеста контекстного меню

```nim
proc onLongPress(gesture: GtkGestureLongPress, x: gdouble, y: gdouble, userData: gpointer) {.cdecl.} =
  let contextPopover = cast[GtkPopover](userData)
  gtk_popover_popup(contextPopover)
  echo "Контекстное меню открыто долгим нажатием"

proc attachLongPressMenu(widget: GtkWidget, popover: GtkPopover) =
  let longPressGesture = gtk_gesture_long_press_new()
  gtk_gesture_single_set_touch_only(longPressGesture, 1.gboolean)
  discard g_signal_connect(longPressGesture, "pressed", onLongPress, cast[gpointer](popover))
  gtk_widget_add_controller(widget, longPressGesture)
  echo "Долгое нажатие на сенсорном экране открывает то же контекстное меню"
```

---

### Перетаскивание текста из одного поля в другое

```nim
proc attachTextDragSource(sourceLabel: GtkLabel) =
  let dragSource = gtk_drag_source_new()
  gtk_drag_source_set_actions(dragSource, 1)

  proc onPrepare(source: GtkDragSource, x: gdouble, y: gdouble, userData: gpointer): pointer {.cdecl.} =
    let text = $gtk_label_get_text(cast[GtkLabel](userData))
    echo "Подготовка содержимого для перетаскивания: ", text

  discard g_signal_connect(dragSource, "prepare", onPrepare, cast[gpointer](sourceLabel))
  gtk_widget_add_controller(sourceLabel, dragSource)

proc attachTextDropTarget(targetEntry: GtkEntry) =
  let dropTarget = gtk_drop_target_new(G_TYPE_STRING, 1)

  proc onDrop(target: GtkDropTarget, value: GValue, x: gdouble, y: gdouble, userData: gpointer): gboolean {.cdecl.} =
    echo "Текст отпущен в поле ввода"
    result = 1.gboolean

  discard g_signal_connect(dropTarget, "drop", onDrop, nil)
  gtk_widget_add_controller(targetEntry, dropTarget)

echo "Перетаскивание текста между надписью и полем ввода настроено"
```

---

### Реакция на наведение курсора (hover) на карточку

```nim
proc makeCardHoverable(card: GtkWidget) =
  let motionController = gtk_event_controller_motion_new()

  proc onEnter(controller: GtkEventControllerMotion, x: gdouble, y: gdouble, userData: gpointer) {.cdecl.} =
    gtk_widget_add_css_class(cast[GtkWidget](userData), "card-hovered")

  proc onLeave(controller: GtkEventControllerMotion, userData: gpointer) {.cdecl.} =
    gtk_widget_remove_css_class(cast[GtkWidget](userData), "card-hovered")

  discard g_signal_connect(motionController, "enter", onEnter, cast[gpointer](card))
  discard g_signal_connect(motionController, "leave", onLeave, cast[gpointer](card))
  gtk_widget_add_controller(card, motionController)
  echo "Карточка подсвечивается CSS-классом при наведении курсора"
```

---

## Краткая таблица

| Процедура(ы) | Категория | Что делает вкратце |
|---|---|---|
| `gtk_widget_add/remove_controller` | EventController | Присоединить/отсоединить контроллер к виджету |
| `gtk_event_controller_get_widget` | EventController | Виджет, к которому присоединён контроллер |
| `gtk_event_controller_set/get_propagation_phase` | EventController | Фаза распространения события |
| `gtk_event_controller_set/get_propagation_limit` | EventController | Ограничение распространения за пределы окна |
| `gtk_event_controller_set/get_name` | EventController | Отладочное имя контроллера |
| `gtk_event_controller_reset` | EventController | Сбросить внутреннее состояние |
| `gtk_gesture_is_active`, `is_recognized` | Gesture | Активен ли жест / распознан ли |
| `gtk_gesture_get_point`, `get_bounding_box*` | Gesture | Координаты точек взаимодействия |
| `gtk_gesture_set_state`, `get/set_sequence_state` | Gesture | Заявка на эксклюзивное владение |
| `gtk_gesture_group/ungroup`, `is_grouped_with` | Gesture | Совместная обработка несколькими жестами |
| `gtk_gesture_single_set/get_button` | GestureSingle | Кнопка мыши |
| `gtk_gesture_single_set/get_touch_only` | GestureSingle | Реакция только на сенсорный ввод |
| `gtk_gesture_single_set/get_exclusive` | GestureSingle | Игнорировать при второй точке касания |
| `gtk_gesture_click_new` | Click | Распознавание клика |
| `gtk_gesture_drag_new`, `get_start_point`, `get_offset` | Drag | Распознавание перетаскивания мышью |
| `gtk_gesture_long_press_new`, `set/get_delay_factor` | LongPress | Распознавание долгого нажатия |
| `gtk_gesture_swipe_new`, `get_velocity` | Swipe | Распознавание смахивающего жеста |
| `gtk_gesture_rotate_new`, `get_angle_delta` | Rotate | Распознавание вращения |
| `gtk_gesture_zoom_new`, `get_scale_delta` | Zoom | Распознавание масштабирования |
| `gtk_event_controller_key_new` и родственные | Key | Нажатия клавиш, метод ввода |
| `gtk_event_controller_focus_new`, `contains/is_focus` | Focus | Отслеживание фокуса |
| `gtk_event_controller_motion_new`, `contains/is_pointer` | Motion | Отслеживание курсора, hover |
| `gtk_event_controller_scroll_new` и родственные | Scroll | Прокрутка колесом/тачпадом |
| `gtk_drag_source_new` | DragSource | Создать источник перетаскивания |
| `gtk_drag_source_set/get_content` | DragSource | Перетаскиваемое содержимое |
| `gtk_drag_source_set/get_actions` | DragSource | Допустимые действия |
| `gtk_drag_source_set_icon` | DragSource | Изображение, следующее за курсором |
| `gtk_drag_source_drag_cancel`, `get_drag` | DragSource | Программная отмена / текущая операция |
| `gtk_drop_target_new` | DropTarget | Создать цель перетаскивания |
| `gtk_drop_target_set/get_gtypes` | DropTarget | Несколько допустимых типов |
| `gtk_drop_target_set/get_actions` | DropTarget | Допустимые действия |
| `gtk_drop_target_set/get_preload` | DropTarget | Предзагрузка при наведении |
| `gtk_drop_target_get_value`, `get_drop`, `get_current_drop`, `get_formats`, `reject` | DropTarget | Чтение и отклонение содержимого |

---

## Сводка: какую процедуру выбрать

- **Реакция на обычный клик** → `GtkGestureClick` с кнопкой по умолчанию (`0` — любая). **Только правая кнопка для контекстного меню** → тот же жест с `gtk_gesture_single_set_button(gesture, 3)`.
- **Перетаскивание виджета внутри интерфейса приложения** → `GtkGestureDrag` + собственная логика перемещения, а не полноценный Drag-and-Drop — тот нужен для передачи данных между виджетами/приложениями.
- **Передача данных перетаскиванием между разными виджетами** → `GtkDragSource` + `GtkDropTarget`, а не `GtkGestureDrag`.
- **Долгое нажатие как аналог правого клика на сенсорных устройствах** → `GtkGestureLongPress` с `touch_only = true`, чтобы не конфликтовать с обычным кликом мыши.
- **Эффект подсветки при наведении без клика** → `GtkEventControllerMotion` с `"enter"`/`"leave"`, управляющими CSS-классом.
- **Родитель должен перехватывать события раньше дочерних виджетов** → `propagation_phase = 0` (capture), а не полагаться на стандартную фазу bubble.
- **Несколько жестов на одном виджете не должны мешать друг другу** → `gtk_gesture_group`, а не полагаться на автоматическое сосуществование.
