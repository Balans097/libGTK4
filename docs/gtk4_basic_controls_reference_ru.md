# GTK4 (basic controls: Button / ToggleButton / CheckButton / Switch / Label) — справочник модуля

> **Импорт:** `import libGTK4`
> **Область применения:** базовые интерактивные и текстово-отображающие виджеты GTK4 — кнопки всех разновидностей, переключатели и надписи. Это вторая часть серии справочников по обёртке; первая часть (`gtk4_core_reference_ru.md`) охватывает инициализацию, `GtkApplication`/`GApplication`, `GtkWindow`, базовый интерфейс `GtkWidget` и контейнеры `GtkBox`/`GtkGrid` — примеры этого справочника предполагают знакомство с ней (создание окна, компоновка, `g_signal_connect`).

Этот справочник охватывает: `GtkButton` (обычная кнопка), `GtkToggleButton` (кнопка-переключатель с двумя состояниями), `GtkCheckButton` (флажок/радиокнопка — в GTK4 это один и тот же класс), `GtkSwitch` (тумблер в стиле мобильных интерфейсов) и `GtkLabel` (статичный или интерактивный текст). Поле ввода текста (`GtkEntry` и родственные) вынесено в отдельный справочник по вводу текста — раздел ENTRY достаточно велик, чтобы рассматривать его отдельно.

---

## Оглавление

