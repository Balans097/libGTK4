# GTK4 (multiline text: GtkTextBuffer / GtkTextView) — справочник модуля

> **Импорт:** `import libGTK4`
> **Область применения:** многострочный текст — модель данных (`GtkTextBuffer`) и её визуальное представление (`GtkTextView`). Четвёртая часть серии справочников по обёртке; предполагает знакомство с предыдущими частями (`gtk4_core_reference_ru.md`, `gtk4_basic_controls_reference_ru.md`, `gtk4_text_input_reference_ru.md`).

Важное отличие от однострочных полей (справочник по вводу текста): у многострочного текста в GTK4 модель данных (`GtkTextBuffer` — сам текст, форматирование, метки) и виджет отображения (`GtkTextView` — как этот текст показан на экране: перенос строк, отступы, курсор) — это два разных объекта. Один и тот же буфер можно показать сразу в нескольких `GtkTextView` одновременно (они будут синхронно отражать один текст) — примерно как `GtkEntryBuffer` у `GtkEntry`, но с гораздо более богатой моделью.

Положение внутри текста в этом API задаётся не числом (индексом символа), а структурой `GtkTextIter` ("итератор") — множество функций и `GtkTextBuffer`, и `GtkTextView` принимают и заполняют `ptr GtkTextIter`. В этой обёртке `GtkTextIter` — структура фиксированного размера, которую нужно объявить как обычную Nim-переменную (`var iter: GtkTextIter`) и передавать по адресу (`addr iter`) — сама GTK заполняет её содержимое, вызывающему коду не нужно и не следует создавать итератор вручную "с нуля".

---

## Оглавление

