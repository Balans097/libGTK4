# GTK4 (bars & misc: InfoBar / Statusbar / LevelBar / LinkButton / ActionBar / SearchBar / Picture / FlowBox / Viewport) — справочник модуля

> **Импорт:** `import libGTK4`
> **Область применения:** различные панели (информационная, статусная, панель действий, панель поиска), индикатор уровня, кнопка-ссылка, современный виджет изображения, поток однотипных карточек и вспомогательный контейнер прокрутки. Одиннадцатая часть серии справочников по обёртке; предполагает знакомство с предыдущими частями, особенно с `gtk4_core_reference_ru.md` (компоновка, `GtkWidget`).

Два виджета этого справочника — `GtkInfoBar` и `GtkStatusbar` — помечены как устаревшие (**deprecated**) в GTK4: они по-прежнему присутствуют и работают, но новый код не должен на них полагаться, если есть современная альтернатива (для информационных сообщений — `GtkBanner`/собственный виджет с `GtkRevealer`, не входящие в эту обёртку; для статуса — произвольная строка в заголовочной панели или тексте). В этой обёртке обе процедурные группы обёрнуты в `when not defined(GTK_DISABLE_DEPRECATED):` — они компилируются по умолчанию, но пропадают из сборки при указании `-d:GTK_DISABLE_DEPRECATED`, что позволяет заранее проверить, не зависит ли код от устаревшего API.

---

## Оглавление

