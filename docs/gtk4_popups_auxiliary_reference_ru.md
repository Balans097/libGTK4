# GTK4 (popups & auxiliary containers: Popover / MenuButton / Expander / Calendar / Overlay / Fixed / AspectFrame) — справочник модуля

> **Импорт:** `import libGTK4`
> **Область применения:** всплывающие окна, кнопка с меню, сворачиваемая секция, календарь, наложение виджетов друг на друга, абсолютное позиционирование и сохранение пропорций. Десятая часть серии справочников по обёртке; предполагает знакомство с предыдущими частями, особенно с `gtk4_core_reference_ru.md` (компоновка, `GtkWidget`) и `gtk4_window_chrome_dialogs_reference_ru.md` (диалоги, меню на уровне `GMenuModel`).

Семь виджетов этого справочника не образуют одну тематическую группу, а скорее собраны как "то, что часто нужно, но не поместилось в предыдущие тематические разделы": `GtkPopover` — всплывающее окно, привязанное к виджету; `GtkMenuButton` — кнопка, открывающая `GtkPopover` или меню по клику (готовая связка, часто используемая вместе); `GtkExpander` — сворачиваемая/разворачиваемая секция содержимого; `GtkCalendar` — виджет выбора даты; `GtkOverlay` — наложение виджетов друг на друга поверх основного содержимого; `GtkFixed` — контейнер с абсолютным позиционированием по пиксельным координатам; `GtkAspectFrame` — контейнер, поддерживающий заданное соотношение сторон содержимого.

---

## Оглавление

