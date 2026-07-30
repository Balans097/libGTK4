# GTK4 (about/color/font dialogs, GLArea, clipboard & images: AboutDialog / ColorChooserDialog / FontChooserDialog / GLArea / Clipboard / GdkPixbuf / GdkTexture) — справочник модуля

> **Импорт:** `import libGTK4`
> **Область применения:** диалог "О программе", системные диалоги выбора цвета и шрифта, область рендеринга OpenGL, системный буфер обмена и два способа работы с растровыми изображениями в памяти. Двенадцатая часть серии справочников по обёртке; предполагает знакомство с предыдущими частями, особенно с `gtk4_core_reference_ru.md` и `gtk4_window_chrome_dialogs_reference_ru.md` (диалоги, `GtkWindow`).

`GdkPixbuf` и `GdkTexture` решают внешне похожую задачу (растровое изображение в памяти), но для разных целей: `GdkPixbuf` — старый, CPU-ориентированный формат, удобный для программной обработки пикселей (масштабирование, сохранение в файл, построчная загрузка из потока); `GdkTexture` — современный, GPU-ориентированный формат, оптимальный для показа изображения на экране (то, что в итоге принимают `gtk_image_new_from_paintable`/`gtk_picture_set_paintable` из предыдущих справочников, поскольку `GdkTexture` реализует интерфейс `GdkPaintable`). Между ними есть прямое преобразование (`gdk_texture_new_for_pixbuf`).

---

## Оглавление

