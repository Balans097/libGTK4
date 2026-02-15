# Документация API библиотеки libGTK4.nim

## Общая информация

**Версия:** 1.2  
**Дата:** 2026-02-15  
**Автор:** Balans097 — vasil.minsk@yahoo.com  
**Назначение:** Полная обёртка GTK4 для языка программирования Nim

### Описание

Библиотека предоставляет прямые привязки к C API GTK4 через FFI (Foreign Function Interface). Это позволяет разрабатывать графические приложения на Nim с использованием всей функциональности GTK4.

### История версий

- **1.2** (2026-02-15) — Дополнение библиотеки расширенными функциями:
  - Inspector API (gtk_inspector_*)
  - Accessible API (gtk_accessible_*)
  - Action API (gtk_action_*)
  - Builder API (gtk_builder_*)
  - Constraint API (gtk_constraint_*)
  - Вспомогательные функции Graph, Bitset, Roaring
  - GSK (GskRenderNode, GskTransform и др.)
  - GDK (события, дисплей, устройства)
  - Добавлено ~1780 дополнительных функций GTK4 API

- **1.1** (2026-02-05) — Исправления критических проблем:
  - Исправлен `createListStore`: использует `gtk_list_store_newv` вместо небезопасного varargs
  - Исправлены `g_timeout_add`/`g_idle_add`: используют правильный тип GSourceFunc с user_data
  - Исправлен `getClipboardText`: использует GAsyncReadyCallback
  - Исправлены типы для различных функций
  - Добавлены guards GTK_DISABLE_DEPRECATED для устаревших GTK3 API

- **1.0** (2026-01-20) — Начальная реализация библиотеки

---

## Содержание

