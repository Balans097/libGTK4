# GTK4 (containers & indicators: ScrolledWindow / Frame / Separator / Image / Spinner / ProgressBar) — справочник модуля

> **Импорт:** `import libGTK4`
> **Область применения:** прокручиваемый контейнер, декоративная рамка, разделитель, изображение и два индикатора хода выполнения. Пятая часть серии справочников по обёртке; предполагает знакомство с предыдущими частями, особенно с `gtk4_core_reference_ru.md` (компоновка, `GtkWidget`).

Этот справочник компактнее предыдущих — все шесть виджетов небольшие по числу функций, но каждый по-своему обязателен в почти любом приложении: `GtkScrolledWindow` оборачивает контент, который может не поместиться на экране (список, текст, таблица); `GtkFrame` и `GtkSeparator` — простейшие средства визуальной группировки; `GtkImage` показывает статичную картинку или иконку; `GtkSpinner` и `GtkProgressBar` — два разных способа показать пользователю, что что-то происходит в фоне.

---

## Оглавление

I. [GtkScrolledWindow](#gtkscrolledwindow)
&nbsp;&nbsp;1. [`gtk_scrolled_window_new`](#gtk_scrolled_window_new)
&nbsp;&nbsp;2. [`gtk_scrolled_window_set_child` / `gtk_scrolled_window_get_child`](#gtk_scrolled_window_set_child--gtk_scrolled_window_get_child)
&nbsp;&nbsp;3. [`gtk_scrolled_window_set_policy` / `gtk_scrolled_window_get_policy`](#gtk_scrolled_window_set_policy--gtk_scrolled_window_get_policy)
&nbsp;&nbsp;4. [`gtk_scrolled_window_set_has_frame` / `gtk_scrolled_window_get_has_frame`](#gtk_scrolled_window_set_has_frame--gtk_scrolled_window_get_has_frame)

II. [GtkFrame](#gtkframe)
&nbsp;&nbsp;1. [`gtk_frame_new`](#gtk_frame_new)
&nbsp;&nbsp;2. [`gtk_frame_set_label` / `gtk_frame_get_label`](#gtk_frame_set_label--gtk_frame_get_label)
&nbsp;&nbsp;3. [`gtk_frame_set_child` / `gtk_frame_get_child`](#gtk_frame_set_child--gtk_frame_get_child)
&nbsp;&nbsp;4. [`gtk_frame_set_label_widget` / `gtk_frame_get_label_widget`](#gtk_frame_set_label_widget--gtk_frame_get_label_widget)
&nbsp;&nbsp;5. [`gtk_frame_set_label_align` / `gtk_frame_get_label_align`](#gtk_frame_set_label_align--gtk_frame_get_label_align)

III. [GtkSeparator](#gtkseparator)
&nbsp;&nbsp;1. [`gtk_separator_new`](#gtk_separator_new)

IV. [GtkImage](#gtkimage)
&nbsp;&nbsp;1. [`gtk_image_new` / `gtk_image_new_from_file` / `gtk_image_new_from_icon_name` / `gtk_image_new_from_paintable`](#gtk_image_new--gtk_image_new_from_file--gtk_image_new_from_icon_name--gtk_image_new_from_paintable)
&nbsp;&nbsp;2. [`gtk_image_set_from_file` / `gtk_image_set_from_icon_name` / `gtk_image_set_from_paintable`](#gtk_image_set_from_file--gtk_image_set_from_icon_name--gtk_image_set_from_paintable)
&nbsp;&nbsp;3. [`gtk_image_get_paintable`](#gtk_image_get_paintable)
&nbsp;&nbsp;4. [`gtk_image_set_pixel_size` / `gtk_image_get_pixel_size`](#gtk_image_set_pixel_size--gtk_image_get_pixel_size)

V. [GtkSpinner](#gtkspinner)
&nbsp;&nbsp;1. [`gtk_spinner_new`](#gtk_spinner_new)
&nbsp;&nbsp;2. [`gtk_spinner_start` / `gtk_spinner_stop`](#gtk_spinner_start--gtk_spinner_stop)

VI. [GtkProgressBar](#gtkprogressbar)
&nbsp;&nbsp;1. [`gtk_progress_bar_new`](#gtk_progress_bar_new)
&nbsp;&nbsp;2. [`gtk_progress_bar_set_fraction` / `gtk_progress_bar_get_fraction`](#gtk_progress_bar_set_fraction--gtk_progress_bar_get_fraction)
&nbsp;&nbsp;3. [`gtk_progress_bar_set_text` / `gtk_progress_bar_get_text` / `gtk_progress_bar_set_show_text` / `gtk_progress_bar_get_show_text`](#gtk_progress_bar_set_text--gtk_progress_bar_get_text--gtk_progress_bar_set_show_text--gtk_progress_bar_get_show_text)
&nbsp;&nbsp;4. [`gtk_progress_bar_pulse`](#gtk_progress_bar_pulse)

VII. [Практические рецепты](#практические-рецепты)
&nbsp;&nbsp;1. [Прокручиваемый список внутри окна фиксированного размера](#прокручиваемый-список-внутри-окна-фиксированного-размера)
&nbsp;&nbsp;2. [Группа настроек в подписанной рамке](#группа-настроек-в-подписанной-рамке)
&nbsp;&nbsp;3. [Панель инструментов с разделителями между группами кнопок](#панель-инструментов-с-разделителями-между-группами-кнопок)
&nbsp;&nbsp;4. [Индикатор загрузки: спиннер, пока идёт запрос, полоса прогресса — когда известна доля выполнения](#индикатор-загрузки-спиннер-пока-идёт-запрос-полоса-прогресса--когда-известна-доля-выполнения)
&nbsp;&nbsp;5. [Аватар пользователя с запасной иконкой](#аватар-пользователя-с-запасной-иконкой)

VIII. [Краткая таблица](#краткая-таблица)

IX. [Сводка: какую процедуру выбрать](#сводка-какую-процедуру-выбрать)

---

## GtkScrolledWindow

`GtkScrolledWindow` — контейнер с ровно одним дочерним виджетом, добавляющий полосы прокрутки, когда содержимое не помещается в отведённое место. Многие виджеты со своим встроенным списком (например, `GtkTextView` из предыдущего справочника, или `GtkListBox`/`GtkColumnView` из справочника по спискам) специально спроектированы так, чтобы их естественный минимальный размер был маленьким именно в расчёте на то, что их поместят внутрь `GtkScrolledWindow` — без этого длинный список или документ просто растянул бы окно на весь экран вместо появления полосы прокрутки.

### `gtk_scrolled_window_new`

```nim
proc gtk_scrolled_window_new*(): GtkScrolledWindow
```

**Что делает.** Создаёт пустой прокручиваемый контейнер. Дочерний виджет устанавливается отдельно через `gtk_scrolled_window_set_child`.

- Параметров нет.

```nim
let scrolled = gtk_scrolled_window_new()
echo "Прокручиваемый контейнер создан"
```

---

### `gtk_scrolled_window_set_child` / `gtk_scrolled_window_get_child`

```nim
proc gtk_scrolled_window_set_child*(scrolledWindow: GtkScrolledWindow, child: GtkWidget)
proc gtk_scrolled_window_get_child*(scrolledWindow: GtkScrolledWindow): GtkWidget
```

**Что делает.** Устанавливают и читают единственный дочерний виджет — тот же паттерн "один слот содержимого", что у `gtk_window_set_child` (базовый справочник). Чтобы прокручивать несколько элементов сразу, единственным ребёнком делают контейнер (`GtkBox`/`GtkGrid`), как и для окна.

- `scrolledWindow` — контейнер.
- `child` — виджет-содержимое.

```nim
gtk_scrolled_window_set_child(scrolled, longArticleTextView)
echo "Длинный текст помещён в прокручиваемую область"
```

---

### `gtk_scrolled_window_set_policy` / `gtk_scrolled_window_get_policy`

```nim
proc gtk_scrolled_window_set_policy*(scrolledWindow: GtkScrolledWindow, hscrollbarPolicy: GtkPolicyType, vscrollbarPolicy: GtkPolicyType)
proc gtk_scrolled_window_get_policy*(scrolledWindow: GtkScrolledWindow, hscrollbarPolicy: ptr GtkPolicyType, vscrollbarPolicy: ptr GtkPolicyType)
```

**Что делает.** Задают, когда именно показывать полосу прокрутки по каждой из двух осей независимо: `GTK_POLICY_ALWAYS` — всегда показывать, `GTK_POLICY_AUTOMATIC` — показывать только когда содержимое действительно не помещается (значение по умолчанию для обеих осей), `GTK_POLICY_NEVER` — никогда не показывать полосу этой оси (содержимое либо обрезается, либо не может выходить за размер по этой оси — типично для отключения горизонтальной прокрутки в списке с переносом текста), `GTK_POLICY_EXTERNAL` — полоса прокрутки не рисуется самим виджетом вообще, предполагается, что прокрутку обеспечивает какой-то внешний виджет (специализированный случай).

- `scrolledWindow` — контейнер.
- `hscrollbarPolicy`, `vscrollbarPolicy` — политика для горизонтальной и вертикальной полос.

```nim
gtk_scrolled_window_set_policy(scrolled, GTK_POLICY_NEVER, GTK_POLICY_AUTOMATIC)
echo "Горизонтальная прокрутка отключена, вертикальная — по необходимости"
```

---

### `gtk_scrolled_window_set_has_frame` / `gtk_scrolled_window_get_has_frame`

```nim
proc gtk_scrolled_window_set_has_frame*(scrolledWindow: GtkScrolledWindow, hasFrame: gboolean)
proc gtk_scrolled_window_get_has_frame*(scrolledWindow: GtkScrolledWindow): gboolean
```

**Что делает.** Показывают/убирают рамку вокруг прокручиваемой области — та же логика, что и у `gtk_entry_set_has_frame`/`gtk_button_set_has_frame`. Рамка помогает визуально отделить прокручиваемую область от окружающего интерфейса, особенно когда содержимое (например, список) само по себе не имеет чёткой границы.

- `scrolledWindow` — контейнер.
- `hasFrame` — `1.gboolean` для рамки.

```nim
gtk_scrolled_window_set_has_frame(scrolled, 1.gboolean)
echo "Прокручиваемая область теперь визуально обведена рамкой"
```

---

## GtkFrame

`GtkFrame` — простая декоративная рамка вокруг одного дочернего виджета, опционально с подписью в верхнем крае рамки. Используется для визуальной группировки связанных элементов формы или панели настроек — то же назначение, что у HTML-тега `<fieldset>`.

### `gtk_frame_new`

```nim
proc gtk_frame_new*(label: cstring): GtkFrame
```

**Что делает.** Создаёт рамку с текстовой подписью. Передача `nil` вместо `label` создаёт рамку без подписи — только линия по периметру.

- `label` — текст подписи, либо `nil` без подписи.

```nim
let printSettingsFrame = gtk_frame_new("Параметры печати")
echo "Рамка с подписью 'Параметры печати' создана"
```

---

### `gtk_frame_set_label` / `gtk_frame_get_label`

```nim
proc gtk_frame_set_label*(frame: GtkFrame, label: cstring)
proc gtk_frame_get_label*(frame: GtkFrame): cstring
```

**Что делает.** Устанавливают и читают текст подписи уже после создания рамки. Передача `nil` убирает подпись целиком (не то же самое, что пустая строка `""`, которая покажет пустое, но заметное место для подписи).

- `frame` — рамка.
- `label` — новый текст подписи, либо `nil`.

```nim
gtk_frame_set_label(printSettingsFrame, "Дополнительные параметры печати")
echo "Подпись рамки: ", $gtk_frame_get_label(printSettingsFrame)
```

---

### `gtk_frame_set_child` / `gtk_frame_get_child`

```nim
proc gtk_frame_set_child*(frame: GtkFrame, child: GtkWidget)
proc gtk_frame_get_child*(frame: GtkFrame): GtkWidget
```

**Что делает.** Устанавливают и читают единственный дочерний виджет рамки — тот же паттерн, что у `gtk_window_set_child`/`gtk_scrolled_window_set_child`. Чтобы сгруппировать несколько элементов внутри рамки, единственным ребёнком делают `GtkBox`/`GtkGrid`.

- `frame` — рамка.
- `child` — виджет-содержимое.

```nim
let settingsBox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 8)
gtk_frame_set_child(printSettingsFrame, settingsBox)
echo "Рамка теперь содержит вертикальный список настроек"
```

---

### `gtk_frame_set_label_widget` / `gtk_frame_get_label_widget`

```nim
proc gtk_frame_set_label_widget*(frame: GtkFrame, label_widget: GtkWidget)
proc gtk_frame_get_label_widget*(frame: GtkFrame): GtkWidget
```

**Что делает.** Заменяют простую текстовую подпись на произвольный виджет в качестве заголовка рамки — например, флажок `GtkCheckButton`, позволяющий целиком включать/выключать группу настроек внутри рамки прямо через сам заголовок (частый паттерн панелей настроек: "☐ Включить автосохранение" как заголовок рамки с параметрами автосохранения внутри). Установка `label_widget` отменяет действие `set_label` и наоборот — оба метода задают одно и то же место, только простым текстом или виджетом.

- `frame` — рамка.
- `label_widget` — виджет-заголовок.

```nim
let enableAutosaveCheck = gtk_check_button_new_with_label("Автосохранение")
gtk_frame_set_label_widget(printSettingsFrame, enableAutosaveCheck)
echo "Заголовок рамки заменён на флажок включения группы настроек"
```

---

### `gtk_frame_set_label_align` / `gtk_frame_get_label_align`

```nim
proc gtk_frame_set_label_align*(frame: GtkFrame, xalign: cfloat)
proc gtk_frame_get_label_align*(frame: GtkFrame): cfloat
```

**Что делает.** Задают горизонтальное положение подписи вдоль верхнего края рамки дробным значением: `0.0` — у левого края (значение по умолчанию), `0.5` — по центру, `1.0` — у правого края.

- `frame` — рамка.
- `xalign` — значение от `0.0` до `1.0`.

```nim
gtk_frame_set_label_align(printSettingsFrame, 0.5)
echo "Подпись рамки отцентрирована по верхнему краю"
```

---

## GtkSeparator

`GtkSeparator` — тонкая разделительная линия, горизонтальная или вертикальная, без какого-либо собственного поведения — визуальный аналог HTML-тега `<hr>`, используемый внутри `GtkBox` для отделения групп элементов друг от друга.

### `gtk_separator_new`

```nim
proc gtk_separator_new*(orientation: GtkOrientation): GtkSeparator
```

**Что делает.** Создаёт разделительную линию. Ориентация линии обычно противоположна ориентации `GtkBox`, в который её помещают: в горизонтальном `GtkBox` (элементы выстроены в ряд) нужен **вертикальный** разделитель, чтобы визуально разбить ряд на группы; в вертикальном `GtkBox` — соответственно горизонтальный.

- `orientation` — `GTK_ORIENTATION_HORIZONTAL` или `GTK_ORIENTATION_VERTICAL`.

```nim
let toolbar = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 6)
gtk_box_append(toolbar, cutButton)
gtk_box_append(toolbar, copyButton)
gtk_box_append(toolbar, pasteButton)
let divider = gtk_separator_new(GTK_ORIENTATION_VERTICAL)  # вертикальная линия в горизонтальном ряду
gtk_box_append(toolbar, divider)
gtk_box_append(toolbar, undoButton)
echo "Панель инструментов: [Вырезать][Копировать][Вставить] | [Отменить]"
```

---

## GtkImage

`GtkImage` — виджет для показа статичного изображения: иконки из системной темы, файла на диске, или произвольного уже подготовленного `GdkPaintable` (общий интерфейс GTK4 для всего, что можно нарисовать, — включая, например, кадр из видео или сгенерированный код программно).

### `gtk_image_new` / `gtk_image_new_from_file` / `gtk_image_new_from_icon_name` / `gtk_image_new_from_paintable`

```nim
proc gtk_image_new*(): GtkImage
proc gtk_image_new_from_file*(filename: cstring): GtkImage
proc gtk_image_new_from_icon_name*(iconName: cstring): GtkImage
proc gtk_image_new_from_paintable*(paintable: GdkPaintable): GtkImage
```

**Что делает.** Четыре способа создать изображение: пустое (содержимое задаётся позже одним из сеттеров ниже), из файла на диске (загружается сразу, синхронно — для больших файлов или сетевых путей это может задержать интерфейс, лучше использовать асинхронную загрузку через `GdkPixbufLoader`/`GFile`, не входящую в этот справочник), из иконки системной темы по имени (предпочтительный способ для стандартных значков действий — масштабируется под тему и режим тёмный/светлый автоматически), и из уже готового `GdkPaintable` (например, `GdkTexture`, полученного любым другим способом — из декодированного видеокадра, сгенерированного изображения и т.п.).

- `filename` — путь к файлу изображения на диске.
- `iconName` — имя иконки в теме (например, `"folder-symbolic"`).
- `paintable` — готовый объект, реализующий интерфейс `GdkPaintable`.

```nim
let logo = gtk_image_new_from_file("/usr/share/myapp/logo.png")
let openIcon = gtk_image_new_from_icon_name("document-open-symbolic")
echo "Изображение из файла и иконка из темы созданы"
```

---

### `gtk_image_set_from_file` / `gtk_image_set_from_icon_name` / `gtk_image_set_from_paintable`

```nim
proc gtk_image_set_from_file*(image: GtkImage, filename: cstring)
proc gtk_image_set_from_icon_name*(image: GtkImage, iconName: cstring)
proc gtk_image_set_from_paintable*(image: GtkImage, paintable: GdkPaintable)
```

**Что делает.** Меняют содержимое уже существующего виджета `GtkImage` на новое изображение любым из трёх источников — тот же выбор, что и у одноимённых конструкторов, но применимо к уже размещённому в интерфейсе виджету (например, чтобы сменить превью после выбора другого файла в списке).

- `image` — виджет изображения.
- `filename` / `iconName` / `paintable` — новый источник изображения.

```nim
gtk_image_set_from_icon_name(statusIcon, "emblem-ok-symbolic")
echo "Иконка статуса обновлена на 'готово'"
```

---

### `gtk_image_get_paintable`

```nim
proc gtk_image_get_paintable*(image: GtkImage): GdkPaintable
```

**Что делает.** Возвращает текущее изображение виджета как объект `GdkPaintable`, независимо от того, каким из трёх способов оно было установлено (даже если исходно был указан файл или имя иконки, а не готовый `GdkPaintable` напрямую). Полезно, когда нужно переиспользовать то же самое изображение в другом месте интерфейса (например, ещё в одном `GtkImage`) без повторной загрузки с диска.

- `image` — виджет изображения.

```nim
let currentPaintable = gtk_image_get_paintable(logo)
let secondLogo = gtk_image_new_from_paintable(currentPaintable)
echo "Второй экземпляр логотипа создан без повторного чтения файла"
```

---

### `gtk_image_set_pixel_size` / `gtk_image_get_pixel_size`

```nim
proc gtk_image_set_pixel_size*(image: GtkImage, pixelSize: gint)
proc gtk_image_get_pixel_size*(image: GtkImage): gint
```

**Что делает.** Задают квадратный размер (в пикселях) для отображения изображения — особенно важно для иконок из темы, установленных по имени: сама тема обычно хранит иконку в нескольких дискретных размерах (16, 24, 32, 48...), и без явного `pixel_size` GTK выбирает размер по контексту использования, который не всегда подходит; явное указание размера гарантирует предсказуемый результат вне зависимости от темы. Значение `-1` означает "использовать размер по умолчанию для контекста".

- `image` — виджет изображения.
- `pixelSize` — сторона квадрата в пикселях, либо `-1`.

```nim
let largeIcon = gtk_image_new_from_icon_name("dialog-warning-symbolic")
gtk_image_set_pixel_size(largeIcon, 48)
echo "Иконка предупреждения увеличена до 48×48 пикселей"
```

---

## GtkSpinner

`GtkSpinner` — простой крутящийся индикатор активности без числового значения ("что-то происходит, но неизвестно, сколько именно и когда закончится") — визуальный аналог `gtk_entry_progress_pulse` из справочника по вводу текста, но как самостоятельный виджет, а не встроенный в поле ввода.

### `gtk_spinner_new`

```nim
proc gtk_spinner_new*(): GtkSpinner
```

**Что делает.** Создаёт спиннер в остановленном (невидимом с точки зрения анимации) состоянии.

- Параметров нет.

```nim
let loadingSpinner = gtk_spinner_new()
echo "Спиннер создан, но пока не крутится"
```

---

### `gtk_spinner_start` / `gtk_spinner_stop`

```nim
proc gtk_spinner_start*(spinner: GtkSpinner)
proc gtk_spinner_stop*(spinner: GtkSpinner)
```

**Что делает.** Запускают и останавливают анимацию вращения. В отличие от `gtk_widget_hide`, `stop` не скрывает сам виджет — он просто перестаёт крутиться и застывает в текущем кадре; если нужно, чтобы спиннер полностью исчезал по завершении операции, `stop` обычно комбинируют с `gtk_widget_set_visible(spinner, 0.gboolean)`.

- `spinner` — спиннер.

```nim
gtk_spinner_start(loadingSpinner)
gtk_widget_set_visible(loadingSpinner, 1.gboolean)
echo "Началась загрузка, спиннер запущен и показан"
# ... после завершения операции ...
gtk_spinner_stop(loadingSpinner)
gtk_widget_set_visible(loadingSpinner, 0.gboolean)
echo "Загрузка завершена, спиннер остановлен и скрыт"
```

---

## GtkProgressBar

`GtkProgressBar` — горизонтальная (или вертикальная — зависит от ориентации родительского контейнера, у самого виджета явной настройки ориентации в этой обёртке нет) полоса, показывающая долю выполнения операции. В отличие от `GtkSpinner`, полезна именно когда доля прогресса **известна** — как точным числом, так и (через `pulse`) в режиме "неизвестно сколько, но точно что-то происходит", аналогично пульсирующему режиму `GtkEntry`.

### `gtk_progress_bar_new`

```nim
proc gtk_progress_bar_new*(): GtkProgressBar
```

**Что делает.** Создаёт полосу прогресса с нулевым значением выполнения.

- Параметров нет.

```nim
let exportProgress = gtk_progress_bar_new()
echo "Полоса прогресса экспорта создана"
```

---

### `gtk_progress_bar_set_fraction` / `gtk_progress_bar_get_fraction`

```nim
proc gtk_progress_bar_set_fraction*(pbar: GtkProgressBar, fraction: gdouble)
proc gtk_progress_bar_get_fraction*(pbar: GtkProgressBar): gdouble
```

**Что делает.** Устанавливают и читают долю выполнения от `0.0` (ничего не сделано) до `1.0` (полностью завершено).

- `pbar` — полоса прогресса.
- `fraction` — значение от `0.0` до `1.0`.

```nim
gtk_progress_bar_set_fraction(exportProgress, 0.42)
echo "Прогресс экспорта: ", int(gtk_progress_bar_get_fraction(exportProgress) * 100), "%"
```

---

### `gtk_progress_bar_set_text` / `gtk_progress_bar_get_text` / `gtk_progress_bar_set_show_text` / `gtk_progress_bar_get_show_text`

```nim
proc gtk_progress_bar_set_text*(pbar: GtkProgressBar, text: cstring)
proc gtk_progress_bar_get_text*(pbar: GtkProgressBar): cstring
proc gtk_progress_bar_set_show_text*(pbar: GtkProgressBar, showText: gboolean)
proc gtk_progress_bar_get_show_text*(pbar: GtkProgressBar): gboolean
```

**Что делает.** Задают текст, отображаемый поверх полосы прогресса (например, `"42%"` или `"Обработка файла 3 из 7"`), и управляют тем, показывается ли этот текст вообще (`show_text`, по умолчанию выключено). Если `set_text` не вызывался или ему передан `nil`, а `show_text` включён, GTK сама показывает вычисленный процент вида `"42 %"` на основе `fraction`.

- `pbar` — полоса прогресса.
- `text` — текст поверх полосы, либо `nil` для автоматического процента.
- `showText` — `1.gboolean`, чтобы показывать текст.

```nim
gtk_progress_bar_set_show_text(exportProgress, 1.gboolean)
gtk_progress_bar_set_text(exportProgress, "Кодирование видео: кадр 420 из 1000")
echo "Текст поверх полосы прогресса: ", $gtk_progress_bar_get_text(exportProgress)
```

---

### `gtk_progress_bar_pulse`

```nim
proc gtk_progress_bar_pulse*(pbar: GtkProgressBar)
```

**Что делает.** Сдвигает небольшой блок внутри полосы прогресса на один шаг вперёд-назад — режим для операций с неизвестной длительностью, аналогичный `gtk_entry_progress_pulse` из справочника по вводу текста. Как и там, автоматической анимации нет — `pulse` нужно вызывать самостоятельно и периодически (например, по таймеру каждые 100–200 мс), пока операция не завершится, после чего обычно переключаются на `set_fraction(pbar, 1.0)` либо скрывают полосу целиком.

- `pbar` — полоса прогресса.

```nim
proc onPulseTick(userData: gpointer): gboolean {.cdecl.} =
  gtk_progress_bar_pulse(cast[GtkProgressBar](userData))
  result = 1.gboolean  # продолжать таймер

# g_timeout_add(150, onPulseTick, cast[gpointer](searchProgress))  # см. справочник по GLib-таймерам
echo "Пульсирующая индикация для операции с неизвестной длительностью запущена"
```

---

## Практические рецепты

### Прокручиваемый список внутри окна фиксированного размера

Классическая связка: окно с фиксированным размером, содержащее длинный список, который прокручивается внутри выделенной ему области, не растягивая само окно.

```nim
proc buildScrollableContentWindow(app: GtkApplication): GtkWindow =
  result = gtk_application_window_new(app)
  gtk_window_set_default_size(result, 400, 500)

  let listBox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 4)
  for i in 1..50:
    gtk_box_append(listBox, gtk_label_new(("Элемент " & $i).cstring))

  let scrolled = gtk_scrolled_window_new()
  gtk_scrolled_window_set_policy(scrolled, GTK_POLICY_NEVER, GTK_POLICY_AUTOMATIC)
  gtk_scrolled_window_set_child(scrolled, listBox)

  gtk_window_set_child(result, scrolled)
  echo "50 элементов помещены в окно фиксированного размера 400×500 с вертикальной прокруткой"

# let window = buildScrollableContentWindow(app)
```

---

### Группа настроек в подписанной рамке

`GtkFrame` с текстовой подписью, содержащий `GtkGrid` с несколькими настройками, — типичный визуальный блок панели настроек.

```nim
proc buildSettingsGroup(title: string): GtkFrame =
  result = gtk_frame_new(title.cstring)
  let content = gtk_grid_new()
  gtk_grid_set_row_spacing(content, 8)
  gtk_grid_set_column_spacing(content, 12)
  gtk_widget_set_margin_start(content, 12)
  gtk_widget_set_margin_end(content, 12)
  gtk_widget_set_margin_top(content, 12)
  gtk_widget_set_margin_bottom(content, 12)
  gtk_frame_set_child(result, content)

let networkGroup = buildSettingsGroup("Сеть")
echo "Группа настроек 'Сеть' в подписанной рамке готова к заполнению полями"
```

---

### Панель инструментов с разделителями между группами кнопок

Три логические группы кнопок, разделённые вертикальными линиями.

```nim
proc buildToolbarWithSeparators(): GtkBox =
  result = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 4)

  for iconName in ["document-new-symbolic", "document-open-symbolic", "document-save-symbolic"]:
    gtk_box_append(result, gtk_button_new_from_icon_name(iconName.cstring))

  gtk_box_append(result, gtk_separator_new(GTK_ORIENTATION_VERTICAL))

  for iconName in ["edit-cut-symbolic", "edit-copy-symbolic", "edit-paste-symbolic"]:
    gtk_box_append(result, gtk_button_new_from_icon_name(iconName.cstring))

  gtk_box_append(result, gtk_separator_new(GTK_ORIENTATION_VERTICAL))
  gtk_box_append(result, gtk_button_new_from_icon_name("edit-undo-symbolic"))

  echo "Панель инструментов из трёх групп, разделённых вертикальными линиями, собрана"

let toolbar = buildToolbarWithSeparators()
```

---

### Индикатор загрузки: спиннер, пока идёт запрос, полоса прогресса — когда известна доля выполнения

Переключение между двумя видами индикации в зависимости от того, известен ли прогресс операции на момент её начала.

```nim
proc showIndeterminateLoading(container: GtkBox): GtkSpinner =
  result = gtk_spinner_new()
  gtk_spinner_start(result)
  gtk_box_append(container, result)
  echo "Показан спиннер — доля выполнения запроса пока неизвестна"

proc switchToKnownProgress(container: GtkBox, spinner: GtkSpinner): GtkProgressBar =
  gtk_spinner_stop(spinner)
  gtk_box_remove(container, spinner)
  result = gtk_progress_bar_new()
  gtk_progress_bar_set_show_text(result, 1.gboolean)
  gtk_box_append(container, result)
  echo "Сервер сообщил общий размер файла — переключились на точную полосу прогресса"

proc updateProgress(pbar: GtkProgressBar, downloaded, total: int) =
  gtk_progress_bar_set_fraction(pbar, downloaded.float / total.float)
  gtk_progress_bar_set_text(pbar, (
    $downloaded & " из " & $total & " МБ"
  ).cstring)
```

---

### Аватар пользователя с запасной иконкой

Попытка загрузить изображение аватара из файла, с откатом на стандартную иконку профиля, если файла нет.

```nim
proc buildAvatarImage(avatarPath: string): GtkImage =
  if fileExists(avatarPath):
    result = gtk_image_new_from_file(avatarPath.cstring)
    echo "Аватар загружен из файла: ", avatarPath
  else:
    result = gtk_image_new_from_icon_name("avatar-default-symbolic")
    echo "Файл аватара не найден, показана стандартная иконка профиля"
  gtk_image_set_pixel_size(result, 64)

let userAvatar = buildAvatarImage("/home/user/.cache/myapp/avatar.png")
```

---

## Краткая таблица

| Процедура(ы) | Категория | Что делает вкратце |
|---|---|---|
| `gtk_scrolled_window_new` | ScrolledWindow | Создать прокручиваемый контейнер |
| `gtk_scrolled_window_set/get_child` | ScrolledWindow | Единственный дочерний виджет |
| `gtk_scrolled_window_set/get_policy` | ScrolledWindow | Когда показывать полосы прокрутки по каждой оси |
| `gtk_scrolled_window_set/get_has_frame` | ScrolledWindow | Рамка вокруг прокручиваемой области |
| `gtk_frame_new` | Frame | Создать рамку с подписью или без |
| `gtk_frame_set/get_label` | Frame | Текст подписи |
| `gtk_frame_set/get_child` | Frame | Единственный дочерний виджет внутри рамки |
| `gtk_frame_set/get_label_widget` | Frame | Произвольный виджет вместо текстовой подписи |
| `gtk_frame_set/get_label_align` | Frame | Положение подписи вдоль верхнего края |
| `gtk_separator_new` | Separator | Создать разделительную линию |
| `gtk_image_new`, `_from_file`, `_from_icon_name`, `_from_paintable` | Image | Создать изображение из разных источников |
| `gtk_image_set_from_file/icon_name/paintable` | Image | Сменить содержимое существующего виджета |
| `gtk_image_get_paintable` | Image | Получить текущее изображение как `GdkPaintable` |
| `gtk_image_set/get_pixel_size` | Image | Размер отображения (особенно важно для иконок темы) |
| `gtk_spinner_new` | Spinner | Создать крутящийся индикатор активности |
| `gtk_spinner_start/stop` | Spinner | Запустить/остановить анимацию вращения |
| `gtk_progress_bar_new` | ProgressBar | Создать полосу прогресса |
| `gtk_progress_bar_set/get_fraction` | ProgressBar | Точная доля выполнения от 0.0 до 1.0 |
| `gtk_progress_bar_set/get_text`, `set/get_show_text` | ProgressBar | Текст поверх полосы (свой или автоматический процент) |
| `gtk_progress_bar_pulse` | ProgressBar | Пульсация для операций с неизвестной длительностью |

---

## Сводка: какую процедуру выбрать

- **Список/текст/таблица может не поместиться на экране** → всегда оборачивать в `GtkScrolledWindow`, а не полагаться на то, что окно само подстроится под содержимое — без обёртки длинное содержимое просто растянет окно, а не станет прокручиваемым.
- **Визуально сгруппировать несколько полей формы или настроек** → `GtkFrame` с подписью, а не просто отступ пустым пространством — рамка даёт чёткую видимую границу группы. Если группу нужно целиком включать/выключать одним переключателем прямо в заголовке → `gtk_frame_set_label_widget` с флажком вместо простого текста.
- **Разбить ряд кнопок в панели инструментов на смысловые группы** → `GtkSeparator` **противоположной** ориентации относительно `GtkBox`, в который он вложен (вертикальная линия — в горизонтальном ряду).
- **Показать иконку или картинку** → `GtkImage`; для стандартных значков действий — конструктор `_from_icon_name` (масштабируется под тему автоматически), а не `_from_file` с иконкой, экспортированной вручную в конкретном размере.
- **Индикация "что-то происходит, но неизвестно сколько"** → `GtkSpinner` (компактный, без числового значения) для коротких операций, либо `GtkProgressBar` в пульсирующем режиме (`gtk_progress_bar_pulse`), если по контексту уместнее именно полоса, а не крутящийся значок.
- **Индикация с известной точной долей выполнения** → `GtkProgressBar` с `gtk_progress_bar_set_fraction`, не пульсация — пульсирующий режим сигнализирует пользователю именно неопределённость длительности.
- **Текст поверх полосы прогресса** → `gtk_progress_bar_set_show_text` + `gtk_progress_bar_set_text` для содержательного текста; если достаточно процента — просто `set_show_text(true)` без вызова `set_text`, GTK покажет процент от `fraction` сама.
