# GTK4 (window chrome & dialogs: HeaderBar / MessageDialog / Dialog / FileChooser) — справочник модуля

> **Импорт:** `import libGTK4`
> **Область применения:** пользовательская заголовочная панель окна и три вида диалогов — сообщение, произвольный диалог с кнопками, диалог выбора файла. Восьмая часть серии справочников по обёртке; предполагает знакомство с предыдущими частями, особенно с `gtk4_core_reference_ru.md` (окно, `gtk_window_set_titlebar`) и `gtk4_basic_controls_reference_ru.md` (кнопки).

`GtkHeaderBar` — виджет, которым в предыдущем справочнике заменяли стандартную заголовочную панель окна через `gtk_window_set_titlebar`; здесь он рассматривается подробно. Три оставшихся виджета — разные по сложности диалоговые окна: `GtkMessageDialog` — готовое диалоговое окно "текст + набор стандартных кнопок" для простых сообщений, `GtkDialog` — конструктор произвольного диалога с собственным содержимым и кнопками, `GtkFileChooserDialog` — специализированный системный диалог выбора файла/папки.

---

## Оглавление

I. [GtkHeaderBar](#gtkheaderbar)
&nbsp;&nbsp;1. [`gtk_header_bar_new`](#gtk_header_bar_new)
&nbsp;&nbsp;2. [`gtk_header_bar_pack_start` / `gtk_header_bar_pack_end` / `gtk_header_bar_remove`](#gtk_header_bar_pack_start--gtk_header_bar_pack_end--gtk_header_bar_remove)
&nbsp;&nbsp;3. [`gtk_header_bar_set_title_widget` / `gtk_header_bar_get_title_widget`](#gtk_header_bar_set_title_widget--gtk_header_bar_get_title_widget)
&nbsp;&nbsp;4. [`gtk_header_bar_set_show_title_buttons` / `gtk_header_bar_get_show_title_buttons`](#gtk_header_bar_set_show_title_buttons--gtk_header_bar_get_show_title_buttons)
&nbsp;&nbsp;5. [`gtk_header_bar_set_decoration_layout` / `gtk_header_bar_get_decoration_layout`](#gtk_header_bar_set_decoration_layout--gtk_header_bar_get_decoration_layout)

II. [GtkMessageDialog](#gtkmessagedialog)
&nbsp;&nbsp;1. [`gtk_message_dialog_new`](#gtk_message_dialog_new)
&nbsp;&nbsp;2. [`gtk_message_dialog_set_markup`](#gtk_message_dialog_set_markup)

III. [GtkDialog](#gtkdialog)
&nbsp;&nbsp;1. [`gtk_dialog_new`](#gtk_dialog_new)
&nbsp;&nbsp;2. [`gtk_dialog_add_button` / `gtk_dialog_add_action_widget`](#gtk_dialog_add_button--gtk_dialog_add_action_widget)
&nbsp;&nbsp;3. [`gtk_dialog_set_default_response`](#gtk_dialog_set_default_response)
&nbsp;&nbsp;4. [`gtk_dialog_get_content_area` / `gtk_dialog_get_header_bar`](#gtk_dialog_get_content_area--gtk_dialog_get_header_bar)
&nbsp;&nbsp;5. [`gtk_dialog_response`](#gtk_dialog_response)

IV. [GtkFileChooserDialog](#gtkfilechooserdialog)
&nbsp;&nbsp;1. [`gtk_file_chooser_dialog_new`](#gtk_file_chooser_dialog_new)
&nbsp;&nbsp;2. [`gtk_file_chooser_set_current_name`](#gtk_file_chooser_set_current_name)
&nbsp;&nbsp;3. [`gtk_file_chooser_get_file` / `gtk_file_chooser_set_file`](#gtk_file_chooser_get_file--gtk_file_chooser_set_file)
&nbsp;&nbsp;4. [`gtk_file_chooser_set_current_folder` / `gtk_file_chooser_get_current_folder`](#gtk_file_chooser_set_current_folder--gtk_file_chooser_get_current_folder)

V. [Практические рецепты](#практические-рецепты)
&nbsp;&nbsp;1. [Заголовочная панель с кнопками действий по краям](#заголовочная-панель-с-кнопками-действий-по-краям)
&nbsp;&nbsp;2. [Диалог подтверждения удаления](#диалог-подтверждения-удаления)
&nbsp;&nbsp;3. [Произвольный диалог настроек с кнопками Отмена/Применить](#произвольный-диалог-настроек-с-кнопками-отменаприменить)
&nbsp;&nbsp;4. [Диалог сохранения файла с именем по умолчанию](#диалог-сохранения-файла-с-именем-по-умолчанию)
&nbsp;&nbsp;5. [Заголовочная панель без стандартных кнопок с собственным виджетом заголовка](#заголовочная-панель-без-стандартных-кнопок-с-собственным-виджетом-заголовка)

VI. [Краткая таблица](#краткая-таблица)

VII. [Сводка: какую процедуру выбрать](#сводка-какую-процедуру-выбрать)

---

## GtkHeaderBar

`GtkHeaderBar` заменяет стандартную заголовочную панель окна (см. `gtk_window_set_titlebar` в базовом справочнике) на панель с произвольными виджетами по краям — кнопками действий, переключателями режима, полем поиска — при сохранении системных кнопок управления окном (свернуть/развернуть/закрыть) в углу.

### `gtk_header_bar_new`

```nim
proc gtk_header_bar_new*(): GtkHeaderBar
```

**Что делает.** Создаёт пустую заголовочную панель. Сама по себе не привязана ни к какому окну — привязка происходит отдельным вызовом `gtk_window_set_titlebar(window, headerBar)` (базовый справочник).

- Параметров нет.

```nim
let headerBar = gtk_header_bar_new()
gtk_window_set_titlebar(mainWindow, headerBar)
echo "Пользовательская заголовочная панель создана и установлена в окно"
```

---

### `gtk_header_bar_pack_start` / `gtk_header_bar_pack_end` / `gtk_header_bar_remove`

```nim
proc gtk_header_bar_pack_start*(bar: GtkHeaderBar, child: GtkWidget)
proc gtk_header_bar_pack_end*(bar: GtkHeaderBar, child: GtkWidget)
proc gtk_header_bar_remove*(bar: GtkHeaderBar, child: GtkWidget)
```

**Что делает.** Добавляют виджет в левую (`pack_start`) или правую (`pack_end`) часть заголовочной панели — независимо от направления письма локали (`start`/`end`, а не буквально "лево"/"право", как и у отступов `GtkWidget` в базовом справочнике). Каждая сторона может содержать несколько виджетов — они выстраиваются в ряд в порядке добавления, ближе к соответствующему краю панели, оставляя область заголовка (или `title_widget`, см. ниже) в центре.

- `bar` — заголовочная панель.
- `child` — добавляемый/удаляемый виджет.

```nim
gtk_header_bar_pack_start(headerBar, gtk_button_new_from_icon_name("document-new-symbolic"))
gtk_header_bar_pack_end(headerBar, gtk_button_new_from_icon_name("open-menu-symbolic"))
echo "Кнопка создания документа слева, кнопка меню справа"
```

---

### `gtk_header_bar_set_title_widget` / `gtk_header_bar_get_title_widget`

```nim
proc gtk_header_bar_set_title_widget*(bar: GtkHeaderBar, titleWidget: GtkWidget)
proc gtk_header_bar_get_title_widget*(bar: GtkHeaderBar): GtkWidget
```

**Что делает.** Заменяют центральную область заголовка (по умолчанию показывающую заголовок окна, заданный `gtk_window_set_title`, — базовый справочник) на произвольный виджет — типично `GtkStackSwitcher` (справочник по многовидовым контейнерам) для приложений, где вкладки/режимы переключаются прямо в заголовке окна, либо `GtkSearchEntry` (справочник по вводу текста) для приложений, где поиск — центральное действие.

- `bar` — заголовочная панель.
- `titleWidget` — виджет для центральной области.

```nim
let modeSwitcher = gtk_stack_switcher_new()
gtk_stack_switcher_set_stack(modeSwitcher, viewStack)
gtk_header_bar_set_title_widget(headerBar, modeSwitcher)
echo "Переключатель режимов просмотра занял центральную область заголовка вместо текста"
```

---

### `gtk_header_bar_set_show_title_buttons` / `gtk_header_bar_get_show_title_buttons`

```nim
proc gtk_header_bar_set_show_title_buttons*(bar: GtkHeaderBar, setting: gboolean)
proc gtk_header_bar_get_show_title_buttons*(bar: GtkHeaderBar): gboolean
```

**Что делает.** Показывают/скрывают системные кнопки управления окном (свернуть/развернуть/закрыть), обычно расположенные в углу заголовочной панели, — включено по умолчанию. Отключение уместно для дополнительных `GtkHeaderBar`, встроенных не в само окно, а, например, внутрь боковой панели или диалога, где системные кнопки окна были бы неуместны или дублировали бы уже показанные на основном окне.

- `bar` — заголовочная панель.
- `setting` — `0.gboolean`, чтобы скрыть системные кнопки.

```nim
let sidebarHeader = gtk_header_bar_new()
gtk_header_bar_set_show_title_buttons(sidebarHeader, 0.gboolean)
echo "Дополнительная заголовочная панель боковой панели без системных кнопок окна"
```

---

### `gtk_header_bar_set_decoration_layout` / `gtk_header_bar_get_decoration_layout`

```nim
proc gtk_header_bar_set_decoration_layout*(bar: GtkHeaderBar, layout: cstring)
proc gtk_header_bar_get_decoration_layout*(bar: GtkHeaderBar): cstring
```

**Что делает.** Задают, какие системные кнопки показывать и с какой стороны, строкой специального формата: элементы слева от двоеточия располагаются в начале панели, справа — в конце; сами элементы — `close`, `minimize`, `maximize`, разделённые запятыми (например, `"close:minimize,maximize"` — кнопка закрытия слева, сворачивание и разворачивание справа). Передача `nil` возвращает раскладку кнопок, заданную настройками окружения рабочего стола, — то, что используется по умолчанию и в большинстве случаев менять не требуется, поскольку так заголовок выглядит нативно для конкретной ОС пользователя.

- `bar` — заголовочная панель.
- `layout` — строка раскладки, либо `nil` для системного значения по умолчанию.

```nim
gtk_header_bar_set_decoration_layout(headerBar, "close:minimize,maximize")
echo "Раскладка системных кнопок: ", $gtk_header_bar_get_decoration_layout(headerBar)
```

---

## GtkMessageDialog

`GtkMessageDialog` — готовый диалог для простых сообщений пользователю: иконка по типу сообщения, текст, стандартный набор кнопок — без необходимости вручную собирать содержимое, как для `GtkDialog` (раздел III).

### `gtk_message_dialog_new`

```nim
proc gtk_message_dialog_new*(parent: GtkWindow, flags: gint, msgType: GtkMessageType, buttons: GtkButtonsType, messageFormat: cstring): GtkMessageDialog {.varargs.}
```

**Что делает.** Создаёт диалог сообщения. `msgType` определяет показываемую иконку (`GTK_MESSAGE_INFO`, `_WARNING`, `_QUESTION`, `_ERROR`, `_OTHER` — без иконки). `buttons` задаёт готовый набор кнопок одним значением (`GTK_BUTTONS_OK`, `_CLOSE`, `_CANCEL`, `_YES_NO`, `_OK_CANCEL`, `_NONE` — без кнопок, добавляемых затем вручную через `gtk_dialog_add_button`, поскольку `GtkMessageDialog` — это подтип `GtkDialog`). `messageFormat` и последующие переменные аргументы — это `printf`-подобная строка формата (то же поведение, что у C-функции `printf`) — параметр объявлен с `{.varargs.}`, поэтому в Nim вызывается с обычными дополнительными аргументами после строки формата.

- **Реализация.** Поскольку `messageFormat` интерпретируется как `printf`-строка формата на стороне C, если текст сообщения формируется из пользовательских данных (например, имени файла), в нём не должно попадаться случайных символов `%` — безопаснее передавать готовую Nim-строку с единственным спецификатором `%s`, а не подставлять пользовательский ввод прямо в саму строку формата.

- `parent` — родительское окно.
- `flags` — зарезервированный битовый флаг (обычно `0`).
- `msgType` — значение `GtkMessageType`.
- `buttons` — значение `GtkButtonsType`.
- `messageFormat` — `printf`-подобная строка формата, с последующими аргументами по необходимости.

```nim
let confirmDialog = gtk_message_dialog_new(mainWindow, 0, GTK_MESSAGE_QUESTION, GTK_BUTTONS_YES_NO,
                                            "Удалить файл \"%s\" безвозвратно?", "report.pdf".cstring)
gtk_window_set_modal(confirmDialog, 1.gboolean)
gtk_window_present(confirmDialog)
echo "Диалог подтверждения удаления показан"
```

---

### `gtk_message_dialog_set_markup`

```nim
proc gtk_message_dialog_set_markup*(messageDialog: GtkMessageDialog, str: cstring)
```

**Что делает.** Заменяет основной текст сообщения на текст с Pango-разметкой (аналог `gtk_label_set_markup` из справочника по базовым элементам управления) — например, чтобы выделить жирным ключевую часть сообщения на фоне обычного текста.

- `messageDialog` — диалог сообщения.
- `str` — текст с Pango-разметкой.

```nim
gtk_message_dialog_set_markup(confirmDialog, "Удалить файл <b>report.pdf</b> безвозвратно?")
echo "Имя файла в тексте диалога теперь выделено жирным"
```

---

## GtkDialog

`GtkDialog` — конструктор произвольного диалога: собственная область содержимого плюс ряд кнопок действий, каждая из которых при нажатии сообщает о выборе пользователя числовым кодом ответа через сигнал `"response"`. В отличие от `GtkMessageDialog`, содержимое и набор кнопок собираются вручную, что даёт полный контроль над версткой.

### `gtk_dialog_new`

```nim
proc gtk_dialog_new*(): GtkDialog
```

**Что делает.** Создаёт пустой диалог без кнопок и без содержимого — оба добавляются последующими вызовами.

- Параметров нет.

```nim
let settingsDialog = gtk_dialog_new()
gtk_window_set_title(settingsDialog, "Настройки экспорта")
echo "Пустой диалог настроек создан"
```

---

### `gtk_dialog_add_button` / `gtk_dialog_add_action_widget`

```nim
proc gtk_dialog_add_button*(dialog: GtkDialog, buttonText: cstring, responseId: gint): GtkWidget
proc gtk_dialog_add_action_widget*(dialog: GtkDialog, child: GtkWidget, responseId: gint)
```

**Что делает.** Добавляют кнопку действия в диалог. `gtk_dialog_add_button` — короткая форма: создаёт обычную текстовую кнопку сама и возвращает её (например, чтобы затем стилизовать через `gtk_widget_add_css_class` классом `"suggested-action"`/`"destructive-action"`). `gtk_dialog_add_action_widget` — более общая форма, принимающая уже готовый произвольный виджет в качестве элемента действия. `responseId` — числовой код, которым сигнал `"response"` сообщит, какая именно кнопка была нажата; удобно использовать готовые значения `GtkResponseType` (все отрицательные, чтобы не пересекаться с произвольными положительными кодами для нестандартных кнопок).

- `dialog` — диалог.
- `buttonText` — текст кнопки (для `add_button`).
- `child` — произвольный виджет действия (для `add_action_widget`).
- `responseId` — код ответа, сообщаемый сигналом `"response"`.

```nim
discard gtk_dialog_add_button(settingsDialog, "Отмена", ord(GTK_RESPONSE_CANCEL).gint)
let applyButton = gtk_dialog_add_button(settingsDialog, "Применить", ord(GTK_RESPONSE_APPLY).gint)
gtk_widget_add_css_class(applyButton, "suggested-action")
echo "Кнопки 'Отмена' и выделенная 'Применить' добавлены в диалог"
```

---

### `gtk_dialog_set_default_response`

```nim
proc gtk_dialog_set_default_response*(dialog: GtkDialog, responseId: gint)
```

**Что делает.** Назначает, какая из уже добавленных кнопок действия активируется по нажатию Enter — та же логика "кнопки по умолчанию окна", что и `gtk_entry_set_activates_default` из справочника по вводу текста, но выраженная через код ответа, а не сам виджет кнопки напрямую.

- `dialog` — диалог.
- `responseId` — код ответа кнопки, которая должна стать кнопкой по умолчанию.

```nim
gtk_dialog_set_default_response(settingsDialog, ord(GTK_RESPONSE_APPLY).gint)
echo "Enter в диалоге настроек теперь активирует кнопку 'Применить'"
```

---

### `gtk_dialog_get_content_area` / `gtk_dialog_get_header_bar`

```nim
proc gtk_dialog_get_content_area*(dialog: GtkDialog): GtkWidget
proc gtk_dialog_get_header_bar*(dialog: GtkDialog): GtkWidget
```

**Что делает.** `get_content_area` возвращает контейнер, в который нужно добавлять собственное содержимое диалога (через `gtk_box_append`, как в обычный `GtkBox`) — этот контейнер уже существует у любого `GtkDialog` сразу после создания. `get_header_bar` возвращает заголовочную панель диалога (раздел I), если диалог использует её вместо классической области кнопок снизу, — может вернуть `nil`, если диалог использует традиционный стиль.

- `dialog` — диалог.

```nim
let contentArea = gtk_dialog_get_content_area(settingsDialog)
gtk_box_append(cast[GtkBox](contentArea), gtk_label_new("Выберите формат экспорта:"))
gtk_box_append(cast[GtkBox](contentArea), formatCombo)
echo "Содержимое добавлено в область содержимого диалога"
```

---

### `gtk_dialog_response`

```nim
proc gtk_dialog_response*(dialog: GtkDialog, responseId: gint)
```

**Что делает.** Программно эмитирует сигнал `"response"` с заданным кодом ответа, как если бы пользователь нажал соответствующую кнопку, — например, чтобы закрыть диалог после фоновой валидации, или для тестового сценария, эмулирующего нажатие кнопки без реального клика.

- `dialog` — диалог.
- `responseId` — код ответа для эмиссии.

```nim
proc onDialogResponse(dialog: GtkDialog, responseId: gint, userData: gpointer) {.cdecl.} =
  if responseId == ord(GTK_RESPONSE_APPLY).gint:
    echo "Пользователь нажал 'Применить' — сохраняем настройки экспорта"
  gtk_window_destroy(cast[GtkWindow](dialog))

discard g_signal_connect(settingsDialog, "response", onDialogResponse, nil)
gtk_dialog_response(settingsDialog, ord(GTK_RESPONSE_CANCEL).gint)
```

---

## GtkFileChooserDialog

`GtkFileChooserDialog` — системный диалог выбора файла или папки, реализующий интерфейс `GtkFileChooser` поверх `GtkDialog` (так что `gtk_dialog_add_button`/`response` из раздела III применимы и к нему напрямую).

### `gtk_file_chooser_dialog_new`

```nim
proc gtk_file_chooser_dialog_new*(title: cstring, parent: GtkWindow, action: GtkFileChooserAction, firstButtonText: cstring): GtkFileChooserDialog {.varargs.}
```

**Что делает.** Создаёт диалог выбора файла. `action` определяет режим: `GTK_FILE_CHOOSER_ACTION_OPEN` (выбор существующего файла), `_SAVE` (выбор имени и места для сохранения — поле имени файла редактируемо), `_SELECT_FOLDER` (выбор папки, а не файла). После `firstButtonText` следуют переменные аргументы — чередующиеся пары "текст кнопки"/"код ответа", завершённые обязательным `nil` вместо текста кнопки — тот же протокол, что у классических вариативных C-функций.

- **Реализация.** Пропуск завершающего `nil` — частая ошибка: без него GTK продолжит читать память за пределами переданных аргументов в поисках несуществующей следующей пары, что приводит к неопределённому поведению.

- `title` — заголовок диалога.
- `parent` — родительское окно.
- `action` — значение `GtkFileChooserAction`.
- `firstButtonText`, далее пары (текст, код ответа), обязательно завершённые `nil`.

```nim
let openDialog = gtk_file_chooser_dialog_new("Открыть документ", mainWindow, GTK_FILE_CHOOSER_ACTION_OPEN,
                                              "Отмена".cstring, ord(GTK_RESPONSE_CANCEL).gint,
                                              "Открыть".cstring, ord(GTK_RESPONSE_ACCEPT).gint,
                                              nil)
gtk_window_present(openDialog)
echo "Диалог открытия файла показан с кнопками Отмена/Открыть"
```

---

### `gtk_file_chooser_set_current_name`

```nim
proc gtk_file_chooser_set_current_name*(chooser: GtkFileChooser, name: cstring)
```

**Что делает.** Задаёт предлагаемое имя файла в поле ввода имени — работает только в режиме `GTK_FILE_CHOOSER_ACTION_SAVE`. Типичное применение — предложить осмысленное имя по умолчанию при сохранении нового документа.

- `chooser` — диалог выбора файла (или любой другой `GtkFileChooser`).
- `name` — предлагаемое имя файла.

```nim
let saveDialog = gtk_file_chooser_dialog_new("Сохранить как", mainWindow, GTK_FILE_CHOOSER_ACTION_SAVE,
                                              "Отмена".cstring, ord(GTK_RESPONSE_CANCEL).gint,
                                              "Сохранить".cstring, ord(GTK_RESPONSE_ACCEPT).gint,
                                              nil)
gtk_file_chooser_set_current_name(saveDialog, "Новый документ.txt")
echo "Диалог сохранения показан с предложенным именем файла"
```

---

### `gtk_file_chooser_get_file` / `gtk_file_chooser_set_file`

```nim
proc gtk_file_chooser_get_file*(chooser: GtkFileChooser): GFile
proc gtk_file_chooser_set_file*(chooser: GtkFileChooser, file: GFile, error: ptr GError): gboolean
```

**Что делает.** Читают выбранный пользователем файл (обычно внутри обработчика сигнала `"response"` с кодом `GTK_RESPONSE_ACCEPT`) и предустанавливают текущий выбранный файл программно. Значение — объект `GFile` из GIO, а не строка пути напрямую; для получения самого пути нужны отдельные функции `g_file_get_path`/`g_file_get_uri`, не входящие в этот справочник.

- `chooser` — диалог выбора файла.
- `file` — объект `GFile` (для `set_file`).
- `error` — указатель для получения ошибки (можно передать `nil`).

```nim
proc onOpenDialogResponse(dialog: GtkFileChooserDialog, responseId: gint, userData: gpointer) {.cdecl.} =
  if responseId == ord(GTK_RESPONSE_ACCEPT).gint:
    let chosenFile = gtk_file_chooser_get_file(dialog)
    echo "Файл выбран, объект GFile получен: ", not isNil(chosenFile)
  gtk_window_destroy(cast[GtkWindow](dialog))

discard g_signal_connect(openDialog, "response", onOpenDialogResponse, nil)
```

---

### `gtk_file_chooser_set_current_folder` / `gtk_file_chooser_get_current_folder`

```nim
proc gtk_file_chooser_set_current_folder*(chooser: GtkFileChooser, file: GFile, error: ptr GError): gboolean
proc gtk_file_chooser_get_current_folder*(chooser: GtkFileChooser): GFile
```

**Что делает.** Задают и читают папку, открытую в диалоге, — отдельно от самого выбранного файла (`get_file`). Полезно, чтобы каждый следующий диалог открывался в той же папке, где пользователь работал в прошлый раз.

- `chooser` — диалог выбора файла.
- `file` — объект `GFile`, указывающий на папку (для `set_current_folder`).
- `error` — указатель для получения ошибки (можно передать `nil`).

```nim
discard gtk_file_chooser_set_current_folder(openDialog, lastUsedFolder, nil)
echo "Диалог откроется в той же папке, где пользователь выбирал файл в прошлый раз"
```

---

## Практические рецепты

### Заголовочная панель с кнопками действий по краям

Типичная сборка для главного окна: кнопка добавления слева, кнопка меню справа, заголовок окна по центру (по умолчанию).

```nim
proc buildMainHeaderBar(window: GtkWindow): GtkHeaderBar =
  result = gtk_header_bar_new()

  let addButton = gtk_button_new_from_icon_name("list-add-symbolic")
  gtk_header_bar_pack_start(result, addButton)

  let menuButton = gtk_button_new_from_icon_name("open-menu-symbolic")
  gtk_header_bar_pack_end(result, menuButton)

  gtk_window_set_titlebar(window, result)
  echo "Заголовочная панель с кнопками добавления и меню установлена"

# let headerBar = buildMainHeaderBar(mainWindow)
```

---

### Диалог подтверждения удаления

Полная сборка `GtkMessageDialog` с обработкой ответа пользователя и корректным закрытием диалога в любом случае.

```nim
proc confirmDeletion(parent: GtkWindow, itemName: string, onConfirmed: proc()) =
  let dialog = gtk_message_dialog_new(parent, 0, GTK_MESSAGE_WARNING, GTK_BUTTONS_NONE,
                                       "Удалить \"%s\"?", itemName.cstring)
  discard gtk_dialog_add_button(cast[GtkDialog](dialog), "Отмена", ord(GTK_RESPONSE_CANCEL).gint)
  let deleteButton = gtk_dialog_add_button(cast[GtkDialog](dialog), "Удалить", ord(GTK_RESPONSE_ACCEPT).gint)
  gtk_widget_add_css_class(deleteButton, "destructive-action")
  gtk_window_set_modal(dialog, 1.gboolean)

  proc onResponse(d: GtkDialog, responseId: gint, userData: gpointer) {.cdecl.} =
    if responseId == ord(GTK_RESPONSE_ACCEPT).gint:
      echo "Пользователь подтвердил удаление"
    gtk_window_destroy(cast[GtkWindow](d))

  discard g_signal_connect(dialog, "response", onResponse, nil)
  gtk_window_present(dialog)

# confirmDeletion(mainWindow, "report.pdf", proc() = echo "файл удалён")
```

---

### Произвольный диалог настроек с кнопками Отмена/Применить

`GtkDialog` с собственной формой внутри и явно назначенной кнопкой по умолчанию.

```nim
proc buildExportSettingsDialog(parent: GtkWindow): GtkDialog =
  result = cast[GtkDialog](gtk_dialog_new())
  gtk_window_set_title(result, "Настройки экспорта")
  gtk_window_set_transient_for(result, parent)
  gtk_window_set_modal(result, 1.gboolean)

  discard gtk_dialog_add_button(result, "Отмена", ord(GTK_RESPONSE_CANCEL).gint)
  let applyButton = gtk_dialog_add_button(result, "Применить", ord(GTK_RESPONSE_APPLY).gint)
  gtk_widget_add_css_class(applyButton, "suggested-action")
  gtk_dialog_set_default_response(result, ord(GTK_RESPONSE_APPLY).gint)

  let contentArea = gtk_dialog_get_content_area(result)
  let formatCombo = gtk_combo_box_text_new()
  gtk_combo_box_text_append_text(formatCombo, "PNG")
  gtk_combo_box_text_append_text(formatCombo, "JPEG")
  gtk_combo_box_set_active(formatCombo, 0)
  gtk_box_append(cast[GtkBox](contentArea), formatCombo)

  echo "Диалог настроек экспорта с выбором формата собран"

let exportDialog = buildExportSettingsDialog(mainWindow)
```

---

### Диалог сохранения файла с именем по умолчанию

Полная связка `GtkFileChooserDialog` в режиме сохранения с предложенным именем и обработкой результата.

```nim
proc showSaveDialog(parent: GtkWindow, suggestedName: string) =
  let dialog = gtk_file_chooser_dialog_new("Сохранить документ", parent, GTK_FILE_CHOOSER_ACTION_SAVE,
                                            "Отмена".cstring, ord(GTK_RESPONSE_CANCEL).gint,
                                            "Сохранить".cstring, ord(GTK_RESPONSE_ACCEPT).gint,
                                            nil)
  gtk_file_chooser_set_current_name(dialog, suggestedName.cstring)

  proc onResponse(d: GtkFileChooserDialog, responseId: gint, userData: gpointer) {.cdecl.} =
    if responseId == ord(GTK_RESPONSE_ACCEPT).gint:
      let target = gtk_file_chooser_get_file(d)
      echo "Файл будет сохранён, GFile получен: ", not isNil(target)
    gtk_window_destroy(cast[GtkWindow](d))

  discard g_signal_connect(dialog, "response", onResponse, nil)
  gtk_window_present(dialog)

showSaveDialog(mainWindow, "Новый документ.txt")
```

---

### Заголовочная панель без стандартных кнопок с собственным виджетом заголовка

Заголовок диалога с центральным переключателем вкладок вместо простого текста, без системных кнопок окна.

```nim
proc buildDialogHeaderWithSwitcher(stack: GtkStack): GtkHeaderBar =
  result = gtk_header_bar_new()
  gtk_header_bar_set_show_title_buttons(result, 0.gboolean)

  let switcher = gtk_stack_switcher_new()
  gtk_stack_switcher_set_stack(switcher, stack)
  gtk_header_bar_set_title_widget(result, switcher)

  echo "Заголовок диалога с переключателем вкладок вместо текста и без системных кнопок собран"

# let dialogHeader = buildDialogHeaderWithSwitcher(settingsStack)
```

---

## Краткая таблица

| Процедура(ы) | Категория | Что делает вкратце |
|---|---|---|
| `gtk_header_bar_new` | HeaderBar | Создать заголовочную панель |
| `gtk_header_bar_pack_start/end`, `remove` | HeaderBar | Добавить/убрать виджет с края панели |
| `gtk_header_bar_set/get_title_widget` | HeaderBar | Произвольный виджет вместо текста заголовка |
| `gtk_header_bar_set/get_show_title_buttons` | HeaderBar | Показывать ли системные кнопки окна |
| `gtk_header_bar_set/get_decoration_layout` | HeaderBar | Какие системные кнопки и с какой стороны |
| `gtk_message_dialog_new` | MessageDialog | Готовый диалог сообщения с иконкой и кнопками |
| `gtk_message_dialog_set_markup` | MessageDialog | Текст сообщения с Pango-разметкой |
| `gtk_dialog_new` | Dialog | Создать пустой произвольный диалог |
| `gtk_dialog_add_button`, `add_action_widget` | Dialog | Добавить кнопку/произвольный виджет действия |
| `gtk_dialog_set_default_response` | Dialog | Кнопка, активируемая по Enter |
| `gtk_dialog_get_content_area` | Dialog | Контейнер для собственного содержимого диалога |
| `gtk_dialog_get_header_bar` | Dialog | Заголовочная панель диалога, если используется |
| `gtk_dialog_response` | Dialog | Программно эмитировать сигнал "response" |
| `gtk_file_chooser_dialog_new` | FileChooserDialog | Создать диалог выбора файла/папки |
| `gtk_file_chooser_set_current_name` | FileChooserDialog | Предлагаемое имя файла (режим сохранения) |
| `gtk_file_chooser_get_file`, `set_file` | FileChooserDialog | Выбранный файл как объект GFile |
| `gtk_file_chooser_set/get_current_folder` | FileChooserDialog | Текущая открытая в диалоге папка |

---

## Сводка: какую процедуру выбрать

- **Простое сообщение пользователю с готовым набором кнопок** (ошибка, предупреждение, вопрос да/нет) → `GtkMessageDialog`, а не собирать `GtkDialog` вручную ради типового случая — иконка и кнопки уже готовы.
- **Диалог с собственной формой, полями, нестандартным содержимым** → `GtkDialog` + `gtk_dialog_get_content_area`, а не пытаться встроить сложную вёрстку в `GtkMessageDialog`.
- **Выбор существующего файла** → `GTK_FILE_CHOOSER_ACTION_OPEN`. **Выбор места и имени для сохранения нового файла** → `GTK_FILE_CHOOSER_ACTION_SAVE` вместе с `gtk_file_chooser_set_current_name`. **Выбор папки, а не файла** → `GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER`.
- **Кастомизация внешнего вида заголовка окна** → `GtkHeaderBar` + `gtk_window_set_titlebar` (базовый справочник), а не пытаться разместить эти элементы прямо внутри содержимого окна под заголовком.
- **Опасное действие в диалоге** (удаление, необратимая операция) → кнопка с CSS-классом `"destructive-action"`, а рекомендуемое действие — `"suggested-action"`.
- **Реагировать на выбор пользователя в любом диалоге на основе `GtkDialog`** (включая `GtkMessageDialog`/`GtkFileChooserDialog`) → сигнал `"response"` с проверкой `responseId`.
- **Заголовок диалога без системных кнопок окна, но со своим заголовочным виджетом** → `gtk_header_bar_set_show_title_buttons(bar, 0.gboolean)` — диалоги обычно закрываются собственными кнопками действий, а не системным крестиком.