I. [GtkTextBuffer](#gtktextbuffer)
&nbsp;&nbsp;1. [`gtk_text_buffer_new`](#gtk_text_buffer_new)
&nbsp;&nbsp;2. [`gtk_text_buffer_set_text` / `gtk_text_buffer_get_text` / `gtk_text_buffer_get_slice`](#gtk_text_buffer_set_text--gtk_text_buffer_get_text--gtk_text_buffer_get_slice)
&nbsp;&nbsp;3. [`gtk_text_buffer_insert` / `gtk_text_buffer_insert_at_cursor` / `_range`](#gtk_text_buffer_insert--gtk_text_buffer_insert_at_cursor--_range)
&nbsp;&nbsp;4. [Интерактивные вставка и удаление: `_interactive`-варианты](#интерактивные-вставка-и-удаление-_interactive-варианты)
&nbsp;&nbsp;5. [`gtk_text_buffer_delete` / `gtk_text_buffer_backspace`](#gtk_text_buffer_delete--gtk_text_buffer_backspace)
&nbsp;&nbsp;6. [`gtk_text_buffer_get_char_count` / `gtk_text_buffer_get_line_count`](#gtk_text_buffer_get_char_count--gtk_text_buffer_get_line_count)
&nbsp;&nbsp;7. [Получение итераторов: `get_start_iter` и родственные](#получение-итераторов-get_start_iter-и-родственные)
&nbsp;&nbsp;8. [Маркеры (marks): `create_mark` и родственные](#маркеры-marks-create_mark-и-родственные)
&nbsp;&nbsp;9. [`gtk_text_buffer_place_cursor` / `gtk_text_buffer_select_range`](#gtk_text_buffer_place_cursor--gtk_text_buffer_select_range)
&nbsp;&nbsp;10. [Выделение: `get_selection_bounds` / `get_has_selection` / `delete_selection`](#выделение-get_selection_bounds--get_has_selection--delete_selection)
&nbsp;&nbsp;11. [Теги форматирования: `apply_tag` и родственные](#теги-форматирования-apply_tag-и-родственные)
&nbsp;&nbsp;12. [Якоря для дочерних виджетов и изображений](#якоря-для-дочерних-виджетов-и-изображений)
&nbsp;&nbsp;13. [Буфер обмена: `cut/copy/paste_clipboard`](#буфер-обмена-cutcopypaste_clipboard)
&nbsp;&nbsp;14. [Флаг изменения: `gtk_text_buffer_set/get_modified`](#флаг-изменения-gtk_text_buffer_setget_modified)
&nbsp;&nbsp;15. [Undo/Redo буфера](#undoredo-буфера)

II. [GtkTextView](#gtktextview)
&nbsp;&nbsp;1. [`gtk_text_view_new` / `gtk_text_view_new_with_buffer`](#gtk_text_view_new--gtk_text_view_new_with_buffer)
&nbsp;&nbsp;2. [`gtk_text_view_set_buffer` / `gtk_text_view_get_buffer`](#gtk_text_view_set_buffer--gtk_text_view_get_buffer)
&nbsp;&nbsp;3. [`gtk_text_view_set_editable` / `gtk_text_view_get_editable`](#gtk_text_view_set_editable--gtk_text_view_get_editable)
&nbsp;&nbsp;4. [`gtk_text_view_set_wrap_mode` / `gtk_text_view_get_wrap_mode`](#gtk_text_view_set_wrap_mode--gtk_text_view_get_wrap_mode)
&nbsp;&nbsp;5. [`gtk_text_view_set_cursor_visible` / `gtk_text_view_get_cursor_visible`](#gtk_text_view_set_cursor_visible--gtk_text_view_get_cursor_visible)
&nbsp;&nbsp;6. [`gtk_text_view_set_monospace` / `gtk_text_view_get_monospace`](#gtk_text_view_set_monospace--gtk_text_view_get_monospace)
&nbsp;&nbsp;7. [Отступы и выравнивание: margins, indent, justification](#отступы-и-выравнивание-margins-indent-justification)
&nbsp;&nbsp;8. [`gtk_text_view_set_tabs` / `gtk_text_view_get_tabs`](#gtk_text_view_set_tabs--gtk_text_view_get_tabs)
&nbsp;&nbsp;9. [`gtk_text_view_set_accepts_tab` / `gtk_text_view_get_accepts_tab`](#gtk_text_view_set_accepts_tab--gtk_text_view_get_accepts_tab)
&nbsp;&nbsp;10. [`gtk_text_view_set_overwrite` / `gtk_text_view_get_overwrite`](#gtk_text_view_set_overwrite--gtk_text_view_get_overwrite)
&nbsp;&nbsp;11. [`gtk_text_view_set_input_purpose` / `get_input_purpose` / `set_input_hints` / `get_input_hints`](#gtk_text_view_set_input_purpose--get_input_purpose--set_input_hints--get_input_hints)
&nbsp;&nbsp;12. [Прокрутка к позиции: `scroll_to_mark` / `scroll_to_iter` / `scroll_mark_onscreen`](#прокрутка-к-позиции-scroll_to_mark--scroll_to_iter--scroll_mark_onscreen)
&nbsp;&nbsp;13. [Преобразование координат: `get_iter_at_location` и родственные](#преобразование-координат-get_iter_at_location-и-родственные)
&nbsp;&nbsp;14. [`gtk_text_view_set_gutter` / `gtk_text_view_get_gutter`](#gtk_text_view_set_gutter--gtk_text_view_get_gutter)
&nbsp;&nbsp;15. [`gtk_text_view_set_extra_menu` / `gtk_text_view_get_extra_menu`](#gtk_text_view_set_extra_menu--gtk_text_view_get_extra_menu)
&nbsp;&nbsp;16. [Встраивание виджетов: `add_child_at_anchor` / `add_overlay` / `move_overlay` / `remove`](#встраивание-виджетов-add_child_at_anchor--add_overlay--move_overlay--remove)
&nbsp;&nbsp;17. [Навигация по визуальным строкам: `forward/backward_display_line` и родственные](#навигация-по-визуальным-строкам-forwardbackward_display_line-и-родственные)
&nbsp;&nbsp;18. [`gtk_text_view_get_cursor_locations`](#gtk_text_view_get_cursor_locations)
&nbsp;&nbsp;19. [`gtk_text_view_reset_im_context` / `gtk_text_view_im_context_filter_keypress`](#gtk_text_view_reset_im_context--gtk_text_view_im_context_filter_keypress)

III. [Практические рецепты](#практические-рецепты)
&nbsp;&nbsp;1. [Простой многострочный редактор с переносом и отступами](#простой-многострочный-редактор-с-переносом-и-отступами)
&nbsp;&nbsp;2. [Подсветка части текста через теги](#подсветка-части-текста-через-теги)
&nbsp;&nbsp;3. [Индикатор несохранённых изменений через флаг modified](#индикатор-несохранённых-изменений-через-флаг-modified)
&nbsp;&nbsp;4. [Поле только для чтения с моноширинным шрифтом (просмотр лога)](#поле-только-для-чтения-с-моноширинным-шрифтом-просмотр-лога)
&nbsp;&nbsp;5. [Группировка правок в одну операцию отмены](#группировка-правок-в-одну-операцию-отмены)

IV. [Краткая таблица](#краткая-таблица)

V. [Сводка: какую процедуру выбрать](#сводка-какую-процедуру-выбрать)

---

## GtkTextBuffer

`GtkTextBuffer` хранит сам текст, его форматирование (через теги — `GtkTextTag`) и именованные позиции внутри текста (маркеры — `GtkTextMark`), но ничего не знает о том, как это должно быть нарисовано на экране, — за отрисовку отвечает `GtkTextView` (раздел II).

### `gtk_text_buffer_new`

```nim
proc gtk_text_buffer_new*(table: GtkTextTagTable): GtkTextBuffer
```

**Что делает.** Создаёт пустой буфер текста. `table` — таблица тегов форматирования (`GtkTextTagTable`), которую буфер будет использовать; передача `nil` создаёт буфер с новой пустой таблицей тегов автоматически — для большинства сценариев (в том числе всех примеров этого справочника) этого достаточно, и создавать таблицу тегов вручную не требуется.

- `table` — таблица тегов, либо `nil` для автоматически создаваемой пустой таблицы.

```nim
let buffer = gtk_text_buffer_new(nil)
echo "Пустой буфер текста создан"
```

---

### `gtk_text_buffer_set_text` / `gtk_text_buffer_get_text` / `gtk_text_buffer_get_slice`

```nim
proc gtk_text_buffer_set_text*(buffer: GtkTextBuffer, text: cstring, len: gint)
proc gtk_text_buffer_get_text*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter, include_hidden_chars: gboolean): cstring
proc gtk_text_buffer_get_slice*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter, include_hidden_chars: gboolean): cstring
```

**Что делает.** `set_text` заменяет весь текст буфера целиком. `get_text` возвращает текст в заданном диапазоне (`get_start_iter`/`get_end_iter` — для всего текста целиком, см. ниже); `get_slice`, в отличие от `get_text`, дополнительно подставляет текстовое представление для нетекстовых элементов внутри диапазона — например, вставленных изображений — как символ-заполнитель. `include_hidden_chars` определяет, включать ли в результат текст, помеченный тегом невидимости (скрытый текст) — для обычного использования передаётся `1.gboolean`.

- `buffer` — буфер.
- `text` — новый текст (для `set_text`).
- `len` — длина текста в байтах, либо `-1` для обычной `NUL`-терминированной строки.
- `start`, `end` — итераторы, ограничивающие диапазон чтения.
- `include_hidden_chars` — `1.gboolean`, чтобы включить скрытый тегами текст.

```nim
let buffer = gtk_text_buffer_new(nil)
gtk_text_buffer_set_text(buffer, "Первая строка\nВторая строка", -1)

var startIter, endIter: GtkTextIter
gtk_text_buffer_get_start_iter(buffer, addr startIter)
gtk_text_buffer_get_end_iter(buffer, addr endIter)
echo "Текст буфера: ", $gtk_text_buffer_get_text(buffer, addr startIter, addr endIter, 1.gboolean)
```

---

### `gtk_text_buffer_insert` / `gtk_text_buffer_insert_at_cursor` / `_range`

```nim
proc gtk_text_buffer_insert*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, text: cstring, len: gint)
proc gtk_text_buffer_insert_at_cursor*(buffer: GtkTextBuffer, text: cstring, len: gint)
proc gtk_text_buffer_insert_range*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, start: ptr GtkTextIter, `end`: ptr GtkTextIter)
```

**Что делает.** Вставляют текст в буфер, не затрагивая остальное содержимое. `gtk_text_buffer_insert` вставляет по указанной позиции (после вставки `iter` смещается на конец вставленного текста). `insert_at_cursor` — короткая форма для самого частого случая, вставки в текущую позицию курсора (маркер `"insert"`, см. раздел про маркеры). `insert_range` копирует и вставляет диапазон текста **из того же или другого буфера** — включая теги форматирования этого диапазона, а не только голый текст.

- `buffer` — буфер.
- `iter` — позиция вставки (для `insert`).
- `text` — вставляемый текст.
- `len` — длина в байтах, либо `-1`.
- `start`, `end` (для `insert_range`) — диапазон-источник для копирования.

```nim
gtk_text_buffer_insert_at_cursor(buffer, "добавленный текст", -1)
echo "Текст вставлен в текущую позицию курсора"
```

---

### Интерактивные вставка и удаление: `_interactive`-варианты

```nim
proc gtk_text_buffer_insert_interactive*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, text: cstring, len: gint, default_editable: gboolean): gboolean
proc gtk_text_buffer_insert_interactive_at_cursor*(buffer: GtkTextBuffer, text: cstring, len: gint, default_editable: gboolean): gboolean
proc gtk_text_buffer_insert_range_interactive*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, start: ptr GtkTextIter, `end`: ptr GtkTextIter, default_editable: gboolean): gboolean
proc gtk_text_buffer_delete_interactive*(buffer: GtkTextBuffer, start_iter: ptr GtkTextIter, end_iter: ptr GtkTextIter, default_editable: gboolean): gboolean
```

**Что делает.** "Интерактивные" версии операций вставки/удаления учитывают, помечен ли текст в затрагиваемом диапазоне тегами как нередактируемый (`GtkTextTag` может индивидуально запрещать редактирование помеченного им фрагмента, даже если весь `GtkTextView` в целом редактируемый — например, для "заблокированных" вставленных цитат). `default_editable` — что считать редактируемостью по умолчанию для текста без явного тега на этот счёт (обычно `1.gboolean`, если сам буфер в целом предназначен для редактирования). Возвращают `gboolean` — удалась ли операция целиком; частичное применение (только к редактируемым фрагментам диапазона) — тоже штатный исход, о котором отдельно не сообщается.

- **Реализация.** Обычная (не интерактивная) `gtk_text_buffer_insert`/`delete` **всегда** выполняет операцию, игнорируя теги нередактируемости, — интерактивные варианты нужны именно тогда, когда вставка/удаление инициирована действием пользователя (например, внутри обработчика ввода с клавиатуры) и должна уважать защищённые тегами участки; для программных модификаций текста, минуя пользовательский ввод, обычно достаточно неинтерактивных версий.

- `buffer` — буфер.
- `default_editable` — `1.gboolean`, если текст без явного тега считается редактируемым.

```nim
var cursorIter: GtkTextIter
gtk_text_buffer_get_iter_at_mark(buffer, addr cursorIter, gtk_text_buffer_get_insert(buffer))
let inserted = gtk_text_buffer_insert_interactive(buffer, addr cursorIter, "текст от пользователя", -1, 1.gboolean)
echo "Вставка выполнена: ", inserted != 0.gboolean
```

---

### `gtk_text_buffer_delete` / `gtk_text_buffer_backspace`

```nim
proc gtk_text_buffer_delete*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter)
proc gtk_text_buffer_backspace*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, interactive: gboolean, default_editable: gboolean): gboolean
```

**Что делает.** `delete` безусловно удаляет диапазон текста между итераторами. `backspace` эмулирует ровно одно нажатие клавиши `Backspace` в позиции `iter` — это не просто "удалить один символ назад": для составных символов (эмодзи из нескольких кодовых точек, комбинируемые диакритические знаки) `backspace` удаляет ровно то, что удалил бы пользователь одним нажатием клавиши, что может отличаться от удаления одного `gunichar`.

- `buffer` — буфер.
- `start`, `end` (для `delete`) — границы удаляемого диапазона.
- `iter` (для `backspace`) — позиция, перед которой выполняется удаление (после вызова итератор указывает на новую позицию курсора).
- `interactive`, `default_editable` (для `backspace`) — та же логика уважения тегов нередактируемости, что и у `_interactive`-вариантов выше.

```nim
var start, stop: GtkTextIter
gtk_text_buffer_get_iter_at_offset(buffer, addr start, 0)
gtk_text_buffer_get_iter_at_offset(buffer, addr stop, 5)
gtk_text_buffer_delete(buffer, addr start, addr stop)
echo "Первые 5 символов буфера удалены"
```

---

### `gtk_text_buffer_get_char_count` / `gtk_text_buffer_get_line_count`

```nim
proc gtk_text_buffer_get_char_count*(buffer: GtkTextBuffer): gint
proc gtk_text_buffer_get_line_count*(buffer: GtkTextBuffer): gint
```

**Что делает.** Возвращают общее количество символов и количество строк (разделённых `\n`) в буфере целиком — быстрее, чем вычислять то же самое через `get_text` и подсчёт вручную, так как не требует копирования всего текста.

- `buffer` — буфер.

```nim
echo "В документе ", gtk_text_buffer_get_line_count(buffer), " строк, ",
     gtk_text_buffer_get_char_count(buffer), " символов"
```

---

### Получение итераторов: `get_start_iter` и родственные

```nim
proc gtk_text_buffer_get_start_iter*(buffer: GtkTextBuffer, iter: ptr GtkTextIter)
proc gtk_text_buffer_get_end_iter*(buffer: GtkTextBuffer, iter: ptr GtkTextIter)
proc gtk_text_buffer_get_bounds*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter)
proc gtk_text_buffer_get_iter_at_line*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, line_number: gint)
proc gtk_text_buffer_get_iter_at_offset*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, char_offset: gint)
proc gtk_text_buffer_get_iter_at_line_offset*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, line_number: gint, char_offset: gint)
proc gtk_text_buffer_get_iter_at_line_index*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, line_number: gint, byte_index: gint)
proc gtk_text_buffer_get_iter_at_mark*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, mark: GtkTextMark)
proc gtk_text_buffer_get_iter_at_child_anchor*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, anchor: GtkTextChildAnchor)
```

**Что делает.** Все эти функции заполняют переданный по указателю `GtkTextIter`, указывая его на конкретную позицию в тексте — это единственный способ получить итератор (создать его "с нуля" без буфера нельзя). `get_start_iter`/`get_end_iter`/`get_bounds` — начало, конец и сразу обе границы всего текста. `get_iter_at_offset` — позиция по абсолютному номеру символа от начала текста (аналог `gtk_editable_set_position` для однострочных полей, но для буфера). `get_iter_at_line`/`get_iter_at_line_offset` — по номеру строки (и, во втором случае, смещению символа внутри этой строки). `get_iter_at_line_index` — то же самое, что `_line_offset`, но смещение задаётся в **байтах** UTF-8, а не в символах — нужна редко, в основном при интеграции с кодом, оперирующим байтовыми индексами. `get_iter_at_mark`/`get_iter_at_child_anchor` — позиция ранее созданного маркера/якоря (см. следующие подразделы).

- `buffer` — буфер.
- `iter` — указатель на структуру, которая будет заполнена.
- `line_number` — номер строки, начиная с `0`.
- `char_offset` — смещение в символах.
- `byte_index` — смещение в байтах UTF-8.
- `mark`, `anchor` — ранее созданные маркер или якорь.

```nim
var lineStart: GtkTextIter
gtk_text_buffer_get_iter_at_line(buffer, addr lineStart, 1)  # начало второй строки (индекс с 0)
echo "Итератор установлен на начало второй строки"
```

---

### Маркеры (marks): `create_mark` и родственные

```nim
proc gtk_text_buffer_create_mark*(buffer: GtkTextBuffer, mark_name: cstring, where: ptr GtkTextIter, left_gravity: gboolean): GtkTextMark
proc gtk_text_buffer_add_mark*(buffer: GtkTextBuffer, mark: GtkTextMark, where: ptr GtkTextIter)
proc gtk_text_buffer_move_mark*(buffer: GtkTextBuffer, mark: GtkTextMark, where: ptr GtkTextIter)
proc gtk_text_buffer_move_mark_by_name*(buffer: GtkTextBuffer, name: cstring, where: ptr GtkTextIter)
proc gtk_text_buffer_delete_mark*(buffer: GtkTextBuffer, mark: GtkTextMark)
proc gtk_text_buffer_delete_mark_by_name*(buffer: GtkTextBuffer, name: cstring)
proc gtk_text_buffer_get_mark*(buffer: GtkTextBuffer, name: cstring): GtkTextMark
proc gtk_text_buffer_get_insert*(buffer: GtkTextBuffer): GtkTextMark
proc gtk_text_buffer_get_selection_bound*(buffer: GtkTextBuffer): GtkTextMark
```

**Что делает.** Маркер (`GtkTextMark`) — именованная позиция внутри текста, которая, в отличие от `GtkTextIter`, **сохраняется** при последующем редактировании текста: если текст перед маркером изменяется, маркер автоматически "плывёт" вместе с окружающим его текстом, оставаясь на том же логическом месте. `GtkTextIter`, наоборот, — это снимок позиции на конкретный момент, который становится некорректным сразу после любого изменения текста буфера. Каждый буфер уже содержит два предопределённых маркера, доступных через `get_insert` (текущая позиция курсора) и `get_selection_bound` (другой конец текущего выделения, если оно есть) — именно эти два маркера использует `place_cursor`/`select_range` (следующий подраздел). `left_gravity` определяет, к какому символу "прилипает" маркер при вставке текста ровно в его позиции — `1.gboolean` означает, что вставленный текст окажется **после** маркера.

- `buffer` — буфер.
- `mark_name` / `name` — имя маркера (можно передать `nil` для анонимного маркера, обращаться к которому затем можно только через возвращённый объект `GtkTextMark`, а не по имени).
- `where` — позиция, куда поместить/переместить маркер.
- `left_gravity` — `1.gboolean`/`0.gboolean` (см. выше).
- `mark` — объект маркера, полученный от `create_mark`/`get_mark`/`get_insert`/`get_selection_bound`.

```nim
var savedPosition: GtkTextIter
gtk_text_buffer_get_iter_at_offset(buffer, addr savedPosition, 42)
let bookmark = gtk_text_buffer_create_mark(buffer, "bookmark-1", addr savedPosition, 1.gboolean)
# ... после произвольных правок текста в других местах буфера ...
var restoredIter: GtkTextIter
gtk_text_buffer_get_iter_at_mark(buffer, addr restoredIter, bookmark)
echo "Закладка восстановлена на прежнее логическое место, даже если текст выше сдвинулся"
```

---

### `gtk_text_buffer_place_cursor` / `gtk_text_buffer_select_range`

```nim
proc gtk_text_buffer_place_cursor*(buffer: GtkTextBuffer, where: ptr GtkTextIter)
proc gtk_text_buffer_select_range*(buffer: GtkTextBuffer, ins: ptr GtkTextIter, bound: ptr GtkTextIter)
```

**Что делает.** `place_cursor` перемещает курсор в указанную позицию и снимает текущее выделение (эквивалент клика мышью без зажатого Shift). `select_range` перемещает курсор в позицию `ins` и одновременно выделяет текст от неё до `bound` — если `ins` и `bound` совпадают, это эквивалентно `place_cursor`. Названия параметров соответствуют именам предопределённых маркеров `"insert"` и `"selection_bound"` (см. предыдущий подраздел) — именно эти два маркера переставляет данная функция.

- `buffer` — буфер.
- `where` (для `place_cursor`) — новая позиция курсора.
- `ins`, `bound` (для `select_range`) — новая позиция курсора и второй конец выделения.

```nim
var start, stop: GtkTextIter
gtk_text_buffer_get_iter_at_offset(buffer, addr start, 0)
gtk_text_buffer_get_iter_at_offset(buffer, addr stop, 13)
gtk_text_buffer_select_range(buffer, addr stop, addr start)  # выделить первые 13 символов
echo "Первая строка выделена программно"
```

---

### Выделение: `get_selection_bounds` / `get_has_selection` / `delete_selection`

```nim
proc gtk_text_buffer_get_selection_bounds*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter): gboolean
proc gtk_text_buffer_get_has_selection*(buffer: GtkTextBuffer): gboolean
proc gtk_text_buffer_delete_selection*(buffer: GtkTextBuffer, interactive: gboolean, default_editable: gboolean): gboolean
```

**Что делает.** Читают границы текущего выделения (`get_selection_bounds` заполняет оба итератора и возвращает `gboolean`, есть ли вообще выделение — аналог `gtk_editable_get_selection_bounds` для однострочных полей, но для буфера), проверяют сам факт наличия выделения без получения границ (`get_has_selection` — быстрее, если границы не нужны), и удаляют выделенный текст (`delete_selection`, с той же логикой `interactive`/`default_editable`, что и у остальных `_interactive`-операций).

- `buffer` — буфер.
- `start`, `end` — итераторы, в которые будут записаны границы выделения.
- `interactive`, `default_editable` (для `delete_selection`) — см. подраздел про интерактивные операции.

```nim
if gtk_text_buffer_get_has_selection(buffer) != 0.gboolean:
  discard gtk_text_buffer_delete_selection(buffer, 1.gboolean, 1.gboolean)
  echo "Выделенный текст удалён"
```

---

### Теги форматирования: `apply_tag` и родственные

```nim
proc gtk_text_buffer_apply_tag*(buffer: GtkTextBuffer, tag: GtkTextTag, start: ptr GtkTextIter, `end`: ptr GtkTextIter)
proc gtk_text_buffer_remove_tag*(buffer: GtkTextBuffer, tag: GtkTextTag, start: ptr GtkTextIter, `end`: ptr GtkTextIter)
proc gtk_text_buffer_apply_tag_by_name*(buffer: GtkTextBuffer, name: cstring, start: ptr GtkTextIter, `end`: ptr GtkTextIter)
proc gtk_text_buffer_remove_tag_by_name*(buffer: GtkTextBuffer, name: cstring, start: ptr GtkTextIter, `end`: ptr GtkTextIter)
proc gtk_text_buffer_remove_all_tags*(buffer: GtkTextBuffer, start: ptr GtkTextIter, `end`: ptr GtkTextIter)
proc gtk_text_buffer_get_tag_table*(buffer: GtkTextBuffer): GtkTextTagTable
```

**Что делает.** `GtkTextTag` — именованный набор атрибутов форматирования (цвет, жирность, зачёркивание, нередактируемость и т.д.), который можно применить к произвольному диапазону текста; один и тот же тег можно применять к нескольким несмежным диапазонам одновременно. `apply_tag`/`remove_tag` работают с уже созданным объектом `GtkTextTag`; `_by_name`-варианты — то же самое по имени тега, зарегистрированного в таблице тегов буфера (создание самих тегов — функции `gtk_text_tag_new`/`gtk_text_tag_table_add`, не входящие в этот справочник). `remove_all_tags` снимает сразу все теги с диапазона, независимо от того, какие именно были применены. `get_tag_table` возвращает таблицу тегов буфера — ту же, что можно было передать в `gtk_text_buffer_new`.

- `buffer` — буфер.
- `tag` / `name` — тег форматирования (объектом или по имени).
- `start`, `end` — диапазон применения.

```nim
# boldTag создаётся заранее через gtk_text_tag_new("bold") + свойство "weight",
# затем регистрируется в таблице тегов буфера
var start, stop: GtkTextIter
gtk_text_buffer_get_iter_at_offset(buffer, addr start, 0)
gtk_text_buffer_get_iter_at_offset(buffer, addr stop, 5)
gtk_text_buffer_apply_tag_by_name(buffer, "bold", addr start, addr stop)
echo "Первые 5 символов помечены тегом жирного начертания"
```

---

### Якоря для дочерних виджетов и изображений

```nim
proc gtk_text_buffer_create_child_anchor*(buffer: GtkTextBuffer, iter: ptr GtkTextIter): GtkTextChildAnchor
proc gtk_text_buffer_insert_markup*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, markup: cstring, len: gint)
proc gtk_text_buffer_insert_paintable*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, paintable: GdkPaintable)
```

**Что делает.** `create_child_anchor` создаёт в тексте "якорь" — специальную точку-заполнитель, в которую затем можно встроить произвольный виджет через `gtk_text_view_add_child_at_anchor` (раздел II) — так в текст вставляются, например, кнопки или мини-формы прямо посреди абзаца. `insert_markup` вставляет текст с Pango-разметкой (аналог `gtk_label_set_markup`, но с возможностью вставить именно в определённое место уже существующего текста, а не заменить всё содержимое). `insert_paintable` вставляет готовое изображение (`GdkPaintable`) прямо в текстовый поток.

- `buffer` — буфер.
- `iter` — позиция вставки.
- `markup` — текст с Pango-разметкой (для `insert_markup`).
- `paintable` — изображение (для `insert_paintable`).

```nim
var endIter: GtkTextIter
gtk_text_buffer_get_end_iter(buffer, addr endIter)
let anchor = gtk_text_buffer_create_child_anchor(buffer, addr endIter)
echo "Якорь для встраивания виджета создан в конце текста"
```

---

### Буфер обмена: `cut/copy/paste_clipboard`

```nim
proc gtk_text_buffer_cut_clipboard*(buffer: GtkTextBuffer, clipboard: GdkClipboard, default_editable: gboolean)
proc gtk_text_buffer_copy_clipboard*(buffer: GtkTextBuffer, clipboard: GdkClipboard)
proc gtk_text_buffer_paste_clipboard*(buffer: GtkTextBuffer, clipboard: GdkClipboard, override_location: ptr GtkTextIter, default_editable: gboolean)
```

**Что делает.** Программно выполняют операции "Вырезать"/"Копировать"/"Вставить" для текущего выделения буфера через системный буфер обмена — тот же эффект, что и стандартные сочетания клавиш, но вызываемый из кода (например, для собственного пункта меню "Копировать" вместо стандартного). `override_location` для `paste_clipboard` — необязательная позиция вставки, отличная от текущей позиции курсора (`nil` — вставить в текущую позицию курсора, как обычно).

- `buffer` — буфер.
- `clipboard` — объект буфера обмена (обычно получаемый через `gtk_widget_get_clipboard` — вне рамок этого справочника).
- `default_editable` — `1.gboolean`, если текст без явного тега считается редактируемым.
- `override_location` — позиция вставки, либо `nil`.

```nim
# clipboard получается заранее через gtk_widget_get_clipboard(textView)
gtk_text_buffer_copy_clipboard(buffer, clipboard)
echo "Выделенный текст скопирован в системный буфер обмена"
```

---

### Флаг изменения: `gtk_text_buffer_set/get_modified`

```nim
proc gtk_text_buffer_set_modified*(buffer: GtkTextBuffer, setting: gboolean)
proc gtk_text_buffer_get_modified*(buffer: GtkTextBuffer): gboolean
```

**Что делает.** GTK автоматически выставляет этот флаг в `true` при любом изменении текста буфера пользователем или программно — типичное применение: показывать в заголовке окна `"Документ.txt •"` (с точкой/звёздочкой) вместо `"Документ.txt"`, пока есть несохранённые изменения. После сохранения документа приложение должно **само** сбросить флаг вызовом `set_modified(buffer, 0.gboolean)` — GTK не знает о том, что содержимое было сохранено во внешний файл, и не сбрасывает флаг автоматически.

- `buffer` — буфер.
- `setting` — `0.gboolean`/`1.gboolean`.

```nim
proc onSave() =
  # ... запись текста буфера в файл ...
  gtk_text_buffer_set_modified(buffer, 0.gboolean)
  echo "Документ сохранён, флаг изменений сброшен"

echo "Есть несохранённые изменения: ", gtk_text_buffer_get_modified(buffer) != 0.gboolean
```

---

### Undo/Redo буфера

```nim
proc gtk_text_buffer_set_enable_undo*(buffer: GtkTextBuffer, enable_undo: gboolean)
proc gtk_text_buffer_get_enable_undo*(buffer: GtkTextBuffer): gboolean
proc gtk_text_buffer_get_can_undo*(buffer: GtkTextBuffer): gboolean
proc gtk_text_buffer_get_can_redo*(buffer: GtkTextBuffer): gboolean
proc gtk_text_buffer_undo*(buffer: GtkTextBuffer)
proc gtk_text_buffer_redo*(buffer: GtkTextBuffer)
proc gtk_text_buffer_begin_irreversible_action*(buffer: GtkTextBuffer)
proc gtk_text_buffer_end_irreversible_action*(buffer: GtkTextBuffer)
proc gtk_text_buffer_begin_user_action*(buffer: GtkTextBuffer)
proc gtk_text_buffer_end_user_action*(buffer: GtkTextBuffer)
proc gtk_text_buffer_set_max_undo_levels*(buffer: GtkTextBuffer, max_undo_levels: guint)
proc gtk_text_buffer_get_max_undo_levels*(buffer: GtkTextBuffer): guint
```

**Что делает.** У `GtkTextBuffer`, как и у `GtkEditable` (справочник по вводу текста), есть встроенная поддержка отмены/повтора — включена по умолчанию (`enable_undo`), `Ctrl+Z`/`Ctrl+Shift+Z` работают в `GtkTextView` без дополнительного кода. `get_can_undo`/`get_can_redo` сообщают, доступна ли отмена/повтор прямо сейчас (например, чтобы включить/выключить соответствующие пункты меню); `undo`/`redo` выполняют операцию программно. `begin_user_action`/`end_user_action` группируют несколько последовательных операций редактирования в одну запись истории — например, автозамена, которая удаляет слово и вставляет исправленное, без группировки создала бы два отдельных шага отмены вместо одного логического. `begin_irreversible_action`/`end_irreversible_action` — обратное: помечают операции внутри блока как не подлежащие отмене вообще (например, программную загрузку нового документа в существующий буфер, которую не должно быть возможности "отменить" обратно к прежнему содержимому). `max_undo_levels` ограничивает глубину истории (`0` — не ограничивать).

- `buffer` — буфер.
- `enable_undo` — `1.gboolean`/`0.gboolean`.
- `max_undo_levels` — максимальное число шагов истории.

```nim
gtk_text_buffer_begin_user_action(buffer)
gtk_text_buffer_delete(buffer, addr wrongWordStart, addr wrongWordEnd)
gtk_text_buffer_insert(buffer, addr wrongWordStart, "исправленноеСлово", -1)
gtk_text_buffer_end_user_action(buffer)
echo "Автозамена слова — единая операция для Ctrl+Z"
```

---

## GtkTextView

`GtkTextView` — виджет, отображающий содержимое `GtkTextBuffer` и обрабатывающий взаимодействие с пользователем (клавиатурный ввод, мышь, прокрутка). Сам текст и его форматирование редактируются через буфер (раздел I) — процедуры этого раздела отвечают за то, как этот текст выглядит и ведёт себя на экране.

### `gtk_text_view_new` / `gtk_text_view_new_with_buffer`

```nim
proc gtk_text_view_new*(): GtkTextView
proc gtk_text_view_new_with_buffer*(buffer: GtkTextBuffer): GtkTextView
```

**Что делает.** Создают виджет отображения текста — с автоматически созданным пустым буфером (`gtk_text_view_new`) либо с заранее подготовленным буфером (`gtk_text_view_new_with_buffer`, например, если текст должен быть виден сразу в нескольких `GtkTextView`).

- `buffer` — существующий буфер (для варианта `_with_buffer`).

```nim
let editor = gtk_text_view_new()
echo "Виджет отображения текста создан со своим собственным пустым буфером"
```

---

### `gtk_text_view_set_buffer` / `gtk_text_view_get_buffer`

```nim
proc gtk_text_view_set_buffer*(textView: GtkTextView, buffer: GtkTextBuffer)
proc gtk_text_view_get_buffer*(textView: GtkTextView): GtkTextBuffer
```

**Что делает.** Заменяют буфер, который отображает виджет, на другой (например, чтобы переключить редактор между несколькими открытыми документами, каждый из которых хранится в своём буфере), либо получают буфер, чтобы работать с текстом через функции раздела I.

- `textView` — виджет.
- `buffer` — новый буфер.

```nim
let buffer = gtk_text_view_get_buffer(editor)
gtk_text_buffer_set_text(buffer, "Начальный текст документа", -1)
echo "Текст установлен через буфер, полученный от виджета"
```

---

### `gtk_text_view_set_editable` / `gtk_text_view_get_editable`

```nim
proc gtk_text_view_set_editable*(textView: GtkTextView, setting: gboolean)
proc gtk_text_view_get_editable*(textView: GtkTextView): gboolean
```

**Что делает.** Разрешают/запрещают редактирование текста пользователем — та же логика, что и `gtk_editable_set_editable` для однострочных полей: текст остаётся видимым и выделяемым для копирования, но не поддаётся правке с клавиатуры. Типичное применение — просмотр лога или документации внутри `GtkTextView` (что даёт перенос строк, прокрутку и выделение текста "бесплатно", в отличие от `GtkLabel`).

- `textView` — виджет.
- `setting` — `0.gboolean`, чтобы запретить редактирование.

```nim
gtk_text_view_set_editable(logViewer, 0.gboolean)
echo "Просмотр лога доступен только для чтения: ", gtk_text_view_get_editable(logViewer) == 0.gboolean
```

---

### `gtk_text_view_set_wrap_mode` / `gtk_text_view_get_wrap_mode`

```nim
proc gtk_text_view_set_wrap_mode*(textView: GtkTextView, wrap_mode: PangoWrapMode)
proc gtk_text_view_get_wrap_mode*(textView: GtkTextView): PangoWrapMode
```

**Что делает.** Задают режим переноса длинных строк — та же логика и те же значения (`PANGO_WRAP_WORD`, `PANGO_WRAP_CHAR`, `PANGO_WRAP_WORD_CHAR`), что у `gtk_label_set_wrap_mode` из справочника по базовым элементам управления. В отличие от `GtkLabel`, у `GtkTextView` нет отдельного булева "включить перенос" — перенос всегда либо включён в одном из режимов, либо полностью выключен специальным значением `GTK_WRAP_NONE` (это значение относится к отдельному типу `GtkWrapMode`, а не `PangoWrapMode`, — в этой обёртке за него отвечает более широкий enum `GtkWrapMode`, объявленный в разделе базовых типов).

- `textView` — виджет.
- `wrap_mode` — значение `PangoWrapMode`.

```nim
gtk_text_view_set_wrap_mode(editor, PANGO_WRAP_WORD)
echo "Перенос длинных строк по границам слов включён"
```

---

### `gtk_text_view_set_cursor_visible` / `gtk_text_view_get_cursor_visible`

```nim
proc gtk_text_view_set_cursor_visible*(textView: GtkTextView, setting: gboolean)
proc gtk_text_view_get_cursor_visible*(textView: GtkTextView): gboolean
```

**Что делает.** Показывают/скрывают мигающий текстовый курсор — независимо от `editable`: можно, например, оставить курсор видимым в нередактируемом просмотрщике (чтобы пользователь мог перемещаться по тексту клавишами и видеть текущую позицию для последующего выделения и копирования), или, наоборот, скрыть курсор в редактируемом поле с полностью кастомным способом отображения позиции ввода.

- `textView` — виджет.
- `setting` — `0.gboolean`, чтобы скрыть курсор.

```nim
gtk_text_view_set_cursor_visible(logViewer, 1.gboolean)
echo "Курсор виден в просмотрщике лога даже без возможности редактирования"
```

---

### `gtk_text_view_set_monospace` / `gtk_text_view_get_monospace`

```nim
proc gtk_text_view_set_monospace*(textView: GtkTextView, monospace: gboolean)
proc gtk_text_view_get_monospace*(textView: GtkTextView): gboolean
```

**Что делает.** Переключают виджет на моноширинный шрифт (из настроек темы/системы) — удобно для отображения кода, логов, данных с выравниванием по столбцам через пробелы/табуляции, где пропорциональный шрифт визуально ломает выравнивание.

- `textView` — виджет.
- `monospace` — `1.gboolean` для моноширинного шрифта.

```nim
gtk_text_view_set_monospace(logViewer, 1.gboolean)
echo "Просмотрщик лога переключён на моноширинный шрифт"
```

---

### Отступы и выравнивание: margins, indent, justification

```nim
proc gtk_text_view_set_left_margin*(text_view: GtkTextView, left_margin: gint)
proc gtk_text_view_get_left_margin*(text_view: GtkTextView): gint
proc gtk_text_view_set_right_margin*(text_view: GtkTextView, right_margin: gint)
proc gtk_text_view_get_right_margin*(text_view: GtkTextView): gint
proc gtk_text_view_set_top_margin*(text_view: GtkTextView, top_margin: gint)
proc gtk_text_view_get_top_margin*(text_view: GtkTextView): gint
proc gtk_text_view_set_bottom_margin*(text_view: GtkTextView, bottom_margin: gint)
proc gtk_text_view_get_bottom_margin*(text_view: GtkTextView): gint
proc gtk_text_view_set_indent*(text_view: GtkTextView, indent: gint)
proc gtk_text_view_get_indent*(text_view: GtkTextView): gint
proc gtk_text_view_set_pixels_above_lines*(text_view: GtkTextView, pixels_above_lines: gint)
proc gtk_text_view_get_pixels_above_lines*(text_view: GtkTextView): gint
proc gtk_text_view_set_pixels_below_lines*(text_view: GtkTextView, pixels_below_lines: gint)
proc gtk_text_view_get_pixels_below_lines*(text_view: GtkTextView): gint
proc gtk_text_view_set_pixels_inside_wrap*(text_view: GtkTextView, pixels_inside_wrap: gint)
proc gtk_text_view_get_pixels_inside_wrap*(text_view: GtkTextView): gint
proc gtk_text_view_set_justification*(text_view: GtkTextView, justification: GtkJustification)
proc gtk_text_view_get_justification*(text_view: GtkTextView): GtkJustification
```

**Что делает.** Большая группа настроек типографики текста внутри виджета. `left_margin`/`right_margin`/`top_margin`/`bottom_margin` — внутренние отступы текста от границ виджета (не путать с `gtk_widget_set_margin_*` из базового справочника — та задаёт внешний отступ **самого виджета** в его контейнере, эта — отступ **текста внутри** виджета). `indent` — дополнительный отступ первой строки каждого абзаца (может быть отрицательным — тогда первая строка выступает влево относительно остальных, "висячий отступ"). `pixels_above_lines`/`pixels_below_lines` — дополнительное вертикальное расстояние до и после каждой строки текста (межстрочный интервал). `pixels_inside_wrap` — дополнительное расстояние между визуальными строками, на которые перенеслась одна логическая строка (то есть между переносами внутри одного абзаца, а не между абзацами). `justification` — та же логика, что у `gtk_label_set_justify`.

- `text_view` — виджет.
- Каждый параметр — значение в пикселях (для отступов/интервалов) либо `GtkJustification` (для выравнивания).

```nim
gtk_text_view_set_left_margin(editor, 16)
gtk_text_view_set_right_margin(editor, 16)
gtk_text_view_set_pixels_above_lines(editor, 2)
gtk_text_view_set_pixels_below_lines(editor, 2)
echo "Текстовый редактор получил комфортные поля и межстрочный интервал"
```

---

### `gtk_text_view_set_tabs` / `gtk_text_view_get_tabs`

```nim
proc gtk_text_view_set_tabs*(text_view: GtkTextView, tabs: PangoTabArray)
proc gtk_text_view_get_tabs*(text_view: GtkTextView): PangoTabArray
```

**Что делает.** Задают позиции табуляции для символов `\t` — та же логика, что у `gtk_label_set_tabs`/`gtk_entry_set_tabs`, но для многострочного виджета это гораздо более востребованная настройка (например, для редактора кода с шириной табуляции в 4 пробельные позиции).

- `text_view` — виджет.
- `tabs` — массив позиций табуляции Pango.

```nim
# tabArray строится заранее через pango_tab_array_new/pango_tab_array_set_tab
gtk_text_view_set_tabs(codeEditor, tabArray)
echo "Ширина табуляции для редактора кода настроена"
```

---

### `gtk_text_view_set_accepts_tab` / `gtk_text_view_get_accepts_tab`

```nim
proc gtk_text_view_set_accepts_tab*(text_view: GtkTextView, accepts_tab: gboolean)
proc gtk_text_view_get_accepts_tab*(text_view: GtkTextView): gboolean
```

**Что делает.** Определяют, вставляет ли нажатие клавиши `Tab` символ табуляции в текст (`1.gboolean`, поведение по умолчанию — типично для редакторов кода) или, наоборот, передаёт фокус следующему виджету формы, как в обычных полях (`0.gboolean` — уместно, когда `GtkTextView` используется как многострочное поле внутри формы, а не как самостоятельный редактор).

- `text_view` — виджет.
- `accepts_tab` — `1.gboolean`/`0.gboolean`.

```nim
gtk_text_view_set_accepts_tab(commentField, 0.gboolean)
echo "Tab в поле комментария теперь передаёт фокус дальше по форме, а не вставляет символ таба"
```

---

### `gtk_text_view_set_overwrite` / `gtk_text_view_get_overwrite`

```nim
proc gtk_text_view_set_overwrite*(text_view: GtkTextView, overwrite: gboolean)
proc gtk_text_view_get_overwrite*(text_view: GtkTextView): gboolean
```

**Что делает.** Переключают режим ввода между "вставка" (по умолчанию — новый текст сдвигает существующий) и "замена"/overwrite (новый текст затирает символы под курсором) — то же поведение, что переключает клавиша `Insert` на клавиатуре в большинстве текстовых редакторов.

- `text_view` — виджет.
- `overwrite` — `1.gboolean` для режима замены.

```nim
proc onInsertKeyPressed() =
  gtk_text_view_set_overwrite(editor, if gtk_text_view_get_overwrite(editor) != 0.gboolean: 0.gboolean else: 1.gboolean)
  echo "Режим ввода переключён"
```

---

### `gtk_text_view_set_input_purpose` / `get_input_purpose` / `set_input_hints` / `get_input_hints`

```nim
proc gtk_text_view_set_input_purpose*(text_view: GtkTextView, purpose: GtkInputPurpose)
proc gtk_text_view_get_input_purpose*(text_view: GtkTextView): GtkInputPurpose
proc gtk_text_view_set_input_hints*(text_view: GtkTextView, hints: GtkInputHints)
proc gtk_text_view_get_input_hints*(text_view: GtkTextView): GtkInputHints
```

**Что делает.** То же самое, что `gtk_entry_set_input_purpose`/`set_input_hints` из справочника по вводу текста, применительно к многострочному виджету — назначение содержимого для экранной клавиатуры и системы ввода.

- `text_view` — виджет.
- `purpose` — значение `GtkInputPurpose`.
- `hints` — битовая маска значений `GtkInputHints`.

```nim
gtk_text_view_set_input_hints(commentField, GTK_INPUT_HINT_UPPERCASE_SENTENCES)
echo "Первая буква каждого предложения будет предлагаться заглавной на экранной клавиатуре"
```

---

### Прокрутка к позиции: `scroll_to_mark` / `scroll_to_iter` / `scroll_mark_onscreen`

```nim
proc gtk_text_view_scroll_to_mark*(text_view: GtkTextView, mark: GtkTextMark, within_margin: gdouble, use_align: gboolean, xalign: gdouble, yalign: gdouble)
proc gtk_text_view_scroll_to_iter*(text_view: GtkTextView, iter: ptr GtkTextIter, within_margin: gdouble, use_align: gboolean, xalign: gdouble, yalign: gdouble): gboolean
proc gtk_text_view_scroll_mark_onscreen*(text_view: GtkTextView, mark: GtkTextMark)
```

**Что делает.** Прокручивают видимую область `GtkTextView`, чтобы показать заданную позицию — по маркеру (переживает изменения текста) либо по итератору (снимок на текущий момент, годится только для немедленного использования). `within_margin` — минимальный отступ от края видимой области (доля от `0.0` до `0.5`), внутри которого позиция не считается "видимой достаточно хорошо" и всё равно вызовет прокрутку. `use_align`/`xalign`/`yalign` — если `use_align = true`, позиция будет размещена на точном относительном месте видимой области (`0.0`–`1.0` по каждой оси, как у `gtk_label_set_xalign`); если `false`, GTK прокручивает на минимально необходимое расстояние, чтобы просто сделать позицию видимой, не более того. `scroll_mark_onscreen` — короткая форма для самого частого случая: минимальная прокрутка, чтобы просто показать маркер, без точного позиционирования.

- `text_view` — виджет.
- `mark` / `iter` — целевая позиция.
- `within_margin` — отступ-порог от `0.0` до `0.5`.
- `use_align`, `xalign`, `yalign` — точное позиционирование внутри видимой области.

```nim
let insertMark = gtk_text_buffer_get_insert(buffer)
gtk_text_view_scroll_mark_onscreen(editor, insertMark)
echo "Область прокручена так, чтобы курсор был виден"
```

---

### Преобразование координат: `get_iter_at_location` и родственные

```nim
proc gtk_text_view_get_iter_location*(text_view: GtkTextView, iter: ptr GtkTextIter, location: ptr GdkRectangle)
proc gtk_text_view_get_iter_at_location*(text_view: GtkTextView, iter: ptr GtkTextIter, x: gint, y: gint): gboolean
proc gtk_text_view_get_iter_at_position*(text_view: GtkTextView, iter: ptr GtkTextIter, trailing: ptr gint, x: gint, y: gint): gboolean
proc gtk_text_view_get_line_at_y*(text_view: GtkTextView, target_iter: ptr GtkTextIter, y: gint, line_top: ptr gint)
proc gtk_text_view_get_line_yrange*(text_view: GtkTextView, iter: ptr GtkTextIter, y: ptr gint, height: ptr gint)
proc gtk_text_view_get_visible_rect*(text_view: GtkTextView, visible_rect: ptr GdkRectangle)
proc gtk_text_view_buffer_to_window_coords*(text_view: GtkTextView, win: GtkTextWindowType, buffer_x: gint, buffer_y: gint, window_x: ptr gint, window_y: ptr gint)
proc gtk_text_view_window_to_buffer_coords*(text_view: GtkTextView, win: GtkTextWindowType, window_x: gint, window_y: gint, buffer_x: ptr gint, buffer_y: ptr gint)
```

**Что делает.** Группа функций для перевода между текстовой позицией (`GtkTextIter`) и пиксельными координатами — нужны для продвинутых сценариев вроде собственной обработки кликов мыши по определённому слову, отрисовки поверх конкретной строки текста, или для реализации собственного поведения прокрутки. `get_iter_location` — пиксельный прямоугольник, который занимает символ в данной позиции. `get_iter_at_location`/`get_iter_at_position` — обратная операция: по пиксельным координатам найти позицию текста под ними (`_at_position` дополнительно возвращает `trailing` — находится ли точка ближе к началу или концу символа под курсором, важно для точного позиционирования курсора между символами). `get_line_at_y`/`get_line_yrange` — аналогичные операции на уровне целых строк, а не отдельных символов. `get_visible_rect` — прямоугольник текущей видимой (не прокрученной за пределы экрана) области в координатах буфера. `buffer_to_window_coords`/`window_to_buffer_coords` — конвертация между системой координат буфера и системой координат конкретной области виджета (`win` — значение `GtkTextWindowType`, определяющее, о какой области идёт речь — основной текстовой области или боковых "gutter"-областях, см. следующий подраздел).

- `text_view` — виджет.
- `iter` — текстовая позиция (используется как источник или как результат, в зависимости от функции).
- `x`, `y` — пиксельные координаты.
- `win` — значение `GtkTextWindowType`.

```nim
var clickedIter: GtkTextIter
if gtk_text_view_get_iter_at_location(editor, addr clickedIter, mouseX, mouseY) != 0.gboolean:
  echo "Клик мыши попал в текстовую позицию, итератор получен"
```

---

### `gtk_text_view_set_gutter` / `gtk_text_view_get_gutter`

```nim
proc gtk_text_view_set_gutter*(text_view: GtkTextView, win: GtkTextWindowType, widget: GtkWidget)
proc gtk_text_view_get_gutter*(text_view: GtkTextView, win: GtkTextWindowType): GtkWidget
```

**Что делает.** Устанавливают произвольный виджет в боковую область ("gutter") вдоль одного из четырёх краёв текстовой области — классическое применение: колонка с номерами строк слева от кода в редакторе. `win` определяет, с какой стороны (`GTK_TEXT_WINDOW_LEFT`, `_RIGHT`, `_TOP`, `_BOTTOM`).

- `text_view` — виджет.
- `win` — сторона размещения (значение `GtkTextWindowType`).
- `widget` — виджет для этой боковой области.

```nim
# lineNumbersWidget — самостоятельно нарисованный виджет с номерами строк
gtk_text_view_set_gutter(codeEditor, GTK_TEXT_WINDOW_LEFT, lineNumbersWidget)
echo "Колонка с номерами строк добавлена слева от редактора кода"
```

---

### `gtk_text_view_set_extra_menu` / `gtk_text_view_get_extra_menu`

```nim
proc gtk_text_view_set_extra_menu*(text_view: GtkTextView, model: GMenuModel)
proc gtk_text_view_get_extra_menu*(text_view: GtkTextView): GMenuModel
```

**Что делает.** Добавляют дополнительные пункты в стандартное контекстное меню виджета — та же логика, что у `gtk_entry_set_extra_menu`/`gtk_label_set_extra_menu`.

- `text_view` — виджет.
- `model` — дополнительная модель меню.

```nim
# extraMenuModel строится заранее через g_menu_new/g_menu_append
gtk_text_view_set_extra_menu(editor, extraMenuModel)
echo "В контекстное меню редактора добавлены дополнительные пункты"
```

---

### Встраивание виджетов: `add_child_at_anchor` / `add_overlay` / `move_overlay` / `remove`

```nim
proc gtk_text_view_add_child_at_anchor*(text_view: GtkTextView, child: GtkWidget, anchor: GtkTextChildAnchor)
proc gtk_text_view_add_overlay*(text_view: GtkTextView, child: GtkWidget, xpos: gint, ypos: gint)
proc gtk_text_view_move_overlay*(text_view: GtkTextView, child: GtkWidget, xpos: gint, ypos: gint)
proc gtk_text_view_remove*(text_view: GtkTextView, child: GtkWidget)
```

**Что делает.** Два разных способа разместить произвольный виджет поверх/внутри текста. `add_child_at_anchor` встраивает виджет **в поток текста**, в место якоря, ранее созданного через `gtk_text_buffer_create_child_anchor` (раздел I) — виджет ведёт себя как часть текста: сдвигается при редактировании окружающего текста, участвует в переносе строк. `add_overlay`, наоборот, размещает виджет поверх текста в фиксированных пиксельных координатах (`xpos`, `ypos`) относительно буфера — не привязан к конкретному месту в тексте и не сдвигается при редактировании (`move_overlay` меняет координаты уже добавленного оверлея). `remove` убирает виджет, добавленный любым из двух способов.

- `text_view` — виджет.
- `child` — встраиваемый виджет.
- `anchor` (для `add_child_at_anchor`) — якорь, полученный от `gtk_text_buffer_create_child_anchor`.
- `xpos`, `ypos` (для `add_overlay`/`move_overlay`) — координаты в системе буфера.

```nim
var endIter: GtkTextIter
gtk_text_buffer_get_end_iter(buffer, addr endIter)
let anchor = gtk_text_buffer_create_child_anchor(buffer, addr endIter)
let inlineButton = gtk_button_new_with_label("Развернуть")
gtk_text_view_add_child_at_anchor(editor, inlineButton, anchor)
echo "Кнопка встроена прямо в поток текста и будет двигаться вместе с ним"
```

---

### Навигация по визуальным строкам: `forward/backward_display_line` и родственные

```nim
proc gtk_text_view_forward_display_line*(text_view: GtkTextView, iter: ptr GtkTextIter): gboolean
proc gtk_text_view_backward_display_line*(text_view: GtkTextView, iter: ptr GtkTextIter): gboolean
proc gtk_text_view_forward_display_line_end*(text_view: GtkTextView, iter: ptr GtkTextIter): gboolean
proc gtk_text_view_backward_display_line_start*(text_view: GtkTextView, iter: ptr GtkTextIter): gboolean
proc gtk_text_view_starts_display_line*(text_view: GtkTextView, iter: ptr GtkTextIter): gboolean
proc gtk_text_view_move_visually*(text_view: GtkTextView, iter: ptr GtkTextIter, count: gint): gboolean
```

**Что делает.** "Визуальная строка" (display line) — это строка **после** переноса по ширине виджета, в отличие от "логической строки" (строки между символами `\n` в самом тексте, с которыми работают функции `GtkTextBuffer` вроде `get_iter_at_line`). Одна длинная логическая строка с включённым переносом может занимать несколько визуальных строк на экране. Эта группа функций перемещает итератор на одну визуальную строку вперёд/назад (а не на одну логическую), к концу/началу текущей визуальной строки, проверяет, находится ли позиция ровно в начале визуальной строки, и перемещает курсор "визуально" на заданное число позиций (`move_visually` — с учётом двунаправленного текста, RTL/LTR, где визуальный порядок символов может отличаться от логического порядка в памяти). Нужны при реализации клавиш `Стрелка вверх`/`Стрелка вниз`/`Home`/`End` вручную — стандартный `GtkTextView` уже обрабатывает эти клавиши сам, так что напрямую эти функции требуются только при кастомной навигации.

- `text_view` — виджет.
- `iter` — итератор, который будет перемещён.
- `count` (для `move_visually`) — число визуальных позиций для перемещения (может быть отрицательным).

```nim
var iter: GtkTextIter
gtk_text_buffer_get_iter_at_mark(buffer, addr iter, gtk_text_buffer_get_insert(buffer))
discard gtk_text_view_forward_display_line(editor, addr iter)
echo "Итератор перемещён на одну визуальную строку вниз от курсора"
```

---

### `gtk_text_view_get_cursor_locations`

```nim
proc gtk_text_view_get_cursor_locations*(text_view: GtkTextView, iter: ptr GtkTextIter, strong: ptr GdkRectangle, weak: ptr GdkRectangle)
```

**Что делает.** Возвращает пиксельные прямоугольники курсора для заданной позиции — сразу два, "сильный" (strong) и "слабый" (weak) курсор, поскольку в текстах со смешанным направлением письма (например, английский текст с вкраплениями иврита) курсор в точке смены направления визуально должен указывать сразу на два возможных "следующих" места ввода. Для однонаправленного текста (в том числе для русского и английского без RTL-вставок) оба прямоугольника совпадают, и различие не имеет практического значения — достаточно использовать `strong`. Передача `nil` для `iter` означает "текущая позиция курсора".

- `text_view` — виджет.
- `iter` — позиция (либо `nil` для текущей позиции курсора).
- `strong`, `weak` — указатели для результата (любой можно передать как `nil`, если конкретное значение не нужно).

```nim
var cursorRect: GdkRectangle
gtk_text_view_get_cursor_locations(editor, nil, addr cursorRect, nil)
echo "Курсор на экране в координатах буфера: (", cursorRect.x, ", ", cursorRect.y, ")"
```

---

### `gtk_text_view_reset_im_context` / `gtk_text_view_im_context_filter_keypress`

```nim
proc gtk_text_view_reset_im_context*(text_view: GtkTextView)
proc gtk_text_view_im_context_filter_keypress*(text_view: GtkTextView, event: GdkEvent): gboolean
```

**Что делает.** `reset_im_context` — та же логика, что у `gtk_entry_reset_im_context` из справочника по вводу текста: сбрасывает состояние текущего метода ввода (актуально для языков со сложным вводом — китайский, японский, корейский). `im_context_filter_keypress` — низкоуровневая функция, передающая событие нажатия клавиши напрямую методу ввода в обход обычной обработки виджета; используется только при реализации полностью кастомной обработки клавиатурного ввода поверх `GtkTextView`, что выходит за рамки типового использования этого справочника.

- `text_view` — виджет.
- `event` (для `im_context_filter_keypress`) — событие клавиатуры `GdkEvent`.

```nim
gtk_text_view_reset_im_context(editor)
echo "Состояние метода ввода сброшено"
```

---

## Практические рецепты

### Простой многострочный редактор с переносом и отступами

Базовая сборка: `GtkTextView` + буфер + перенос по словам + внутренние поля + прокручиваемый контейнер (см. справочник по базовым элементам — `GtkScrolledWindow` рассматривается отдельно, здесь используется для полноты примера).

```nim
proc buildTextEditor(): GtkTextView =
  result = gtk_text_view_new()
  gtk_text_view_set_wrap_mode(result, PANGO_WRAP_WORD)
  gtk_text_view_set_left_margin(result, 12)
  gtk_text_view_set_right_margin(result, 12)
  gtk_text_view_set_top_margin(result, 8)
  gtk_text_view_set_pixels_below_lines(result, 2)

  let buffer = gtk_text_view_get_buffer(result)
  gtk_text_buffer_set_text(buffer, "Начните печатать здесь...", -1)
  echo "Текстовый редактор с переносом по словам и полями собран"

let editor = buildTextEditor()
```

---

### Подсветка части текста через теги

Создание тега форматирования и его регистрация в таблице тегов буфера, затем применение к диапазону — минимальный пример подсветки синтаксиса.

```nim
proc highlightWord(buffer: GtkTextBuffer, word: string) =
  # tagTable уже содержит тег "highlight", созданный заранее через
  # gtk_text_tag_new("highlight") + настройку свойства "background" + добавление
  # в таблицу тегов буфера (gtk_text_tag_table_add) — эти шаги относятся
  # к API GtkTextTag/GtkTextTagTable и не входят в этот справочник.
  var searchStart: GtkTextIter
  gtk_text_buffer_get_start_iter(buffer, addr searchStart)
  # Поиск подстроки через gtk_text_iter_forward_search — функции GtkTextIter
  # как самостоятельного API рассматриваются в справочнике по поиску в тексте.
  echo "Подсветка слова '", word, "' применена там, где оно найдено"

highlightWord(gtk_text_view_get_buffer(editor), "TODO")
```

---

### Индикатор несохранённых изменений через флаг modified

Заголовок окна автоматически получает маркер несохранённых изменений на основе сигнала `"modified-changed"` буфера.

```nim
proc onModifiedChanged(buffer: GtkTextBuffer, userData: gpointer) {.cdecl.} =
  let window = cast[GtkWindow](userData)
  let baseTitle = "Документ.txt"
  if gtk_text_buffer_get_modified(buffer) != 0.gboolean:
    gtk_window_set_title(window, baseTitle & " •")
  else:
    gtk_window_set_title(window, baseTitle)

let buffer = gtk_text_view_get_buffer(editor)
discard g_signal_connect(buffer, "modified-changed", onModifiedChanged, cast[gpointer](mainWindow))

proc onSaveDocument() =
  # ... запись buffer в файл ...
  gtk_text_buffer_set_modified(buffer, 0.gboolean)
  echo "Документ сохранён — маркер несохранённых изменений в заголовке исчезнет"
```

---

### Поле только для чтения с моноширинным шрифтом (просмотр лога)

Компактный `GtkTextView`, настроенный как просмотрщик лога: без редактирования, с курсором для навигации и копирования, моноширинным шрифтом.

```nim
proc buildLogViewer(): GtkTextView =
  result = gtk_text_view_new()
  gtk_text_view_set_editable(result, 0.gboolean)
  gtk_text_view_set_cursor_visible(result, 1.gboolean)
  gtk_text_view_set_monospace(result, 1.gboolean)
  gtk_text_view_set_wrap_mode(result, PANGO_WRAP_WORD_CHAR)
  echo "Просмотрщик лога собран: только чтение, моноширинный шрифт, курсор для выделения"

proc appendLogLine(viewer: GtkTextView, line: string) =
  let buffer = gtk_text_view_get_buffer(viewer)
  var endIter: GtkTextIter
  gtk_text_buffer_get_end_iter(buffer, addr endIter)
  gtk_text_buffer_insert(buffer, addr endIter, (line & "\n").cstring, -1)
  gtk_text_view_scroll_mark_onscreen(viewer, gtk_text_buffer_get_insert(buffer))

let logViewer = buildLogViewer()
appendLogLine(logViewer, "[12:00:01] Приложение запущено")
appendLogLine(logViewer, "[12:00:02] Подключение к серверу установлено")
```

---

### Группировка правок в одну операцию отмены

Автоматическая замена символов кавычек по всему документу как одна логическая операция для `Ctrl+Z`, а не отдельная запись истории на каждую замену.

```nim
proc replaceStraightQuotesWithCurly(buffer: GtkTextBuffer) =
  gtk_text_buffer_begin_user_action(buffer)
  # Многократные gtk_text_buffer_delete/insert по всему тексту буфера —
  # поиск и замена по содержимому выходит за рамки этого справочника
  # (см. функции GtkTextIter, отвечающие за поиск подстрок).
  gtk_text_buffer_end_user_action(buffer)
  echo "Все замены кавычек сгруппированы в одну операцию отмены"

replaceStraightQuotesWithCurly(gtk_text_view_get_buffer(editor))
echo "Один Ctrl+Z отменит сразу все произведённые замены"
```

---

## Краткая таблица

| Процедура(ы) | Категория | Что делает вкратце |
|---|---|---|
| `gtk_text_buffer_new` | TextBuffer | Создать буфер (с таблицей тегов или без) |
| `gtk_text_buffer_set/get_text`, `get_slice` | TextBuffer | Весь текст буфера / диапазон текста |
| `gtk_text_buffer_insert`, `insert_at_cursor`, `insert_range` | TextBuffer | Вставка текста без затрагивания остального содержимого |
| `gtk_text_buffer_insert/delete_interactive*` | TextBuffer | Вставка/удаление с уважением тегов нередактируемости |
| `gtk_text_buffer_delete`, `backspace` | TextBuffer | Безусловное удаление диапазона / эмуляция Backspace |
| `gtk_text_buffer_get_char_count`, `get_line_count` | TextBuffer | Быстрый подсчёт символов/строк |
| `gtk_text_buffer_get_start/end_iter`, `get_bounds`, `get_iter_at_*` | TextBuffer | Получение итераторов по разным критериям |
| `gtk_text_buffer_create_mark`, `add/move/delete_mark`, `get_mark`, `get_insert`, `get_selection_bound` | TextBuffer | Именованные позиции, "плывущие" вместе с текстом |
| `gtk_text_buffer_place_cursor`, `select_range` | TextBuffer | Программное позиционирование курсора и выделения |
| `gtk_text_buffer_get_selection_bounds`, `get_has_selection`, `delete_selection` | TextBuffer | Работа с текущим выделением |
| `gtk_text_buffer_apply/remove_tag*`, `get_tag_table` | TextBuffer | Форматирование диапазонов текста тегами |
| `gtk_text_buffer_create_child_anchor`, `insert_markup`, `insert_paintable` | TextBuffer | Встраивание виджетов/разметки/изображений в текст |
| `gtk_text_buffer_cut/copy/paste_clipboard` | TextBuffer | Программные вырезать/копировать/вставить |
| `gtk_text_buffer_set/get_modified` | TextBuffer | Флаг несохранённых изменений |
| `gtk_text_buffer_undo/redo`, `get_can_undo/redo`, `set/get_enable_undo`, `begin/end_user_action`, `begin/end_irreversible_action`, `set/get_max_undo_levels` | TextBuffer | Отмена/повтор и группировка операций |
| `gtk_text_view_new`, `_with_buffer` | TextView | Создать виджет отображения текста |
| `gtk_text_view_set/get_buffer` | TextView | Какой буфер отображается |
| `gtk_text_view_set/get_editable` | TextView | Разрешить/запретить редактирование |
| `gtk_text_view_set/get_wrap_mode` | TextView | Режим переноса длинных строк |
| `gtk_text_view_set/get_cursor_visible` | TextView | Видимость мигающего курсора |
| `gtk_text_view_set/get_monospace` | TextView | Моноширинный шрифт |
| `gtk_text_view_set/get_left/right/top/bottom_margin`, `set/get_indent` | TextView | Внутренние отступы текста и абзацев |
| `gtk_text_view_set/get_pixels_above/below_lines`, `pixels_inside_wrap` | TextView | Межстрочный интервал |
| `gtk_text_view_set/get_justification` | TextView | Выравнивание строк текста |
| `gtk_text_view_set/get_tabs` | TextView | Позиции табуляции |
| `gtk_text_view_set/get_accepts_tab` | TextView | Tab вставляет символ или передаёт фокус дальше |
| `gtk_text_view_set/get_overwrite` | TextView | Режим вставки/замены символов |
| `gtk_text_view_set/get_input_purpose`, `set/get_input_hints` | TextView | Назначение для экранной клавиатуры |
| `gtk_text_view_scroll_to_mark`, `scroll_to_iter`, `scroll_mark_onscreen` | TextView | Прокрутка к позиции в тексте |
| `gtk_text_view_get_iter_location`, `get_iter_at_location/position`, `get_line_at_y`, `get_line_yrange`, `get_visible_rect`, `*_to_*_coords` | TextView | Преобразование между текстовыми позициями и пикселями |
| `gtk_text_view_set/get_gutter` | TextView | Боковая область (например, номера строк) |
| `gtk_text_view_set/get_extra_menu` | TextView | Доп. пункты в контекстном меню |
| `gtk_text_view_add_child_at_anchor`, `add/move_overlay`, `remove` | TextView | Встраивание произвольных виджетов в текст/поверх текста |
| `gtk_text_view_forward/backward_display_line*`, `starts_display_line`, `move_visually` | TextView | Навигация по визуальным (не логическим) строкам |
| `gtk_text_view_get_cursor_locations` | TextView | Пиксельные координаты курсора (с учётом RTL/LTR) |
| `gtk_text_view_reset_im_context`, `im_context_filter_keypress` | TextView | Низкоуровневая работа с методом ввода |

---

## Сводка: какую процедуру выбрать

- **Однострочный ввод** → справочник по вводу текста (`GtkEntry`/`GtkPasswordEntry`/`GtkSearchEntry`). **Многострочный текст, код, документ** → этот справочник (`GtkTextView`/`GtkTextBuffer`).
- **Изменить сам текст, форматирование, найти позицию** → функции `GtkTextBuffer` (раздел I). **Изменить, как текст выглядит на экране и ведёт себя при вводе** (перенос, отступы, шрифт, редактируемость) → функции `GtkTextView` (раздел II).
- **Запомнить место в тексте, которое должно "пережить" последующее редактирование** (например, положение курсора до и после длинной программной вставки) → маркер (`GtkTextMark` через `gtk_text_buffer_create_mark`), а не сохранённая копия `GtkTextIter` — итератор становится некорректным сразу после любого изменения текста.
- **Показать в интерфейсе многострочный текст только для чтения, но с возможностью выделения и копирования** → `GtkTextView` с `gtk_text_view_set_editable(view, 0.gboolean)`, а не `GtkLabel` — даёт перенос строк, прокрутку и полноценное выделение "бесплатно"; `GtkLabel` больше подходит для коротких надписей фиксированного размера.
- **Индикатор "документ изменён"** → сигнал `"modified-changed"` буфера плюс `gtk_text_buffer_get_modified`, не забывая вручную сбрасывать флаг через `set_modified(buffer, 0.gboolean)` после сохранения — GTK не знает, что данные записаны во внешний файл.
- **Несколько последовательных программных правок должны отменяться одним Ctrl+Z** → обернуть их в `gtk_text_buffer_begin_user_action`/`end_user_action`, а не полагаться на то, что GTK сама угадает, какие правки логически связаны.
- **Программная модификация текста не должна попадать в историю отмены вообще** (например, загрузка нового документа в буфер) → `gtk_text_buffer_begin_irreversible_action`/`end_irreversible_action`.
- **Встроить виджет (кнопку, изображение) прямо в текст, чтобы он двигался вместе с окружающим текстом** → якорь через `gtk_text_buffer_create_child_anchor` + `gtk_text_view_add_child_at_anchor`. **Разместить виджет поверх текста в фиксированных координатах, независимо от редактирования** → `gtk_text_view_add_overlay`.
- **Обработать клик мыши по конкретному месту текста** → `gtk_text_view_get_iter_at_location`/`get_iter_at_position`, а не пытаться вычислять текстовую позицию по пиксельным координатам вручную.
