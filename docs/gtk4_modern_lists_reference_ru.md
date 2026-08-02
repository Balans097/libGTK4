# GTK4 (modern lists: GtkListView / GtkColumnView / GtkGridView / GtkDropDown) — справочник модуля

> **Импорт:** `import libGTK4`
> **Область применения:** современная система списков и таблиц GTK4, официальная замена устаревшего семейства `GtkTreeView` из части 14 этой серии. Семнадцатая, завершающая содержательная часть серии справочников по обёртке.

## Важное замечание об ограничении этой обёртки

Современные списковые виджеты GTK4 строятся на интерфейсе `GListModel` из GIO — универсальном источнике данных (список произвольных `GObject`-объектов), над которым `GtkSelectionModel` (раздел II) надстраивает логику выбора, а `GtkListView`/`GtkColumnView`/`GtkGridView` — визуальное представление. **В этой версии обёртки нет биндингов для `GListStore`** — стандартной, самой обычной реализации `GListModel` для хранения списка собственных объектов приложения (`g_list_store_new`, `g_list_store_append` и т.д. отсутствуют). Единственный готовый источник данных, доступный напрямую в этой обёртке, — `GtkStringList` (раздел I), реализующий `GListModel` специально для списка строк. Для отображения списка **произвольных** объектов (не просто строк) через `GtkListView`/`GtkColumnView` в текущем состоянии обёртки потребуется либо получить готовый `GListModel` откуда-то ещё (например, из другого GIO-API, не входящего в этот справочник), либо использовать `GtkStringList` с последующим преобразованием строки в нужный объект внутри фабрики элементов (раздел III).

---

## Оглавление

