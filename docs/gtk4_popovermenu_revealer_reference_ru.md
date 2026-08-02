# GTK4 (PopoverMenu / Revealer) — справочник модуля

> **Импорт:** `import libGTK4`
> **Область применения:** меню, построенное из декларативной модели `GMenuModel` и показываемое как всплывающее окно, и контейнер с анимированным показом/скрытием содержимого. Восемнадцатая часть серии справочников по обёртке.

`GtkPopoverMenu` — специализированный `GtkPopover` (справочник по всплывающим и вспомогательным контейнерам), автоматически строящий содержимое меню из `GMenuModel` (та же модель, что использовалась в `gtk_application_set_menubar` и `gtk_menu_button_set_menu_model` из предыдущих справочников) — то есть закрывает случаи, где `GtkMenuButton` был не совсем подходящей отправной точкой (например, контекстное меню, открываемое не по клику на кнопку, а по правому клику мыши, см. рецепт ниже). `GtkRevealer` — простой контейнер, анимированно показывающий/скрывающий один дочерний виджет, — механизм, который использовали `GtkInfoBar`/`GtkSearchBar` из предыдущих справочников "под капотом", доступный и напрямую для собственных нужд.

---

## Оглавление

I. [GtkPopoverMenu](#gtkpopovermenu)
&nbsp;&nbsp;1. [`gtk_popover_menu_new_from_model` / `_from_model_full`](#gtk_popover_menu_new_from_model--_from_model_full)
&nbsp;&nbsp;2. [`gtk_popover_menu_set/get_menu_model`](#gtk_popover_menu_setget_menu_model)
&nbsp;&nbsp;3. [`gtk_popover_menu_add_child` / `remove_child`](#gtk_popover_menu_add_child--remove_child)

II. [GtkRevealer](#gtkrevealer)
&nbsp;&nbsp;1. [`gtk_revealer_new`](#gtk_revealer_new)
&nbsp;&nbsp;2. [`gtk_revealer_set/get_reveal_child` / `get_child_revealed`](#gtk_revealer_setget_reveal_child--get_child_revealed)
&nbsp;&nbsp;3. [`gtk_revealer_set/get_transition_type`](#gtk_revealer_setget_transition_type)
&nbsp;&nbsp;4. [`gtk_revealer_set/get_transition_duration`](#gtk_revealer_setget_transition_duration)
&nbsp;&nbsp;5. [`gtk_revealer_set/get_child`](#gtk_revealer_setget_child)

III. [Практические рецепты](#практические-рецепты)
&nbsp;&nbsp;1. [Контекстное меню по правому клику из GMenuModel](#контекстное-меню-по-правому-клику-из-gmenumodel)
&nbsp;&nbsp;2. [Меню со встроенным виджетом (не только пункты)](#меню-со-встроенным-виджетом-не-только-пункты)
&nbsp;&nbsp;3. [Плавно раскрывающаяся панель дополнительных фильтров](#плавно-раскрывающаяся-панель-дополнительных-фильтров)
&nbsp;&nbsp;4. [Индикатор "сохранено", исчезающий через несколько секунд](#индикатор-сохранено-исчезающий-через-несколько-секунд)

IV. [Краткая таблица](#краткая-таблица)

V. [Сводка: какую процедуру выбрать](#сводка-какую-процедуру-выбрать)

---

## GtkPopoverMenu

### `gtk_popover_menu_new_from_model` / `_from_model_full`

```nim
proc gtk_popover_menu_new_from_model*(model: GMenuModel): GtkPopoverMenu
proc gtk_popover_menu_new_from_model_full*(model: GMenuModel, flags: gint): GtkPopoverMenu
```

**Что делает.** Создают меню-всплывающее окно, построенное из модели меню, — тот же принцип, что и у `gtk_menu_button_set_menu_model` из справочника по всплывающим и вспомогательным контейнерам, но как самостоятельный `GtkPopover`, не привязанный жёстко к `GtkMenuButton`. `_full`-вариант принимает дополнительные `flags`, управляющие деталями построения (в этой обёртке — без именованных констант, обычно передаётся `0` для поведения по умолчанию).

- `model` — модель меню.
- `flags` — дополнительные флаги построения (для `_full`).

```nim
let contextMenu = gtk_popover_menu_new_from_model(cast[GMenuModel](menuModel))
gtk_widget_set_parent(contextMenu, targetWidget)
echo "Контекстное меню построено из модели и привязано к виджету"
```

---

### `gtk_popover_menu_set/get_menu_model`

```nim
proc gtk_popover_menu_set_menu_model*(popover: GtkPopoverMenu, model: GMenuModel)
proc gtk_popover_menu_get_menu_model*(popover: GtkPopoverMenu): GMenuModel
```

**Что делает.** Заменяют модель уже существующего меню на другую (например, контекстное меню, содержимое которого зависит от того, что было выбрано на момент открытия) и читают текущую модель.

- `popover` — меню.
- `model` — новая модель меню.

```nim
gtk_popover_menu_set_menu_model(contextMenu, cast[GMenuModel](differentMenuModel))
echo "Содержимое контекстного меню обновлено под новый контекст"
```

---

### `gtk_popover_menu_add_child` / `remove_child`

```nim
proc gtk_popover_menu_add_child*(popover: GtkPopoverMenu, child: GtkWidget, id: cstring): gboolean
proc gtk_popover_menu_remove_child*(popover: GtkPopoverMenu, child: GtkWidget): gboolean
```

**Что делает.** Встраивают произвольный виджет (не просто пункт меню с текстом) в конкретное место меню — `id` соответствует специальному атрибуту `custom` в XML-описании модели меню (`GtkBuilder`-разметка меню, не входящая в этот справочник напрямую), обозначающему место, куда должен быть вставлен виджет с этим идентификатором. Позволяет, например, встроить `GtkScale` (ползунок громкости) прямо внутрь меню вместо обычного пункта. Возвращают `gboolean`, удалось ли найти соответствующее место `id` в текущей модели меню.

- `popover` — меню.
- `child` — встраиваемый виджет.
- `id` — идентификатор места вставки, соответствующий атрибуту `custom` в модели меню.

```nim
let volumeScale = gtk_scale_new_with_range(GTK_ORIENTATION_HORIZONTAL, 0.0, 100.0, 5.0)
discard gtk_popover_menu_add_child(contextMenu, volumeScale, "volume-slider".cstring)
echo "Ползунок громкости встроен в меню на место, помеченное 'volume-slider'"
```

---

## GtkRevealer

### `gtk_revealer_new`

```nim
proc gtk_revealer_new*(): GtkRevealer
```

**Что делает.** Создаёт контейнер в скрытом состоянии по умолчанию, без содержимого.

- Параметров нет.

```nim
let filtersRevealer = gtk_revealer_new()
echo "Контейнер с анимированным показом создан, изначально скрыт"
```

---

### `gtk_revealer_set/get_reveal_child` / `get_child_revealed`

```nim
proc gtk_revealer_set_reveal_child*(revealer: GtkRevealer, revealChild: gboolean)
proc gtk_revealer_get_reveal_child*(revealer: GtkRevealer): gboolean
proc gtk_revealer_get_child_revealed*(revealer: GtkRevealer): gboolean
```

**Что делает.** `set_reveal_child` запускает анимацию показа/скрытия содержимого. `get_reveal_child` возвращает **целевое** состояние (куда сейчас анимируется контейнер — `true` сразу после вызова `set_reveal_child(true)`, даже если анимация ещё идёт). `get_child_revealed` возвращает **фактическое** состояние с учётом анимации (`false`, пока анимация появления ещё не завершилась полностью) — различие важно, если код должен выполнить действие только после того, как содержимое реально полностью показано, а не в момент, когда показ только запрошен.

- `revealer` — контейнер.
- `revealChild` — `1.gboolean`, чтобы показать содержимое.

```nim
gtk_revealer_set_reveal_child(filtersRevealer, 1.gboolean)
echo "Запрошен показ: ", gtk_revealer_get_reveal_child(filtersRevealer) != 0.gboolean
echo "Показ уже завершён: ", gtk_revealer_get_child_revealed(filtersRevealer) != 0.gboolean
```

---

### `gtk_revealer_set/get_transition_type`

```nim
proc gtk_revealer_set_transition_type*(revealer: GtkRevealer, transition: GtkRevealerTransitionType)
proc gtk_revealer_get_transition_type*(revealer: GtkRevealer): GtkRevealerTransitionType
```

**Что делает.** Задают тип анимации: `GTK_REVEALER_TRANSITION_TYPE_NONE` (мгновенно), `_CROSSFADE` (плавное затухание — значение по умолчанию), `_SLIDE_RIGHT`/`_LEFT`/`_UP`/`_DOWN` (выезжание в соответствующую сторону) и `_SWING_RIGHT`/`_LEFT`/`_UP`/`_DOWN` (эффект "раскрытия", напоминающий разворачивание из точки крепления — уникальный для `GtkRevealer`, у `GtkStack` из справочника по многовидовым контейнерам такого варианта нет).

- `revealer` — контейнер.
- `transition` — значение `GtkRevealerTransitionType`.

```nim
gtk_revealer_set_transition_type(filtersRevealer, GTK_REVEALER_TRANSITION_TYPE_SLIDE_DOWN)
echo "Панель фильтров будет выезжать сверху вниз при показе"
```

---

### `gtk_revealer_set/get_transition_duration`

```nim
proc gtk_revealer_set_transition_duration*(revealer: GtkRevealer, duration: guint)
proc gtk_revealer_get_transition_duration*(revealer: GtkRevealer): guint
```

**Что делает.** Задают длительность анимации в миллисекундах — та же логика, что у `gtk_stack_set_transition_duration` из справочника по многовидовым контейнерам.

- `revealer` — контейнер.
- `duration` — длительность в миллисекундах.

```nim
gtk_revealer_set_transition_duration(filtersRevealer, 300)
echo "Анимация показа панели фильтров теперь длится 300 мс"
```

---

### `gtk_revealer_set/get_child`

```nim
proc gtk_revealer_set_child*(revealer: GtkRevealer, child: GtkWidget)
proc gtk_revealer_get_child*(revealer: GtkRevealer): GtkWidget
```

**Что делает.** Устанавливают и читают единственный дочерний виджет — тот же паттерн "один слот содержимого", что у большинства контейнеров этой серии справочников.

- `revealer` — контейнер.
- `child` — виджет-содержимое.

```nim
let filtersBox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)
gtk_revealer_set_child(filtersRevealer, filtersBox)
echo "Панель фильтров установлена как содержимое контейнера"
```

---

## Практические рецепты

### Контекстное меню по правому клику из GMenuModel

```nim
proc buildContextMenu(): GtkPopoverMenu =
  let menu = g_menu_new()
  g_menu_append(menu, "Копировать", "app.copy")
  g_menu_append(menu, "Вставить", "app.paste")
  g_menu_append(menu, "Удалить", "app.delete")
  result = gtk_popover_menu_new_from_model(cast[GMenuModel](menu))

proc attachContextMenu(widget: GtkWidget) =
  let menu = buildContextMenu()
  gtk_widget_set_parent(menu, widget)

  proc onRightClick(gesture: GtkGestureClick, nPress: gint, x: gdouble, y: gdouble, userData: gpointer) {.cdecl.} =
    gtk_popover_popup(cast[GtkPopover](userData))

  let rightClickGesture = gtk_gesture_click_new()
  gtk_gesture_single_set_button(rightClickGesture, 3)
  discard g_signal_connect(rightClickGesture, "pressed", onRightClick, cast[gpointer](menu))
  gtk_widget_add_controller(widget, rightClickGesture)
  echo "Контекстное меню из трёх пунктов открывается по правому клику"

attachContextMenu(documentArea)
```

---

### Меню со встроенным виджетом (не только пункты)

```nim
proc buildAppMenuWithSlider(): GtkPopoverMenu =
  let menu = g_menu_new()
  g_menu_append(menu, "Настройки", "app.preferences")
  g_menu_append(menu, "О программе", "app.about")
  result = gtk_popover_menu_new_from_model(cast[GMenuModel](menu))

  let brightnessScale = gtk_scale_new_with_range(GTK_ORIENTATION_HORIZONTAL, 0.0, 100.0, 5.0)
  discard gtk_popover_menu_add_child(result, brightnessScale, "brightness".cstring)
  echo "Меню приложения с встроенным ползунком яркости собрано"

# XML/программная модель меню должна содержать элемент <item custom="brightness"/>
# в соответствующем месте, чтобы gtk_popover_menu_add_child нашёл, куда вставить виджет.
```

---

### Плавно раскрывающаяся панель дополнительных фильтров

```nim
proc buildFilterableSearch(): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)

  let toggleButton = gtk_toggle_button_new_with_label("Фильтры")
  gtk_box_append(result, toggleButton)

  let revealer = gtk_revealer_new()
  gtk_revealer_set_transition_type(revealer, GTK_REVEALER_TRANSITION_TYPE_SLIDE_DOWN)
  let filtersContent = gtk_box_new(GTK_ORIENTATION_VERTICAL, 6)
  gtk_box_append(filtersContent, gtk_check_button_new_with_label("Только активные"))
  gtk_revealer_set_child(revealer, filtersContent)
  gtk_box_append(result, revealer)

  proc onToggled(button: GtkToggleButton, userData: gpointer) {.cdecl.} =
    let rev = cast[GtkRevealer](userData)
    gtk_revealer_set_reveal_child(rev, gtk_toggle_button_get_active(button))

  discard g_signal_connect(toggleButton, "toggled", onToggled, cast[gpointer](revealer))
  echo "Панель фильтров плавно появляется/скрывается по кнопке 'Фильтры'"

let searchArea = buildFilterableSearch()
```

---

### Индикатор "сохранено", исчезающий через несколько секунд

```nim
proc showTemporarySavedIndicator(revealer: GtkRevealer) =
  gtk_revealer_set_transition_type(revealer, GTK_REVEALER_TRANSITION_TYPE_CROSSFADE)
  gtk_revealer_set_reveal_child(revealer, 1.gboolean)

  proc onHideTimeout(userData: gpointer): gboolean {.cdecl.} =
    gtk_revealer_set_reveal_child(cast[GtkRevealer](userData), 0.gboolean)
    result = 0.gboolean

  discard g_timeout_add(2000, onHideTimeout, cast[gpointer](revealer))
  echo "Индикатор 'Сохранено' показан и скроется через 2 секунды"

let savedIndicatorRevealer = gtk_revealer_new()
gtk_revealer_set_child(savedIndicatorRevealer, gtk_label_new("Сохранено"))
showTemporarySavedIndicator(savedIndicatorRevealer)
```

---

## Краткая таблица

| Процедура(ы) | Категория | Что делает вкратце |
|---|---|---|
| `gtk_popover_menu_new_from_model`, `_from_model_full` | PopoverMenu | Создать меню из GMenuModel |
| `gtk_popover_menu_set/get_menu_model` | PopoverMenu | Заменить/прочитать модель меню |
| `gtk_popover_menu_add_child`, `remove_child` | PopoverMenu | Встроить произвольный виджет в меню |
| `gtk_revealer_new` | Revealer | Создать контейнер с анимированным показом |
| `gtk_revealer_set/get_reveal_child` | Revealer | Запросить показ/скрытие (целевое состояние) |
| `gtk_revealer_get_child_revealed` | Revealer | Фактическое состояние с учётом анимации |
| `gtk_revealer_set/get_transition_type` | Revealer | Тип анимации (crossfade/slide/swing) |
| `gtk_revealer_set/get_transition_duration` | Revealer | Длительность анимации |
| `gtk_revealer_set/get_child` | Revealer | Единственный дочерний виджет |

---

## Сводка: какую процедуру выбрать

- **Меню с пунктами, открываемое кнопкой** → `GtkMenuButton` + `gtk_menu_button_set_menu_model` — уже включает управление открытием/закрытием по клику. **Меню, открываемое чем-то ещё** (правый клик, программный вызов без выделенной кнопки) → `GtkPopoverMenu` напрямую с ручным `gtk_widget_set_parent` + `gtk_popover_popup`.
- **В меню нужен не только текстовый пункт, а произвольный виджет** → `gtk_popover_menu_add_child` с соответствующим атрибутом `custom` в модели, а не пытаться превратить нужный элемент в обычный пункт меню.
- **Нужно узнать, что показ содержимого уже полностью завершился** → `gtk_revealer_get_child_revealed`, а не `get_reveal_child` — второй отражает лишь целевое состояние.
- **Временное уведомление, которое должно само исчезнуть** → `GtkRevealer` с `gtk_revealer_set_reveal_child` в паре с `g_timeout_add` для автоматического скрытия через заданное время.
- **Показ/скрытие целого экрана или между несколькими взаимоисключающими состояниями** → `GtkStack`. **Показ/скрытие одного дополнительного блока содержимого рядом с основным** → `GtkRevealer` — они решают разные по своей природе задачи, хотя оба дают анимацию.