I. [GtkInfoBar (устарел)](#gtkinfobar-устарел)
&nbsp;&nbsp;1. [`gtk_info_bar_new`](#gtk_info_bar_new)
&nbsp;&nbsp;2. [`gtk_info_bar_add_button`](#gtk_info_bar_add_button)
&nbsp;&nbsp;3. [`gtk_info_bar_add_child` / `gtk_info_bar_remove_child`](#gtk_info_bar_add_child--gtk_info_bar_remove_child)
&nbsp;&nbsp;4. [`gtk_info_bar_set_message_type` / `gtk_info_bar_get_message_type`](#gtk_info_bar_set_message_type--gtk_info_bar_get_message_type)
&nbsp;&nbsp;5. [`gtk_info_bar_set_show_close_button` / `gtk_info_bar_get_show_close_button`](#gtk_info_bar_set_show_close_button--gtk_info_bar_get_show_close_button)
&nbsp;&nbsp;6. [`gtk_info_bar_set_revealed` / `gtk_info_bar_get_revealed`](#gtk_info_bar_set_revealed--gtk_info_bar_get_revealed)

II. [GtkStatusbar (устарел)](#gtkstatusbar-устарел)
&nbsp;&nbsp;1. [`gtk_statusbar_new`](#gtk_statusbar_new)
&nbsp;&nbsp;2. [`gtk_statusbar_get_context_id`](#gtk_statusbar_get_context_id)
&nbsp;&nbsp;3. [`gtk_statusbar_push` / `gtk_statusbar_pop` / `gtk_statusbar_remove` / `gtk_statusbar_remove_all`](#gtk_statusbar_push--gtk_statusbar_pop--gtk_statusbar_remove--gtk_statusbar_remove_all)

III. [GtkLevelBar](#gtklevelbar)
&nbsp;&nbsp;1. [`gtk_level_bar_new` / `gtk_level_bar_new_for_interval`](#gtk_level_bar_new--gtk_level_bar_new_for_interval)
&nbsp;&nbsp;2. [`gtk_level_bar_set_value` / `gtk_level_bar_get_value`](#gtk_level_bar_set_value--gtk_level_bar_get_value)
&nbsp;&nbsp;3. [`gtk_level_bar_set_min_value` / `get_min_value` / `set_max_value` / `get_max_value`](#gtk_level_bar_set_min_value--get_min_value--set_max_value--get_max_value)

IV. [GtkLinkButton](#gtklinkbutton)
&nbsp;&nbsp;1. [`gtk_link_button_new` / `gtk_link_button_new_with_label`](#gtk_link_button_new--gtk_link_button_new_with_label)
&nbsp;&nbsp;2. [`gtk_link_button_set_uri` / `gtk_link_button_get_uri`](#gtk_link_button_set_uri--gtk_link_button_get_uri)
&nbsp;&nbsp;3. [`gtk_link_button_set_visited` / `gtk_link_button_get_visited`](#gtk_link_button_set_visited--gtk_link_button_get_visited)

V. [GtkActionBar](#gtkactionbar)
&nbsp;&nbsp;1. [`gtk_action_bar_new`](#gtk_action_bar_new)
&nbsp;&nbsp;2. [`gtk_action_bar_pack_start` / `gtk_action_bar_pack_end` / `gtk_action_bar_remove`](#gtk_action_bar_pack_start--gtk_action_bar_pack_end--gtk_action_bar_remove)
&nbsp;&nbsp;3. [`gtk_action_bar_set_center_widget` / `gtk_action_bar_get_center_widget`](#gtk_action_bar_set_center_widget--gtk_action_bar_get_center_widget)

VI. [GtkSearchBar](#gtksearchbar)
&nbsp;&nbsp;1. [`gtk_search_bar_new`](#gtk_search_bar_new)
&nbsp;&nbsp;2. [`gtk_search_bar_set_child` / `gtk_search_bar_get_child`](#gtk_search_bar_set_child--gtk_search_bar_get_child)
&nbsp;&nbsp;3. [`gtk_search_bar_set_search_mode` / `gtk_search_bar_get_search_mode`](#gtk_search_bar_set_search_mode--gtk_search_bar_get_search_mode)
&nbsp;&nbsp;4. [`gtk_search_bar_set_show_close_button` / `gtk_search_bar_get_show_close_button`](#gtk_search_bar_set_show_close_button--gtk_search_bar_get_show_close_button)

VII. [GtkPicture](#gtkpicture)
&nbsp;&nbsp;1. [`gtk_picture_new` / `gtk_picture_new_for_file` / `gtk_picture_new_for_filename`](#gtk_picture_new--gtk_picture_new_for_file--gtk_picture_new_for_filename)
&nbsp;&nbsp;2. [`gtk_picture_set_file` / `gtk_picture_get_file` / `set_filename` / `set_pixbuf` / `set_paintable`](#gtk_picture_set_file--gtk_picture_get_file--set_filename--set_pixbuf--set_paintable)
&nbsp;&nbsp;3. [`gtk_picture_set_can_shrink` / `gtk_picture_get_can_shrink`](#gtk_picture_set_can_shrink--gtk_picture_get_can_shrink)

VIII. [GtkFlowBox](#gtkflowbox)
&nbsp;&nbsp;1. [`gtk_flow_box_new`](#gtk_flow_box_new)
&nbsp;&nbsp;2. [`gtk_flow_box_insert` / `gtk_flow_box_append` / `gtk_flow_box_prepend` / `gtk_flow_box_remove`](#gtk_flow_box_insert--gtk_flow_box_append--gtk_flow_box_prepend--gtk_flow_box_remove)
&nbsp;&nbsp;3. [`gtk_flow_box_set_homogeneous` / `gtk_flow_box_get_homogeneous`](#gtk_flow_box_set_homogeneous--gtk_flow_box_get_homogeneous)
&nbsp;&nbsp;4. [`gtk_flow_box_set_row_spacing` / `get_row_spacing` / `set_column_spacing` / `get_column_spacing`](#gtk_flow_box_set_row_spacing--get_row_spacing--set_column_spacing--get_column_spacing)
&nbsp;&nbsp;5. [`gtk_flow_box_set_min_children_per_line` / `get_min_children_per_line` / `set_max_children_per_line` / `get_max_children_per_line`](#gtk_flow_box_set_min_children_per_line--get_min_children_per_line--set_max_children_per_line--get_max_children_per_line)
&nbsp;&nbsp;6. [`gtk_flow_box_set_selection_mode` / `gtk_flow_box_get_selection_mode`](#gtk_flow_box_set_selection_mode--gtk_flow_box_get_selection_mode)
&nbsp;&nbsp;7. [`gtk_flow_box_child_new` / `set_child` / `get_child` / `get_index`](#gtk_flow_box_child_new--set_child--get_child--get_index)

IX. [GtkViewport](#gtkviewport)
&nbsp;&nbsp;1. [`gtk_viewport_new`](#gtk_viewport_new)
&nbsp;&nbsp;2. [`gtk_viewport_set_child` / `gtk_viewport_get_child`](#gtk_viewport_set_child--gtk_viewport_get_child)
&nbsp;&nbsp;3. [`gtk_viewport_set_scroll_to_focus` / `gtk_viewport_get_scroll_to_focus`](#gtk_viewport_set_scroll_to_focus--gtk_viewport_get_scroll_to_focus)

X. [Практические рецепты](#практические-рецепты)
&nbsp;&nbsp;1. [Полоса поиска, разворачиваемая по Ctrl+F](#полоса-поиска-разворачиваемая-по-ctrlf)
&nbsp;&nbsp;2. [Индикатор уровня заряда батареи с сегментами](#индикатор-уровня-заряда-батареи-с-сегментами)
&nbsp;&nbsp;3. [Галерея превью изображений на GtkFlowBox](#галерея-превью-изображений-на-gtkflowbox)
&nbsp;&nbsp;4. [Панель действий внизу окна с кнопками по краям](#панель-действий-внизу-окна-с-кнопками-по-краям)
&nbsp;&nbsp;5. [Ссылка на внешний ресурс в тексте описания](#ссылка-на-внешний-ресурс-в-тексте-описания)

XI. [Краткая таблица](#краткая-таблица)

XII. [Сводка: какую процедуру выбрать](#сводка-какую-процедуру-выбрать)

---

## GtkInfoBar (устарел)

`GtkInfoBar` — горизонтальная полоса с сообщением, иконкой по типу (как у `GtkMessageDialog`) и опциональными кнопками — показывается обычно вверху или внизу содержимого окна, а не как отдельное всплывающее окно/диалог. Помечен как устаревший в GTK4.

### `gtk_info_bar_new`

```nim
proc gtk_info_bar_new*(): GtkInfoBar
```

**Что делает.** Создаёт информационную полосу без кнопок и дополнительного содержимого.

- Параметров нет.

```nim
let infoBar = gtk_info_bar_new()
echo "Информационная полоса создана"
```

---

### `gtk_info_bar_add_button`

```nim
proc gtk_info_bar_add_button*(infoBar: GtkInfoBar, buttonText: cstring, responseId: gint)
```

**Что делает.** Добавляет кнопку действия в полосу — та же логика кода ответа (`responseId`), что у `gtk_dialog_add_button` из справочника по window chrome, поскольку `GtkInfoBar` эмитирует тот же сигнал `"response"`.

- `infoBar` — информационная полоса.
- `buttonText` — текст кнопки.
- `responseId` — код ответа, сообщаемый сигналом `"response"`.

```nim
gtk_info_bar_add_button(infoBar, "Закрыть", ord(GTK_RESPONSE_CLOSE).gint)
echo "Кнопка закрытия добавлена в информационную полосу"
```

---

### `gtk_info_bar_add_child` / `gtk_info_bar_remove_child`

```nim
proc gtk_info_bar_add_child*(infoBar: GtkInfoBar, widget: GtkWidget)
proc gtk_info_bar_remove_child*(infoBar: GtkInfoBar, widget: GtkWidget)
```

**Что делает.** Добавляют/убирают произвольный виджет в основную область содержимого полосы (не в область кнопок) — например, текстовую надпись с самим сообщением.

- `infoBar` — информационная полоса.
- `widget` — добавляемый/убираемый виджет.

```nim
gtk_info_bar_add_child(infoBar, gtk_label_new("Соединение с сервером потеряно"))
echo "Текст сообщения добавлен в информационную полосу"
```

---

### `gtk_info_bar_set_message_type` / `gtk_info_bar_get_message_type`

```nim
proc gtk_info_bar_set_message_type*(infoBar: GtkInfoBar, messageType: GtkMessageType)
proc gtk_info_bar_get_message_type*(infoBar: GtkInfoBar): GtkMessageType
```

**Что делает.** Задают тип сообщения — та же логика и те же значения `GtkMessageType`, что у `GtkMessageDialog` (справочник по window chrome): влияет на цвет фона и иконку полосы (`GTK_MESSAGE_WARNING` — предупреждающий жёлтый/оранжевый вид, `_ERROR` — красный и т.д.).

- `infoBar` — информационная полоса.
- `messageType` — значение `GtkMessageType`.

```nim
gtk_info_bar_set_message_type(infoBar, GTK_MESSAGE_WARNING)
echo "Полоса окрашена в предупреждающий цвет"
```

---

### `gtk_info_bar_set_show_close_button` / `gtk_info_bar_get_show_close_button`

```nim
proc gtk_info_bar_set_show_close_button*(infoBar: GtkInfoBar, setting: gboolean)
proc gtk_info_bar_get_show_close_button*(infoBar: GtkInfoBar): gboolean
```

**Что делает.** Показывают/скрывают встроенную кнопку закрытия (крестик) отдельно от кнопок, добавленных через `add_button`, — быстрый способ дать пользователю закрыть полосу без необходимости добавлять отдельную кнопку "Закрыть" вручную.

- `infoBar` — информационная полоса.
- `setting` — `1.gboolean`, чтобы показать встроенную кнопку закрытия.

```nim
gtk_info_bar_set_show_close_button(infoBar, 1.gboolean)
echo "Кнопка закрытия (крестик) теперь видна"
```

---

### `gtk_info_bar_set_revealed` / `gtk_info_bar_get_revealed`

```nim
proc gtk_info_bar_set_revealed*(infoBar: GtkInfoBar, revealed: gboolean)
proc gtk_info_bar_get_revealed*(infoBar: GtkInfoBar): gboolean
```

**Что делает.** Показывают/скрывают полосу с плавной анимацией раскрытия/сворачивания (в отличие от резкого `gtk_widget_set_visible` из базового справочника) — предпочтительный способ показать/скрыть `GtkInfoBar` именно потому, что для него специально предусмотрена анимация, а не общая функция видимости.

- `infoBar` — информационная полоса.
- `revealed` — `1.gboolean`, чтобы показать полосу с анимацией.

```nim
gtk_info_bar_set_revealed(infoBar, 1.gboolean)
echo "Информационная полоса плавно появляется"
```

---

## GtkStatusbar (устарел)

`GtkStatusbar` — узкая полоса внизу окна для коротких статусных сообщений с поддержкой "стека" сообщений по контекстам — новое сообщение можно вытолкнуть (push), а после того как оно больше не актуально, вернуться к предыдущему (pop), не теряя истории. Помечен как устаревший в GTK4 — современные приложения чаще показывают статус в заголовочной панели или вообще отказываются от отдельной статусной строки.

### `gtk_statusbar_new`

```nim
proc gtk_statusbar_new*(): GtkStatusbar
```

**Что делает.** Создаёт пустую статусную строку.

- Параметров нет.

```nim
let statusbar = gtk_statusbar_new()
echo "Статусная строка создана"
```

---

### `gtk_statusbar_get_context_id`

```nim
proc gtk_statusbar_get_context_id*(statusbar: GtkStatusbar, contextDescription: cstring): guint
```

**Что делает.** Возвращает числовой идентификатор "контекста" сообщений по его текстовому описанию — вызовы с одинаковым `contextDescription` всегда возвращают один и тот же `contextId`, что позволяет группировать связанные сообщения (например, все сообщения, связанные с загрузкой файлов, отдельно от сообщений о сетевом соединении) и работать с каждой группой независимо через `push`/`pop`/`remove` (следующий подраздел).

- `statusbar` — статусная строка.
- `contextDescription` — произвольное текстовое описание контекста (используется только как ключ для получения `contextId`, пользователю не показывается).

```nim
let fileContextId = gtk_statusbar_get_context_id(statusbar, "file-operations")
echo "Идентификатор контекста для сообщений о файловых операциях получен"
```

---

### `gtk_statusbar_push` / `gtk_statusbar_pop` / `gtk_statusbar_remove` / `gtk_statusbar_remove_all`

```nim
proc gtk_statusbar_push*(statusbar: GtkStatusbar, contextId: guint, text: cstring): guint
proc gtk_statusbar_pop*(statusbar: GtkStatusbar, contextId: guint)
proc gtk_statusbar_remove*(statusbar: GtkStatusbar, contextId: guint, messageId: guint)
proc gtk_statusbar_remove_all*(statusbar: GtkStatusbar, contextId: guint)
```

**Что делает.** `push` добавляет новое сообщение в стек указанного контекста и показывает его как текущее (возвращает уникальный `messageId` этого конкретного сообщения — для его последующего точечного удаления через `remove`, отдельно от остальных сообщений того же контекста). `pop` убирает самое верхнее сообщение контекста, возвращая видимым предыдущее под ним в стеке того же контекста (если оно было). `remove` убирает конкретное сообщение по его `messageId`, даже если оно не самое верхнее. `remove_all` очищает весь стек указанного контекста разом.

- `statusbar` — статусная строка.
- `contextId` — идентификатор контекста, полученный от `get_context_id`.
- `text` — текст сообщения (для `push`).
- `messageId` — идентификатор конкретного сообщения, возвращённый ранее от `push` (для `remove`).

```nim
let msgId = gtk_statusbar_push(statusbar, fileContextId, "Копирование файлов: 3 из 10")
# ... по завершении операции ...
gtk_statusbar_pop(statusbar, fileContextId)
echo "Сообщение о копировании убрано, показано предыдущее сообщение этого контекста (если было)"
```

---

## GtkLevelBar

`GtkLevelBar` — горизонтальная полоса-индикатор уровня значения в диапазоне, визуально похожая на `GtkProgressBar`, но предназначенная для показа **статичного уровня**, а не прогресса выполняющейся операции, — заряд батареи, громкость, уровень сигнала.

### `gtk_level_bar_new` / `gtk_level_bar_new_for_interval`

```nim
proc gtk_level_bar_new*(): GtkLevelBar
proc gtk_level_bar_new_for_interval*(minValue: gdouble, maxValue: gdouble): GtkLevelBar
```

**Что делает.** `gtk_level_bar_new` создаёт индикатор со стандартным диапазоном от `0.0` до `1.0`. `gtk_level_bar_new_for_interval` сразу задаёт произвольный диапазон — удобнее, когда естественные единицы значения не `0.0`–`1.0` (например, громкость в привычных `0`–`100`).

- `minValue`, `maxValue` — границы диапазона (для `new_for_interval`).

```nim
let batteryLevel = gtk_level_bar_new_for_interval(0.0, 100.0)
echo "Индикатор заряда батареи создан с диапазоном 0–100"
```

---

### `gtk_level_bar_set_value` / `gtk_level_bar_get_value`

```nim
proc gtk_level_bar_set_value*(levelBar: GtkLevelBar, value: gdouble)
proc gtk_level_bar_get_value*(levelBar: GtkLevelBar): gdouble
```

**Что делает.** Устанавливают и читают текущий отображаемый уровень.

- `levelBar` — индикатор уровня.
- `value` — значение в пределах текущего диапазона.

```nim
gtk_level_bar_set_value(batteryLevel, 72.0)
echo "Текущий уровень заряда: ", gtk_level_bar_get_value(batteryLevel), "%"
```

---

### `gtk_level_bar_set_min_value` / `get_min_value` / `set_max_value` / `get_max_value`

```nim
proc gtk_level_bar_set_min_value*(levelBar: GtkLevelBar, value: gdouble)
proc gtk_level_bar_get_min_value*(levelBar: GtkLevelBar): gdouble
proc gtk_level_bar_set_max_value*(levelBar: GtkLevelBar, value: gdouble)
proc gtk_level_bar_get_max_value*(levelBar: GtkLevelBar): gdouble
```

**Что делает.** Изменяют границы диапазона уже после создания.

- `levelBar` — индикатор уровня.
- `value` — новая граница.

```nim
gtk_level_bar_set_max_value(signalStrengthBar, 5.0)
echo "Диапазон индикатора сигнала: от ", gtk_level_bar_get_min_value(signalStrengthBar), " до ", gtk_level_bar_get_max_value(signalStrengthBar)
```

---

## GtkLinkButton

`GtkLinkButton` — кнопка, визуально выглядящая как гиперссылка, и открывающая указанный URI во внешнем приложении при клике — встроенное поведение виджета, без ручного подключения обработчика.

### `gtk_link_button_new` / `gtk_link_button_new_with_label`

```nim
proc gtk_link_button_new*(uri: cstring): GtkLinkButton
proc gtk_link_button_new_with_label*(uri: cstring, label: cstring): GtkLinkButton
```

**Что делает.** Создают кнопку-ссылку. `gtk_link_button_new` показывает сам URI как видимый текст. `gtk_link_button_new_with_label` показывает произвольный текст вместо URI.

- `uri` — адрес, открываемый по клику.
- `label` — видимый текст кнопки (для варианта `_with_label`).

```nim
let docsLink = gtk_link_button_new_with_label("https://example.com/docs", "Документация проекта")
echo "Кнопка-ссылка на документацию создана"
```

---

### `gtk_link_button_set_uri` / `gtk_link_button_get_uri`

```nim
proc gtk_link_button_set_uri*(linkButton: GtkLinkButton, uri: cstring)
proc gtk_link_button_get_uri*(linkButton: GtkLinkButton): cstring
```

**Что делает.** Изменяют и читают целевой адрес уже после создания кнопки.

- `linkButton` — кнопка-ссылка.
- `uri` — новый адрес.

```nim
gtk_link_button_set_uri(docsLink, "https://example.com/docs/v2")
echo "Ссылка обновлена: ", $gtk_link_button_get_uri(docsLink)
```

---

### `gtk_link_button_set_visited` / `gtk_link_button_get_visited`

```nim
proc gtk_link_button_set_visited*(linkButton: GtkLinkButton, visited: gboolean)
proc gtk_link_button_get_visited*(linkButton: GtkLinkButton): gboolean
```

**Что делает.** Управляют визуальным состоянием "посещённой" ссылки — GTK не отслеживает историю посещений сама, состояние выставляется вручную приложением.

- `linkButton` — кнопка-ссылка.
- `visited` — `1.gboolean` для отображения как "посещённой".

```nim
gtk_link_button_set_visited(docsLink, 1.gboolean)
echo "Ссылка на документацию отображается как уже посещённая"
```

---

## GtkActionBar

`GtkActionBar` — узкая горизонтальная панель, обычно размещаемая внизу окна, с виджетами по краям и опциональным виджетом по центру — похожа на `GtkHeaderBar`, но для нижней части окна и без системных кнопок управления окном.

### `gtk_action_bar_new`

```nim
proc gtk_action_bar_new*(): GtkActionBar
```

**Что делает.** Создаёт пустую панель действий.

- Параметров нет.

```nim
let bottomBar = gtk_action_bar_new()
echo "Панель действий внизу окна создана"
```

---

### `gtk_action_bar_pack_start` / `gtk_action_bar_pack_end` / `gtk_action_bar_remove`

```nim
proc gtk_action_bar_pack_start*(actionBar: GtkActionBar, child: GtkWidget)
proc gtk_action_bar_pack_end*(actionBar: GtkActionBar, child: GtkWidget)
proc gtk_action_bar_remove*(actionBar: GtkActionBar, child: GtkWidget)
```

**Что делает.** Добавляют/убирают виджет в начало или конец панели — та же логика `start`/`end`, что у `gtk_header_bar_pack_start`/`pack_end`.

- `actionBar` — панель действий.
- `child` — добавляемый/убираемый виджет.

```nim
gtk_action_bar_pack_start(bottomBar, gtk_button_new_from_icon_name("edit-select-all-symbolic"))
gtk_action_bar_pack_end(bottomBar, gtk_button_new_with_label("Готово"))
echo "Кнопка выделения всего слева, кнопка 'Готово' справа"
```

---

### `gtk_action_bar_set_center_widget` / `gtk_action_bar_get_center_widget`

```nim
proc gtk_action_bar_set_center_widget*(actionBar: GtkActionBar, centerWidget: GtkWidget)
proc gtk_action_bar_get_center_widget*(actionBar: GtkActionBar): GtkWidget
```

**Что делает.** Устанавливают и читают виджет, размещаемый по центру панели — например, счётчик "3 из 12 выбрано" в режиме множественного выбора.

- `actionBar` — панель действий.
- `centerWidget` — виджет для центральной области.

```nim
gtk_action_bar_set_center_widget(bottomBar, gtk_label_new("3 выбрано"))
echo "Счётчик выбранных элементов показан по центру панели действий"
```

---

## GtkSearchBar

`GtkSearchBar` — панель поиска, которая может быть скрыта и появляться по запросу с плавной анимацией, содержащая внутри поле поиска (`GtkSearchEntry` из справочника по вводу текста).

### `gtk_search_bar_new`

```nim
proc gtk_search_bar_new*(): GtkSearchBar
```

**Что делает.** Создаёт панель поиска в свёрнутом состоянии по умолчанию.

- Параметров нет.

```nim
let searchBar = gtk_search_bar_new()
echo "Панель поиска создана в скрытом состоянии"
```

---

### `gtk_search_bar_set_child` / `gtk_search_bar_get_child`

```nim
proc gtk_search_bar_set_child*(searchBar: GtkSearchBar, child: GtkWidget)
proc gtk_search_bar_get_child*(searchBar: GtkSearchBar): GtkWidget
```

**Что делает.** Устанавливают и читают содержимое панели — как правило, `GtkSearchEntry`, но может быть и составным контейнером с дополнительными элементами.

- `searchBar` — панель поиска.
- `child` — виджет-содержимое.

```nim
let searchEntry = gtk_search_entry_new()
gtk_search_bar_set_child(searchBar, searchEntry)
echo "Поле поиска установлено как содержимое панели"
```

---

### `gtk_search_bar_set_search_mode` / `gtk_search_bar_get_search_mode`

```nim
proc gtk_search_bar_set_search_mode*(searchBar: GtkSearchBar, searchMode: gboolean)
proc gtk_search_bar_get_search_mode*(searchBar: GtkSearchBar): gboolean
```

**Что делает.** Показывают/скрывают панель поиска с плавной анимацией и читают, показана ли она сейчас — основной способ управлять видимостью, например по `Ctrl+F`.

- `searchBar` — панель поиска.
- `searchMode` — `1.gboolean`, чтобы показать панель.

```nim
proc onSearchShortcut() =
  gtk_search_bar_set_search_mode(searchBar, 1.gboolean)
  echo "Панель поиска показана по Ctrl+F"
```

---

### `gtk_search_bar_set_show_close_button` / `gtk_search_bar_get_show_close_button`

```nim
proc gtk_search_bar_set_show_close_button*(searchBar: GtkSearchBar, visible: gboolean)
proc gtk_search_bar_get_show_close_button*(searchBar: GtkSearchBar): gboolean
```

**Что делает.** Показывают/скрывают встроенную кнопку закрытия панели поиска.

- `searchBar` — панель поиска.
- `visible` — `1.gboolean`, чтобы показать кнопку закрытия.

```nim
gtk_search_bar_set_show_close_button(searchBar, 1.gboolean)
echo "Кнопка закрытия панели поиска теперь видна"
```

---

## GtkPicture

`GtkPicture` — современный виджет изображения в GTK4 (в отличие от `GtkImage` из справочника по вспомогательным виджетам, рассчитанного в первую очередь на иконки фиксированных стандартных размеров): предназначен для показа фотографий и изображений произвольного размера с гибким масштабированием и сохранением пропорций. Выбор между `GtkImage` и `GtkPicture` — типично `GtkImage` для иконок из темы, `GtkPicture` для фотографий и пользовательского контента.

### `gtk_picture_new` / `gtk_picture_new_for_file` / `gtk_picture_new_for_filename`

```nim
proc gtk_picture_new*(): GtkPicture
proc gtk_picture_new_for_file*(file: GFile): GtkPicture
proc gtk_picture_new_for_filename*(filename: cstring): GtkPicture
```

**Что делает.** Создают виджет изображения — пустой, из объекта `GFile` (раздел про GFile в справочнике по рисованию и GLib-утилитам), либо сразу из строки пути к файлу (короче, без промежуточного создания `GFile`).

- `file` — объект `GFile`.
- `filename` — путь к файлу изображения.

```nim
let photoView = gtk_picture_new_for_filename("/home/user/Pictures/vacation.jpg")
echo "Изображение фотографии загружено из файла"
```

---

### `gtk_picture_set_file` / `gtk_picture_get_file` / `set_filename` / `set_pixbuf` / `set_paintable`

```nim
proc gtk_picture_set_file*(picture: GtkPicture, file: GFile)
proc gtk_picture_get_file*(picture: GtkPicture): GFile
proc gtk_picture_set_filename*(picture: GtkPicture, filename: cstring)
proc gtk_picture_set_pixbuf*(picture: GtkPicture, pixbuf: GdkPixbuf)
proc gtk_picture_set_paintable*(picture: GtkPicture, paintable: pointer)
```

**Что делает.** Меняют содержимое уже существующего виджета `GtkPicture` любым из четырёх источников — `GFile`, путь к файлу, готовый `GdkPixbuf` (декодированное изображение в памяти — например, полученное после программной обработки), либо произвольный `GdkPaintable` (наиболее общий вариант — то же, что принимает `gtk_image_new_from_paintable` из справочника по вспомогательным виджетам, включая, например, кадр видео). `get_file` читает текущий источник обратно, если содержимое было установлено именно через файл.

- `picture` — виджет изображения.
- `file` / `filename` / `pixbuf` / `paintable` — новый источник изображения.

```nim
gtk_picture_set_filename(photoView, "/home/user/Pictures/other-photo.jpg")
echo "Отображаемая фотография заменена на другую"
```

---

### `gtk_picture_set_can_shrink` / `gtk_picture_get_can_shrink`

```nim
proc gtk_picture_set_can_shrink*(picture: GtkPicture, canShrink: gboolean)
proc gtk_picture_get_can_shrink*(picture: GtkPicture): gboolean
```

**Что делает.** Разрешают изображению сжиматься меньше его собственного естественного размера, если места не хватает (включено по умолчанию — `GtkPicture`, в отличие от `GtkImage`, изначально спроектирован под масштабируемые изображения переменного размера, а не иконки фиксированного размера). Отключение (`0.gboolean`) заставляет контейнер, в который помещено изображение, всегда выделять ему не меньше естественного размера картинки — контейнер при нехватке места скорее покажет полосы прокрутки или обрежет само изображение по краям, чем уменьшит его.

- `picture` — виджет изображения.
- `canShrink` — `0.gboolean`, чтобы запретить сжатие меньше естественного размера.

```nim
gtk_picture_set_can_shrink(photoView, 1.gboolean)  # значение по умолчанию, указано явно для ясности
echo "Изображение будет масштабироваться под доступное место, сохраняя пропорции"
```

---

## GtkFlowBox

`GtkFlowBox` — контейнер, выстраивающий однотипные "карточки" в поток, автоматически переносящий их на новую строку/столбец по мере нехватки места (аналог CSS `flexbox`/`flex-wrap` из веб-вёрстки) — типичное применение: галерея превью изображений, сетка значков приложений, облако тегов.

### `gtk_flow_box_new`

```nim
proc gtk_flow_box_new*(): GtkFlowBox
```

**Что делает.** Создаёт пустой поток.

- Параметров нет.

```nim
let gallery = gtk_flow_box_new()
echo "Контейнер-галерея создан"
```

---

### `gtk_flow_box_insert` / `gtk_flow_box_append` / `gtk_flow_box_prepend` / `gtk_flow_box_remove`

```nim
proc gtk_flow_box_insert*(box: GtkFlowBox, widget: GtkWidget, position: gint)
proc gtk_flow_box_append*(box: GtkFlowBox, widget: GtkWidget)
proc gtk_flow_box_prepend*(box: GtkFlowBox, widget: GtkWidget)
proc gtk_flow_box_remove*(box: GtkFlowBox, widget: GtkWidget)
```

**Что делает.** Добавляют и убирают элементы потока — та же логика порядка вставки, что у `gtk_box_append`/`prepend`/`insert` из базового справочника. Как и `GtkListBox` (справочник по многовидовым контейнерам), `GtkFlowBox` автоматически оборачивает добавляемый виджет в `GtkFlowBoxChild`, если он не был создан явно (см. последний подраздел).

- `box` — поток.
- `widget` — добавляемый/убираемый виджет.
- `position` (для `insert`) — индекс вставки.

```nim
for photoPath in ["photo1.jpg", "photo2.jpg", "photo3.jpg"]:
  gtk_flow_box_append(gallery, gtk_picture_new_for_filename(photoPath.cstring))
echo "Три превью добавлены в галерею"
```

---

### `gtk_flow_box_set_homogeneous` / `gtk_flow_box_get_homogeneous`

```nim
proc gtk_flow_box_set_homogeneous*(box: GtkFlowBox, homogeneous: gboolean)
proc gtk_flow_box_get_homogeneous*(box: GtkFlowBox): gboolean
```

**Что делает.** Заставляют все элементы потока иметь одинаковый размер (по самому крупному) — та же логика, что у `gtk_box_set_homogeneous`/`gtk_grid_set_row/column_homogeneous`. Для галереи превью обычно включается, чтобы карточки визуально выстраивались в аккуратную равномерную сетку.

- `box` — поток.
- `homogeneous` — `1.gboolean` для одинакового размера всех элементов.

```nim
gtk_flow_box_set_homogeneous(gallery, 1.gboolean)
echo "Все превью в галерее теперь одного размера"
```

---

### `gtk_flow_box_set_row_spacing` / `get_row_spacing` / `set_column_spacing` / `get_column_spacing`

```nim
proc gtk_flow_box_set_row_spacing*(box: GtkFlowBox, spacing: guint)
proc gtk_flow_box_get_row_spacing*(box: GtkFlowBox): guint
proc gtk_flow_box_set_column_spacing*(box: GtkFlowBox, spacing: guint)
proc gtk_flow_box_get_column_spacing*(box: GtkFlowBox): guint
```

**Что делает.** Задают промежутки между строками и между столбцами потока независимо — та же логика, что у `gtk_grid_set_row_spacing`/`set_column_spacing`.

- `box` — поток.
- `spacing` — промежуток в пикселях.

```nim
gtk_flow_box_set_row_spacing(gallery, 12)
gtk_flow_box_set_column_spacing(gallery, 12)
echo "Промежутки между превью в галерее установлены"
```

---

### `gtk_flow_box_set_min_children_per_line` / `get_min_children_per_line` / `set_max_children_per_line` / `get_max_children_per_line`

```nim
proc gtk_flow_box_set_min_children_per_line*(box: GtkFlowBox, nChildren: guint)
proc gtk_flow_box_get_min_children_per_line*(box: GtkFlowBox): guint
proc gtk_flow_box_set_max_children_per_line*(box: GtkFlowBox, nChildren: guint)
proc gtk_flow_box_get_max_children_per_line*(box: GtkFlowBox): guint
```

**Что делает.** Ограничивают, сколько элементов помещается в одну строку/столбец потока, независимо от того, сколько бы их поместилось чисто по ширине. `min_children_per_line` — минимум, ниже которого GTK не станет уменьшать число элементов в строке, даже если места категорически не хватает (при необходимости элементы будут обрезаны/потребуют прокрутки, но не переносятся на дополнительные строки сверх этого ограничения на количество строк). `max_children_per_line` — потолок, при котором остальное свободное место по ширине просто остаётся пустым, а не заполняется ещё большим числом элементов в строке.

- `box` — поток.
- `nChildren` — количество элементов на строку.

```nim
gtk_flow_box_set_min_children_per_line(gallery, 2)
gtk_flow_box_set_max_children_per_line(gallery, 6)
echo "В галерее в одной строке будет от 2 до 6 превью в зависимости от ширины окна"
```

---

### `gtk_flow_box_set_selection_mode` / `gtk_flow_box_get_selection_mode`

```nim
proc gtk_flow_box_set_selection_mode*(box: GtkFlowBox, mode: GtkSelectionMode)
proc gtk_flow_box_get_selection_mode*(box: GtkFlowBox): GtkSelectionMode
```

**Что делает.** Задают режим выбора элементов потока — та же логика и те же значения `GtkSelectionMode`, что у `gtk_list_box_set_selection_mode` из справочника по многовидовым контейнерам.

- `box` — поток.
- `mode` — значение `GtkSelectionMode`.

```nim
gtk_flow_box_set_selection_mode(gallery, GTK_SELECTION_MULTIPLE)
echo "В галерее можно выбрать сразу несколько фотографий"
```

---

### `gtk_flow_box_child_new` / `set_child` / `get_child` / `get_index`

```nim
proc gtk_flow_box_child_new*(): GtkFlowBoxChild
proc gtk_flow_box_child_set_child*(child: GtkFlowBoxChild, widget: GtkWidget)
proc gtk_flow_box_child_get_child*(child: GtkFlowBoxChild): GtkWidget
proc gtk_flow_box_child_get_index*(child: GtkFlowBoxChild): gint
```

**Что делает.** Явное создание элемента потока отдельно от добавления в него — та же логика, что у `gtk_list_box_row_new`/`row_set_child`/`row_get_child`/`row_get_index` из справочника по многовидовым контейнерам, но для `GtkFlowBox` вместо `GtkListBox`. Нужно, когда с элементом требуется что-то сделать до или помимо установки содержимого (например, задать `gtk_widget_set_name` для точечной CSS-стилизации конкретной карточки).

- `child` — элемент потока.
- `widget` — содержимое элемента.

```nim
let customChild = gtk_flow_box_child_new()
gtk_flow_box_child_set_child(customChild, gtk_picture_new_for_filename("cover.jpg"))
gtk_flow_box_append(gallery, customChild)
echo "Элемент потока создан явно, с индексом ", gtk_flow_box_child_get_index(customChild)
```

---

## GtkViewport

`GtkViewport` — вспомогательный контейнер, который делает свой единственный дочерний виджет прокручиваемым, даже если сам этот виджет не умеет прокручиваться самостоятельно. `GtkScrolledWindow` (справочник по вспомогательным виджетам) на практике использует `GtkViewport` автоматически "под капотом" для виджетов, не поддерживающих прокрутку нативно, — поэтому в большинстве сценариев `GtkViewport` не нужно создавать вручную. Явное использование нужно в первую очередь для тонкой настройки поведения фокуса при прокрутке.

### `gtk_viewport_new`

```nim
proc gtk_viewport_new*(hadjustment: GtkAdjustment, vadjustment: GtkAdjustment): GtkViewport
```

**Что делает.** Создаёт вьюпорт с явно заданными горизонтальным и вертикальным `GtkAdjustment` (справочник по числовым и выборочным элементам управления) — обычно передаются `nil`/`nil`, и `GtkScrolledWindow`, в который вьюпорт вложен, создаёт и подключает собственные adjustment'ы автоматически.

- `hadjustment`, `vadjustment` — объекты настройки диапазона прокрутки, либо `nil` для автоматически создаваемых.

```nim
let viewport = gtk_viewport_new(nil, nil)
echo "Вьюпорт создан с автоматически подключаемыми adjustment'ами"
```

---

### `gtk_viewport_set_child` / `gtk_viewport_get_child`

```nim
proc gtk_viewport_set_child*(viewport: GtkViewport, child: GtkWidget)
proc gtk_viewport_get_child*(viewport: GtkViewport): GtkWidget
```

**Что делает.** Устанавливают и читают единственный дочерний виджет, который вьюпорт делает прокручиваемым, — тот же паттерн "один слот содержимого", что и у большинства контейнеров этой серии справочников.

- `viewport` — вьюпорт.
- `child` — виджет-содержимое.

```nim
gtk_viewport_set_child(viewport, gtk_fixed_new())  # GtkFixed сам по себе не умеет прокручиваться
echo "Контейнер абсолютного позиционирования теперь прокручивается через вьюпорт"
```

---

### `gtk_viewport_set_scroll_to_focus` / `gtk_viewport_get_scroll_to_focus`

```nim
proc gtk_viewport_set_scroll_to_focus*(viewport: GtkViewport, scrollToFocus: gboolean)
proc gtk_viewport_get_scroll_to_focus*(viewport: GtkViewport): gboolean
```

**Что делает.** Управляют тем, прокручивается ли содержимое автоматически, чтобы показать виджет, получивший клавиатурный фокус (например, при переходе по `Tab` между полями длинной формы внутри прокручиваемой области) — включено по умолчанию. Отключение может понадобиться для нестандартных сценариев прокрутки, где приложение управляет позицией прокрутки полностью самостоятельно и автоматическое поведение мешало бы.

- `viewport` — вьюпорт.
- `scrollToFocus` — `0.gboolean`, чтобы отключить автопрокрутку к сфокусированному виджету.

```nim
echo "Автопрокрутка к сфокусированному полю: ", gtk_viewport_get_scroll_to_focus(viewport) != 0.gboolean
```

---

## Практические рецепты

### Полоса поиска, разворачиваемая по Ctrl+F

Полная связка `GtkSearchBar` + `GtkSearchEntry`, встроенная над содержимым окна.

```nim
proc buildSearchableView(content: GtkWidget): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0)

  let searchBar = gtk_search_bar_new()
  let searchEntry = gtk_search_entry_new()
  gtk_search_bar_set_child(searchBar, searchEntry)
  gtk_search_bar_set_show_close_button(searchBar, 1.gboolean)

  gtk_box_append(result, searchBar)
  gtk_box_append(result, content)

  proc onSearchChanged(entry: GtkSearchEntry, userData: gpointer) {.cdecl.} =
    echo "Фильтрация по запросу: ", $gtk_editable_get_text(entry)
  discard g_signal_connect(searchEntry, "search-changed", onSearchChanged, nil)

  echo "Панель поиска встроена над основным содержимым, изначально скрыта"

# Показ панели по Ctrl+F делается вызовом gtk_search_bar_set_search_mode(searchBar, 1.gboolean)
# из обработчика соответствующего сочетания клавиш (см. справочник по действиям и сигналам).
```

---

### Индикатор уровня заряда батареи с сегментами

`GtkLevelBar` в панели статуса, обновляемый по мере изменения реального заряда.

```nim
proc buildBatteryIndicator(): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 6)

  let icon = gtk_image_new_from_icon_name("battery-symbolic")
  let level = gtk_level_bar_new_for_interval(0.0, 100.0)
  gtk_widget_set_size_request(level, 80, -1)

  gtk_box_append(result, icon)
  gtk_box_append(result, level)
  echo "Индикатор заряда батареи с иконкой и полосой уровня собран"

proc updateBatteryLevel(level: GtkLevelBar, percent: float) =
  gtk_level_bar_set_value(level, percent)
```

---

### Галерея превью изображений на GtkFlowBox

Адаптивная сетка превью, автоматически подстраивающая количество карточек в строке под ширину окна.

```nim
proc buildPhotoGallery(photoPaths: openArray[string]): GtkFlowBox =
  result = gtk_flow_box_new()
  gtk_flow_box_set_homogeneous(result, 1.gboolean)
  gtk_flow_box_set_row_spacing(result, 8)
  gtk_flow_box_set_column_spacing(result, 8)
  gtk_flow_box_set_min_children_per_line(result, 2)
  gtk_flow_box_set_max_children_per_line(result, 8)
  gtk_flow_box_set_selection_mode(result, GTK_SELECTION_SINGLE)

  for path in photoPaths:
    let picture = gtk_picture_new_for_filename(path.cstring)
    gtk_widget_set_size_request(picture, 120, 120)
    gtk_flow_box_append(result, picture)

  echo "Галерея из ", photoPaths.len, " превью собрана с адаптивной сеткой 2–8 в строке"

let gallery = buildPhotoGallery(["1.jpg", "2.jpg", "3.jpg", "4.jpg", "5.jpg"])
```

---

### Панель действий внизу окна с кнопками по краям

`GtkActionBar` для режима множественного выбора со счётчиком по центру.

```nim
proc buildSelectionActionBar(): GtkActionBar =
  result = gtk_action_bar_new()

  let cancelButton = gtk_button_new_with_label("Отмена")
  gtk_action_bar_pack_start(result, cancelButton)

  let countLabel = gtk_label_new("0 выбрано")
  gtk_action_bar_set_center_widget(result, countLabel)

  let deleteButton = gtk_button_new_with_label("Удалить")
  gtk_widget_add_css_class(deleteButton, "destructive-action")
  gtk_action_bar_pack_end(result, deleteButton)

  echo "Панель действий режима выбора собрана: Отмена / счётчик / Удалить"

proc updateSelectionCount(bar: GtkActionBar, count: int) =
  let countLabel = gtk_action_bar_get_center_widget(bar)
  gtk_label_set_text(cast[GtkLabel](countLabel), (($count) & " выбрано").cstring)

let selectionBar = buildSelectionActionBar()
```

---

### Ссылка на внешний ресурс в тексте описания

Кнопка-ссылка, встроенная в обычный поток компоновки формы, рядом с описанием.

```nim
proc buildLicenseNotice(): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 4)
  gtk_box_append(result, gtk_label_new("Распространяется по лицензии MIT."))

  let licenseLink = gtk_link_button_new_with_label("https://opensource.org/licenses/MIT", "Подробнее")
  gtk_widget_add_css_class(licenseLink, "flat")
  gtk_box_append(result, licenseLink)

  echo "Строка с уведомлением о лицензии и кликабельной ссылкой собрана"

let licenseNotice = buildLicenseNotice()
```

---

## Краткая таблица

| Процедура(ы) | Категория | Что делает вкратце |
|---|---|---|
| `gtk_info_bar_new` | InfoBar (устарел) | Создать информационную полосу |
| `gtk_info_bar_add_button` | InfoBar (устарел) | Добавить кнопку с кодом ответа |
| `gtk_info_bar_add/remove_child` | InfoBar (устарел) | Содержимое полосы (не кнопки) |
| `gtk_info_bar_set/get_message_type` | InfoBar (устарел) | Тип сообщения (цвет/иконка) |
| `gtk_info_bar_set/get_show_close_button` | InfoBar (устарел) | Встроенная кнопка закрытия |
| `gtk_info_bar_set/get_revealed` | InfoBar (устарел) | Показ/скрытие с анимацией |
| `gtk_statusbar_new` | Statusbar (устарел) | Создать статусную строку |
| `gtk_statusbar_get_context_id` | Statusbar (устарел) | Идентификатор группы сообщений |
| `gtk_statusbar_push/pop/remove/remove_all` | Statusbar (устарел) | Стек сообщений по контексту |
| `gtk_level_bar_new`, `_for_interval` | LevelBar | Создать индикатор уровня |
| `gtk_level_bar_set/get_value` | LevelBar | Текущий уровень |
| `gtk_level_bar_set/get_min/max_value` | LevelBar | Границы диапазона |
| `gtk_link_button_new`, `_with_label` | LinkButton | Создать кнопку-ссылку |
| `gtk_link_button_set/get_uri` | LinkButton | Целевой адрес |
| `gtk_link_button_set/get_visited` | LinkButton | Визуальное состояние "посещена" |
| `gtk_action_bar_new` | ActionBar | Создать панель действий |
| `gtk_action_bar_pack_start/end`, `remove` | ActionBar | Виджеты по краям панели |
| `gtk_action_bar_set/get_center_widget` | ActionBar | Виджет по центру панели |
| `gtk_search_bar_new` | SearchBar | Создать панель поиска |
| `gtk_search_bar_set/get_child` | SearchBar | Содержимое панели |
| `gtk_search_bar_set/get_search_mode` | SearchBar | Показ/скрытие панели |
| `gtk_search_bar_set/get_show_close_button` | SearchBar | Встроенная кнопка закрытия |
| `gtk_picture_new`, `_for_file`, `_for_filename` | Picture | Создать виджет изображения |
| `gtk_picture_set/get_file`, `set_filename/pixbuf/paintable` | Picture | Сменить источник изображения |
| `gtk_picture_set/get_can_shrink` | Picture | Разрешить сжатие меньше естественного размера |
| `gtk_flow_box_new` | FlowBox | Создать поток однотипных карточек |
| `gtk_flow_box_insert/append/prepend/remove` | FlowBox | Добавить/убрать элемент |
| `gtk_flow_box_set/get_homogeneous` | FlowBox | Одинаковый размер всех элементов |
| `gtk_flow_box_set/get_row/column_spacing` | FlowBox | Промежутки между строками/столбцами |
| `gtk_flow_box_set/get_min/max_children_per_line` | FlowBox | Мин./макс. число элементов в строке |
| `gtk_flow_box_set/get_selection_mode` | FlowBox | Режим выбора элементов |
| `gtk_flow_box_child_new`, `set/get_child`, `get_index` | FlowBox | Явное создание элемента потока |
| `gtk_viewport_new` | Viewport | Создать вьюпорт для прокрутки |
| `gtk_viewport_set/get_child` | Viewport | Прокручиваемое содержимое |
| `gtk_viewport_set/get_scroll_to_focus` | Viewport | Автопрокрутка к сфокусированному виджету |

---

## Сводка: какую процедуру выбрать

- **Статусное сообщение или предупреждение вверху содержимого окна** → в новом коде предпочтительнее собственный виджет с `GtkRevealer` или баннер вместо `GtkInfoBar`/`GtkStatusbar` — оба устарели; если всё же нужен именно `GtkInfoBar` (например, для совместимости с существующим кодом), используйте `gtk_info_bar_set_revealed` для показа/скрытия, а не `gtk_widget_set_visible`, чтобы не потерять встроенную анимацию.
- **Иконка из системной темы** → `GtkImage` (справочник по вспомогательным виджетам). **Фотография или изображение переменного размера с сохранением пропорций** → `GtkPicture`, а не `GtkImage` — рассчитан именно на такой случай.
- **Статичный уровень значения** (заряд, громкость, сигнал) → `GtkLevelBar`. **Прогресс выполняющейся операции** → `GtkProgressBar` (справочник по вспомогательным виджетам) — оба выглядят похоже, но сигнализируют разный смысл пользователю.
- **Кликабельная ссылка на внешний ресурс** → `GtkLinkButton`, который сам открывает URI при клике, а не обычная `GtkButton` с самостоятельно написанным обработчиком, вызывающим системную функцию открытия URI.
- **Сетка однотипных карточек переменного количества** (галерея, облако тегов, значки) → `GtkFlowBox`, а не `GtkGrid` с фиксированным числом столбцов — поток сам переносит элементы по мере нехватки места, подстраиваясь под ширину окна.
- **Панель поиска, появляющаяся по запросу** (`Ctrl+F`) → `GtkSearchBar`, оборачивающий `GtkSearchEntry` и дающий встроенную анимацию показа/скрытия, а не ручное управление видимостью обычного `GtkSearchEntry` через `gtk_widget_set_visible`.
- **Панель кнопок действий внизу окна** (не системные кнопки, а контекстные действия — например, режим выбора) → `GtkActionBar`, визуально согласованная по стилю с `GtkHeaderBar`, а не `GtkBox` с ручной стилизацией под панель.
- **Виджет, который сам по себе не прокручивается, нужно поместить в прокручиваемую область** → обычно достаточно просто обернуть его в `GtkScrolledWindow` напрямую — `GtkScrolledWindow` создаёт `GtkViewport` автоматически при необходимости; создавать `GtkViewport` вручную нужно только для тонкой настройки (например, `scroll_to_focus`).