I. [GtkPopover](#gtkpopover)
&nbsp;&nbsp;1. [`gtk_popover_new`](#gtk_popover_new)
&nbsp;&nbsp;2. [`gtk_popover_set_child` / `gtk_popover_get_child`](#gtk_popover_set_child--gtk_popover_get_child)
&nbsp;&nbsp;3. [`gtk_popover_popup` / `gtk_popover_popdown`](#gtk_popover_popup--gtk_popover_popdown)
&nbsp;&nbsp;4. [`gtk_widget_get_ancestor`](#gtk_widget_get_ancestor)

II. [GtkMenuButton](#gtkmenubutton)
&nbsp;&nbsp;1. [`gtk_menu_button_new`](#gtk_menu_button_new)
&nbsp;&nbsp;2. [`gtk_menu_button_set_label` / `gtk_menu_button_set_icon_name` / `get_icon_name` / `set_child` / `get_child`](#gtk_menu_button_set_label--gtk_menu_button_set_icon_name--get_icon_name--set_child--get_child)
&nbsp;&nbsp;3. [`gtk_menu_button_set_popover` / `gtk_menu_button_get_popover`](#gtk_menu_button_set_popover--gtk_menu_button_get_popover)
&nbsp;&nbsp;4. [`gtk_menu_button_set_menu_model` / `gtk_menu_button_get_menu_model`](#gtk_menu_button_set_menu_model--gtk_menu_button_get_menu_model)
&nbsp;&nbsp;5. [`gtk_menu_button_get_active` / `gtk_menu_button_set_active` / `popup` / `popdown`](#gtk_menu_button_get_active--gtk_menu_button_set_active--popup--popdown)
&nbsp;&nbsp;6. [`gtk_menu_button_set_direction` / `gtk_menu_button_get_direction`](#gtk_menu_button_set_direction--gtk_menu_button_get_direction)
&nbsp;&nbsp;7. [`gtk_menu_button_set_use_underline` / `gtk_menu_button_get_use_underline`](#gtk_menu_button_set_use_underline--gtk_menu_button_get_use_underline)
&nbsp;&nbsp;8. [`gtk_menu_button_set_has_frame` / `gtk_menu_button_get_has_frame`](#gtk_menu_button_set_has_frame--gtk_menu_button_get_has_frame)
&nbsp;&nbsp;9. [`gtk_menu_button_set_primary` / `gtk_menu_button_get_primary`](#gtk_menu_button_set_primary--gtk_menu_button_get_primary)
&nbsp;&nbsp;10. [`gtk_menu_button_set_create_popup_func`](#gtk_menu_button_set_create_popup_func)
&nbsp;&nbsp;11. [`gtk_menu_button_set_always_show_arrow` / `gtk_menu_button_get_always_show_arrow`](#gtk_menu_button_set_always_show_arrow--gtk_menu_button_get_always_show_arrow)

III. [GtkExpander](#gtkexpander)
&nbsp;&nbsp;1. [`gtk_expander_new` / `gtk_expander_new_with_mnemonic`](#gtk_expander_new--gtk_expander_new_with_mnemonic)
&nbsp;&nbsp;2. [`gtk_expander_set_expanded` / `gtk_expander_get_expanded`](#gtk_expander_set_expanded--gtk_expander_get_expanded)
&nbsp;&nbsp;3. [`gtk_expander_set_label` / `gtk_expander_get_label`](#gtk_expander_set_label--gtk_expander_get_label)
&nbsp;&nbsp;4. [`gtk_expander_set_child` / `gtk_expander_get_child`](#gtk_expander_set_child--gtk_expander_get_child)

IV. [GtkCalendar](#gtkcalendar)
&nbsp;&nbsp;1. [`gtk_calendar_new`](#gtk_calendar_new)
&nbsp;&nbsp;2. [`gtk_calendar_select_day`](#gtk_calendar_select_day)
&nbsp;&nbsp;3. [`gtk_calendar_mark_day` / `gtk_calendar_unmark_day` / `gtk_calendar_clear_marks`](#gtk_calendar_mark_day--gtk_calendar_unmark_day--gtk_calendar_clear_marks)

V. [GtkOverlay](#gtkoverlay)
&nbsp;&nbsp;1. [`gtk_overlay_new`](#gtk_overlay_new)
&nbsp;&nbsp;2. [`gtk_overlay_set_child` / `gtk_overlay_get_child`](#gtk_overlay_set_child--gtk_overlay_get_child)
&nbsp;&nbsp;3. [`gtk_overlay_add_overlay` / `gtk_overlay_remove_overlay`](#gtk_overlay_add_overlay--gtk_overlay_remove_overlay)

VI. [GtkFixed](#gtkfixed)
&nbsp;&nbsp;1. [`gtk_fixed_new`](#gtk_fixed_new)
&nbsp;&nbsp;2. [`gtk_fixed_put` / `gtk_fixed_move` / `gtk_fixed_remove`](#gtk_fixed_put--gtk_fixed_move--gtk_fixed_remove)

VII. [GtkAspectFrame](#gtkaspectframe)
&nbsp;&nbsp;1. [`gtk_aspect_frame_new`](#gtk_aspect_frame_new)
&nbsp;&nbsp;2. [`gtk_aspect_frame_set_xalign` / `get_xalign` / `set_yalign` / `get_yalign`](#gtk_aspect_frame_set_xalign--get_xalign--set_yalign--get_yalign)
&nbsp;&nbsp;3. [`gtk_aspect_frame_set_ratio` / `gtk_aspect_frame_get_ratio`](#gtk_aspect_frame_set_ratio--gtk_aspect_frame_get_ratio)
&nbsp;&nbsp;4. [`gtk_aspect_frame_set_obey_child` / `gtk_aspect_frame_get_obey_child`](#gtk_aspect_frame_set_obey_child--gtk_aspect_frame_get_obey_child)
&nbsp;&nbsp;5. [`gtk_aspect_frame_set_child` / `gtk_aspect_frame_get_child`](#gtk_aspect_frame_set_child--gtk_aspect_frame_get_child)

VIII. [Практические рецепты](#практические-рецепты)
&nbsp;&nbsp;1. [Кнопка с выпадающим меню действий](#кнопка-с-выпадающим-меню-действий)
&nbsp;&nbsp;2. [Кнопка с произвольным всплывающим содержимым (не меню)](#кнопка-с-произвольным-всплывающим-содержимым-не-меню)
&nbsp;&nbsp;3. [Свёрнутая по умолчанию секция «Дополнительные параметры»](#свёрнутая-по-умолчанию-секция-дополнительные-параметры)
&nbsp;&nbsp;4. [Значок-бейдж поверх изображения через GtkOverlay](#значок-бейдж-поверх-изображения-через-gtkoverlay)
&nbsp;&nbsp;5. [Видео/изображение с сохранением соотношения сторон 16:9](#видеоизображение-с-сохранением-соотношения-сторон-169)

IX. [Краткая таблица](#краткая-таблица)

X. [Сводка: какую процедуру выбрать](#сводка-какую-процедуру-выбрать)

---

## GtkPopover

`GtkPopover` — всплывающее окно, визуально привязанное к конкретному виджету (появляется рядом с ним, со стрелкой-указателем в сторону этого виджета) и автоматически закрывающееся при клике снаружи или потере фокуса. Используется как строительный блок для более специализированных виджетов (`GtkMenuButton` в разделе II использует `GtkPopover` под капотом), но может применяться и напрямую для произвольного всплывающего содержимого — не обязательно меню.

### `gtk_popover_new`

```nim
proc gtk_popover_new*(): GtkPopover
```

**Что делает.** Создаёт всплывающее окно без родителя и без содержимого. Родитель устанавливается отдельно через общую функцию `gtk_widget_set_parent(popover, parent)` (базовый справочник — у `GtkPopover` нет отдельного сеттера родителя), содержимое — через `gtk_popover_set_child` ниже.

- Параметров нет.

```nim
let infoPopover = gtk_popover_new()
gtk_widget_set_parent(infoPopover, infoButton)
echo "Всплывающее окно создано и привязано к кнопке информации"
```

---

### `gtk_popover_set_child` / `gtk_popover_get_child`

```nim
proc gtk_popover_set_child*(popover: GtkPopover, child: GtkWidget)
proc gtk_popover_get_child*(popover: GtkPopover): GtkWidget
```

**Что делает.** Устанавливают и читают единственный дочерний виджет всплывающего окна — тот же паттерн "один слот содержимого", что у `gtk_window_set_child`. Для нескольких элементов внутри всплывающего окна единственным ребёнком делают контейнер (`GtkBox`/`GtkGrid` из базового справочника).

- `popover` — всплывающее окно.
- `child` — виджет-содержимое.

```nim
let infoContent = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)
gtk_box_append(infoContent, gtk_label_new("Версия приложения: 1.3"))
gtk_popover_set_child(infoPopover, infoContent)
echo "Содержимое всплывающего окна установлено"
```

---

### `gtk_popover_popup` / `gtk_popover_popdown`

```nim
proc gtk_popover_popup*(popover: GtkPopover)
proc gtk_popover_popdown*(popover: GtkPopover)
```

**Что делает.** Программно показывают и скрывают всплывающее окно — например, для показа подсказки или мини-панели по клику на произвольный (не обязательно кнопку) виджет, к которому `GtkPopover` был привязан через `gtk_widget_set_parent`.

- `popover` — всплывающее окно.

```nim
proc onInfoButtonClicked(button: GtkButton, userData: gpointer) {.cdecl.} =
  gtk_popover_popup(infoPopover)
  echo "Всплывающее окно с информацией показано"

discard g_signal_connect(infoButton, "clicked", onInfoButtonClicked, nil)
```

---

### `gtk_widget_get_ancestor`

```nim
proc gtk_widget_get_ancestor*(widget: GtkWidget, widget_type: GType): GtkWidget
```

**Что делает.** Хотя формально это функция `GtkWidget`, а не `GtkPopover`, она особенно полезна именно в контексте всплывающих окон: ищет ближайшего предка виджета заданного типа, поднимаясь вверх по дереву родителей, — например, чтобы из обработчика клика внутри содержимого всплывающего окна получить сам объект `GtkPopover`, в который это содержимое вложено, не передавая его отдельно через `userData` сигнала.

- `widget` — виджет, с которого начинается поиск вверх по дереву.
- `widget_type` — искомый тип (`GType`, полученный, например, через `gtk_popover_get_type()`).

```nim
let popoverAncestor = gtk_widget_get_ancestor(someButtonInsidePopover, gtk_popover_get_type())
if not isNil(popoverAncestor):
  gtk_popover_popdown(cast[GtkPopover](popoverAncestor))
  echo "Всплывающее окно, содержащее эту кнопку, найдено и закрыто"
```

---

## GtkMenuButton

`GtkMenuButton` — кнопка, при клике на которую открывается меню или произвольное всплывающее окно, — самый частый способ показать меню в GTK4 (кнопка "гамбургер"/три точки в заголовке окна, кнопка с треугольником-стрелкой рядом с текстом). Внутри уже содержит и управляет собственным `GtkPopover` — не нужно создавать его отдельно, если достаточно стандартного меню или произвольного содержимого через `set_popover`.

### `gtk_menu_button_new`

```nim
proc gtk_menu_button_new*(): GtkMenuButton
```

**Что делает.** Создаёт кнопку с меню без содержимого (текста/иконки) и без назначенного меню/всплывающего окна — то и другое настраивается отдельно последующими вызовами.

- Параметров нет.

```nim
let menuButton = gtk_menu_button_new()
echo "Кнопка с меню создана"
```

---

### `gtk_menu_button_set_label` / `gtk_menu_button_set_icon_name` / `get_icon_name` / `set_child` / `get_child`

```nim
proc gtk_menu_button_set_label*(button: GtkMenuButton, label: cstring)
proc gtk_menu_button_set_icon_name*(menuButton: GtkMenuButton, iconName: cstring)
proc gtk_menu_button_get_icon_name*(menuButton: GtkMenuButton): cstring
proc gtk_menu_button_set_child*(menuButton: GtkMenuButton, child: GtkWidget)
proc gtk_menu_button_get_child*(menuButton: GtkMenuButton): GtkWidget
```

**Что делает.** Три взаимоисключающих способа задать видимое содержимое кнопки — та же логика выбора, что и у обычной `GtkButton` (справочник по базовым элементам управления): простой текст (`set_label`), иконка по имени из темы (`set_icon_name`/`get_icon_name`), либо полностью произвольный виджет (`set_child`/`get_child`) для сложных случаев вроде иконки с текстом одновременно.

- `button`/`menuButton` — кнопка с меню.
- `label` — текст кнопки.
- `iconName` — имя иконки в теме.
- `child` — произвольный виджет-содержимое.

```nim
gtk_menu_button_set_icon_name(menuButton, "open-menu-symbolic")
echo "Кнопка меню показывает стандартную иконку 'гамбургер'"
```

---

### `gtk_menu_button_set_popover` / `gtk_menu_button_get_popover`

```nim
proc gtk_menu_button_set_popover*(menuButton: GtkMenuButton, popover: GtkWidget)
proc gtk_menu_button_get_popover*(menuButton: GtkMenuButton): GtkPopover
```

**Что делает.** Связывают кнопку с произвольным `GtkPopover` (раздел I) в качестве всплывающего содержимого, открываемого по клику, — используется, когда нужно не готовое меню, а полностью произвольное содержимое (форма, список с превью, что угодно). Отдельно создавать и позиционировать `GtkPopover` вручную через `gtk_widget_set_parent` не требуется — `GtkMenuButton` берёт это на себя после `set_popover`.

- `menuButton` — кнопка с меню.
- `popover` — всплывающее окно (принимает `GtkWidget`, хотя ожидается именно `GtkPopover` — в этой обёртке оба типа взаимозаменяемы как `pointer`).

```nim
let customPopover = gtk_popover_new()
gtk_popover_set_child(customPopover, gtk_calendar_new())
gtk_menu_button_set_popover(menuButton, customPopover)
echo "Кнопка теперь открывает всплывающий календарь вместо обычного меню"
```

---

### `gtk_menu_button_set_menu_model` / `gtk_menu_button_get_menu_model`

```nim
proc gtk_menu_button_set_menu_model*(menuButton: GtkMenuButton, menuModel: GMenuModel)
proc gtk_menu_button_get_menu_model*(menuButton: GtkMenuButton): GMenuModel
```

**Что делает.** Связывают кнопку с моделью меню (`GMenuModel`, та же модель, что используется в `gtk_application_set_menubar` из справочника по window chrome) — GTK автоматически строит `GtkPopover` с пунктами меню из этой модели, без необходимости вручную собирать список пунктов виджетами. Это предпочтительный способ показать классическое меню с пунктами (в отличие от `set_popover`, который нужен для нестандартного содержимого).

- `menuButton` — кнопка с меню.
- `menuModel` — модель меню.

```nim
# actionsMenuModel строится заранее через g_menu_new/g_menu_append
# (справочник по window chrome, раздел про GtkApplication)
gtk_menu_button_set_menu_model(menuButton, actionsMenuModel)
echo "Кнопка меню автоматически построила выпадающий список пунктов из модели"
```

---

### `gtk_menu_button_get_active` / `gtk_menu_button_set_active` / `popup` / `popdown`

```nim
proc gtk_menu_button_get_active*(menuButton: GtkMenuButton): gboolean
proc gtk_menu_button_set_active*(menuButton: GtkMenuButton, active: gboolean)
proc gtk_menu_button_popup*(menuButton: GtkMenuButton)
proc gtk_menu_button_popdown*(menuButton: GtkMenuButton)
```

**Что делает.** Программно открывают/закрывают меню и проверяют, открыто ли оно сейчас. `set_active`/`get_active` — через булево свойство состояния (согласуется с остальными "активными" состояниями переключателей в этой обёртке); `popup`/`popdown` — прямые команды открыть/закрыть, функционально эквивалентные `set_active(true)`/`set_active(false)`.

- `menuButton` — кнопка с меню.
- `active` — `1.gboolean` для открытого состояния.

```nim
gtk_menu_button_popup(menuButton)
echo "Меню открыто программно, без клика пользователя"
```

---

### `gtk_menu_button_set_direction` / `gtk_menu_button_get_direction`

```nim
proc gtk_menu_button_set_direction*(menuButton: GtkMenuButton, direction: GtkArrowType)
proc gtk_menu_button_get_direction*(menuButton: GtkMenuButton): GtkArrowType
```

**Что делает.** Задают, с какой стороны от кнопки появляется всплывающее меню, и одновременно — направление стрелки-индикатора на самой кнопке (если она отображается, см. `set_always_show_arrow` ниже): `GTK_ARROW_DOWN` (значение по умолчанию), `_UP`, `_LEFT`, `_RIGHT`.

- `menuButton` — кнопка с меню.
- `direction` — значение `GtkArrowType`.

```nim
gtk_menu_button_set_direction(bottomToolbarMenuButton, GTK_ARROW_UP)
echo "Меню кнопки, расположенной внизу экрана, теперь открывается вверх"
```

---

### `gtk_menu_button_set_use_underline` / `gtk_menu_button_get_use_underline`

```nim
proc gtk_menu_button_set_use_underline*(menuButton: GtkMenuButton, useUnderline: gboolean)
proc gtk_menu_button_get_use_underline*(menuButton: GtkMenuButton): gboolean
```

**Что делает.** Включают/выключают интерпретацию символа `_` в тексте кнопки (`set_label`) как маркера мнемоники — та же логика, что у `gtk_button_set_use_underline` из справочника по базовым элементам управления.

- `menuButton` — кнопка с меню.
- `useUnderline` — `1.gboolean`, чтобы включить интерпретацию мнемоники.

```nim
gtk_menu_button_set_use_underline(menuButton, 1.gboolean)
gtk_menu_button_set_label(menuButton, "_Файл")  # Alt+Ф открывает меню
```

---

### `gtk_menu_button_set_has_frame` / `gtk_menu_button_get_has_frame`

```nim
proc gtk_menu_button_set_has_frame*(menuButton: GtkMenuButton, hasFrame: gboolean)
proc gtk_menu_button_get_has_frame*(menuButton: GtkMenuButton): gboolean
```

**Что делает.** Убирают/возвращают стандартную рамку кнопки — та же логика, что у `gtk_button_set_has_frame`. Часто отключается для кнопок меню в заголовочной панели (`GtkHeaderBar`), где плоский вид визуально более уместен.

- `menuButton` — кнопка с меню.
- `hasFrame` — `0.gboolean`, чтобы убрать рамку.

```nim
gtk_menu_button_set_has_frame(menuButton, 0.gboolean)
echo "Кнопка меню в заголовке окна теперь плоская, без рамки"
```

---

### `gtk_menu_button_set_primary` / `gtk_menu_button_get_primary`

```nim
proc gtk_menu_button_set_primary*(menuButton: GtkMenuButton, primary: gboolean)
proc gtk_menu_button_get_primary*(menuButton: GtkMenuButton): gboolean
```

**Что делает.** Помечает кнопку меню как "основную" для окна — влияет на позиционирование и поведение в контексте заголовочной панели (например, основная кнопка меню приложения, обычно единственная такая на окно, в отличие от вспомогательных кнопок меню, открывающих контекстные меню отдельных элементов интерфейса).

- `menuButton` — кнопка с меню.
- `primary` — `1.gboolean` для основной кнопки меню окна.

```nim
gtk_menu_button_set_primary(appMenuButton, 1.gboolean)
echo "Кнопка помечена как основное меню приложения"
```

---

### `gtk_menu_button_set_create_popup_func`

```nim
proc gtk_menu_button_set_create_popup_func*(menuButton: GtkMenuButton, callback: pointer, userData: pointer, destroyNotify: pointer)
```

**Что делает.** Назначает функцию, вызываемую непосредственно перед каждым открытием меню, — позволяет динамически пересобрать содержимое всплывающего окна (например, обновить список недавних файлов) прямо перед показом, вместо того чтобы поддерживать его актуальным постоянно. Альтернатива статичному `set_menu_model`/`set_popover`, заданному один раз заранее.

- `menuButton` — кнопка с меню.
- `callback` — указатель на C-совместимую функцию, вызываемую перед открытием.
- `userData` — пользовательские данные, передаваемые в `callback`.
- `destroyNotify` — функция очистки `userData` (можно передать `nil`).

```nim
proc onCreatePopup(button: GtkMenuButton, userData: gpointer) {.cdecl.} =
  let freshPopover = gtk_popover_new()
  # ... наполнение свежими данными, например списком недавних файлов ...
  gtk_menu_button_set_popover(button, freshPopover)
  echo "Содержимое меню пересобрано непосредственно перед открытием"

gtk_menu_button_set_create_popup_func(recentFilesButton, onCreatePopup, nil, nil)
```

---

### `gtk_menu_button_set_always_show_arrow` / `gtk_menu_button_get_always_show_arrow`

```nim
proc gtk_menu_button_set_always_show_arrow*(menuButton: GtkMenuButton, alwaysShowArrow: gboolean)
proc gtk_menu_button_get_always_show_arrow*(menuButton: GtkMenuButton): gboolean
```

**Что делает.** Управляют показом маленькой стрелки-индикатора рядом с содержимым кнопки, сигнализирующей пользователю, что это кнопка с выпадающим меню, а не обычная кнопка действия. Для кнопок с одной лишь иконкой (например, "гамбургер") стрелка обычно избыточна и не показывается по умолчанию; для кнопок с текстом — наоборот, часто ожидаема пользователем.

- `menuButton` — кнопка с меню.
- `alwaysShowArrow` — `1.gboolean`, чтобы всегда показывать стрелку.

```nim
gtk_menu_button_set_always_show_arrow(fileMenuButton, 1.gboolean)
echo "Стрелка-индикатор меню теперь всегда видна рядом с текстом 'Файл'"
```

---

## GtkExpander

`GtkExpander` — сворачиваемая секция: кликабельный заголовок с треугольником-индикатором и скрываемое/показываемое содержимое под ним. Типичное применение — "Дополнительные параметры" в форме, свёрнутые по умолчанию.

### `gtk_expander_new` / `gtk_expander_new_with_mnemonic`

```nim
proc gtk_expander_new*(label: cstring): GtkExpander
proc gtk_expander_new_with_mnemonic*(label: cstring): GtkExpander
```

**Что делает.** Создают свёрнутую по умолчанию секцию с текстовым заголовком. `_with_mnemonic`-вариант интерпретирует `_` перед буквой как маркер мнемоники — та же логика, что у `gtk_button_new_with_mnemonic`.

- `label` — текст заголовка.

```nim
let advancedExpander = gtk_expander_new("Дополнительные параметры")
echo "Свёрнутая секция 'Дополнительные параметры' создана"
```

---

### `gtk_expander_set_expanded` / `gtk_expander_get_expanded`

```nim
proc gtk_expander_set_expanded*(expander: GtkExpander, expanded: gboolean)
proc gtk_expander_get_expanded*(expander: GtkExpander): gboolean
```

**Что делает.** Программно разворачивают/сворачивают секцию и читают её текущее состояние — например, чтобы запомнить между запусками приложения, была ли секция развёрнута в прошлый раз.

- `expander` — секция.
- `expanded` — `1.gboolean` для развёрнутого состояния.

```nim
gtk_expander_set_expanded(advancedExpander, 1.gboolean)
echo "Секция развёрнута: ", gtk_expander_get_expanded(advancedExpander) != 0.gboolean
```

---

### `gtk_expander_set_label` / `gtk_expander_get_label`

```nim
proc gtk_expander_set_label*(expander: GtkExpander, label: cstring)
proc gtk_expander_get_label*(expander: GtkExpander): cstring
```

**Что делает.** Устанавливают и читают текст заголовка уже после создания секции.

- `expander` — секция.
- `label` — новый текст заголовка.

```nim
gtk_expander_set_label(advancedExpander, "Дополнительные параметры (3)")
echo "Заголовок секции обновлён: ", $gtk_expander_get_label(advancedExpander)
```

---

### `gtk_expander_set_child` / `gtk_expander_get_child`

```nim
proc gtk_expander_set_child*(expander: GtkExpander, child: GtkWidget)
proc gtk_expander_get_child*(expander: GtkExpander): GtkWidget
```

**Что делает.** Устанавливают и читают единственный дочерний виджет — содержимое, скрываемое/показываемое при сворачивании/разворачивании. Для нескольких элементов единственным ребёнком делают контейнер.

- `expander` — секция.
- `child` — виджет-содержимое.

```nim
let advancedOptions = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)
gtk_box_append(advancedOptions, gtk_check_button_new_with_label("Подробное логирование"))
gtk_expander_set_child(advancedExpander, advancedOptions)
echo "Содержимое секции установлено — будет скрыто, пока секция свёрнута"
```

---

## GtkCalendar

`GtkCalendar` — виджет выбора даты в виде месячного календаря с возможностью отмечать отдельные дни.

### `gtk_calendar_new`

```nim
proc gtk_calendar_new*(): GtkCalendar
```

**Что делает.** Создаёт календарь, изначально показывающий текущий месяц с выбранной сегодняшней датой.

- Параметров нет.

```nim
let eventCalendar = gtk_calendar_new()
echo "Календарь создан, показывает текущий месяц"
```

---

### `gtk_calendar_select_day`

```nim
proc gtk_calendar_select_day*(calendar: GtkCalendar, day: gint)
```

**Что делает.** Программно выбирает день **в пределах текущего отображаемого месяца** — эта функция принимает только номер дня месяца (1–31), а не полную дату с годом и месяцем.

- `calendar` — календарь.
- `day` — номер дня месяца.

```nim
gtk_calendar_select_day(eventCalendar, 15)
echo "Выбран 15-й день текущего отображаемого месяца"
```

---

### `gtk_calendar_mark_day` / `gtk_calendar_unmark_day` / `gtk_calendar_clear_marks`

```nim
proc gtk_calendar_mark_day*(calendar: GtkCalendar, day: gint)
proc gtk_calendar_unmark_day*(calendar: GtkCalendar, day: gint)
proc gtk_calendar_clear_marks*(calendar: GtkCalendar)
```

**Что делает.** Помечают/снимают пометку с конкретного дня визуальным индикатором (обычно точкой под числом) — независимо от выбора дня. `clear_marks` снимает все пометки текущего месяца разом. Типичное применение — показать дни с запланированными событиями отдельно от выбранного дня.

- `calendar` — календарь.
- `day` — номер дня месяца.

```nim
for eventDay in [3, 10, 22]:
  gtk_calendar_mark_day(eventCalendar, gint(eventDay))
echo "Дни с запланированными событиями отмечены точками"
gtk_calendar_clear_marks(eventCalendar)
```

---

## GtkOverlay

`GtkOverlay` показывает один основной дочерний виджет и произвольное число дополнительных виджетов, наложенных поверх него. Типичное применение — значок-бейдж поверх иконки, водяной знак поверх изображения, плавающая кнопка поверх карты.

### `gtk_overlay_new`

```nim
proc gtk_overlay_new*(): GtkOverlay
```

**Что делает.** Создаёт пустой контейнер наложения.

- Параметров нет.

```nim
let overlay = gtk_overlay_new()
echo "Контейнер наложения создан"
```

---

### `gtk_overlay_set_child` / `gtk_overlay_get_child`

```nim
proc gtk_overlay_set_child*(overlay: GtkOverlay, child: GtkWidget)
proc gtk_overlay_get_child*(overlay: GtkOverlay): GtkWidget
```

**Что делает.** Устанавливают и читают основной (нижний, фоновый) виджет — тот, поверх которого показываются наложенные через `add_overlay` виджеты. Именно основной виджет определяет размер всего контейнера.

- `overlay` — контейнер наложения.
- `child` — основной виджет.

```nim
let mapImage = gtk_image_new_from_file("/usr/share/myapp/map.png")
gtk_overlay_set_child(overlay, mapImage)
echo "Изображение карты установлено как основное (фоновое) содержимое"
```

---

### `gtk_overlay_add_overlay` / `gtk_overlay_remove_overlay`

```nim
proc gtk_overlay_add_overlay*(overlay: GtkOverlay, widget: GtkWidget)
proc gtk_overlay_remove_overlay*(overlay: GtkOverlay, widget: GtkWidget)
```

**Что делает.** Добавляют/убирают виджет, накладываемый поверх основного содержимого. Можно добавить несколько наложенных виджетов — каждый позиционируется независимо через `gtk_widget_set_halign`/`set_valign`/`set_margin_*`.

- `overlay` — контейнер наложения.
- `widget` — накладываемый/убираемый виджет.

```nim
let locationButton = gtk_button_new_from_icon_name("find-location-symbolic")
gtk_widget_set_halign(locationButton, GTK_ALIGN_END)
gtk_widget_set_valign(locationButton, GTK_ALIGN_END)
gtk_widget_set_margin_end(locationButton, 16)
gtk_widget_set_margin_bottom(locationButton, 16)
gtk_overlay_add_overlay(overlay, locationButton)
echo "Плавающая кнопка местоположения размещена в правом нижнем углу поверх карты"
```

---

## GtkFixed

`GtkFixed` — контейнер с абсолютным позиционированием: каждый дочерний виджет размещается по явным пиксельным координатам, без автоматической компоновки. В отличие от остальных контейнеров этой серии справочников, `GtkFixed` **не адаптируется** к изменению размера окна, шрифта или локализации — GTK-документация не рекомендует использовать его для обычных интерфейсов, предпочитая его для специализированных сценариев (canvas-подобные редакторы).

### `gtk_fixed_new`

```nim
proc gtk_fixed_new*(): GtkFixed
```

**Что делает.** Создаёт пустой контейнер абсолютного позиционирования.

- Параметров нет.

```nim
let canvas = gtk_fixed_new()
echo "Контейнер абсолютного позиционирования создан"
```

---

### `gtk_fixed_put` / `gtk_fixed_move` / `gtk_fixed_remove`

```nim
proc gtk_fixed_put*(fixed: GtkFixed, widget: GtkWidget, x: gdouble, y: gdouble)
proc gtk_fixed_move*(fixed: GtkFixed, widget: GtkWidget, x: gdouble, y: gdouble)
proc gtk_fixed_remove*(fixed: GtkFixed, widget: GtkWidget)
```

**Что делает.** `put` добавляет новый виджет по заданным координатам (от левого верхнего угла контейнера). `move` перемещает уже добавленный виджет на новые координаты. `remove` убирает виджет.

- `fixed` — контейнер.
- `widget` — добавляемый/перемещаемый/убираемый виджет.
- `x`, `y` — координаты в пикселях.

```nim
let draggableNode = gtk_button_new_with_label("Узел A")
gtk_fixed_put(canvas, draggableNode, 50.0, 80.0)
echo "Узел размещён по координатам (50, 80)"
gtk_fixed_move(canvas, draggableNode, 120.0, 200.0)
echo "Узел перемещён на новые координаты (120, 200)"
```

---

## GtkAspectFrame

`GtkAspectFrame` — контейнер, поддерживающий заданное соотношение сторон единственного дочернего виджета независимо от выделенного места — содержимое остаётся вписанным с сохранением пропорций (как у видеоплеера с чёрными полосами).

### `gtk_aspect_frame_new`

```nim
proc gtk_aspect_frame_new*(xalign: gfloat, yalign: gfloat, ratio: gfloat, obeyChild: gboolean): GtkAspectFrame
```

**Что делает.** Создаёт контейнер с заданными начальными параметрами. `xalign`/`yalign` — положение содержимого внутри выделенной области (от `0.0` до `1.0`, та же логика, что у `gtk_label_set_xalign`). `ratio` — желаемое соотношение ширины к высоте (например, `16.0/9.0` для видео). `obeyChild`: `1.gboolean` — использовать естественное соотношение сторон дочернего виджета, игнорируя `ratio`; `0.gboolean` — использовать именно заданное значение `ratio`.

- `xalign`, `yalign` — выравнивание содержимого от `0.0` до `1.0`.
- `ratio` — соотношение сторон ширина/высота.
- `obeyChild` — `1.gboolean`, чтобы использовать пропорции самого содержимого.

```nim
let videoFrame = gtk_aspect_frame_new(0.5, 0.5, 16.0 / 9.0, 0.gboolean)
echo "Контейнер с фиксированным соотношением сторон 16:9 создан, содержимое центрировано"
```

---

### `gtk_aspect_frame_set_xalign` / `get_xalign` / `set_yalign` / `get_yalign`

```nim
proc gtk_aspect_frame_set_xalign*(aspectFrame: GtkAspectFrame, xalign: gfloat)
proc gtk_aspect_frame_get_xalign*(aspectFrame: GtkAspectFrame): gfloat
proc gtk_aspect_frame_set_yalign*(aspectFrame: GtkAspectFrame, yalign: gfloat)
proc gtk_aspect_frame_get_yalign*(aspectFrame: GtkAspectFrame): gfloat
```

**Что делает.** Изменяют выравнивание содержимого внутри выделенной области уже после создания контейнера.

- `aspectFrame` — контейнер.
- `xalign`, `yalign` — значения от `0.0` до `1.0`.

```nim
gtk_aspect_frame_set_yalign(videoFrame, 0.0)
echo "Видео теперь прижато к верхнему краю выделенной области"
```

---

### `gtk_aspect_frame_set_ratio` / `gtk_aspect_frame_get_ratio`

```nim
proc gtk_aspect_frame_set_ratio*(aspectFrame: GtkAspectFrame, ratio: gfloat)
proc gtk_aspect_frame_get_ratio*(aspectFrame: GtkAspectFrame): gfloat
```

**Что делает.** Изменяют желаемое соотношение сторон уже после создания — например, при переключении отображаемого видео на другое соотношение сторон.

- `aspectFrame` — контейнер.
- `ratio` — соотношение сторон ширина/высота.

```nim
gtk_aspect_frame_set_ratio(videoFrame, 21.0 / 9.0)
echo "Соотношение сторон переключено на широкоформатное 21:9"
```

---

### `gtk_aspect_frame_set_obey_child` / `gtk_aspect_frame_get_obey_child`

```nim
proc gtk_aspect_frame_set_obey_child*(aspectFrame: GtkAspectFrame, obeyChild: gboolean)
proc gtk_aspect_frame_get_obey_child*(aspectFrame: GtkAspectFrame): gboolean
```

**Что делает.** Переключают источник соотношения сторон между явным значением `ratio` и естественными пропорциями дочернего виджета.

- `aspectFrame` — контейнер.
- `obeyChild` — `1.gboolean`, чтобы использовать пропорции содержимого.

```nim
gtk_aspect_frame_set_obey_child(videoFrame, 1.gboolean)
echo "Соотношение сторон теперь определяется самим изображением, а не заданным ratio"
```

---

### `gtk_aspect_frame_set_child` / `gtk_aspect_frame_get_child`

```nim
proc gtk_aspect_frame_set_child*(aspectFrame: GtkAspectFrame, child: GtkWidget)
proc gtk_aspect_frame_get_child*(aspectFrame: GtkAspectFrame): GtkWidget
```

**Что делает.** Устанавливают и читают единственный дочерний виджет — тот же паттерн "один слот содержимого".

- `aspectFrame` — контейнер.
- `child` — виджет-содержимое.

```nim
gtk_aspect_frame_set_child(videoFrame, videoPlayerWidget)
echo "Видеоплеер вписан в контейнер с сохранением соотношения сторон"
```

---

## Практические рецепты

### Кнопка с выпадающим меню действий

Классическая кнопка "гамбургер" в заголовке окна, открывающая меню, построенное из `GMenuModel`.

```nim
proc buildAppMenuButton(): GtkMenuButton =
  result = gtk_menu_button_new()
  gtk_menu_button_set_icon_name(result, "open-menu-symbolic")
  gtk_menu_button_set_primary(result, 1.gboolean)

  let menu = g_menu_new()
  g_menu_append(menu, "Настройки", "app.preferences")
  g_menu_append(menu, "О программе", "app.about")
  gtk_menu_button_set_menu_model(result, cast[GMenuModel](menu))

  echo "Кнопка меню приложения с пунктами 'Настройки' и 'О программе' собрана"

let appMenuButton = buildAppMenuButton()
```

---

### Кнопка с произвольным всплывающим содержимым (не меню)

Кнопка, открывающая мини-форму быстрой настройки вместо стандартного меню с пунктами.

```nim
proc buildQuickSettingsButton(): GtkMenuButton =
  result = gtk_menu_button_new()
  gtk_menu_button_set_icon_name(result, "preferences-system-symbolic")

  let popover = gtk_popover_new()
  let content = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)
  gtk_widget_set_margin_start(content, 12)
  gtk_widget_set_margin_end(content, 12)
  gtk_widget_set_margin_top(content, 12)
  gtk_widget_set_margin_bottom(content, 12)

  let brightnessScale = gtk_scale_new_with_range(GTK_ORIENTATION_HORIZONTAL, 0.0, 100.0, 5.0)
  gtk_box_append(content, gtk_label_new("Яркость"))
  gtk_box_append(content, brightnessScale)

  gtk_popover_set_child(popover, content)
  gtk_menu_button_set_popover(result, popover)
  echo "Кнопка быстрых настроек с ползунком яркости внутри всплывающего окна собрана"

let quickSettingsButton = buildQuickSettingsButton()
```

---

### Свёрнутая по умолчанию секция «Дополнительные параметры»

Форма с обязательными полями сразу на виду и необязательными — скрытыми в `GtkExpander`.

```nim
proc buildExportForm(): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_VERTICAL, 12)

  let formatCombo = gtk_combo_box_text_new()
  gtk_combo_box_text_append_text(formatCombo, "PNG")
  gtk_combo_box_text_append_text(formatCombo, "JPEG")
  gtk_combo_box_set_active(formatCombo, 0)
  gtk_box_append(result, formatCombo)

  let advanced = gtk_expander_new("Дополнительные параметры")
  let advancedContent = gtk_box_new(GTK_ORIENTATION_VERTICAL, 6)
  gtk_box_append(advancedContent, gtk_check_button_new_with_label("Сохранить метаданные"))
  gtk_box_append(advancedContent, gtk_check_button_new_with_label("Оптимизировать размер файла"))
  gtk_expander_set_child(advanced, advancedContent)
  gtk_box_append(result, advanced)

  echo "Форма экспорта: формат виден сразу, редкие опции скрыты в свёрнутой секции"

let exportForm = buildExportForm()
```

---

### Значок-бейдж поверх изображения через GtkOverlay

Счётчик непрочитанных уведомлений в виде маленького кружка поверх иконки.

```nim
proc buildIconWithBadge(iconName: string, count: int): GtkOverlay =
  result = gtk_overlay_new()

  let icon = gtk_image_new_from_icon_name(iconName.cstring)
  gtk_image_set_pixel_size(icon, 32)
  gtk_overlay_set_child(result, icon)

  if count > 0:
    let badge = gtk_label_new($count)
    gtk_widget_add_css_class(badge, "badge")
    gtk_widget_set_halign(badge, GTK_ALIGN_END)
    gtk_widget_set_valign(badge, GTK_ALIGN_START)
    gtk_overlay_add_overlay(result, badge)

  echo "Иконка с бейджем количества (", count, ") собрана"

let notificationsIcon = buildIconWithBadge("mail-symbolic", 5)
```

---

### Видео/изображение с сохранением соотношения сторон 16:9

Область предпросмотра видео, которая никогда не искажает пропорции кадра независимо от размера окна.

```nim
proc buildVideoPreviewArea(): GtkAspectFrame =
  result = gtk_aspect_frame_new(0.5, 0.5, 16.0 / 9.0, 0.gboolean)
  gtk_widget_add_css_class(result, "video-frame-background")

  let videoDrawing = gtk_drawing_area_new()
  gtk_aspect_frame_set_child(result, videoDrawing)
  echo "Область предпросмотра видео с фиксированным соотношением сторон 16:9 готова"

let videoPreview = buildVideoPreviewArea()
```

---

## Краткая таблица

| Процедура(ы) | Категория | Что делает вкратце |
|---|---|---|
| `gtk_popover_new` | Popover | Создать всплывающее окно |
| `gtk_popover_set/get_child` | Popover | Единственный дочерний виджет |
| `gtk_popover_popup/popdown` | Popover | Программно показать/скрыть |
| `gtk_widget_get_ancestor` | Popover/Widget | Найти ближайшего предка заданного типа |
| `gtk_menu_button_new` | MenuButton | Создать кнопку с меню |
| `gtk_menu_button_set_label`, `set/get_icon_name`, `set/get_child` | MenuButton | Видимое содержимое кнопки |
| `gtk_menu_button_set/get_popover` | MenuButton | Произвольное всплывающее содержимое |
| `gtk_menu_button_set/get_menu_model` | MenuButton | Готовое меню из GMenuModel |
| `gtk_menu_button_get/set_active`, `popup`, `popdown` | MenuButton | Программное управление открытием |
| `gtk_menu_button_set/get_direction` | MenuButton | С какой стороны открывается меню |
| `gtk_menu_button_set/get_use_underline` | MenuButton | Мнемоника в тексте кнопки |
| `gtk_menu_button_set/get_has_frame` | MenuButton | Рамка кнопки |
| `gtk_menu_button_set/get_primary` | MenuButton | Основная кнопка меню окна |
| `gtk_menu_button_set_create_popup_func` | MenuButton | Пересборка содержимого перед каждым открытием |
| `gtk_menu_button_set/get_always_show_arrow` | MenuButton | Стрелка-индикатор меню |
| `gtk_expander_new`, `_with_mnemonic` | Expander | Создать сворачиваемую секцию |
| `gtk_expander_set/get_expanded` | Expander | Развёрнута ли секция |
| `gtk_expander_set/get_label` | Expander | Текст заголовка |
| `gtk_expander_set/get_child` | Expander | Скрываемое/показываемое содержимое |
| `gtk_calendar_new` | Calendar | Создать календарь |
| `gtk_calendar_select_day` | Calendar | Выбрать день текущего месяца |
| `gtk_calendar_mark/unmark_day`, `clear_marks` | Calendar | Визуальные пометки дней |
| `gtk_overlay_new` | Overlay | Создать контейнер наложения |
| `gtk_overlay_set/get_child` | Overlay | Основной (фоновый) виджет |
| `gtk_overlay_add/remove_overlay` | Overlay | Наложенные поверх виджеты |
| `gtk_fixed_new` | Fixed | Создать контейнер абсолютного позиционирования |
| `gtk_fixed_put`, `move`, `remove` | Fixed | Разместить/переместить/убрать по координатам |
| `gtk_aspect_frame_new` | AspectFrame | Создать контейнер с фиксированным соотношением сторон |
| `gtk_aspect_frame_set/get_xalign`, `set/get_yalign` | AspectFrame | Выравнивание содержимого в области |
| `gtk_aspect_frame_set/get_ratio` | AspectFrame | Желаемое соотношение сторон |
| `gtk_aspect_frame_set/get_obey_child` | AspectFrame | Источник соотношения — ratio или сам контент |
| `gtk_aspect_frame_set/get_child` | AspectFrame | Единственный дочерний виджет |

---

## Сводка: какую процедуру выбрать

- **Кнопка, открывающая список пунктов меню** → `gtk_menu_button_set_menu_model` с готовой `GMenuModel` — GTK сама строит всплывающий список, не нужно вручную собирать виджеты пунктов. **Кнопка, открывающая произвольное содержимое** (форму, календарь, что угодно, кроме списка пунктов) → `gtk_menu_button_set_popover` с самостоятельно собранным `GtkPopover`.
- **Всплывающее содержимое нужно вне контекста кнопки** (привязано к произвольному виджету, не обязательно кнопке) → `GtkPopover` напрямую через `gtk_widget_set_parent` + `gtk_popover_popup`/`popdown`, а не `GtkMenuButton`, который жёстко привязан к кнопке.
- **Скрыть редко нужные опции, не убирая их совсем** → `GtkExpander`, свёрнутый по умолчанию (`gtk_expander_set_expanded(false)` — фактически значение по умолчанию при создании).
- **Наложить один виджет на другой** (бейдж, водяной знак, плавающая кнопка) → `GtkOverlay`, а не пытаться добиться того же через абсолютное позиционирование в `GtkFixed` — `GtkOverlay` сам следует за размером основного содержимого при изменении окна, `GtkFixed` — нет.
- **Позиционирование по абсолютным координатам действительно необходимо** (canvas-редактор, где координаты — часть модели данных, а не просто вёрстки) → `GtkFixed`, с пониманием, что это осознанный отход от адаптивной раскладки, которую GTK обеспечивает по умолчанию для всех остальных контейнеров этой серии справочников.
- **Видео/изображение не должно искажаться при изменении размера окна** → `GtkAspectFrame` с явным `ratio`, а не `gtk_widget_set_size_request` на самом содержимом — последнее задаёт минимум, но не поддерживает пропорции при растягивании контейнера.
- **Отметить в календаре дни с событиями, отдельно от текущего выбранного дня** → `gtk_calendar_mark_day`, а не `gtk_calendar_select_day` — выбор и пометка визуально и по смыслу независимы друг от друга.
