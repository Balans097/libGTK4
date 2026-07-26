# GTK4 (multi-view containers: ListBox / Notebook / Paned / Stack) — справочник модуля

> **Импорт:** `import libGTK4`
> **Область применения:** контейнеры, которые управляют несколькими "видами" содержимого — списком строк, вкладками, регулируемым разделением на две панели, переключаемыми экранами. Седьмая часть серии справочников по обёртке; предполагает знакомство с предыдущими частями, особенно с `gtk4_core_reference_ru.md` (компоновка, `GtkWidget`).

Четыре виджета этого справочника решают внешне похожие, но разные задачи: `GtkListBox` — вертикальный список произвольных виджетов-строк с поддержкой выбора (в отличие от `GtkBox`, который просто выстраивает виджеты без понятия "строка" и "выбор"); `GtkNotebook` — классические вкладки; `GtkPaned` — область, разделённая на две части перетаскиваемым разделителем; `GtkStack` — несколько "экранов", занимающих одно и то же место, из которых виден только один — как слайды в презентации, переключаемые программно или через `GtkStackSwitcher`.

---

## Оглавление

I. [GtkListBox](#gtklistbox)
&nbsp;&nbsp;1. [`gtk_list_box_new`](#gtk_list_box_new)
&nbsp;&nbsp;2. [`gtk_list_box_append` / `gtk_list_box_prepend` / `gtk_list_box_insert` / `gtk_list_box_remove`](#gtk_list_box_append--gtk_list_box_prepend--gtk_list_box_insert--gtk_list_box_remove)
&nbsp;&nbsp;3. [`gtk_list_box_set_selection_mode` / `gtk_list_box_get_selection_mode`](#gtk_list_box_set_selection_mode--gtk_list_box_get_selection_mode)
&nbsp;&nbsp;4. [`gtk_list_box_select_row` / `gtk_list_box_unselect_row` / `gtk_list_box_get_selected_row`](#gtk_list_box_select_row--gtk_list_box_unselect_row--gtk_list_box_get_selected_row)
&nbsp;&nbsp;5. [`gtk_list_box_row_new` / `gtk_list_box_row_set_child` / `gtk_list_box_row_get_child` / `gtk_list_box_row_get_index`](#gtk_list_box_row_new--gtk_list_box_row_set_child--gtk_list_box_row_get_child--gtk_list_box_row_get_index)

II. [GtkNotebook](#gtknotebook)
&nbsp;&nbsp;1. [`gtk_notebook_new`](#gtk_notebook_new)
&nbsp;&nbsp;2. [`gtk_notebook_append_page` / `gtk_notebook_prepend_page` / `gtk_notebook_insert_page`](#gtk_notebook_append_page--gtk_notebook_prepend_page--gtk_notebook_insert_page)
&nbsp;&nbsp;3. [`gtk_notebook_remove_page`](#gtk_notebook_remove_page)
&nbsp;&nbsp;4. [`gtk_notebook_set_current_page` / `gtk_notebook_get_current_page`](#gtk_notebook_set_current_page--gtk_notebook_get_current_page)
&nbsp;&nbsp;5. [`gtk_notebook_get_nth_page` / `gtk_notebook_get_n_pages`](#gtk_notebook_get_nth_page--gtk_notebook_get_n_pages)
&nbsp;&nbsp;6. [`gtk_notebook_set_tab_pos` / `gtk_notebook_get_tab_pos`](#gtk_notebook_set_tab_pos--gtk_notebook_get_tab_pos)
&nbsp;&nbsp;7. [`gtk_notebook_set_show_tabs` / `gtk_notebook_get_show_tabs`](#gtk_notebook_set_show_tabs--gtk_notebook_get_show_tabs)
&nbsp;&nbsp;8. [`gtk_notebook_set_scrollable`](#gtk_notebook_set_scrollable)

III. [GtkPaned](#gtkpaned)
&nbsp;&nbsp;1. [`gtk_paned_new`](#gtk_paned_new)
&nbsp;&nbsp;2. [`gtk_paned_set_start_child` / `gtk_paned_get_start_child` / `gtk_paned_set_end_child` / `gtk_paned_get_end_child`](#gtk_paned_set_start_child--gtk_paned_get_start_child--gtk_paned_set_end_child--gtk_paned_get_end_child)
&nbsp;&nbsp;3. [`gtk_paned_set_position` / `gtk_paned_get_position`](#gtk_paned_set_position--gtk_paned_get_position)

IV. [GtkStack (и GtkStackSwitcher)](#gtkstack-и-gtkstackswitcher)
&nbsp;&nbsp;1. [`gtk_stack_new`](#gtk_stack_new)
&nbsp;&nbsp;2. [`gtk_stack_add_child` / `gtk_stack_add_named` / `gtk_stack_add_titled`](#gtk_stack_add_child--gtk_stack_add_named--gtk_stack_add_titled)
&nbsp;&nbsp;3. [`gtk_stack_remove` / `gtk_stack_get_child_by_name`](#gtk_stack_remove--gtk_stack_get_child_by_name)
&nbsp;&nbsp;4. [`gtk_stack_set_visible_child` / `gtk_stack_get_visible_child` / `set_visible_child_name` / `get_visible_child_name`](#gtk_stack_set_visible_child--gtk_stack_get_visible_child--set_visible_child_name--get_visible_child_name)
&nbsp;&nbsp;5. [`gtk_stack_set_transition_type` / `gtk_stack_get_transition_type` / `set_transition_duration` / `get_transition_duration`](#gtk_stack_set_transition_type--gtk_stack_get_transition_type--set_transition_duration--get_transition_duration)
&nbsp;&nbsp;6. [`gtk_stack_switcher_new` / `gtk_stack_switcher_set_stack` / `gtk_stack_switcher_get_stack`](#gtk_stack_switcher_new--gtk_stack_switcher_set_stack--gtk_stack_switcher_get_stack)

V. [Практические рецепты](#практические-рецепты)
&nbsp;&nbsp;1. [Список контактов с составными строками и режимом множественного выбора](#список-контактов-с-составными-строками-и-режимом-множественного-выбора)
&nbsp;&nbsp;2. [Вкладки редактора документов с закрытием по кнопке](#вкладки-редактора-документов-с-закрытием-по-кнопке)
&nbsp;&nbsp;3. [Разделённая на две панели область: список слева, детали справа](#разделённая-на-две-панели-область-список-слева-детали-справа)
&nbsp;&nbsp;4. [Экран настроек, переключаемый через GtkStackSwitcher](#экран-настроек-переключаемый-через-gtkstackswitcher)
&nbsp;&nbsp;5. [Программное переключение между "загрузкой" и "результатом" на одном месте экрана](#программное-переключение-между-загрузкой-и-результатом-на-одном-месте-экрана)

VI. [Краткая таблица](#краткая-таблица)

VII. [Сводка: какую процедуру выбрать](#сводка-какую-процедуру-выбрать)

---

## GtkListBox

`GtkListBox` — вертикальный список, где каждый элемент — это `GtkListBoxRow`, содержащий произвольный виджет (в отличие от простого перебора виджетов в `GtkBox`, `GtkListBox` знает о выборе строк, поддерживает несколько режимов выбора и специальный CSS-стиль для строк списка). Отличается от полноценных моделей данных (`GtkColumnView`/`GtkListView`, не входящих в этот справочник) тем, что каждая строка — обычный виджет, создаваемый и наполняемый вручную, а не строящийся автоматически из модели данных, — удобнее для коротких списков произвольной сложной вёрстки строки, но не рассчитан на тысячи элементов.

### `gtk_list_box_new`

```nim
proc gtk_list_box_new*(): GtkListBox
```

**Что делает.** Создаёт пустой список.

- Параметров нет.

```nim
let contactsList = gtk_list_box_new()
echo "Список контактов создан"
```

---

### `gtk_list_box_append` / `gtk_list_box_prepend` / `gtk_list_box_insert` / `gtk_list_box_remove`

```nim
proc gtk_list_box_append*(box: GtkListBox, child: GtkWidget)
proc gtk_list_box_prepend*(box: GtkListBox, child: GtkWidget)
proc gtk_list_box_insert*(box: GtkListBox, child: GtkWidget, position: gint)
proc gtk_list_box_remove*(box: GtkListBox, child: GtkWidget)
```

**Что делает.** Добавляют и убирают строки списка — та же логика порядка вставки, что у `gtk_box_append`/`prepend`/`insert_child_after` из базового справочника. Передаваемый `child` может быть как явно созданным `GtkListBoxRow` (раздел про строки ниже — нужен, если требуется тонкий контроль над самой строкой, например её собственным CSS-именем), так и произвольным виджетом напрямую — в этом случае `GtkListBox` автоматически оборачивает его в `GtkListBoxRow` неявно.

- `box` — список.
- `child` — добавляемый виджет (строка или произвольный виджет, который будет обёрнут автоматически).
- `position` (для `insert`) — индекс вставки.

```nim
let contactsList = gtk_list_box_new()
gtk_list_box_append(contactsList, gtk_label_new("Анна Иванова"))
gtk_list_box_append(contactsList, gtk_label_new("Пётр Смирнов"))
echo "Два контакта добавлены в список"
```

---

### `gtk_list_box_set_selection_mode` / `gtk_list_box_get_selection_mode`

```nim
proc gtk_list_box_set_selection_mode*(box: GtkListBox, mode: GtkSelectionMode)
proc gtk_list_box_get_selection_mode*(box: GtkListBox): GtkSelectionMode
```

**Что делает.** Задают, сколько строк списка может быть выбрано одновременно и можно ли снять выбор со всех строк вовсе: `GTK_SELECTION_NONE` — выбор отключён (список используется только для отображения, без интерактивности), `GTK_SELECTION_SINGLE` — можно выбрать одну строку либо не выбрать ни одной, `GTK_SELECTION_BROWSE` — ровно одна строка выбрана всегда (значение по умолчанию — щелчок по другой строке переносит выбор на неё, но полностью снять выбор нельзя), `GTK_SELECTION_MULTIPLE` — можно выбрать сразу несколько строк (`Ctrl+клик`, `Shift+клик`).

- `box` — список.
- `mode` — значение `GtkSelectionMode`.

```nim
gtk_list_box_set_selection_mode(contactsList, GTK_SELECTION_MULTIPLE)
echo "Список контактов теперь поддерживает выбор нескольких строк сразу"
```

---

### `gtk_list_box_select_row` / `gtk_list_box_unselect_row` / `gtk_list_box_get_selected_row`

```nim
proc gtk_list_box_select_row*(box: GtkListBox, row: GtkListBoxRow)
proc gtk_list_box_unselect_row*(box: GtkListBox, row: GtkListBoxRow)
proc gtk_list_box_get_selected_row*(box: GtkListBox): GtkListBoxRow
```

**Что делает.** Программно выбирают/снимают выбор с конкретной строки и читают текущую выбранную строку. `get_selected_row` возвращает только одну строку (последнюю выбранную) даже в режиме `GTK_SELECTION_MULTIPLE` — для получения полного списка выбранных строк при множественном выборе в этой обёртке нужна отдельная функция перебора всех выбранных строк, не входящая в данный набор (`gtk_list_box_selected_foreach`); для большинства сценариев с одиночным выбором (`GTK_SELECTION_SINGLE`/`_BROWSE`) `get_selected_row` — то, что нужно.

- `box` — список.
- `row` — строка (объект `GtkListBoxRow`, а не произвольный виджет, переданный в `append`, — если строка не создавалась вручную через `gtk_list_box_row_new`, GTK всё равно оборачивает её в `GtkListBoxRow`, доступный через сигналы `"row-selected"`/`"row-activated"`).

```nim
let selected = gtk_list_box_get_selected_row(contactsList)
if not isNil(selected):
  echo "Выбрана строка с индексом: ", gtk_list_box_row_get_index(selected)
```

---

### `gtk_list_box_row_new` / `gtk_list_box_row_set_child` / `gtk_list_box_row_get_child` / `gtk_list_box_row_get_index`

```nim
proc gtk_list_box_row_new*(): GtkListBoxRow
proc gtk_list_box_row_set_child*(row: GtkListBoxRow, child: GtkWidget)
proc gtk_list_box_row_get_child*(row: GtkListBoxRow): GtkWidget
proc gtk_list_box_row_get_index*(row: GtkListBoxRow): gint
```

**Что делает.** Явное создание строки списка отдельно от добавления в список — нужно, когда со строкой требуется что-то сделать до или помимо добавления содержимого через `append` (например, задать `gtk_widget_set_name` для строки ради точечной CSS-стилизации конкретной строки). `row_set_child`/`row_get_child` — единственный слот содержимого строки, тот же паттерн "один ребёнок", что у окна/рамки/прокручиваемого контейнера — для нескольких элементов внутри одной строки используется `GtkBox`. `row_get_index` возвращает позицию строки в списке (начиная с `0`) — не идентификатор, а именно текущая позиция, которая меняется при вставке/удалении других строк.

- `row` — строка.
- `child` — содержимое строки.

```nim
let complexRow = gtk_list_box_row_new()
let rowContent = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 8)
gtk_box_append(rowContent, gtk_image_new_from_icon_name("avatar-default-symbolic"))
gtk_box_append(rowContent, gtk_label_new("Мария Кузнецова"))
gtk_list_box_row_set_child(complexRow, rowContent)
gtk_list_box_append(contactsList, complexRow)
echo "Строка с иконкой и именем добавлена как явный GtkListBoxRow"
```

---

## GtkNotebook

`GtkNotebook` — классический виджет вкладок: несколько страниц содержимого, между которыми пользователь переключается кликом по ярлыку вкладки. Каждая страница добавляется парой виджетов — содержимое страницы и виджет ярлыка вкладки (обычно `GtkLabel`, но может быть и что-то сложнее, например ярлык с кнопкой закрытия).

### `gtk_notebook_new`

```nim
proc gtk_notebook_new*(): GtkNotebook
```

**Что делает.** Создаёт пустой виджет вкладок без страниц.

- Параметров нет.

```nim
let documentTabs = gtk_notebook_new()
echo "Виджет вкладок редактора создан"
```

---

### `gtk_notebook_append_page` / `gtk_notebook_prepend_page` / `gtk_notebook_insert_page`

```nim
proc gtk_notebook_append_page*(notebook: GtkNotebook, child: GtkWidget, tabLabel: GtkWidget): gint
proc gtk_notebook_prepend_page*(notebook: GtkNotebook, child: GtkWidget, tabLabel: GtkWidget): gint
proc gtk_notebook_insert_page*(notebook: GtkNotebook, child: GtkWidget, tabLabel: GtkWidget, position: gint): gint
```

**Что делает.** Добавляют новую вкладку — `child` становится содержимым страницы, `tabLabel` — виджетом самого ярлыка вкладки (обычно `gtk_label_new`, но подойдёт любой виджет, вплоть до `GtkBox` с иконкой и кнопкой закрытия, см. раздел V). Все три варианта возвращают числовой индекс добавленной страницы (начиная с `0`) — удобно сразу сохранить для последующего обращения через `set_current_page`/`remove_page`, не полагаясь на то, что индекс останется предсказуемым после дальнейших вставок/удалений других вкладок.

- `notebook` — виджет вкладок.
- `child` — содержимое новой страницы.
- `tabLabel` — виджет ярлыка вкладки.
- `position` (для `insert_page`) — индекс вставки.

```nim
let firstDocView = gtk_text_view_new()
let tabIndex = gtk_notebook_append_page(documentTabs, firstDocView, gtk_label_new("Документ 1"))
echo "Вкладка добавлена с индексом ", tabIndex
```

---

### `gtk_notebook_remove_page`

```nim
proc gtk_notebook_remove_page*(notebook: GtkNotebook, pageNum: gint)
```

**Что делает.** Удаляет вкладку по числовому индексу вместе с её содержимым (сам виджет содержимого при этом не уничтожается, а лишь отсоединяется — как и `gtk_box_remove` для `GtkBox`). После удаления индексы всех последующих вкладок сдвигаются на единицу вниз — если индексы вкладок хранятся где-то в логике приложения (например, для связи вкладки с открытым файлом), их нужно пересчитать после каждого удаления.

- `notebook` — виджет вкладок.
- `pageNum` — индекс удаляемой вкладки.

```nim
gtk_notebook_remove_page(documentTabs, tabIndex)
echo "Вкладка с документом закрыта"
```

---

### `gtk_notebook_set_current_page` / `gtk_notebook_get_current_page`

```nim
proc gtk_notebook_set_current_page*(notebook: GtkNotebook, pageNum: gint)
proc gtk_notebook_get_current_page*(notebook: GtkNotebook): gint
```

**Что делает.** Переключают активную (видимую) вкладку программно и читают индекс текущей активной вкладки. `set_current_page(notebook, -1)` переключает на последнюю добавленную вкладку — удобный способ сразу активировать только что созданную вкладку, не запоминая её точный индекс, если она заведомо добавлена последней.

- `notebook` — виджет вкладок.
- `pageNum` — индекс вкладки для активации, либо `-1` для последней.

```nim
gtk_notebook_set_current_page(documentTabs, -1)  # переключиться на только что добавленную вкладку
echo "Активна вкладка с индексом: ", gtk_notebook_get_current_page(documentTabs)
```

---

### `gtk_notebook_get_nth_page` / `gtk_notebook_get_n_pages`

```nim
proc gtk_notebook_get_nth_page*(notebook: GtkNotebook, pageNum: gint): GtkWidget
proc gtk_notebook_get_n_pages*(notebook: GtkNotebook): gint
```

**Что делает.** Возвращают виджет содержимого страницы по индексу и общее количество вкладок — например, для перебора всех открытых документов, чтобы проверить, есть ли среди них несохранённые изменения, перед закрытием приложения.

- `notebook` — виджет вкладок.
- `pageNum` — индекс страницы.

```nim
for i in 0 ..< gtk_notebook_get_n_pages(documentTabs):
  let pageContent = gtk_notebook_get_nth_page(documentTabs, gint(i))
  echo "Страница ", i, ": виджет содержимого получен"
```

---

### `gtk_notebook_set_tab_pos` / `gtk_notebook_get_tab_pos`

```nim
proc gtk_notebook_set_tab_pos*(notebook: GtkNotebook, pos: GtkPositionType)
proc gtk_notebook_get_tab_pos*(notebook: GtkNotebook): GtkPositionType
```

**Что делает.** Задают, с какой стороны области содержимого расположены ярлыки вкладок — `GTK_POS_TOP` (сверху, значение по умолчанию), `_BOTTOM`, `_LEFT`, `_RIGHT` (вертикальный ряд вкладок сбоку).

- `notebook` — виджет вкладок.
- `pos` — значение `GtkPositionType`.

```nim
gtk_notebook_set_tab_pos(documentTabs, GTK_POS_LEFT)
echo "Ярлыки вкладок перенесены на левую сторону"
```

---

### `gtk_notebook_set_show_tabs` / `gtk_notebook_get_show_tabs`

```nim
proc gtk_notebook_set_show_tabs*(notebook: GtkNotebook, showTabs: gboolean)
proc gtk_notebook_get_show_tabs*(notebook: GtkNotebook): gboolean
```

**Что делает.** Показывают/скрывают ряд ярлыков вкладок целиком, оставляя переключение страниц доступным только программно (`set_current_page`) — например, для мастера настройки в несколько шагов, реализованного через `GtkNotebook` ради встроенной логики страниц, но без визуальных вкладок, которые пользователь мог бы переключать сам в произвольном порядке.

- `notebook` — виджет вкладок.
- `showTabs` — `0.gboolean`, чтобы скрыть ярлыки.

```nim
gtk_notebook_set_show_tabs(wizardNotebook, 0.gboolean)
echo "Ярлыки вкладок скрыты — переключение только программное, через кнопки Далее/Назад"
```

---

### `gtk_notebook_set_scrollable`

```nim
proc gtk_notebook_set_scrollable*(notebook: GtkNotebook, scrollable: gboolean)
```

**Что делает.** Разрешает прокручивать ряд ярлыков вкладок (стрелками по краям), когда открыто больше вкладок, чем помещается по ширине, вместо того чтобы сжимать каждый ярлык до нечитаемого минимума. Актуально для приложений с потенциально большим числом одновременно открытых вкладок (текстовые редакторы, браузеры).

- `notebook` — виджет вкладок.
- `scrollable` — `1.gboolean`, чтобы разрешить прокрутку ярлыков.

```nim
gtk_notebook_set_scrollable(documentTabs, 1.gboolean)
echo "При большом числе открытых документов ярлыки вкладок можно будет прокручивать"
```

---

## GtkPaned

`GtkPaned` — область, разделённая на две части (`start`/`end` — левую/правую для горизонтальной ориентации, верхнюю/нижнюю для вертикальной) перетаскиваемым разделителем, позволяющим пользователю самому регулировать соотношение размеров двух панелей. Классический пример — файловый менеджер с деревом папок слева и списком файлов справа.

### `gtk_paned_new`

```nim
proc gtk_paned_new*(orientation: GtkOrientation): GtkPaned
```

**Что делает.** Создаёт пустую разделённую область указанной ориентации. `GTK_ORIENTATION_HORIZONTAL` — панели расположены рядом по горизонтали (`start` слева, `end` справа), `GTK_ORIENTATION_VERTICAL` — одна над другой (`start` сверху, `end` снизу).

- `orientation` — `GTK_ORIENTATION_HORIZONTAL` или `GTK_ORIENTATION_VERTICAL`.

```nim
let mainSplit = gtk_paned_new(GTK_ORIENTATION_HORIZONTAL)
echo "Горизонтально разделённая область создана: панель слева и справа"
```

---

### `gtk_paned_set_start_child` / `gtk_paned_get_start_child` / `gtk_paned_set_end_child` / `gtk_paned_get_end_child`

```nim
proc gtk_paned_set_start_child*(paned: GtkPaned, child: GtkWidget)
proc gtk_paned_get_start_child*(paned: GtkPaned): GtkWidget
proc gtk_paned_set_end_child*(paned: GtkPaned, child: GtkWidget)
proc gtk_paned_get_end_child*(paned: GtkPaned): GtkWidget
```

**Что делает.** Устанавливают и читают содержимое каждой из двух панелей независимо. Как и у `GtkBox`, для нескольких элементов в одной панели единственным ребёнком делают контейнер.

- `paned` — разделённая область.
- `child` — виджет-содержимое соответствующей панели.

```nim
gtk_paned_set_start_child(mainSplit, folderTreeScrolled)
gtk_paned_set_end_child(mainSplit, fileListScrolled)
echo "Дерево папок слева, список файлов справа"
```

---

### `gtk_paned_set_position` / `gtk_paned_get_position`

```nim
proc gtk_paned_set_position*(paned: GtkPaned, position: gint)
proc gtk_paned_get_position*(paned: GtkPaned): gint
```

**Что делает.** Устанавливают и читают положение разделителя в пикселях от начала области (левого края для горизонтальной ориентации, верхнего — для вертикальной) — то есть фактически ширину (или высоту) панели `start`. Позицию стоит задать сразу после создания — без явного `set_position` GTK делит место примерно пополам, что не всегда уместно (например, для дерева папок обычно нужна панель уже, чем список файлов).

- `paned` — разделённая область.
- `position` — позиция разделителя в пикселях.

```nim
gtk_paned_set_position(mainSplit, 220)  # панель дерева папок шириной 220px
echo "Начальная ширина левой панели: ", gtk_paned_get_position(mainSplit), " пикселей"
```

---

## GtkStack (и GtkStackSwitcher)

`GtkStack` показывает ровно один из нескольких добавленных в него виджетов, занимающих одно и то же место, с плавной анимацией перехода между ними при переключении. В отличие от `GtkNotebook`, у `GtkStack` нет собственного визуального ряда переключателей — за это отдельно отвечает `GtkStackSwitcher` (или, в других сценариях, `GtkStackSidebar` — вне этого справочника) либо переключение выполняется полностью программно, без видимого пользователю элемента управления вовсе (например, переключение между экраном загрузки и экраном результата).

### `gtk_stack_new`

```nim
proc gtk_stack_new*(): GtkStack
```

**Что делает.** Создаёт пустой стек без страниц.

- Параметров нет.

```nim
let settingsStack = gtk_stack_new()
echo "Стек экранов настроек создан"
```

---

### `gtk_stack_add_child` / `gtk_stack_add_named` / `gtk_stack_add_titled`

```nim
proc gtk_stack_add_child*(stack: GtkStack, child: GtkWidget): GtkWidget
proc gtk_stack_add_named*(stack: GtkStack, child: GtkWidget, name: cstring): GtkWidget
proc gtk_stack_add_titled*(stack: GtkStack, child: GtkWidget, name: cstring, title: cstring): GtkWidget
```

**Что делает.** Три уровня добавления страницы в стек. `gtk_stack_add_child` — минимальный вариант, без имени (обращаться к странице впоследствии можно только через сам объект виджета, не по строковому идентификатору). `gtk_stack_add_named` добавляет с именем — тем самым `name`, которое затем использует `gtk_stack_set_visible_child_name` для переключения и `GtkStackSwitcher` для сопоставления кнопки переключения со страницей. `gtk_stack_add_titled` — то же самое, что `_named`, но дополнительно с человекочитаемым заголовком `title`, который использует `GtkStackSwitcher` как подпись на кнопке переключения (в отличие от `name`, предназначенного оставаться техническим и не изменяться при локализации интерфейса). Все три варианта возвращают тот же переданный `child` — удобно для использования в цепочке без промежуточной переменной.

- `stack` — стек.
- `child` — добавляемый виджет-страница.
- `name` — технический строковый идентификатор страницы.
- `title` — заголовок, видимый пользователю (для `add_titled`).

```nim
let generalPage = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)
let networkPage = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)
discard gtk_stack_add_titled(settingsStack, generalPage, "general", "Общие")
discard gtk_stack_add_titled(settingsStack, networkPage, "network", "Сеть")
echo "Два экрана настроек добавлены в стек с именами и заголовками"
```

---

### `gtk_stack_remove` / `gtk_stack_get_child_by_name`

```nim
proc gtk_stack_remove*(stack: GtkStack, child: GtkWidget)
proc gtk_stack_get_child_by_name*(stack: GtkStack, name: cstring): GtkWidget
```

**Что делает.** Убирают страницу из стека (по объекту виджета) и находят страницу по её техническому имени, заданному через `add_named`/`add_titled` (возвращает `nil`, если страницы с таким именем нет — в том числе если страница была добавлена через `add_child` вовсе без имени).

- `stack` — стек.
- `child` — виджет-страница для удаления.
- `name` — техническое имя искомой страницы.

```nim
let networkPageFound = gtk_stack_get_child_by_name(settingsStack, "network")
echo "Страница 'network' найдена в стеке: ", not isNil(networkPageFound)
```

---

### `gtk_stack_set_visible_child` / `gtk_stack_get_visible_child` / `set_visible_child_name` / `get_visible_child_name`

```nim
proc gtk_stack_set_visible_child*(stack: GtkStack, child: GtkWidget)
proc gtk_stack_get_visible_child*(stack: GtkStack): GtkWidget
proc gtk_stack_set_visible_child_name*(stack: GtkStack, name: cstring)
proc gtk_stack_get_visible_child_name*(stack: GtkStack): cstring
```

**Что делает.** Переключают видимую страницу — по объекту виджета (`set_visible_child`, работает для любой страницы, включая добавленные через `add_child` без имени) либо по техническому имени (`set_visible_child_name`, только для страниц, добавленных с именем). Переключение запускает анимацию перехода, настраиваемую следующим подразделом. `get_visible_child`/`get_visible_child_name` читают текущую видимую страницу — вторая функция удобнее, когда логика приложения и так оперирует именами страниц, а не хранит прямые ссылки на объекты виджетов.

- `stack` — стек.
- `child` — целевая страница (объектом).
- `name` — техническое имя целевой страницы.

```nim
gtk_stack_set_visible_child_name(settingsStack, "network")
echo "Показан экран сетевых настроек: ", $gtk_stack_get_visible_child_name(settingsStack)
```

---

### `gtk_stack_set_transition_type` / `gtk_stack_get_transition_type` / `set_transition_duration` / `get_transition_duration`

```nim
proc gtk_stack_set_transition_type*(stack: GtkStack, transition: GtkStackTransitionType)
proc gtk_stack_get_transition_type*(stack: GtkStack): GtkStackTransitionType
proc gtk_stack_set_transition_duration*(stack: GtkStack, duration: cuint)
proc gtk_stack_get_transition_duration*(stack: GtkStack): cuint
```

**Что делает.** Настраивают анимацию перехода между страницами при переключении. `transition` — тип анимации: `GTK_STACK_TRANSITION_TYPE_NONE` (мгновенно, без анимации), `_CROSSFADE` (плавное перекрёстное затухание — универсальный выбор по умолчанию для большинства случаев), различные варианты выезжания (`_SLIDE_LEFT`/`_RIGHT`/`_UP`/`_DOWN`, а также направленные автоматически в зависимости от взаимного порядка страниц — `_SLIDE_LEFT_RIGHT`/`_SLIDE_UP_DOWN`) и наложения (`_OVER_*`/`_UNDER_*` — новая страница выезжает поверх старой или появляется из-под неё). `duration` — длительность анимации в миллисодах (по умолчанию — 200 мс).

- `stack` — стек.
- `transition` — значение `GtkStackTransitionType`.
- `duration` — длительность в миллисекундах.

```nim
gtk_stack_set_transition_type(settingsStack, GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT_RIGHT)
gtk_stack_set_transition_duration(settingsStack, 250)
echo "Переключение экранов настроек теперь анимируется выезжанием в нужную сторону за 250 мс"
```

---

### `gtk_stack_switcher_new` / `gtk_stack_switcher_set_stack` / `gtk_stack_switcher_get_stack`

```nim
proc gtk_stack_switcher_new*(): GtkStackSwitcher
proc gtk_stack_switcher_set_stack*(switcher: GtkStackSwitcher, stack: GtkStack)
proc gtk_stack_switcher_get_stack*(switcher: GtkStackSwitcher): GtkStack
```

**Что делает.** `GtkStackSwitcher` — готовый ряд кнопок-переключателей, по одной на каждую страницу стека, добавленную с `title` через `gtk_stack_add_titled` (страницы без заголовка в переключателе не появляются). `gtk_stack_switcher_set_stack` связывает переключатель с конкретным стеком — после этого переключатель автоматически показывает кнопки для всех текущих и последующих добавленных страниц, без какой-либо ручной синхронизации.

- `switcher` — переключатель.
- `stack` — стек, с которым нужно связать переключатель.

```nim
let switcher = gtk_stack_switcher_new()
gtk_stack_switcher_set_stack(switcher, settingsStack)

let settingsRoot = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)
gtk_widget_set_halign(switcher, GTK_ALIGN_CENTER)
gtk_box_append(settingsRoot, switcher)
gtk_box_append(settingsRoot, settingsStack)
echo "Переключатель с кнопками 'Общие'/'Сеть' автоматически синхронизирован со стеком"
```

---

## Практические рецепты

### Список контактов с составными строками и режимом множественного выбора

Строки списка с иконкой и двумя строками текста (имя и статус), с возможностью выбрать сразу несколько контактов.

```nim
proc buildContactRow(name, status: string): GtkWidget =
  let row = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 8)
  gtk_widget_set_margin_top(row, 6)
  gtk_widget_set_margin_bottom(row, 6)
  gtk_widget_set_margin_start(row, 8)
  gtk_widget_set_margin_end(row, 8)

  gtk_box_append(row, gtk_image_new_from_icon_name("avatar-default-symbolic"))

  let textColumn = gtk_box_new(GTK_ORIENTATION_VERTICAL, 2)
  gtk_box_append(textColumn, gtk_label_new(name.cstring))
  let statusLabel = gtk_label_new(status.cstring)
  gtk_widget_add_css_class(statusLabel, "dim-label")
  gtk_box_append(textColumn, statusLabel)
  gtk_box_append(row, textColumn)

  result = row

proc buildContactsList(): GtkListBox =
  result = gtk_list_box_new()
  gtk_list_box_set_selection_mode(result, GTK_SELECTION_MULTIPLE)
  gtk_list_box_append(result, buildContactRow("Анна Иванова", "в сети"))
  gtk_list_box_append(result, buildContactRow("Пётр Смирнов", "не в сети"))
  echo "Список контактов с составными строками и множественным выбором собран"

let contactsList = buildContactsList()
```

---

### Вкладки редактора документов с закрытием по кнопке

Ярлык вкладки — не просто текст, а `GtkBox` с надписью и маленькой кнопкой закрытия.

```nim
proc buildClosableTab(notebook: GtkNotebook, title: string, content: GtkWidget) =
  let tabLabel = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 4)
  gtk_box_append(tabLabel, gtk_label_new(title.cstring))

  let closeButton = gtk_button_new_from_icon_name("window-close-symbolic")
  gtk_button_set_has_frame(closeButton, 0.gboolean)
  gtk_widget_add_css_class(closeButton, "flat")

  proc onCloseClicked(button: GtkButton, userData: gpointer) {.cdecl.} =
    let nb = cast[GtkNotebook](userData)
    let pageIndex = gtk_notebook_get_current_page(nb)
    gtk_notebook_remove_page(nb, pageIndex)
    echo "Вкладка закрыта по клику на кнопку в ярлыке"

  discard g_signal_connect(closeButton, "clicked", onCloseClicked, cast[gpointer](notebook))
  gtk_box_append(tabLabel, closeButton)

  discard gtk_notebook_append_page(notebook, content, tabLabel)

let editorTabs = gtk_notebook_new()
gtk_notebook_set_scrollable(editorTabs, 1.gboolean)
buildClosableTab(editorTabs, "main.nim", gtk_text_view_new())
buildClosableTab(editorTabs, "utils.nim", gtk_text_view_new())
```

---

### Разделённая на две панели область: список слева, детали справа

Файловый менеджер / почтовый клиент — типичный layout: узкая панель навигации слева, широкая область содержимого справа.

```nim
proc buildMasterDetailLayout(): GtkPaned =
  result = gtk_paned_new(GTK_ORIENTATION_HORIZONTAL)

  let folderList = gtk_list_box_new()
  gtk_list_box_append(folderList, gtk_label_new("Входящие"))
  gtk_list_box_append(folderList, gtk_label_new("Отправленные"))
  gtk_list_box_append(folderList, gtk_label_new("Черновики"))
  let folderScrolled = gtk_scrolled_window_new()
  gtk_scrolled_window_set_child(folderScrolled, folderList)
  gtk_paned_set_start_child(result, folderScrolled)

  let messageView = gtk_text_view_new()
  gtk_text_view_set_editable(messageView, 0.gboolean)
  let messageScrolled = gtk_scrolled_window_new()
  gtk_scrolled_window_set_child(messageScrolled, messageView)
  gtk_paned_set_end_child(result, messageScrolled)

  gtk_paned_set_position(result, 180)
  echo "Список папок слева (180px), просмотр письма справа"

let mailLayout = buildMasterDetailLayout()
```

---

### Экран настроек, переключаемый через GtkStackSwitcher

Полная сборка стека с двумя экранами настроек и рядом кнопок-переключателей над ним.

```nim
proc buildSettingsScreen(): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_VERTICAL, 12)

  let stack = gtk_stack_new()
  gtk_stack_set_transition_type(stack, GTK_STACK_TRANSITION_TYPE_CROSSFADE)

  let generalPage = gtk_label_new("Здесь общие настройки")
  let networkPage = gtk_label_new("Здесь настройки сети")
  discard gtk_stack_add_titled(stack, generalPage, "general", "Общие")
  discard gtk_stack_add_titled(stack, networkPage, "network", "Сеть")

  let switcher = gtk_stack_switcher_new()
  gtk_stack_switcher_set_stack(switcher, stack)
  gtk_widget_set_halign(switcher, GTK_ALIGN_CENTER)

  gtk_box_append(result, switcher)
  gtk_box_append(result, stack)
  echo "Экран настроек с переключателем и двумя вкладками-экранами готов"

let settingsScreen = buildSettingsScreen()
```

---

### Программное переключение между "загрузкой" и "результатом" на одном месте экрана

`GtkStack` без видимого переключателя — переключение происходит по завершении фоновой операции, а не по клику пользователя.

```nim
proc buildAsyncResultArea(): GtkStack =
  result = gtk_stack_new()
  gtk_stack_set_transition_type(result, GTK_STACK_TRANSITION_TYPE_CROSSFADE)

  let spinner = gtk_spinner_new()
  gtk_spinner_start(spinner)
  discard gtk_stack_add_named(result, spinner, "loading")

  let resultLabel = gtk_label_new("")
  discard gtk_stack_add_named(result, resultLabel, "result")

  gtk_stack_set_visible_child_name(result, "loading")
  echo "Область результата показывает спиннер загрузки"

proc onDataLoaded(stack: GtkStack, text: string) =
  let resultChild = gtk_stack_get_child_by_name(stack, "result")
  gtk_label_set_text(cast[GtkLabel](resultChild), text.cstring)
  gtk_stack_set_visible_child_name(stack, "result")
  echo "Загрузка завершена — область переключилась на результат с анимацией перекрёстного затухания"
```

---

## Краткая таблица

| Процедура(ы) | Категория | Что делает вкратце |
|---|---|---|
| `gtk_list_box_new` | ListBox | Создать список строк |
| `gtk_list_box_append/prepend/insert/remove` | ListBox | Добавить/убрать строку |
| `gtk_list_box_set/get_selection_mode` | ListBox | Сколько строк можно выбрать одновременно |
| `gtk_list_box_select_row`, `unselect_row`, `get_selected_row` | ListBox | Программное управление выбором |
| `gtk_list_box_row_new`, `row_set/get_child`, `row_get_index` | ListBox | Явное создание строки и её содержимое |
| `gtk_notebook_new` | Notebook | Создать виджет вкладок |
| `gtk_notebook_append/prepend/insert_page` | Notebook | Добавить вкладку (содержимое + ярлык) |
| `gtk_notebook_remove_page` | Notebook | Удалить вкладку по индексу |
| `gtk_notebook_set/get_current_page` | Notebook | Текущая активная вкладка |
| `gtk_notebook_get_nth_page`, `get_n_pages` | Notebook | Содержимое по индексу / общее число вкладок |
| `gtk_notebook_set/get_tab_pos` | Notebook | С какой стороны расположены ярлыки |
| `gtk_notebook_set/get_show_tabs` | Notebook | Показывать ли ряд ярлыков вообще |
| `gtk_notebook_set_scrollable` | Notebook | Разрешить прокрутку ярлыков при их избытке |
| `gtk_paned_new` | Paned | Создать область с двумя панелями и разделителем |
| `gtk_paned_set/get_start_child`, `set/get_end_child` | Paned | Содержимое каждой из двух панелей |
| `gtk_paned_set/get_position` | Paned | Положение перетаскиваемого разделителя |
| `gtk_stack_new` | Stack | Создать стек переключаемых страниц |
| `gtk_stack_add_child`, `add_named`, `add_titled` | Stack | Добавить страницу — без имени / с именем / с именем и заголовком |
| `gtk_stack_remove`, `get_child_by_name` | Stack | Удалить страницу / найти по имени |
| `gtk_stack_set/get_visible_child`, `set/get_visible_child_name` | Stack | Переключение видимой страницы (объектом или по имени) |
| `gtk_stack_set/get_transition_type`, `set/get_transition_duration` | Stack | Тип и длительность анимации перехода |
| `gtk_stack_switcher_new`, `switcher_set/get_stack` | StackSwitcher | Готовый ряд кнопок-переключателей для стека |

---

## Сводка: какую процедуру выбрать

- **Список произвольных строк с возможностью выбора** (контакты, файлы с иконками, настройки в виде строк) → `GtkListBox`, а не `GtkBox` + собственноручно написанная логика клика и подсветки — выбор, режимы выбора и стилизация строк уже встроены.
- **Классические вкладки, переключаемые пользователем** → `GtkNotebook`. **Переключение экранов без визуального ряда вкладок, либо с полностью кастомным переключателем, либо программно без участия пользователя вовсе** → `GtkStack` (при необходимости — с `GtkStackSwitcher`, если всё же нужен готовый ряд кнопок, но не обязательно в форме классических вкладок).
- **Пользователь должен сам регулировать соотношение размеров двух областей** (список/детали, дерево/содержимое) → `GtkPaned` с `gtk_paned_set_position` для начального разумного значения — не пытаться добиться того же эффекта через `GtkBox` с `hexpand` на одном из двух виджетов, тот не даёт перетаскиваемой границы.
- **Нужно и показать несколько вариантов, и уметь переключаться на них по стабильному текстовому имени** (не завязываясь на индекс или прямую ссылку на объект виджета) → `gtk_stack_add_named`/`add_titled` + `gtk_stack_set_visible_child_name`, а не `gtk_notebook_insert_page` с числовым индексом, который сдвигается при добавлении/удалении других вкладок.
- **У стека должен быть заголовок, видимый пользователю в переключателе, отдельно от технического имени** (например, для локализации интерфейса без изменения внутренней логики, ссылающейся на `name`) → `gtk_stack_add_titled`, а не `add_named` с последующей попыткой достать заголовок откуда-то ещё — техническое имя и видимый заголовок разделены намеренно.
- **Переключение экрана должно быть плавным, а не резким** → `gtk_stack_set_transition_type` с любым значением, кроме `GTK_STACK_TRANSITION_TYPE_NONE` (по умолчанию уже `_CROSSFADE`, но конкретное направление уместнее подбирать под контекст: выезжание — для навигации "вперёд/назад", перекрёстное затухание — для переключений без выраженного направления, как загрузка → результат).
