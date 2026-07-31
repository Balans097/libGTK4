# GTK4 (text formatting & navigation: GtkTextTag / GtkTextMark / GtkTextIter) — справочник модуля

> **Импорт:** `import libGTK4`
> **Область применения:** углублённая работа с многострочным текстом — управление объектами тегов форматирования и таблицей тегов, дополнительные свойства маркеров, и полный API навигации/анализа позиции `GtkTextIter`. Шестнадцатая часть серии справочников по обёртке; напрямую продолжает `gtk4_multiline_text_reference_ru.md` (`GtkTextBuffer`/`GtkTextView`), который уже вводил понятия итератора, маркера и тега на базовом уровне — здесь они разбираются подробно.

Этот справочник — расширение, а не замена: применение тегов к тексту (`gtk_text_buffer_apply_tag`) и базовое использование маркеров (`gtk_text_buffer_create_mark`) уже были в предыдущем справочнике. Здесь — как создавать сами объекты тегов с конкретными визуальными свойствами, дополнительные свойства маркеров, и как перемещать/анализировать `GtkTextIter` на уровне символов, слов, предложений и визуальных строк.

---

## Оглавление

I. [GtkTextTag и GtkTextTagTable](#gtktexttag-и-gtktexttagtable)
&nbsp;&nbsp;1. [`gtk_text_tag_new`](#gtk_text_tag_new)
&nbsp;&nbsp;2. [`gtk_text_tag_set/get_priority`](#gtk_text_tag_setget_priority)
&nbsp;&nbsp;3. [`gtk_text_tag_table_new` / `add` / `remove` / `lookup` / `get_size`](#gtk_text_tag_table_new--add--remove--lookup--get_size)

II. [GtkTextMark (дополнительные свойства)](#gtktextmark-дополнительные-свойства)
&nbsp;&nbsp;1. [`gtk_text_mark_new`](#gtk_text_mark_new)
&nbsp;&nbsp;2. [`gtk_text_mark_set/get_visible`](#gtk_text_mark_setget_visible)
&nbsp;&nbsp;3. [`gtk_text_mark_get_deleted` / `get_name` / `get_buffer` / `get_left_gravity`](#gtk_text_mark_get_deleted--get_name--get_buffer--get_left_gravity)

III. [GtkTextIter: позиция и извлечение текста](#gtktextiter-позиция-и-извлечение-текста)
&nbsp;&nbsp;1. [Запрос позиции: `get_offset`, `get_line` и родственные](#запрос-позиции-get_offset-get_line-и-родственные)
&nbsp;&nbsp;2. [Извлечение содержимого: `get_char`, `get_slice`, `get_text` и видимые варианты](#извлечение-содержимого-get_char-get_slice-get_text-и-видимые-варианты)
&nbsp;&nbsp;3. [Абсолютное позиционирование: `set_offset`, `set_line` и родственные](#абсолютное-позиционирование-set_offset-set_line-и-родственные)

IV. [GtkTextIter: перемещение](#gtktextiter-перемещение)
&nbsp;&nbsp;1. [По символам и строкам: `forward/backward_char(s)`, `_line(s)`](#по-символам-и-строкам-forwardbackward_chars-_lines)
&nbsp;&nbsp;2. [По словам и предложениям](#по-словам-и-предложениям)
&nbsp;&nbsp;3. [По позициям курсора: `forward/backward_cursor_position(s)`](#по-позициям-курсора-forwardbackward_cursor_positions)
&nbsp;&nbsp;4. [К границам и тегам: `forward_to_end`, `forward_to_line_end`, `forward/backward_to_tag_toggle`](#к-границам-и-тегам-forward_to_end-forward_to_line_end-forwardbackward_to_tag_toggle)
&nbsp;&nbsp;5. [Поиск текста: `forward_search` / `backward_search`](#поиск-текста-forward_search--backward_search)

V. [GtkTextIter: сравнение и проверки границ](#gtktextiter-сравнение-и-проверки-границ)
&nbsp;&nbsp;1. [`gtk_text_iter_equal` / `compare` / `in_range`](#gtk_text_iter_equal--compare--in_range)
&nbsp;&nbsp;2. [Проверки границ слова/строки/предложения](#проверки-границ-словастрокипредложения)
&nbsp;&nbsp;3. [`gtk_text_iter_is_cursor_position`, `get_chars_in_line`, `get_bytes_in_line`, `is_end`, `is_start`, `can_insert`, `editable`](#gtk_text_iter_is_cursor_position-get_chars_in_line-get_bytes_in_line-is_end-is_start-can_insert-editable)

VI. [GtkTextBuffer: дополнительные функции](#gtktextbuffer-дополнительные-функции)
&nbsp;&nbsp;1. [`gtk_text_buffer_create_tag`](#gtk_text_buffer_create_tag)
&nbsp;&nbsp;2. [`gtk_text_buffer_insert_with_tags` / `insert_with_tags_by_name`](#gtk_text_buffer_insert_with_tags--insert_with_tags_by_name)
&nbsp;&nbsp;3. [`gtk_text_buffer_add/remove_selection_clipboard`](#gtk_text_buffer_addremove_selection_clipboard)

VII. [Практические рецепты](#практические-рецепты)
&nbsp;&nbsp;1. [Набор тегов форматирования для простого редактора (жирный, курсив, заголовок)](#набор-тегов-форматирования-для-простого-редактора-жирный-курсив-заголовок)
&nbsp;&nbsp;2. [Поиск и подсветка всех вхождений подстроки](#поиск-и-подсветка-всех-вхождений-подстроки)
&nbsp;&nbsp;3. [Выделение слова под курсором двойным кликом](#выделение-слова-под-курсором-двойным-кликом)
&nbsp;&nbsp;4. [Подсчёт слов в документе](#подсчёт-слов-в-документе)
&nbsp;&nbsp;5. [Приоритет тегов при перекрытии (выделение поверх подсветки синтаксиса)](#приоритет-тегов-при-перекрытии-выделение-поверх-подсветки-синтаксиса)

VIII. [Краткая таблица](#краткая-таблица)

IX. [Сводка: какую процедуру выбрать](#сводка-какую-процедуру-выбрать)

---

## GtkTextTag и GtkTextTagTable

`GtkTextTag` — именованный набор визуальных свойств (цвет, шрифт, отступы и т.д.), задаваемых не отдельными функциями этой обёртки, а универсальным механизмом свойств GObject — `g_object_set` (справочник по рисованию, стилям и GLib-утилитам), поскольку у `GtkTextTag` десятки возможных свойств (`"foreground"`, `"weight"`, `"strikethrough"`, `"editable"` и т.д.), и заводить для каждого отдельную типобезопасную функцию в этой обёртке избыточно.

### `gtk_text_tag_new`

```nim
proc gtk_text_tag_new*(name: cstring): GtkTextTag
```

**Что делает.** Создаёт объект тега с указанным именем (передача `nil` создаёт анонимный тег, на который затем можно ссылаться только по объекту, не по имени). Само по себе создание тега не применяет никакого форматирования — свойства задаются отдельно через `g_object_set` (см. раздел VII, рецепт «Набор тегов форматирования»), а сам тег должен быть зарегистрирован в таблице тегов буфера (`gtk_text_tag_table_add`, следующий подраздел, либо через укороченную `gtk_text_buffer_create_tag` из раздела VI) прежде, чем его можно будет применить к тексту.

- `name` — имя тега, либо `nil` для анонимного.

```nim
let boldTag = gtk_text_tag_new("bold")
g_object_set(cast[GObject](boldTag), "weight".cstring, 700.cint, nil)  # 700 = PANGO_WEIGHT_BOLD
echo "Тег 'bold' создан с жирным начертанием"
```

---

### `gtk_text_tag_set/get_priority`

```nim
proc gtk_text_tag_set_priority*(tag: GtkTextTag, priority: gint)
proc gtk_text_tag_get_priority*(tag: GtkTextTag): gint
```

**Что делает.** Задают приоритет тега при перекрытии с другими тегами, применёнными к тому же диапазону текста, — при конфликте значений одного и того же визуального свойства (например, два тега оба задают цвет текста) побеждает тег с более высоким приоритетом. Приоритет по умолчанию соответствует порядку добавления тега в таблицу (более поздний добавленный — выше приоритет); явная установка нужна, когда порядок добавления не совпадает с желаемым порядком применения (см. раздел VII, рецепт про приоритет тегов).

- `tag` — тег.
- `priority` — числовой приоритет (больше — выше).

```nim
gtk_text_tag_set_priority(searchHighlightTag, 100)  # выше, чем у тегов подсветки синтаксиса
echo "Подсветка результатов поиска теперь всегда поверх подсветки синтаксиса"
```

---

### `gtk_text_tag_table_new` / `add` / `remove` / `lookup` / `get_size`

```nim
proc gtk_text_tag_table_new*(): GtkTextTagTable
proc gtk_text_tag_table_add*(table: GtkTextTagTable, tag: GtkTextTag): gboolean
proc gtk_text_tag_table_remove*(table: GtkTextTagTable, tag: GtkTextTag)
proc gtk_text_tag_table_lookup*(table: GtkTextTagTable, name: cstring): GtkTextTag
proc gtk_text_tag_table_get_size*(table: GtkTextTagTable): gint
```

**Что делает.** `GtkTextTagTable` — реестр тегов, доступных конкретному буферу (тот же объект, что можно было передать в `gtk_text_buffer_new` из предыдущего справочника, либо получить у уже существующего буфера через `gtk_text_buffer_get_tag_table`). `new` создаёт пустую таблицу (нужно только при ручной сборке — обычно буфер создаёт свою таблицу автоматически). `add` регистрирует тег (возвращает `0.gboolean`, если тег с таким именем уже зарегистрирован — двух тегов с одинаковым именем в одной таблице быть не может). `remove` убирает тег из таблицы. `lookup` находит уже зарегистрированный тег по имени — тот же способ получить объект тега, что использовался неявно в `gtk_text_buffer_apply_tag_by_name` из предыдущего справочника. `get_size` — количество тегов в таблице.

- `table` — таблица тегов.
- `tag` — тег.
- `name` — имя тега (для `lookup`).

```nim
let tagTable = gtk_text_buffer_get_tag_table(buffer)
discard gtk_text_tag_table_add(tagTable, boldTag)
echo "Тег 'bold' зарегистрирован в таблице тегов буфера, всего тегов: ", gtk_text_tag_table_get_size(tagTable)
```

---

## GtkTextMark (дополнительные свойства)

Базовое использование маркеров (`create_mark`, `get_insert`, `get_selection_bound`) уже разобрано в предыдущем справочнике. Здесь — дополнительные свойства самого объекта `GtkTextMark`.

### `gtk_text_mark_new`

```nim
proc gtk_text_mark_new*(name: cstring, leftGravity: gboolean): GtkTextMark
```

**Что делает.** Создаёт объект маркера отдельно от буфера — в отличие от `gtk_text_buffer_create_mark` (предыдущий справочник), которая создаёт маркер и сразу привязывает его к позиции в конкретном буфере, эта функция лишь создаёт "свободный" объект маркера, который затем нужно привязать к буферу через `gtk_text_buffer_add_mark` (предыдущий справочник). Разница чисто в разбиении на шаги — `create_mark` для большинства сценариев короче.

- `name` — имя маркера, либо `nil`.
- `leftGravity` — та же логика "прилипания" при вставке текста, что у `create_mark`.

```nim
let freeMark = gtk_text_mark_new("bookmark-2", 1.gboolean)
echo "Маркер создан отдельно от буфера, ещё не привязан к позиции"
```

---

### `gtk_text_mark_set/get_visible`

```nim
proc gtk_text_mark_set_visible*(mark: GtkTextMark, setting: gboolean)
proc gtk_text_mark_get_visible*(mark: GtkTextMark): gboolean
```

**Что делает.** Показывают/скрывают маркер как видимую вертикальную черту в тексте `GtkTextView` (по умолчанию маркеры невидимы — большинство маркеров используются как чисто программные закладки позиции, без визуального представления). Видимые маркеры используются редко — в первую очередь для отображения позиции других участников совместного редактирования документа.

- `mark` — маркер.
- `setting` — `1.gboolean`, чтобы сделать маркер видимым.

```nim
gtk_text_mark_set_visible(collaboratorCursorMark, 1.gboolean)
echo "Позиция курсора другого участника теперь видна как вертикальная черта в тексте"
```

---

### `gtk_text_mark_get_deleted` / `get_name` / `get_buffer` / `get_left_gravity`

```nim
proc gtk_text_mark_get_deleted*(mark: GtkTextMark): gboolean
proc gtk_text_mark_get_name*(mark: GtkTextMark): cstring
proc gtk_text_mark_get_buffer*(mark: GtkTextMark): GtkTextBuffer
proc gtk_text_mark_get_left_gravity*(mark: GtkTextMark): gboolean
```

**Что делает.** `get_deleted` сообщает, был ли маркер удалён из буфера (через `gtk_text_buffer_delete_mark`, предыдущий справочник) — после удаления объект маркера может ещё существовать в памяти (если на него остались ссылки), но больше не привязан ни к какой позиции; проверка полезна перед попыткой использовать сохранённый где-то в коде маркер, который мог быть удалён independently. `get_name`/`get_buffer` — обратные операции: имя маркера и буфер, к которому он привязан (`get_buffer` вернёт `nil`, если маркер уже удалён). `get_left_gravity` читает параметр, заданный при создании через `create_mark`/`gtk_text_mark_new`.

- `mark` — маркер.

```nim
if gtk_text_mark_get_deleted(savedBookmark) != 0.gboolean:
  echo "Сохранённая закладка больше не существует в буфере"
else:
  echo "Закладка '", $gtk_text_mark_get_name(savedBookmark), "' всё ещё действительна"
```

---

## GtkTextIter: позиция и извлечение текста

### Запрос позиции: `get_offset`, `get_line` и родственные

```nim
proc gtk_text_iter_get_offset*(iter: ptr GtkTextIter): gint
proc gtk_text_iter_get_line*(iter: ptr GtkTextIter): gint
proc gtk_text_iter_get_line_offset*(iter: ptr GtkTextIter): gint
proc gtk_text_iter_get_line_index*(iter: ptr GtkTextIter): gint
proc gtk_text_iter_get_visible_line_index*(iter: ptr GtkTextIter): gint
proc gtk_text_iter_get_visible_line_offset*(iter: ptr GtkTextIter): gint
```

**Что делает.** Читают текущую позицию итератора в разных единицах измерения. `get_offset` — абсолютный номер символа от начала текста. `get_line` — номер логической строки (от `0`). `get_line_offset`/`get_line_index` — позиция внутри строки в символах и в байтах UTF-8. `get_visible_line_index`/`_offset` — та же пара, но с исключением текста, скрытого тегами невидимости.

- `iter` — итератор.

```nim
echo "Позиция: строка ", gtk_text_iter_get_line(myIter), ", символ ", gtk_text_iter_get_line_offset(myIter), " от начала строки"
```

---

### Извлечение содержимого: `get_char`, `get_slice`, `get_text` и видимые варианты

```nim
proc gtk_text_iter_get_char*(iter: ptr GtkTextIter): gunichar
proc gtk_text_iter_get_slice*(start: ptr GtkTextIter, `end`: ptr GtkTextIter): cstring
proc gtk_text_iter_get_text*(start: ptr GtkTextIter, `end`: ptr GtkTextIter): cstring
proc gtk_text_iter_get_visible_slice*(start: ptr GtkTextIter, `end`: ptr GtkTextIter): cstring
proc gtk_text_iter_get_visible_text*(start: ptr GtkTextIter, `end`: ptr GtkTextIter): cstring
```

**Что делает.** `get_char` возвращает единственный символ Unicode в текущей позиции. `get_slice`/`get_text` — те же операции, что вызывались как методы буфера в предыдущем справочнике, но здесь как самостоятельные функции, принимающие напрямую два итератора. `get_visible_slice`/`get_visible_text` — то же самое, но всегда исключают текст, скрытый тегами невидимости.

- `iter` — итератор (для `get_char`).
- `start`, `end` — границы диапазона.

```nim
let firstChar = gtk_text_iter_get_char(startIter)
echo "Код первого символа диапазона: ", firstChar
```

---

### Абсолютное позиционирование: `set_offset`, `set_line` и родственные

```nim
proc gtk_text_iter_set_offset*(iter: ptr GtkTextIter, charOffset: gint)
proc gtk_text_iter_set_line*(iter: ptr GtkTextIter, lineNumber: gint)
proc gtk_text_iter_set_line_offset*(iter: ptr GtkTextIter, charOnLine: gint)
proc gtk_text_iter_set_line_index*(iter: ptr GtkTextIter, byteOnLine: gint)
proc gtk_text_iter_set_visible_line_index*(iter: ptr GtkTextIter, byteOnLine: gint)
proc gtk_text_iter_set_visible_line_offset*(iter: ptr GtkTextIter, charOnLine: gint)
```

**Что делает.** Перемещают уже существующий итератор на абсолютную позицию — та же логика, что у `gtk_text_buffer_get_iter_at_offset`/`get_iter_at_line_offset` из предыдущего справочника, но применяется к уже полученному итератору (переиспользование одной переменной вместо повторного получения нового итератора от буфера).

- `iter` — итератор, который будет перемещён.
- `charOffset`, `lineNumber`, `charOnLine`, `byteOnLine` — целевая позиция.

```nim
gtk_text_iter_set_line(myIter, 0)
gtk_text_iter_set_line_offset(myIter, 0)
echo "Итератор перемещён на начало первой строки"
```

---

## GtkTextIter: перемещение

### По символам и строкам: `forward/backward_char(s)`, `_line(s)`

```nim
proc gtk_text_iter_forward_char*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_backward_char*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_forward_chars*(iter: ptr GtkTextIter, count: gint): gboolean
proc gtk_text_iter_backward_chars*(iter: ptr GtkTextIter, count: gint): gboolean
proc gtk_text_iter_forward_line*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_backward_line*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_forward_lines*(iter: ptr GtkTextIter, count: gint): gboolean
proc gtk_text_iter_backward_lines*(iter: ptr GtkTextIter, count: gint): gboolean
```

**Что делает.** Базовое пошаговое перемещение итератора — на один символ/строку вперёд-назад, либо сразу на заданное число символов/строк через варианты с `count`. Все возвращают `gboolean`, удалось ли переместиться на полное запрошенное расстояние (`0.gboolean`, если итератор упёрся в начало/конец текста раньше). Перемещение по строке — на начало следующей/предыдущей логической строки (не визуальной — см. `gtk_text_view_forward_display_line` в предыдущем справочнике для перемещения по визуальным строкам с учётом переноса).

- `iter` — итератор, который будет перемещён.
- `count` — количество позиций (для вариантов во множественном числе).

```nim
discard gtk_text_iter_forward_chars(myIter, 5)
echo "Итератор сдвинут на 5 символов вперёд"
```

---

### По словам и предложениям

```nim
proc gtk_text_iter_forward_word_end*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_backward_word_start*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_forward_word_ends*(iter: ptr GtkTextIter, count: gint): gboolean
proc gtk_text_iter_backward_word_starts*(iter: ptr GtkTextIter, count: gint): gboolean
proc gtk_text_iter_forward_visible_word_end*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_backward_visible_word_start*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_forward_visible_word_ends*(iter: ptr GtkTextIter, count: gint): gboolean
proc gtk_text_iter_backward_visible_word_starts*(iter: ptr GtkTextIter, count: gint): gboolean
proc gtk_text_iter_forward_sentence_end*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_backward_sentence_start*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_forward_sentence_ends*(iter: ptr GtkTextIter, count: gint): gboolean
proc gtk_text_iter_backward_sentence_starts*(iter: ptr GtkTextIter, count: gint): gboolean
```

**Что делает.** Перемещают итератор к границе слова или предложения — та же логика, что реализует двойной/тройной клик мыши для выделения слова/предложения в текстовом редакторе (см. раздел VII, «Выделение слова под курсором»). Обратите внимание на асимметрию названий: вперёд движение идёт к **концу** слова/предложения (`forward_word_end`), назад — к его **началу** (`backward_word_start`) — то есть обе функции всегда движутся "наружу" от текущего слова/предложения, а не симметрично к противоположной границе того же слова. Границы слова определяются правилами Unicode (учитывают знаки препинания, пробелы) — то же, что использует GTK для определения "слова" при двойном клике. `_visible_`-варианты исключают текст, скрытый тегами невидимости, при подсчёте границ.

- `iter` — итератор, который будет перемещён.
- `count` — количество границ (для вариантов во множественном числе).

```nim
discard gtk_text_iter_backward_word_start(myIter)
discard gtk_text_iter_forward_word_end(endIter)
echo "Итераторы теперь охватывают слово, в котором изначально находились"
```

---

### По позициям курсора: `forward/backward_cursor_position(s)`

```nim
proc gtk_text_iter_forward_cursor_position*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_backward_cursor_position*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_forward_cursor_positions*(iter: ptr GtkTextIter, count: gint): gboolean
proc gtk_text_iter_backward_cursor_positions*(iter: ptr GtkTextIter, count: gint): gboolean
proc gtk_text_iter_forward_visible_cursor_position*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_backward_visible_cursor_position*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_forward_visible_cursor_positions*(iter: ptr GtkTextIter, count: gint): gboolean
proc gtk_text_iter_backward_visible_cursor_positions*(iter: ptr GtkTextIter, count: gint): gboolean
```

**Что делает.** Перемещают итератор на одну допустимую позицию текстового курсора — не то же самое, что перемещение на один символ (`forward_char`): некоторые последовательности символов Unicode (составные эмодзи, комбинируемые диакритические знаки) занимают несколько кодовых точек, но представляют собой одну позицию, между которыми курсор не может остановиться. Именно эта группа функций лежит в основе того, как `Стрелка влево`/`Стрелка вправо` перемещают курсор в `GtkTextView` на практике (в отличие от `forward_char`, который сдвинулся бы посреди составного символа).

- `iter` — итератор, который будет перемещён.
- `count` — количество позиций.

```nim
discard gtk_text_iter_forward_cursor_position(cursorIter)
echo "Итератор сдвинут на одну допустимую позицию курсора вперёд"
```

---

### К границам и тегам: `forward_to_end`, `forward_to_line_end`, `forward/backward_to_tag_toggle`

```nim
proc gtk_text_iter_forward_to_end*(iter: ptr GtkTextIter)
proc gtk_text_iter_forward_to_line_end*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_forward_to_tag_toggle*(iter: ptr GtkTextIter, tag: GtkTextTag): gboolean
proc gtk_text_iter_backward_to_tag_toggle*(iter: ptr GtkTextIter, tag: GtkTextTag): gboolean
```

**Что делает.** `forward_to_end` перемещает итератор сразу в самый конец текста буфера (без возвращаемого значения — операция всегда успешна). `forward_to_line_end` — до конца текущей логической строки. `forward_to_tag_toggle`/`backward_to_tag_toggle` перемещают итератор к ближайшей точке, где применение указанного тега "переключается" (начинается либо заканчивается) — способ быстро найти границы отформатированного тегом диапазона без последовательного посимвольного сканирования; передача `nil` вместо `tag` находит переключение **любого** тега, а не конкретного.

- `iter` — итератор, который будет перемещён.
- `tag` — тег, чьё переключение ищется, либо `nil` для любого тега.

```nim
discard gtk_text_iter_forward_to_tag_toggle(myIter, boldTag)
echo "Итератор перемещён к концу (или началу) ближайшего форматированного жирным диапазона"
```

---

### Поиск текста: `forward_search` / `backward_search`

```nim
proc gtk_text_iter_forward_search*(iter: ptr GtkTextIter, str: cstring, flags: gint, matchStart: ptr GtkTextIter, matchEnd: ptr GtkTextIter, limit: ptr GtkTextIter): gboolean
proc gtk_text_iter_backward_search*(iter: ptr GtkTextIter, str: cstring, flags: gint, matchStart: ptr GtkTextIter, matchEnd: ptr GtkTextIter, limit: ptr GtkTextIter): gboolean
```

**Что делает.** Ищут подстроку `str` в тексте, начиная с позиции `iter`, в соответствующем направлении, — заполняют `matchStart`/`matchEnd` границами найденного совпадения (можно передать `nil` для любого из них, если конкретная граница не нужна). `flags` — битовая маска режимов поиска: `GTK_TEXT_SEARCH_VISIBLE_ONLY = 1` (игнорировать скрытый тегами текст), `_TEXT_ONLY = 2` (игнорировать нетекстовые элементы вроде вставленных изображений при подсчёте позиций), `_CASE_INSENSITIVE = 4` (без учёта регистра). `limit` — необязательная граница, до которой производится поиск (передача `nil` — искать до конца/начала всего текста).

- `iter` — начальная позиция поиска.
- `str` — искомая подстрока.
- `flags` — битовая маска режимов поиска (именованных констант в этой обёртке нет).
- `matchStart`, `matchEnd` — указатели для границ найденного совпадения, любой может быть `nil`.
- `limit` — граница поиска, либо `nil`.

```nim
var searchStart: GtkTextIter
gtk_text_buffer_get_start_iter(buffer, addr searchStart)
var matchStart, matchEnd: GtkTextIter
if gtk_text_iter_forward_search(addr searchStart, "TODO".cstring, 4, addr matchStart, addr matchEnd, nil) != 0.gboolean:
  # 4 = GTK_TEXT_SEARCH_CASE_INSENSITIVE
  echo "Найдено первое вхождение 'TODO' без учёта регистра"
```

---

## GtkTextIter: сравнение и проверки границ

### `gtk_text_iter_equal` / `compare` / `in_range`

```nim
proc gtk_text_iter_equal*(lhs: ptr GtkTextIter, rhs: ptr GtkTextIter): gboolean
proc gtk_text_iter_compare*(lhs: ptr GtkTextIter, rhs: ptr GtkTextIter): gint
proc gtk_text_iter_in_range*(iter: ptr GtkTextIter, start: ptr GtkTextIter, `end`: ptr GtkTextIter): gboolean
```

**Что делает.** `equal` проверяет, указывают ли два итератора на одну и ту же позицию (не путать со сравнением адресов самих Nim-переменных `GtkTextIter` — это сравнение логической текстовой позиции). `compare` — трёхзначное сравнение позиций (отрицательное число, `0`, положительное — та же семантика, что у `g_strcmp0` из справочника по GLib-утилитам, но для текстовых позиций, а не строк). `in_range` проверяет, находится ли позиция `iter` внутри диапазона `[start, end)`.

- `lhs`, `rhs` — сравниваемые итераторы.
- `iter` — проверяемая позиция.
- `start`, `end` — границы диапазона.

```nim
if gtk_text_iter_compare(cursorIter, selectionEndIter) < 0:
  echo "Курсор находится раньше конца выделения"
```

---

### Проверки границ слова/строки/предложения

```nim
proc gtk_text_iter_starts_word*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_ends_word*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_inside_word*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_starts_line*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_ends_line*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_starts_sentence*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_ends_sentence*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_inside_sentence*(iter: ptr GtkTextIter): gboolean
```

**Что делает.** Проверяют, находится ли текущая позиция итератора ровно на границе (начало/конец) или внутри слова/предложения/строки, без изменения самого итератора, — используются вместе с функциями перемещения из раздела IV для условной логики (например, "если курсор не в начале слова, сначала переместиться в начало", прежде чем выделять слово целиком).

- `iter` — итератор.

```nim
if gtk_text_iter_starts_word(cursorIter) == 0.gboolean:
  discard gtk_text_iter_backward_word_start(cursorIter)
echo "Итератор гарантированно находится в начале слова"
```

---

### `gtk_text_iter_is_cursor_position`, `get_chars_in_line`, `get_bytes_in_line`, `is_end`, `is_start`, `can_insert`, `editable`

```nim
proc gtk_text_iter_is_cursor_position*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_get_chars_in_line*(iter: ptr GtkTextIter): gint
proc gtk_text_iter_get_bytes_in_line*(iter: ptr GtkTextIter): gint
proc gtk_text_iter_is_end*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_is_start*(iter: ptr GtkTextIter): gboolean
proc gtk_text_iter_can_insert*(iter: ptr GtkTextIter, defaultEditability: gboolean): gboolean
proc gtk_text_iter_editable*(iter: ptr GtkTextIter, defaultSetting: gboolean): gboolean
```

**Что делает.** `is_cursor_position` — допустима ли эта позиция как позиция курсора (см. раздел IV, "по позициям курсора" — та же логика составных символов). `get_chars_in_line`/`get_bytes_in_line` — длина текущей логической строки (в символах и байтах соответственно), не всего текста. `is_end`/`is_start` — находится ли итератор точно в самом начале/конце всего текста буфера. `can_insert`/`editable` — можно ли вставить текст в этой позиции / является ли позиция редактируемой с учётом тегов нередактируемости (та же логика уважения тегов, что у `_interactive`-операций буфера из предыдущего справочника) — `defaultEditability`/`defaultSetting` определяют результат для текста без явного тега на этот счёт.

- `iter` — итератор.
- `defaultEditability`, `defaultSetting` — `1.gboolean`, если текст без тега считается редактируемым.

```nim
echo "Длина текущей строки: ", gtk_text_iter_get_chars_in_line(myIter), " символов"
if gtk_text_iter_can_insert(myIter, 1.gboolean) != 0.gboolean:
  echo "В эту позицию можно вставить текст"
```

---

## GtkTextBuffer: дополнительные функции

### `gtk_text_buffer_create_tag`

```nim
proc gtk_text_buffer_create_tag*(buffer: GtkTextBuffer, tagName: cstring, firstPropertyName: cstring): GtkTextTag {.varargs.}
```

**Что делает.** Укороченная форма, объединяющая `gtk_text_tag_new` + установку свойств через `g_object_set` + `gtk_text_tag_table_add` в один вызов — создаёт тег, сразу задаёт его свойства (вариативный список чередующихся пар "имя свойства"/"значение", завершённый `nil` — тот же протокол, что у `g_object_set`) и регистрирует в таблице тегов буфера. Предпочтительный способ создания тегов в прикладном коде вместо трёх раздельных шагов из раздела I.

- `buffer` — буфер.
- `tagName` — имя тега, либо `nil`.
- `firstPropertyName`, далее пары (имя свойства, значение), завершённые `nil`.

```nim
let highlightTag = gtk_text_buffer_create_tag(buffer, "highlight".cstring,
                                                "background".cstring, "yellow".cstring, nil)
echo "Тег подсветки жёлтым создан и сразу зарегистрирован одним вызовом"
```

---

### `gtk_text_buffer_insert_with_tags` / `insert_with_tags_by_name`

```nim
proc gtk_text_buffer_insert_with_tags*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, text: cstring, len: gint, firstTag: GtkTextTag) {.varargs.}
proc gtk_text_buffer_insert_with_tags_by_name*(buffer: GtkTextBuffer, iter: ptr GtkTextIter, text: cstring, len: gint, firstTagName: cstring) {.varargs.}
```

**Что делает.** Вставляют текст и сразу применяют к нему один или несколько тегов за один вызов — короче, чем последовательность `gtk_text_buffer_insert` + `gtk_text_buffer_apply_tag` для каждого тега отдельно. Список тегов передаётся вариативным списком объектов тегов (`insert_with_tags`) или их имён (`insert_with_tags_by_name`), завершённым `nil`.

- `buffer` — буфер.
- `iter` — позиция вставки.
- `text` — вставляемый текст.
- `len` — длина в байтах, либо `-1`.
- `firstTag`/`firstTagName`, далее теги/имена тегов, завершённые `nil`.

```nim
var endIter: GtkTextIter
gtk_text_buffer_get_end_iter(buffer, addr endIter)
gtk_text_buffer_insert_with_tags_by_name(buffer, addr endIter, "Важное замечание".cstring, -1, "bold".cstring, nil)
echo "Текст вставлен сразу с применённым тегом жирного начертания"
```

---

### `gtk_text_buffer_add/remove_selection_clipboard`

```nim
proc gtk_text_buffer_add_selection_clipboard*(buffer: GtkTextBuffer, clipboard: GdkClipboard)
proc gtk_text_buffer_remove_selection_clipboard*(buffer: GtkTextBuffer, clipboard: GdkClipboard)
```

**Что делает.** Связывают буфер с системным буфером обмена "первичного выделения" (X11-специфичная концепция, отдельная от обычного `Ctrl+C`/`Ctrl+V` буфера обмена — текст, выделенный мышью, автоматически становится доступен для вставки средним кликом мыши, без явного копирования) — на платформах без этой концепции (Windows) эффекта не имеет. `GtkTextView`, как правило, уже настраивает это автоматически для своего буфера; явный вызов нужен только при нестандартном использовании буфера без привязанного `GtkTextView`.

- `buffer` — буфер.
- `clipboard` — объект буфера обмена (из справочника по диалогам и медиа, `gdk_display_get_clipboard`).

```nim
# primarySelectionClipboard получается отдельным вызовом, специфичным для первичного выделения,
# не входящим в этот справочник
gtk_text_buffer_add_selection_clipboard(buffer, primarySelectionClipboard)
echo "Буфер связан с первичным выделением X11 (на платформах, где оно есть)"
```

---

## Практические рецепты

### Набор тегов форматирования для простого редактора (жирный, курсив, заголовок)

```nim
proc setupFormattingTags(buffer: GtkTextBuffer) =
  discard gtk_text_buffer_create_tag(buffer, "bold".cstring, "weight".cstring, 700.cint, nil)
  discard gtk_text_buffer_create_tag(buffer, "italic".cstring, "style".cstring, 2.cint, nil)
  discard gtk_text_buffer_create_tag(buffer, "heading".cstring,
                                      "weight".cstring, 700.cint,
                                      "scale".cstring, 1.5.cdouble, nil)
  echo "Теги 'bold', 'italic', 'heading' готовы к использованию"

proc applyBoldToSelection(buffer: GtkTextBuffer) =
  var start, stop: GtkTextIter
  if gtk_text_buffer_get_selection_bounds(buffer, addr start, addr stop) != 0.gboolean:
    gtk_text_buffer_apply_tag_by_name(buffer, "bold".cstring, addr start, addr stop)
    echo "Выделенный текст сделан жирным"

setupFormattingTags(buffer)
```

---

### Поиск и подсветка всех вхождений подстроки

```nim
proc highlightAllOccurrences(buffer: GtkTextBuffer, query: string) =
  discard gtk_text_buffer_create_tag(buffer, "search-highlight".cstring,
                                      "background".cstring, "yellow".cstring, nil)
  var searchPos: GtkTextIter
  gtk_text_buffer_get_start_iter(buffer, addr searchPos)

  var foundCount = 0
  while true:
    var matchStart, matchEnd: GtkTextIter
    let found = gtk_text_iter_forward_search(addr searchPos, query.cstring, 4,
                                              addr matchStart, addr matchEnd, nil)
    if found == 0.gboolean:
      break
    gtk_text_buffer_apply_tag_by_name(buffer, "search-highlight".cstring, addr matchStart, addr matchEnd)
    foundCount += 1
    searchPos = matchEnd

  echo "Найдено и подсвечено вхождений: ", foundCount

highlightAllOccurrences(buffer, "TODO")
```

---

### Выделение слова под курсором двойным кликом

```nim
proc onDoubleClick(gesture: GtkGestureClick, nPress: gint, x: gdouble, y: gdouble, userData: gpointer) {.cdecl.} =
  if nPress != 2:
    return
  let textView = cast[GtkTextView](userData)
  let buffer = gtk_text_view_get_buffer(textView)

  var wordStart, wordEnd, clickIter: GtkTextIter
  # позиция клика получается через gtk_text_view_get_iter_at_position (см. многострочный текст)
  wordStart = clickIter
  wordEnd = clickIter

  if gtk_text_iter_starts_word(addr wordStart) == 0.gboolean:
    discard gtk_text_iter_backward_word_start(addr wordStart)
  if gtk_text_iter_ends_word(addr wordEnd) == 0.gboolean:
    discard gtk_text_iter_forward_word_end(addr wordEnd)
  gtk_text_buffer_select_range(buffer, addr wordEnd, addr wordStart)
  echo "Слово под курсором выделено целиком по двойному клику"
```

---

### Подсчёт слов в документе

```nim
proc countWords(buffer: GtkTextBuffer): int =
  var iter: GtkTextIter
  gtk_text_buffer_get_start_iter(buffer, addr iter)

  while gtk_text_iter_is_end(addr iter) == 0.gboolean:
    if gtk_text_iter_forward_word_end(addr iter) == 0.gboolean:
      break
    result += 1

echo "Количество слов в документе: ", countWords(buffer)
```

---

### Приоритет тегов при перекрытии (выделение поверх подсветки синтаксиса)

```nim
proc setupLayeredTags(buffer: GtkTextBuffer) =
  let syntaxTag = gtk_text_buffer_create_tag(buffer, "syntax-keyword".cstring,
                                              "foreground".cstring, "blue".cstring, nil)
  let searchTag = gtk_text_buffer_create_tag(buffer, "search-match".cstring,
                                              "background".cstring, "yellow".cstring, nil)

  gtk_text_tag_set_priority(searchTag, gtk_text_tag_get_priority(syntaxTag) + 1)
  echo "Тег подсветки поиска гарантированно виден поверх подсветки синтаксиса"

setupLayeredTags(buffer)
```

---

## Краткая таблица

| Процедура(ы) | Категория | Что делает вкратце |
|---|---|---|
| `gtk_text_tag_new` | TextTag | Создать объект тега (свойства — через g_object_set) |
| `gtk_text_tag_set/get_priority` | TextTag | Приоритет при перекрытии с другими тегами |
| `gtk_text_tag_table_new`, `add`, `remove`, `lookup`, `get_size` | TextTagTable | Реестр тегов буфера |
| `gtk_text_mark_new` | TextMark | Создать маркер отдельно от буфера |
| `gtk_text_mark_set/get_visible` | TextMark | Видимая вертикальная черта маркера |
| `gtk_text_mark_get_deleted`, `get_name`, `get_buffer`, `get_left_gravity` | TextMark | Состояние и свойства маркера |
| `gtk_text_iter_get_offset/line/line_offset/line_index/visible_*` | TextIter | Текущая позиция в разных единицах |
| `gtk_text_iter_get_char/slice/text/visible_slice/visible_text` | TextIter | Извлечение символа/текста в диапазоне |
| `gtk_text_iter_set_offset/line/line_offset/line_index/visible_*` | TextIter | Абсолютное позиционирование |
| `gtk_text_iter_forward/backward_char(s)`, `_line(s)` | TextIter | Пошаговое перемещение |
| `gtk_text_iter_forward/backward_word_*`, `_sentence_*` | TextIter | Перемещение по словам/предложениям |
| `gtk_text_iter_forward/backward_cursor_position(s)` | TextIter | Перемещение по допустимым позициям курсора |
| `gtk_text_iter_forward_to_end/line_end`, `forward/backward_to_tag_toggle` | TextIter | Перемещение к границам и переключениям тегов |
| `gtk_text_iter_forward/backward_search` | TextIter | Поиск подстроки от текущей позиции |
| `gtk_text_iter_equal`, `compare`, `in_range` | TextIter | Сравнение позиций |
| `gtk_text_iter_starts/ends/inside_word/line/sentence` | TextIter | Проверка нахождения на границе/внутри |
| `gtk_text_iter_is_cursor_position`, `get_chars/bytes_in_line`, `is_end/start`, `can_insert`, `editable` | TextIter | Прочие проверки позиции |
| `gtk_text_buffer_create_tag` | TextBuffer | Создать и сразу зарегистрировать тег |
| `gtk_text_buffer_insert_with_tags(_by_name)` | TextBuffer | Вставить текст с сразу применёнными тегами |
| `gtk_text_buffer_add/remove_selection_clipboard` | TextBuffer | Связь с первичным выделением X11 |

---

## Сводка: какую процедуру выбрать

- **Создать тег форматирования** → `gtk_text_buffer_create_tag` (один вызов), а не раздельные `gtk_text_tag_new` + `g_object_set` + `gtk_text_tag_table_add`.
- **Вставить текст сразу с форматированием** → `gtk_text_buffer_insert_with_tags_by_name`, а не `insert` + `apply_tag_by_name` отдельно.
- **Перемещение максимально совпадающее с ощущениями от стрелок клавиатуры** → `forward/backward_cursor_position`, а не `forward/backward_char` — второе может остановиться посреди составного символа Unicode.
- **Выделить слово/предложение целиком** → `backward_word_start`/`forward_word_end` от текущей позиции, с предварительной проверкой `starts_word`/`inside_word`.
- **Быстро найти границы отформатированного тегом участка** → `forward_to_tag_toggle`/`backward_to_tag_toggle`, а не посимвольный перебор.
- **Два тега визуально конфликтуют при перекрытии** → явно задать более высокий `gtk_text_tag_set_priority`, а не полагаться на порядок создания тегов.
- **Маркер нужен только для программного слежения за позицией** → обычный `gtk_text_buffer_create_mark` (по умолчанию невидим); `gtk_text_mark_set_visible` — только для специализированных сценариев.
