# GTK4 (deprecated: GtkTreeView family — ListStore / TreeStore / TreeView / TreeViewColumn / CellRenderer / TreeSelection / TreePath / TreeModel) — справочник модуля

> **Импорт:** `import libGTK4`
> **Область применения:** классическая модель "список/дерево + модель данных + столбцы" из GTK3, перенесённая в GTK4 для обратной совместимости. Четырнадцатая часть серии справочников по обёртке.

## Важное предупреждение

**Весь API этого справочника официально устарел (deprecated) в GTK4.** Для нового кода GTK-документация рекомендует современную замену: `GtkColumnView`/`GtkListView` (табличные и простые списки на основе `GListModel`) вместо `GtkTreeView`/`GtkTreeStore`, `GtkColumnViewColumn` вместо `GtkTreeViewColumn`, фабрики виджетов (`GtkListItemFactory`) вместо `GtkCellRenderer`, `GtkSelectionModel` вместо `GtkTreeSelection` — этот современный набор рассматривается в отдельном справочнике этой серии.

В самой обёртке весь код этого справочника обёрнут в `when not defined(GTK_DISABLE_DEPRECATED):` — доступен при обычной сборке, но полностью исчезает из бинарника при компиляции с флагом `-d:GTK_DISABLE_DEPRECATED`. Это даёт практический способ проверить, не тянет ли существующий код зависимость от устаревшего API, прежде чем переходить на современную замену: если проект компилируется с этим флагом, значит, ни одна функция данного справочника не используется.

Причины, по которым этот справочник всё же документируется (а не просто пропускается): существующий код на GTK3, переносимый на GTK4 без полного переписывания интерфейса; библиотеки и туториалы, всё ещё опирающиеся на этот API; и сама GTK4 гарантирует его работоспособность (хоть и без развития) на всём протяжении жизненного цикла GTK4, в отличие от кода, полагающегося на неэкспортируемые внутренние символы (см. отдельное обсуждение приватного API при разборе очистки самой обёртки).

---

## Оглавление