I. [GtkAboutDialog](#gtkaboutdialog)
&nbsp;&nbsp;1. [`gtk_about_dialog_new`](#gtk_about_dialog_new)
&nbsp;&nbsp;2. [`gtk_about_dialog_set/get_program_name`, `set/get_version`, `set/get_copyright`, `set/get_comments`](#gtk_about_dialog_setget_program_name-setget_version-setget_copyright-setget_comments)
&nbsp;&nbsp;3. [`gtk_about_dialog_set/get_license`](#gtk_about_dialog_setget_license)
&nbsp;&nbsp;4. [`gtk_about_dialog_set/get_website`, `set/get_website_label`](#gtk_about_dialog_setget_website-setget_website_label)
&nbsp;&nbsp;5. [`gtk_about_dialog_set/get_authors`](#gtk_about_dialog_setget_authors)
&nbsp;&nbsp;6. [`gtk_about_dialog_set/get_logo`, `set/get_logo_icon_name`](#gtk_about_dialog_setget_logo-setget_logo_icon_name)

II. [GtkColorChooserDialog](#gtkcolorchooserdialog)
&nbsp;&nbsp;1. [`gtk_color_chooser_dialog_new`](#gtk_color_chooser_dialog_new)
&nbsp;&nbsp;2. [`gtk_color_chooser_get_rgba` / `gtk_color_chooser_set_rgba`](#gtk_color_chooser_get_rgba--gtk_color_chooser_set_rgba)
&nbsp;&nbsp;3. [`gtk_color_chooser_set_use_alpha` / `gtk_color_chooser_get_use_alpha`](#gtk_color_chooser_set_use_alpha--gtk_color_chooser_get_use_alpha)

III. [GtkFontChooserDialog](#gtkfontchooserdialog)
&nbsp;&nbsp;1. [`gtk_font_chooser_dialog_new`](#gtk_font_chooser_dialog_new)
&nbsp;&nbsp;2. [`gtk_font_chooser_get_font` / `gtk_font_chooser_set_font`](#gtk_font_chooser_get_font--gtk_font_chooser_set_font)
&nbsp;&nbsp;3. [`gtk_font_chooser_get_font_desc` / `gtk_font_chooser_set_font_desc`](#gtk_font_chooser_get_font_desc--gtk_font_chooser_set_font_desc)
&nbsp;&nbsp;4. [`gtk_font_chooser_get_preview_text` / `gtk_font_chooser_set_preview_text`](#gtk_font_chooser_get_preview_text--gtk_font_chooser_set_preview_text)

IV. [GtkGLArea](#gtkglarea)
&nbsp;&nbsp;1. [`gtk_gl_area_new`](#gtk_gl_area_new)
&nbsp;&nbsp;2. [`gtk_gl_area_make_current` / `gtk_gl_area_queue_render` / `gtk_gl_area_attach_buffers`](#gtk_gl_area_make_current--gtk_gl_area_queue_render--gtk_gl_area_attach_buffers)
&nbsp;&nbsp;3. [`gtk_gl_area_set/get_required_version`](#gtk_gl_area_setget_required_version)
&nbsp;&nbsp;4. [`gtk_gl_area_set/get_has_depth_buffer`, `set/get_has_stencil_buffer`](#gtk_gl_area_setget_has_depth_buffer-setget_has_stencil_buffer)

V. [Буфер обмена: GdkClipboard](#буфер-обмена-gdkclipboard)
&nbsp;&nbsp;1. [`gdk_display_get_clipboard`](#gdk_display_get_clipboard)
&nbsp;&nbsp;2. [`gdk_clipboard_set_text`](#gdk_clipboard_set_text)
&nbsp;&nbsp;3. [`gdk_clipboard_read_text_async` / `gdk_clipboard_read_text_finish`](#gdk_clipboard_read_text_async--gdk_clipboard_read_text_finish)

VI. [GdkPixbuf](#gdkpixbuf)
&nbsp;&nbsp;1. [`gdk_pixbuf_new` / `gdk_pixbuf_new_from_file`](#gdk_pixbuf_new--gdk_pixbuf_new_from_file)
&nbsp;&nbsp;2. [`gdk_pixbuf_get_width` / `gdk_pixbuf_get_height`](#gdk_pixbuf_get_width--gdk_pixbuf_get_height)
&nbsp;&nbsp;3. [`gdk_pixbuf_scale_simple`](#gdk_pixbuf_scale_simple)
&nbsp;&nbsp;4. [`gdk_pixbuf_savev`](#gdk_pixbuf_savev)
&nbsp;&nbsp;5. [`gdk_pixbuf_new_from_stream` / `g_memory_input_stream_new_from_bytes`](#gdk_pixbuf_new_from_stream--g_memory_input_stream_new_from_bytes)
&nbsp;&nbsp;6. [Пошаговая загрузка: `gdk_pixbuf_loader_new` и родственные](#пошаговая-загрузка-gdk_pixbuf_loader_new-и-родственные)

VII. [GdkTexture](#gdktexture)
&nbsp;&nbsp;1. [`gdk_texture_new_for_pixbuf`](#gdk_texture_new_for_pixbuf)
&nbsp;&nbsp;2. [`gdk_texture_new_from_file` / `gdk_texture_new_from_filename`](#gdk_texture_new_from_file--gdk_texture_new_from_filename)
&nbsp;&nbsp;3. [`gdk_texture_get_width` / `gdk_texture_get_height`](#gdk_texture_get_width--gdk_texture_get_height)
&nbsp;&nbsp;4. [`gdk_texture_new_from_bytes` / `g_bytes_new_static` / `g_bytes_unref`](#gdk_texture_new_from_bytes--g_bytes_new_static--g_bytes_unref)

VIII. [Практические рецепты](#практические-рецепты)
&nbsp;&nbsp;1. [Диалог "О программе" с полным набором сведений](#диалог-о-программе-с-полным-набором-сведений)
&nbsp;&nbsp;2. [Кнопка выбора цвета акцента с диалогом](#кнопка-выбора-цвета-акцента-с-диалогом)
&nbsp;&nbsp;3. [Копирование текста в буфер обмена и чтение из него](#копирование-текста-в-буфер-обмена-и-чтение-из-него)
&nbsp;&nbsp;4. [Уменьшение изображения перед сохранением в миниатюру](#уменьшение-изображения-перед-сохранением-в-миниатюру)
&nbsp;&nbsp;5. [Пошаговая загрузка изображения из потока данных, приходящих частями](#пошаговая-загрузка-изображения-из-потока-данных-приходящих-частями)

IX. [Краткая таблица](#краткая-таблица)

X. [Сводка: какую процедуру выбрать](#сводка-какую-процедуру-выбрать)

---

## GtkAboutDialog

`GtkAboutDialog` — готовый диалог "О программе" со стандартным набором полей (название, версия, авторы, лицензия, сайт), не требующий вручную собирать вёрстку, — заполняются только текстовые данные, компоновка и оформление берёт на себя сама GTK.

### `gtk_about_dialog_new`

```nim
proc gtk_about_dialog_new*(): GtkAboutDialog
```

**Что делает.** Создаёт пустой диалог "О программе" — все поля изначально не заполнены, показ диалога без единого заполненного поля даст малосодержательный результат, обычно сразу вслед за созданием заполняется хотя бы название и версия (следующий подраздел).

- Параметров нет.

```nim
let aboutDialog = gtk_about_dialog_new()
echo "Диалог 'О программе' создан"
```

---

### `gtk_about_dialog_set/get_program_name`, `set/get_version`, `set/get_copyright`, `set/get_comments`

```nim
proc gtk_about_dialog_set_program_name*(about: GtkAboutDialog, name: cstring)
proc gtk_about_dialog_get_program_name*(about: GtkAboutDialog): cstring
proc gtk_about_dialog_set_version*(about: GtkAboutDialog, version: cstring)
proc gtk_about_dialog_get_version*(about: GtkAboutDialog): cstring
proc gtk_about_dialog_set_copyright*(about: GtkAboutDialog, copyright: cstring)
proc gtk_about_dialog_get_copyright*(about: GtkAboutDialog): cstring
proc gtk_about_dialog_set_comments*(about: GtkAboutDialog, comments: cstring)
proc gtk_about_dialog_get_comments*(about: GtkAboutDialog): cstring
```

**Что делает.** Заполняют основные текстовые поля диалога: `program_name` — название приложения (крупным шрифтом в верхней части диалога), `version` — строка версии, `copyright` — короткая строка авторского права (например, `"© 2026 Ваша компания"`), `comments` — короткое описание назначения приложения (одно-два предложения, показывается под названием).

- `about` — диалог "О программе".
- `name`, `version`, `copyright`, `comments` — соответствующие строки.

```nim
gtk_about_dialog_set_program_name(aboutDialog, "Редактор проекта")
gtk_about_dialog_set_version(aboutDialog, "1.3.0")
gtk_about_dialog_set_copyright(aboutDialog, "© 2026 Ваша компания")
gtk_about_dialog_set_comments(aboutDialog, "Простой редактор для быстрой работы с проектами")
echo "Основные сведения диалога заполнены"
```

---

### `gtk_about_dialog_set/get_license`

```nim
proc gtk_about_dialog_set_license*(about: GtkAboutDialog, license: cstring)
proc gtk_about_dialog_get_license*(about: GtkAboutDialog): cstring
```

**Что делает.** Задают полный текст лицензии, показываемый на отдельной вкладке/экране диалога (для длинного текста, например полного текста MIT/GPL) — в отличие от `gtk_about_dialog_set_website_label` (следующий подраздел), не ссылка, а именно встроенный текст целиком.

- `about` — диалог "О программе".
- `license` — полный текст лицензии.

```nim
gtk_about_dialog_set_license(aboutDialog, "Распространяется по лицензии MIT.\n\nПолный текст лицензии...")
echo "Текст лицензии добавлен в диалог"
```

---

### `gtk_about_dialog_set/get_website`, `set/get_website_label`

```nim
proc gtk_about_dialog_set_website*(about: GtkAboutDialog, website: cstring)
proc gtk_about_dialog_get_website*(about: GtkAboutDialog): cstring
proc gtk_about_dialog_set_website_label*(about: GtkAboutDialog, websiteLabel: cstring)
proc gtk_about_dialog_get_website_label*(about: GtkAboutDialog): cstring
```

**Что делает.** Задают ссылку на сайт проекта (`website` — сам URI) и текст, которым эта ссылка отображается пользователю (`website_label` — например, `"Сайт проекта"` вместо длинного технического URL). Диалог показывает ссылку как кликабельную (аналогично `GtkLinkButton` из справочника по панелям).

- `about` — диалог "О программе".
- `website` — URI сайта.
- `websiteLabel` — видимый текст ссылки.

```nim
gtk_about_dialog_set_website(aboutDialog, "https://example.com")
gtk_about_dialog_set_website_label(aboutDialog, "Сайт проекта")
echo "Ссылка на сайт проекта добавлена"
```

---

### `gtk_about_dialog_set/get_authors`

```nim
proc gtk_about_dialog_set_authors*(about: GtkAboutDialog, authors: ptr cstring)
proc gtk_about_dialog_get_authors*(about: GtkAboutDialog): ptr cstring
```

**Что делает.** Задают список авторов — `NULL`-терминированный массив строк (тот же C-протокол, что у `argv` и у `gtk_application_set_accels_for_action` из справочника по core-разделу), а не единая строка со всеми именами. В Nim такой массив нужно собрать вручную из `seq[string]` перед вызовом.

- `about` — диалог "О программе".
- `authors` — массив строк-имён авторов, завершённый `nil`.

```nim
var authorsArray = [cstring("Иван Петров"), cstring("Анна Сидорова"), nil]
gtk_about_dialog_set_authors(aboutDialog, addr authorsArray[0])
echo "Список из двух авторов добавлен в диалог"
```

---

### `gtk_about_dialog_set/get_logo`, `set/get_logo_icon_name`

```nim
proc gtk_about_dialog_set_logo*(about: GtkAboutDialog, logo: pointer)
proc gtk_about_dialog_get_logo*(about: GtkAboutDialog): pointer
proc gtk_about_dialog_set_logo_icon_name*(about: GtkAboutDialog, iconName: cstring)
proc gtk_about_dialog_get_logo_icon_name*(about: GtkAboutDialog): cstring
```

**Что делает.** Задают логотип, показываемый в верхней части диалога, — либо готовым изображением (`set_logo`, принимает `GdkPaintable` — например, `GdkTexture` из раздела VII, приведённый к `pointer`), либо по имени иконки из системной темы (`set_logo_icon_name`, для приложений, использующих значок из иконочной темы вместо собственного растрового логотипа). Если ни один из способов не вызван, GTK показывает иконку приложения по умолчанию (заданную через `gtk_window_set_default_icon_name`, базовый справочник).

- `about` — диалог "О программе".
- `logo` — изображение логотипа (`GdkPaintable`, приведённый к `pointer`).
- `iconName` — имя иконки в теме.

```nim
gtk_about_dialog_set_logo_icon_name(aboutDialog, "accessories-text-editor")
echo "Логотип задан по имени иконки из темы"
```

---

## GtkColorChooserDialog

`GtkColorChooserDialog` — системный диалог выбора цвета, реализующий интерфейс `GtkColorChooser` поверх `GtkDialog` (те же `gtk_dialog_add_button`/сигнал `"response"` из справочника по window chrome применимы напрямую).

### `gtk_color_chooser_dialog_new`

```nim
proc gtk_color_chooser_dialog_new*(title: cstring, parent: GtkWindow): GtkColorChooserDialog
```

**Что делает.** Создаёт диалог выбора цвета с готовым стандартным набором кнопок ("Отмена"/"Выбрать").

- `title` — заголовок диалога.
- `parent` — родительское окно.

```nim
let colorDialog = gtk_color_chooser_dialog_new("Выберите цвет акцента", mainWindow)
gtk_window_present(colorDialog)
echo "Диалог выбора цвета показан"
```

---

### `gtk_color_chooser_get_rgba` / `gtk_color_chooser_set_rgba`

```nim
proc gtk_color_chooser_get_rgba*(chooser: GtkColorChooser, color: pointer)
proc gtk_color_chooser_set_rgba*(chooser: GtkColorChooser, color: pointer)
```

**Что делает.** Читают и устанавливают текущий выбранный цвет через структуру `GdkRGBA` (компоненты red/green/blue/alpha, каждый — `gdouble` от `0.0` до `1.0`; передаётся как непрозрачный `pointer` — отдельного именованного типа для неё в этом наборе функций нет, структуру нужно объявить вручную).

- `chooser` — диалог выбора цвета.
- `color` — указатель на структуру `GdkRGBA`.

```nim
proc onResponse(dialog: GtkColorChooserDialog, responseId: gint, userData: gpointer) {.cdecl.} =
  if responseId == ord(GTK_RESPONSE_ACCEPT).gint:
    var chosenColor: array[4, gdouble]  # red, green, blue, alpha
    gtk_color_chooser_get_rgba(dialog, addr chosenColor[0])
    echo "Выбран цвет: R=", chosenColor[0], " G=", chosenColor[1], " B=", chosenColor[2]
  gtk_window_destroy(cast[GtkWindow](dialog))

discard g_signal_connect(colorDialog, "response", onResponse, nil)
```

---

### `gtk_color_chooser_set_use_alpha` / `gtk_color_chooser_get_use_alpha`

```nim
proc gtk_color_chooser_set_use_alpha*(chooser: GtkColorChooser, useAlpha: gboolean)
proc gtk_color_chooser_get_use_alpha*(chooser: GtkColorChooser): gboolean
```

**Что делает.** Включают/выключают возможность настраивать прозрачность (альфа-канал) выбираемого цвета — по умолчанию выключено.

- `chooser` — диалог выбора цвета.
- `useAlpha` — `1.gboolean`, чтобы разрешить настройку прозрачности.

```nim
gtk_color_chooser_set_use_alpha(colorDialog, 1.gboolean)
echo "Диалог теперь позволяет настроить и прозрачность цвета"
```

---

## GtkFontChooserDialog

`GtkFontChooserDialog` — системный диалог выбора шрифта с живым предпросмотром, реализующий интерфейс `GtkFontChooser` поверх `GtkDialog`.

### `gtk_font_chooser_dialog_new`

```nim
proc gtk_font_chooser_dialog_new*(title: cstring, parent: GtkWindow): GtkFontChooserDialog
```

**Что делает.** Создаёт диалог выбора шрифта с готовым стандартным набором кнопок.

- `title` — заголовок диалога.
- `parent` — родительское окно.

```nim
let fontDialog = gtk_font_chooser_dialog_new("Выберите шрифт редактора", mainWindow)
gtk_window_present(fontDialog)
echo "Диалог выбора шрифта показан"
```

---

### `gtk_font_chooser_get_font` / `gtk_font_chooser_set_font`

```nim
proc gtk_font_chooser_get_font*(fontchooser: GtkFontChooser): cstring
proc gtk_font_chooser_set_font*(fontchooser: GtkFontChooser, fontname: cstring)
```

**Что делает.** Читают и устанавливают выбранный шрифт единой строкой Pango-описания (например, `"Sans Bold 12"`) — стандартный формат Pango, самый простой способ работы со шрифтом для большинства сценариев.

- `fontchooser` — диалог выбора шрифта.
- `fontname` — строка описания шрифта в формате Pango.

```nim
gtk_font_chooser_set_font(fontDialog, "Monospace 11")
proc onFontResponse(dialog: GtkFontChooserDialog, responseId: gint, userData: gpointer) {.cdecl.} =
  if responseId == ord(GTK_RESPONSE_ACCEPT).gint:
    echo "Выбран шрифт: ", $gtk_font_chooser_get_font(dialog)
  gtk_window_destroy(cast[GtkWindow](dialog))
discard g_signal_connect(fontDialog, "response", onFontResponse, nil)
```

---

### `gtk_font_chooser_get_font_desc` / `gtk_font_chooser_set_font_desc`

```nim
proc gtk_font_chooser_get_font_desc*(fontchooser: GtkFontChooser): pointer
proc gtk_font_chooser_set_font_desc*(fontchooser: GtkFontChooser, fontDesc: pointer)
```

**Что делает.** То же самое, что `get_font`/`set_font`, но через структурированный объект `PangoFontDescription` (непрозрачный `pointer` в этой обёртке) вместо строки — нужен при программной работе со шрифтами, где отдельные компоненты нужно читать/менять по отдельности. Построение и разбор `PangoFontDescription` — функции `pango_font_description_*`, не входящие в этот справочник.

- `fontchooser` — диалог выбора шрифта.
- `fontDesc` — объект `PangoFontDescription`.

```nim
let currentDesc = gtk_font_chooser_get_font_desc(fontDialog)
echo "Структурированное описание текущего шрифта получено: ", not isNil(currentDesc)
```

---

### `gtk_font_chooser_get_preview_text` / `gtk_font_chooser_set_preview_text`

```nim
proc gtk_font_chooser_get_preview_text*(fontchooser: GtkFontChooser): cstring
proc gtk_font_chooser_set_preview_text*(fontchooser: GtkFontChooser, text: cstring)
```

**Что делает.** Задают и читают текст предпросмотра шрифта — по умолчанию GTK показывает стандартную фразу-панграмму; замена на осмысленный для приложения текст помогает пользователю точнее оценить выбор.

- `fontchooser` — диалог выбора шрифта.
- `text` — текст предпросмотра.

```nim
gtk_font_chooser_set_preview_text(fontDialog, "def hello(): print(\"Привет, мир!\")")
echo "Предпросмотр шрифта теперь показывает пример кода вместо стандартной фразы"
```

---

## GtkGLArea

`GtkGLArea` — область для рендеринга через OpenGL, аналог `GtkDrawingArea`, но вместо контекста Cairo предоставляет активный контекст OpenGL для прямых вызовов `gl*`-функций (сама привязка к OpenGL API не входит в эту обёртку).

### `gtk_gl_area_new`

```nim
proc gtk_gl_area_new*(): GtkGLArea
```

**Что делает.** Создаёт пустую область рендеринга OpenGL. Для реальной отрисовки требуется подключить обработчик сигнала `"render"` (эмитируется при каждой необходимости перерисовки).

- Параметров нет.

```nim
let glCanvas = gtk_gl_area_new()
echo "Область рендеринга OpenGL создана"
```

---

### `gtk_gl_area_make_current` / `gtk_gl_area_queue_render` / `gtk_gl_area_attach_buffers`

```nim
proc gtk_gl_area_make_current*(area: GtkGLArea)
proc gtk_gl_area_queue_render*(area: GtkGLArea)
proc gtk_gl_area_attach_buffers*(area: GtkGLArea)
```

**Что делает.** `make_current` делает OpenGL-контекст этой области активным для последующих вызовов OpenGL-функций текущим потоком. `queue_render` запрашивает перерисовку на следующей итерации главного цикла — аналог `gtk_widget_queue_draw`. `attach_buffers` привязывает framebuffer-объекты OpenGL к области — обычно вызывается автоматически перед `"render"`.

- `area` — область рендеринга OpenGL.

```nim
gtk_gl_area_make_current(glCanvas)
gtk_gl_area_queue_render(glCanvas)
echo "Контекст OpenGL активирован, запрошена перерисовка"
```

---

### `gtk_gl_area_set/get_required_version`

```nim
proc gtk_gl_area_set_required_version*(area: GtkGLArea, major: gint, minor: gint)
proc gtk_gl_area_get_required_version*(area: GtkGLArea, major: ptr gint, minor: ptr gint)
```

**Что делает.** Задают минимально требуемую версию OpenGL — если система не может предоставить контекст запрошенной версии, `GtkGLArea` сообщит об ошибке вместо того, чтобы молча предоставить несовместимую версию.

- `area` — область рендеринга.
- `major`, `minor` — компоненты требуемой версии.

```nim
gtk_gl_area_set_required_version(glCanvas, 3, 3)
echo "Требуется OpenGL версии не ниже 3.3"
```

---

### `gtk_gl_area_set/get_has_depth_buffer`, `set/get_has_stencil_buffer`

```nim
proc gtk_gl_area_set_has_depth_buffer*(area: GtkGLArea, hasDepthBuffer: gboolean)
proc gtk_gl_area_get_has_depth_buffer*(area: GtkGLArea): gboolean
proc gtk_gl_area_set_has_stencil_buffer*(area: GtkGLArea, hasStencilBuffer: gboolean)
proc gtk_gl_area_get_has_stencil_buffer*(area: GtkGLArea): gboolean
```

**Что делает.** Включают/выключают буфер глубины (для корректного перекрытия 3D-объектов) и буфер трафарета (для техник маскирования) — оба выключены по умолчанию.

- `area` — область рендеринга.
- `hasDepthBuffer`, `hasStencilBuffer` — `1.gboolean` для включения.

```nim
gtk_gl_area_set_has_depth_buffer(glCanvas, 1.gboolean)
echo "Буфер глубины включён для корректного отображения 3D-объектов"
```

---

## Буфер обмена: GdkClipboard

`GdkClipboard` — системный буфер обмена (тот же, что используется штатными "Копировать"/"Вставить" в текстовых полях предыдущих справочников), доступный и для программного использования — например, кнопки "Копировать ссылку" рядом с полем, не являющимся текстовым вводом. В этой обёртке доступна работа с текстом; полноценный буфер обмена GTK4 поддерживает и произвольные типы данных (изображения и т.д.) через более широкий API, не входящий в этот минимальный набор.

### `gdk_display_get_clipboard`

```nim
proc gdk_display_get_clipboard*(display: pointer): GdkClipboard
```

**Что делает.** Возвращает объект системного буфера обмена для указанного дисплея (тот же `GdkDisplay`, что и в `gtk_style_context_add_provider_for_display` из справочника по рисованию и GLib-утилитам) — общий один на весь дисплей, а не отдельный на каждое окно. Дисплей обычно получают через `gtk_widget_get_display` для конкретного виджета либо `gdk_display_get_default()`.

- `display` — объект дисплея (`GdkDisplay`, приводится к `pointer`).

```nim
let clipboard = gdk_display_get_clipboard(gdk_display_get_default())
echo "Объект системного буфера обмена получен"
```

---

### `gdk_clipboard_set_text`

```nim
proc gdk_clipboard_set_text*(clipboard: GdkClipboard, text: cstring)
```

**Что делает.** Копирует строку текста в буфер обмена — программный аналог `Ctrl+C` для произвольного текста, не обязательно выделенного в текстовом поле (например, скопировать ссылку по клику на кнопку "Поделиться").

- `clipboard` — объект буфера обмена.
- `text` — копируемый текст.

```nim
gdk_clipboard_set_text(clipboard, "https://example.com/shared-link")
echo "Ссылка скопирована в буфер обмена"
```

---

### `gdk_clipboard_read_text_async` / `gdk_clipboard_read_text_finish`

```nim
proc gdk_clipboard_read_text_async*(clipboard: GdkClipboard, cancellable: pointer, callback: GAsyncReadyCallback, userData: gpointer)
proc gdk_clipboard_read_text_finish*(clipboard: GdkClipboard, res: pointer, error: ptr GError): cstring
```

**Что делает.** Асинхронно читают текст из буфера обмена — чтение обязательно асинхронное (в отличие от `set_text`, работающего синхронно), поскольку в общем случае содержимое буфера обмена может принадлежать другому процессу и его получение требует межпроцессного взаимодействия, которое не должно блокировать интерфейс. `read_text_async` запускает операцию и сразу возвращает управление; когда результат готов, вызывается `callback` (стандартный шаблон `GAsyncReadyCallback` из GIO), внутри которого нужно вызвать `read_text_finish`, чтобы получить итоговую строку (или ошибку через `error`, если чтение не удалось — например, в буфере обмена не оказалось текста).

- `clipboard` — объект буфера обмена.
- `cancellable` — объект отмены операции (можно передать `nil`).
- `callback` — функция обратного вызова, вызываемая по завершении чтения.
- `userData` — пользовательские данные, передаваемые в `callback`.
- `res` (для `finish`) — объект результата асинхронной операции, полученный в `callback`.
- `error` (для `finish`) — указатель для получения ошибки.

```nim
proc onClipboardReadReady(sourceObject: pointer, res: pointer, userData: gpointer) {.cdecl.} =
  var err: ptr GError = nil
  let text = gdk_clipboard_read_text_finish(cast[GdkClipboard](sourceObject), res, addr err)
  if isNil(err):
    echo "Из буфера обмена прочитан текст: ", $text
  else:
    echo "Не удалось прочитать текст из буфера обмена"
    g_error_free(err[])

gdk_clipboard_read_text_async(clipboard, nil, onClipboardReadReady, nil)
echo "Асинхронное чтение буфера обмена запущено"
```

---

## GdkPixbuf

`GdkPixbuf` — растровое изображение в памяти, ориентированное на программную обработку пикселей (CPU-side): загрузка из файла, масштабирование, сохранение обратно в файл. Для показа изображения на экране без дополнительной обработки чаще используется `GdkTexture` (раздел VII) — либо напрямую, либо преобразованный из `GdkPixbuf` через `gdk_texture_new_for_pixbuf`.

### `gdk_pixbuf_new` / `gdk_pixbuf_new_from_file`

```nim
proc gdk_pixbuf_new*(colorspace: gint, hasAlpha: gboolean, bitsPerSample: gint, width: gint, height: gint): GdkPixbuf
proc gdk_pixbuf_new_from_file*(filename: cstring, error: ptr GError): GdkPixbuf
```

**Что делает.** `gdk_pixbuf_new` создаёт пустое изображение заданного размера в памяти, заполненное неопределёнными данными (для последующего программного заполнения пикселей — доступ к самому буферу пикселей требует дополнительных функций, не входящих в этот справочник). `colorspace` — цветовое пространство (практически всегда единственное поддерживаемое значение `GDK_COLORSPACE_RGB`, равное `0`). `bitsPerSample` — почти всегда `8` (стандартные 8 бит на канал). `gdk_pixbuf_new_from_file` — гораздо более частый способ получить `GdkPixbuf`: синхронная загрузка и декодирование изображения из файла на диске.

- `colorspace` — цветовое пространство (обычно `0` для RGB).
- `hasAlpha` — `1.gboolean`, если изображение должно иметь альфа-канал.
- `bitsPerSample` — бит на канал (обычно `8`).
- `width`, `height` — размер изображения в пикселях.
- `filename` — путь к файлу изображения (для `new_from_file`).
- `error` — указатель для получения ошибки (можно передать `nil`).

```nim
var err: ptr GError = nil
let photo = gdk_pixbuf_new_from_file("/home/user/Pictures/photo.jpg", addr err)
if isNil(err):
  echo "Изображение загружено и декодировано в память"
else:
  echo "Не удалось загрузить изображение"
  g_error_free(err[])
```

---

### `gdk_pixbuf_get_width` / `gdk_pixbuf_get_height`

```nim
proc gdk_pixbuf_get_width*(pixbuf: GdkPixbuf): gint
proc gdk_pixbuf_get_height*(pixbuf: GdkPixbuf): gint
```

**Что делает.** Возвращают фактический размер изображения в пикселях — например, чтобы вычислить пропорциональный размер для последующего масштабирования через `gdk_pixbuf_scale_simple`.

- `pixbuf` — изображение.

```nim
echo "Размер загруженной фотографии: ", gdk_pixbuf_get_width(photo), "×", gdk_pixbuf_get_height(photo)
```

---

### `gdk_pixbuf_scale_simple`

```nim
proc gdk_pixbuf_scale_simple*(src: GdkPixbuf, destWidth: gint, destHeight: gint, interpType: gint): GdkPixbuf
```

**Что делает.** Создаёт **новое** изображение — масштабированную копию исходного до указанного размера (исходное изображение не изменяется). `interpType` — метод интерполяции при масштабировании (значения `GDK_INTERP_*`, не заведённые в этой обёртке отдельным enum-типом — на практике `GDK_INTERP_BILINEAR`, равное `2`, даёт хороший баланс качества и скорости для большинства случаев; `GDK_INTERP_NEAREST` = `0` быстрее, но даёт зубчатый результат).

- `src` — исходное изображение.
- `destWidth`, `destHeight` — размер результата в пикселях.
- `interpType` — метод интерполяции.

```nim
let thumbnail = gdk_pixbuf_scale_simple(photo, 128, 128, 2)  # 2 = GDK_INTERP_BILINEAR
echo "Миниатюра 128×128 создана из полноразмерной фотографии"
```

---

### `gdk_pixbuf_savev`

```nim
proc gdk_pixbuf_savev*(pixbuf: GdkPixbuf, filename: cstring, `type`: cstring, optionKeys: ptr cstring, optionValues: ptr cstring, error: ptr GError): gboolean
```

**Что делает.** Сохраняет изображение в файл в указанном формате. `type` — строковый идентификатор формата (`"png"`, `"jpeg"`, `"bmp"` и т.п.). `optionKeys`/`optionValues` — два параллельных `NULL`-терминированных массива строк для специфичных для формата параметров сохранения (например, для JPEG — `"quality"` со значением `"90"`); если дополнительные параметры не нужны, оба массива могут состоять из одного `nil`.

- `pixbuf` — изображение.
- `filename` — путь для сохранения.
- `type` — строка формата.
- `optionKeys`, `optionValues` — параллельные массивы параметров формата, оба завершённые `nil`.
- `error` — указатель для получения ошибки.

```nim
var noOptions: array[1, cstring] = [cstring(nil)]
var err: ptr GError = nil
let saved = gdk_pixbuf_savev(thumbnail, "/home/user/.cache/myapp/thumb.png", "png",
                              addr noOptions[0], addr noOptions[0], addr err)
echo "Миниатюра сохранена: ", saved != 0.gboolean
```

---

### `gdk_pixbuf_new_from_stream` / `g_memory_input_stream_new_from_bytes`

```nim
proc gdk_pixbuf_new_from_stream*(stream: pointer, cancellable: pointer, error: ptr GError): GdkPixbuf
proc g_memory_input_stream_new_from_bytes*(bytes: GBytes): pointer
```

**Что делает.** `gdk_pixbuf_new_from_stream` декодирует изображение не из файла на диске, а из произвольного входного потока GIO (`GInputStream`) — например, данных, скачанных по сети или встроенных в бинарник приложения через GResource. `g_memory_input_stream_new_from_bytes` — способ получить такой поток из уже имеющихся в памяти байт (`GBytes`), если исходные данные изображения не связаны с файлом или сетевым соединением напрямую.

- `stream` — входной поток (`GInputStream`).
- `cancellable` — объект отмены (можно передать `nil`).
- `error` — указатель для получения ошибки.
- `bytes` — объект `GBytes` с данными изображения в памяти.

```nim
# imageBytes — GBytes с данными изображения, уже находящимися в памяти
# (например, встроенными в бинарник через GResource)
let stream = g_memory_input_stream_new_from_bytes(imageBytes)
var err: ptr GError = nil
let decodedImage = gdk_pixbuf_new_from_stream(stream, nil, addr err)
echo "Изображение декодировано из данных в памяти, без файла на диске"
```

---

### Пошаговая загрузка: `gdk_pixbuf_loader_new` и родственные

```nim
proc gdk_pixbuf_loader_new*(): pointer
proc gdk_pixbuf_loader_write*(loader: pointer, buf: ptr uint8, count: csize_t, error: ptr GError): gboolean
proc gdk_pixbuf_loader_close*(loader: pointer, error: ptr GError): gboolean
proc gdk_pixbuf_loader_get_pixbuf*(loader: pointer): GdkPixbuf
```

**Что делает.** `GdkPixbufLoader` декодирует изображение по частям, по мере того как байты становятся доступны, — например, при потоковой загрузке файла по сети, когда все данные сразу не находятся в памяти. `gdk_pixbuf_loader_new` создаёт загрузчик; `gdk_pixbuf_loader_write` скармливает ему очередную порцию байт (можно вызывать многократно по мере поступления данных); `gdk_pixbuf_loader_close` сообщает загрузчику, что данные закончились, и завершает декодирование; `gdk_pixbuf_loader_get_pixbuf` возвращает результирующее изображение — можно вызывать и до `close`, если формат поддерживает прогрессивную загрузку (тогда возвращает изображение в текущем, ещё неполном состоянии), но гарантированно полное изображение доступно только после `close`.

- `loader` — объект загрузчика.
- `buf` — указатель на буфер байт очередной порции данных.
- `count` — количество байт в `buf`.
- `error` — указатель для получения ошибки.

```nim
let loader = gdk_pixbuf_loader_new()
var err: ptr GError = nil
# chunk — очередная порция байт, полученная, например, из сетевого сокета
discard gdk_pixbuf_loader_write(loader, addr chunk[0], csize_t(chunk.len), addr err)
# ... повторные вызовы write по мере поступления следующих порций данных ...
discard gdk_pixbuf_loader_close(loader, addr err)
let streamedImage = gdk_pixbuf_loader_get_pixbuf(loader)
echo "Изображение полностью декодировано из потоковых данных"
```

---

## GdkTexture

`GdkTexture` — GPU-ориентированное представление изображения, оптимальное для показа на экране (реализует интерфейс `GdkPaintable`, тот же, что принимают `gtk_image_new_from_paintable`/`gtk_picture_set_paintable` из предыдущих справочников). В отличие от `GdkPixbuf`, не предназначен для программного изменения пикселей после создания — только для отображения.

### `gdk_texture_new_for_pixbuf`

```nim
proc gdk_texture_new_for_pixbuf*(pixbuf: GdkPixbuf): GdkTexture
```

**Что делает.** Преобразует уже загруженный/обработанный `GdkPixbuf` в `GdkTexture` для показа на экране — типичный завершающий шаг после программной обработки изображения (масштабирования, обрезки) через функции `GdkPixbuf` из раздела VI, перед передачей результата в `GtkPicture`/`GtkImage`.

- `pixbuf` — исходное изображение.

```nim
let texture = gdk_texture_new_for_pixbuf(thumbnail)
gtk_picture_set_paintable(thumbnailView, cast[pointer](texture))
echo "Обработанная миниатюра преобразована в текстуру и показана в GtkPicture"
```

---

### `gdk_texture_new_from_file` / `gdk_texture_new_from_filename`

```nim
proc gdk_texture_new_from_file*(file: GFile, error: ptr GError): GdkTexture
proc gdk_texture_new_from_filename*(filename: cstring, error: pointer): GdkTexture
```

**Что делает.** Загружают изображение напрямую в `GdkTexture`, минуя промежуточный `GdkPixbuf`, — короче и эффективнее, если изображение не требует программной обработки перед показом (просто отобразить файл как есть). `new_from_file` принимает объект `GFile`, `new_from_filename` — сразу строку пути.

- `file` — объект `GFile` (для `new_from_file`).
- `filename` — путь к файлу (для `new_from_filename`).
- `error` — указатель для получения ошибки.

```nim
var err: ptr GError = nil
let iconTexture = gdk_texture_new_from_filename("/usr/share/myapp/splash.png", addr err)
echo "Изображение заставки загружено напрямую в текстуру"
```

---

### `gdk_texture_get_width` / `gdk_texture_get_height`

```nim
proc gdk_texture_get_width*(texture: GdkTexture): gint
proc gdk_texture_get_height*(texture: GdkTexture): gint
```

**Что делает.** Возвращают размер текстуры в пикселях — та же логика, что у `gdk_pixbuf_get_width`/`get_height`, но для `GdkTexture`.

- `texture` — текстура.

```nim
echo "Размер загруженной текстуры: ", gdk_texture_get_width(iconTexture), "×", gdk_texture_get_height(iconTexture)
```

---

### `gdk_texture_new_from_bytes` / `g_bytes_new_static` / `g_bytes_unref`

```nim
proc gdk_texture_new_from_bytes*(bytes: GBytes, error: ptr GError): GdkTexture
proc g_bytes_new_static*(data: pointer, size: csize_t): GBytes
proc g_bytes_unref*(bytes: GBytes)
```

**Что делает.** `gdk_texture_new_from_bytes` создаёт текстуру напрямую из байт изображения в памяти (в закодированном виде — PNG/JPEG и т.п., как если бы это было содержимое файла, а не уже декодированные пиксели), не требуя промежуточного файла на диске. `g_bytes_new_static` оборачивает уже существующий в памяти регион байт (например, встроенный в бинарник ресурс) в объект `GBytes`, не копируя данные, — подходит только для данных, которые гарантированно останутся действительными на всё время жизни `GBytes` (например, статически слинкованных ресурсов), в отличие от временных буферов. `g_bytes_unref` освобождает `GBytes`, когда он больше не нужен, — как и большинство GObject-совместимых типов, `GBytes` управляется подсчётом ссылок (см. `g_object_unref` в справочнике по рисованию и GLib-утилитам, хотя формально `GBytes` — не `GObject`, а собственный refcounted-тип GLib с похожей моделью владения).

- `bytes` — объект `GBytes` с данными изображения.
- `data` — указатель на данные в памяти (для `new_static`).
- `size` — размер данных в байтах.

```nim
# embeddedIconData — статический массив байт, встроенный в бинарник приложения
let iconBytes = g_bytes_new_static(addr embeddedIconData[0], csize_t(embeddedIconData.len))
var err: ptr GError = nil
let embeddedTexture = gdk_texture_new_from_bytes(iconBytes, addr err)
g_bytes_unref(iconBytes)
echo "Текстура создана из встроенных в бинарник данных, без обращения к файловой системе"
```

---

## Практические рецепты

### Диалог "О программе" с полным набором сведений

Все основные поля заполнены одним заходом, показываются по клику на пункт меню приложения.

```nim
proc showAboutDialog(parent: GtkWindow) =
  let about = gtk_about_dialog_new()
  gtk_window_set_transient_for(about, parent)
  gtk_window_set_modal(about, 1.gboolean)

  gtk_about_dialog_set_program_name(about, "Редактор проекта")
  gtk_about_dialog_set_version(about, "1.3.0")
  gtk_about_dialog_set_copyright(about, "© 2026 Ваша компания")
  gtk_about_dialog_set_comments(about, "Простой редактор для быстрой работы с проектами")
  gtk_about_dialog_set_website(about, "https://example.com")
  gtk_about_dialog_set_website_label(about, "Сайт проекта")
  gtk_about_dialog_set_logo_icon_name(about, "accessories-text-editor")

  var authorsArray = [cstring("Иван Петров"), cstring("Анна Сидорова"), nil]
  gtk_about_dialog_set_authors(about, addr authorsArray[0])
  gtk_about_dialog_set_license(about, "Распространяется по лицензии MIT.")

  gtk_window_present(about)
  echo "Диалог 'О программе' со всеми сведениями показан"

# showAboutDialog(mainWindow)
```

---

### Кнопка выбора цвета акцента с диалогом

Кнопка, открывающая диалог выбора цвета и сохраняющая выбранное значение.

```nim
var selectedAccentColor: array[4, gdouble] = [0.2, 0.5, 0.9, 1.0]  # начальный синий цвет

proc onColorButtonClicked(button: GtkButton, userData: gpointer) {.cdecl.} =
  let dialog = gtk_color_chooser_dialog_new("Выберите цвет акцента", cast[GtkWindow](userData))
  gtk_color_chooser_set_rgba(dialog, addr selectedAccentColor[0])

  proc onResponse(d: GtkColorChooserDialog, responseId: gint, ud: gpointer) {.cdecl.} =
    if responseId == ord(GTK_RESPONSE_ACCEPT).gint:
      gtk_color_chooser_get_rgba(d, addr selectedAccentColor[0])
      echo "Новый цвет акцента сохранён"
    gtk_window_destroy(cast[GtkWindow](d))

  discard g_signal_connect(dialog, "response", onResponse, nil)
  gtk_window_present(dialog)

let colorButton = gtk_button_new_with_label("Цвет акцента...")
discard g_signal_connect(colorButton, "clicked", onColorButtonClicked, cast[gpointer](mainWindow))
```

---

### Копирование текста в буфер обмена и чтение из него

Кнопка "Копировать", и отдельная кнопка "Вставить", читающая содержимое буфера обмена асинхронно.

```nim
proc onCopyClicked(button: GtkButton, userData: gpointer) {.cdecl.} =
  let clipboard = gdk_display_get_clipboard(gdk_display_get_default())
  gdk_clipboard_set_text(clipboard, "Скопированный программно текст")
  echo "Текст скопирован в системный буфер обмена"

proc onClipboardReadReady(sourceObject: pointer, res: pointer, userData: gpointer) {.cdecl.} =
  var err: ptr GError = nil
  let text = gdk_clipboard_read_text_finish(cast[GdkClipboard](sourceObject), res, addr err)
  if isNil(err):
    echo "Вставлено из буфера обмена: ", $text
  else:
    g_error_free(err[])

proc onPasteClicked(button: GtkButton, userData: gpointer) {.cdecl.} =
  let clipboard = gdk_display_get_clipboard(gdk_display_get_default())
  gdk_clipboard_read_text_async(clipboard, nil, onClipboardReadReady, nil)
```

---

### Уменьшение изображения перед сохранением в миниатюру

Полная цепочка: загрузка полноразмерного изображения → масштабирование → сохранение в файл.

```nim
proc createThumbnail(sourcePath, thumbPath: string, size: int): bool =
  var err: ptr GError = nil
  let original = gdk_pixbuf_new_from_file(sourcePath.cstring, addr err)
  if not isNil(err):
    echo "Не удалось загрузить исходное изображение"
    g_error_free(err[])
    return false

  let thumbnail = gdk_pixbuf_scale_simple(original, size.gint, size.gint, 2)  # 2 = GDK_INTERP_BILINEAR

  var noOptions: array[1, cstring] = [cstring(nil)]
  var saveErr: ptr GError = nil
  result = gdk_pixbuf_savev(thumbnail, thumbPath.cstring, "png",
                            addr noOptions[0], addr noOptions[0], addr saveErr) != 0.gboolean
  if result:
    echo "Миниатюра ", size, "×", size, " сохранена в ", thumbPath
  else:
    g_error_free(saveErr[])

discard createThumbnail("/home/user/Pictures/photo.jpg", "/home/user/.cache/myapp/thumb.png", 128)
```

---

### Пошаговая загрузка изображения из потока данных, приходящих частями

Декодирование изображения по мере поступления сетевых данных, без ожидания полной загрузки в память заранее.

```nim
proc buildStreamingImageLoader(): pointer =
  result = gdk_pixbuf_loader_new()
  echo "Загрузчик изображения создан, готов принимать порции данных"

proc feedChunk(loader: pointer, chunk: seq[uint8]) =
  var err: ptr GError = nil
  discard gdk_pixbuf_loader_write(loader, unsafeAddr chunk[0], csize_t(chunk.len), addr err)
  if not isNil(err):
    echo "Ошибка при декодировании очередной порции данных"
    g_error_free(err[])

proc finishStreamingLoad(loader: pointer): GdkPixbuf =
  var err: ptr GError = nil
  discard gdk_pixbuf_loader_close(loader, addr err)
  result = gdk_pixbuf_loader_get_pixbuf(loader)
  echo "Загрузка завершена, итоговое изображение получено"

let loader = buildStreamingImageLoader()
# feedChunk(loader, receivedNetworkChunk) — вызывается по мере поступления данных из сети
# let finalImage = finishStreamingLoad(loader) — после того как все данные получены
```

---

## Краткая таблица

| Процедура(ы) | Категория | Что делает вкратце |
|---|---|---|
| `gtk_about_dialog_new` | AboutDialog | Создать диалог "О программе" |
| `gtk_about_dialog_set/get_program_name`, `version`, `copyright`, `comments` | AboutDialog | Основные текстовые поля |
| `gtk_about_dialog_set/get_license` | AboutDialog | Полный текст лицензии |
| `gtk_about_dialog_set/get_website`, `website_label` | AboutDialog | Ссылка на сайт проекта |
| `gtk_about_dialog_set/get_authors` | AboutDialog | Список авторов (NULL-терминированный массив) |
| `gtk_about_dialog_set/get_logo`, `logo_icon_name` | AboutDialog | Логотип — изображением или иконкой темы |
| `gtk_color_chooser_dialog_new` | ColorChooserDialog | Создать диалог выбора цвета |
| `gtk_color_chooser_get/set_rgba` | ColorChooserDialog | Текущий цвет через GdkRGBA |
| `gtk_color_chooser_set/get_use_alpha` | ColorChooserDialog | Разрешить настройку прозрачности |
| `gtk_font_chooser_dialog_new` | FontChooserDialog | Создать диалог выбора шрифта |
| `gtk_font_chooser_get/set_font` | FontChooserDialog | Шрифт строкой Pango-описания |
| `gtk_font_chooser_get/set_font_desc` | FontChooserDialog | Шрифт структурированным PangoFontDescription |
| `gtk_font_chooser_get/set_preview_text` | FontChooserDialog | Текст предпросмотра шрифта |
| `gtk_gl_area_new` | GLArea | Создать область рендеринга OpenGL |
| `gtk_gl_area_make_current`, `queue_render`, `attach_buffers` | GLArea | Управление контекстом и перерисовкой |
| `gtk_gl_area_set/get_required_version` | GLArea | Минимальная требуемая версия OpenGL |
| `gtk_gl_area_set/get_has_depth/stencil_buffer` | GLArea | Буферы глубины и трафарета |
| `gdk_display_get_clipboard` | Clipboard | Получить объект буфера обмена дисплея |
| `gdk_clipboard_set_text` | Clipboard | Скопировать текст программно |
| `gdk_clipboard_read_text_async/finish` | Clipboard | Асинхронно прочитать текст из буфера |
| `gdk_pixbuf_new`, `new_from_file` | Pixbuf | Создать пустое / загрузить из файла |
| `gdk_pixbuf_get_width/height` | Pixbuf | Размер изображения |
| `gdk_pixbuf_scale_simple` | Pixbuf | Масштабированная копия изображения |
| `gdk_pixbuf_savev` | Pixbuf | Сохранить изображение в файл |
| `gdk_pixbuf_new_from_stream`, `g_memory_input_stream_new_from_bytes` | Pixbuf | Декодирование из потока/памяти |
| `gdk_pixbuf_loader_new`, `write`, `close`, `get_pixbuf` | Pixbuf | Пошаговая (потоковая) загрузка |
| `gdk_texture_new_for_pixbuf` | Texture | Преобразовать GdkPixbuf в текстуру |
| `gdk_texture_new_from_file/filename` | Texture | Загрузить изображение напрямую в текстуру |
| `gdk_texture_get_width/height` | Texture | Размер текстуры |
| `gdk_texture_new_from_bytes`, `g_bytes_new_static/unref` | Texture | Текстура из байт в памяти |

---

## Сводка: какую процедуру выбрать

- **Показать изображение на экране без программной обработки** → `GdkTexture` напрямую (`gdk_texture_new_from_file`/`_from_filename`), а не `GdkPixbuf` — короче и эффективнее, поскольку `GdkTexture` уже оптимизирован под отображение.
- **Изображение нужно сначала обработать** (масштабировать, обрезать, сохранить в другом формате) → `GdkPixbuf`, и только по завершении обработки — преобразование в `GdkTexture` через `gdk_texture_new_for_pixbuf` для показа результата.
- **Данные изображения приходят по частям** (сеть, поток) → `GdkPixbufLoader` (`gdk_pixbuf_loader_new`/`write`/`close`), а не ожидание полной загрузки всех байт в память перед декодированием.
- **Скопировать/вставить текст программно, не через выделение в текстовом поле** → `GdkClipboard` (`gdk_clipboard_set_text`/`read_text_async`), а не пытаться эмулировать `Ctrl+C`/`Ctrl+V` через синтетические события клавиатуры.
- **Диалог выбора цвета/шрифта** → готовые `GtkColorChooserDialog`/`GtkFontChooserDialog`, а не собственный `GtkDialog` с самодельным виджетом выбора — системные диалоги уже дают знакомый пользователю интерфейс и живой предпросмотр.
- **Работа со шрифтом только на уровне "выбрать и применить"** → строковый `gtk_font_chooser_get/set_font` (формат Pango). **Программный разбор отдельных компонентов шрифта** (семейство отдельно от размера) → структурированный `get/set_font_desc`.
- **3D-графика или сложный кастомный рендеринг, для которого Cairo (GtkDrawingArea) недостаточно производителен** → `GtkGLArea` с прямыми вызовами OpenGL, с обязательной проверкой `set_required_version` под нужды используемого шейдерного кода.