1. [Базовые типы](#базовые-типы)
2. [Приложения](#приложения)
3. [Окна](#окна)
4. [Контейнеры](#контейнеры)
5. [Кнопки и переключатели](#кнопки-и-переключатели)
6. [Текстовые виджеты](#текстовые-виджеты)
7. [Списки и выбор](#списки-и-выбор)
8. [Отображение](#отображение)
9. [Диалоги](#диалоги)
10. [Меню и панели](#меню-и-панели)
11. [Рисование](#рисование)
12. [События и сигналы](#события-и-сигналы)
13. [CSS и стили](#css-и-стили)
14. [Ресурсы и данные](#ресурсы-и-данные)
15. [Inspector API](#inspector-api)
16. [Bitset API](#bitset-api)
17. [Roaring Bitmap API](#roaring-bitmap-api)
18. [Утилиты](#утилиты)

---

## Базовые типы

### GLib типы

```nim
type
  gboolean* = int32      # Логический тип (0 = FALSE, 1 = TRUE)
  gint* = int32          # Знаковое целое 32-бит
  guint* = uint32        # Беззнаковое целое 32-бит
  gchar* = char          # Символ
  guchar* = uint8        # Беззнаковый символ
  gshort* = int16        # Короткое целое
  gushort* = uint16      # Беззнаковое короткое целое
  glong* = int           # Длинное целое
  gulong* = uint         # Беззнаковое длинное целое
  gint8* = int8          # 8-битное знаковое целое
  guint8* = uint8        # 8-битное беззнаковое целое
  gint16* = int16        # 16-битное знаковое целое
  guint16* = uint16      # 16-битное беззнаковое целое
  gint32* = int32        # 32-битное знаковое целое
  guint32* = uint32      # 32-битное беззнаковое целое
  gint64* = int64        # 64-битное знаковое целое
  guint64* = uint64      # 64-битное беззнаковое целое
  gfloat* = float32      # Число с плавающей точкой одинарной точности
  gdouble* = float64     # Число с плавающей точкой двойной точности
  gsize* = uint          # Размер
  gssize* = int          # Знаковый размер
  goffset* = int64       # Смещение
  gpointer* = pointer    # Универсальный указатель
  gconstpointer* = pointer  # Константный указатель
  gunichar* = uint32     # Unicode символ
```

### GTK основные типы виджетов

```nim
type
  GtkWidget* = pointer              # Базовый виджет
  GtkWindow* = pointer              # Окно
  GtkApplicationWindow* = pointer   # Окно приложения
  GtkDialog* = pointer              # Диалоговое окно
```

---

## Приложения

### GtkApplication

Основной тип для создания GTK приложений.

#### Создание приложения

```nim
proc gtk_application_new*(
  application_id: cstring,
  flags: GApplicationFlags
): GtkApplication
```

Создает новое GTK приложение.

**Параметры:**
- `application_id` — уникальный идентификатор приложения (например, "com.example.MyApp")
- `flags` — флаги приложения

**Возвращает:** новый экземпляр GtkApplication

**Пример:**
```nim
let app = gtk_application_new("com.example.myapp", G_APPLICATION_DEFAULT_FLAGS)
```

#### Запуск приложения

```nim
proc g_application_run*(
  application: GApplication,
  argc: gint,
  argv: cstringArray
): gint
```

Запускает главный цикл приложения.

**Параметры:**
- `application` — приложение для запуска
- `argc` — количество аргументов командной строки
- `argv` — массив аргументов командной строки

**Возвращает:** код выхода приложения

#### Подключение сигналов

```nim
proc g_signal_connect_data*(
  instance: gpointer,
  detailed_signal: cstring,
  c_handler: GCallback,
  data: gpointer,
  destroy_data: GClosureNotify,
  connect_flags: GConnectFlags
): gulong
```

Подключает обработчик сигнала к объекту.

**Параметры:**
- `instance` — объект для подключения
- `detailed_signal` — имя сигнала
- `c_handler` — функция-обработчик
- `data` — пользовательские данные
- `destroy_data` — функция освобождения данных
- `connect_flags` — флаги подключения

---

## Окна

### GtkWindow

#### Создание окна

```nim
proc gtk_application_window_new*(
  application: GtkApplication
): GtkWidget
```

Создает новое окно приложения.

**Параметры:**
- `application` — приложение-владелец окна

**Возвращает:** новое окно

#### Установка заголовка

```nim
proc gtk_window_set_title*(
  window: GtkWindow,
  title: cstring
)
```

Устанавливает заголовок окна.

**Параметры:**
- `window` — окно
- `title` — текст заголовка

#### Установка размера по умолчанию

```nim
proc gtk_window_set_default_size*(
  window: GtkWindow,
  width: gint,
  height: gint
)
```

Устанавливает размер окна по умолчанию.

**Параметры:**
- `window` — окно
- `width` — ширина в пикселях
- `height` — высота в пикселях

#### Показ окна

```nim
proc gtk_window_present*(
  window: GtkWindow
)
```

Показывает окно и переводит его на передний план.

#### Установка содержимого

```nim
proc gtk_window_set_child*(
  window: GtkWindow,
  child: GtkWidget
)
```

Устанавливает дочерний виджет в окно.

**Параметры:**
- `window` — окно
- `child` — виджет для размещения в окне

---

## Контейнеры

### GtkBox

Контейнер для размещения виджетов в одну линию (горизонтально или вертикально).

#### Создание

```nim
proc gtk_box_new*(
  orientation: GtkOrientation,
  spacing: gint
): GtkWidget
```

Создает новый контейнер Box.

**Параметры:**
- `orientation` — ориентация (GTK_ORIENTATION_HORIZONTAL или GTK_ORIENTATION_VERTICAL)
- `spacing` — расстояние между виджетами в пикселях

**Возвращает:** новый виджет Box

#### Добавление виджета

```nim
proc gtk_box_append*(
  box: GtkBox,
  child: GtkWidget
)
```

Добавляет виджет в конец контейнера.

**Параметры:**
- `box` — контейнер
- `child` — виджет для добавления

```nim
proc gtk_box_prepend*(
  box: GtkBox,
  child: GtkWidget
)
```

Добавляет виджет в начало контейнера.

### GtkGrid

Контейнер для размещения виджетов в виде таблицы.

#### Создание

```nim
proc gtk_grid_new*(): GtkWidget
```

Создает новый контейнер Grid.

#### Добавление виджета

```nim
proc gtk_grid_attach*(
  grid: GtkGrid,
  child: GtkWidget,
  column: gint,
  row: gint,
  width: gint,
  height: gint
)
```

Размещает виджет в таблице.

**Параметры:**
- `grid` — контейнер Grid
- `child` — виджет для размещения
- `column` — номер столбца (начиная с 0)
- `row` — номер строки (начиная с 0)
- `width` — количество столбцов для занятия
- `height` — количество строк для занятия

### GtkPaned

Контейнер с разделителем для двух виджетов.

```nim
proc gtk_paned_new*(
  orientation: GtkOrientation
): GtkWidget
```

Создает новый контейнер Paned.

```nim
proc gtk_paned_set_start_child*(
  paned: GtkPaned,
  child: GtkWidget
)
```

Устанавливает первый дочерний виджет.

```nim
proc gtk_paned_set_end_child*(
  paned: GtkPaned,
  child: GtkWidget
)
```

Устанавливает второй дочерний виджет.

### GtkNotebook

Контейнер с вкладками.

```nim
proc gtk_notebook_new*(): GtkWidget
```

Создает новый контейнер Notebook.

```nim
proc gtk_notebook_append_page*(
  notebook: GtkNotebook,
  child: GtkWidget,
  tab_label: GtkWidget
): gint
```

Добавляет страницу в конец.

**Параметры:**
- `notebook` — контейнер
- `child` — содержимое страницы
- `tab_label` — виджет метки вкладки

**Возвращает:** индекс новой страницы

---

## Кнопки и переключатели

### GtkButton

Стандартная кнопка.

#### Создание

```nim
proc gtk_button_new*(): GtkWidget
```

Создает пустую кнопку.

```nim
proc gtk_button_new_with_label*(
  label: cstring
): GtkWidget
```

Создает кнопку с текстовой меткой.

**Параметры:**
- `label` — текст кнопки

```nim
proc gtk_button_new_from_icon_name*(
  icon_name: cstring
): GtkWidget
```

Создает кнопку с иконкой.

**Параметры:**
- `icon_name` — имя иконки из темы

#### Установка метки

```nim
proc gtk_button_set_label*(
  button: GtkButton,
  label: cstring
)
```

Устанавливает текст кнопки.

#### Установка дочернего виджета

```nim
proc gtk_button_set_child*(
  button: GtkButton,
  child: GtkWidget
)
```

Устанавливает произвольный виджет внутри кнопки.

### GtkToggleButton

Кнопка-переключатель.

```nim
proc gtk_toggle_button_new*(): GtkWidget
```

Создает новую кнопку-переключатель.

```nim
proc gtk_toggle_button_set_active*(
  toggle_button: GtkToggleButton,
  is_active: gboolean
)
```

Устанавливает состояние кнопки.

```nim
proc gtk_toggle_button_get_active*(
  toggle_button: GtkToggleButton
): gboolean
```

Получает текущее состояние кнопки.

### GtkCheckButton

Флажок (чекбокс).

```nim
proc gtk_check_button_new*(): GtkWidget
```

Создает новый флажок.

```nim
proc gtk_check_button_new_with_label*(
  label: cstring
): GtkWidget
```

Создает флажок с меткой.

### GtkSwitch

Переключатель в стиле on/off.

```nim
proc gtk_switch_new*(): GtkWidget
```

Создает новый переключатель.

```nim
proc gtk_switch_set_active*(
  sw: GtkSwitch,
  is_active: gboolean
)
```

Устанавливает состояние переключателя.

```nim
proc gtk_switch_get_active*(
  sw: GtkSwitch
): gboolean
```

Получает текущее состояние переключателя.

---

## Текстовые виджеты

### GtkLabel

Виджет для отображения текста.

#### Создание

```nim
proc gtk_label_new*(
  str: cstring
): GtkWidget
```

Создает метку с текстом.

**Параметры:**
- `str` — текст метки (может быть NULL для пустой метки)

#### Установка текста

```nim
proc gtk_label_set_text*(
  label: GtkLabel,
  str: cstring
)
```

Устанавливает текст метки.

```nim
proc gtk_label_set_markup*(
  label: GtkLabel,
  str: cstring
)
```

Устанавливает текст с разметкой Pango.

#### Получение текста

```nim
proc gtk_label_get_text*(
  label: GtkLabel
): cstring
```

Получает текущий текст метки.

#### Выравнивание

```nim
proc gtk_label_set_xalign*(
  label: GtkLabel,
  xalign: gfloat
)
```

Устанавливает горизонтальное выравнивание (0.0 = слева, 1.0 = справа).

```nim
proc gtk_label_set_yalign*(
  label: GtkLabel,
  yalign: gfloat
)
```

Устанавливает вертикальное выравнивание (0.0 = сверху, 1.0 = снизу).

### GtkEntry

Однострочное текстовое поле ввода.

#### Создание

```nim
proc gtk_entry_new*(): GtkWidget
```

Создает новое поле ввода.

#### Работа с текстом

```nim
proc gtk_entry_set_text*(
  entry: GtkEntry,
  text: cstring
)
```

Устанавливает текст в поле.

```nim
proc gtk_entry_get_text*(
  entry: GtkEntry
): cstring
```

Получает текст из поля.

#### Placeholder

```nim
proc gtk_entry_set_placeholder_text*(
  entry: GtkEntry,
  text: cstring
)
```

Устанавливает текст-подсказку, отображаемый когда поле пусто.

### GtkTextView

Многострочный текстовый редактор.

#### Создание

```nim
proc gtk_text_view_new*(): GtkWidget
```

Создает новый текстовый редактор.

```nim
proc gtk_text_view_new_with_buffer*(
  buffer: GtkTextBuffer
): GtkWidget
```

Создает текстовый редактор с указанным буфером.

#### Получение буфера

```nim
proc gtk_text_view_get_buffer*(
  text_view: GtkTextView
): GtkTextBuffer
```

Получает буфер текста.

### GtkTextBuffer

Буфер для хранения текста.

#### Работа с текстом

```nim
proc gtk_text_buffer_set_text*(
  buffer: GtkTextBuffer,
  text: cstring,
  len: gint
)
```

Устанавливает весь текст в буфере.

**Параметры:**
- `buffer` — буфер
- `text` — новый текст
- `len` — длина текста в байтах (-1 для автоопределения)

```nim
proc gtk_text_buffer_get_text*(
  buffer: GtkTextBuffer,
  start: ptr GtkTextIter,
  end_iter: ptr GtkTextIter,
  include_hidden_chars: gboolean
): cstring
```

Получает текст из указанного диапазона.

#### Итераторы

```nim
proc gtk_text_buffer_get_start_iter*(
  buffer: GtkTextBuffer,
  iter: ptr GtkTextIter
)
```

Получает итератор на начало буфера.

```nim
proc gtk_text_buffer_get_end_iter*(
  buffer: GtkTextBuffer,
  iter: ptr GtkTextIter
)
```

Получает итератор на конец буфера.

---

## Списки и выбор

### GtkComboBoxText

Выпадающий список с текстовыми элементами.

```nim
proc gtk_combo_box_text_new*(): GtkWidget
```

Создает новый комбобокс.

```nim
proc gtk_combo_box_text_append_text*(
  combo_box: GtkComboBoxText,
  text: cstring
)
```

Добавляет текстовый элемент в конец списка.

```nim
proc gtk_combo_box_text_get_active_text*(
  combo_box: GtkComboBoxText
): cstring
```

Получает текст выбранного элемента.

### GtkListBox

Вертикальный список виджетов.

```nim
proc gtk_list_box_new*(): GtkWidget
```

Создает новый список.

```nim
proc gtk_list_box_append*(
  box: GtkListBox,
  child: GtkWidget
)
```

Добавляет виджет в список.

```nim
proc gtk_list_box_select_row*(
  box: GtkListBox,
  row: GtkListBoxRow
)
```

Выбирает указанную строку.

### GtkDropDown

Современный выпадающий список (GTK4).

```nim
proc gtk_drop_down_new*(
  model: GListModel,
  expression: GtkExpression
): GtkWidget
```

Создает новый выпадающий список.

```nim
proc gtk_drop_down_set_selected*(
  self: GtkDropDown,
  position: guint
)
```

Устанавливает выбранный элемент по индексу.

```nim
proc gtk_drop_down_get_selected*(
  self: GtkDropDown
): guint
```

Получает индекс выбранного элемента.

---

## Отображение

### GtkImage

Виджет для отображения изображений.

```nim
proc gtk_image_new*(): GtkWidget
```

Создает пустое изображение.

```nim
proc gtk_image_new_from_file*(
  filename: cstring
): GtkWidget
```

Создает изображение из файла.

```nim
proc gtk_image_new_from_icon_name*(
  icon_name: cstring
): GtkWidget
```

Создает изображение из иконки темы.

```nim
proc gtk_image_set_from_file*(
  image: GtkImage,
  filename: cstring
)
```

Загружает изображение из файла.

### GtkSpinner

Анимированный индикатор загрузки.

```nim
proc gtk_spinner_new*(): GtkWidget
```

Создает новый спиннер.

```nim
proc gtk_spinner_start*(
  spinner: GtkSpinner
)
```

Запускает анимацию.

```nim
proc gtk_spinner_stop*(
  spinner: GtkSpinner
)
```

Останавливает анимацию.

### GtkProgressBar

Индикатор прогресса.

```nim
proc gtk_progress_bar_new*(): GtkWidget
```

Создает новый индикатор прогресса.

```nim
proc gtk_progress_bar_set_fraction*(
  pbar: GtkProgressBar,
  fraction: gdouble
)
```

Устанавливает прогресс (от 0.0 до 1.0).

```nim
proc gtk_progress_bar_set_text*(
  pbar: GtkProgressBar,
  text: cstring
)
```

Устанавливает текст на индикаторе.

```nim
proc gtk_progress_bar_pulse*(
  pbar: GtkProgressBar
)
```

Переводит индикатор в режим "пульсации" (неопределенный прогресс).

---

## Диалоги

### GtkMessageDialog

Диалоговое окно с сообщением.

```nim
proc gtk_message_dialog_new*(
  parent: GtkWindow,
  flags: GtkDialogFlags,
  type_: GtkMessageType,
  buttons: GtkButtonsType,
  message_format: cstring
): GtkWidget
```

Создает диалог сообщения.

**Параметры:**
- `parent` — родительское окно
- `flags` — флаги диалога
- `type_` — тип сообщения (GTK_MESSAGE_INFO, GTK_MESSAGE_WARNING и т.д.)
- `buttons` — набор кнопок
- `message_format` — текст сообщения

### GtkFileChooserDialog

Диалог выбора файла.

```nim
proc gtk_file_chooser_dialog_new*(
  title: cstring,
  parent: GtkWindow,
  action: GtkFileChooserAction,
  first_button_text: cstring
): GtkWidget
```

Создает диалог выбора файла.

**Параметры:**
- `title` — заголовок диалога
- `parent` — родительское окно
- `action` — действие (открыть, сохранить и т.д.)
- `first_button_text` — текст первой кнопки

```nim
proc gtk_file_chooser_get_file*(
  chooser: GtkFileChooser
): GFile
```

Получает выбранный файл.

### GtkDialog

Базовый диалог.

```nim
proc gtk_dialog_new*(): GtkWidget
```

Создает пустой диалог.

```nim
proc gtk_dialog_add_button*(
  dialog: GtkDialog,
  button_text: cstring,
  response_id: gint
): GtkWidget
```

Добавляет кнопку в диалог.

```nim
proc gtk_dialog_run*(
  dialog: GtkDialog
): gint
```

Запускает диалог модально (устарело в GTK4, используйте асинхронные методы).

---

## Меню и панели

### GtkMenuButton

Кнопка с выпадающим меню.

```nim
proc gtk_menu_button_new*(): GtkWidget
```

Создает новую кнопку меню.

```nim
proc gtk_menu_button_set_popover*(
  menu_button: GtkMenuButton,
  popover: GtkWidget
)
```

Устанавливает popover для меню.

### GtkPopover

Всплывающее меню.

```nim
proc gtk_popover_new*(): GtkWidget
```

Создает новый popover.

```nim
proc gtk_popover_set_child*(
  popover: GtkPopover,
  child: GtkWidget
)
```

Устанавливает содержимое popover.

### GtkHeaderBar

Заголовочная панель окна.

```nim
proc gtk_header_bar_new*(): GtkWidget
```

Создает новую заголовочную панель.

```nim
proc gtk_header_bar_pack_start*(
  bar: GtkHeaderBar,
  child: GtkWidget
)
```

Добавляет виджет в левую часть панели.

```nim
proc gtk_header_bar_pack_end*(
  bar: GtkHeaderBar,
  child: GtkWidget
)
```

Добавляет виджет в правую часть панели.

```nim
proc gtk_header_bar_set_title_widget*(
  bar: GtkHeaderBar,
  title_widget: GtkWidget
)
```

Устанавливает виджет заголовка.

---

## Рисование

### GtkDrawingArea

Область для пользовательского рисования.

```nim
proc gtk_drawing_area_new*(): GtkWidget
```

Создает новую область рисования.

```nim
proc gtk_drawing_area_set_draw_func*(
  area: GtkDrawingArea,
  draw_func: GtkDrawingAreaDrawFunc,
  user_data: gpointer,
  destroy: GDestroyNotify
)
```

Устанавливает функцию рисования.

**Параметры:**
- `area` — область рисования
- `draw_func` — функция обратного вызова для рисования
- `user_data` — пользовательские данные
- `destroy` — функция освобождения данных

**Сигнатура draw_func:**
```nim
type GtkDrawingAreaDrawFunc* = proc(
  drawing_area: GtkDrawingArea,
  cr: ptr cairo_t,
  width: gint,
  height: gint,
  user_data: gpointer
) {.cdecl.}
```

---

## События и сигналы

### Подключение обработчиков

```nim
proc g_signal_connect_data*(
  instance: gpointer,
  detailed_signal: cstring,
  c_handler: GCallback,
  data: gpointer,
  destroy_data: GClosureNotify,
  connect_flags: GConnectFlags
): gulong
```

Основная функция для подключения обработчиков сигналов.

**Основные сигналы:**

#### Сигналы кнопок
- `"clicked"` — кнопка нажата
- `"toggled"` — состояние переключателя изменилось

#### Сигналы окна
- `"destroy"` — окно уничтожается
- `"close-request"` — запрос на закрытие окна

#### Сигналы текстовых полей
- `"changed"` — текст изменился
- `"activate"` — нажат Enter

### GtkEventController

Контроллеры событий для обработки ввода.

```nim
proc gtk_event_controller_key_new*(): GtkEventController
```

Создает контроллер клавиатурных событий.

```nim
proc gtk_event_controller_motion_new*(): GtkEventController
```

Создает контроллер событий движения мыши.

```nim
proc gtk_gesture_click_new*(): GtkGesture
```

Создает жест для обработки кликов.

```nim
proc gtk_widget_add_controller*(
  widget: GtkWidget,
  controller: GtkEventController
)
```

Добавляет контроллер событий к виджету.

---

## CSS и стили

### Применение CSS

```nim
proc gtk_css_provider_new*(): GtkCssProvider
```

Создает новый CSS провайдер.

```nim
proc gtk_css_provider_load_from_data*(
  css_provider: GtkCssProvider,
  data: cstring,
  length: gssize
)
```

Загружает CSS из строки.

**Параметры:**
- `css_provider` — провайдер
- `data` — CSS код
- `length` — длина данных (-1 для автоопределения)

```nim
proc gtk_style_context_add_provider_for_display*(
  display: GdkDisplay,
  provider: GtkStyleProvider,
  priority: guint
)
```

Применяет CSS провайдер ко всему дисплею.

### Классы CSS

```nim
proc gtk_widget_add_css_class*(
  widget: GtkWidget,
  css_class: cstring
)
```

Добавляет CSS класс к виджету.

```nim
proc gtk_widget_remove_css_class*(
  widget: GtkWidget,
  css_class: cstring
)
```

Удаляет CSS класс у виджета.

```nim
proc gtk_widget_has_css_class*(
  widget: GtkWidget,
  css_class: cstring
): gboolean
```

Проверяет наличие CSS класса.

---

## Ресурсы и данные

### GResource

Система ресурсов GTK для встраивания данных в приложение.

```nim
proc g_resource_load*(
  filename: cstring,
  error: ptr GError
): GResource
```

Загружает ресурсы из файла.

```nim
proc g_resources_register*(
  resource: GResource
)
```

Регистрирует ресурсы в глобальной базе.

### GBytes

Неизменяемый массив байтов.

```nim
proc g_bytes_new*(
  data: gconstpointer,
  size: gsize
): GBytes
```

Создает новый объект GBytes.

```nim
proc g_bytes_get_data*(
  bytes: GBytes,
  size: ptr gsize
): gconstpointer
```

Получает указатель на данные.

---

## Inspector API

GTK Inspector — встроенный инструмент для отладки и инспектирования интерфейса.

### Основные функции

```nim
proc gtk_inspector_window_get_type*(): pointer
```

Получает тип окна Inspector.

```nim
proc gtk_inspector_window_select_widget_under_pointer*(
  iw: pointer
)
```

Выбирает виджет под указателем мыши.

```nim
proc gtk_inspector_window_get_inspected_display*(
  iw: pointer
): pointer
```

Получает инспектируемый дисплей.

```nim
proc gtk_inspector_is_recording*(
  widget: GtkWidget
): gboolean
```

Проверяет, ведется ли запись для виджета.

```nim
proc gtk_inspector_handle_event*(
  event: pointer
): gboolean
```

Обрабатывает событие в Inspector.

### Записи и профилирование

```nim
proc gtk_inspector_recorder_is_recording*(
  recorder: pointer
): gboolean
```

Проверяет, идет ли запись.

```nim
proc gtk_inspector_recording_get_timestamp*(
  recording: pointer
): gint64
```

Получает временную метку записи.

```nim
proc gtk_inspector_render_recording_get_node*(
  recording: pointer
): pointer
```

Получает узел рендеринга из записи.

---

## Bitset API

Эффективные операции с множествами битов.

### Основные операции

```nim
proc bitset_free*(bitset: pointer): pointer
```

Освобождает bitset.

```nim
proc bitset_clear*(bitset: pointer): pointer
```

Очищает все биты.

```nim
proc bitset_fill*(bitset: pointer): pointer
```

Устанавливает все биты в 1.

```nim
proc bitset_resize*(
  bitset: pointer,
  newarraysize: pointer,
  padwithzeroes: pointer
): pointer
```

Изменяет размер bitset.

```nim
proc bitset_count*(bitset: pointer): pointer
```

Подсчитывает количество установленных битов.

```nim
proc bitset_empty*(bitset: pointer): pointer
```

Проверяет, пуст ли bitset.

```nim
proc bitset_minimum*(bitset: pointer): pointer
```

Находит минимальный установленный бит.

```nim
proc bitset_maximum*(bitset: pointer): pointer
```

Находит максимальный установленный бит.

---

## Roaring Bitmap API

Сжатые битовые карты для эффективного хранения больших множеств целых чисел.

### 32-битные битмапы

#### Создание и управление

```nim
proc roaring_bitmap_create_with_capacity*(): pointer
```

Создает битмап с заданной емкостью.

```nim
proc roaring_bitmap_free*(r: pointer): pointer
```

Освобождает битмап.

```nim
proc roaring_bitmap_clear*(r: pointer): pointer
```

Очищает все элементы.

#### Добавление и удаление

```nim
proc roaring_bitmap_add*(
  r: pointer,
  x: pointer
): pointer
```

Добавляет элемент в битмап.

```nim
proc roaring_bitmap_add_checked*(
  r: pointer,
  x: pointer
): pointer
```

Добавляет элемент с проверкой.

```nim
proc roaring_bitmap_remove*(
  r: pointer,
  x: pointer
): pointer
```

Удаляет элемент из битмапа.

```nim
proc roaring_bitmap_contains*(
  r: pointer,
  val: pointer
): pointer
```

Проверяет наличие элемента.

#### Информация и статистика

```nim
proc roaring_bitmap_get_cardinality*(
  r: pointer
): pointer
```

Возвращает количество элементов.

```nim
proc roaring_bitmap_is_empty*(
  r: pointer
): pointer
```

Проверяет, пуст ли битмап.

```nim
proc roaring_bitmap_minimum*(
  r: pointer
): pointer
```

Возвращает минимальный элемент.

```nim
proc roaring_bitmap_maximum*(
  r: pointer
): pointer
```

Возвращает максимальный элемент.

#### Оптимизация

```nim
proc roaring_bitmap_run_optimize*(
  r: pointer
): pointer
```

Оптимизирует битмап для последовательностей.

```nim
proc roaring_bitmap_shrink_to_fit*(
  r: pointer
): pointer
```

Уменьшает используемую память.

#### Сериализация

```nim
proc roaring_bitmap_serialize*(
  r: pointer,
  buf: cstring
): pointer
```

Сериализует битмап.

```nim
proc roaring_bitmap_size_in_bytes*(
  r: pointer
): pointer
```

Возвращает размер сериализованных данных.

```nim
proc roaring_bitmap_portable_serialize*(
  r: pointer,
  buf: cstring
): pointer
```

Портируемая сериализация.

### 64-битные битмапы

```nim
proc roaring64_bitmap_free*(r: pointer): pointer
```

Освобождает 64-битный битмап.

```nim
proc roaring64_bitmap_add*(
  r: pointer,
  val: pointer
): pointer
```

Добавляет 64-битное значение.

```nim
proc roaring64_bitmap_contains*(
  r: pointer,
  val: pointer
): pointer
```

Проверяет наличие 64-битного значения.

```nim
proc roaring64_bitmap_get_cardinality*(
  r: pointer
): pointer
```

Возвращает количество элементов.

---

## Утилиты

### Управление памятью

```nim
proc safeUnref*[T](obj: var T)
```

Безопасно уменьшает счетчик ссылок объекта.

**Параметры:**
- `obj` — объект GObject для освобождения (будет установлен в nil)

**Пример:**
```nim
var window = gtk_application_window_new(app)
# ... использование окна ...
window.safeUnref()  # Теперь window == nil
```

```nim
proc safeRef*[T](obj: T): T
```

Увеличивает счетчик ссылок объекта.

**Параметры:**
- `obj` — объект для увеличения счетчика

**Возвращает:** тот же объект с увеличенным счетчиком

### Настройки

```nim
proc getDefaultSettings*(): GtkSettings
```

Получает объект настроек по умолчанию.

**Возвращает:** глобальные настройки GTK

```nim
proc isDarkTheme*(): bool
```

Проверяет, используется ли темная тема.

**Возвращает:** true, если установлена темная тема

---

## Константы

### Ориентация

```nim
const
  GTK_ORIENTATION_HORIZONTAL* = 0
  GTK_ORIENTATION_VERTICAL* = 1
```

### Типы выравнивания

```nim
const
  GTK_ALIGN_FILL* = 0
  GTK_ALIGN_START* = 1
  GTK_ALIGN_END* = 2
  GTK_ALIGN_CENTER* = 3
  GTK_ALIGN_BASELINE* = 4
```

### Флаги приложения

```nim
const
  G_APPLICATION_DEFAULT_FLAGS* = 0
  G_APPLICATION_IS_SERVICE* = (1 shl 0)
  G_APPLICATION_HANDLES_OPEN* = (1 shl 1)
  G_APPLICATION_HANDLES_COMMAND_LINE* = (1 shl 2)
```

---

## Примеры использования

### Минимальное приложение

```nim
import libGTK4

proc activate(app: GtkApplication, user_data: gpointer) {.cdecl.} =
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Hello GTK4")
  gtk_window_set_default_size(window, 400, 300)
  
  let button = gtk_button_new_with_label("Нажми меня")
  gtk_window_set_child(window, button)
  
  gtk_window_present(window)

proc main() =
  let app = gtk_application_new("com.example.hello", G_APPLICATION_DEFAULT_FLAGS)
  discard g_signal_connect_data(app, "activate", cast[GCallback](activate), nil, nil, 0)
  discard g_application_run(app, 0, nil)
  g_object_unref(app)

main()
```

### Приложение с контейнером

```nim
import libGTK4

proc activate(app: GtkApplication, user_data: gpointer) {.cdecl.} =
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Контейнеры GTK4")
  gtk_window_set_default_size(window, 400, 300)
  
  # Создаем вертикальный Box
  let box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 10)
  gtk_window_set_child(window, box)
  
  # Добавляем виджеты
  let label = gtk_label_new("Привет, GTK4!")
  gtk_box_append(box, label)
  
  let entry = gtk_entry_new()
  gtk_entry_set_placeholder_text(entry, "Введите текст...")
  gtk_box_append(box, entry)
  
  let button = gtk_button_new_with_label("ОК")
  gtk_box_append(box, button)
  
  gtk_window_present(window)

proc main() =
  let app = gtk_application_new("com.example.containers", G_APPLICATION_DEFAULT_FLAGS)
  discard g_signal_connect_data(app, "activate", cast[GCallback](activate), nil, nil, 0)
  discard g_application_run(app, 0, nil)
  g_object_unref(app)

main()
```

### Обработка событий

```nim
import libGTK4

proc onButtonClicked(button: GtkButton, user_data: gpointer) {.cdecl.} =
  echo "Кнопка нажата!"

proc activate(app: GtkApplication, user_data: gpointer) {.cdecl.} =
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "События")
  
  let button = gtk_button_new_with_label("Нажми меня")
  discard g_signal_connect_data(button, "clicked", 
                                cast[GCallback](onButtonClicked), 
                                nil, nil, 0)
  
  gtk_window_set_child(window, button)
  gtk_window_present(window)

proc main() =
  let app = gtk_application_new("com.example.events", G_APPLICATION_DEFAULT_FLAGS)
  discard g_signal_connect_data(app, "activate", cast[GCallback](activate), nil, nil, 0)
  discard g_application_run(app, 0, nil)
  g_object_unref(app)

main()
```

---

## Дополнительные ресурсы

- [Официальная документация GTK](https://docs.gtk.org/gtk4/)
- [GTK4 Tutorial](https://www.gtk.org/docs/getting-started/)
- [Nim язык программирования](https://nim-lang.org/)

---

## Лицензия

Библиотека распространяется в соответствии с лицензией GTK4.

## Контакты

**Автор:** Balans097  
**Email:** vasil.minsk@yahoo.com

---

*Документация сгенерирована для версии 1.2 (2026-02-15)*

 = gtk_button_new_with_label("Открыть")
  let btnSave = gtk_button_new_with_label("Сохранить")
  gtk_header_bar_pack_start(headerBar, btnOpen)
  gtk_header_bar_pack_end(headerBar, btnSave)
  gtk_window_set_titlebar(window, headerBar)
  
  # Создаем текстовый редактор с прокруткой
  let scrolled = gtk_scrolled_window_new()
  let textView = gtk_text_view_new()
  gtk_text_view_set_wrap_mode(textView, GTK_WRAP_WORD)
  gtk_scrolled_window_set_child(scrolled, textView)
  gtk_window_set_child(window, scrolled)
  
  # Обработчик кнопки открытия
  proc onOpen(btn: GtkButton, data: gpointer) {.cdecl.} =
    let dialog = gtk_file_chooser_dialog_new(
      "Открыть файл",
      window,
      GTK_FILE_CHOOSER_ACTION_OPEN,
      nil
    )
    discard gtk_dialog_add_button(dialog, "Отмена", GTK_RESPONSE_CANCEL)
    discard gtk_dialog_add_button(dialog, "Открыть", GTK_RESPONSE_ACCEPT)
    
    proc onResponse(dlg: GtkDialog, response: gint, tv: gpointer) {.cdecl.} =
      if response == GTK_RESPONSE_ACCEPT:
        let file = gtk_file_chooser_get_file(dlg)
        if file != nil:
          # Чтение содержимого файла (упрощено)
          let path = g_file_get_path(file)
          echo "Открытие: ", path
          g_free(path)
          g_object_unref(file)
      gtk_window_destroy(dlg)
    
    discard g_signal_connect_data(dialog, "response", 
                                  cast[GCallback](onResponse), 
                                  textView, nil, 0)
    gtk_window_present(dialog)
  
  # Обработчик кнопки сохранения
  proc onSave(btn: GtkButton, tv: gpointer) {.cdecl.} =
    let textView = cast[GtkTextView](tv)
    let buffer = gtk_text_view_get_buffer(textView)
    var start, endIter: GtkTextIter
    gtk_text_buffer_get_start_iter(buffer, addr start)
    gtk_text_buffer_get_end_iter(buffer, addr endIter)
    let text = gtk_text_buffer_get_text(buffer, addr start, addr endIter, 0)
    echo "Сохранение текста: ", text
  
  discard g_signal_connect_data(btnOpen, "clicked", 
                                cast[GCallback](onOpen), 
                                nil, nil, 0)
  discard g_signal_connect_data(btnSave, "clicked", 
                                cast[GCallback](onSave), 
                                textView, nil, 0)
  
  gtk_window_present(window)

proc main() =
  let app = gtk_application_new("com.example.editor", G_APPLICATION_DEFAULT_FLAGS)
  discard g_signal_connect_data(app, "activate", 
                                cast[GCallback](activate), 
                                nil, nil, 0)
  discard g_application_run(app, 0, nil)
  g_object_unref(app)

main()
```

### Пример 3: Калькулятор

```nim
import libGTK4
import strutils

var display: GtkEntry
var currentValue: float = 0.0
var pendingOp: string = ""
var pendingValue: float = 0.0

proc updateDisplay(value: float) =
  gtk_entry_set_text(display, $value)

proc onNumberClick(btn: GtkButton, data: gpointer) {.cdecl.} =
  let label = gtk_button_get_label(btn)
  let current = $gtk_entry_get_text(display)
  if current == "0" or pendingOp != "":
    gtk_entry_set_text(display, label)
    pendingOp = ""
  else:
    gtk_entry_set_text(display, current & $label)

proc onOpClick(btn: GtkButton, data: gpointer) {.cdecl.} =
  let op = $gtk_button_get_label(btn)
  currentValue = parseFloat($gtk_entry_get_text(display))
  pendingOp = op
  pendingValue = currentValue

proc onEquals(btn: GtkButton, data: gpointer) {.cdecl.} =
  let value = parseFloat($gtk_entry_get_text(display))
  var result: float
  case pendingOp:
  of "+": result = pendingValue + value
  of "-": result = pendingValue - value
  of "*": result = pendingValue * value
  of "/": result = if value != 0: pendingValue / value else: 0.0
  else: result = value
  
  updateDisplay(result)
  pendingOp = ""

proc onClear(btn: GtkButton, data: gpointer) {.cdecl.} =
  currentValue = 0.0
  pendingValue = 0.0
  pendingOp = ""
  updateDisplay(0.0)

proc activate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Калькулятор")
  gtk_window_set_default_size(window, 300, 400)
  
  let mainBox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 5)
  gtk_window_set_child(window, mainBox)
  
  # Дисплей
  display = gtk_entry_new()
  gtk_entry_set_text(display, "0")
  gtk_entry_set_alignment(display, 1.0)  # Выравнивание справа
  gtk_widget_set_hexpand(display, 1)
  gtk_box_append(mainBox, display)
  
  # Сетка кнопок
  let grid = gtk_grid_new()
  gtk_grid_set_row_spacing(grid, 5)
  gtk_grid_set_column_spacing(grid, 5)
  gtk_box_append(mainBox, grid)
  
  # Цифровые кнопки
  let numbers = ["7", "8", "9", "4", "5", "6", "1", "2", "3", "0"]
  var row = 0
  var col = 0
  for num in numbers:
    let btn = gtk_button_new_with_label(num)
    gtk_grid_attach(grid, btn, col, row, 1, 1)
    discard g_signal_connect_data(btn, "clicked", 
                                  cast[GCallback](onNumberClick), 
                                  nil, nil, 0)
    col += 1
    if col > 2:
      col = 0
      row += 1
  
  # Кнопки операций
  let ops = ["+", "-", "*", "/"]
  for i, op in ops:
    let btn = gtk_button_new_with_label(op)
    gtk_grid_attach(grid, btn, 3, i, 1, 1)
    discard g_signal_connect_data(btn, "clicked", 
                                  cast[GCallback](onOpClick), 
                                  nil, nil, 0)
  
  # Равно и Очистить
  let btnEquals = gtk_button_new_with_label("=")
  gtk_grid_attach(grid, btnEquals, 1, 3, 1, 1)
  discard g_signal_connect_data(btnEquals, "clicked", 
                                cast[GCallback](onEquals), 
                                nil, nil, 0)
  
  let btnClear = gtk_button_new_with_label("C")
  gtk_grid_attach(grid, btnClear, 2, 3, 1, 1)
  discard g_signal_connect_data(btnClear, "clicked", 
                                cast[GCallback](onClear), 
                                nil, nil, 0)
  
  gtk_window_present(window)

proc main() =
  let app = gtk_application_new("com.example.calculator", G_APPLICATION_DEFAULT_FLAGS)
  discard g_signal_connect_data(app, "activate", 
                                cast[GCallback](activate), 
                                nil, nil, 0)
  discard g_application_run(app, 0, nil)
  g_object_unref(app)

main()
```

### Пример 4: Приложение для рисования

```nim
import libGTK4
import math

var points: seq[tuple[x, y: float]] = @[]

proc drawCallback(area: GtkDrawingArea, cr: ptr cairo_t, 
                  width: gint, height: gint, data: gpointer) {.cdecl.} =
  # Белый фон
  cairo_set_source_rgb(cr, 1.0, 1.0, 1.0)
  cairo_paint(cr)
  
  # Рисуем линии
  if points.len > 0:
    cairo_set_source_rgb(cr, 0.0, 0.0, 0.0)
    cairo_set_line_width(cr, 2.0)
    cairo_move_to(cr, points[0].x, points[0].y)
    for i in 1..<points.len:
      cairo_line_to(cr, points[i].x, points[i].y)
    cairo_stroke(cr)

proc onDrag(gesture: GtkGesture, x: gdouble, y: gdouble, area: gpointer) {.cdecl.} =
  points.add((x, y))
  gtk_widget_queue_draw(cast[GtkWidget](area))

proc onDragEnd(gesture: GtkGesture, x: gdouble, y: gdouble, data: gpointer) {.cdecl.} =
  points = @[]

proc activate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  let window = gtk_application_window_new(app)
  gtk_window_set_title(window, "Приложение для рисования")
  gtk_window_set_default_size(window, 800, 600)
  
  let drawingArea = gtk_drawing_area_new()
  gtk_drawing_area_set_draw_func(drawingArea, drawCallback, nil, nil)
  gtk_window_set_child(window, drawingArea)
  
  # Добавляем жест перетаскивания
  let dragGesture = gtk_gesture_drag_new()
  discard g_signal_connect_data(dragGesture, "drag-update", 
                                cast[GCallback](onDrag), 
                                drawingArea, nil, 0)
  discard g_signal_connect_data(dragGesture, "drag-end", 
                                cast[GCallback](onDragEnd), 
                                nil, nil, 0)
  gtk_widget_add_controller(drawingArea, dragGesture)
  
  gtk_window_present(window)

proc main() =
  let app = gtk_application_new("com.example.drawing", G_APPLICATION_DEFAULT_FLAGS)
  discard g_signal_connect_data(app, "activate", 
                                cast[GCallback](activate), 
                                nil, nil, 0)
  discard g_application_run(app, 0, nil)
  g_object_unref(app)

main()
```

---

## Справочник констант

### Ориентация
```nim
const
  GTK_ORIENTATION_HORIZONTAL* = 0
  GTK_ORIENTATION_VERTICAL* = 1
```

### Выравнивание
```nim
const
  GTK_ALIGN_FILL* = 0
  GTK_ALIGN_START* = 1
  GTK_ALIGN_END* = 2
  GTK_ALIGN_CENTER* = 3
  GTK_ALIGN_BASELINE* = 4
```

### Типы ответов
```nim
const
  GTK_RESPONSE_NONE* = -1
  GTK_RESPONSE_REJECT* = -2
  GTK_RESPONSE_ACCEPT* = -3
  GTK_RESPONSE_DELETE_EVENT* = -4
  GTK_RESPONSE_OK* = -5
  GTK_RESPONSE_CANCEL* = -6
  GTK_RESPONSE_CLOSE* = -7
  GTK_RESPONSE_YES* = -8
  GTK_RESPONSE_NO* = -9
  GTK_RESPONSE_APPLY* = -10
```

### Флаги приложения
```nim
const
  G_APPLICATION_DEFAULT_FLAGS* = 0
  G_APPLICATION_IS_SERVICE* = (1 shl 0)
  G_APPLICATION_HANDLES_OPEN* = (1 shl 1)
  G_APPLICATION_HANDLES_COMMAND_LINE* = (1 shl 2)
```

---

## Дополнительные ресурсы

- [Официальная документация GTK](https://docs.gtk.org/gtk4/)
- [Руководство по GTK4](https://www.gtk.org/docs/getting-started/)
- [Язык программирования Nim](https://nim-lang.org/)
- [Cairo Graphics](https://www.cairographics.org/)
- [Pango Text Layout](https://pango.gnome.org/)

---

## Лицензия

Эта библиотека следует условиям лицензии GTK4.

## Контакты

**Автор:** Balans097  
**Email:** vasil.minsk@yahoo.com

---

*Документация создана для версии 1.2 (2026-02-15)*