I. [GtkListStore](#gtkliststore)
&nbsp;&nbsp;1. [`gtk_list_store_new` / `gtk_list_store_newv`](#gtk_list_store_new--gtk_list_store_newv)
&nbsp;&nbsp;2. [`gtk_list_store_append` / `gtk_list_store_prepend` / `gtk_list_store_insert`](#gtk_list_store_append--gtk_list_store_prepend--gtk_list_store_insert)
&nbsp;&nbsp;3. [`gtk_list_store_set`](#gtk_list_store_set)
&nbsp;&nbsp;4. [`gtk_list_store_remove` / `gtk_list_store_clear`](#gtk_list_store_remove--gtk_list_store_clear)

II. [GtkTreeStore](#gtktreestore)
&nbsp;&nbsp;1. [`gtk_tree_store_new`](#gtk_tree_store_new)
&nbsp;&nbsp;2. [`gtk_tree_store_append` / `gtk_tree_store_prepend` / `gtk_tree_store_insert`](#gtk_tree_store_append--gtk_tree_store_prepend--gtk_tree_store_insert)
&nbsp;&nbsp;3. [`gtk_tree_store_set`](#gtk_tree_store_set)
&nbsp;&nbsp;4. [`gtk_tree_store_remove` / `gtk_tree_store_clear`](#gtk_tree_store_remove--gtk_tree_store_clear)

III. [GtkTreeView](#gtktreeview)
&nbsp;&nbsp;1. [`gtk_tree_view_new` / `gtk_tree_view_new_with_model`](#gtk_tree_view_new--gtk_tree_view_new_with_model)
&nbsp;&nbsp;2. [`gtk_tree_view_set_model` / `gtk_tree_view_get_model`](#gtk_tree_view_set_model--gtk_tree_view_get_model)
&nbsp;&nbsp;3. [`gtk_tree_view_append_column` / `gtk_tree_view_insert_column` / `gtk_tree_view_remove_column`](#gtk_tree_view_append_column--gtk_tree_view_insert_column--gtk_tree_view_remove_column)
&nbsp;&nbsp;4. [`gtk_tree_view_get_selection`](#gtk_tree_view_get_selection)
&nbsp;&nbsp;5. [`gtk_tree_view_set_headers_visible` / `gtk_tree_view_get_headers_visible`](#gtk_tree_view_set_headers_visible--gtk_tree_view_get_headers_visible)
&nbsp;&nbsp;6. [`gtk_tree_view_expand_all` / `gtk_tree_view_collapse_all`](#gtk_tree_view_expand_all--gtk_tree_view_collapse_all)

IV. [GtkTreeViewColumn](#gtktreeviewcolumn)
&nbsp;&nbsp;1. [`gtk_tree_view_column_new` / `gtk_tree_view_column_new_with_attributes`](#gtk_tree_view_column_new--gtk_tree_view_column_new_with_attributes)
&nbsp;&nbsp;2. [`gtk_tree_view_column_pack_start` / `gtk_tree_view_column_pack_end` / `gtk_tree_view_column_add_attribute`](#gtk_tree_view_column_pack_start--gtk_tree_view_column_pack_end--gtk_tree_view_column_add_attribute)
&nbsp;&nbsp;3. [`gtk_tree_view_column_set_title` / `gtk_tree_view_column_get_title`](#gtk_tree_view_column_set_title--gtk_tree_view_column_get_title)
&nbsp;&nbsp;4. [`gtk_tree_view_column_set_resizable` / `get_resizable` / `set_visible` / `get_visible`](#gtk_tree_view_column_set_resizable--get_resizable--set_visible--get_visible)
&nbsp;&nbsp;5. [`gtk_tree_view_column_clear`](#gtk_tree_view_column_clear)

V. [GtkCellRenderer](#gtkcellrenderer)
&nbsp;&nbsp;1. [`gtk_cell_renderer_text_new` / `gtk_cell_renderer_toggle_new` / `gtk_cell_renderer_pixbuf_new`](#gtk_cell_renderer_text_new--gtk_cell_renderer_toggle_new--gtk_cell_renderer_pixbuf_new)
&nbsp;&nbsp;2. [`gtk_cell_renderer_toggle_set_active` / `get_active` / `set_radio` / `get_radio`](#gtk_cell_renderer_toggle_set_active--get_active--set_radio--get_radio)

VI. [GtkTreeSelection](#gtktreeselection)
&nbsp;&nbsp;1. [`gtk_tree_selection_set_mode` / `gtk_tree_selection_get_mode`](#gtk_tree_selection_set_mode--gtk_tree_selection_get_mode)
&nbsp;&nbsp;2. [`gtk_tree_selection_get_selected`](#gtk_tree_selection_get_selected)
&nbsp;&nbsp;3. [`gtk_tree_selection_select_iter` / `unselect_iter` / `select_all` / `unselect_all`](#gtk_tree_selection_select_iter--unselect_iter--select_all--unselect_all)

VII. [GtkTreePath](#gtktreepath)
&nbsp;&nbsp;1. [`gtk_tree_path_new` / `gtk_tree_path_new_from_string`](#gtk_tree_path_new--gtk_tree_path_new_from_string)
&nbsp;&nbsp;2. [`gtk_tree_path_to_string` / `gtk_tree_path_free`](#gtk_tree_path_to_string--gtk_tree_path_free)

VIII. [GtkTreeModel](#gtktreemodel)
&nbsp;&nbsp;1. [`gtk_tree_model_get_iter` / `gtk_tree_model_get_iter_first` / `gtk_tree_model_get_path`](#gtk_tree_model_get_iter--gtk_tree_model_get_iter_first--gtk_tree_model_get_path)
&nbsp;&nbsp;2. [`gtk_tree_model_get_value`](#gtk_tree_model_get_value)
&nbsp;&nbsp;3. [`gtk_tree_model_iter_next` / `gtk_tree_model_iter_previous`](#gtk_tree_model_iter_next--gtk_tree_model_iter_previous)
&nbsp;&nbsp;4. [`gtk_tree_model_iter_children` / `iter_has_child` / `iter_n_children` / `iter_nth_child` / `iter_parent`](#gtk_tree_model_iter_children--iter_has_child--iter_n_children--iter_nth_child--iter_parent)
&nbsp;&nbsp;5. [`gtk_tree_model_get_string_from_iter`](#gtk_tree_model_get_string_from_iter)

IX. [Практические рецепты](#практические-рецепты)
&nbsp;&nbsp;1. [Простой список с одним текстовым столбцом](#простой-список-с-одним-текстовым-столбцом)
&nbsp;&nbsp;2. [Дерево с раскрывающимися узлами](#дерево-с-раскрывающимися-узлами)
&nbsp;&nbsp;3. [Столбец с флажками (чекбоксами) в каждой строке](#столбец-с-флажками-чекбоксами-в-каждой-строке)
&nbsp;&nbsp;4. [Обход всех строк модели вручную через итератор](#обход-всех-строк-модели-вручную-через-итератор)
&nbsp;&nbsp;5. [Реакция на выбор строки пользователем](#реакция-на-выбор-строки-пользователем)

X. [Краткая таблица](#краткая-таблица)

XI. [Сводка: какую процедуру выбрать](#сводка-какую-процедуру-выбрать)

---

## GtkListStore

`GtkListStore` — плоская (без иерархии) табличная модель данных: набор строк, каждая с фиксированным числом типизированных столбцов, — данные для `GtkTreeView` в режиме простого списка (без вложенности узлов, в отличие от `GtkTreeStore`, раздел II).

### `gtk_list_store_new` / `gtk_list_store_newv`

```nim
proc gtk_list_store_new*(nColumns: gint): GtkListStore {.varargs.}
proc gtk_list_store_newv*(nColumns: gint, types: ptr GType): GtkListStore
```

**Что делает.** Создают модель с заданным числом столбцов и их типами. `gtk_list_store_new` принимает типы столбцов как вариативный список `GType` вслед за `nColumns` (например, `gtk_list_store_new(2, g_object_get_type(), G_TYPE_STRING)` — хотя в реальности типы почти всегда берутся через готовые константы вроде `G_TYPE_STRING`/`G_TYPE_INT`, не всегда заведённые именованными в этой обёртке отдельно от `g_object_get_type`). `gtk_list_store_newv` — та же операция через явный массив `GType` вместо вариативного списка, удобнее при динамически определяемом числе столбцов.

- `nColumns` — количество столбцов.
- Далее (для `new`) — `nColumns` значений `GType`, по одному на столбец.
- `types` (для `newv`) — массив `GType` того же размера, что `nColumns`.

```nim
# G_TYPE_STRING нужно получить любым доступным способом получения GType для строк —
# в этой обёртке нет отдельно заведённой константы, обычно берётся из реальных
# заголовков GLib (G_TYPE_STRING = 64 в стандартной системе типов GLib) либо
# вычисляется через вспомогательные функции типов, не входящие в этот справочник.
let contactsStore = gtk_list_store_new(1, G_TYPE_STRING)
echo "Модель списка с одним текстовым столбцом создана"
```

---

### `gtk_list_store_append` / `gtk_list_store_prepend` / `gtk_list_store_insert`

```nim
proc gtk_list_store_append*(listStore: GtkListStore, iter: ptr GtkTreeIter)
proc gtk_list_store_prepend*(listStore: GtkListStore, iter: ptr GtkTreeIter)
proc gtk_list_store_insert*(listStore: GtkListStore, iter: ptr GtkTreeIter, position: gint)
```

**Что делает.** Добавляют новую пустую строку в конец, в начало, либо в произвольную позицию модели и заполняют переданный `iter`, указывающий на только что добавленную строку, — саму строку затем нужно заполнить значениями через `gtk_list_store_set` (следующий подраздел); сами по себе эти функции лишь резервируют место для новой строки.

- `listStore` — модель.
- `iter` — итератор (`GtkTreeIter`, тот же тип структуры, что и в справочнике по многострочному тексту для `GtkTextIter`, но отдельный, специфичный именно для `GtkTreeModel`), который будет заполнен указателем на новую строку.
- `position` (для `insert`) — индекс вставки.

```nim
var newRow: GtkTreeIter
gtk_list_store_append(contactsStore, addr newRow)
echo "Новая пустая строка добавлена, итератор указывает на неё"
```

---

### `gtk_list_store_set`

```nim
proc gtk_list_store_set*(listStore: GtkListStore, iter: ptr GtkTreeIter) {.varargs.}
```

**Что делает.** Заполняет значения столбцов указанной строки — вариативный список чередующихся пар "номер столбца" (`gint`, начиная с `0`) / "значение", обязательно завершённый значением `-1` вместо очередного номера столбца (сигнал конца списка — тот же принцип terminator-значения, что у `nil` в списках C-строк, но здесь именно числовой, поскольку номера столбцов неотрицательны, а `-1` однозначно не может быть настоящим номером столбца).

- **Реализация.** Пропуск завершающего `-1` — источник неопределённого поведения, аналогично пропуску `nil` в `gtk_file_chooser_dialog_new` из справочника по window chrome.

- `listStore` — модель.
- `iter` — строка, значения которой устанавливаются.
- Далее — чередующиеся пары (номер столбца, значение), завершённые `-1`.

```nim
gtk_list_store_set(contactsStore, addr newRow, 0, "Анна Иванова".cstring, -1)
echo "Значение первого (и единственного) столбца новой строки установлено"
```

---

### `gtk_list_store_remove` / `gtk_list_store_clear`

```nim
proc gtk_list_store_remove*(listStore: GtkListStore, iter: ptr GtkTreeIter): gboolean
proc gtk_list_store_clear*(listStore: GtkListStore)
```

**Что делает.** Удаляют одну строку по итератору (`remove` дополнительно сообщает через возвращаемое значение, остался ли итератор действительным после удаления — указывая теперь на следующую строку, если она есть; `0.gboolean`, если удалённая строка была последней) и очищают модель полностью (`clear` удаляет все строки разом).

- `listStore` — модель.
- `iter` — итератор удаляемой строки (для `remove`).

```nim
discard gtk_list_store_remove(contactsStore, addr newRow)
echo "Строка удалена"
gtk_list_store_clear(contactsStore)
echo "Все строки модели удалены разом"
```

---

## GtkTreeStore

`GtkTreeStore` — иерархическая модель данных: та же логика столбцов, что у `GtkListStore`, но каждая строка может иметь дочерние строки произвольной глубины — данные для `GtkTreeView` в режиме дерева.

### `gtk_tree_store_new`

```nim
proc gtk_tree_store_new*(nColumns: gint): GtkTreeStore {.varargs.}
```

**Что делает.** Создаёт иерархическую модель с заданным числом столбцов и их типами — та же логика вариативного списка типов, что у `gtk_list_store_new`.

- `nColumns` — количество столбцов.
- Далее — `nColumns` значений `GType`, по одному на столбец.

```nim
let fileTreeStore = gtk_tree_store_new(1, G_TYPE_STRING)
echo "Иерархическая модель для дерева файлов создана"
```

---

### `gtk_tree_store_append` / `gtk_tree_store_prepend` / `gtk_tree_store_insert`

```nim
proc gtk_tree_store_append*(treeStore: GtkTreeStore, iter: ptr GtkTreeIter, parent: ptr GtkTreeIter)
proc gtk_tree_store_prepend*(treeStore: GtkTreeStore, iter: ptr GtkTreeIter, parent: ptr GtkTreeIter)
proc gtk_tree_store_insert*(treeStore: GtkTreeStore, iter: ptr GtkTreeIter, parent: ptr GtkTreeIter, position: gint)
```

**Что делает.** Та же логика, что у одноимённых функций `GtkListStore`, но с дополнительным параметром `parent` — итератором родительской строки. Передача `nil` вместо `parent` добавляет строку на верхний уровень дерева.

- `treeStore` — модель.
- `iter` — итератор, который будет заполнен указателем на новую строку.
- `parent` — итератор родительской строки, либо `nil` для верхнего уровня.
- `position` (для `insert`) — индекс вставки среди строк того же уровня.

```nim
var rootFolder, childFile: GtkTreeIter
gtk_tree_store_append(fileTreeStore, addr rootFolder, nil)
gtk_tree_store_append(fileTreeStore, addr childFile, addr rootFolder)
echo "Папка верхнего уровня и вложенный в неё файл добавлены"
```

---

### `gtk_tree_store_set`

```nim
proc gtk_tree_store_set*(treeStore: GtkTreeStore, iter: ptr GtkTreeIter) {.varargs.}
```

**Что делает.** Заполняет значения столбцов указанной строки — та же логика чередующихся пар (номер столбца, значение), завершённых `-1`, что у `gtk_list_store_set`.

- `treeStore` — модель.
- `iter` — строка, значения которой устанавливаются.
- Далее — чередующиеся пары (номер столбца, значение), завершённые `-1`.

```nim
gtk_tree_store_set(fileTreeStore, addr rootFolder, 0, "Проекты".cstring, -1)
gtk_tree_store_set(fileTreeStore, addr childFile, 0, "main.nim".cstring, -1)
echo "Названия папки и вложенного файла установлены"
```

---

### `gtk_tree_store_remove` / `gtk_tree_store_clear`

```nim
proc gtk_tree_store_remove*(treeStore: GtkTreeStore, iter: ptr GtkTreeIter): gboolean
proc gtk_tree_store_clear*(treeStore: GtkTreeStore)
```

**Что делает.** Удаляют строку вместе со всеми её дочерними строками и очищают дерево полностью.

- `treeStore` — модель.
- `iter` — итератор удаляемой строки (для `remove`).

```nim
discard gtk_tree_store_remove(fileTreeStore, addr childFile)
echo "Файл удалён из папки"
```

---

## GtkTreeView

`GtkTreeView` — виджет отображения `GtkTreeModel` в виде таблицы со столбцами, заголовками и раскрытием/сворачиванием узлов дерева.

### `gtk_tree_view_new` / `gtk_tree_view_new_with_model`

```nim
proc gtk_tree_view_new*(): GtkTreeView
proc gtk_tree_view_new_with_model*(model: GtkTreeModel): GtkTreeView
```

**Что делает.** Создают виджет отображения — пустой либо сразу с указанной моделью.

- `model` — модель данных (`GtkListStore`/`GtkTreeStore`, приводится к `GtkTreeModel`).

```nim
let contactsView = gtk_tree_view_new_with_model(cast[GtkTreeModel](contactsStore))
echo "Виджет отображения сразу подключён к модели контактов"
```

---

### `gtk_tree_view_set_model` / `gtk_tree_view_get_model`

```nim
proc gtk_tree_view_set_model*(treeView: GtkTreeView, model: GtkTreeModel)
proc gtk_tree_view_get_model*(treeView: GtkTreeView): GtkTreeModel
```

**Что делает.** Заменяют модель уже существующего виджета на другую и читают текущую подключённую модель.

- `treeView` — виджет отображения.
- `model` — новая модель данных.

```nim
gtk_tree_view_set_model(contactsView, cast[GtkTreeModel](otherContactsStore))
echo "Модель виджета заменена на другую"
```

---

### `gtk_tree_view_append_column` / `gtk_tree_view_insert_column` / `gtk_tree_view_remove_column`

```nim
proc gtk_tree_view_append_column*(treeView: GtkTreeView, column: GtkTreeViewColumn): gint
proc gtk_tree_view_insert_column*(treeView: GtkTreeView, column: GtkTreeViewColumn, position: gint): gint
proc gtk_tree_view_remove_column*(treeView: GtkTreeView, column: GtkTreeViewColumn): gint
```

**Что делает.** Добавляют заранее собранный столбец в конец, в произвольную позицию, либо убирают уже добавленный столбец. Все три возвращают новое общее количество столбцов после операции.

- `treeView` — виджет отображения.
- `column` — столбец (`GtkTreeViewColumn`).
- `position` (для `insert_column`) — индекс вставки.

```nim
let nameColumn = gtk_tree_view_column_new_with_attributes("Имя".cstring, nameCellRenderer, "text".cstring, 0, nil)
discard gtk_tree_view_append_column(contactsView, nameColumn)
echo "Столбец 'Имя' добавлен в виджет отображения"
```

---

### `gtk_tree_view_get_selection`

```nim
proc gtk_tree_view_get_selection*(treeView: GtkTreeView): GtkTreeSelection
```

**Что делает.** Возвращает объект выбора строк, связанный с этим виджетом.

- `treeView` — виджет отображения.

```nim
let selection = gtk_tree_view_get_selection(contactsView)
echo "Объект выбора строк получен"
```

---

### `gtk_tree_view_set_headers_visible` / `gtk_tree_view_get_headers_visible`

```nim
proc gtk_tree_view_set_headers_visible*(treeView: GtkTreeView, headersVisible: gboolean)
proc gtk_tree_view_get_headers_visible*(treeView: GtkTreeView): gboolean
```

**Что делает.** Показывают/скрывают строку заголовков столбцов целиком.

- `treeView` — виджет отображения.
- `headersVisible` — `0.gboolean`, чтобы скрыть заголовки.

```nim
gtk_tree_view_set_headers_visible(contactsView, 0.gboolean)
echo "Заголовки столбцов скрыты — виджет выглядит как простой список"
```

---

### `gtk_tree_view_expand_all` / `gtk_tree_view_collapse_all`

```nim
proc gtk_tree_view_expand_all*(treeView: GtkTreeView)
proc gtk_tree_view_collapse_all*(treeView: GtkTreeView)
```

**Что делает.** Раскрывают/сворачивают сразу все узлы дерева на всех уровнях вложенности — применимо только при подключённой модели `GtkTreeStore`.

- `treeView` — виджет отображения.

```nim
gtk_tree_view_expand_all(fileTreeView)
echo "Все папки дерева файлов развёрнуты"
```

---

## GtkTreeViewColumn

`GtkTreeViewColumn` — описание одного столбца `GtkTreeView`: какие рендереры ячеек показывать, к какому столбцу модели их привязать, заголовок, ширина.

### `gtk_tree_view_column_new` / `gtk_tree_view_column_new_with_attributes`

```nim
proc gtk_tree_view_column_new*(): GtkTreeViewColumn
proc gtk_tree_view_column_new_with_attributes*(title: cstring, cell: GtkCellRenderer, firstAttribute: cstring): GtkTreeViewColumn {.varargs.}
```

**Что делает.** `gtk_tree_view_column_new` создаёт пустой столбец без заголовка и рендерера. `gtk_tree_view_column_new_with_attributes` — укороченный способ: сразу задаёт заголовок, один рендерер и привязку его свойств к столбцам модели. Атрибуты передаются как чередующиеся пары "имя свойства рендерера"/"номер столбца модели", завершённые обязательным `nil`.

- `title` — заголовок столбца.
- `cell` — рендерер ячеек.
- `firstAttribute`, далее пары (имя свойства, номер столбца модели), завершённые `nil`.

```nim
let nameRenderer = gtk_cell_renderer_text_new()
let nameColumn = gtk_tree_view_column_new_with_attributes("Имя".cstring, nameRenderer, "text".cstring, 0, nil)
echo "Столбец 'Имя', показывающий текст из нулевого столбца модели, создан"
```

---

### `gtk_tree_view_column_pack_start` / `gtk_tree_view_column_pack_end` / `gtk_tree_view_column_add_attribute`

```nim
proc gtk_tree_view_column_pack_start*(treeColumn: GtkTreeViewColumn, cell: GtkCellRenderer, expand: gboolean)
proc gtk_tree_view_column_pack_end*(treeColumn: GtkTreeViewColumn, cell: GtkCellRenderer, expand: gboolean)
proc gtk_tree_view_column_add_attribute*(treeColumn: GtkTreeViewColumn, cellRenderer: GtkCellRenderer, attribute: cstring, column: gint)
```

**Что делает.** Пошаговая альтернатива `new_with_attributes` — актуальна, когда в одном столбце нужно показать сразу несколько рендереров (например, иконку и текст рядом). `pack_start`/`pack_end` добавляют рендерер в начало/конец столбца. `add_attribute` привязывает одно свойство рендерера к столбцу модели.

- `treeColumn` — столбец.
- `cell` — рендерер ячеек.
- `expand` — `1.gboolean`, чтобы рендерер забирал свободное место.
- `attribute` — имя свойства рендерера.
- `column` — номер столбца модели.

```nim
let iconColumn = gtk_tree_view_column_new()
let iconRenderer = gtk_cell_renderer_pixbuf_new()
let textRenderer = gtk_cell_renderer_text_new()
gtk_tree_view_column_pack_start(iconColumn, iconRenderer, 0.gboolean)
gtk_tree_view_column_pack_start(iconColumn, textRenderer, 1.gboolean)
gtk_tree_view_column_add_attribute(iconColumn, iconRenderer, "pixbuf".cstring, 0)
gtk_tree_view_column_add_attribute(iconColumn, textRenderer, "text".cstring, 1)
echo "Столбец с иконкой и текстом рядом собран из двух рендереров"
```

---

### `gtk_tree_view_column_set_title` / `gtk_tree_view_column_get_title`

```nim
proc gtk_tree_view_column_set_title*(treeColumn: GtkTreeViewColumn, title: cstring)
proc gtk_tree_view_column_get_title*(treeColumn: GtkTreeViewColumn): cstring
```

**Что делает.** Устанавливают и читают текст заголовка столбца уже после создания.

- `treeColumn` — столбец.
- `title` — новый текст заголовка.

```nim
gtk_tree_view_column_set_title(nameColumn, "Полное имя")
echo "Заголовок столбца изменён: ", $gtk_tree_view_column_get_title(nameColumn)
```

---

### `gtk_tree_view_column_set_resizable` / `get_resizable` / `set_visible` / `get_visible`

```nim
proc gtk_tree_view_column_set_resizable*(treeColumn: GtkTreeViewColumn, resizable: gboolean)
proc gtk_tree_view_column_get_resizable*(treeColumn: GtkTreeViewColumn): gboolean
proc gtk_tree_view_column_set_visible*(treeColumn: GtkTreeViewColumn, visible: gboolean)
proc gtk_tree_view_column_get_visible*(treeColumn: GtkTreeViewColumn): gboolean
```

**Что делает.** `resizable` разрешает менять ширину столбца перетаскиванием границы заголовка. `visible` показывает/скрывает столбец целиком, не удаляя его из виджета.

- `treeColumn` — столбец.
- `resizable`, `visible` — `1.gboolean`/`0.gboolean`.

```nim
gtk_tree_view_column_set_resizable(nameColumn, 1.gboolean)
echo "Столбец 'Имя' теперь можно растягивать мышью"
```

---

### `gtk_tree_view_column_clear`

```nim
proc gtk_tree_view_column_clear*(treeColumn: GtkTreeViewColumn)
```

**Что делает.** Убирает все рендереры ячеек, ранее добавленные в столбец, оставляя его пустым — нужен для полной пересборки содержимого столбца без создания нового объекта.

- `treeColumn` — столбец.

```nim
gtk_tree_view_column_clear(iconColumn)
echo "Все рендереры столбца убраны, столбец готов к повторной сборке"
```

---

## GtkCellRenderer

`GtkCellRenderer` — объект, отвечающий за отрисовку содержимого одной ячейки столбца (текст, флажок, изображение) на основе значения из соответствующего столбца модели.

### `gtk_cell_renderer_text_new` / `gtk_cell_renderer_toggle_new` / `gtk_cell_renderer_pixbuf_new`

```nim
proc gtk_cell_renderer_text_new*(): GtkCellRenderer
proc gtk_cell_renderer_toggle_new*(): GtkCellRenderer
proc gtk_cell_renderer_pixbuf_new*(): GtkCellRenderer
```

**Что делает.** Создают три самых частых типа рендерера: текст, флажок (интерактивный чекбокс в ячейке), изображение (обычно из столбца модели с `GdkPixbuf`).

- Параметров нет.

```nim
let textRenderer = gtk_cell_renderer_text_new()
let toggleRenderer = gtk_cell_renderer_toggle_new()
echo "Текстовый рендерер и рендерер флажка созданы"
```

---

### `gtk_cell_renderer_toggle_set_active` / `get_active` / `set_radio` / `get_radio`

```nim
proc gtk_cell_renderer_toggle_set_active*(cellRenderer: GtkCellRenderer, setting: gboolean)
proc gtk_cell_renderer_toggle_get_active*(cellRenderer: GtkCellRenderer): gboolean
proc gtk_cell_renderer_toggle_set_radio*(cellRenderer: GtkCellRenderer, radio: gboolean)
proc gtk_cell_renderer_toggle_get_radio*(cellRenderer: GtkCellRenderer): gboolean
```

**Что делает.** `set_active`/`get_active` управляют состоянием флажка рендерера как шаблона — как только рендерер привязан к столбцу модели через `add_attribute` со свойством `"active"`, фактическое состояние каждой ячейки берётся из строки модели. `set_radio`/`get_radio` переключают визуальный стиль между квадратным флажком и круглой радиокнопкой — чисто визуальная настройка, логика взаимоисключающего выбора между строками реализуется отдельно в обработчике сигнала `"toggled"`.

- `cellRenderer` — рендерер флажка.
- `setting` — `1.gboolean` для отмеченного состояния по умолчанию.
- `radio` — `1.gboolean` для визуального стиля радиокнопки.

```nim
gtk_cell_renderer_toggle_set_radio(toggleRenderer, 0.gboolean)
echo "Рендерер флажка настроен на визуальный стиль обычного чекбокса"
```

---

## GtkTreeSelection

`GtkTreeSelection` — объект, управляющий выбором строк в `GtkTreeView`, получаемый через `gtk_tree_view_get_selection`.

### `gtk_tree_selection_set_mode` / `gtk_tree_selection_get_mode`

```nim
proc gtk_tree_selection_set_mode*(selection: GtkTreeSelection, mode: GtkSelectionMode)
proc gtk_tree_selection_get_mode*(selection: GtkTreeSelection): GtkSelectionMode
```

**Что делает.** Задают режим выбора — та же логика и значения `GtkSelectionMode`, что у `gtk_list_box_set_selection_mode`.

- `selection` — объект выбора.
- `mode` — значение `GtkSelectionMode`.

```nim
gtk_tree_selection_set_mode(selection, GTK_SELECTION_MULTIPLE)
echo "В таблице контактов можно выбрать сразу несколько строк"
```

---

### `gtk_tree_selection_get_selected`

```nim
proc gtk_tree_selection_get_selected*(selection: GtkTreeSelection, model: ptr GtkTreeModel, iter: ptr GtkTreeIter): gboolean
```

**Что делает.** Возвращает выбранную строку (заполняя `iter`) и, опционально, модель (заполняя `model`, если не `nil`). В режиме `GTK_SELECTION_MULTIPLE` возвращает только одну (последнюю выбранную) строку. Возвращает `gboolean`, было ли что-то выбрано.

- `selection` — объект выбора.
- `model` — указатель для модели, либо `nil`.
- `iter` — указатель для итератора выбранной строки.

```nim
var selectedIter: GtkTreeIter
if gtk_tree_selection_get_selected(selection, nil, addr selectedIter) != 0.gboolean:
  echo "Есть выбранная строка, итератор получен"
else:
  echo "Ничего не выбрано"
```

---

### `gtk_tree_selection_select_iter` / `unselect_iter` / `select_all` / `unselect_all`

```nim
proc gtk_tree_selection_select_iter*(selection: GtkTreeSelection, iter: ptr GtkTreeIter)
proc gtk_tree_selection_unselect_iter*(selection: GtkTreeSelection, iter: ptr GtkTreeIter)
proc gtk_tree_selection_select_all*(selection: GtkTreeSelection)
proc gtk_tree_selection_unselect_all*(selection: GtkTreeSelection)
```

**Что делает.** Программно выбирают/снимают выбор с конкретной строки и со всех строк разом (`select_all`/`unselect_all` имеют смысл только в режиме `GTK_SELECTION_MULTIPLE`).

- `selection` — объект выбора.
- `iter` — итератор строки (для `select_iter`/`unselect_iter`).

```nim
gtk_tree_selection_select_iter(selection, addr newRow)
echo "Только что добавленная строка выбрана программно"
```

---

## GtkTreePath

`GtkTreePath` — независимый от итератора способ адресации строки через последовательность числовых индексов (например, `"2:1"`), удобный для сериализации позиции (в отличие от `GtkTreeIter`, теряющего действительность после изменения модели).

### `gtk_tree_path_new` / `gtk_tree_path_new_from_string`

```nim
proc gtk_tree_path_new*(): GtkTreePath
proc gtk_tree_path_new_from_string*(path: cstring): GtkTreePath
```

**Что делает.** `gtk_tree_path_new` создаёт пустой путь. `gtk_tree_path_new_from_string` разбирает путь из текста вида `"2:1"` (индексы через двоеточие) — более частый способ получить путь.

- `path` — строковое представление пути (для `new_from_string`).

```nim
let path = gtk_tree_path_new_from_string("0")
echo "Путь к первой строке верхнего уровня создан"
```

---

### `gtk_tree_path_to_string` / `gtk_tree_path_free`

```nim
proc gtk_tree_path_to_string*(path: GtkTreePath): cstring
proc gtk_tree_path_free*(path: GtkTreePath)
```

**Что делает.** `to_string` сериализует путь обратно в строку. `free` освобождает память объекта пути — в отличие от `GtkTreeIter`, `GtkTreePath` — отдельно выделяемый объект, требующий явного освобождения.

- `path` — путь.

```nim
echo "Строковое представление пути: ", $gtk_tree_path_to_string(path)
gtk_tree_path_free(path)
echo "Память объекта пути освобождена"
```

---

## GtkTreeModel

`GtkTreeModel` — общий интерфейс, реализуемый и `GtkListStore`, и `GtkTreeStore` — функции этого раздела работают одинаково с обоими.

### `gtk_tree_model_get_iter` / `gtk_tree_model_get_iter_first` / `gtk_tree_model_get_path`

```nim
proc gtk_tree_model_get_iter*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter, path: GtkTreePath): gboolean
proc gtk_tree_model_get_iter_first*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter): gboolean
proc gtk_tree_model_get_path*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter): GtkTreePath
```

**Что делает.** Преобразуют между `GtkTreePath` и `GtkTreeIter`: `get_iter` заполняет итератор по пути, `get_iter_first` — короткая форма для первой строки верхнего уровня. `get_path` строит `GtkTreePath` (который в итоге нужно освободить через `gtk_tree_path_free`) по итератору.

- `treeModel` — модель.
- `iter` — итератор.
- `path` — путь (для `get_iter`).

```nim
var firstRowIter: GtkTreeIter
if gtk_tree_model_get_iter_first(cast[GtkTreeModel](contactsStore), addr firstRowIter) != 0.gboolean:
  echo "Итератор первой строки модели получен"
```

---

### `gtk_tree_model_get_value`

```nim
proc gtk_tree_model_get_value*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter, column: gint, value: pointer)
```

**Что делает.** Читает значение указанного столбца строки в объект `GValue` — для получения самой строки/числа из заполненного `GValue` нужны отдельные функции `g_value_get_string`/`g_value_get_int`, не входящие в этот справочник.

- `treeModel` — модель.
- `iter` — итератор строки.
- `column` — номер столбца.
- `value` — указатель на структуру `GValue`.

```nim
gtk_tree_model_get_value(cast[GtkTreeModel](contactsStore), addr firstRowIter, 0, addr gvalue)
echo "Значение нулевого столбца первой строки прочитано в GValue"
```

---

### `gtk_tree_model_iter_next` / `gtk_tree_model_iter_previous`

```nim
proc gtk_tree_model_iter_next*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter): gboolean
proc gtk_tree_model_iter_previous*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter): gboolean
```

**Что делает.** Перемещают итератор к следующей/предыдущей строке того же уровня вложенности — основной способ обхода строк модели вручную.

- `treeModel` — модель.
- `iter` — итератор, который будет перемещён.

```nim
var iter: GtkTreeIter
discard gtk_tree_model_get_iter_first(cast[GtkTreeModel](contactsStore), addr iter)
while gtk_tree_model_iter_next(cast[GtkTreeModel](contactsStore), addr iter) != 0.gboolean:
  echo "Переход к следующей строке того же уровня"
```

---

### `gtk_tree_model_iter_children` / `iter_has_child` / `iter_n_children` / `iter_nth_child` / `iter_parent`

```nim
proc gtk_tree_model_iter_children*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter, parent: ptr GtkTreeIter): gboolean
proc gtk_tree_model_iter_has_child*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter): gboolean
proc gtk_tree_model_iter_n_children*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter): gint
proc gtk_tree_model_iter_nth_child*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter, parent: ptr GtkTreeIter, n: gint): gboolean
proc gtk_tree_model_iter_parent*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter, child: ptr GtkTreeIter): gboolean
```

**Что делает.** Навигация вглубь и обратно по иерархии дерева (для плоского `GtkListStore` `iter_has_child` всегда `0.gboolean`). `iter_children` заполняет `iter` первым дочерним элементом строки `parent` (`nil` — верхний уровень). `iter_has_child`/`iter_n_children` проверяют/считают дочерние строки. `iter_nth_child` — прямой доступ по индексу. `iter_parent` находит родителя строки `child`.

- `treeModel` — модель.
- `iter` — итератор, заполняемый результатом.
- `parent` — родительская строка (или `nil`).
- `n` — числовой индекс дочерней строки.
- `child` — строка, для которой ищется родитель.

```nim
if gtk_tree_model_iter_has_child(cast[GtkTreeModel](fileTreeStore), addr rootFolder) != 0.gboolean:
  echo "У папки есть ", gtk_tree_model_iter_n_children(cast[GtkTreeModel](fileTreeStore), addr rootFolder), " вложенных элементов"
  var firstChild: GtkTreeIter
  discard gtk_tree_model_iter_children(cast[GtkTreeModel](fileTreeStore), addr firstChild, addr rootFolder)
```

---

### `gtk_tree_model_get_string_from_iter`

```nim
proc gtk_tree_model_get_string_from_iter*(treeModel: GtkTreeModel, iter: ptr GtkTreeIter): cstring
```

**Что делает.** Короткая альтернатива связке `get_path` + `to_string` — сразу возвращает строковое представление позиции строки без промежуточного объекта `GtkTreePath`.

- `treeModel` — модель.
- `iter` — итератор строки.

```nim
let positionString = gtk_tree_model_get_string_from_iter(cast[GtkTreeModel](contactsStore), addr firstRowIter)
echo "Позиция строки в виде строки: ", $positionString
```

---

## Практические рецепты

### Простой список с одним текстовым столбцом

Минимальная сборка `GtkListStore` + `GtkTreeView` с одним столбцом — самый частый начальный сценарий.

```nim
proc buildSimpleContactsList(): GtkTreeView =
  let store = gtk_list_store_new(1, G_TYPE_STRING)

  for name in ["Анна Иванова", "Пётр Смирнов", "Мария Кузнецова"]:
    var iter: GtkTreeIter
    gtk_list_store_append(store, addr iter)
    gtk_list_store_set(store, addr iter, 0, name.cstring, -1)

  result = gtk_tree_view_new_with_model(cast[GtkTreeModel](store))
  let renderer = gtk_cell_renderer_text_new()
  let column = gtk_tree_view_column_new_with_attributes("Имя".cstring, renderer, "text".cstring, 0, nil)
  discard gtk_tree_view_append_column(result, column)
  echo "Список из трёх контактов с одним столбцом собран"

let contactsView = buildSimpleContactsList()
```

---

### Дерево с раскрывающимися узлами

Двухуровневая иерархия папка → файлы, отображаемая деревом.

```nim
proc buildFileTree(): GtkTreeView =
  let store = gtk_tree_store_new(1, G_TYPE_STRING)

  var projectsFolder: GtkTreeIter
  gtk_tree_store_append(store, addr projectsFolder, nil)
  gtk_tree_store_set(store, addr projectsFolder, 0, "Проекты".cstring, -1)

  for fileName in ["main.nim", "utils.nim"]:
    var fileIter: GtkTreeIter
    gtk_tree_store_append(store, addr fileIter, addr projectsFolder)
    gtk_tree_store_set(store, addr fileIter, 0, fileName.cstring, -1)

  result = gtk_tree_view_new_with_model(cast[GtkTreeModel](store))
  let renderer = gtk_cell_renderer_text_new()
  let column = gtk_tree_view_column_new_with_attributes("Файл".cstring, renderer, "text".cstring, 0, nil)
  discard gtk_tree_view_append_column(result, column)
  gtk_tree_view_expand_all(result)
  echo "Дерево 'Проекты' с двумя вложенными файлами собрано и развёрнуто"

let fileTreeView = buildFileTree()
```

---

### Столбец с флажками (чекбоксами) в каждой строке

Список задач с интерактивным чекбоксом "выполнено" в отдельном столбце.

```nim
proc onTaskToggled(cellRenderer: GtkCellRenderer, path: cstring, userData: gpointer) {.cdecl.} =
  let store = cast[GtkListStore](userData)
  let treePath = gtk_tree_path_new_from_string(path)
  var iter: GtkTreeIter
  if gtk_tree_model_get_iter(cast[GtkTreeModel](store), addr iter, treePath) != 0.gboolean:
    # Значение читается через GValue (не показано здесь для краткости) и инвертируется,
    # затем записывается обратно через gtk_list_store_set с новым булевым значением.
    echo "Флажок задачи переключён"
  gtk_tree_path_free(treePath)

proc buildTaskListWithCheckboxes(): GtkTreeView =
  let store = gtk_list_store_new(2, G_TYPE_BOOLEAN, G_TYPE_STRING)  # done, title

  var iter: GtkTreeIter
  gtk_list_store_append(store, addr iter)
  gtk_list_store_set(store, addr iter, 0, 0.gboolean, 1, "Написать отчёт".cstring, -1)

  result = gtk_tree_view_new_with_model(cast[GtkTreeModel](store))

  let toggleRenderer = gtk_cell_renderer_toggle_new()
  discard g_signal_connect(toggleRenderer, "toggled", onTaskToggled, cast[gpointer](store))
  let doneColumn = gtk_tree_view_column_new_with_attributes("Готово".cstring, toggleRenderer, "active".cstring, 0, nil)
  discard gtk_tree_view_append_column(result, doneColumn)

  let titleRenderer = gtk_cell_renderer_text_new()
  let titleColumn = gtk_tree_view_column_new_with_attributes("Задача".cstring, titleRenderer, "text".cstring, 1, nil)
  discard gtk_tree_view_append_column(result, titleColumn)

  echo "Список задач с интерактивным столбцом флажков собран"

let taskListView = buildTaskListWithCheckboxes()
```

---

### Обход всех строк модели вручную через итератор

Перебор всех строк верхнего уровня плоской модели, например для подсчёта или поиска.

```nim
proc countRows(store: GtkListStore): int =
  var iter: GtkTreeIter
  var hasRow = gtk_tree_model_get_iter_first(cast[GtkTreeModel](store), addr iter) != 0.gboolean
  while hasRow:
    result += 1
    hasRow = gtk_tree_model_iter_next(cast[GtkTreeModel](store), addr iter) != 0.gboolean

echo "Количество строк в модели: ", countRows(contactsStore)
```

---

### Реакция на выбор строки пользователем

Обработчик изменения выбора, читающий значение из выбранной строки.

```nim
proc onSelectionChanged(selection: GtkTreeSelection, userData: gpointer) {.cdecl.} =
  var iter: GtkTreeIter
  if gtk_tree_selection_get_selected(selection, nil, addr iter) != 0.gboolean:
    let path = gtk_tree_model_get_string_from_iter(cast[GtkTreeModel](contactsStore), addr iter)
    echo "Пользователь выбрал строку с позицией: ", $path

let selection = gtk_tree_view_get_selection(contactsView)
discard g_signal_connect(selection, "changed", onSelectionChanged, nil)
```

---

## Краткая таблица

| Процедура(ы) | Категория | Что делает вкратце |
|---|---|---|
| `gtk_list_store_new`, `newv` | ListStore | Создать плоскую модель с заданными столбцами |
| `gtk_list_store_append/prepend/insert` | ListStore | Добавить пустую строку |
| `gtk_list_store_set` | ListStore | Заполнить значения столбцов строки |
| `gtk_list_store_remove`, `clear` | ListStore | Удалить строку / очистить модель |
| `gtk_tree_store_new` | TreeStore | Создать иерархическую модель |
| `gtk_tree_store_append/prepend/insert` | TreeStore | Добавить строку (с родителем или без) |
| `gtk_tree_store_set` | TreeStore | Заполнить значения столбцов строки |
| `gtk_tree_store_remove`, `clear` | TreeStore | Удалить строку с потомками / очистить дерево |
| `gtk_tree_view_new`, `_with_model` | TreeView | Создать виджет отображения |
| `gtk_tree_view_set/get_model` | TreeView | Подключённая модель данных |
| `gtk_tree_view_append/insert/remove_column` | TreeView | Управление столбцами |
| `gtk_tree_view_get_selection` | TreeView | Объект выбора строк |
| `gtk_tree_view_set/get_headers_visible` | TreeView | Строка заголовков столбцов |
| `gtk_tree_view_expand_all`, `collapse_all` | TreeView | Раскрыть/свернуть все узлы дерева |
| `gtk_tree_view_column_new`, `_with_attributes` | TreeViewColumn | Создать столбец |
| `gtk_tree_view_column_pack_start/end`, `add_attribute` | TreeViewColumn | Пошаговая сборка нескольких рендереров в столбце |
| `gtk_tree_view_column_set/get_title` | TreeViewColumn | Заголовок столбца |
| `gtk_tree_view_column_set/get_resizable`, `set/get_visible` | TreeViewColumn | Изменение размера и видимость столбца |
| `gtk_tree_view_column_clear` | TreeViewColumn | Убрать все рендереры столбца |
| `gtk_cell_renderer_text/toggle/pixbuf_new` | CellRenderer | Создать рендерер текста/флажка/изображения |
| `gtk_cell_renderer_toggle_set/get_active`, `set/get_radio` | CellRenderer | Состояние и визуальный стиль флажка |
| `gtk_tree_selection_set/get_mode` | TreeSelection | Режим выбора строк |
| `gtk_tree_selection_get_selected` | TreeSelection | Текущая выбранная строка |
| `gtk_tree_selection_select/unselect_iter`, `select/unselect_all` | TreeSelection | Программное управление выбором |
| `gtk_tree_path_new`, `_from_string` | TreePath | Создать путь к строке |
| `gtk_tree_path_to_string`, `free` | TreePath | Сериализация и освобождение пути |
| `gtk_tree_model_get_iter`, `get_iter_first`, `get_path` | TreeModel | Преобразование путь ↔ итератор |
| `gtk_tree_model_get_value` | TreeModel | Значение столбца строки через GValue |
| `gtk_tree_model_iter_next`, `iter_previous` | TreeModel | Обход строк одного уровня |
| `gtk_tree_model_iter_children`, `has_child`, `n_children`, `nth_child`, `parent` | TreeModel | Навигация по иерархии дерева |
| `gtk_tree_model_get_string_from_iter` | TreeModel | Короткое строковое представление позиции |

---

## Сводка: какую процедуру выбрать

- **Новый код, не связанный переносом существующей кодовой базы с GTK3** → предпочесть современный `GtkColumnView`/`GtkListView` (отдельный справочник), а не начинать с `GtkTreeView` — весь API этого справочника официально устарел.
- **Данные без иерархии** (простой список записей) → `GtkListStore`. **Данные с вложенностью** (файлы и папки, структура категорий) → `GtkTreeStore`.
- **Столбец показывает одно значение простым способом** → `gtk_tree_view_column_new_with_attributes` с одним рендерером. **В одной ячейке нужно показать несколько элементов сразу** (иконка + текст) → пошаговая сборка через `pack_start`/`pack_end`/`add_attribute` на пустом столбце от `gtk_tree_view_column_new`.
- **Нужно временно скрыть столбец, сохранив возможность вернуть его позже** → `gtk_tree_view_column_set_visible(column, false)`, а не `gtk_tree_view_remove_column` — `remove_column` требует заново пересобирать столбец при возврате.
- **Позиция строки должна пережить последующие изменения модели** (сохранена во внешней структуре, передана между функциями не сразу) → `GtkTreePath` (через `gtk_tree_model_get_path`/`get_string_from_iter`), а не сохранённая копия `GtkTreeIter`, которая, как и `GtkTextIter`, теряет действительность при изменении модели.
- **Обход всех строк модели вручную** → цепочка `get_iter_first` + `iter_next` в цикле для одного уровня; `iter_children`/`iter_has_child`/`iter_n_children` — для рекурсивного обхода вложенных уровней дерева.
- **Столбец с интерактивным флажком в каждой строке** → `GtkCellRendererToggle`, привязанный к булеву столбцу модели через свойство `"active"`, с обработчиком сигнала `"toggled"` самого рендерера (не путать с `gtk_cell_renderer_toggle_set_active` — это лишь значение-шаблон, не связанное с конкретной строкой после привязки к модели).