I. [GtkStringList](#gtkstringlist)
&nbsp;&nbsp;1. [`gtk_string_list_new`](#gtk_string_list_new)
&nbsp;&nbsp;2. [`gtk_string_list_append` / `gtk_string_list_take` / `gtk_string_list_remove` / `gtk_string_list_splice`](#gtk_string_list_append--gtk_string_list_take--gtk_string_list_remove--gtk_string_list_splice)
&nbsp;&nbsp;3. [`gtk_string_list_get_string`](#gtk_string_list_get_string)
&nbsp;&nbsp;4. [`gtk_string_object_new` / `gtk_string_object_get_string`](#gtk_string_object_new--gtk_string_object_get_string)

II. [GtkSelectionModel и его реализации](#gtkselectionmodel-и-его-реализации)
&nbsp;&nbsp;1. [`gtk_selection_model_is_selected`, `get_selection`, `get_selection_in_range`](#gtk_selection_model_is_selected-get_selection-get_selection_in_range)
&nbsp;&nbsp;2. [`gtk_selection_model_select_item`, `unselect_item`, `select_range`, `unselect_range`, `select_all`, `unselect_all`, `set_selection`](#gtk_selection_model_select_item-unselect_item-select_range-unselect_range-select_all-unselect_all-set_selection)
&nbsp;&nbsp;3. [`gtk_single_selection_new` и свойства](#gtk_single_selection_new-и-свойства)
&nbsp;&nbsp;4. [`gtk_multi_selection_new` / `gtk_no_selection_new`](#gtk_multi_selection_new--gtk_no_selection_new)

III. [GtkListItem и GtkListItemFactory](#gtklistitem-и-gtklistitemfactory)
&nbsp;&nbsp;1. [`gtk_signal_list_item_factory_new`](#gtk_signal_list_item_factory_new)
&nbsp;&nbsp;2. [`gtk_list_item_get_item` / `get_position` / `get_selected`](#gtk_list_item_get_item--get_position--get_selected)
&nbsp;&nbsp;3. [`gtk_list_item_get/set_child`](#gtk_list_item_getset_child)
&nbsp;&nbsp;4. [`gtk_list_item_get/set_selectable`, `get/set_activatable`](#gtk_list_item_getset_selectable-getset_activatable)

IV. [GtkListView](#gtklistview)
&nbsp;&nbsp;1. [`gtk_list_view_new`](#gtk_list_view_new)
&nbsp;&nbsp;2. [`gtk_list_view_get/set_model`, `get/set_factory`](#gtk_list_view_getset_model-getset_factory)
&nbsp;&nbsp;3. [`gtk_list_view_get/set_show_separators`](#gtk_list_view_getset_show_separators)
&nbsp;&nbsp;4. [`gtk_list_view_get/set_single_click_activate`](#gtk_list_view_getset_single_click_activate)
&nbsp;&nbsp;5. [`gtk_list_view_get/set_enable_rubberband`](#gtk_list_view_getset_enable_rubberband)

V. [GtkColumnView и GtkColumnViewColumn](#gtkcolumnview-и-gtkcolumnviewcolumn)
&nbsp;&nbsp;1. [`gtk_column_view_new`](#gtk_column_view_new)
&nbsp;&nbsp;2. [`gtk_column_view_append_column`, `insert_column`, `remove_column`, `get_columns`](#gtk_column_view_append_column-insert_column-remove_column-get_columns)
&nbsp;&nbsp;3. [`gtk_column_view_get/set_model`](#gtk_column_view_getset_model)
&nbsp;&nbsp;4. [`gtk_column_view_get/set_show_row_separators`, `show_column_separators`, `reorderable`](#gtk_column_view_getset_show_row_separators-show_column_separators-reorderable)
&nbsp;&nbsp;5. [`gtk_column_view_column_new`](#gtk_column_view_column_new)
&nbsp;&nbsp;6. [`gtk_column_view_column_get/set_title`, `get/set_visible`, `get/set_resizable`, `get/set_expand`, `get/set_fixed_width`](#gtk_column_view_column_getset_title-getset_visible-getset_resizable-getset_expand-getset_fixed_width)

VI. [GtkGridView](#gtkgridview)
&nbsp;&nbsp;1. [`gtk_grid_view_new`](#gtk_grid_view_new)
&nbsp;&nbsp;2. [`gtk_grid_view_get/set_min_columns`, `get/set_max_columns`](#gtk_grid_view_getset_min_columns-getset_max_columns)

VII. [GtkDropDown](#gtkdropdown)
&nbsp;&nbsp;1. [`gtk_drop_down_new` / `gtk_drop_down_new_from_strings`](#gtk_drop_down_new--gtk_drop_down_new_from_strings)
&nbsp;&nbsp;2. [`gtk_drop_down_get/set_selected`, `get_selected_item`](#gtk_drop_down_getset_selected-get_selected_item)
&nbsp;&nbsp;3. [`gtk_drop_down_get/set_enable_search`](#gtk_drop_down_getset_enable_search)

VIII. [Практические рецепты](#практические-рецепты)
&nbsp;&nbsp;1. [Простой список строк на GtkListView](#простой-список-строк-на-gtklistview)
&nbsp;&nbsp;2. [Таблица с несколькими столбцами на GtkColumnView](#таблица-с-несколькими-столбцами-на-gtkcolumnview)
&nbsp;&nbsp;3. [Выпадающий список на GtkDropDown вместо GtkComboBoxText](#выпадающий-список-на-gtkdropdown-вместо-gtkcomboboxtext)
&nbsp;&nbsp;4. [Сетка превью изображений на GtkGridView](#сетка-превью-изображений-на-gtkgridview)
&nbsp;&nbsp;5. [Реакция на изменение выбора в GtkSingleSelection](#реакция-на-изменение-выбора-в-gtksingleselection)

IX. [Краткая таблица](#краткая-таблица)

X. [Сводка: какую процедуру выбрать](#сводка-какую-процедуру-выбрать)

---

## GtkStringList

`GtkStringList` — простая реализация `GListModel`, хранящая список строк, — единственный источник данных для списковых виджетов, полностью доступный в этой обёртке без выхода за её пределы.

### `gtk_string_list_new`

```nim
proc gtk_string_list_new*(strings: ptr cstring): GtkStringList
```

**Что делает.** Создаёт список строк сразу из массива — `NULL`-терминированный массив `cstring` (тот же протокол, что у `gtk_about_dialog_set_authors` из справочника по диалогам и медиа). Передача массива из одного `nil` создаёт пустой список.

- `strings` — массив строк, завершённый `nil`.

```nim
var initialItems = [cstring("Россия"), cstring("Германия"), cstring("Франция"), nil]
let countryList = gtk_string_list_new(addr initialItems[0])
echo "Список строк создан с тремя начальными элементами"
```

---

### `gtk_string_list_append` / `gtk_string_list_take` / `gtk_string_list_remove` / `gtk_string_list_splice`

```nim
proc gtk_string_list_append*(self: GtkStringList, str: cstring)
proc gtk_string_list_take*(self: GtkStringList, str: cstring)
proc gtk_string_list_remove*(self: GtkStringList, position: guint)
proc gtk_string_list_splice*(self: GtkStringList, position: guint, nRemovals: guint, additions: ptr cstring)
```

**Что делает.** `append` добавляет строку в конец, копируя её содержимое. `take` — то же самое, но "забирает" уже выделенную через аллокатор GLib строку (например, результат `g_strdup_printf` из справочника по GLib-утилитам) без дополнительного копирования — вызывающий код не должен освобождать переданную строку сам, `GtkStringList` берёт на себя владение ею. `remove` убирает элемент по индексу. `splice` — универсальная операция "удалить `nRemovals` элементов начиная с `position` и вставить на их место элементы из `additions`" за одну операцию (аналог `Array.splice` в других языках) — удобна для пакетного обновления списка одним вызовом вместо серии отдельных `remove`/`append`.

- `self` — список строк.
- `str` — добавляемая строка.
- `position` — индекс.
- `nRemovals` — сколько элементов удалить, начиная с `position`.
- `additions` — массив вставляемых строк, завершённый `nil`.

```nim
gtk_string_list_append(countryList, "Япония")
echo "Строка добавлена в конец списка"
```

---

### `gtk_string_list_get_string`

```nim
proc gtk_string_list_get_string*(self: GtkStringList, position: guint): cstring
```

**Что делает.** Возвращает строку по индексу — прямой доступ к элементу без промежуточного объекта `GtkStringObject` (следующий подраздел), для случаев, когда позиция уже известна (например, после `gtk_single_selection_get_selected` из раздела II).

- `self` — список строк.
- `position` — индекс.

```nim
echo "Элемент под индексом 0: ", $gtk_string_list_get_string(countryList, 0)
```

---

### `gtk_string_object_new` / `gtk_string_object_get_string`

```nim
proc gtk_string_object_new*(str: cstring): GtkStringObject
proc gtk_string_object_get_string*(self: GtkStringObject): cstring
```

**Что делает.** `GtkStringObject` — обёртка одной строки в полноценный `GObject`, то, что фактически возвращает `gtk_list_item_get_item` (раздел III) для элемента, происходящего из `GtkStringList`, — списковым виджетам GTK4 в общем случае нужны именно объекты (`GListModel` хранит `GObject`, а не сырые примитивы), а не голые строки. `gtk_string_object_new` нужен редко в прикладном коде напрямую (обычно объекты этого типа только читаются, получаемые от `GtkStringList`, а не создаются вручную); `get_string` — извлечение строки обратно из такого объекта внутри фабрики элементов.

- `str` — строка (для `new`).
- `self` — объект-обёртка строки (для `get_string`).

```nim
proc onBind(factory: GtkSignalListItemFactory, listItem: GtkListItem, userData: gpointer) {.cdecl.} =
  let stringObj = cast[GtkStringObject](gtk_list_item_get_item(listItem))
  let text = $gtk_string_object_get_string(stringObj)
  echo "Элемент строки: ", text
```

---

## GtkSelectionModel и его реализации

`GtkSelectionModel` — интерфейс, надстраивающий логику выбора над произвольным `GListModel` (в этой обёртке — практически всегда над `GtkStringList`, см. предупреждение в начале справочника). Три готовые реализации отличаются тем, сколько элементов могут быть выбраны одновременно: `GtkSingleSelection` — не больше одного, `GtkMultiSelection` — произвольное число, `GtkNoSelection` — выбор полностью отключён (для чисто отображающих списков без интерактивности).

### `gtk_selection_model_is_selected`, `get_selection`, `get_selection_in_range`

```nim
proc gtk_selection_model_is_selected*(model: GtkSelectionModel, position: guint): gboolean
proc gtk_selection_model_get_selection*(model: GtkSelectionModel): pointer
proc gtk_selection_model_get_selection_in_range*(model: GtkSelectionModel, position: guint, nItems: guint): pointer
```

**Что делает.** `is_selected` — выбран ли элемент с указанным индексом. `get_selection` возвращает набор всех выбранных индексов целиком как `GtkBitset` (компактная структура для представления множества индексов, объявленная в базовых типах обёртки, но без отдельных функций работы с ней в этом наборе — для перебора индексов внутри неё нужны функции `gtk_bitset_*`, не входящие в этот справочник). `get_selection_in_range` — то же самое, но ограниченное диапазоном индексов, что эффективнее для больших списков, если интересует только видимая на экране часть.

- `model` — модель выбора.
- `position` — индекс элемента (для `is_selected`).
- `nItems` — размер диапазона (для `_in_range`).

```nim
echo "Элемент с индексом 3 выбран: ", gtk_selection_model_is_selected(selectionModel, 3) != 0.gboolean
```

---

### `gtk_selection_model_select_item`, `unselect_item`, `select_range`, `unselect_range`, `select_all`, `unselect_all`, `set_selection`

```nim
proc gtk_selection_model_select_item*(model: GtkSelectionModel, position: guint, unselectRest: gboolean): gboolean
proc gtk_selection_model_unselect_item*(model: GtkSelectionModel, position: guint): gboolean
proc gtk_selection_model_select_range*(model: GtkSelectionModel, position: guint, nItems: guint, unselectRest: gboolean): gboolean
proc gtk_selection_model_unselect_range*(model: GtkSelectionModel, position: guint, nItems: guint): gboolean
proc gtk_selection_model_select_all*(model: GtkSelectionModel): gboolean
proc gtk_selection_model_unselect_all*(model: GtkSelectionModel): gboolean
proc gtk_selection_model_set_selection*(model: GtkSelectionModel, selected: pointer, mask: pointer): gboolean
```

**Что делает.** Программное управление выбором — по одному элементу, по диапазону, либо сразу всё/ничего. `unselectRest` определяет, снимать ли выбор со всех остальных элементов при выборе нового (`1.gboolean` — обычное поведение одиночного клика, `0.gboolean` — добавить к уже выбранным, как при `Ctrl+клик`). Для `GtkSingleSelection` вызовы, противоречащие однократному выбору (например, `select_range` с несколькими элементами), не имеют смысла и будут проигнорированы моделью. `set_selection` — низкоуровневая операция с явным битовым множеством (`GtkBitset`, как и в предыдущем подразделе) и маской, какие биты вообще затрагивать, — используется редко напрямую.

- `model` — модель выбора.
- `position` — индекс элемента.
- `nItems` — размер диапазона.
- `unselectRest` — `1.gboolean`, чтобы снять выбор с остальных элементов.

```nim
discard gtk_selection_model_select_item(selectionModel, 0, 1.gboolean)
echo "Первый элемент выбран, выбор с остальных снят"
```

---

### `gtk_single_selection_new` и свойства

```nim
proc gtk_single_selection_new*(model: pointer): GtkSingleSelection
proc gtk_single_selection_get_model*(self: GtkSingleSelection): pointer
proc gtk_single_selection_set_model*(self: GtkSingleSelection, model: pointer)
proc gtk_single_selection_get_selected*(self: GtkSingleSelection): guint
proc gtk_single_selection_set_selected*(self: GtkSingleSelection, position: guint)
proc gtk_single_selection_get_selected_item*(self: GtkSingleSelection): gpointer
proc gtk_single_selection_get_autoselect*(self: GtkSingleSelection): gboolean
proc gtk_single_selection_set_autoselect*(self: GtkSingleSelection, autoselect: gboolean)
proc gtk_single_selection_get_can_unselect*(self: GtkSingleSelection): gboolean
proc gtk_single_selection_set_can_unselect*(self: GtkSingleSelection, canUnselect: gboolean)
```

**Что делает.** Оборачивает произвольный `GListModel` (`model`, приводится к `pointer` — практически всегда `GtkStringList` в этой обёртке) в модель с выбором не более одного элемента. `get_selected`/`set_selected` — прямой доступ к индексу текущего выбора (`GTK_INVALID_LIST_POSITION`, равное `guint.high` — специальное значение "ничего не выбрано", а не `-1`, поскольку `guint` беззнаковый). `get_selected_item` — сразу сам объект (тот же `GtkStringObject` для `GtkStringList`), а не только индекс. `autoselect` — если включено (по умолчанию), модель гарантирует, что всегда выбран хотя бы один элемент, как только список не пуст (нельзя перевести в состояние "ничего не выбрано" программно). `can_unselect` — можно ли пользователю кликом снять выбор с уже выбранного элемента, оставшись без выбора вовсе (актуально только при выключенном `autoselect`).

- `model` — оборачиваемый `GListModel`.
- `self` — модель выбора.
- `position` — индекс.
- `autoselect`, `canUnselect` — `1.gboolean`/`0.gboolean`.

```nim
let selectionModel = gtk_single_selection_new(cast[pointer](countryList))
gtk_single_selection_set_selected(selectionModel, 0)
echo "Первая страна выбрана по умолчанию"
```

---

### `gtk_multi_selection_new` / `gtk_no_selection_new`

```nim
proc gtk_multi_selection_new*(model: pointer): GtkMultiSelection
proc gtk_multi_selection_get_model*(self: GtkMultiSelection): pointer
proc gtk_multi_selection_set_model*(self: GtkMultiSelection, model: pointer)
proc gtk_no_selection_new*(model: pointer): GtkNoSelection
proc gtk_no_selection_get_model*(self: GtkNoSelection): pointer
proc gtk_no_selection_set_model*(self: GtkNoSelection, model: pointer)
```

**Что делает.** `GtkMultiSelection` оборачивает `GListModel` в модель, допускающую выбор произвольного числа элементов сразу (управляется общими функциями `gtk_selection_model_*` из предыдущего подраздела — у самого `GtkMultiSelection` нет специфичных для множественного выбора функций сверх базового интерфейса). `GtkNoSelection` — обёртка без какой-либо возможности выбора вовсе, для списков, предназначенных только для отображения (например, журнал событий, где клик по строке ничего не выбирает).

- `model` — оборачиваемый `GListModel`.
- `self` — модель выбора.

```nim
let multiSelection = gtk_multi_selection_new(cast[pointer](countryList))
echo "Модель с возможностью выбора нескольких стран сразу создана"

let readOnlyModel = gtk_no_selection_new(cast[pointer](logEntriesList))
echo "Модель для журнала событий без возможности выбора создана"
```

---

## GtkListItem и GtkListItemFactory

В отличие от устаревшего `GtkTreeView` (часть 14), современные списковые виджеты используют настоящий виджет для каждой строки, создаваемый и переиспользуемый фабрикой (`GtkListItemFactory`) — GTK создаёт заметно меньше виджетов, чем элементов в списке, переиспользуя их при прокрутке. `GtkListItem` — обёртка вокруг одной переиспользуемой строки, передаваемая в обработчики сигналов фабрики.

### `gtk_signal_list_item_factory_new`

```nim
proc gtk_signal_list_item_factory_new*(): GtkSignalListItemFactory
```

**Что делает.** Создаёт фабрику, управляемую через сигналы. Настройка происходит через четыре сигнала: `"setup"` (создать структуру виджета строки один раз), `"bind"` (связать виджет с конкретными данными строки — вызывается при каждом переиспользовании), `"unbind"` (отвязать перед переиспользованием), `"teardown"` (виджет уничтожается окончательно). Обязательны как минимум `"setup"` и `"bind"`.

- Параметров нет.

```nim
let factory = gtk_signal_list_item_factory_new()

proc onSetup(factory: GtkSignalListItemFactory, listItem: GtkListItem, userData: gpointer) {.cdecl.} =
  let label = gtk_label_new("")
  gtk_list_item_set_child(listItem, label)

proc onBind(factory: GtkSignalListItemFactory, listItem: GtkListItem, userData: gpointer) {.cdecl.} =
  let stringObj = cast[GtkStringObject](gtk_list_item_get_item(listItem))
  let label = cast[GtkLabel](gtk_list_item_get_child(listItem))
  gtk_label_set_text(label, gtk_string_object_get_string(stringObj))

discard g_signal_connect(factory, "setup", onSetup, nil)
discard g_signal_connect(factory, "bind", onBind, nil)
echo "Фабрика элементов настроена: каждая строка — это GtkLabel с текстом строки"
```

---

### `gtk_list_item_get_item` / `get_position` / `get_selected`

```nim
proc gtk_list_item_get_item*(self: GtkListItem): gpointer
proc gtk_list_item_get_position*(self: GtkListItem): guint
proc gtk_list_item_get_selected*(self: GtkListItem): gboolean
```

**Что делает.** Внутри обработчика `"bind"` сообщают, с какими данными связан виджет строки. `get_item` — сам объект данных (`GtkStringObject` для `GtkStringList`). `get_position` — индекс элемента в модели. `get_selected` — выбран ли этот элемент прямо сейчас.

- `self` — обёртка строки.

```nim
proc onBindWithHighlight(factory: GtkSignalListItemFactory, listItem: GtkListItem, userData: gpointer) {.cdecl.} =
  let label = cast[GtkLabel](gtk_list_item_get_child(listItem))
  if gtk_list_item_get_selected(listItem) != 0.gboolean:
    gtk_widget_add_css_class(label, "selected-item-text")
  echo "Строка с индексом ", gtk_list_item_get_position(listItem), " связана с данными"
```

---

### `gtk_list_item_get/set_child`

```nim
proc gtk_list_item_get_child*(self: GtkListItem): GtkWidget
proc gtk_list_item_set_child*(self: GtkListItem, child: GtkWidget)
```

**Что делает.** Устанавливают и читают виджет строки — тот же паттерн "один слот содержимого". `set_child` вызывается один раз в `"setup"`; `get_child` — в `"bind"`/`"unbind"` для получения уже созданного виджета.

- `self` — обёртка строки.
- `child` — виджет строки.

```nim
gtk_list_item_set_child(listItem, gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 8))
echo "Виджет строки установлен как горизонтальный контейнер"
```

---

### `gtk_list_item_get/set_selectable`, `get/set_activatable`

```nim
proc gtk_list_item_get_selectable*(self: GtkListItem): gboolean
proc gtk_list_item_set_selectable*(self: GtkListItem, selectable: gboolean)
proc gtk_list_item_get_activatable*(self: GtkListItem): gboolean
proc gtk_list_item_set_activatable*(self: GtkListItem, activatable: gboolean)
```

**Что делает.** `selectable` — может ли конкретная строка быть выбрана (полезно для строк-разделителей секций). `activatable` — может ли строка быть "активирована" (двойной клик/Enter) — та же концепция, что у `GtkListBox`.

- `self` — обёртка строки.
- `selectable`, `activatable` — `1.gboolean`/`0.gboolean`.

```nim
gtk_list_item_set_selectable(sectionHeaderItem, 0.gboolean)
echo "Строка-заголовок секции не может быть выбрана пользователем"
```

---

## GtkListView

`GtkListView` — вертикальный список строк, отображающий модель данных через фабрику элементов (разделы I–III), функциональный современный аналог `GtkListBox` (справочник по многовидовым контейнерам) для больших списков — в отличие от `GtkListBox`, где каждая строка создаётся вручную и хранится как отдельный виджет всегда, `GtkListView` виртуализирует строки (не создаёт виджеты для строк, находящихся вне видимой области) и подходит для списков с тысячами и более элементов, где `GtkListBox` стал бы неэффективным.

### `gtk_list_view_new`

```nim
proc gtk_list_view_new*(model: GtkSelectionModel, factory: GtkListItemFactory): GtkListView
```

**Что делает.** Создаёт список сразу с моделью выбора и фабрикой элементов. Оба параметра можно передать как `nil` и установить позже через `set_model`/`set_factory` (следующий подраздел) — например, если фабрика конструируется в несколько этапов до того, как список готов к показу.

- `model` — модель выбора (`GtkSingleSelection`/`GtkMultiSelection`/`GtkNoSelection`, приводится к `GtkSelectionModel`).
- `factory` — фабрика элементов (`GtkSignalListItemFactory`, приводится к `GtkListItemFactory`).

```nim
let countryListView = gtk_list_view_new(cast[GtkSelectionModel](selectionModel), cast[GtkListItemFactory](factory))
echo "Список стран создан с моделью выбора и фабрикой строк"
```

---

### `gtk_list_view_get/set_model`, `get/set_factory`

```nim
proc gtk_list_view_get_model*(self: GtkListView): GtkSelectionModel
proc gtk_list_view_set_model*(self: GtkListView, model: GtkSelectionModel)
proc gtk_list_view_get_factory*(self: GtkListView): GtkListItemFactory
proc gtk_list_view_set_factory*(self: GtkListView, factory: GtkListItemFactory)
```

**Что делает.** Заменяют модель/фабрику уже существующего виджета на другую — например, при переключении между разными наборами данных, отображаемыми одним и тем же списком (аналог `gtk_tree_view_set_model` из части 14, но для современного API).

- `self` — список.
- `model` — новая модель выбора.
- `factory` — новая фабрика элементов.

```nim
gtk_list_view_set_model(countryListView, cast[GtkSelectionModel](otherSelectionModel))
echo "Модель списка заменена на другую"
```

---

### `gtk_list_view_get/set_show_separators`

```nim
proc gtk_list_view_get_show_separators*(self: GtkListView): gboolean
proc gtk_list_view_set_show_separators*(self: GtkListView, showSeparators: gboolean)
```

**Что делает.** Показывают/скрывают тонкие разделительные линии между строками списка — чисто визуальная настройка.

- `self` — список.
- `showSeparators` — `1.gboolean`, чтобы показывать линии между строками.

```nim
gtk_list_view_set_show_separators(countryListView, 1.gboolean)
echo "Между строками списка теперь видны разделительные линии"
```

---

### `gtk_list_view_get/set_single_click_activate`

```nim
proc gtk_list_view_get_single_click_activate*(self: GtkListView): gboolean
proc gtk_list_view_set_single_click_activate*(self: GtkListView, singleClickActivate: gboolean)
```

**Что делает.** Определяют, активируется ли строка (сигнал `"activate"`) одним кликом (типично для списков-меню, где клик сразу выполняет действие) или требуется двойной клик/Enter (типично для списков файлов, где один клик — только выбор, а открытие — отдельное действие). Выключено по умолчанию (нужен двойной клик).

- `self` — список.
- `singleClickActivate` — `1.gboolean` для активации одним кликом.

```nim
gtk_list_view_set_single_click_activate(menuStyleListView, 1.gboolean)
echo "Список ведёт себя как меню — один клик сразу активирует пункт"
```

---

### `gtk_list_view_get/set_enable_rubberband`

```nim
proc gtk_list_view_get_enable_rubberband*(self: GtkListView): gboolean
proc gtk_list_view_set_enable_rubberband*(self: GtkListView, enableRubberband: gboolean)
```

**Что делает.** Включают/выключают выделение нескольких строк перетаскиванием прямоугольной рамки мышью по пустому пространству списка (тот же приём, что в файловых менеджерах для выделения группы файлов) — имеет смысл только при модели выбора, допускающей несколько элементов (`GtkMultiSelection`).

- `self` — список.
- `enableRubberband` — `1.gboolean`, чтобы разрешить выделение рамкой.

```nim
gtk_list_view_set_enable_rubberband(multiSelectListView, 1.gboolean)
echo "Выделение нескольких строк перетаскиванием рамки включено"
```

---

## GtkColumnView и GtkColumnViewColumn

`GtkColumnView` — табличное представление той же модели данных, что и `GtkListView`, но с несколькими столбцами, каждый со своей фабрикой элементов — современный аналог `GtkTreeView` в табличном режиме (часть 14), с той же виртуализацией, что у `GtkListView`.

### `gtk_column_view_new`

```nim
proc gtk_column_view_new*(model: GtkSelectionModel): GtkColumnView
```

**Что делает.** Создаёт таблицу с указанной моделью выбора — столбцы добавляются отдельно, в отличие от `GtkListView`, где вся визуализация задаётся одной фабрикой сразу.

- `model` — модель выбора, либо `nil` для установки позже.

```nim
let contactsColumnView = gtk_column_view_new(cast[GtkSelectionModel](selectionModel))
echo "Таблица контактов создана с моделью выбора, столбцы пока не добавлены"
```

---

### `gtk_column_view_append_column`, `insert_column`, `remove_column`, `get_columns`

```nim
proc gtk_column_view_append_column*(self: GtkColumnView, column: GtkColumnViewColumn)
proc gtk_column_view_insert_column*(self: GtkColumnView, position: guint, column: GtkColumnViewColumn)
proc gtk_column_view_remove_column*(self: GtkColumnView, column: GtkColumnViewColumn)
proc gtk_column_view_get_columns*(self: GtkColumnView): pointer
```

**Что делает.** Добавляют/убирают заранее собранные столбцы — та же логика порядка, что у `gtk_tree_view_append_column`, но здесь передаётся `GtkColumnViewColumn`. `get_columns` возвращает список текущих столбцов как `GListModel` (`pointer`).

- `self` — таблица.
- `column` — столбец.
- `position` — индекс вставки.

```nim
discard gtk_column_view_append_column(contactsColumnView, nameColumn)
discard gtk_column_view_append_column(contactsColumnView, emailColumn)
echo "Столбцы 'Имя' и 'Email' добавлены в таблицу"
```

---

### `gtk_column_view_get/set_model`

```nim
proc gtk_column_view_get_model*(self: GtkColumnView): GtkSelectionModel
proc gtk_column_view_set_model*(self: GtkColumnView, model: GtkSelectionModel)
```

**Что делает.** Заменяют модель уже существующей таблицы и читают текущую подключённую модель.

- `self` — таблица.
- `model` — новая модель выбора.

```nim
gtk_column_view_set_model(contactsColumnView, cast[GtkSelectionModel](otherSelectionModel))
echo "Модель таблицы заменена"
```

---

### `gtk_column_view_get/set_show_row_separators`, `show_column_separators`, `reorderable`

```nim
proc gtk_column_view_get_show_row_separators*(self: GtkColumnView): gboolean
proc gtk_column_view_set_show_row_separators*(self: GtkColumnView, showRowSeparators: gboolean)
proc gtk_column_view_get_show_column_separators*(self: GtkColumnView): gboolean
proc gtk_column_view_set_show_column_separators*(self: GtkColumnView, showColumnSeparators: gboolean)
proc gtk_column_view_get_reorderable*(self: GtkColumnView): gboolean
proc gtk_column_view_set_reorderable*(self: GtkColumnView, reorderable: gboolean)
```

**Что делает.** `show_row_separators`/`show_column_separators` — визуальные линии между строками и столбцами независимо. `reorderable` разрешает менять порядок столбцов перетаскиванием заголовков (включено по умолчанию).

- `self` — таблица.
- Каждый флаг — `1.gboolean`/`0.gboolean`.

```nim
gtk_column_view_set_show_column_separators(contactsColumnView, 1.gboolean)
echo "Вертикальные линии между столбцами таблицы теперь видны"
```

---

### `gtk_column_view_column_new`

```nim
proc gtk_column_view_column_new*(title: cstring, factory: GtkListItemFactory): GtkColumnViewColumn
```

**Что делает.** Создаёт столбец с заголовком и собственной фабрикой элементов, отвечающей за содержимое именно этого столбца — у каждого столбца своя фабрика.

- `title` — заголовок столбца, либо `nil`.
- `factory` — фабрика элементов для этого столбца.

```nim
let nameFactory = gtk_signal_list_item_factory_new()
let nameColumn = gtk_column_view_column_new("Имя".cstring, cast[GtkListItemFactory](nameFactory))
echo "Столбец 'Имя' со своей собственной фабрикой элементов создан"
```

---

### `gtk_column_view_column_get/set_title`, `get/set_visible`, `get/set_resizable`, `get/set_expand`, `get/set_fixed_width`

```nim
proc gtk_column_view_column_get_title*(self: GtkColumnViewColumn): cstring
proc gtk_column_view_column_set_title*(self: GtkColumnViewColumn, title: cstring)
proc gtk_column_view_column_get_visible*(self: GtkColumnViewColumn): gboolean
proc gtk_column_view_column_set_visible*(self: GtkColumnViewColumn, visible: gboolean)
proc gtk_column_view_column_get_resizable*(self: GtkColumnViewColumn): gboolean
proc gtk_column_view_column_set_resizable*(self: GtkColumnViewColumn, resizable: gboolean)
proc gtk_column_view_column_get_expand*(self: GtkColumnViewColumn): gboolean
proc gtk_column_view_column_set_expand*(self: GtkColumnViewColumn, expand: gboolean)
proc gtk_column_view_column_get_fixed_width*(self: GtkColumnViewColumn): gint
proc gtk_column_view_column_set_fixed_width*(self: GtkColumnViewColumn, fixedWidth: gint)
```

**Что делает.** `title`/`visible`/`resizable` — та же логика, что у `GtkTreeViewColumn`. `expand` — забирает ли столбец лишнее свободное место по ширине (аналог `hexpand`). `fixed_width` задаёт точную ширину в пикселях (`-1` — автоматически по содержимому).

- `self` — столбец.
- `title` — текст заголовка.
- `visible`, `resizable`, `expand` — `1.gboolean`/`0.gboolean`.
- `fixedWidth` — ширина в пикселях, либо `-1`.

```nim
gtk_column_view_column_set_expand(descriptionColumn, 1.gboolean)
gtk_column_view_column_set_fixed_width(idColumn, 60)
echo "Столбец описания растягивается, столбец id зафиксирован в 60 пикселей"
```

---

## GtkGridView

`GtkGridView` — сеточное представление той же модели данных, что и `GtkListView`, но с автоматическим переносом элементов на новую строку (аналог `GtkFlowBox`, но с виртуализацией для больших списков) — типичное применение: галерея превью с тысячами изображений.

### `gtk_grid_view_new`

```nim
proc gtk_grid_view_new*(model: GtkSelectionModel, factory: GtkListItemFactory): GtkGridView
```

**Что делает.** Создаёт сетку с моделью выбора и фабрикой элементов — та же логика, что у `gtk_list_view_new`.

- `model` — модель выбора.
- `factory` — фабрика элементов.

```nim
let photoGridView = gtk_grid_view_new(cast[GtkSelectionModel](photoSelectionModel), cast[GtkListItemFactory](photoFactory))
echo "Сетка превью фотографий создана"
```

---

### `gtk_grid_view_get/set_min_columns`, `get/set_max_columns`

```nim
proc gtk_grid_view_get_min_columns*(self: GtkGridView): guint
proc gtk_grid_view_set_min_columns*(self: GtkGridView, minColumns: guint)
proc gtk_grid_view_get_max_columns*(self: GtkGridView): guint
proc gtk_grid_view_set_max_columns*(self: GtkGridView, maxColumns: guint)
```

**Что делает.** Ограничивают число столбцов сетки в одной строке — та же логика, что у `gtk_flow_box_set_min/max_children_per_line`, но для виртуализированной сетки.

- `self` — сетка.
- `minColumns`, `maxColumns` — количество столбцов.

```nim
gtk_grid_view_set_min_columns(photoGridView, 2)
gtk_grid_view_set_max_columns(photoGridView, 6)
echo "Сетка превью будет показывать от 2 до 6 столбцов в зависимости от ширины окна"
```

---

## GtkDropDown

`GtkDropDown` — современная замена `GtkComboBoxText`: та же концепция выпадающего списка, но построенная на `GListModel`/`GtkSelectionModel`, с автоматическим встроенным полем поиска по длинному списку вариантов.

### `gtk_drop_down_new` / `gtk_drop_down_new_from_strings`

```nim
proc gtk_drop_down_new*(model: pointer, expression: pointer): GtkDropDown
proc gtk_drop_down_new_from_strings*(strings: ptr cstring): GtkDropDown
```

**Что делает.** `gtk_drop_down_new` — полная форма: `model` — произвольный `GListModel` (практически всегда `GtkStringList`), `expression` — объект `GtkExpression` (непрозрачный `pointer`; для `GtkStringList` можно передать `nil`). `gtk_drop_down_new_from_strings` — короткая форма для списка строк: принимает `NULL`-терминированный массив прямо, без ручного создания `GtkStringList`/модели выбора — предпочтительный способ для большинства сценариев.

- `model` — источник данных (`GListModel`, приведённый к `pointer`).
- `expression` — объект `GtkExpression` для извлечения текста, либо `nil`.
- `strings` — массив строк вариантов, завершённый `nil`.

```nim
var sortOptions = [cstring("По имени"), cstring("По дате"), cstring("По размеру"), nil]
let sortDropDown = gtk_drop_down_new_from_strings(addr sortOptions[0])
echo "Выпадающий список сортировки создан коротким способом из массива строк"
```

---

### `gtk_drop_down_get/set_selected`, `get_selected_item`

```nim
proc gtk_drop_down_get_selected*(self: GtkDropDown): guint
proc gtk_drop_down_set_selected*(self: GtkDropDown, position: guint)
proc gtk_drop_down_get_selected_item*(self: GtkDropDown): gpointer
```

**Что делает.** Читают/устанавливают текущий выбор по индексу и получают сам выбранный объект данных (для `GtkStringList` — `GtkStringObject`).

- `self` — выпадающий список.
- `position` — индекс варианта.

```nim
gtk_drop_down_set_selected(sortDropDown, 0)
let selectedObj = cast[GtkStringObject](gtk_drop_down_get_selected_item(sortDropDown))
echo "Выбран вариант сортировки: ", $gtk_string_object_get_string(selectedObj)
```

---

### `gtk_drop_down_get/set_enable_search`

```nim
proc gtk_drop_down_get_enable_search*(self: GtkDropDown): gboolean
proc gtk_drop_down_set_enable_search*(self: GtkDropDown, enableSearch: gboolean)
```

**Что делает.** Включают встроенное поле поиска для быстрой фильтрации длинного списка вариантов — выключено по умолчанию.

- `self` — выпадающий список.
- `enableSearch` — `1.gboolean`, чтобы включить поиск.

```nim
gtk_drop_down_set_enable_search(countryDropDown, 1.gboolean)
echo "В выпадающем списке из почти 200 стран теперь можно печатать для быстрого поиска"
```

---

## Практические рецепты

### Простой список строк на GtkListView

```nim
proc buildSimpleStringList(): GtkListView =
  var items = [cstring("Анна Иванова"), cstring("Пётр Смирнов"), cstring("Мария Кузнецова"), nil]
  let stringList = gtk_string_list_new(addr items[0])
  let selectionModel = gtk_single_selection_new(cast[pointer](stringList))

  let factory = gtk_signal_list_item_factory_new()

  proc onSetup(f: GtkSignalListItemFactory, item: GtkListItem, ud: gpointer) {.cdecl.} =
    gtk_list_item_set_child(item, gtk_label_new(""))

  proc onBind(f: GtkSignalListItemFactory, item: GtkListItem, ud: gpointer) {.cdecl.} =
    let strObj = cast[GtkStringObject](gtk_list_item_get_item(item))
    let label = cast[GtkLabel](gtk_list_item_get_child(item))
    gtk_label_set_text(label, gtk_string_object_get_string(strObj))

  discard g_signal_connect(factory, "setup", onSetup, nil)
  discard g_signal_connect(factory, "bind", onBind, nil)

  result = gtk_list_view_new(cast[GtkSelectionModel](selectionModel), cast[GtkListItemFactory](factory))
  echo "Список контактов на GtkListView собран"

let contactsListView = buildSimpleStringList()
```

---

### Таблица с несколькими столбцами на GtkColumnView

```nim
proc buildNameColumn(): GtkColumnViewColumn =
  let factory = gtk_signal_list_item_factory_new()
  proc onSetup(f: GtkSignalListItemFactory, item: GtkListItem, ud: gpointer) {.cdecl.} =
    gtk_list_item_set_child(item, gtk_label_new(""))
  proc onBind(f: GtkSignalListItemFactory, item: GtkListItem, ud: gpointer) {.cdecl.} =
    let strObj = cast[GtkStringObject](gtk_list_item_get_item(item))
    let label = cast[GtkLabel](gtk_list_item_get_child(item))
    gtk_label_set_text(label, gtk_string_object_get_string(strObj))
  discard g_signal_connect(factory, "setup", onSetup, nil)
  discard g_signal_connect(factory, "bind", onBind, nil)
  result = gtk_column_view_column_new("Имя".cstring, cast[GtkListItemFactory](factory))
  gtk_column_view_column_set_expand(result, 1.gboolean)

proc buildContactsTable(): GtkColumnView =
  var items = [cstring("Анна Иванова"), cstring("Пётр Смирнов"), nil]
  let stringList = gtk_string_list_new(addr items[0])
  let selectionModel = gtk_single_selection_new(cast[pointer](stringList))

  result = gtk_column_view_new(cast[GtkSelectionModel](selectionModel))
  discard gtk_column_view_append_column(result, buildNameColumn())
  gtk_column_view_set_show_row_separators(result, 1.gboolean)
  echo "Таблица контактов с растягивающимся столбцом 'Имя' собрана"

let contactsTable = buildContactsTable()
```

---

### Выпадающий список на GtkDropDown вместо GtkComboBoxText

```nim
proc buildCountryDropDown(): GtkDropDown =
  var countries = [cstring("Россия"), cstring("Германия"), cstring("Франция"), cstring("Япония"), nil]
  result = gtk_drop_down_new_from_strings(addr countries[0])
  gtk_drop_down_set_selected(result, 0)

  proc onSelectionChanged(dropDown: GtkDropDown, pspec: pointer, ud: gpointer) {.cdecl.} =
    let selectedObj = cast[GtkStringObject](gtk_drop_down_get_selected_item(dropDown))
    echo "Выбрана страна: ", $gtk_string_object_get_string(selectedObj)

  discard g_signal_connect(result, "notify::selected", onSelectionChanged, nil)
  echo "Выпадающий список стран на GtkDropDown собран"

let countryDropDown = buildCountryDropDown()
```

---

### Сетка превью изображений на GtkGridView

```nim
proc buildPhotoGallery(photoPaths: seq[string]): GtkGridView =
  var pathsCstr: seq[cstring]
  for p in photoPaths:
    pathsCstr.add(p.cstring)
  pathsCstr.add(nil)
  let pathsList = gtk_string_list_new(addr pathsCstr[0])
  let selectionModel = gtk_single_selection_new(cast[pointer](pathsList))

  let factory = gtk_signal_list_item_factory_new()
  proc onSetup(f: GtkSignalListItemFactory, item: GtkListItem, ud: gpointer) {.cdecl.} =
    gtk_list_item_set_child(item, gtk_picture_new())
  proc onBind(f: GtkSignalListItemFactory, item: GtkListItem, ud: gpointer) {.cdecl.} =
    let strObj = cast[GtkStringObject](gtk_list_item_get_item(item))
    let picture = cast[GtkPicture](gtk_list_item_get_child(item))
    gtk_picture_set_filename(picture, gtk_string_object_get_string(strObj))
  discard g_signal_connect(factory, "setup", onSetup, nil)
  discard g_signal_connect(factory, "bind", onBind, nil)

  result = gtk_grid_view_new(cast[GtkSelectionModel](selectionModel), cast[GtkListItemFactory](factory))
  gtk_grid_view_set_min_columns(result, 3)
  gtk_grid_view_set_max_columns(result, 8)
  echo "Виртуализированная галерея из ", photoPaths.len, " превью собрана"

let gallery = buildPhotoGallery(@["photo1.jpg", "photo2.jpg", "photo3.jpg"])
```

---

### Реакция на изменение выбора в GtkSingleSelection

```nim
proc onSelectionChanged(model: GtkSelectionModel, position: guint, nItems: guint, userData: gpointer) {.cdecl.} =
  let selection = cast[GtkSingleSelection](model)
  let selectedIndex = gtk_single_selection_get_selected(selection)
  echo "Текущий выбор теперь на индексе ", selectedIndex

discard g_signal_connect(selectionModel, "selection-changed", onSelectionChanged, nil)
```

---

## Краткая таблица

| Процедура(ы) | Категория | Что делает вкратце |
|---|---|---|
| `gtk_string_list_new` | StringList | Создать список строк из массива |
| `gtk_string_list_append`, `take`, `remove`, `splice` | StringList | Изменение содержимого списка строк |
| `gtk_string_list_get_string` | StringList | Строка по индексу |
| `gtk_string_object_new`, `get_string` | StringObject | Объектная обёртка одной строки |
| `gtk_selection_model_is_selected`, `get_selection`, `get_selection_in_range` | SelectionModel | Чтение состояния выбора |
| `gtk_selection_model_select/unselect_item`, `_range`, `select/unselect_all`, `set_selection` | SelectionModel | Программное управление выбором |
| `gtk_single_selection_new` и свойства | SingleSelection | Модель выбора не более одного элемента |
| `gtk_multi_selection_new` | MultiSelection | Модель выбора произвольного числа элементов |
| `gtk_no_selection_new` | NoSelection | Модель без возможности выбора |
| `gtk_signal_list_item_factory_new` | ListItemFactory | Фабрика элементов, управляемая сигналами |
| `gtk_list_item_get_item`, `get_position`, `get_selected` | ListItem | Данные, индекс и состояние выбора строки |
| `gtk_list_item_get/set_child` | ListItem | Виджет строки |
| `gtk_list_item_get/set_selectable`, `get/set_activatable` | ListItem | Может ли строка быть выбрана/активирована |
| `gtk_list_view_new` | ListView | Создать виртуализированный список |
| `gtk_list_view_get/set_model`, `get/set_factory` | ListView | Модель и фабрика списка |
| `gtk_list_view_get/set_show_separators` | ListView | Линии между строками |
| `gtk_list_view_get/set_single_click_activate` | ListView | Активация одним/двойным кликом |
| `gtk_list_view_get/set_enable_rubberband` | ListView | Выделение рамкой мыши |
| `gtk_column_view_new` | ColumnView | Создать виртуализированную таблицу |
| `gtk_column_view_append/insert/remove_column`, `get_columns` | ColumnView | Управление столбцами |
| `gtk_column_view_get/set_model` | ColumnView | Модель таблицы |
| `gtk_column_view_get/set_show_row/column_separators`, `reorderable` | ColumnView | Линии и перестановка столбцов |
| `gtk_column_view_column_new` | ColumnViewColumn | Создать столбец со своей фабрикой |
| `gtk_column_view_column_get/set_title/visible/resizable/expand/fixed_width` | ColumnViewColumn | Свойства столбца |
| `gtk_grid_view_new` | GridView | Создать виртуализированную сетку |
| `gtk_grid_view_get/set_min/max_columns` | GridView | Число столбцов сетки |
| `gtk_drop_down_new`, `_from_strings` | DropDown | Создать современный выпадающий список |
| `gtk_drop_down_get/set_selected`, `get_selected_item` | DropDown | Текущий выбор |
| `gtk_drop_down_get/set_enable_search` | DropDown | Встроенный поиск по вариантам |

---

## Сводка: какую процедуру выбрать

- **Новый код, список из простых строк, без тысяч элементов** → `GtkDropDown`/`gtk_string_list_new` для выпадающего списка, `GtkListView` для вертикального списка — предпочтительнее устаревшего `GtkComboBoxText`/`GtkTreeView`, если нет причины держаться за старый API ради совместимости.
- **Список из произвольных объектов приложения (не строк)** → потребуется собственный `GListModel` — эта обёртка не предоставляет `GListStore` напрямую, нужно либо получить `GListModel` из другого источника, либо хранить данные как строки через `GtkStringList` и разбирать их внутри фабрики.
- **Список с тысячами и более элементов** → `GtkListView`/`GtkColumnView`/`GtkGridView` (виртуализация — виджеты создаются только для видимой части). **Короткий список, известный заранее** → `GtkListBox`/`GtkComboBoxText` могут быть проще, если виртуализация не требуется.
- **Таблица с несколькими столбцами разных данных** → `GtkColumnView` с отдельной фабрикой на каждый столбец. **Список без табличной структуры** → `GtkListView` с одной фабрикой на всю строку.
- **Сетка карточек/превью с автопереносом** → `GtkGridView` для больших объёмов (виртуализация) либо `GtkFlowBox` для меньших списков.
- **Выбор не более одного элемента** → `GtkSingleSelection`. **Выбор нескольких** → `GtkMultiSelection`. **Список только для отображения** → `GtkNoSelection`.
- **Длинный список вариантов, где прокрутка неудобна** → `gtk_drop_down_set_enable_search(dropDown, true)` — встроенное поле поиска, не нужно реализовывать фильтрацию вручную.