I. [GtkButton](#gtkbutton)
&nbsp;&nbsp;1. [`gtk_button_new` / `gtk_button_new_with_label` / `gtk_button_new_with_mnemonic` / `gtk_button_new_from_icon_name`](#gtk_button_new--gtk_button_new_with_label--gtk_button_new_with_mnemonic--gtk_button_new_from_icon_name)
&nbsp;&nbsp;2. [`gtk_button_set_label` / `gtk_button_get_label`](#gtk_button_set_label--gtk_button_get_label)
&nbsp;&nbsp;3. [`gtk_button_set_use_underline` / `gtk_button_get_use_underline`](#gtk_button_set_use_underline--gtk_button_get_use_underline)
&nbsp;&nbsp;4. [`gtk_button_set_child` / `gtk_button_get_child`](#gtk_button_set_child--gtk_button_get_child)
&nbsp;&nbsp;5. [`gtk_button_set_has_frame` / `gtk_button_get_has_frame`](#gtk_button_set_has_frame--gtk_button_get_has_frame)
&nbsp;&nbsp;6. [`gtk_button_set_icon_name` / `gtk_button_get_icon_name`](#gtk_button_set_icon_name--gtk_button_get_icon_name)
&nbsp;&nbsp;7. [`gtk_button_set_can_shrink` / `gtk_button_get_can_shrink`](#gtk_button_set_can_shrink--gtk_button_get_can_shrink)
&nbsp;&nbsp;8. [`gtk_actionable_set_detailed_action_name`](#gtk_actionable_set_detailed_action_name)

II. [GtkToggleButton](#gtktogglebutton)
&nbsp;&nbsp;1. [`gtk_toggle_button_new` / `gtk_toggle_button_new_with_label` / `gtk_toggle_button_new_with_mnemonic`](#gtk_toggle_button_new--gtk_toggle_button_new_with_label--gtk_toggle_button_new_with_mnemonic)
&nbsp;&nbsp;2. [`gtk_toggle_button_set_active` / `gtk_toggle_button_get_active`](#gtk_toggle_button_set_active--gtk_toggle_button_get_active)
&nbsp;&nbsp;3. [`gtk_toggle_button_toggled`](#gtk_toggle_button_toggled)
&nbsp;&nbsp;4. [`gtk_toggle_button_set_group`](#gtk_toggle_button_set_group)

III. [GtkCheckButton](#gtkcheckbutton)
&nbsp;&nbsp;1. [`gtk_check_button_new` / `gtk_check_button_new_with_label` / `gtk_check_button_new_with_mnemonic`](#gtk_check_button_new--gtk_check_button_new_with_label--gtk_check_button_new_with_mnemonic)
&nbsp;&nbsp;2. [`gtk_check_button_set_active` / `gtk_check_button_get_active`](#gtk_check_button_set_active--gtk_check_button_get_active)
&nbsp;&nbsp;3. [`gtk_check_button_set_inconsistent` / `gtk_check_button_get_inconsistent`](#gtk_check_button_set_inconsistent--gtk_check_button_get_inconsistent)
&nbsp;&nbsp;4. [`gtk_check_button_set_group`](#gtk_check_button_set_group)
&nbsp;&nbsp;5. [`gtk_check_button_set_label` / `gtk_check_button_get_label`](#gtk_check_button_set_label--gtk_check_button_get_label)
&nbsp;&nbsp;6. [`gtk_check_button_set_use_underline` / `gtk_check_button_get_use_underline`](#gtk_check_button_set_use_underline--gtk_check_button_get_use_underline)
&nbsp;&nbsp;7. [`gtk_check_button_set_child` / `gtk_check_button_get_child`](#gtk_check_button_set_child--gtk_check_button_get_child)

IV. [GtkSwitch](#gtkswitch)
&nbsp;&nbsp;1. [`gtk_switch_new`](#gtk_switch_new)
&nbsp;&nbsp;2. [`gtk_switch_set_active` / `gtk_switch_get_active`](#gtk_switch_set_active--gtk_switch_get_active)
&nbsp;&nbsp;3. [`gtk_switch_set_state` / `gtk_switch_get_state`](#gtk_switch_set_state--gtk_switch_get_state)

V. [GtkLabel](#gtklabel)
&nbsp;&nbsp;1. [`gtk_label_new` / `gtk_label_new_with_mnemonic`](#gtk_label_new--gtk_label_new_with_mnemonic)
&nbsp;&nbsp;2. [`gtk_label_set_text` / `gtk_label_get_text`](#gtk_label_set_text--gtk_label_get_text)
&nbsp;&nbsp;3. [`gtk_label_set_markup` / `gtk_label_set_markup_with_mnemonic`](#gtk_label_set_markup--gtk_label_set_markup_with_mnemonic)
&nbsp;&nbsp;4. [`gtk_label_set_use_markup` / `gtk_label_get_use_markup`](#gtk_label_set_use_markup--gtk_label_get_use_markup)
&nbsp;&nbsp;5. [`gtk_label_set_use_underline` / `gtk_label_get_use_underline`](#gtk_label_set_use_underline--gtk_label_get_use_underline)
&nbsp;&nbsp;6. [`gtk_label_set_justify` / `gtk_label_get_justify`](#gtk_label_set_justify--gtk_label_get_justify)
&nbsp;&nbsp;7. [`gtk_label_set_wrap` / `gtk_label_get_wrap` / `gtk_label_set_wrap_mode` / `gtk_label_get_wrap_mode`](#gtk_label_set_wrap--gtk_label_get_wrap--gtk_label_set_wrap_mode--gtk_label_get_wrap_mode)
&nbsp;&nbsp;8. [`gtk_label_set_selectable` / `gtk_label_get_selectable`](#gtk_label_set_selectable--gtk_label_get_selectable)
&nbsp;&nbsp;9. [`gtk_label_set_width_chars` / `gtk_label_get_width_chars` / `gtk_label_set_max_width_chars` / `gtk_label_get_max_width_chars`](#gtk_label_set_width_chars--gtk_label_get_width_chars--gtk_label_set_max_width_chars--gtk_label_get_max_width_chars)
&nbsp;&nbsp;10. [`gtk_label_set_ellipsize` / `gtk_label_get_ellipsize`](#gtk_label_set_ellipsize--gtk_label_get_ellipsize)
&nbsp;&nbsp;11. [`gtk_label_select_region` / `gtk_label_get_selection_bounds`](#gtk_label_select_region--gtk_label_get_selection_bounds)
&nbsp;&nbsp;12. [`gtk_label_set_attributes` / `gtk_label_get_attributes`](#gtk_label_set_attributes--gtk_label_get_attributes)
&nbsp;&nbsp;13. [`gtk_label_set_mnemonic_widget` / `gtk_label_get_mnemonic_widget`](#gtk_label_set_mnemonic_widget--gtk_label_get_mnemonic_widget)
&nbsp;&nbsp;14. [`gtk_label_set_single_line_mode` / `gtk_label_get_single_line_mode`](#gtk_label_set_single_line_mode--gtk_label_get_single_line_mode)
&nbsp;&nbsp;15. [`gtk_label_set_lines` / `gtk_label_get_lines`](#gtk_label_set_lines--gtk_label_get_lines)
&nbsp;&nbsp;16. [`gtk_label_set_xalign` / `gtk_label_get_xalign` / `gtk_label_set_yalign` / `gtk_label_get_yalign`](#gtk_label_set_xalign--gtk_label_get_xalign--gtk_label_set_yalign--gtk_label_get_yalign)
&nbsp;&nbsp;17. [`gtk_label_set_extra_menu` / `gtk_label_get_extra_menu`](#gtk_label_set_extra_menu--gtk_label_get_extra_menu)
&nbsp;&nbsp;18. [`gtk_label_set_natural_wrap_mode` / `gtk_label_get_natural_wrap_mode`](#gtk_label_set_natural_wrap_mode--gtk_label_get_natural_wrap_mode)
&nbsp;&nbsp;19. [`gtk_label_set_tabs` / `gtk_label_get_tabs`](#gtk_label_set_tabs--gtk_label_get_tabs)
&nbsp;&nbsp;20. [`gtk_label_get_current_uri`](#gtk_label_get_current_uri)
&nbsp;&nbsp;21. [`gtk_label_get_layout` / `gtk_label_get_layout_offsets`](#gtk_label_get_layout--gtk_label_get_layout_offsets)

VI. [Практические рецепты](#практические-рецепты)
&nbsp;&nbsp;1. [Группа радиокнопок на GtkCheckButton](#группа-радиокнопок-на-gtkcheckbutton)
&nbsp;&nbsp;2. [Панель настроек: подписанные переключатели GtkSwitch](#панель-настроек-подписанные-переключатели-gtkswitch)
&nbsp;&nbsp;3. [Кнопка с иконкой и текстом одновременно](#кнопка-с-иконкой-и-текстом-одновременно)
&nbsp;&nbsp;4. [Надпись с переносом, обрезкой и выделяемым текстом](#надпись-с-переносом-обрезкой-и-выделяемым-текстом)
&nbsp;&nbsp;5. [Мнемоника: подпись, передающая фокус полю по Alt+буква](#мнемоника-подпись-передающая-фокус-полю-по-altбуква)

VII. [Краткая таблица](#краткая-таблица)

VIII. [Сводка: какую процедуру выбрать](#сводка-какую-процедуру-выбрать)

---

## GtkButton

`GtkButton` — обычная нажимаемая кнопка. Содержимое кнопки в GTK4 — произвольный дочерний виджет (`gtk_button_set_child`), а не жёстко заданный текст: конструкторы `_with_label`/`_from_icon_name` — это просто удобные обёртки, которые сами создают подходящий дочерний виджет (`GtkLabel` или `GtkImage`).

### `gtk_button_new` / `gtk_button_new_with_label` / `gtk_button_new_with_mnemonic` / `gtk_button_new_from_icon_name`

```nim
proc gtk_button_new*(): GtkButton
proc gtk_button_new_with_label*(label: cstring): GtkButton
proc gtk_button_new_with_mnemonic*(label: cstring): GtkButton
proc gtk_button_new_from_icon_name*(icon_name: cstring): GtkButton
```

**Что делает.** Четыре способа создать кнопку. `gtk_button_new` создаёт пустую кнопку без содержимого — дочерний виджет нужно установить отдельно через `gtk_button_set_child`. `gtk_button_new_with_label` сразу создаёт кнопку с текстовой подписью. `gtk_button_new_with_mnemonic` — то же самое, но подчёркнутая буква после символа `_` в тексте (например, `"_Открыть"`) становится мнемоникой — комбинация `Alt+О` активирует кнопку, даже если фокус находится на другом виджете окна. `gtk_button_new_from_icon_name` создаёт кнопку с иконкой из системной темы вместо текста (типично для панелей инструментов).

- `label` — текст подписи (для мнемонического варианта — с символом `_` перед буквой-акселератором).
- `icon_name` — имя иконки в теме (например, `"document-open-symbolic"`).

```nim
let openButton = gtk_button_new_with_mnemonic("_Открыть")
# Alt+О активирует кнопку из любого места окна
let closeIconButton = gtk_button_new_from_icon_name("window-close-symbolic")
echo "Созданы кнопка с мнемоникой и кнопка-иконка"
```

---

### `gtk_button_set_label` / `gtk_button_get_label`

```nim
proc gtk_button_set_label*(button: GtkButton, label: cstring)
proc gtk_button_get_label*(button: GtkButton): cstring
```

**Что делает.** Устанавливают и читают текст кнопки. Если у кнопки в данный момент дочерний виджет — не простая надпись (например, был вызван `gtk_button_set_child` с произвольным `GtkBox`, содержащим иконку и текст), `gtk_button_set_label` заменяет содержимое кнопки на простую `GtkLabel` с указанным текстом — вызов не пытается найти и обновить текст внутри сложной композиции.

- **Реализация.** Для кнопок со сложным содержимым (иконка + текст, см. раздел VI, «Кнопка с иконкой и текстом одновременно») текст нужно менять напрямую через `gtk_label_set_text` на конкретном дочернем `GtkLabel`, а не через `gtk_button_set_label`.

- `button` — кнопка.
- `label` — новый текст.

```nim
let button = gtk_button_new_with_label("Сохранить")
gtk_button_set_label(button, "Сохранение...")
echo "Текст кнопки: ", $gtk_button_get_label(button)
# выводит "Текст кнопки: Сохранение..."
```

---

### `gtk_button_set_use_underline` / `gtk_button_get_use_underline`

```nim
proc gtk_button_set_use_underline*(button: GtkButton, useUnderline: gboolean)
proc gtk_button_get_use_underline*(button: GtkButton): gboolean
```

**Что делает.** Включают/выключают интерпретацию символа `_` в тексте кнопки как маркера мнемоники (то же поведение, которое `gtk_button_new_with_mnemonic` включает автоматически при создании). Полезно, если текст кнопки устанавливается уже после создания через `gtk_button_new`/`gtk_button_set_label`, а не сразу в конструкторе.

- `button` — кнопка.
- `useUnderline` — `1.gboolean`, чтобы включить интерпретацию `_` как мнемоники.

```nim
let button = gtk_button_new()
gtk_button_set_use_underline(button, 1.gboolean)
gtk_button_set_label(button, "_Печать")  # Alt+П теперь активирует кнопку
echo "Мнемоника включена: ", gtk_button_get_use_underline(button) != 0.gboolean
```

---

### `gtk_button_set_child` / `gtk_button_get_child`

```nim
proc gtk_button_set_child*(button: GtkButton, child: GtkWidget)
proc gtk_button_get_child*(button: GtkButton): GtkWidget
```

**Что делает.** Устанавливают произвольный дочерний виджет кнопки — то, что реально отображается внутри неё. Именно так строится содержимое сложнее простого текста: иконка с подписью рядом, индикатор загрузки и т.п. — единственный дочерний виджет оборачивается в `GtkBox` (см. раздел VI, «Кнопка с иконкой и текстом одновременно»).

- `button` — кнопка.
- `child` — виджет-содержимое (передача `nil` очищает кнопку).

```nim
let content = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 6)
gtk_box_append(content, gtk_image_new_from_icon_name("document-save-symbolic"))
gtk_box_append(content, gtk_label_new("Сохранить"))
gtk_button_set_child(saveButton, content)
echo "Содержимое кнопки заменено на иконку с подписью"
```

---

### `gtk_button_set_has_frame` / `gtk_button_get_has_frame`

```nim
proc gtk_button_set_has_frame*(button: GtkButton, hasFrame: gboolean)
proc gtk_button_get_has_frame*(button: GtkButton): gboolean
```

**Что делает.** Убирают/возвращают стандартную рамку и фон кнопки, оставляя только её содержимое, — визуально это то же самое, что и CSS-класс `"flat"` (см. `gtk_widget_add_css_class` в базовом справочнике). Используется для кнопок в панелях инструментов и заголовках, где явная рамка кнопки визуально избыточна и подсвечивается только при наведении/нажатии.

- `button` — кнопка.
- `hasFrame` — `0.gboolean`, чтобы убрать рамку.

```nim
gtk_button_set_has_frame(toolbarButton, 0.gboolean)
echo "Кнопка без рамки: ", gtk_button_get_has_frame(toolbarButton) == 0.gboolean
```

---

### `gtk_button_set_icon_name` / `gtk_button_get_icon_name`

```nim
proc gtk_button_set_icon_name*(button: GtkButton, iconName: cstring)
proc gtk_button_get_icon_name*(button: GtkButton): cstring
```

**Что делает.** Заменяют содержимое кнопки на иконку из темы по имени — эквивалент вызова `gtk_button_set_child` с созданным вручную `GtkImage`, но короче. `gtk_button_get_icon_name` возвращает имя, только если текущее содержимое кнопки было установлено именно так (или через `gtk_button_new_from_icon_name`) — для кнопки с текстом или сложным содержимым вернёт `nil`.

- `button` — кнопка.
- `iconName` — имя иконки в теме.

```nim
gtk_button_set_icon_name(deleteButton, "user-trash-symbolic")
echo "Иконка кнопки: ", $gtk_button_get_icon_name(deleteButton)
```

---

### `gtk_button_set_can_shrink` / `gtk_button_get_can_shrink`

```nim
proc gtk_button_set_can_shrink*(button: GtkButton, can_shrink: gboolean)
proc gtk_button_get_can_shrink*(button: GtkButton): gboolean
```

**Что делает.** Разрешают кнопке сжиматься меньше естественного размера её содержимого (обрезая текст/иконку), вместо того чтобы принудительно требовать себе минимум места, равный полному размеру содержимого. Актуально для кнопок в тесных панелях инструментов, где по умолчанию GTK предпочла бы вообще не показывать кнопку, если места не хватает.

- `button` — кнопка.
- `can_shrink` — `1.gboolean`, чтобы разрешить сжатие.

```nim
gtk_button_set_can_shrink(compactToolbarButton, 1.gboolean)
echo "Кнопка может сжиматься меньше естественного размера: ", gtk_button_get_can_shrink(compactToolbarButton) != 0.gboolean
```

---

### `gtk_actionable_set_detailed_action_name`

```nim
proc gtk_actionable_set_detailed_action_name*(actionable: GtkWidget, detailedActionName: cstring)
```

**Что делает.** Привязывает кнопку (или любой другой `Actionable`-виджет) к действию (Action) приложения или окна одной строкой вида `"группа.имя"` или `"группа.имя(параметр)"` — короткая альтернатива раздельным `gtk_actionable_set_action_name` + `gtk_actionable_set_action_target_value` из базового справочника, когда параметр действия не нужен передавать программно, а можно сразу зашить в строку.

- `actionable` — виджет, реализующий интерфейс `GtkActionable` (в частности, `GtkButton`).
- `detailedActionName` — строка вида `"win.close"`, `"app.quit"`, `"win.set-view('grid')"`.

```nim
gtk_actionable_set_detailed_action_name(closeButton, "win.close")
echo "Кнопка привязана к действию win.close"
```

---

## GtkToggleButton

`GtkToggleButton` — кнопка с двумя устойчивыми состояниями (нажата/отжата), сохраняющая своё состояние между кликами, в отличие от обычной `GtkButton`, которая лишь эмитирует сигнал `"clicked"` и не хранит состояния сама. Визуально выглядит как обычная кнопка, но остаётся "вдавленной" после клика, пока её не нажмут повторно.

### `gtk_toggle_button_new` / `gtk_toggle_button_new_with_label` / `gtk_toggle_button_new_with_mnemonic`

```nim
proc gtk_toggle_button_new*(): GtkToggleButton
proc gtk_toggle_button_new_with_label*(label: cstring): GtkToggleButton
proc gtk_toggle_button_new_with_mnemonic*(label: cstring): GtkToggleButton
```

**Что делает.** Создают кнопку-переключатель — пустую, с текстовой подписью, или с подписью и мнемоникой (символ `_` перед буквой-акселератором — та же логика, что у `gtk_button_new_with_mnemonic`).

- `label` — текст подписи.

```nim
let boldToggle = gtk_toggle_button_new_with_label("Ж")
echo "Кнопка-переключатель для жирного начертания создана"
```

---

### `gtk_toggle_button_set_active` / `gtk_toggle_button_get_active`

```nim
proc gtk_toggle_button_set_active*(toggleButton: GtkToggleButton, isActive: gboolean)
proc gtk_toggle_button_get_active*(toggleButton: GtkToggleButton): gboolean
```

**Что делает.** Устанавливают и читают текущее состояние кнопки (нажата/отжата) программно — например, чтобы отразить внешнее состояние (текущее форматирование текста под курсором) без ожидания клика пользователя. Программная установка через `set_active` тоже эмитирует сигнал `"toggled"`, как и клик пользователя, — обработчик сигнала не может отличить программное изменение от пользовательского без дополнительной логики.

- `toggleButton` — кнопка-переключатель.
- `isActive` — `1.gboolean` для нажатого состояния.

```nim
gtk_toggle_button_set_active(boldToggle, 1.gboolean)
echo "Кнопка 'Ж' нажата: ", gtk_toggle_button_get_active(boldToggle) != 0.gboolean
```

---

### `gtk_toggle_button_toggled`

```nim
proc gtk_toggle_button_toggled*(toggleButton: GtkToggleButton)
```

**Что делает.** Принудительно эмитирует сигнал `"toggled"` без изменения самого состояния `active` — крайне редко нужен напрямую (в подавляющем большинстве случаев состояние меняют через `set_active`, что уже само эмитирует сигнал). Может пригодиться, если внешнее состояние, от которого зависит вид переключателя, изменилось без изменения самого булева `active` (нетипичный сценарий).

- `toggleButton` — кнопка-переключатель.

```nim
gtk_toggle_button_toggled(boldToggle)  # принудительно уведомить подписчиков "toggled"
echo "Сигнал toggled отправлен вручную"
```

---

### `gtk_toggle_button_set_group`

```nim
proc gtk_toggle_button_set_group*(toggle_button: GtkToggleButton, group: GtkToggleButton)
```

**Что делает.** Объединяет кнопку-переключатель в группу с другой кнопкой-переключателем — в пределах группы одновременно может быть нажата только одна кнопка (аналог радиокнопок, но на основе `GtkToggleButton`, что удобно для панелей выбора режима, оформленных как ряд одинаковых кнопок, например переключатель "Список / Сетка" в панели инструментов). Передача `nil` вместо `group` убирает кнопку из группы, в которой она состояла.

- `toggle_button` — кнопка, которую нужно добавить в группу.
- `group` — любая другая кнопка, уже состоящая в целевой группе (либо `nil`, чтобы выйти из группы).

```nim
let listViewToggle = gtk_toggle_button_new_with_label("Список")
let gridViewToggle = gtk_toggle_button_new_with_label("Сетка")
gtk_toggle_button_set_group(gridViewToggle, listViewToggle)
gtk_toggle_button_set_active(listViewToggle, 1.gboolean)  # по умолчанию активен вид "Список"
echo "Кнопки 'Список' и 'Сетка' объединены в группу взаимоисключающего выбора"
```

---

## GtkCheckButton

В GTK4 `GtkCheckButton` — это единый класс и для обычных флажков (checkbox), и для радиокнопок: разница только в том, объединена ли кнопка с другими через `gtk_check_button_set_group` (тогда визуально и по поведению она становится радиокнопкой) или существует независимо (тогда это обычный флажок). Отдельного класса `GtkRadioButton` в GTK4 не существует.

### `gtk_check_button_new` / `gtk_check_button_new_with_label` / `gtk_check_button_new_with_mnemonic`

```nim
proc gtk_check_button_new*(): GtkCheckButton
proc gtk_check_button_new_with_label*(label: cstring): GtkCheckButton
proc gtk_check_button_new_with_mnemonic*(label: cstring): GtkCheckButton
```

**Что делает.** Создают флажок/радиокнопку — пустую (подпись задаётся отдельно через `gtk_check_button_set_label` либо произвольным дочерним виджетом через `set_child`), с текстовой подписью, либо с подписью и мнемоникой.

- `label` — текст подписи.

```nim
let agreeCheck = gtk_check_button_new_with_label("Я принимаю условия использования")
echo "Флажок согласия с условиями создан"
```

---

### `gtk_check_button_set_active` / `gtk_check_button_get_active`

```nim
proc gtk_check_button_set_active*(checkButton: GtkCheckButton, setting: gboolean)
proc gtk_check_button_get_active*(checkButton: GtkCheckButton): gboolean
```

**Что делает.** Устанавливают и читают, отмечен ли флажок (или, для радиокнопки внутри группы, — выбрана ли именно эта). Для радиокнопки программная установка `set_active(true)` для одной кнопки группы автоматически снимает отметку с остальных кнопок той же группы.

- `checkButton` — флажок/радиокнопка.
- `setting` — `1.gboolean` для отмеченного состояния.

```nim
gtk_check_button_set_active(agreeCheck, 1.gboolean)
echo "Условия приняты: ", gtk_check_button_get_active(agreeCheck) != 0.gboolean
```

---

### `gtk_check_button_set_inconsistent` / `gtk_check_button_get_inconsistent`

```nim
proc gtk_check_button_set_inconsistent*(checkButton: GtkCheckButton, inconsistent: gboolean)
proc gtk_check_button_get_inconsistent*(checkButton: GtkCheckButton): gboolean
```

**Что делает.** Включают "неопределённое" визуальное состояние флажка (обычно отображается как прочерк вместо галочки/пустоты) — используется, когда флажок представляет группу вложенных элементов с частично смешанным состоянием (например, флажок "Выбрать всё" в списке, где отмечена только часть элементов). Это чисто визуальный режим — он не меняет значение, возвращаемое `gtk_check_button_get_active`, и снимается автоматически при следующем клике пользователя по флажку.

- `checkButton` — флажок.
- `inconsistent` — `1.gboolean`, чтобы включить неопределённое состояние.

```nim
gtk_check_button_set_inconsistent(selectAllCheck, 1.gboolean)
echo "Показан прочерк вместо галочки: ", gtk_check_button_get_inconsistent(selectAllCheck) != 0.gboolean
```

---

### `gtk_check_button_set_group`

```nim
proc gtk_check_button_set_group*(check_button: GtkCheckButton, group: GtkCheckButton)
```

**Что делает.** Объединяет флажок с другим в группу взаимоисключающего выбора — именно так в GTK4 создаются радиокнопки: превращает набор независимых флажков в набор, где одновременно отмечен только один. Передача `nil` возвращает кнопку в режим независимого флажка.

- `check_button` — кнопка, которую нужно добавить в группу.
- `group` — любая другая кнопка, уже состоящая в целевой группе (либо `nil`, чтобы выйти из группы).

```nim
let optionA = gtk_check_button_new_with_label("Вариант A")
let optionB = gtk_check_button_new_with_label("Вариант B")
let optionC = gtk_check_button_new_with_label("Вариант C")
gtk_check_button_set_group(optionB, optionA)
gtk_check_button_set_group(optionC, optionA)
gtk_check_button_set_active(optionA, 1.gboolean)
echo "Три радиокнопки объединены в одну группу, по умолчанию выбран вариант A"
```

---

### `gtk_check_button_set_label` / `gtk_check_button_get_label`

```nim
proc gtk_check_button_set_label*(check_button: GtkCheckButton, label: cstring)
proc gtk_check_button_get_label*(check_button: GtkCheckButton): cstring
```

**Что делает.** Устанавливают и читают текст подписи флажка/радиокнопки уже после создания.

- `check_button` — флажок/радиокнопка.
- `label` — новый текст.

```nim
gtk_check_button_set_label(agreeCheck, "Согласен с обновлённой политикой конфиденциальности")
echo "Текст флажка: ", $gtk_check_button_get_label(agreeCheck)
```

---

### `gtk_check_button_set_use_underline` / `gtk_check_button_get_use_underline`

```nim
proc gtk_check_button_set_use_underline*(check_button: GtkCheckButton, use_underline: gboolean)
proc gtk_check_button_get_use_underline*(check_button: GtkCheckButton): gboolean
```

**Что делает.** Включают/выключают интерпретацию символа `_` в подписи как маркера мнемоники — та же логика, что у `gtk_button_set_use_underline`.

- `check_button` — флажок/радиокнопка.
- `use_underline` — `1.gboolean`, чтобы включить интерпретацию мнемоники.

```nim
gtk_check_button_set_use_underline(agreeCheck, 1.gboolean)
gtk_check_button_set_label(agreeCheck, "_Согласен с условиями")  # Alt+С переключает флажок
echo "Мнемоника флажка включена"
```

---

### `gtk_check_button_set_child` / `gtk_check_button_get_child`

```nim
proc gtk_check_button_set_child*(check_button: GtkCheckButton, child: GtkWidget)
proc gtk_check_button_get_child*(check_button: GtkCheckButton): GtkWidget
```

**Что делает.** Устанавливают произвольный дочерний виджет вместо простой текстовой подписи — так же, как `gtk_button_set_child` у `GtkButton`, позволяет разместить рядом с флажком, например, иконку или составное описание из нескольких строк текста разного размера.

- `check_button` — флажок/радиокнопка.
- `child` — виджет-содержимое.

```nim
let descriptionBox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 2)
gtk_box_append(descriptionBox, gtk_label_new("Автосохранение"))
gtk_box_append(descriptionBox, gtk_label_new("Сохранять проект каждые 5 минут"))
gtk_check_button_set_child(autosaveCheck, descriptionBox)
echo "Флажок теперь содержит заголовок и описание в две строки"
```

---

## GtkSwitch

`GtkSwitch` — тумблер в стиле мобильных интерфейсов (переключатель "вкл/выкл" со скользящим индикатором), визуальная альтернатива флажку `GtkCheckButton` для булевых настроек — типично используется в панелях настроек. У `GtkSwitch`, в отличие от `GtkCheckButton`, два родственных, но разных свойства: `active` и `state` — это сделано специально, чтобы позволить асинхронное подтверждение переключения.

### `gtk_switch_new`

```nim
proc gtk_switch_new*(): GtkSwitch
```

**Что делает.** Создаёт тумблер в выключенном состоянии.

- Параметров нет.

```nim
let darkModeSwitch = gtk_switch_new()
echo "Тумблер тёмной темы создан"
```

---

### `gtk_switch_set_active` / `gtk_switch_get_active`

```nim
proc gtk_switch_set_active*(sw: GtkSwitch, isActive: gboolean)
proc gtk_switch_get_active*(sw: GtkSwitch): gboolean
```

**Что делает.** Немедленно переключают визуальное положение тумблера (ползунок сразу перескакивает в новое положение) и читают текущее визуальное положение. Для простых настроек, где переключение ничего не блокирует и не требует подтверждения, `active` — это единственное свойство, с которым нужно работать.

- `sw` — тумблер.
- `isActive` — `1.gboolean` для включённого положения.

```nim
gtk_switch_set_active(darkModeSwitch, 1.gboolean)
echo "Тёмная тема включена: ", gtk_switch_get_active(darkModeSwitch) != 0.gboolean
```

---

### `gtk_switch_set_state` / `gtk_switch_get_state`

```nim
proc gtk_switch_set_state*(sw: GtkSwitch, state: gboolean)
proc gtk_switch_get_state*(sw: GtkSwitch): gboolean
```

**Что делает.** `state` — это фактическое, "подтверждённое" состояние, отдельное от визуального положения ползунка (`active`). Когда пользователь двигает тумблер, `active` меняется сразу, но `state` остаётся прежним, пока приложение явно не вызовет `set_state` — это даёт возможность, например, показать диалог подтверждения или выполнить асинхронный запрос к серверу перед тем, как переключение будет считаться окончательным; если операция не удалась, можно вызвать `set_active` с прежним значением, чтобы визуально "откатить" тумблер назад.

- **Реализация.** Для настроек без асинхронного подтверждения различие между `active` и `state` не имеет значения — оба свойства меняются синхронно; разделение существует специально для сценариев, где переключение может быть отклонено уже после визуального движения тумблера.

- `sw` — тумблер.
- `state` — `1.gboolean` для подтверждённого включённого состояния.

```nim
proc onNotifyActive(sw: GtkSwitch, pspec: pointer, userData: gpointer) {.cdecl.} =
  # Пользователь подвинул тумблер — active уже изменился, но подтверждаем не сразу
  echo "Пользователь запросил переключение, отправляем запрос на сервер..."
  # ... после успешного ответа сервера ...
  gtk_switch_set_state(sw, gtk_switch_get_active(sw))
  echo "Переключение подтверждено, state синхронизирован с active"

discard g_signal_connect(darkModeSwitch, "notify::active", onNotifyActive, nil)
```

---

## GtkLabel

`GtkLabel` — статичный или интерактивный текст: заголовки, описания, подписи к полям, а также кликабельные ссылки (через Pango-разметку). В отличие от `GtkEntry`, содержимое `GtkLabel` по умолчанию нельзя редактировать — можно только опционально сделать его выделяемым (`gtk_label_set_selectable`) для копирования.

### `gtk_label_new` / `gtk_label_new_with_mnemonic`

```nim
proc gtk_label_new*(str: cstring): GtkLabel
proc gtk_label_new_with_mnemonic*(str: cstring): GtkLabel
```

**Что делает.** Создают надпись с обычным текстом либо с текстом, где символ `_` перед буквой отмечает мнемонику. Мнемоника у `GtkLabel` сама по себе не активирует надпись (у неё нет действия), а передаёт фокус ввода связанному виджету — см. `gtk_label_set_mnemonic_widget` ниже; типичный пример — подпись поля формы, по мнемонике которой фокус переходит в само поле.

- `str` — текст надписи.

```nim
let title = gtk_label_new("Настройки приложения")
echo "Заголовок создан"
```

---

### `gtk_label_set_text` / `gtk_label_get_text`

```nim
proc gtk_label_set_text*(label: GtkLabel, str: cstring)
proc gtk_label_get_text*(label: GtkLabel): cstring
```

**Что делает.** Устанавливают и читают обычный (не форматированный) текст надписи. Если до этого на надписи была включена Pango-разметка через `gtk_label_set_markup`, вызов `set_text` отключает интерпретацию разметки — переданная строка отображается буквально, включая любые символы `<`, `>`, `&`.

- `label` — надпись.
- `str` — новый текст.

```nim
gtk_label_set_text(statusLabel, "Готово")
echo "Текст статуса: ", $gtk_label_get_text(statusLabel)
```

---

### `gtk_label_set_markup` / `gtk_label_set_markup_with_mnemonic`

```nim
proc gtk_label_set_markup*(label: GtkLabel, str: cstring)
proc gtk_label_set_markup_with_mnemonic*(label: GtkLabel, str: cstring)
```

**Что делает.** Устанавливают текст надписи как разметку Pango (теги `<b>`, `<i>`, `<span foreground="...">`, `<a href="...">` для ссылок и т.д.) — автоматически включают `use_markup` (см. ниже). `_with_mnemonic`-вариант дополнительно интерпретирует `_` в тексте как маркер мнемоники, как и текстовые конструкторы.

- **Реализация.** Отдельного геттера "получить установленную разметку как есть" нет — `gtk_label_get_text` для надписи с разметкой вернёт уже вычищенный от тегов простой текст, а не исходную строку с разметкой.

- `label` — надпись.
- `str` — текст с Pango-разметкой.

```nim
gtk_label_set_markup(hintLabel, "Подробнее см. <a href=\"https://example.com/docs\">документацию</a>")
echo "Надпись с кликабельной ссылкой установлена"
```

---

### `gtk_label_set_use_markup` / `gtk_label_get_use_markup`

```nim
proc gtk_label_set_use_markup*(label: GtkLabel, setting: gboolean)
proc gtk_label_get_use_markup*(label: GtkLabel): gboolean
```

**Что делает.** Включают/выключают интерпретацию текста надписи как Pango-разметки напрямую, отдельно от `set_markup` — например, чтобы один и тот же вызов `set_text` то интерпретировался как разметка, то показывался буквально, в зависимости от источника текста (пользовательский ввод разумно показывать буквально во избежание случайной или намеренной инъекции разметки).

- `label` — надпись.
- `setting` — `1.gboolean` для интерпретации текста как Pango-разметки.

```nim
echo "Разметка используется: ", gtk_label_get_use_markup(hintLabel) != 0.gboolean
```

---

### `gtk_label_set_use_underline` / `gtk_label_get_use_underline`

```nim
proc gtk_label_set_use_underline*(label: GtkLabel, setting: gboolean)
proc gtk_label_get_use_underline*(label: GtkLabel): gboolean
```

**Что делает.** Включают/выключают интерпретацию символа `_` в тексте как маркера мнемоники — та же логика, что у `gtk_button_set_use_underline`, но для передачи фокуса связанному виджету, а не активации самой надписи (см. `gtk_label_set_mnemonic_widget`).

- `label` — надпись.
- `setting` — `1.gboolean` для интерпретации `_` как мнемоники.

```nim
gtk_label_set_use_underline(fieldCaption, 1.gboolean)
gtk_label_set_text(fieldCaption, "_Имя пользователя")
echo "Мнемоника подписи поля включена"
```

---

### `gtk_label_set_justify` / `gtk_label_get_justify`

```nim
proc gtk_label_set_justify*(label: GtkLabel, jtype: GtkJustification)
proc gtk_label_get_justify*(label: GtkLabel): GtkJustification
```

**Что делает.** Задают горизонтальное выравнивание текста **внутри самой надписи**, когда текст занимает несколько строк (`GTK_JUSTIFY_LEFT`, `GTK_JUSTIFY_RIGHT`, `GTK_JUSTIFY_CENTER`, `GTK_JUSTIFY_FILL` — растягивание строк по ширине, как в текстовом редакторе). Не путать с `gtk_widget_set_halign` из базового справочника — тот выравнивает саму надпись как целый виджет внутри выделенного ей контейнером места, а `justify` — только выравнивание строк текста друг относительно друга внутри многострочной надписи.

- `label` — надпись.
- `jtype` — значение `GtkJustification`.

```nim
gtk_label_set_justify(longDescription, GTK_JUSTIFY_LEFT)
echo "Многострочный текст выровнен по левому краю"
```

---

### `gtk_label_set_wrap` / `gtk_label_get_wrap` / `gtk_label_set_wrap_mode` / `gtk_label_get_wrap_mode`

```nim
proc gtk_label_set_wrap*(label: GtkLabel, wrap: gboolean)
proc gtk_label_get_wrap*(label: GtkLabel): gboolean
proc gtk_label_set_wrap_mode*(label: GtkLabel, wrapMode: PangoWrapMode)
proc gtk_label_get_wrap_mode*(label: GtkLabel): PangoWrapMode
```

**Что делает.** `set_wrap` включает перенос длинного текста на новую строку, когда он не помещается по ширине, выделенной надписи (без этого длинный текст просто обрежется или растянет родительский контейнер). `wrap_mode` уточняет, **как именно** переносить — по границам слов (`PANGO_WRAP_WORD`, по умолчанию), посреди слова посимвольно (`PANGO_WRAP_CHAR`), либо сначала пытаться по словам и переходить на посимвольный перенос только для слов длиннее целой строки (`PANGO_WRAP_WORD_CHAR`).

- `label` — надпись.
- `wrap` — `1.gboolean`, чтобы включить перенос.
- `wrapMode` — значение `PangoWrapMode`.

```nim
gtk_label_set_wrap(longDescription, 1.gboolean)
gtk_label_set_wrap_mode(longDescription, PANGO_WRAP_WORD_CHAR)
echo "Перенос текста включён с приоритетом переноса по словам"
```

---

### `gtk_label_set_selectable` / `gtk_label_get_selectable`

```nim
proc gtk_label_set_selectable*(label: GtkLabel, setting: gboolean)
proc gtk_label_get_selectable*(label: GtkLabel): gboolean
```

**Что делает.** Разрешают пользователю выделять текст надписи мышью и копировать его (`Ctrl+C`) — по умолчанию текст обычной надписи не выделяется, как и любой другой неинтерактивный элемент интерфейса. Стоит включать для надписей, содержащих значения, которые пользователю может понадобиться скопировать — коды ошибок, идентификаторы, версии.

- `label` — надпись.
- `setting` — `1.gboolean`, чтобы разрешить выделение.

```nim
gtk_label_set_selectable(versionLabel, 1.gboolean)
echo "Текст версии теперь можно выделить и скопировать"
```

---

### `gtk_label_set_width_chars` / `gtk_label_get_width_chars` / `gtk_label_set_max_width_chars` / `gtk_label_get_max_width_chars`

```nim
proc gtk_label_set_width_chars*(label: GtkLabel, nChars: gint)
proc gtk_label_get_width_chars*(label: GtkLabel): gint
proc gtk_label_set_max_width_chars*(label: GtkLabel, nChars: gint)
proc gtk_label_get_max_width_chars*(label: GtkLabel): gint
```

**Что делает.** Задают минимальную (`width_chars`) и максимальную (`max_width_chars`) ширину надписи в символах (примерном количестве символов "среднего" размера текущего шрифта, а не в пикселях) — способ задать разумные границы ширины текстового виджета, не завязываясь на пиксели, которые по-разному выглядят при разных шрифтах и масштабировании экрана.

- `label` — надпись.
- `nChars` — количество символов, либо `-1`, чтобы не ограничивать.

```nim
gtk_label_set_max_width_chars(descriptionLabel, 40)
gtk_label_set_wrap(descriptionLabel, 1.gboolean)
echo "Надпись не будет шире 40 символов, длинный текст перенесётся"
```

---

### `gtk_label_set_ellipsize` / `gtk_label_get_ellipsize`

```nim
proc gtk_label_set_ellipsize*(label: GtkLabel, mode: PangoEllipsizeMode)
proc gtk_label_get_ellipsize*(label: GtkLabel): PangoEllipsizeMode
```

**Что делает.** Включают обрезку текста многоточием, когда он не помещается по ширине надписи, вместо переноса на новую строку или выхода за границы. `mode` определяет, с какой стороны обрезать: `PANGO_ELLIPSIZE_NONE` (не обрезать, по умолчанию), `PANGO_ELLIPSIZE_START` (многоточие в начале — удобно для путей к файлам, где важнее видеть имя файла в конце), `PANGO_ELLIPSIZE_MIDDLE`, `PANGO_ELLIPSIZE_END` (многоточие в конце — самый частый случай для заголовков).

- `label` — надпись.
- `mode` — значение `PangoEllipsizeMode`.

```nim
gtk_label_set_ellipsize(fileNameLabel, PANGO_ELLIPSIZE_END)
echo "Длинное имя файла будет обрезано многоточием в конце"
```

---

### `gtk_label_select_region` / `gtk_label_get_selection_bounds`

```nim
proc gtk_label_select_region*(label: GtkLabel, start_offset: gint, end_offset: gint)
proc gtk_label_get_selection_bounds*(label: GtkLabel, start: ptr gint, `end`: ptr gint): gboolean
```

**Что делает.** Программно выделяют диапазон текста надписи (работает только если `gtk_label_set_selectable` включён) и читают границы текущего выделения, сделанного пользователем. `get_selection_bounds` возвращает `gboolean`, сообщающий, есть ли вообще активное выделение — если нет, значения по указателям `start`/`end` не определены и использовать их не следует.

- `label` — надпись.
- `start_offset`, `end_offset` — границы выделения в символах.
- `start`, `end` (для чтения) — указатели, куда будут записаны границы текущего выделения.

```nim
gtk_label_set_selectable(codeLabel, 1.gboolean)
gtk_label_select_region(codeLabel, 0, 8)  # выделить первые 8 символов программно
var start, stop: gint
if gtk_label_get_selection_bounds(codeLabel, addr start, addr stop) != 0.gboolean:
  echo "Выделено с ", start, " по ", stop
```

---

### `gtk_label_set_attributes` / `gtk_label_get_attributes`

```nim
proc gtk_label_set_attributes*(label: GtkLabel, attrs: PangoAttrList)
proc gtk_label_get_attributes*(label: GtkLabel): PangoAttrList
```

**Что делает.** Устанавливают и читают список атрибутов форматирования Pango (`PangoAttrList`) напрямую — программная альтернатива текстовой Pango-разметке (`gtk_label_set_markup`) для случаев, когда атрибуты форматирования вычисляются в коде, а не задаются статичной строкой (например, подсветка синтаксиса). Построение `PangoAttrList` — отдельная тема, выходящая за рамки этого справочника (функции `pango_attr_list_*`).

- `label` — надпись.
- `attrs` — список атрибутов Pango.

```nim
# attrs строится заранее через pango_attr_list_new/pango_attr_list_insert
gtk_label_set_attributes(codeLabel, attrs)
echo "Программные атрибуты форматирования применены"
```

---

### `gtk_label_set_mnemonic_widget` / `gtk_label_get_mnemonic_widget`

```nim
proc gtk_label_set_mnemonic_widget*(label: GtkLabel, widget: GtkWidget)
proc gtk_label_get_mnemonic_widget*(label: GtkLabel): GtkWidget
```

**Что делает.** Связывают надпись-подпись с другим виджетом (обычно полем ввода): при активации мнемоники надписи (`Alt+буква`, см. `gtk_label_set_use_underline`) фокус ввода передаётся не самой надписи (у неё нет фокуса как такового), а указанному виджету. Это стандартный способ сделать подписи формы доступными с клавиатуры.

- `label` — надпись-подпись с включённой мнемоникой.
- `widget` — виджет (обычно `GtkEntry`), которому нужно передавать фокус.

```nim
let nameCaption = gtk_label_new_with_mnemonic("_Имя пользователя")
let nameEntry = gtk_entry_new()
gtk_label_set_mnemonic_widget(nameCaption, nameEntry)
echo "Alt+И теперь передаёт фокус в поле имени пользователя"
```

---

### `gtk_label_set_single_line_mode` / `gtk_label_get_single_line_mode`

```nim
proc gtk_label_set_single_line_mode*(label: GtkLabel, single_line_mode: gboolean)
proc gtk_label_get_single_line_mode*(label: GtkLabel): gboolean
```

**Что делает.** Принудительно схлопывают текст надписи в одну строку, даже если в исходном тексте есть символы перевода строки (`\n`) — переводы строк отображаются как обычный пробел вместо перехода на новую визуальную строку. Отличается от простого отсутствия `\n` в тексте тем, что управляет обработкой уже присутствующих в строке переносов, а не их появлением.

- `label` — надпись.
- `single_line_mode` — `1.gboolean`, чтобы схлопнуть в одну строку.

```nim
gtk_label_set_single_line_mode(compactStatusLabel, 1.gboolean)
echo "Переводы строк в тексте статуса будут показаны как пробелы"
```

---

### `gtk_label_set_lines` / `gtk_label_get_lines`

```nim
proc gtk_label_set_lines*(label: GtkLabel, lines: gint)
proc gtk_label_get_lines*(label: GtkLabel): gint
```

**Что делает.** Ограничивают максимальное число видимых строк текста при включённом переносе (`gtk_label_set_wrap`) — текст, который не поместился в заданное число строк, будет обрезан (в сочетании с `gtk_label_set_ellipsize` — с многоточием в конце последней видимой строки). Полезно для превью длинных описаний фиксированной высоты (например, карточка новости с описанием в максимум 3 строки).

- `label` — надпись.
- `lines` — максимальное число строк, либо `-1` без ограничения.

```nim
gtk_label_set_wrap(newsPreview, 1.gboolean)
gtk_label_set_lines(newsPreview, 3)
gtk_label_set_ellipsize(newsPreview, PANGO_ELLIPSIZE_END)
echo "Описание новости ограничено тремя строками с многоточием"
```

---

### `gtk_label_set_xalign` / `gtk_label_get_xalign` / `gtk_label_set_yalign` / `gtk_label_get_yalign`

```nim
proc gtk_label_set_xalign*(label: GtkLabel, xalign: cfloat)
proc gtk_label_get_xalign*(label: GtkLabel): cfloat
proc gtk_label_set_yalign*(label: GtkLabel, yalign: cfloat)
proc gtk_label_get_yalign*(label: GtkLabel): cfloat
```

**Что делает.** Задают точное выравнивание текста внутри границ виджета надписи дробным значением от `0.0` до `1.0` (`0.0` — прижато к левому/верхнему краю, `1.0` — к правому/нижнему, `0.5` — по центру) — более гибкая альтернатива дискретному `gtk_widget_set_halign`/`set_valign` из базового справочника для случаев, когда нужно выравнивание не строго "по краю" или "по центру", а с произвольным смещением.

- `label` — надпись.
- `xalign`, `yalign` — значения от `0.0` до `1.0`.

```nim
gtk_label_set_xalign(priceLabel, 1.0)  # прижать текст цены к правому краю
echo "Текст цены выровнен по правому краю: xalign=", gtk_label_get_xalign(priceLabel)
```

---

### `gtk_label_set_extra_menu` / `gtk_label_get_extra_menu`

```nim
proc gtk_label_set_extra_menu*(label: GtkLabel, model: GMenuModel)
proc gtk_label_get_extra_menu*(label: GtkLabel): GMenuModel
```

**Что делает.** Добавляют дополнительные пункты в стандартное контекстное меню надписи (которое обычно содержит "Копировать" для выделяемого текста) — модель меню строится так же, как меню приложения (см. базовый справочник, `gtk_application_set_menubar`).

- `label` — надпись.
- `model` — дополнительная модель меню.

```nim
# extraMenuModel строится заранее через g_menu_new/g_menu_append
gtk_label_set_extra_menu(codeLabel, extraMenuModel)
echo "В контекстное меню надписи добавлены дополнительные пункты"
```

---

### `gtk_label_set_natural_wrap_mode` / `gtk_label_get_natural_wrap_mode`

```nim
proc gtk_label_set_natural_wrap_mode*(label: GtkLabel, wrap_mode: GtkNaturalWrapMode)
proc gtk_label_get_natural_wrap_mode*(label: GtkLabel): GtkNaturalWrapMode
```

**Что делает.** Тонко настраивает, как GTK вычисляет "естественный" (предпочитаемый) размер надписи с переносом при определении минимального размера в системе компоновки — влияет на то, насколько охотно многострочная надпись с `wrap` соглашается сжаться по ширине вместо того, чтобы настаивать на показе как можно большего числа слов в одной строке. Специализированная настройка для тонкой доводки автоматической раскладки; в большинстве случаев значение по умолчанию не требует изменения.

- `label` — надпись.
- `wrap_mode` — значение `GtkNaturalWrapMode`.

```nim
echo "Текущий режим естественного переноса: ", gtk_label_get_natural_wrap_mode(longDescription)
```

---

### `gtk_label_set_tabs` / `gtk_label_get_tabs`

```nim
proc gtk_label_set_tabs*(label: GtkLabel, tabs: PangoTabArray)
proc gtk_label_get_tabs*(label: GtkLabel): PangoTabArray
```

**Что делает.** Задают позиции табуляции для символов `\t` внутри текста надписи (аналог табуляций в текстовом редакторе) — актуально только для многострочного текста с моноширинным выравниванием данных через табы. `PangoTabArray` строится отдельными функциями `pango_tab_array_*`, не входящими в этот справочник.

- `label` — надпись.
- `tabs` — массив позиций табуляции Pango.

```nim
# tabArray строится заранее через pango_tab_array_new/pango_tab_array_set_tab
gtk_label_set_tabs(monospaceReport, tabArray)
echo "Позиции табуляции для отчёта заданы"
```

---

### `gtk_label_get_current_uri`

```nim
proc gtk_label_get_current_uri*(label: GtkLabel): cstring
```

**Что делает.** Возвращает URI ссылки, над которой сейчас находится курсор мыши (для надписи с Pango-разметкой, содержащей теги `<a href="...">`), — вызывается изнутри обработчика сигнала `"activate-link"` или подобного, чтобы узнать, по какой именно из нескольких возможных ссылок произошло действие. Вне наведения на ссылку возвращает `nil`.

- `label` — надпись со ссылками в разметке.

```nim
let uri = gtk_label_get_current_uri(hintLabel)
if not isNil(uri):
  echo "Курсор сейчас над ссылкой: ", $uri
```

---

### `gtk_label_get_layout` / `gtk_label_get_layout_offsets`

```nim
proc gtk_label_get_layout*(label: GtkLabel): PangoLayout
proc gtk_label_get_layout_offsets*(label: GtkLabel, x: ptr gint, y: ptr gint)
```

**Что делает.** Дают доступ к низкоуровневому объекту раскладки текста Pango (`PangoLayout`), которым надпись рисует свой текст, и к его смещению относительно левого верхнего угла самого виджета. Нужны для продвинутых сценариев — точного измерения текста, кастомной отрисовки поверх текста надписи, определения символа под конкретной пиксельной координатой. Для обычной работы с текстом надписи (чтение, форматирование, выравнивание) эти функции не требуются — их использование предполагает знакомство с API Pango.

- `label` — надпись.
- `x`, `y` (для `get_layout_offsets`) — указатели, куда будет записано смещение.

```nim
let layout = gtk_label_get_layout(measuredLabel)
var offsetX, offsetY: gint
gtk_label_get_layout_offsets(measuredLabel, addr offsetX, addr offsetY)
echo "Смещение текстовой раскладки: (", offsetX, ", ", offsetY, ")"
```

---

## Практические рецепты

### Группа радиокнопок на GtkCheckButton

Выбор одного варианта из нескольких — классический сценарий, в GTK4 реализуемый через `gtk_check_button_set_group`.

```nim
proc buildViewModeChoice(): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_VERTICAL, 6)

  let smallOption = gtk_check_button_new_with_label("Мелкие значки")
  let largeOption = gtk_check_button_new_with_label("Крупные значки")
  let listOption = gtk_check_button_new_with_label("Список")

  gtk_check_button_set_group(largeOption, smallOption)
  gtk_check_button_set_group(listOption, smallOption)
  gtk_check_button_set_active(smallOption, 1.gboolean)  # вариант по умолчанию

  gtk_box_append(result, smallOption)
  gtk_box_append(result, largeOption)
  gtk_box_append(result, listOption)
  echo "Группа из трёх взаимоисключающих вариантов отображения собрана"

let viewModeChoice = buildViewModeChoice()
```

---

### Панель настроек: подписанные переключатели GtkSwitch

Типичная строка настройки: подпись слева, тумблер справа, растянутые на всю ширину через `hexpand` у промежуточного разделителя.

```nim
proc buildSettingRow(caption: string, initiallyOn: bool): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 12)
  let label = gtk_label_new(caption.cstring)
  gtk_widget_set_hexpand(label, 1.gboolean)
  gtk_widget_set_halign(label, GTK_ALIGN_START)

  let sw = gtk_switch_new()
  gtk_switch_set_active(sw, if initiallyOn: 1.gboolean else: 0.gboolean)
  gtk_widget_set_valign(sw, GTK_ALIGN_CENTER)

  gtk_box_append(result, label)
  gtk_box_append(result, sw)

let notificationsRow = buildSettingRow("Уведомления", true)
let autoUpdateRow = buildSettingRow("Автообновление", false)
echo "Две строки настроек с тумблерами собраны"
```

---

### Кнопка с иконкой и текстом одновременно

`gtk_button_set_icon_name` заменяет всё содержимое кнопки на одну иконку — чтобы получить иконку рядом с текстом, содержимое собирается вручную через `gtk_button_set_child`.

```nim
proc buildIconTextButton(iconName, labelText: string): GtkButton =
  result = gtk_button_new()
  let content = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 6)
  let icon = gtk_image_new_from_icon_name(iconName.cstring)
  let label = gtk_label_new(labelText.cstring)
  gtk_box_append(content, icon)
  gtk_box_append(content, label)
  gtk_button_set_child(result, content)

let saveButton = buildIconTextButton("document-save-symbolic", "Сохранить")
echo "Кнопка с иконкой сохранения и текстом собрана"
```

---

### Надпись с переносом, обрезкой и выделяемым текстом

Комбинация свойств `GtkLabel` для показа длинного текста в ограниченном по ширине блоке, с многоточием, если текста слишком много даже для нескольких строк, и с возможностью выделить и скопировать то, что видно.

```nim
proc buildDescriptionLabel(text: string): GtkLabel =
  result = gtk_label_new(text.cstring)
  gtk_label_set_wrap(result, 1.gboolean)
  gtk_label_set_wrap_mode(result, PANGO_WRAP_WORD_CHAR)
  gtk_label_set_lines(result, 4)
  gtk_label_set_ellipsize(result, PANGO_ELLIPSIZE_END)
  gtk_label_set_max_width_chars(result, 50)
  gtk_label_set_selectable(result, 1.gboolean)
  gtk_label_set_xalign(result, 0.0)  # прижать к левому краю, а не центрировать
  echo "Надпись описания собрана: перенос, максимум 4 строки, выделяемая"

let description = buildDescriptionLabel("Очень длинное описание, которое не поместится в четыре строки без обрезки многоточием...")
```

---

### Мнемоника: подпись, передающая фокус полю по Alt+буква

Полная связка подписи и поля ввода — нажатие мнемоники передаёт фокус в поле, не активируя саму подпись.

```nim
proc buildLabeledEntryRow(mnemonicCaption: string): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 8)

  let caption = gtk_label_new_with_mnemonic(mnemonicCaption.cstring)
  gtk_widget_set_halign(caption, GTK_ALIGN_END)

  let entry = gtk_entry_new()
  gtk_widget_set_hexpand(entry, 1.gboolean)
  gtk_label_set_mnemonic_widget(caption, entry)

  gtk_box_append(result, caption)
  gtk_box_append(result, entry)

let emailRow = buildLabeledEntryRow("_Email")
echo "Alt+E теперь передаёт фокус в поле email"
```

---

## Краткая таблица

| Процедура(ы) | Категория | Что делает вкратце |
|---|---|---|
| `gtk_button_new`, `_with_label`, `_with_mnemonic`, `_from_icon_name` | Button | Создать кнопку — пустую, с текстом, с мнемоникой, с иконкой |
| `gtk_button_set/get_label` | Button | Текст кнопки (заменяет сложное содержимое на простую надпись) |
| `gtk_button_set/get_use_underline` | Button | Интерпретация `_` в тексте как мнемоники |
| `gtk_button_set/get_child` | Button | Произвольное содержимое кнопки |
| `gtk_button_set/get_has_frame` | Button | Рамка/фон кнопки (плоский вид) |
| `gtk_button_set/get_icon_name` | Button | Содержимое-иконка по имени из темы |
| `gtk_button_set/get_can_shrink` | Button | Разрешить сжатие кнопки меньше естественного размера |
| `gtk_actionable_set_detailed_action_name` | Button | Привязка к действию строкой `"группа.имя"` |
| `gtk_toggle_button_new`, `_with_label`, `_with_mnemonic` | ToggleButton | Создать кнопку-переключатель |
| `gtk_toggle_button_set/get_active` | ToggleButton | Текущее состояние (нажата/отжата) |
| `gtk_toggle_button_toggled` | ToggleButton | Принудительно эмитировать сигнал `"toggled"` |
| `gtk_toggle_button_set_group` | ToggleButton | Объединить в группу взаимоисключающего выбора |
| `gtk_check_button_new`, `_with_label`, `_with_mnemonic` | CheckButton | Создать флажок/радиокнопку |
| `gtk_check_button_set/get_active` | CheckButton | Отмечен ли флажок / выбрана ли радиокнопка |
| `gtk_check_button_set/get_inconsistent` | CheckButton | "Неопределённое" визуальное состояние (прочерк) |
| `gtk_check_button_set_group` | CheckButton | Превратить в радиокнопку внутри группы |
| `gtk_check_button_set/get_label` | CheckButton | Текст подписи |
| `gtk_check_button_set/get_use_underline` | CheckButton | Интерпретация `_` в подписи как мнемоники |
| `gtk_check_button_set/get_child` | CheckButton | Произвольное содержимое вместо текста |
| `gtk_switch_new` | Switch | Создать тумблер |
| `gtk_switch_set/get_active` | Switch | Немедленное визуальное положение |
| `gtk_switch_set/get_state` | Switch | Подтверждённое состояние (для асинхронных операций) |
| `gtk_label_new`, `_with_mnemonic` | Label | Создать надпись |
| `gtk_label_set/get_text` | Label | Обычный (не форматированный) текст |
| `gtk_label_set_markup`, `_with_mnemonic` | Label | Текст с Pango-разметкой (ссылки, форматирование) |
| `gtk_label_set/get_use_markup` | Label | Интерпретация текста как Pango-разметки |
| `gtk_label_set/get_use_underline` | Label | Интерпретация `_` как мнемоники |
| `gtk_label_set/get_justify` | Label | Выравнивание строк внутри многострочного текста |
| `gtk_label_set/get_wrap`, `set/get_wrap_mode` | Label | Перенос текста и его режим (по словам/посимвольно) |
| `gtk_label_set/get_selectable` | Label | Разрешить выделение и копирование текста |
| `gtk_label_set/get_width_chars`, `set/get_max_width_chars` | Label | Мин./макс. ширина в символах |
| `gtk_label_set/get_ellipsize` | Label | Обрезка текста многоточием |
| `gtk_label_select_region`, `get_selection_bounds` | Label | Программное выделение / границы текущего выделения |
| `gtk_label_set/get_attributes` | Label | Программные атрибуты форматирования Pango |
| `gtk_label_set/get_mnemonic_widget` | Label | Виджет, получающий фокус по мнемонике надписи |
| `gtk_label_set/get_single_line_mode` | Label | Схлопнуть переводы строк в пробелы |
| `gtk_label_set/get_lines` | Label | Ограничение числа видимых строк |
| `gtk_label_set/get_xalign`, `set/get_yalign` | Label | Точное дробное выравнивание текста |
| `gtk_label_set/get_extra_menu` | Label | Доп. пункты в контекстном меню надписи |
| `gtk_label_set/get_natural_wrap_mode` | Label | Тонкая настройка вычисления естественного размера |
| `gtk_label_set/get_tabs` | Label | Позиции табуляции для `\t` в тексте |
| `gtk_label_get_current_uri` | Label | URI ссылки под курсором (для разметки со ссылками) |
| `gtk_label_get_layout`, `get_layout_offsets` | Label | Низкоуровневый доступ к раскладке Pango |

---

## Сводка: какую процедуру выбрать

- **Выбор из нескольких взаимоисключающих вариантов** → `GtkCheckButton` с `gtk_check_button_set_group` — отдельного класса радиокнопок в GTK4 нет.
- **Переключатель режима, оформленный как ряд одинаковых кнопок** (например, "Список"/"Сетка" в панели инструментов, а не как список флажков) → `GtkToggleButton` с `gtk_toggle_button_set_group`, а не `GtkCheckButton` — визуально это кнопки, а не флажки.
- **Простая булева настройка в панели настроек** → `GtkSwitch` — стилистически ожидаемый выбор для настроек; `GtkCheckButton` — более уместен внутри списков и форм, где рядом уже есть текстовые подписи в стиле формы.
- **Переключение должно быть подтверждено асинхронно** (запрос к серверу, диалог) → `GtkSwitch` с раздельными `active`/`state`, а не мгновенный `GtkCheckButton`/`GtkToggleButton`, где такого разделения нет.
- **Текст кнопки — просто текст** → `gtk_button_new_with_label`/`gtk_button_set_label`. **Текст + иконка одновременно** → `gtk_button_set_child` с самостоятельно собранным `GtkBox` (готовой функции "текст плюс иконка" нет).
- **Кнопка должна активироваться с клавиатуры без явного Tab до неё** → добавить мнемонику (`_` в тексте + `gtk_button_new_with_mnemonic`/`set_use_underline`).
- **Подпись должна передавать фокус связанному полю по мнемонике** (а не выполнять действие сама) → `gtk_label_new_with_mnemonic` + `gtk_label_set_mnemonic_widget`, а не пытаться делать надпись кликабельной вручную.
- **Длинный текст не должен раздувать интерфейс** → `gtk_label_set_wrap` (перенос на несколько строк) в сочетании с `gtk_label_set_lines`/`set_max_width_chars`, и `gtk_label_set_ellipsize`, если после этого текст всё ещё может не поместиться.
- **Пользователю может понадобиться скопировать значение из надписи** (код ошибки, версия, идентификатор) → не забыть `gtk_label_set_selectable` — по умолчанию текст обычной надписи не выделяется.
- **Нужна ссылка внутри текста** → `gtk_label_set_markup` с тегом `<a href="...">`, а не отдельная кнопка-ссылка (`GtkLinkButton` — в справочнике по расширенным кнопкам).
