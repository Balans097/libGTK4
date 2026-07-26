# GTK4 (text input: GtkEditable / Entry / PasswordEntry / SearchEntry) — справочник модуля

> **Импорт:** `import libGTK4`
> **Область применения:** однострочный ввод текста — обычные поля, поля пароля, поле поиска. Третья часть серии справочников по обёртке; предполагает знакомство с первой частью (`gtk4_core_reference_ru.md` — инициализация, окно, `GtkWidget`, компоновка) и второй (`gtk4_basic_controls_reference_ru.md` — кнопки, `GtkLabel`).

Ключевая особенность этого раздела: сам текст, позиция курсора, выделение и редактируемость у `GtkEntry`, `GtkPasswordEntry`, `GtkSearchEntry` управляются не собственными функциями каждого класса, а общим интерфейсом `GtkEditable` — одним и тем же набором `gtk_editable_*` процедур, работающим одинаково для всех трёх виджетов (и ещё нескольких, не входящих в этот справочник, например `GtkSpinButton`). Поэтому справочник начинается именно с `GtkEditable`, а не с `GtkEntry`.

---

## Оглавление

I. [Интерфейс GtkEditable (общий для всех полей ввода)](#интерфейс-gtkeditable-общий-для-всех-полей-ввода)
&nbsp;&nbsp;1. [`gtk_editable_get_text` / `gtk_editable_set_text`](#gtk_editable_get_text--gtk_editable_set_text)
&nbsp;&nbsp;2. [`gtk_editable_get_chars`](#gtk_editable_get_chars)
&nbsp;&nbsp;3. [`gtk_editable_insert_text` / `gtk_editable_delete_text`](#gtk_editable_insert_text--gtk_editable_delete_text)
&nbsp;&nbsp;4. [`gtk_editable_get_selection_bounds` / `gtk_editable_select_region` / `gtk_editable_delete_selection`](#gtk_editable_get_selection_bounds--gtk_editable_select_region--gtk_editable_delete_selection)
&nbsp;&nbsp;5. [`gtk_editable_set_position` / `gtk_editable_get_position`](#gtk_editable_set_position--gtk_editable_get_position)
&nbsp;&nbsp;6. [`gtk_editable_set_editable` / `gtk_editable_get_editable`](#gtk_editable_set_editable--gtk_editable_get_editable)
&nbsp;&nbsp;7. [`gtk_editable_set_alignment` / `gtk_editable_get_alignment`](#gtk_editable_set_alignment--gtk_editable_get_alignment)
&nbsp;&nbsp;8. [`gtk_editable_set_width_chars` / `gtk_editable_get_width_chars` / `gtk_editable_set_max_width_chars` / `gtk_editable_get_max_width_chars`](#gtk_editable_set_width_chars--gtk_editable_get_width_chars--gtk_editable_set_max_width_chars--gtk_editable_get_max_width_chars)
&nbsp;&nbsp;9. [`gtk_editable_set_enable_undo` / `gtk_editable_get_enable_undo`](#gtk_editable_set_enable_undo--gtk_editable_get_enable_undo)

II. [GtkEntry](#gtkentry)
&nbsp;&nbsp;1. [`gtk_entry_new` / `gtk_entry_new_with_buffer`](#gtk_entry_new--gtk_entry_new_with_buffer)
&nbsp;&nbsp;2. [`gtk_entry_set_placeholder_text` / `gtk_entry_get_placeholder_text`](#gtk_entry_set_placeholder_text--gtk_entry_get_placeholder_text)
&nbsp;&nbsp;3. [`gtk_entry_set_visibility` / `gtk_entry_get_visibility`](#gtk_entry_set_visibility--gtk_entry_get_visibility)
&nbsp;&nbsp;4. [`gtk_entry_set_max_length` / `gtk_entry_get_max_length`](#gtk_entry_set_max_length--gtk_entry_get_max_length)
&nbsp;&nbsp;5. [`gtk_entry_set_has_frame` / `gtk_entry_get_has_frame`](#gtk_entry_set_has_frame--gtk_entry_get_has_frame)
&nbsp;&nbsp;6. [`gtk_entry_set_alignment` / `gtk_entry_get_alignment`](#gtk_entry_set_alignment--gtk_entry_get_alignment)
&nbsp;&nbsp;7. [`gtk_entry_set_buffer` / `gtk_entry_get_buffer`](#gtk_entry_set_buffer--gtk_entry_get_buffer)
&nbsp;&nbsp;8. [`gtk_entry_set_invisible_char` / `gtk_entry_get_invisible_char` / `gtk_entry_unset_invisible_char`](#gtk_entry_set_invisible_char--gtk_entry_get_invisible_char--gtk_entry_unset_invisible_char)
&nbsp;&nbsp;9. [`gtk_entry_set_activates_default` / `gtk_entry_get_activates_default`](#gtk_entry_set_activates_default--gtk_entry_get_activates_default)
&nbsp;&nbsp;10. [`gtk_entry_set_attributes` / `gtk_entry_get_attributes`](#gtk_entry_set_attributes--gtk_entry_get_attributes)
&nbsp;&nbsp;11. [`gtk_entry_set_tabs` / `gtk_entry_get_tabs`](#gtk_entry_set_tabs--gtk_entry_get_tabs)
&nbsp;&nbsp;12. [`gtk_entry_set_progress_fraction` / `gtk_entry_get_progress_fraction` / `set_progress_pulse_step` / `get_progress_pulse_step` / `gtk_entry_progress_pulse`](#gtk_entry_set_progress_fraction--gtk_entry_get_progress_fraction--set_progress_pulse_step--get_progress_pulse_step--gtk_entry_progress_pulse)
&nbsp;&nbsp;13. [`gtk_entry_set_completion` / `gtk_entry_get_completion`](#gtk_entry_set_completion--gtk_entry_get_completion)
&nbsp;&nbsp;14. [`gtk_entry_get_text_length`](#gtk_entry_get_text_length)
&nbsp;&nbsp;15. [Иконки внутри поля: `gtk_entry_set_icon_from_icon_name` и родственные](#иконки-внутри-поля-gtk_entry_set_icon_from_icon_name-и-родственные)
&nbsp;&nbsp;16. [`gtk_entry_set_input_purpose` / `gtk_entry_get_input_purpose` / `gtk_entry_set_input_hints` / `gtk_entry_get_input_hints`](#gtk_entry_set_input_purpose--gtk_entry_get_input_purpose--gtk_entry_set_input_hints--gtk_entry_get_input_hints)
&nbsp;&nbsp;17. [`gtk_entry_set_extra_menu` / `gtk_entry_get_extra_menu`](#gtk_entry_set_extra_menu--gtk_entry_get_extra_menu)
&nbsp;&nbsp;18. [`gtk_entry_reset_im_context`](#gtk_entry_reset_im_context)
&nbsp;&nbsp;19. [`gtk_entry_grab_focus_without_selecting`](#gtk_entry_grab_focus_without_selecting)

III. [GtkPasswordEntry](#gtkpasswordentry)
&nbsp;&nbsp;1. [`gtk_password_entry_new`](#gtk_password_entry_new)
&nbsp;&nbsp;2. [`gtk_password_entry_set_show_peek_icon` / `gtk_password_entry_get_show_peek_icon`](#gtk_password_entry_set_show_peek_icon--gtk_password_entry_get_show_peek_icon)
&nbsp;&nbsp;3. [`gtk_password_entry_set_extra_menu` / `gtk_password_entry_get_extra_menu`](#gtk_password_entry_set_extra_menu--gtk_password_entry_get_extra_menu)

IV. [GtkSearchEntry](#gtksearchentry)
&nbsp;&nbsp;1. [`gtk_search_entry_new`](#gtk_search_entry_new)
&nbsp;&nbsp;2. [`gtk_search_entry_set_placeholder_text` / `gtk_search_entry_get_placeholder_text`](#gtk_search_entry_set_placeholder_text--gtk_search_entry_get_placeholder_text)
&nbsp;&nbsp;3. [`gtk_search_entry_set_search_delay` / `gtk_search_entry_get_search_delay`](#gtk_search_entry_set_search_delay--gtk_search_entry_get_search_delay)
&nbsp;&nbsp;4. [`gtk_search_entry_set_key_capture_widget` / `gtk_search_entry_get_key_capture_widget`](#gtk_search_entry_set_key_capture_widget--gtk_search_entry_get_key_capture_widget)
&nbsp;&nbsp;5. [`gtk_search_entry_set_input_purpose` / `gtk_search_entry_get_input_purpose` / `set_input_hints` / `get_input_hints`](#gtk_search_entry_set_input_purpose--gtk_search_entry_get_input_purpose--set_input_hints--get_input_hints)

V. [Практические рецепты](#практические-рецепты)
&nbsp;&nbsp;1. [Форма входа: логин + пароль с кнопкой-глазком](#форма-входа-логин--пароль-с-кнопкой-глазком)
&nbsp;&nbsp;2. [Поле поиска с задержкой и живой фильтрацией](#поле-поиска-с-задержкой-и-живой-фильтрацией)
&nbsp;&nbsp;3. [Поле email с иконкой валидации](#поле-email-с-иконкой-валидации)
&nbsp;&nbsp;4. [Поле ввода с индикатором прогресса (например, при проверке пароля)](#поле-ввода-с-индикатором-прогресса-например-при-проверке-пароля)
&nbsp;&nbsp;5. [Отправка формы по Enter через `activates_default`](#отправка-формы-по-enter-через-activates_default)

VI. [Краткая таблица](#краткая-таблица)

VII. [Сводка: какую процедуру выбрать](#сводка-какую-процедуру-выбрать)

---

## Интерфейс GtkEditable (общий для всех полей ввода)

`GtkEditable` — это не отдельный виджет, а общий интерфейс, который реализуют `GtkEntry`, `GtkPasswordEntry`, `GtkSearchEntry` и ряд других виджетов с редактируемым текстом. Все процедуры этого раздела принимают первым параметром любой из этих виджетов — в данной обёртке параметр типизирован как `pointer`, поэтому конкретный тип (`GtkEntry`, `GtkPasswordEntry` и т.д.) передаётся напрямую без приведения типов.

### `gtk_editable_get_text` / `gtk_editable_set_text`

```nim
proc gtk_editable_get_text*(editable: pointer): cstring
proc gtk_editable_set_text*(editable: pointer, text: cstring)
```

**Что делает.** Устанавливают и читают весь текст поля целиком. Это основной способ работы с содержимым поля ввода в GTK4 — старые функции `gtk_entry_set_text`/`gtk_entry_get_text` из GTK3 в GTK4 объявлены нерабочими (в этой обёртке они закомментированы, а не удалены полностью, — чтобы явно показать, чем их нужно заменить) именно в пользу этой пары, единой для всех Editable-виджетов.

- `editable` — любой Editable-виджет (`GtkEntry`, `GtkPasswordEntry`, `GtkSearchEntry`).
- `text` — новый текст поля.

```nim
let entry = gtk_entry_new()
gtk_editable_set_text(entry, "начальное значение")
echo "Текст поля: ", $gtk_editable_get_text(entry)
# выводит "Текст поля: начальное значение"
```

---

### `gtk_editable_get_chars`

```nim
proc gtk_editable_get_chars*(editable: pointer, startPos: gint, endPos: gint): cstring
```

**Что делает.** Возвращает подстроку текста поля между указанными позициями символов — в отличие от `get_text`, который всегда отдаёт всё содержимое, эта функция читает только выбранный диапазон. Отрицательное значение `endPos` (`-1`) означает "до конца текста".

- `editable` — Editable-виджет.
- `startPos`, `endPos` — границы диапазона в символах (не в байтах — важно для не-ASCII текста).

```nim
gtk_editable_set_text(entry, "Привет, мир!")
let firstWord = gtk_editable_get_chars(entry, 0, 6)
echo "Первое слово: ", $firstWord  # выводит "Первое слово: Привет"
```

---

### `gtk_editable_insert_text` / `gtk_editable_delete_text`

```nim
proc gtk_editable_insert_text*(editable: pointer, text: cstring, length: gint, position: ptr gint)
proc gtk_editable_delete_text*(editable: pointer, startPos: gint, endPos: gint)
```

**Что делает.** Вставляют текст в произвольную позицию (не обязательно в позицию курсора) и удаляют диапазон текста. `gtk_editable_insert_text` необычна тем, что её последний параметр — указатель `ptr gint`: перед вызовом он должен содержать позицию вставки, а после вызова GTK перезаписывает его значением позиции сразу **после** вставленного текста — удобно для последовательных вставок подряд без ручного пересчёта смещений.

- `editable` — Editable-виджет.
- `text` — вставляемый текст.
- `length` — длина вставляемого текста в байтах (`-1`, если `text` — обычная `NUL`-терминированная строка).
- `position` — указатель на позицию вставки (на входе и на выходе, см. выше).
- `startPos`, `endPos` (для `delete_text`) — границы удаляемого диапазона в символах.

```nim
var pos: gint = 0
gtk_editable_insert_text(entry, "Здравствуйте, ", -1, addr pos)
echo "Текст после позиции ", pos, " будет продолжен следующей вставкой"
gtk_editable_delete_text(entry, 0, 5)  # удалить первые 5 символов
```

---

### `gtk_editable_get_selection_bounds` / `gtk_editable_select_region` / `gtk_editable_delete_selection`

```nim
proc gtk_editable_get_selection_bounds*(editable: pointer, startPos: ptr gint, endPos: ptr gint): gboolean
proc gtk_editable_select_region*(editable: pointer, startPos: gint, endPos: gint)
proc gtk_editable_delete_selection*(editable: pointer)
```

**Что делает.** Читают границы текущего выделения текста, задают выделение программно и удаляют выделенный текст. `gtk_editable_get_selection_bounds` возвращает `gboolean`, сообщающий, есть ли вообще активное выделение, — если выделения нет, значения по указателям `startPos`/`endPos` не определены.

- `editable` — Editable-виджет.
- `startPos`, `endPos` — границы диапазона выделения в символах.

```nim
gtk_editable_select_region(entry, 0, 5)  # выделить первые 5 символов
var start, stop: gint
if gtk_editable_get_selection_bounds(entry, addr start, addr stop) != 0.gboolean:
  echo "Выделено с ", start, " по ", stop
gtk_editable_delete_selection(entry)  # стереть выделенный текст, как по нажатию Delete
```

---

### `gtk_editable_set_position` / `gtk_editable_get_position`

```nim
proc gtk_editable_set_position*(editable: pointer, position: gint)
proc gtk_editable_get_position*(editable: pointer): gint
```

**Что делает.** Устанавливают и читают позицию текстового курсора внутри поля (в символах от начала текста, без учёта выделения). Значение `-1` для `set_position` перемещает курсор в конец текста.

- `editable` — Editable-виджет.
- `position` — позиция курсора в символах, либо `-1` для конца текста.

```nim
gtk_editable_set_position(entry, -1)  # переместить курсор в конец
echo "Текущая позиция курсора: ", gtk_editable_get_position(entry)
```

---

### `gtk_editable_set_editable` / `gtk_editable_get_editable`

```nim
proc gtk_editable_set_editable*(editable: pointer, isEditable: gboolean)
proc gtk_editable_get_editable*(editable: pointer): gboolean
```

**Что делает.** Разрешают/запрещают редактирование текста пользователем, не отключая при этом сам виджет целиком (в отличие от `gtk_widget_set_sensitive` из базового справочника, после которого поле выглядит "приглушённым" и не принимает фокус вообще). Поле с `editable = false` выглядит как обычное активное поле, позволяет выделять и копировать текст, но не позволяет его изменять — подходит для отображения значений только для чтения в форме единообразного вида.

- `editable` — Editable-виджет.
- `isEditable` — `1.gboolean`, чтобы разрешить редактирование.

```nim
gtk_editable_set_text(readonlyIdField, "USR-00123")
gtk_editable_set_editable(readonlyIdField, 0.gboolean)
echo "Поле идентификатора доступно для просмотра и копирования, но не для правки"
```

---

### `gtk_editable_set_alignment` / `gtk_editable_get_alignment`

```nim
proc gtk_editable_set_alignment*(editable: pointer, xalign: gfloat)
proc gtk_editable_get_alignment*(editable: pointer): gfloat
```

**Что делает.** Задают горизонтальное выравнивание текста внутри поля дробным значением от `0.0` (по левому краю) до `1.0` (по правому) — аналог `gtk_label_set_xalign` из справочника по базовым элементам управления, но для редактируемого поля. Удобно для полей числовых значений, которые традиционно выравниваются по правому краю.

- `editable` — Editable-виджет.
- `xalign` — значение от `0.0` до `1.0`.

```nim
gtk_editable_set_alignment(quantityEntry, 1.0)  # числа прижаты к правому краю поля
echo "Выравнивание поля количества: ", gtk_editable_get_alignment(quantityEntry)
```

---

### `gtk_editable_set_width_chars` / `gtk_editable_get_width_chars` / `gtk_editable_set_max_width_chars` / `gtk_editable_get_max_width_chars`

```nim
proc gtk_editable_set_width_chars*(editable: pointer, nChars: gint)
proc gtk_editable_get_width_chars*(editable: pointer): gint
proc gtk_editable_set_max_width_chars*(editable: pointer, nChars: gint)
proc gtk_editable_get_max_width_chars*(editable: pointer): gint
```

**Что делает.** Задают минимальную (`width_chars`) и максимальную (`max_width_chars`) ширину поля в символах — та же логика, что и у `gtk_label_set_width_chars`/`set_max_width_chars` из справочника по базовым элементам управления, но применительно к редактируемому полю. Не путать с `gtk_entry_set_max_length` (раздел II) — та ограничивает **количество вводимых символов**, а не визуальную ширину поля.

- `editable` — Editable-виджет.
- `nChars` — количество символов, либо `-1`, чтобы не ограничивать.

```nim
gtk_editable_set_width_chars(zipCodeEntry, 6)
gtk_editable_set_max_width_chars(zipCodeEntry, 6)
echo "Поле почтового индекса шириной ровно в 6 символов"
```

---

### `gtk_editable_set_enable_undo` / `gtk_editable_get_enable_undo`

```nim
proc gtk_editable_set_enable_undo*(editable: pointer, enableUndo: gboolean)
proc gtk_editable_get_enable_undo*(editable: pointer): gboolean
```

**Что делает.** Включают/выключают встроенную в GTK поддержку отмены/повтора ввода (`Ctrl+Z`/`Ctrl+Shift+Z`) для конкретного поля — включена по умолчанию. Отключение имеет смысл для полей, где история правок не нужна или может вводить пользователя в заблуждение (например, поле, значение которого программно перезаписывается извне, а не только вводом пользователя).

- `editable` — Editable-виджет.
- `enableUndo` — `0.gboolean`, чтобы отключить историю отмены для этого поля.

```nim
gtk_editable_set_enable_undo(autoGeneratedField, 0.gboolean)
echo "История отмены для автозаполняемого поля отключена"
```

---

## GtkEntry

`GtkEntry` — стандартное однострочное поле ввода. Сам текст, курсор и выделение управляются интерфейсом `GtkEditable` (раздел I) — процедуры этого раздела отвечают за всё остальное: внешний вид, ограничения ввода, иконки внутри поля, индикатор прогресса и подсказки для программных клавиатур/методов ввода.

### `gtk_entry_new` / `gtk_entry_new_with_buffer`

```nim
proc gtk_entry_new*(): GtkEntry
proc gtk_entry_new_with_buffer*(buffer: GtkEntryBuffer): GtkEntry
```

**Что делает.** Создают поле ввода — с собственным внутренним буфером текста (`gtk_entry_new`) либо с заранее подготовленным общим буфером (`gtk_entry_new_with_buffer`). Общий буфер (`GtkEntryBuffer`) позволяет нескольким полям ввода отображать и синхронно редактировать один и тот же текст — специализированный сценарий, отдельно от него в подавляющем большинстве случаев достаточно `gtk_entry_new`.

- `buffer` — предварительно созданный `GtkEntryBuffer` (см. `gtk_entry_set_buffer` ниже).

```nim
let nameEntry = gtk_entry_new()
echo "Поле ввода имени создано"
```

---

### `gtk_entry_set_placeholder_text` / `gtk_entry_get_placeholder_text`

```nim
proc gtk_entry_set_placeholder_text*(entry: GtkEntry, text: cstring)
proc gtk_entry_get_placeholder_text*(entry: GtkEntry): cstring
```

**Что делает.** Задают текст-подсказку внутри поля, показываемый серым цветом, пока поле пустое, и исчезающий при вводе (типичный паттерн "placeholder" из веб-форм). Это не значение поля — `gtk_editable_get_text` для пустого поля с установленным placeholder всё равно вернёт пустую строку, а не текст подсказки.

- `entry` — поле ввода.
- `text` — текст подсказки.

```nim
gtk_entry_set_placeholder_text(searchBox, "Поиск по названию...")
echo "Текст-подсказка установлен: ", $gtk_entry_get_placeholder_text(searchBox)
```

---

### `gtk_entry_set_visibility` / `gtk_entry_get_visibility`

```nim
proc gtk_entry_set_visibility*(entry: GtkEntry, visible: gboolean)
proc gtk_entry_get_visibility*(entry: GtkEntry): gboolean
```

**Что делает.** Включают/выключают отображение вводимого текста как есть — при `visible = false` вместо символов показывается символ-маска (см. `gtk_entry_set_invisible_char`), как в поле пароля. Для полноценного поля пароля в GTK4 обычно используют готовый `GtkPasswordEntry` (раздел III), а не `GtkEntry` с выключенной видимостью, — эта настройка сохранена для случаев, когда нужно именно поле с поведением `GtkEntry` (например, со своей иконкой автодополнения), но с маскировкой текста.

- `entry` — поле ввода.
- `visible` — `0.gboolean`, чтобы маскировать вводимый текст.

```nim
gtk_entry_set_visibility(pinEntry, 0.gboolean)
echo "Текст поля маскируется: ", gtk_entry_get_visibility(pinEntry) == 0.gboolean
```

---

### `gtk_entry_set_max_length` / `gtk_entry_get_max_length`

```nim
proc gtk_entry_set_max_length*(entry: GtkEntry, max: gint)
proc gtk_entry_get_max_length*(entry: GtkEntry): gint
```

**Что делает.** Ограничивают максимальное количество символов, которое пользователь может ввести в поле, — попытка ввести больше просто игнорируется на уровне самого виджета (в отличие от `gtk_editable_set_max_width_chars` из раздела I, которая ограничивает только визуальную ширину, но не количество вводимого текста). `0` означает отсутствие ограничения.

- `entry` — поле ввода.
- `max` — максимальное число символов, `0` — без ограничения.

```nim
gtk_entry_set_max_length(pinEntry, 4)
echo "Максимальная длина ПИН-кода: ", gtk_entry_get_max_length(pinEntry)
```

---

### `gtk_entry_set_has_frame` / `gtk_entry_get_has_frame`

```nim
proc gtk_entry_set_has_frame*(entry: GtkEntry, setting: gboolean)
proc gtk_entry_get_has_frame*(entry: GtkEntry): gboolean
```

**Что делает.** Убирают/возвращают стандартную рамку поля — аналог `gtk_button_set_has_frame` из справочника по базовым элементам управления. Используется для полей, встраиваемых в панель инструментов или в составной виджет, где отдельная рамка поля визуально избыточна на фоне общей рамки контейнера.

- `entry` — поле ввода.
- `setting` — `0.gboolean`, чтобы убрать рамку.

```nim
gtk_entry_set_has_frame(inlineEditEntry, 0.gboolean)
echo "Поле без рамки, для встраивания в составной виджет"
```

---

### `gtk_entry_set_alignment` / `gtk_entry_get_alignment`

```nim
proc gtk_entry_set_alignment*(entry: GtkEntry, xalign: gfloat)
proc gtk_entry_get_alignment*(entry: GtkEntry): gfloat
```

**Что делает.** То же самое, что `gtk_editable_set_alignment`/`get_alignment` из раздела I, но объявлено отдельно как собственная функция `GtkEntry` — исторически сложившееся дублирование в публичном API самой GTK (обе функции делают одно и то же для `GtkEntry`, поскольку `GtkEntry` реализует `GtkEditable`). Разницы в поведении нет — какую из двух использовать, значения не имеет.

- `entry` — поле ввода.
- `xalign` — значение от `0.0` до `1.0`.

```nim
gtk_entry_set_alignment(priceEntry, 1.0)
echo "Поле цены выровнено по правому краю"
```

---

### `gtk_entry_set_buffer` / `gtk_entry_get_buffer`

```nim
proc gtk_entry_set_buffer*(entry: GtkEntry, buffer: GtkEntryBuffer)
proc gtk_entry_get_buffer*(entry: GtkEntry): GtkEntryBuffer
```

**Что делает.** Устанавливают и читают внутренний буфер текста поля — тот же объект, что можно передать сразу в конструктор `gtk_entry_new_with_buffer`. Смена буфера уже существующего поля целиком заменяет его текст на текст нового буфера; несколько полей, использующих один и тот же объект `GtkEntryBuffer`, автоматически синхронизируют свой текст.

- `entry` — поле ввода.
- `buffer` — объект `GtkEntryBuffer`.

```nim
let sharedBuffer = gtk_entry_get_buffer(primaryEntry)
gtk_entry_set_buffer(mirrorEntry, sharedBuffer)
echo "Два поля теперь показывают и редактируют один и тот же текст"
```

---

### `gtk_entry_set_invisible_char` / `gtk_entry_get_invisible_char` / `gtk_entry_unset_invisible_char`

```nim
proc gtk_entry_set_invisible_char*(entry: GtkEntry, ch: gunichar)
proc gtk_entry_get_invisible_char*(entry: GtkEntry): gunichar
proc gtk_entry_unset_invisible_char*(entry: GtkEntry)
```

**Что делает.** Задают символ, которым маскируется текст при выключенной видимости (`gtk_entry_set_visibility(entry, 0.gboolean)`) — по умолчанию используется символ "чёрная точка" (`•`). `gtk_entry_unset_invisible_char` возвращает символ маски к значению по умолчанию.

- `entry` — поле ввода.
- `ch` — символ маски (`gunichar` — код символа Unicode, а не однобайтовый `char`).

```nim
gtk_entry_set_visibility(pinEntry, 0.gboolean)
gtk_entry_set_invisible_char(pinEntry, gunichar(ord('*')))
echo "Символ маски заменён на звёздочку"
```

---

### `gtk_entry_set_activates_default` / `gtk_entry_get_activates_default`

```nim
proc gtk_entry_set_activates_default*(entry: GtkEntry, setting: gboolean)
proc gtk_entry_get_activates_default*(entry: GtkEntry): gboolean
```

**Что делает.** Включают поведение "нажатие Enter в поле активирует кнопку по умолчанию окна/диалога" — без этого нажатие Enter в поле ввода ничего не делает на уровне окна (только эмитирует сигнал самого поля `"activate"`). Обязательная настройка для полей форм, где ожидается отправка по Enter (см. рецепт «Отправка формы по Enter» в разделе V).

- `entry` — поле ввода.
- `setting` — `1.gboolean`, чтобы включить активацию кнопки по умолчанию.

```nim
gtk_entry_set_activates_default(passwordEntry, 1.gboolean)
echo "Enter в поле пароля теперь активирует кнопку входа по умолчанию"
```

---

### `gtk_entry_set_attributes` / `gtk_entry_get_attributes`

```nim
proc gtk_entry_set_attributes*(entry: GtkEntry, attrs: PangoAttrList)
proc gtk_entry_get_attributes*(entry: GtkEntry): PangoAttrList
```

**Что делает.** Устанавливают и читают список атрибутов форматирования Pango для текста поля — та же логика, что у `gtk_label_set_attributes`/`get_attributes` из справочника по базовым элементам управления. Применимо, например, для подсветки синтаксиса в поле ввода команды.

- `entry` — поле ввода.
- `attrs` — список атрибутов Pango.

```nim
# attrs строится заранее через pango_attr_list_new/pango_attr_list_insert
gtk_entry_set_attributes(commandEntry, attrs)
echo "Атрибуты форматирования применены к полю ввода команды"
```

---

### `gtk_entry_set_tabs` / `gtk_entry_get_tabs`

```nim
proc gtk_entry_set_tabs*(entry: GtkEntry, tabs: PangoTabArray)
proc gtk_entry_get_tabs*(entry: GtkEntry): PangoTabArray
```

**Что делает.** Задают позиции табуляции для символов `\t` внутри текста поля — та же логика, что у `gtk_label_set_tabs`. Для однострочного поля ввода актуальность этой настройки ниже, чем для многострочного текста, но опция сохранена, так как `GtkEntry` в принципе поддерживает символ табуляции в своём содержимом.

- `entry` — поле ввода.
- `tabs` — массив позиций табуляции Pango.

```nim
# tabArray строится заранее через pango_tab_array_new/pango_tab_array_set_tab
gtk_entry_set_tabs(commandEntry, tabArray)
echo "Позиции табуляции для поля ввода команды заданы"
```

---

### `gtk_entry_set_progress_fraction` / `gtk_entry_get_progress_fraction` / `set_progress_pulse_step` / `get_progress_pulse_step` / `gtk_entry_progress_pulse`

```nim
proc gtk_entry_set_progress_fraction*(entry: GtkEntry, fraction: gdouble)
proc gtk_entry_get_progress_fraction*(entry: GtkEntry): gdouble
proc gtk_entry_set_progress_pulse_step*(entry: GtkEntry, fraction: gdouble)
proc gtk_entry_get_progress_pulse_step*(entry: GtkEntry): gdouble
proc gtk_entry_progress_pulse*(entry: GtkEntry)
```

**Что делает.** Показывают индикатор прогресса прямо внутри поля ввода, поверх текста, — необычная, но встроенная в `GtkEntry` возможность, полезная, например, для поля адреса с индикацией загрузки страницы или поля с фоновой асинхронной проверкой введённого значения. `set_progress_fraction` задаёт точную долю выполнения от `0.0` до `1.0` (для операций с известным прогрессом). Для операций с неизвестной длительностью используется "пульсирующий" режим: `set_progress_pulse_step` задаёт шаг пульсации, а каждый вызов `gtk_entry_progress_pulse` сдвигает индикатор на этот шаг — вызывать `progress_pulse` нужно периодически самому (например, по таймеру), автоматической анимации нет.

- `entry` — поле ввода.
- `fraction` — доля выполнения от `0.0` до `1.0`.

```nim
gtk_entry_set_progress_pulse_step(urlEntry, 0.1)
proc onPulseTimeout(userData: gpointer): gboolean {.cdecl.} =
  gtk_entry_progress_pulse(urlEntry)
  result = 1.gboolean  # 1 — продолжать вызывать таймер дальше
# g_timeout_add(200, onPulseTimeout, nil)  # запуск таймера — см. справочник по GLib-таймерам
echo "Пульсирующий индикатор загрузки настроен на шаг 0.1"
```

---

### `gtk_entry_set_completion` / `gtk_entry_get_completion`

```nim
proc gtk_entry_set_completion*(entry: GtkEntry, completion: GtkEntryCompletion)
proc gtk_entry_get_completion*(entry: GtkEntry): GtkEntryCompletion
```

**Что делает.** Подключают к полю всплывающий список автодополнения (`GtkEntryCompletion`) — выпадающий список вариантов, фильтрующийся по мере ввода. Построение самого объекта `GtkEntryCompletion` (модель данных, столбец текста) — отдельная тема, не входящая в этот справочник.

- `entry` — поле ввода.
- `completion` — заранее настроенный объект `GtkEntryCompletion`.

```nim
# completion строится заранее через gtk_entry_completion_new + настройку модели
gtk_entry_set_completion(cityEntry, completion)
echo "Автодополнение подключено к полю города"
```

---

### `gtk_entry_get_text_length`

```nim
proc gtk_entry_get_text_length*(entry: GtkEntry): guint16
```

**Что делает.** Возвращает текущую длину текста поля в символах. Функционально эквивалентно `len($gtk_editable_get_text(entry))` (с поправкой на то, что `len` для Nim-строки считает байты UTF-8, а не символы Unicode) — этот вызов быстрее, так как не требует копирования всей строки только ради подсчёта длины.

- `entry` — поле ввода.

```nim
echo "Введено символов: ", gtk_entry_get_text_length(bioEntry)
```

---

### Иконки внутри поля: `gtk_entry_set_icon_from_icon_name` и родственные

```nim
proc gtk_entry_set_icon_from_icon_name*(entry: GtkEntry, icon_pos: GtkEntryIconPosition, icon_name: cstring)
proc gtk_entry_set_icon_from_gicon*(entry: GtkEntry, icon_pos: GtkEntryIconPosition, icon: GIcon)
proc gtk_entry_set_icon_from_paintable*(entry: GtkEntry, icon_pos: GtkEntryIconPosition, paintable: GdkPaintable)
proc gtk_entry_get_icon_storage_type*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): GtkImageType
proc gtk_entry_get_icon_name*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): cstring
proc gtk_entry_get_icon_gicon*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): GIcon
proc gtk_entry_get_icon_paintable*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): GdkPaintable
proc gtk_entry_set_icon_activatable*(entry: GtkEntry, icon_pos: GtkEntryIconPosition, activatable: gboolean)
proc gtk_entry_get_icon_activatable*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): gboolean
proc gtk_entry_set_icon_sensitive*(entry: GtkEntry, icon_pos: GtkEntryIconPosition, sensitive: gboolean)
proc gtk_entry_get_icon_sensitive*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): gboolean
proc gtk_entry_set_icon_tooltip_text*(entry: GtkEntry, icon_pos: GtkEntryIconPosition, tooltip: cstring)
proc gtk_entry_get_icon_tooltip_text*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): cstring
proc gtk_entry_set_icon_tooltip_markup*(entry: GtkEntry, icon_pos: GtkEntryIconPosition, tooltip: cstring)
proc gtk_entry_get_icon_tooltip_markup*(entry: GtkEntry, icon_pos: GtkEntryIconPosition): cstring
proc gtk_entry_get_icon_at_pos*(entry: GtkEntry, x: gint, y: gint): gint
```

**Что делает.** Большая группа функций управляет двумя "слотами" для иконок внутри поля — в начале (`GTK_ENTRY_ICON_PRIMARY`) и в конце (`GTK_ENTRY_ICON_SECONDARY`) текста. Именно так в GTK4 устроены типичные паттерны вроде "иконка поиска слева, крестик очистки справа" в `GtkSearchEntry`, или "значок валидности справа" в форме. Иконку можно задать по имени из темы (`from_icon_name`), произвольным `GIcon` или напрямую готовым изображением (`from_paintable`); `get_icon_storage_type` сообщает, каким из трёх способов задана текущая иконка в слоте (`GTK_IMAGE_EMPTY`, если иконки нет). Иконку можно сделать кликабельной (`set_icon_activatable`) — тогда клик по ней эмитирует сигнал `"icon-press"` — и снабдить всплывающей подсказкой (`set_icon_tooltip_text`/`_markup`). `get_icon_at_pos` определяет, находится ли пиксельная координата над одной из иконок (возвращает индекс позиции иконки, либо `-1`, если координата не над иконкой).

- `entry` — поле ввода.
- `icon_pos` — `GTK_ENTRY_ICON_PRIMARY` или `GTK_ENTRY_ICON_SECONDARY`.
- `icon_name` / `icon` / `paintable` — источник изображения иконки (один из трёх взаимоисключающих способов).
- `activatable`, `sensitive` — `1.gboolean`/`0.gboolean`.
- `tooltip` — текст всплывающей подсказки для иконки.

```nim
gtk_entry_set_icon_from_icon_name(searchLikeEntry, GTK_ENTRY_ICON_SECONDARY, "edit-clear-symbolic")
gtk_entry_set_icon_activatable(searchLikeEntry, GTK_ENTRY_ICON_SECONDARY, 1.gboolean)
gtk_entry_set_icon_tooltip_text(searchLikeEntry, GTK_ENTRY_ICON_SECONDARY, "Очистить")

proc onIconPress(entry: GtkEntry, iconPos: GtkEntryIconPosition, userData: gpointer) {.cdecl.} =
  if iconPos == GTK_ENTRY_ICON_SECONDARY:
    gtk_editable_set_text(entry, "")
    echo "Поле очищено по клику на иконку"

discard g_signal_connect(searchLikeEntry, "icon-press", onIconPress, nil)
```

---

### `gtk_entry_set_input_purpose` / `gtk_entry_get_input_purpose` / `gtk_entry_set_input_hints` / `gtk_entry_get_input_hints`

```nim
proc gtk_entry_set_input_purpose*(entry: GtkEntry, purpose: GtkInputPurpose)
proc gtk_entry_get_input_purpose*(entry: GtkEntry): GtkInputPurpose
proc gtk_entry_set_input_hints*(entry: GtkEntry, hints: GtkInputHints)
proc gtk_entry_get_input_hints*(entry: GtkEntry): GtkInputHints
```

**Что делает.** Сообщают системе ввода (в первую очередь — экранной клавиатуре на сенсорных устройствах, но также влияет на методы ввода и автозамену) смысловое назначение поля. `input_purpose` — категория содержимого одним значением (`GTK_INPUT_PURPOSE_EMAIL`, `_PHONE`, `_DIGITS`, `_PASSWORD`, `_URL` и т.д.) — экранная клавиатура может показать, например, специальную раскладку с символом `@` для email. `input_hints` — независимая битовая маска дополнительных указаний (`GTK_INPUT_HINT_NO_SPELLCHECK`, `_UPPERCASE_WORDS`, `_WORD_COMPLETION` и т.п.), комбинируемых через `or`.

- `entry` — поле ввода.
- `purpose` — значение `GtkInputPurpose`.
- `hints` — битовая маска значений `GtkInputHints`.

```nim
gtk_entry_set_input_purpose(emailEntry, GTK_INPUT_PURPOSE_EMAIL)
gtk_entry_set_input_hints(emailEntry, GTK_INPUT_HINT_NO_SPELLCHECK)
echo "Поле email настроено: без проверки орфографии, с клавиатурой для email"
```

---

### `gtk_entry_set_extra_menu` / `gtk_entry_get_extra_menu`

```nim
proc gtk_entry_set_extra_menu*(entry: GtkEntry, model: GMenuModel)
proc gtk_entry_get_extra_menu*(entry: GtkEntry): GMenuModel
```

**Что делает.** Добавляют дополнительные пункты в стандартное контекстное меню поля (которое обычно содержит "Вырезать"/"Копировать"/"Вставить") — та же логика, что и `gtk_label_set_extra_menu`.

- `entry` — поле ввода.
- `model` — дополнительная модель меню.

```nim
# extraMenuModel строится заранее через g_menu_new/g_menu_append
gtk_entry_set_extra_menu(commandEntry, extraMenuModel)
echo "В контекстное меню поля добавлены дополнительные пункты"
```

---

### `gtk_entry_reset_im_context`

```nim
proc gtk_entry_reset_im_context*(entry: GtkEntry)
```

**Что делает.** Сбрасывает состояние текущего метода ввода (Input Method — механизм, используемый, например, для набора текста на языках со сложной раскладкой: китайский, японский, корейский, или для ввода составных символов). Нужен в редких случаях — например, если поле было программно очищено во время незавершённого ввода составного символа, и нужно явно прервать этот процесс ввода, а не оставить метод ввода в рассинхронизированном состоянии.

- `entry` — поле ввода.

```nim
gtk_editable_set_text(entry, "")
gtk_entry_reset_im_context(entry)
echo "Состояние метода ввода сброшено вместе с очисткой поля"
```

---

### `gtk_entry_grab_focus_without_selecting`

```nim
proc gtk_entry_grab_focus_without_selecting*(entry: GtkEntry): gboolean
```

**Что делает.** Передаёт полю клавиатурный фокус, не выделяя при этом весь текст поля целиком — обычный `gtk_widget_grab_focus` (базовый справочник) для `GtkEntry` по умолчанию выделяет весь текст при получении фокуса (стандартное поведение полей ввода, удобное для быстрой замены значения). Эта функция нужна, когда такое поведение нежелательно — например, при программном возврате фокуса в поле, где пользователь уже что-то печатал, и выделение текста было бы неожиданным для него.

- `entry` — поле ввода.

```nim
discard gtk_entry_grab_focus_without_selecting(entry)
echo "Фокус передан полю без выделения его текущего содержимого"
```

---

## GtkPasswordEntry

`GtkPasswordEntry` — специализированное поле для ввода пароля: текст всегда маскируется, а сам виджет добавляет только одну особенность сверх стандартного маскирования — кнопку "показать пароль" ("глазок"). Работа с самим текстом пароля идёт через тот же интерфейс `GtkEditable` (раздел I) — `gtk_editable_get_text`/`set_text`.

### `gtk_password_entry_new`

```nim
proc gtk_password_entry_new*(): GtkPasswordEntry
```

**Что делает.** Создаёт поле ввода пароля с уже включённым маскированием текста и кнопкой-глазком по умолчанию.

- Параметров нет.

```nim
let passwordEntry = gtk_password_entry_new()
echo "Поле пароля создано"
```

---

### `gtk_password_entry_set_show_peek_icon` / `gtk_password_entry_get_show_peek_icon`

```nim
proc gtk_password_entry_set_show_peek_icon*(entry: GtkPasswordEntry, showPeekIcon: gboolean)
proc gtk_password_entry_get_show_peek_icon*(entry: GtkPasswordEntry): gboolean
```

**Что делает.** Показывают/скрывают кнопку-глазок, позволяющую пользователю временно увидеть введённый пароль в открытом виде. По умолчанию кнопка показана; отключение уместно для полей с повышенными требованиями к приватности (например, повторный ввод PIN-кода в публичном месте) либо когда пароль вводится через отдельную кастомную кнопку показа/скрытия, реализованную самим приложением.

- `entry` — поле пароля.
- `showPeekIcon` — `0.gboolean`, чтобы скрыть кнопку-глазок.

```nim
gtk_password_entry_set_show_peek_icon(pinEntry, 0.gboolean)
echo "Кнопка-глазок скрыта: ", gtk_password_entry_get_show_peek_icon(pinEntry) == 0.gboolean
```

---

### `gtk_password_entry_set_extra_menu` / `gtk_password_entry_get_extra_menu`

```nim
proc gtk_password_entry_set_extra_menu*(entry: GtkPasswordEntry, model: GMenuModel)
proc gtk_password_entry_get_extra_menu*(entry: GtkPasswordEntry): GMenuModel
```

**Что делает.** Добавляют дополнительные пункты в контекстное меню поля пароля — та же логика, что у `gtk_entry_set_extra_menu`. Обратите внимание: у поля пароля стандартное контекстное меню по умолчанию не содержит пункта "Копировать" (по соображениям безопасности) — добавление собственных пунктов через `extra_menu` не возвращает эту возможность автоматически.

- `entry` — поле пароля.
- `model` — дополнительная модель меню.

```nim
# extraMenuModel строится заранее через g_menu_new/g_menu_append
gtk_password_entry_set_extra_menu(passwordEntry, extraMenuModel)
echo "В контекстное меню поля пароля добавлены дополнительные пункты"
```

---

## GtkSearchEntry

`GtkSearchEntry` — поле, специализированное под поиск: со встроенной иконкой лупы, кнопкой очистки при непустом тексте и сигналами, оптимизированными под живой поиск по мере набора текста (с задержкой, чтобы не запускать поиск на каждое нажатие клавиши). Текст поля — снова через `GtkEditable` (раздел I).

### `gtk_search_entry_new`

```nim
proc gtk_search_entry_new*(): GtkSearchEntry
```

**Что делает.** Создаёт поле поиска с иконкой лупы слева и автоматически появляющейся кнопкой очистки справа, когда поле не пустое.

- Параметров нет.

```nim
let searchEntry = gtk_search_entry_new()
echo "Поле поиска создано"
```

---

### `gtk_search_entry_set_placeholder_text` / `gtk_search_entry_get_placeholder_text`

```nim
proc gtk_search_entry_set_placeholder_text*(entry: GtkSearchEntry, text: cstring)
proc gtk_search_entry_get_placeholder_text*(entry: GtkSearchEntry): cstring
```

**Что делает.** То же самое, что `gtk_entry_set_placeholder_text` из раздела II, но как отдельная функция `GtkSearchEntry`, — текст-подсказка, показываемый, пока поле пустое.

- `entry` — поле поиска.
- `text` — текст подсказки.

```nim
gtk_search_entry_set_placeholder_text(searchEntry, "Поиск по контактам")
echo "Подсказка поля поиска: ", $gtk_search_entry_get_placeholder_text(searchEntry)
```

---

### `gtk_search_entry_set_search_delay` / `gtk_search_entry_get_search_delay`

```nim
proc gtk_search_entry_set_search_delay*(entry: GtkSearchEntry, delay: guint)
proc gtk_search_entry_get_search_delay*(entry: GtkSearchEntry): guint
```

**Что делает.** Задают задержку в миллисекундах между последним нажатием клавиши и эмиссией сигнала `"search-changed"` — в отличие от сигнала `"changed"` (эмитируется на каждое изменение текста немедленно, унаследован от `GtkEditable`), `"search-changed"` специально предназначен для запуска самого поиска и "гасит" быстро следующие друг за другом нажатия клавиш в одно срабатывание после паузы в наборе. Это избавляет от необходимости реализовывать debounce вручную через таймер.

- `entry` — поле поиска.
- `delay` — задержка в миллисекундах (значение по умолчанию — 150 мс).

```nim
gtk_search_entry_set_search_delay(searchEntry, 300)

proc onSearchChanged(entry: GtkSearchEntry, userData: gpointer) {.cdecl.} =
  echo "Запускаем поиск по: ", $gtk_editable_get_text(entry)

discard g_signal_connect(searchEntry, "search-changed", onSearchChanged, nil)
echo "Поиск запускается через 300 мс паузы в наборе текста"
```

---

### `gtk_search_entry_set_key_capture_widget` / `gtk_search_entry_get_key_capture_widget`

```nim
proc gtk_search_entry_set_key_capture_widget*(entry: GtkSearchEntry, widget: GtkWidget)
proc gtk_search_entry_get_key_capture_widget*(entry: GtkSearchEntry): GtkWidget
```

**Что делает.** Связывают поле поиска с другим виджетом (обычно — со списком/деревом результатов или с целым окном) так, что начало набора текста в пределах указанного виджета автоматически передаёт фокус и вводимые символы в поле поиска, даже если сам пользователь не кликал по полю явно, — паттерн "начните печатать, чтобы искать", привычный по файловым менеджерам.

- `entry` — поле поиска.
- `widget` — виджет (или окно), в пределах которого нажатия клавиш должны перехватываться полем поиска.

```nim
gtk_search_entry_set_key_capture_widget(searchEntry, resultsListView)
echo "Печать в списке результатов теперь автоматически перенаправляется в поле поиска"
```

---

### `gtk_search_entry_set_input_purpose` / `gtk_search_entry_get_input_purpose` / `set_input_hints` / `get_input_hints`

```nim
proc gtk_search_entry_set_input_purpose*(entry: GtkSearchEntry, purpose: GtkInputPurpose)
proc gtk_search_entry_get_input_purpose*(entry: GtkSearchEntry): GtkInputPurpose
proc gtk_search_entry_set_input_hints*(entry: GtkSearchEntry, hints: GtkInputHints)
proc gtk_search_entry_get_input_hints*(entry: GtkSearchEntry): GtkInputHints
```

**Что делает.** То же самое, что `gtk_entry_set_input_purpose`/`set_input_hints` из раздела II, применительно к полю поиска — назначение содержимого для экранной клавиатуры и дополнительные указания (например, отключение автозаглавной буквы, уместное для поиска, где регистр обычно не важен).

- `entry` — поле поиска.
- `purpose` — значение `GtkInputPurpose` (для поиска обычно остаётся `GTK_INPUT_PURPOSE_FREE_FORM`, значение по умолчанию).
- `hints` — битовая маска значений `GtkInputHints`.

```nim
gtk_search_entry_set_input_hints(searchEntry, GTK_INPUT_HINT_NO_SPELLCHECK)
echo "Проверка орфографии для поля поиска отключена"
```

---

## Практические рецепты

### Форма входа: логин + пароль с кнопкой-глазком

Стандартная связка поля логина и `GtkPasswordEntry` — кнопка-глазок для пароля уже встроена, дополнительно настраивать её не нужно.

```nim
proc buildLoginForm(): GtkGrid =
  result = gtk_grid_new()
  gtk_grid_set_row_spacing(result, 8)
  gtk_grid_set_column_spacing(result, 12)

  let loginLabel = gtk_label_new("Логин:")
  gtk_widget_set_halign(loginLabel, GTK_ALIGN_END)
  let loginEntry = gtk_entry_new()
  gtk_entry_set_placeholder_text(loginEntry, "имя пользователя")
  gtk_widget_set_hexpand(loginEntry, 1.gboolean)
  gtk_grid_attach(result, loginLabel, 0, 0, 1, 1)
  gtk_grid_attach(result, loginEntry, 1, 0, 1, 1)

  let passwordLabel = gtk_label_new("Пароль:")
  gtk_widget_set_halign(passwordLabel, GTK_ALIGN_END)
  let passwordEntry = gtk_password_entry_new()
  gtk_entry_set_activates_default(passwordEntry, 1.gboolean)
  gtk_grid_attach_next_to(result, passwordLabel, loginLabel, GTK_POS_BOTTOM, 1, 1)
  gtk_grid_attach_next_to(result, passwordEntry, passwordLabel, GTK_POS_RIGHT, 1, 1)

  echo "Форма входа собрана: логин + пароль с кнопкой-глазком"

let loginForm = buildLoginForm()
```

---

### Поле поиска с задержкой и живой фильтрацией

Полная связка `GtkSearchEntry` с обработчиком `"search-changed"`, срабатывающим только после паузы в наборе текста.

```nim
proc onSearchChanged(entry: GtkSearchEntry, userData: gpointer) {.cdecl.} =
  let query = $gtk_editable_get_text(entry)
  if query.len == 0:
    echo "Запрос пуст — показать все элементы"
  else:
    echo "Фильтрация списка по запросу: '", query, "'"

proc buildSearchBar(): GtkSearchEntry =
  result = gtk_search_entry_new()
  gtk_search_entry_set_placeholder_text(result, "Поиск...")
  gtk_search_entry_set_search_delay(result, 250)
  discard g_signal_connect(result, "search-changed", onSearchChanged, nil)

let searchBar = buildSearchBar()
```

---

### Поле email с иконкой валидации

Иконка в конце поля меняется в зависимости от того, похож ли введённый текст на email — простая проверка "есть символ `@`" для примера.

```nim
proc onEmailChanged(entry: GtkEntry, userData: gpointer) {.cdecl.} =
  let text = $gtk_editable_get_text(entry)
  if text.len == 0:
    gtk_entry_set_icon_from_icon_name(entry, GTK_ENTRY_ICON_SECONDARY, nil)
  elif '@' in text:
    gtk_entry_set_icon_from_icon_name(entry, GTK_ENTRY_ICON_SECONDARY, "emblem-ok-symbolic")
    gtk_entry_set_icon_tooltip_text(entry, GTK_ENTRY_ICON_SECONDARY, "Похоже на email")
  else:
    gtk_entry_set_icon_from_icon_name(entry, GTK_ENTRY_ICON_SECONDARY, "dialog-warning-symbolic")
    gtk_entry_set_icon_tooltip_text(entry, GTK_ENTRY_ICON_SECONDARY, "Не похоже на email")

proc buildEmailField(): GtkEntry =
  result = gtk_entry_new()
  gtk_entry_set_placeholder_text(result, "you@example.com")
  gtk_entry_set_input_purpose(result, GTK_INPUT_PURPOSE_EMAIL)
  discard g_signal_connect(result, "changed", onEmailChanged, nil)

let emailField = buildEmailField()
echo "Поле email с живой валидацией через иконку собрано"
```

---

### Поле ввода с индикатором прогресса (например, при проверке пароля)

Пульсирующий индикатор внутри поля, пока идёт асинхронная операция (например, проверка занятости логина на сервере).

```nim
var pulseActive = false

proc onPulseTick(userData: gpointer): gboolean {.cdecl.} =
  let entry = cast[GtkEntry](userData)
  if pulseActive:
    gtk_entry_progress_pulse(entry)
    result = 1.gboolean  # продолжать таймер
  else:
    gtk_entry_set_progress_fraction(entry, 0.0)  # погасить индикатор
    result = 0.gboolean  # остановить таймер

proc startAvailabilityCheck(entry: GtkEntry) =
  pulseActive = true
  gtk_entry_set_progress_pulse_step(entry, 0.15)
  # g_timeout_add(150, onPulseTick, cast[gpointer](entry))  # см. справочник по GLib-таймерам
  echo "Проверка занятости логина началась, индикатор запущен"

proc finishAvailabilityCheck() =
  pulseActive = false
  echo "Проверка завершена, индикатор погашен"
```

---

### Отправка формы по Enter через `activates_default`

Чтобы нажатие Enter в любом поле формы срабатывало как клик по кнопке "Войти", у кнопки должен быть выставлен флаг "кнопка по умолчанию" окна, а у полей — включён `activates_default`.

```nim
proc buildLoginFormWithSubmit(window: GtkWindow): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_VERTICAL, 12)

  let loginEntry = gtk_entry_new()
  gtk_entry_set_activates_default(loginEntry, 1.gboolean)
  gtk_box_append(result, loginEntry)

  let passwordEntry = gtk_password_entry_new()
  gtk_entry_set_activates_default(passwordEntry, 1.gboolean)
  gtk_box_append(result, passwordEntry)

  let submitButton = gtk_button_new_with_label("Войти")
  gtk_widget_add_css_class(submitButton, "suggested-action")
  gtk_box_append(result, submitButton)

  # gtk_window_set_default_widget(window, submitButton) — см. справочник по WINDOW/WIDGET
  echo "Enter в любом из полей теперь активирует кнопку 'Войти'"

# let loginBox = buildLoginFormWithSubmit(mainWindow)
```

---

## Краткая таблица

| Процедура(ы) | Категория | Что делает вкратце |
|---|---|---|
| `gtk_editable_get/set_text` | GtkEditable | Весь текст поля целиком — основной способ работы с содержимым |
| `gtk_editable_get_chars` | GtkEditable | Подстрока текста по диапазону символов |
| `gtk_editable_insert_text`, `delete_text` | GtkEditable | Вставка/удаление текста в произвольной позиции |
| `gtk_editable_get_selection_bounds`, `select_region`, `delete_selection` | GtkEditable | Работа с текущим выделением |
| `gtk_editable_set/get_position` | GtkEditable | Позиция текстового курсора |
| `gtk_editable_set/get_editable` | GtkEditable | Разрешить/запретить правку, не отключая поле целиком |
| `gtk_editable_set/get_alignment` | GtkEditable | Горизонтальное выравнивание текста в поле |
| `gtk_editable_set/get_width_chars`, `set/get_max_width_chars` | GtkEditable | Мин./макс. визуальная ширина поля в символах |
| `gtk_editable_set/get_enable_undo` | GtkEditable | Встроенная история отмены ввода (Ctrl+Z) |
| `gtk_entry_new`, `_with_buffer` | Entry | Создать поле — с собственным или общим буфером текста |
| `gtk_entry_set/get_placeholder_text` | Entry | Текст-подсказка на пустом поле |
| `gtk_entry_set/get_visibility` | Entry | Маскировка вводимого текста |
| `gtk_entry_set/get_max_length` | Entry | Максимальное число вводимых символов |
| `gtk_entry_set/get_has_frame` | Entry | Рамка поля |
| `gtk_entry_set/get_alignment` | Entry | Выравнивание текста (дублирует `gtk_editable_*`) |
| `gtk_entry_set/get_buffer` | Entry | Общий буфер текста между несколькими полями |
| `gtk_entry_set/get_invisible_char`, `unset_invisible_char` | Entry | Символ маски при выключенной видимости |
| `gtk_entry_set/get_activates_default` | Entry | Enter в поле активирует кнопку по умолчанию окна |
| `gtk_entry_set/get_attributes` | Entry | Программные атрибуты форматирования Pango |
| `gtk_entry_set/get_tabs` | Entry | Позиции табуляции для `\t` |
| `gtk_entry_set/get_progress_fraction`, `pulse_step`, `progress_pulse` | Entry | Индикатор прогресса внутри поля |
| `gtk_entry_set/get_completion` | Entry | Всплывающий список автодополнения |
| `gtk_entry_get_text_length` | Entry | Быстрое получение длины текста без копирования строки |
| `gtk_entry_set_icon_from_icon_name/gicon/paintable` | Entry | Иконка в начале/конце поля |
| `gtk_entry_get_icon_storage_type` | Entry | Каким способом задана иконка в слоте |
| `gtk_entry_set/get_icon_activatable`, `set/get_icon_sensitive` | Entry | Кликабельность и доступность иконки |
| `gtk_entry_set/get_icon_tooltip_text/markup` | Entry | Подсказка для иконки |
| `gtk_entry_get_icon_at_pos` | Entry | Находится ли координата над иконкой |
| `gtk_entry_set/get_input_purpose`, `set/get_input_hints` | Entry | Назначение поля для экранной клавиатуры/методов ввода |
| `gtk_entry_set/get_extra_menu` | Entry | Доп. пункты в контекстном меню поля |
| `gtk_entry_reset_im_context` | Entry | Сброс состояния метода ввода |
| `gtk_entry_grab_focus_without_selecting` | Entry | Передать фокус без выделения всего текста |
| `gtk_password_entry_new` | PasswordEntry | Создать поле пароля |
| `gtk_password_entry_set/get_show_peek_icon` | PasswordEntry | Кнопка "показать пароль" |
| `gtk_password_entry_set/get_extra_menu` | PasswordEntry | Доп. пункты в контекстном меню поля пароля |
| `gtk_search_entry_new` | SearchEntry | Создать поле поиска |
| `gtk_search_entry_set/get_placeholder_text` | SearchEntry | Текст-подсказка |
| `gtk_search_entry_set/get_search_delay` | SearchEntry | Задержка перед сигналом `"search-changed"` |
| `gtk_search_entry_set/get_key_capture_widget` | SearchEntry | Автоперенаправление печати из другого виджета |
| `gtk_search_entry_set/get_input_purpose`, `set/get_input_hints` | SearchEntry | Назначение поля для экранной клавиатуры |

---

## Сводка: какую процедуру выбрать

- **Работа с текстом любого поля ввода** (получить/установить, выделение, позиция курсора) → всегда `gtk_editable_*`, а не отдельные функции конкретного класса — интерфейс `GtkEditable` одинаков для `GtkEntry`, `GtkPasswordEntry`, `GtkSearchEntry`.
- **Нужно поле пароля** → `GtkPasswordEntry`, а не `GtkEntry` с `gtk_entry_set_visibility(entry, 0.gboolean)` — специализированный виджет уже даёт кнопку-глазок и корректное поведение контекстного меню (без "Копировать") из коробки.
- **Нужно поле поиска с живой фильтрацией** → `GtkSearchEntry` + сигнал `"search-changed"` (уже с задержкой через `gtk_search_entry_set_search_delay`), а не `GtkEntry` + сигнал `"changed"` с самостоятельно написанным debounce-таймером.
- **Ограничить, сколько пользователь может ввести** → `gtk_entry_set_max_length` (число символов). **Ограничить, сколько поле занимает места на экране** → `gtk_editable_set_width_chars`/`set_max_width_chars` — это два независимых, не путаемых друг с другом ограничения.
- **Нажатие Enter должно отправлять форму** → `gtk_entry_set_activates_default(entry, 1.gboolean)` на каждом поле формы, плюс кнопка отправки должна быть назначена кнопкой по умолчанию окна.
- **Иконка внутри поля** (лупа, крестик очистки, индикатор валидности) → `gtk_entry_set_icon_from_icon_name`/`_from_gicon`/`_from_paintable` с указанием `GTK_ENTRY_ICON_PRIMARY`/`_SECONDARY`, а не отдельный `GtkImage` рядом с полем — так иконка визуально и функционально интегрирована в само поле (клик, подсказка).
- **Поле только для отображения значения, без возможности редактирования, но с возможностью выделить и скопировать** → `gtk_editable_set_editable(entry, 0.gboolean)`, а не `gtk_widget_set_sensitive(entry, 0.gboolean)` — второе также блокирует выделение и копирование текста.
- **Длительная фоновая операция, связанная с полем** (проверка на сервере, загрузка) → пульсирующий индикатор через `gtk_entry_set_progress_pulse_step`/`gtk_entry_progress_pulse`, если длительность неизвестна, либо `gtk_entry_set_progress_fraction`, если прогресс известен точно.
