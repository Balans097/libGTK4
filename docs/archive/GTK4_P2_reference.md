# Справочник функций GTK4 — libGTK4_p2.nim

> Документация по файлу `libGTK4_p2.nim` — второй части Nim-обёртки над библиотекой GTK4.  
> Файл содержит объявления функций GTK/GDK/GIO, высокоуровневые вспомогательные процедуры, утилиты для работы с виджетами, а также современные GTK4-виджеты для списков, видео и снапшотов.

---

## Содержание

1. [Высокоуровневые фабричные функции (create*)](#1-высокоуровневые-фабричные-функции-create)
2. [Хелперы для виджетов](#2-хелперы-для-виджетов)
3. [Хелперы для контейнеров](#3-хелперы-для-контейнеров)
4. [Диалоги (высокоуровневые)](#4-диалоги-высокоуровневые)
5. [CSS и стилизация](#5-css-и-стилизация)
6. [Изображения (GtkImage)](#6-изображения-gtkimage)
7. [Окна (GtkWindow)](#7-окна-gtkwindow)
8. [GtkPicture](#8-gtkpicture)
9. [FlowBox](#9-flowbox)
10. [Viewport](#10-viewport)
11. [About Dialog](#11-about-dialog)
12. [Color Chooser Dialog](#12-color-chooser-dialog)
13. [Font Chooser Dialog](#13-font-chooser-dialog)
14. [GL Area (OpenGL)](#14-gl-area-opengl)
15. [Clipboard (GDK)](#15-clipboard-gdk)
16. [Pixbuf (GdkPixbuf)](#16-pixbuf-gdkpixbuf)
17. [Texture (GdkTexture)](#17-texture-gdktexture)
18. [GLib — утилиты памяти и строк](#18-glib--утилиты-памяти-и-строк)
19. [Таймеры и Main Loop](#19-таймеры-и-main-loop)
20. [TreeModel / ListStore / TreeStore (устаревшие)](#20-treemodel--liststore--treestore-устаревшие)
21. [TreeView и TreeViewColumn (устаревшие)](#21-treeview-и-treeviewcolumn-устаревшие)
22. [TreeSelection и TreePath / TreeModel](#22-treeselection-и-treepath--treemodel)
23. [RadioButton](#23-radiobutton)
24. [ScaleButton и VolumeButton](#24-scalebutton-и-volumebutton)
25. [LockButton](#25-lockbutton)
26. [TextTag и TextTagTable](#26-texttag-и-texttagtable)
27. [TextMark](#27-textmark)
28. [TextIter — навигация по тексту](#28-textiter--навигация-по-тексту)
29. [TextBuffer (дополнительные функции)](#29-textbuffer-дополнительные-функции)
30. [Editable](#30-editable)
31. [PopoverMenu и GMenu](#31-popovermenu-и-gmenu)
32. [Revealer](#32-revealer)
33. [Gesture & Event Controllers](#33-gesture--event-controllers)
34. [Drag and Drop](#34-drag-and-drop)
35. [Shortcuts](#35-shortcuts)
36. [Constraint Layout](#36-constraint-layout)
37. [WindowGroup](#37-windowgroup)
38. [Native Dialog и Alert Dialog](#38-native-dialog-и-alert-dialog)
39. [Print Operation](#39-print-operation)
40. [Builder (GTK XML)](#40-builder-gtk-xml)
41. [GtkSettings](#41-gtksettings)
42. [SizeGroup](#42-sizegroup)
43. [GDK KeyVal](#43-gdk-keyval)
44. [GIO — файловые операции](#44-gio--файловые-операции)
45. [Tooltip](#45-tooltip)
46. [Selection Model (GTK4)](#46-selection-model-gtk4)
47. [ListView и ColumnView (GTK4)](#47-listview-и-columnview-gtk4)
48. [GridView](#48-gridview)
49. [DropDown](#49-dropdown)
50. [StringList](#50-stringlist)
51. [WindowControls / WindowHandle / CenterBox](#51-windowcontrols--windowhandle--centerbox)
52. [Inscription (GTK 4.8+)](#52-inscription-gtk-48)
53. [Video / MediaStream / MediaFile](#53-video--mediastream--mediafile)
54. [MediaControls](#54-mediacontrols)
55. [Snapshot (Drawing API)](#55-snapshot-drawing-api)
56. [GdkRGBA — цвет](#56-gdkrgba--цвет)
57. [GList / GSList](#57-glist--gslist)
58. [Вспомогательные шаблоны и утилиты](#58-вспомогательные-шаблоны-и-утилиты)
59. [Работа со строками](#59-работа-со-строками)
60. [Сигналы — удобные обёртки](#60-сигналы--удобные-обёртки)
61. [Работа с boolean](#61-работа-с-boolean)
62. [Виджет-утилиты (отступы, выравнивание, размер)](#62-виджет-утилиты-отступы-выравнивание-размер)
63. [Дополнительные GTK-виджеты](#63-дополнительные-gtk-виджеты)

---

## 1. Высокоуровневые фабричные функции (create*)

Все функции ниже — это Nim-обёртки, упрощающие создание типовых виджетов за один вызов.

---

### `createButton(label, onClick, data): GtkButton`

**Что делает:** Создаёт кнопку с текстом и, по желанию, сразу подключает к ней обработчик нажатия.

**Когда использовать:** В большинстве случаев, когда нужна обычная кнопка с надписью.

**Результат:** `GtkButton`.

**Пример:**
```nim
proc onClickHandler(w: GtkWidget, data: pointer) {.cdecl.} =
  echo "Нажато!"

let btn = createButton("Нажми меня", cast[GCallback](onClickHandler))
```

---

### `createLabel(text, markup): GtkLabel`

**Что делает:** Создаёт метку. При `markup = true` активирует поддержку Pango-разметки (`<b>`, `<i>`, цвета и т.д.).

**Когда использовать:** Для отображения любого неизменяемого текста — заголовков, подсказок, описаний.

**Результат:** `GtkLabel`.

**Пример:**
```nim
let plain = createLabel("Обычный текст")
let bold  = createLabel("<b>Жирный</b>", markup = true)
```

---

### `createEntry(placeholder, maxLength): GtkEntry`

**Что делает:** Создаёт однострочное текстовое поле. Поддерживает placeholder и ограничение длины.

**Когда использовать:** Для ввода имени, адреса, поискового запроса и любого одностроченного текста.

**Результат:** `GtkEntry`.

**Пример:**
```nim
let nameField = createEntry("Введите имя", 64)
```

---

### `createPasswordEntry(placeholder): GtkPasswordEntry`

**Что делает:** Создаёт поле ввода пароля (скрывает вводимые символы).

**Когда использовать:** Для форм авторизации, смены пароля, PIN-кодов.

**Результат:** `GtkPasswordEntry`.

**Пример:**
```nim
let pwd = createPasswordEntry("Пароль")
```

---

### `createCheckButton(label, active): GtkCheckButton`

**Что делает:** Создаёт чекбокс с подписью и устанавливает его начальное состояние.

**Когда использовать:** Для опций «да/нет», согласия с условиями, фильтров.

**Результат:** `GtkCheckButton`.

**Пример:**
```nim
let agree = createCheckButton("Принимаю условия", active = false)
```

---

### `createSwitch(active): GtkSwitch`

**Что делает:** Создаёт переключатель on/off. Аналог чекбокса, но визуально в стиле тумблера.

**Когда использовать:** Для включения/отключения функций в настройках приложения.

**Результат:** `GtkSwitch`.

**Пример:**
```nim
let darkMode = createSwitch(active = false)
```

---

### `createSpinButton(min, max, step, value, digits): GtkSpinButton`

**Что делает:** Создаёт числовой счётчик с диапазоном, шагом и начальным значением. `digits` — количество знаков после запятой.

**Когда использовать:** Для выбора числовых значений — размера шрифта, количества копий, возраста.

**Результат:** `GtkSpinButton`.

**Пример:**
```nim
let fontSizeSpin = createSpinButton(6.0, 72.0, 1.0, value = 12.0, digits = 0)
```

---

### `createScale(min, max, step, value, orientation): GtkScale`

**Что делает:** Создаёт ползунок с диапазоном значений. Ориентация по умолчанию — горизонтальная.

**Когда использовать:** Для регулировки громкости, яркости, прозрачности или любого непрерывного параметра.

**Результат:** `GtkScale`.

**Пример:**
```nim
let volume = createScale(0.0, 100.0, 1.0, value = 50.0)
let vertical = createScale(0.0, 1.0, 0.01, orientation = GTK_ORIENTATION_VERTICAL)
```

---

### `createProgressBar(fraction, showText): GtkProgressBar`

**Что делает:** Создаёт полосу прогресса. `fraction` — заполненность от 0.0 до 1.0. При `showText = true` отображает процент.

**Когда использовать:** Для индикации хода загрузки, копирования файлов, длительных операций.

**Результат:** `GtkProgressBar`.

**Пример:**
```nim
let bar = createProgressBar(0.0, showText = true)
gtk_progress_bar_set_fraction(bar, 0.75)  # 75%
```

---

## 2. Хелперы для виджетов

### `setMargins(widget, top, right, bottom, left: int)`

**Что делает:** Устанавливает внешние отступы виджета со всех четырёх сторон.

**Когда использовать:** При размещении виджетов в контейнерах, когда нужно задать точные отступы.

**Результат:** Нет. Изменяет свойства `margin-top/end/bottom/start`.

**Пример:**
```nim
setMargins(button, 8, 12, 8, 12)  # top right bottom left
```

---

### `setMargins(widget, all: int)`

**Что делает:** Устанавливает одинаковый отступ со всех сторон.

**Пример:**
```nim
setMargins(label, 10)  # 10px со всех сторон
```

---

### `setSizeHints(widget, width, height: int)`

**Что делает:** Задаёт минимальный запрошенный размер виджета. `-1` означает «без ограничения».

**Когда использовать:** Для задания фиксированного или минимального размера кнопок, полей ввода, панелей.

**Пример:**
```nim
setSizeHints(button, 120, 36)
setSizeHints(panel, 200, -1)  # только минимальная ширина
```

---

### `setExpand(widget, horizontal, vertical: bool)`

**Что делает:** Управляет расширением виджета в контейнере по горизонтали и/или вертикали.

**Когда использовать:** Когда виджет должен заполнять доступное пространство в Box или Grid.

**Пример:**
```nim
setExpand(textView, true, true)   # растягивается во все стороны
setExpand(statusBar, true, false) # только по ширине
```

---

### `setAlign(widget, halign, valign: GtkAlign)`

**Что делает:** Устанавливает выравнивание виджета внутри ячейки контейнера по горизонтали и вертикали.

**Когда использовать:** Для центрирования, выравнивания по краям виджетов в Grid и Box.

**Пример:**
```nim
setAlign(icon, GTK_ALIGN_CENTER, GTK_ALIGN_CENTER)
setAlign(label, GTK_ALIGN_START, GTK_ALIGN_BASELINE)
```

---

### `addCssClass(widget, classes: varargs[string])`

**Что делает:** Добавляет одновременно несколько CSS-классов к виджету.

**Когда использовать:** Для применения нескольких стилей: `"suggested-action"`, `"destructive-action"`, кастомных классов.

**Пример:**
```nim
addCssClass(saveBtn, "suggested-action", "large-button")
```

---

### `removeCssClass(widget, classes: varargs[string])`

**Что делает:** Удаляет несколько CSS-классов одновременно.

**Когда использовать:** При динамическом переключении состояний виджета (активный/неактивный, ошибка/норма).

**Пример:**
```nim
removeCssClass(field, "error", "warning")
```

---

## 3. Хелперы для контейнеров

### `addChildren(box: GtkBox, children: varargs[GtkWidget])`

**Что делает:** Добавляет несколько виджетов в Box за один вызов.

**Когда использовать:** При построении панелей инструментов, строк с несколькими элементами.

**Пример:**
```nim
let hbox = createHBox(spacing = 6)
addChildren(hbox, iconWidget, labelWidget, buttonWidget)
```

---

### `packStart(box, child, expand)` / `packEnd(box, child, expand)`

**Что делает:** GTK3-совместимые функции для добавления виджета в начало или конец Box. При `expand = true` виджет получает `hexpand`/`vexpand`.

**Когда использовать:** При переносе кода с GTK3 на GTK4 или для простого управления расположением.

**Пример:**
```nim
packStart(toolbar, backButton)
packEnd(toolbar, menuButton, expand = false)
```

---

### `attachGrid(grid, child, x, y, width, height)`

**Что делает:** Упрощённая вставка виджета в ячейку Grid с указанием позиции и охватываемых колонок/строк.

**Когда использовать:** При построении форм и таблиц с фиксированной структурой.

**Пример:**
```nim
let grid = createGrid(rowSpacing = 8, columnSpacing = 6)
attachGrid(grid, nameLabel, 0, 0)
attachGrid(grid, nameEntry, 1, 0, width = 2)
```

---

### `createHBox(spacing, homogeneous): GtkBox`

**Что делает:** Создаёт горизонтальный контейнер Box. `spacing` — отступ между дочерними элементами, `homogeneous` — одинаковый размер для всех.

**Пример:**
```nim
let row = createHBox(spacing = 8)
```

---

### `createVBox(spacing, homogeneous): GtkBox`

**Что делает:** Создаёт вертикальный контейнер Box.

**Пример:**
```nim
let column = createVBox(spacing = 4, homogeneous = false)
```

---

### `createGrid(rowSpacing, columnSpacing, homogeneous): GtkGrid`

**Что делает:** Создаёт сетку с настройкой отступов между строками/колонками.

**Пример:**
```nim
let form = createGrid(rowSpacing = 10, columnSpacing = 8)
```

---

### `createScrolledWindow(child, hpolicy, vpolicy): GtkScrolledWindow`

**Что делает:** Создаёт контейнер с полосами прокрутки. Если передан дочерний виджет — сразу добавляет его.

**Когда использовать:** Для текстовых редакторов, длинных списков, изображений большого размера.

**Пример:**
```nim
let scr = createScrolledWindow(textView, GTK_POLICY_AUTOMATIC, GTK_POLICY_ALWAYS)
```

---

### `createFrame(label, child): GtkFrame`

**Что делает:** Создаёт рамку с необязательным заголовком. Если задан дочерний виджет — вставляет его.

**Пример:**
```nim
let frame = createFrame("Настройки сети", networkWidget)
```

---

### `createNotebook(): GtkNotebook` и `addTab(notebook, child, label): int`

**Что делает:** `createNotebook` — создаёт виджет вкладок. `addTab` — добавляет страницу с текстовым заголовком.

**Результат:** `addTab` возвращает индекс добавленной страницы.

**Пример:**
```nim
let nb = createNotebook()
discard addTab(nb, generalPage, "Основные")
discard addTab(nb, advancedPage, "Дополнительно")
```

---

### `createPaned(orientation): GtkPaned`

**Что делает:** Создаёт разделённую панель с перетаскиваемым разделителем.

**Когда использовать:** Для разделения рабочей области на части (панель файлов + редактор, список + детали).

**Пример:**
```nim
let paned = createPaned(GTK_ORIENTATION_HORIZONTAL)
gtk_paned_set_start_child(paned, filePanel)
gtk_paned_set_end_child(paned, editorPanel)
```

---

### `createStack(): GtkStack` и `addToStack(stack, child, name, title): GtkWidget`

**Что делает:** `createStack` — создаёт стек страниц с анимированными переходами. `addToStack` — добавляет страницу с именем и заголовком.

**Когда использовать:** Для реализации многоэкранного интерфейса без вкладок, мастеров (wizard), онбординга.

**Пример:**
```nim
let stack = createStack()
discard addToStack(stack, welcomePage, "welcome", "Добро пожаловать")
discard addToStack(stack, settingsPage, "settings", "Настройки")
gtk_stack_set_visible_child_name(stack, "welcome")
```

---

## 4. Диалоги (высокоуровневые)

### `showMessageDialog(parent, title, message, msgType)`

**Что делает:** Показывает модальный диалог с сообщением и кнопкой OK. Автоматически закрывается при нажатии.

**Когда использовать:** Для простых уведомлений, которые не требуют выбора пользователя.

**Пример:**
```nim
showMessageDialog(mainWindow, "Готово", "Файл успешно сохранён")
```

---

### `showErrorDialog(parent, title, message)`

**Что делает:** Диалог с иконкой ошибки (`GTK_MESSAGE_ERROR`). Обёртка над `showMessageDialog`.

**Пример:**
```nim
showErrorDialog(mainWindow, "Ошибка", "Не удалось открыть файл")
```

---

### `showWarningDialog(parent, title, message)`

**Что делает:** Диалог предупреждения (`GTK_MESSAGE_WARNING`).

**Пример:**
```nim
showWarningDialog(win, "Предупреждение", "Несохранённые изменения будут потеряны")
```

---

### `showInfoDialog(parent, title, message)`

**Что делает:** Информационный диалог (`GTK_MESSAGE_INFO`).

**Пример:**
```nim
showInfoDialog(win, "Информация", "Обновление установлено")
```

---

## 5. CSS и стилизация

### `loadCssFromString(css: string): GtkCssProvider`

**Что делает:** Создаёт CSS-провайдер из строки и немедленно применяет его глобально к дисплею с приоритетом `APPLICATION`.

**Когда использовать:** Для глобальной темизации приложения, встроенной прямо в исходный код.

**Пример:**
```nim
discard loadCssFromString("""
  .error-field { border-color: red; }
  button.large { font-size: 16px; padding: 8px 16px; }
""")
```

---

### `loadCssFromFile(filename: string): GtkCssProvider`

**Что делает:** Загружает CSS из внешнего файла и применяет глобально.

**Когда использовать:** Для разработки с выносом стилей в отдельный `.css`-файл, удобного редактирования без перекомпиляции.

**Пример:**
```nim
discard loadCssFromFile("styles/app.css")
```

---

### `applyCss(widget: GtkWidget, css: string)`

**Что делает:** Применяет CSS только к конкретному виджету (не глобально).

**Когда использовать:** Для локальной стилизации отдельных виджетов, не затрагивая весь интерфейс.

**Пример:**
```nim
applyCss(headerLabel, "label { font-size: 20px; font-weight: bold; }")
```

---

## 6. Изображения (GtkImage)

### `createImage(filename: string): GtkImage`

**Что делает:** Создаёт виджет изображения из файла на диске.

**Когда использовать:** Для отображения логотипов, аватаров, иллюстраций.

**Пример:**
```nim
let logo = createImage("assets/logo.png")
```

---

### `createImageFromIcon(iconName, size): GtkImage`

**Что делает:** Создаёт изображение из системной темы иконок по имени.

**Когда использовать:** Для кнопок с иконками, панелей инструментов. Иконки автоматически масштабируются под тему.

**Пример:**
```nim
let saveIcon = createImageFromIcon("document-save", 24)
let errorIcon = createImageFromIcon("dialog-error", 48)
```

---

### `setImageFromFile(image, filename)`

**Что делает:** Меняет изображение в существующем виджете `GtkImage` на другой файл.

**Когда использовать:** При динамическом обновлении изображений (смена аватара, превью).

**Пример:**
```nim
setImageFromFile(avatarImg, newAvatarPath)
```

---

## 7. Окна (GtkWindow)

### `createWindow(title, width, height): GtkWindow`

**Что делает:** Создаёт независимое окно верхнего уровня с заголовком и начальными размерами.

**Когда использовать:** Для вторичных окон: настройки, справка, дополнительные панели.

**Пример:**
```nim
let settingsWindow = createWindow("Настройки", 500, 400)
gtk_widget_set_visible(settingsWindow, TRUE)
```

---

### `createAppWindow(app, title, width, height): GtkWindow`

**Что делает:** Создаёт основное окно приложения, привязанное к `GtkApplication`. Правильно отслеживается GTK при подсчёте открытых окон.

**Когда использовать:** Как главное окно приложения в обработчике сигнала `activate`.

**Пример:**
```nim
proc onActivate(app: GtkApplication, data: pointer) {.cdecl.} =
  let win = createAppWindow(app, "Моё приложение", 800, 600)
  gtk_window_present(win)
```

---

## 8. GtkPicture

`GtkPicture` — современная замена `GtkImage` в GTK4. Поддерживает масштабирование с сохранением пропорций.

### `gtk_picture_new_for_filename(filename): GtkPicture`

**Что делает:** Создаёт `GtkPicture` из файла изображения.

**Когда использовать:** Для отображения крупных изображений с автоматическим масштабированием под доступное пространство.

**Пример:**
```nim
let pic = gtk_picture_new_for_filename("photo.jpg")
gtk_picture_set_can_shrink(pic, TRUE)
```

---

### `gtk_picture_set_can_shrink(picture, canShrink)`

**Что делает:** Разрешает (`TRUE`) или запрещает (`FALSE`) уменьшение изображения ниже его реального размера.

---

### `gtk_picture_set_paintable(picture, paintable)`

**Что делает:** Устанавливает источник изображения через интерфейс `GdkPaintable` — гибкий способ, поддерживающий анимации и кастомную отрисовку.

---

## 9. FlowBox

`GtkFlowBox` — контейнер, в котором дочерние виджеты автоматически переносятся на новую строку при нехватке места.

### `gtk_flow_box_new(): GtkFlowBox`

**Что делает:** Создаёт новый FlowBox.

**Когда использовать:** Для галерей изображений, наборов кнопок-фильтров, тегов, карточек.

**Пример:**
```nim
let gallery = gtk_flow_box_new()
gtk_flow_box_set_min_children_per_line(gallery, 2)
gtk_flow_box_set_max_children_per_line(gallery, 6)
gtk_flow_box_set_selection_mode(gallery, GTK_SELECTION_SINGLE)
for img in images:
  gtk_flow_box_append(gallery, img)
```

---

### `gtk_flow_box_set_homogeneous(box, homogeneous)`

**Что делает:** При `TRUE` все дочерние ячейки получают одинаковый размер.

---

### `gtk_flow_box_set_row_spacing` / `gtk_flow_box_set_column_spacing`

**Что делает:** Устанавливает отступы между строками и колонками элементов.

---

## 10. Viewport

### `gtk_viewport_new(hadjustment, vadjustment): GtkViewport`

**Что делает:** Создаёт порт просмотра для прокрутки виджетов, не поддерживающих прокрутку напрямую.

**Когда использовать:** Обычно используется автоматически внутри `GtkScrolledWindow`. Нужен напрямую для нестандартных сценариев прокрутки.

### `gtk_viewport_set_scroll_to_focus(viewport, scrollToFocus)`

**Что делает:** При `TRUE` окно прокрутки автоматически центрируется на виджете, получившем фокус.

---

## 11. About Dialog

### `gtk_about_dialog_new(): GtkAboutDialog`

**Что делает:** Создаёт стандартный диалог «О программе».

**Когда использовать:** В меню «Справка» → «О программе» для предоставления информации об авторах, версии, лицензии.

**Пример:**
```nim
let about = gtk_about_dialog_new()
gtk_about_dialog_set_program_name(about, "MyApp")
gtk_about_dialog_set_version(about, "1.0.0")
gtk_about_dialog_set_copyright(about, "© 2025 Автор")
gtk_about_dialog_set_website(about, "https://example.com")
gtk_window_present(cast[GtkWindow](about))
```

---

## 12. Color Chooser Dialog

### `gtk_color_chooser_dialog_new(title, parent): GtkColorChooserDialog`

**Что делает:** Открывает стандартный диалог выбора цвета.

**Когда использовать:** Для выбора цвета текста, фона, элементов оформления пользователем.

**Пример:**
```nim
let colorDlg = gtk_color_chooser_dialog_new("Выберите цвет", mainWindow)
# Подключить сигнал "response" для получения выбранного цвета
# gtk_color_chooser_get_rgba(colorDlg, addr chosenColor)
```

---

## 13. Font Chooser Dialog

### `gtk_font_chooser_dialog_new(title, parent): GtkFontChooserDialog`

**Что делает:** Открывает стандартный диалог выбора шрифта.

**Пример:**
```nim
let fontDlg = gtk_font_chooser_dialog_new("Выберите шрифт", mainWindow)
# После ответа пользователя:
# let fontName = gtk_font_chooser_get_font(fontDlg)
```

---

## 14. GL Area (OpenGL)

### `gtk_gl_area_new(): GtkGLArea`

**Что делает:** Создаёт виджет для OpenGL-рендеринга внутри GTK-окна.

**Когда использовать:** Для 3D-графики, игр, визуализации данных с GPU-ускорением.

**Пример:**
```nim
let glArea = gtk_gl_area_new()
gtk_gl_area_set_required_version(glArea, 3, 3)
gtk_gl_area_set_has_depth_buffer(glArea, TRUE)
discard g_signal_connect(glArea, "render", cast[GCallback](onRender), nil)
```

---

### `gtk_gl_area_make_current(area)` / `gtk_gl_area_queue_render(area)`

**Что делает:** `make_current` — активирует OpenGL-контекст виджета для последующих GL-вызовов. `queue_render` — запрашивает перерисовку кадра.

---

## 15. Clipboard (GDK)

### `gdk_display_get_clipboard(display): GdkClipboard`

**Что делает:** Возвращает объект буфера обмена для данного дисплея.

---

### `gdk_clipboard_set_text(clipboard, text)`

**Что делает:** Записывает текст в буфер обмена.

**Пример:**
```nim
let clipboard = gdk_display_get_clipboard(gdk_display_get_default())
gdk_clipboard_set_text(clipboard, "Текст для копирования")
```

---

### `gdk_clipboard_read_text_async(clipboard, cancellable, callback, userData)`

**Что делает:** Асинхронно читает текст из буфера обмена. Результат доступен через коллбэк.

---

### `gdk_clipboard_read_text_finish(clipboard, res, error): cstring`

**Что делает:** Завершает асинхронную операцию чтения и возвращает текст.

**Пример:**
```nim
proc onPaste(src: pointer, res: pointer, data: gpointer) {.cdecl.} =
  let clip = gdk_display_get_clipboard(gdk_display_get_default())
  let text = gdk_clipboard_read_text_finish(clip, res, nil)
  if text != nil: echo "Вставлено: ", $text

gdk_clipboard_read_text_async(clipboard, nil, onPaste, nil)
```

---

## 16. Pixbuf (GdkPixbuf)

### `gdk_pixbuf_new_from_file(filename, error): GdkPixbuf`

**Что делает:** Загружает изображение из файла в пиксельный буфер.

**Когда использовать:** Для загрузки изображений перед масштабированием, обработкой или отображением.

**Пример:**
```nim
var err: GError = nil
let pixbuf = gdk_pixbuf_new_from_file("image.png", addr err)
```

---

### `gdk_pixbuf_scale_simple(src, destWidth, destHeight, interpType): GdkPixbuf`

**Что делает:** Масштабирует пиксельный буфер до указанных размеров. `interpType` — алгоритм интерполяции (0=ближайший, 1=тайлы, 2=билинейный, 3=гиперколичество).

**Пример:**
```nim
let thumb = gdk_pixbuf_scale_simple(original, 128, 128, 2)  # билинейная
```

---

### `gdk_pixbuf_loader_new()` / `gdk_pixbuf_loader_write` / `gdk_pixbuf_loader_close` / `gdk_pixbuf_loader_get_pixbuf`

**Что делает:** Загрузчик изображений из памяти (байтового потока). Подходит для загрузки изображений из сети или встроенных ресурсов.

**Пример:**
```nim
let loader = gdk_pixbuf_loader_new()
discard gdk_pixbuf_loader_write(loader, addr data[0], data.len.csize_t, nil)
discard gdk_pixbuf_loader_close(loader, nil)
let pixbuf = gdk_pixbuf_loader_get_pixbuf(loader)
```

---

## 17. Texture (GdkTexture)

`GdkTexture` — это иммутабельное изображение GTK4, предназначенное для быстрого отображения через GPU.

### `gdk_texture_new_for_pixbuf(pixbuf): GdkTexture`

**Что делает:** Создаёт текстуру из `GdkPixbuf`.

### `gdk_texture_new_from_file(file, error): GdkTexture`

**Что делает:** Создаёт текстуру напрямую из файла.

### `gdk_texture_new_from_filename(filename, error): GdkTexture`

**Что делает:** Более простая версия — принимает строку пути вместо `GFile`.

**Пример:**
```nim
let texture = gdk_texture_new_from_filename("icon.png", nil)
gtk_picture_set_paintable(picture, cast[GdkPaintable](texture))
```

---

### `g_bytes_new_static(data, size): GBytes`

**Что делает:** Создаёт неизменяемый контейнер `GBytes` из указателя на данные без копирования.

**Когда использовать:** Для передачи статических данных (встроенных в бинарник) в GTK-функции.

---

## 18. GLib — утилиты памяти и строк

### `g_free(mem)` / `g_malloc(nBytes): gpointer` / `g_malloc0(nBytes): gpointer`

**Что делает:** Аналоги `free`/`malloc`/`calloc` из C, но через GLib. Обязательны для освобождения строк и объектов, возвращаемых GTK-функциями.

**Когда использовать:** Всегда, когда GTK-функция возвращает `cstring` или `gpointer`, которые нужно освободить.

**Пример:**
```nim
let path = g_file_get_path(gfile)
let pathStr = $path
g_free(cast[gpointer](path))
```

---

### `g_strdup(str): cstring`

**Что делает:** Создаёт копию C-строки в памяти GLib.

---

### `g_strcmp0(str1, str2): gint`

**Что делает:** Безопасное сравнение C-строк (обрабатывает `nil`). Возвращает 0 при равенстве, отрицательное/положительное при различии.

---

## 19. Таймеры и Main Loop

### `g_timeout_add(interval, function, data): guint`

**Что делает:** Регистрирует периодически вызываемый коллбэк с интервалом в **миллисекундах**.

**Результат:** ID источника событий. Коллбэк должен возвращать `TRUE` для продолжения или `FALSE` для отмены.

---

### `g_timeout_add_seconds(interval, function, data): guint`

**Что делает:** То же, но интервал в **секундах**. Более экономичен по ресурсам.

---

### `g_idle_add(function, data): guint`

**Что делает:** Регистрирует коллбэк, вызываемый в моменты простоя главного цикла событий.

---

### `g_source_remove(tag): gboolean`

**Что делает:** Отменяет таймер или idle-коллбэк по его ID.

---

### `g_main_loop_new` / `g_main_loop_run` / `g_main_loop_quit`

**Что делает:** Создаёт, запускает и останавливает главный цикл GLib вручную (редко нужно при использовании `GtkApplication`).

---

## 20. TreeModel / ListStore / TreeStore (устаревшие)

> ⚠️ Эти API устарели в GTK4. Для новых проектов используйте `GtkListView`, `GtkColumnView`, `GtkStringList` и `GtkSingleSelection`.

### `gtk_list_store_new(nColumns, ...): GtkListStore`

**Что делает:** Создаёт плоское хранилище данных с указанными типами колонок.

**Пример:**
```nim
let store = gtk_list_store_new(2, G_TYPE_STRING, G_TYPE_INT)
var iter: GtkTreeIter
gtk_list_store_append(store, addr iter)
gtk_list_store_set(store, addr iter, 0, "Файл.txt".cstring, 1, 1024.gint, -1)
```

---

### `gtk_tree_store_new` / `gtk_tree_store_append`

**Что делает:** Аналог `ListStore`, но поддерживает иерархию (дерево). Элементы могут иметь родителей и дочерние узлы.

**Пример:**
```nim
let treeStore = gtk_tree_store_new(1, G_TYPE_STRING)
var parent, child: GtkTreeIter
gtk_tree_store_append(treeStore, addr parent, nil)
gtk_tree_store_set(treeStore, addr parent, 0, "Папка".cstring, -1)
gtk_tree_store_append(treeStore, addr child, addr parent)
gtk_tree_store_set(treeStore, addr child, 0, "Файл".cstring, -1)
```

---

## 21. TreeView и TreeViewColumn (устаревшие)

### `gtk_tree_view_new_with_model(model): GtkTreeView`

**Что делает:** Создаёт виджет таблицы/дерева с привязанной моделью данных.

### `gtk_tree_view_append_column(treeView, column): gint`

**Что делает:** Добавляет колонку к TreeView. Возвращает количество колонок.

### `gtk_tree_view_get_selection(treeView): GtkTreeSelection`

**Что делает:** Возвращает объект для управления выделением строк.

**Пример:**
```nim
let view = gtk_tree_view_new_with_model(store)
let col = gtk_tree_view_column_new_with_attributes("Имя", gtk_cell_renderer_text_new(), "text", 0, nil)
discard gtk_tree_view_append_column(view, col)
```

---

## 22. TreeSelection и TreePath / TreeModel

### `gtk_tree_selection_get_selected(selection, model, iter): gboolean`

**Что делает:** Записывает в `model` и `iter` данные о текущей выделенной строке.

**Пример:**
```nim
var model: GtkTreeModel
var iter: GtkTreeIter
let selection = gtk_tree_view_get_selection(treeView)
if gtk_tree_selection_get_selected(selection, addr model, addr iter) != 0:
  var value: GValue
  gtk_tree_model_get_value(model, addr iter, 0, value)
```

---

### `gtk_tree_model_iter_next(treeModel, iter): gboolean`

**Что делает:** Перемещает итератор на следующую строку.

**Результат:** `TRUE` если следующая строка существует, `FALSE` — конец данных.

---

### `gtk_tree_model_get_iter_first(treeModel, iter): gboolean`

**Что делает:** Устанавливает итератор на первую строку модели.

---

## 23. RadioButton

> ⚠️ `GtkRadioButton` устарел в GTK4. Используйте `GtkCheckButton` с методом `gtk_check_button_set_group`.

### `gtk_radio_button_new_with_label_from_widget(radioGroupMember, label): GtkRadioButton`

**Что делает:** Создаёт новую радиокнопку в той же группе, что и `radioGroupMember`.

**Пример:**
```nim
let rb1 = gtk_radio_button_new_with_label(nil, "Вариант А")
let rb2 = gtk_radio_button_new_with_label_from_widget(rb1, "Вариант Б")
let rb3 = gtk_radio_button_new_with_label_from_widget(rb1, "Вариант В")
```

---

## 24. ScaleButton и VolumeButton

### `gtk_scale_button_new(min, max, step, icons): GtkScaleButton`

**Что делает:** Создаёт кнопку с всплывающим ползунком. `icons` — массив иконок для разных уровней.

**Когда использовать:** Для компактного управления громкостью или другим параметром в ограниченном пространстве.

### `gtk_volume_button_new(): GtkVolumeButton`

**Что делает:** Специализированный вариант `ScaleButton` с иконками громкости.

**Пример:**
```nim
let volBtn = gtk_volume_button_new()
gtk_scale_button_set_value(cast[GtkScaleButton](volBtn), 0.7)
```

---

## 25. LockButton

### `gtk_lock_button_new(permission): GtkLockButton`

**Что делает:** Создаёт кнопку блокировки/разблокировки доступа (интеграция с `GPermission`/PolicyKit).

**Когда использовать:** В настройках системы, требующих прав администратора (аналог замочка в GNOME Settings).

---

## 26. TextTag и TextTagTable

### `gtk_text_tag_new(name): GtkTextTag`

**Что делает:** Создаёт именованный тег для форматирования фрагментов текста в `GtkTextBuffer`.

**Когда использовать:** Для подсветки синтаксиса, жирного/курсивного текста, цветовой разметки.

### `gtk_text_tag_table_new(): GtkTextTagTable`

**Что делает:** Создаёт хранилище тегов для `GtkTextBuffer`.

**Пример:**
```nim
let tagTable = gtk_text_tag_table_new()
let boldTag = gtk_text_tag_new("bold")
g_object_set(boldTag, "weight", 700, nil)  # Pango.Weight.BOLD
discard gtk_text_tag_table_add(tagTable, boldTag)
let buffer = gtk_text_buffer_new(tagTable)
```

---

### `gtk_text_tag_table_lookup(table, name): GtkTextTag`

**Что делает:** Ищет тег по имени.

**Пример:**
```nim
let tag = gtk_text_tag_table_lookup(tagTable, "bold")
```

---

## 27. TextMark

### `gtk_text_mark_new(name, leftGravity): GtkTextMark`

**Что делает:** Создаёт закладку (метку позиции) в тексте. При `leftGravity = TRUE` — перемещается влево от вставляемого текста.

**Когда использовать:** Для сохранения позиций (курсор, начало/конец выделения, закладки для навигации).

**Пример:**
```nim
let bookmark = gtk_text_mark_new("bookmark1", FALSE)
gtk_text_buffer_add_mark(buffer, bookmark, addr insertIter)
```

---

## 28. TextIter — навигация по тексту

`GtkTextIter` — позиция в текстовом буфере. Позволяет читать текст, навигировать и искать.

### Получение информации о позиции:

| Функция | Что возвращает |
|---|---|
| `gtk_text_iter_get_offset(iter)` | Абсолютный символьный offset от начала буфера |
| `gtk_text_iter_get_line(iter)` | Номер строки (с 0) |
| `gtk_text_iter_get_line_offset(iter)` | Позиция в символах от начала строки |
| `gtk_text_iter_get_char(iter)` | Unicode-символ под курсором |

### Получение текста:

```nim
# Получить текст между двумя итераторами
var start, finish: GtkTextIter
gtk_text_buffer_get_bounds(buffer, addr start, addr finish)
let allText = $gtk_text_iter_get_text(addr start, addr finish)
```

### Навигация:

| Функция | Действие |
|---|---|
| `gtk_text_iter_forward_char(iter)` | Один символ вперёд |
| `gtk_text_iter_backward_char(iter)` | Один символ назад |
| `gtk_text_iter_forward_line(iter)` | Следующая строка |
| `gtk_text_iter_forward_word_end(iter)` | Конец следующего слова |
| `gtk_text_iter_forward_to_end(iter)` | Конец буфера |
| `gtk_text_iter_forward_to_line_end(iter)` | Конец текущей строки |

### Поиск:

```nim
var matchStart, matchEnd: GtkTextIter
if gtk_text_iter_forward_search(addr start, "hello", 0, 
                                 addr matchStart, addr matchEnd, nil) != 0:
  echo "Найдено!"
```

### Проверки позиции:

```nim
if gtk_text_iter_is_start(addr iter) != 0: echo "Начало буфера"
if gtk_text_iter_starts_word(addr iter) != 0: echo "Начало слова"
```

---

## 29. TextBuffer (дополнительные функции)

### `gtk_text_buffer_insert_with_tags(buffer, iter, text, len, firstTag, ...)`

**Что делает:** Вставляет текст с немедленным применением одного или нескольких тегов форматирования.

**Пример:**
```nim
gtk_text_buffer_insert_with_tags(buffer, addr iter, "Заголовок", -1, titleTag, nil)
```

---

### `gtk_text_buffer_create_tag(buffer, tagName, firstPropertyName, ...): GtkTextTag`

**Что делает:** Создаёт тег и добавляет его в таблицу тегов буфера за один вызов.

**Пример:**
```nim
let errTag = gtk_text_buffer_create_tag(buffer, "error", 
                                         "foreground", "red".cstring,
                                         "weight", 700.gint, nil)
```

---

### `gtk_text_buffer_add_selection_clipboard(buffer, clipboard)`

**Что делает:** Подключает буфер обмена для синхронизации выделения текста с системным буфером обмена.

---

## 30. Editable

Интерфейс `GtkEditable` реализован в `GtkEntry`, `GtkSearchEntry`, `GtkPasswordEntry`, `GtkSpinButton`.

### `gtk_editable_get_text(editable): cstring` / `gtk_editable_set_text(editable, text)`

**Что делает:** Читает и устанавливает текст в редактируемом виджете.

**Пример:**
```nim
let text = $gtk_editable_get_text(entry)
gtk_editable_set_text(entry, "Новый текст")
```

---

### `gtk_editable_select_region(editable, startPos, endPos)`

**Что делает:** Программно выделяет диапазон текста.

**Пример:**
```nim
gtk_editable_select_region(entry, 0, -1)  # выделить весь текст
```

---

### `gtk_editable_set_editable(editable, isEditable)` / `gtk_editable_set_enable_undo`

**Что делает:** Включает/отключает редактирование и возможность отмены изменений (Ctrl+Z).

---

## 31. PopoverMenu и GMenu

### `gtk_popover_menu_new_from_model(model): GtkPopoverMenu`

**Что делает:** Создаёт всплывающее меню на основе `GMenuModel` — декларативного описания меню через GIO.

**Когда использовать:** Для контекстных меню, меню кнопок (hamburger menu), меню заголовка окна.

**Пример:**
```nim
let menu = g_menu_new()
let item1 = g_menu_item_new("Открыть", "app.open")
let item2 = g_menu_item_new("Сохранить", "app.save")
g_menu_append_item(menu, item1)
g_menu_append_item(menu, item2)

let popover = gtk_popover_menu_new_from_model(cast[GMenuModel](menu))
gtk_menu_button_set_popover(menuButton, popover)
```

---

### `g_menu_item_new_section(label, section): GMenuItem` / `g_menu_item_new_submenu(label, submenu)`

**Что делает:** Создаёт пункт-секцию (разделитель с группой) или пункт с подменю.

---

## 32. Revealer

### `gtk_revealer_new(): GtkRevealer`

**Что делает:** Создаёт контейнер, который анимированно показывает и скрывает дочерний виджет.

**Когда использовать:** Для строк поиска, панелей подсказок, уведомлений, дополнительных настроек с плавным появлением.

### `gtk_revealer_set_reveal_child(revealer, revealChild)`

**Что делает:** `TRUE` — показать с анимацией, `FALSE` — скрыть.

### `gtk_revealer_set_transition_type(revealer, transition)` / `gtk_revealer_set_transition_duration(revealer, duration)`

**Типы анимации:**
- `GTK_REVEALER_TRANSITION_TYPE_CROSSFADE` — затухание
- `GTK_REVEALER_TRANSITION_TYPE_SLIDE_DOWN` / `SLIDE_UP` / `SLIDE_LEFT` / `SLIDE_RIGHT` — сдвиг

**Пример:**
```nim
let revealer = gtk_revealer_new()
gtk_revealer_set_transition_type(revealer, GTK_REVEALER_TRANSITION_TYPE_SLIDE_DOWN)
gtk_revealer_set_transition_duration(revealer, 300)
gtk_revealer_set_child(revealer, searchBar)
# Показать:
gtk_revealer_set_reveal_child(revealer, TRUE)
```

---

## 33. Gesture & Event Controllers

### `gtk_gesture_click_new(): GtkGestureClick`

**Что делает:** Создаёт контроллер одиночных кликов мышью.

**Сигналы:** `pressed`, `released`, `stopped`.

**Пример:**
```nim
let click = gtk_gesture_click_new()
gtk_gesture_click_set_button(click, 3)  # правая кнопка
gtk_widget_add_controller(widget, cast[GtkEventController](click))
discard g_signal_connect(click, "pressed", cast[GCallback](onRightClick), nil)
```

---

### `gtk_gesture_drag_new(): GtkGestureDrag`

**Что делает:** Контроллер перетаскивания. `get_start_point` — начало, `get_offset` — текущее смещение.

---

### `gtk_gesture_long_press_new(): GtkGestureLongPress`

**Что делает:** Распознаёт длительное удержание кнопки/пальца. Полезно для контекстных меню на тач-устройствах.

---

### `gtk_gesture_swipe_new(): GtkGestureSwipe`

**Что делает:** Распознаёт жест смахивания. `get_velocity` — возвращает скорость по X и Y.

---

### `gtk_gesture_rotate_new(): GtkGestureRotate`

**Что делает:** Распознаёт вращение (pinch-rotate). `get_angle_delta` — угол поворота в радианах.

---

### `gtk_gesture_zoom_new(): GtkGestureZoom`

**Что делает:** Распознаёт pinch-to-zoom. `get_scale_delta` — коэффициент масштаба.

---

### `gtk_event_controller_key_new(): GtkEventControllerKey`

**Что делает:** Контроллер клавиатурных событий.

**Сигналы:** `key-pressed(keyval, keycode, modifiers)`, `key-released`.

---

### `gtk_event_controller_focus_new(): GtkEventControllerFocus`

**Что делает:** Отслеживает получение и потерю фокуса виджетом.

**Сигналы:** `enter`, `leave`.

---

### `gtk_event_controller_motion_new(): GtkEventControllerMotion`

**Что делает:** Отслеживает движение курсора мыши над виджетом.

**Сигналы:** `enter`, `leave`, `motion(x, y)`.

---

### `gtk_event_controller_scroll_new(flags): GtkEventControllerScroll`

**Что делает:** Обрабатывает прокрутку колёсиком/тачпадом.

**Сигналы:** `scroll(dx, dy)`, `scroll-begin`, `scroll-end`.

---

### `gtk_widget_add_controller(widget, controller)` / `gtk_widget_remove_controller`

**Что делает:** Прикрепляет/отсоединяет контроллер событий к виджету.

---

## 34. Drag and Drop

### `gtk_drag_source_new(): GtkDragSource`

**Что делает:** Создаёт источник перетаскивания (виджет, с которого можно тащить данные).

**Сигналы:** `prepare(x, y)`, `drag-begin`, `drag-end`, `drag-cancel`.

**Пример:**
```nim
let source = gtk_drag_source_new()
gtk_drag_source_set_actions(source, 1)  # GDK_ACTION_COPY
gtk_widget_add_controller(fileIcon, cast[GtkEventController](source))
```

---

### `gtk_drop_target_new(contentType, actions): GtkDropTarget`

**Что делает:** Создаёт цель для приёма перетаскиваемых данных заданного типа.

**Сигналы:** `accept`, `enter`, `motion`, `leave`, `drop`.

**Пример:**
```nim
let target = gtk_drop_target_new(G_TYPE_STRING, 1)  # принимает строки
gtk_widget_add_controller(dropZone, cast[GtkEventController](target))
discard g_signal_connect(target, "drop", cast[GCallback](onDrop), nil)
```

---

## 35. Shortcuts

### `gtk_shortcut_controller_new(): GtkShortcutController`

**Что делает:** Создаёт контроллер клавиатурных сочетаний.

### `gtk_shortcut_trigger_parse_string(string): GtkShortcutTrigger`

**Что делает:** Разбирает строку вроде `"<Control>S"`, `"F5"`, `"<Alt>Return"` в триггер горячей клавиши.

### `gtk_shortcut_action_parse_string(string): GtkShortcutAction`

**Что делает:** Парсит действие, например `"action(app.save)"`.

**Пример:**
```nim
let controller = gtk_shortcut_controller_new()
let trigger = gtk_shortcut_trigger_parse_string("<Control>S")
let action = gtk_shortcut_action_parse_string("action(app.save)")
let shortcut = gtk_shortcut_new(trigger, action)
gtk_shortcut_controller_add_shortcut(controller, shortcut)
gtk_widget_add_controller(window, cast[GtkEventController](controller))
```

---

## 36. Constraint Layout

`GtkConstraintLayout` — менеджер компоновки на основе системы линейных ограничений (Cassowary). Позволяет задавать соотношения между размерами и позициями виджетов.

### `gtk_constraint_layout_new(): GtkConstraintLayout`

**Что делает:** Создаёт менеджер компоновки.

### `gtk_constraint_new(target, targetAttr, relation, source, sourceAttr, multiplier, constant, strength): GtkConstraint`

**Что делает:** Создаёт ограничение вида: `target.attr = source.attr * multiplier + constant`.

**Пример:**
```nim
# Ширина кнопки = ширина контейнера * 0.5 - 8
let c = gtk_constraint_new(button, GTK_CONSTRAINT_ATTRIBUTE_WIDTH,
                            GTK_CONSTRAINT_RELATION_EQ,
                            container, GTK_CONSTRAINT_ATTRIBUTE_WIDTH,
                            0.5, -8.0, GTK_CONSTRAINT_STRENGTH_REQUIRED)
gtk_constraint_layout_add_constraint(layout, c)
```

---

## 37. WindowGroup

### `gtk_window_group_new(): GtkWindowGroup`

**Что делает:** Создаёт группу окон. Модальные диалоги изолируются в пределах группы.

**Когда использовать:** В многооконных приложениях, чтобы модальное окно блокировало только окна своей группы.

**Пример:**
```nim
let group = gtk_window_group_new()
gtk_window_group_add_window(group, mainWin)
gtk_window_group_add_window(group, secondaryWin)
```

---

## 38. Native Dialog и Alert Dialog

### `GtkAlertDialog` (GTK 4.10+)

Современная замена `GtkMessageDialog`.

### `gtk_alert_dialog_new(format, ...): GtkAlertDialog`

**Что делает:** Создаёт простой диалог с сообщением.

### `gtk_alert_dialog_set_buttons(dialog, labels)`

**Что делает:** Устанавливает список кнопок.

### `gtk_alert_dialog_choose(dialog, parent, cancellable, callback, userData)`

**Что делает:** Показывает диалог асинхронно. Результат (индекс нажатой кнопки) передаётся в `callback`.

**Пример:**
```nim
let dlg = gtk_alert_dialog_new("Удалить файл?")
gtk_alert_dialog_set_detail(dlg, "Это действие нельзя отменить")
var btns = ["Отмена".cstring, "Удалить".cstring, nil]
gtk_alert_dialog_set_buttons(dlg, addr btns[0])
gtk_alert_dialog_set_cancel_button(dlg, 0)
gtk_alert_dialog_choose(dlg, mainWindow, nil, onAlertResult, nil)
```

---

### `GtkNativeDialog` — абстрактный базовый класс для системных диалогов

`gtk_native_dialog_show(nativeDialog)` / `gtk_native_dialog_hide(nativeDialog)` / `gtk_native_dialog_destroy(nativeDialog)` — управление жизненным циклом нативных диалогов (File Chooser и т.д.).

---

## 39. Print Operation

### `gtk_print_operation_new(): GtkPrintOperation`

**Что делает:** Создаёт объект операции печати.

**Сигналы:** `begin-print`, `draw-page(context, pageNr)`, `end-print`.

### `gtk_print_operation_run(op, action, parent, error): gint`

**Что делает:** Запускает диалог печати и операцию. `action` = 0 (диалог), 1 (печать), 2 (в файл), 3 (предварительный просмотр).

### `gtk_print_context_get_cairo_context(context): cairo_t`

**Что делает:** Возвращает Cairo-контекст текущей страницы для рисования.

**Пример:**
```nim
proc onDrawPage(op: GtkPrintOperation, ctx: GtkPrintContext, pageNr: gint, data: pointer) {.cdecl.} =
  let cr = gtk_print_context_get_cairo_context(ctx)
  cairo_move_to(cr, 10.0, 50.0)
  # pango_cairo_show_layout(cr, layout)  # или Cairo-рисование

let printOp = gtk_print_operation_new()
gtk_print_operation_set_n_pages(printOp, 1)
discard g_signal_connect(printOp, "draw-page", cast[GCallback](onDrawPage), nil)
discard gtk_print_operation_run(printOp, 0, mainWindow, nil)
```

---

## 40. Builder (GTK XML)

### `gtk_builder_new_from_file(filename): GtkBuilder`

**Что делает:** Загружает описание интерфейса из `.ui`-файла.

### `gtk_builder_new_from_resource(resourcePath): GtkBuilder`

**Что делает:** Загружает UI из встроенного GResource (скомпилированного в бинарник).

### `gtk_builder_new_from_string(string, length): GtkBuilder`

**Что делает:** Загружает UI из строки.

### `gtk_builder_get_object(builder, name): GObject`

**Что делает:** Возвращает объект по `id` из XML.

### `gtk_builder_expose_object(builder, name, obj)`

**Что делает:** Делает внешний объект Nim доступным по имени внутри Builder (для ссылок из XML).

### `gtk_builder_set_translation_domain(builder, domain)`

**Что делает:** Устанавливает домен перевода gettext для локализации строк в UI.

**Пример:**
```nim
let builder = gtk_builder_new_from_file("ui/main.ui")
let win = cast[GtkWindow](gtk_builder_get_object(builder, "mainWindow"))
let btn = cast[GtkButton](gtk_builder_get_object(builder, "okButton"))
gtk_window_present(win)
```

---

## 41. GtkSettings

### `gtk_settings_get_default(): GtkSettings`

**Что делает:** Возвращает глобальные настройки GTK для дисплея по умолчанию.

### `gtk_settings_get_for_display(display): GtkSettings`

**Что делает:** Настройки для конкретного дисплея (в многомониторных конфигурациях).

### `gtk_settings_reset_property(settings, name)`

**Что делает:** Сбрасывает свойство настройки к значению по умолчанию.

**Пример:**
```nim
let settings = gtk_settings_get_default()
g_object_set(settings, "gtk-application-prefer-dark-theme", TRUE, nil)
```

---

## 42. SizeGroup

### `gtk_size_group_new(mode): GtkSizeGroup`

**Что делает:** Создаёт группу размеров. Все виджеты в группе будут иметь одинаковый размер по заданной оси.

**Режимы:** `NONE`, `HORIZONTAL`, `VERTICAL`, `BOTH`.

**Когда использовать:** Для выравнивания ширины кнопок в форме, одинаковой высоты иконок в панели.

**Пример:**
```nim
let sg = gtk_size_group_new(GTK_SIZE_GROUP_HORIZONTAL)
gtk_size_group_add_widget(sg, btn1)
gtk_size_group_add_widget(sg, btn2)
gtk_size_group_add_widget(sg, btn3)
# Все три кнопки получат одинаковую ширину
```

---

## 43. GDK KeyVal

### `gdk_keyval_from_name(keyvalName): guint`

**Что делает:** Преобразует строковое имя клавиши (`"Return"`, `"Escape"`, `"F1"`) в числовой keyval.

### `gdk_keyval_name(keyval): cstring`

**Что делает:** Обратное преобразование — keyval в имя клавиши.

### `gdk_keyval_to_unicode(keyval): gunichar`

**Что делает:** Получает Unicode-символ, соответствующий клавише.

**Пример:**
```nim
proc onKeyPress(ctrl: GtkEventControllerKey, keyval: guint, 
                keycode: guint, state: guint, data: pointer): gboolean {.cdecl.} =
  if keyval == gdk_keyval_from_name("Return"):
    echo "Enter нажат"
    return TRUE
  return FALSE
```

---

## 44. GIO — файловые операции

### `g_file_new_for_uri(uri): GFile`

**Что делает:** Создаёт `GFile` из URI (например, `"file:///home/user/doc.txt"`, `"ftp://..."`).

### `g_file_equal(file1, file2): gboolean`

**Что делает:** Сравнивает два GFile объекта.

### `g_file_get_parent(file): GFile`

**Что делает:** Возвращает родительскую директорию.

### `g_file_get_child(file, name): GFile`

**Что делает:** Создаёт GFile для дочернего элемента с указанным именем.

### `g_file_query_exists(file, cancellable): gboolean`

**Что делает:** Проверяет существование файла/директории. Неблокирующий вариант.

**Пример:**
```nim
let configFile = g_file_new_for_path("/home/user/.config/app.cfg")
if g_file_query_exists(configFile, nil) != 0:
  echo "Конфиг найден"
let parentDir = g_file_get_parent(configFile)
```

---

## 45. Tooltip

### `gtk_tooltip_set_text(tooltip, text)` / `gtk_tooltip_set_markup(tooltip, markup)`

**Что делает:** Устанавливает текст подсказки (обычный или с Pango-разметкой).

### `gtk_tooltip_set_icon_from_icon_name(tooltip, iconName)`

**Что делает:** Добавляет иконку к подсказке.

### `gtk_tooltip_set_custom(tooltip, customWidget)`

**Что делает:** Заменяет стандартную подсказку произвольным виджетом (например, виджетом с изображением и кнопкой).

**Пример:**
```nim
proc onQueryTooltip(widget: GtkWidget, x, y: gint, keyboardMode: gboolean,
                    tooltip: GtkTooltip, data: pointer): gboolean {.cdecl.} =
  gtk_tooltip_set_text(tooltip, "Нажмите для сохранения")
  gtk_tooltip_set_icon_from_icon_name(tooltip, "document-save")
  return TRUE

gtk_widget_set_has_tooltip(button, TRUE)
discard g_signal_connect(button, "query-tooltip", cast[GCallback](onQueryTooltip), nil)
```

---

## 46. Selection Model (GTK4)

GTK4 использует `GtkSelectionModel` вместо `GtkTreeSelection` для современных виджетов списков.

### `gtk_single_selection_new(model): GtkSingleSelection`

**Что делает:** Оборачивает модель данных с поддержкой одиночного выделения.

### `gtk_multi_selection_new(model): GtkMultiSelection`

**Что делает:** Оборачивает модель с поддержкой множественного выделения.

### `gtk_no_selection_new(model): GtkNoSelection`

**Что делает:** Оборачивает модель без выделения (только отображение).

**Пример:**
```nim
let stringList = gtk_string_list_new(nil)
gtk_string_list_append(stringList, "Элемент 1")
gtk_string_list_append(stringList, "Элемент 2")

let selection = gtk_single_selection_new(cast[pointer](stringList))
let listView = gtk_list_view_new(selection, factory)
```

---

## 47. ListView и ColumnView (GTK4)

### `gtk_signal_list_item_factory_new(): GtkSignalListItemFactory`

**Что делает:** Создаёт фабрику элементов списка, работающую через сигналы. Самый гибкий способ создавать кастомные строки.

**Сигналы фабрики:** `setup(factory, listItem)` — создать виджет строки, `bind(factory, listItem)` — заполнить данными, `unbind`, `teardown`.

### `gtk_list_view_new(model, factory): GtkListView`

**Что делает:** Создаёт вертикальный список с виртуализацией (отрисовывает только видимые строки).

**Когда использовать:** Для отображения тысяч строк без потери производительности.

**Пример:**
```nim
let factory = gtk_signal_list_item_factory_new()

proc onSetup(f: pointer, listItem: GtkListItem, data: pointer) {.cdecl.} =
  let label = gtk_label_new(nil)
  gtk_list_item_set_child(listItem, label)

proc onBind(f: pointer, listItem: GtkListItem, data: pointer) {.cdecl.} =
  let item = cast[GtkStringObject](gtk_list_item_get_item(listItem))
  let label = gtk_list_item_get_child(listItem)
  gtk_label_set_text(label, gtk_string_object_get_string(item))

discard g_signal_connect(factory, "setup", cast[GCallback](onSetup), nil)
discard g_signal_connect(factory, "bind", cast[GCallback](onBind), nil)

let listView = gtk_list_view_new(selection, factory)
```

---

### `gtk_column_view_new(model): GtkColumnView`

**Что делает:** Создаёт табличный виджет с колонками, заголовками и сортировкой.

### `gtk_column_view_column_new(title, factory): GtkColumnViewColumn`

**Что делает:** Создаёт колонку для `GtkColumnView` с заголовком и фабрикой.

---

## 48. GridView

### `gtk_grid_view_new(model, factory): GtkGridView`

**Что делает:** Создаёт сеточный (галерейный) вид с виртуализацией.

**Когда использовать:** Для отображения карточек, иконок файлов, фотографий в сетке.

**Пример:**
```nim
let gridView = gtk_grid_view_new(selection, factory)
gtk_grid_view_set_min_columns(gridView, 2)
gtk_grid_view_set_max_columns(gridView, 8)
gtk_grid_view_set_single_click_activate(gridView, TRUE)
```

---

## 49. DropDown

### `gtk_drop_down_new_from_strings(strings): GtkDropDown`

**Что делает:** Создаёт выпадающий список из массива строк. Современная замена `GtkComboBoxText`.

**Пример:**
```nim
var items = ["Вариант 1".cstring, "Вариант 2".cstring, "Вариант 3".cstring, nil]
let dropdown = gtk_drop_down_new_from_strings(addr items[0])
```

### `gtk_drop_down_get_selected(self): guint` / `gtk_drop_down_set_selected(self, position)`

**Что делает:** Читает и устанавливает индекс выбранного элемента.

### `gtk_drop_down_set_enable_search(self, enableSearch)`

**Что делает:** Активирует поле поиска внутри выпадающего списка для больших списков.

---

## 50. StringList

### `gtk_string_list_new(strings): GtkStringList`

**Что делает:** Создаёт список строк, реализующий интерфейс `GListModel`. Используется как модель данных для `GtkListView`, `GtkDropDown` и т.д.

### `gtk_string_list_append(self, string)` / `gtk_string_list_remove(self, position)`

**Что делает:** Добавляет и удаляет строки.

### `gtk_string_list_get_string(self, position): cstring`

**Что делает:** Возвращает строку по индексу.

**Пример:**
```nim
let list = gtk_string_list_new(nil)
gtk_string_list_append(list, "Москва")
gtk_string_list_append(list, "Санкт-Петербург")
gtk_string_list_append(list, "Казань")
```

---

## 51. WindowControls / WindowHandle / CenterBox

### `gtk_window_controls_new(side): GtkWindowControls`

**Что делает:** Создаёт кнопки управления окном (свернуть, развернуть, закрыть) для заданной стороны. Используется в кастомных `GtkHeaderBar`.

### `gtk_window_controls_set_decoration_layout(self, layout)`

**Что делает:** Задаёт расположение кнопок. Строка вида `"icon:minimize,maximize,close"`.

---

### `gtk_window_handle_new(): GtkWindowHandle`

**Что делает:** Создаёт область для перетаскивания окна мышью (аналог строки заголовка).

**Пример:**
```nim
let handle = gtk_window_handle_new()
gtk_window_handle_set_child(handle, titleLabel)
```

---

### `gtk_center_box_new(): GtkCenterBox`

**Что делает:** Контейнер с тремя зонами: начало, центр, конец. Центральный элемент всегда остаётся точно в центре.

**Когда использовать:** Для шапок с заголовком по центру и кнопками по краям (аналог `GtkHeaderBar` без встроенных функций окна).

**Пример:**
```nim
let centerBox = gtk_center_box_new()
gtk_center_box_set_start_widget(centerBox, backButton)
gtk_center_box_set_center_widget(centerBox, pageTitle)
gtk_center_box_set_end_widget(centerBox, menuButton)
```

---

## 52. Inscription (GTK 4.8+)

### `gtk_inscription_new(text): GtkInscription`

**Что делает:** Создаёт виджет для показа текста в фиксированном пространстве с умным усечением. В отличие от `GtkLabel` не изменяет размер контейнера.

**Когда использовать:** В ячейках `GtkListView`/`GtkColumnView`, где размер строки фиксирован.

### `gtk_inscription_set_min_chars/nat_chars(self, n)` / `gtk_inscription_set_min_lines/nat_lines(self, n)`

**Что делает:** Устанавливает минимальные и предпочтительные размеры виджета в символах/строках.

**Пример:**
```nim
let ins = gtk_inscription_new("Длинный текст, который будет усечён...")
gtk_inscription_set_min_chars(ins, 10)
gtk_inscription_set_nat_chars(ins, 20)
```

---

## 53. Video / MediaStream / MediaFile

### `gtk_video_new_for_filename(filename): GtkVideo`

**Что делает:** Создаёт виджет воспроизведения видео из файла.

**Пример:**
```nim
let video = gtk_video_new_for_filename("movie.mp4")
gtk_video_set_autoplay(video, TRUE)
gtk_video_set_loop(video, FALSE)
```

---

### `gtk_media_stream_play(self)` / `gtk_media_stream_pause(self)`

**Что делает:** Запускает и останавливает воспроизведение медиапотока.

### `gtk_media_stream_seek(self, timestamp)`

**Что делает:** Перематывает к позиции в микросекундах.

### `gtk_media_stream_set_volume(self, volume)` / `gtk_media_stream_set_muted(self, muted)`

**Что делает:** Управляет громкостью (0.0–1.0) и отключением звука.

**Пример:**
```nim
let stream = gtk_video_get_media_stream(video)
gtk_media_stream_play(stream)
gtk_media_stream_seek(stream, 30_000_000)  # 30 секунд
gtk_media_stream_set_volume(stream, 0.8)
```

---

## 54. MediaControls

### `gtk_media_controls_new(stream): GtkMediaControls`

**Что делает:** Создаёт панель управления медиаплеером (кнопки play/pause, полоса прогресса, громкость) для заданного `GtkMediaStream`.

**Пример:**
```nim
let video = gtk_video_new_for_filename("video.mp4")
let stream = gtk_video_get_media_stream(video)
let controls = gtk_media_controls_new(stream)

let vbox = createVBox(spacing = 4)
addChildren(vbox, video, controls)
```

---

## 55. Snapshot (Drawing API)

`GtkSnapshot` — современный способ рисования в GTK4 (вместо Cairo в `draw`-сигнале). Используется в виртуальном методе `snapshot()` кастомных виджетов.

### `gtk_snapshot_append_color(snapshot, color, bounds)`

**Что делает:** Заполняет прямоугольную область цветом.

### `gtk_snapshot_append_texture(snapshot, texture, bounds)`

**Что делает:** Отрисовывает текстуру в заданной области.

### `gtk_snapshot_append_cairo(snapshot, bounds): cairo_t`

**Что делает:** Создаёт Cairo-контекст для отрисовки в указанной области через Cairo API.

### `gtk_snapshot_push_opacity(snapshot, opacity)` / `gtk_snapshot_pop(snapshot)`

**Что делает:** `push_opacity` — применяет прозрачность ко всем последующим операциям рисования. `pop` — снимает эффект.

### `gtk_snapshot_push_blur(snapshot, radius)` / `gtk_snapshot_push_clip(snapshot, bounds)`

**Что делает:** Применяет размытие Гаусса или обрезку по прямоугольнику.

### `gtk_snapshot_rotate(snapshot, angle)` / `gtk_snapshot_scale(snapshot, fx, fy)` / `gtk_snapshot_translate(snapshot, point)`

**Что делает:** Трансформации координатной системы для последующих операций рисования.

**Пример:**
```nim
proc onSnapshot(widget: GtkWidget, snapshot: GtkSnapshot, data: pointer) {.cdecl.} =
  var color = GdkRGBA(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
  var bounds: GskRoundedRect  # упрощённо
  gtk_snapshot_append_color(snapshot, addr color, addr bounds)
```

---

## 56. GdkRGBA — цвет

### `gdk_rgba_parse(rgba, spec): gboolean`

**Что делает:** Разбирает строку цвета (`"#FF0000"`, `"red"`, `"rgba(255,0,0,0.5)"`) в структуру `GdkRGBA`.

### `gdk_rgba_to_string(rgba): cstring`

**Что делает:** Сериализует цвет в строку формата `"rgb(r,g,b)"` или `"rgba(r,g,b,a)"`.

### `gdk_rgba_equal(p1, p2): gboolean`

**Что делает:** Сравнивает два цвета.

**Пример:**
```nim
var color: GdkRGBA
discard gdk_rgba_parse(addr color, "#3584e4")
let colorStr = $gdk_rgba_to_string(addr color)
echo colorStr  # "rgb(53,132,228)"
```

---

## 57. GList / GSList

`GList` — двусвязный список GLib. `GSList` — односвязный.

### `g_list_append(list, data): ptr GList`

**Что делает:** Добавляет элемент в конец списка.

### `g_list_nth_data(list, n): gpointer`

**Что делает:** Возвращает данные n-го элемента.

### `g_list_length(list): guint`

**Что делает:** Возвращает длину списка.

### `g_list_free(list)` / `g_list_free_full(list, freeFunc)`

**Что делает:** Освобождает список. `free_full` также вызывает `freeFunc` для каждого элемента данных.

**Пример:**
```nim
var list: ptr GList = nil
list = g_list_append(list, cast[gpointer](42))
list = g_list_append(list, cast[gpointer](100))
echo g_list_length(list)  # 2
g_list_free(list)
```

---

## 58. Вспомогательные шаблоны и утилиты

### `gtk_widget_destroy(widget)` (template)

**Что делает:** В GTK4 это `g_object_unref(widget)` — уменьшает счётчик ссылок. Оставлен для совместимости с GTK3-кодом.

### Преобразования типов (`toGtkWidget`, `toGtkButton`, и т.д.)

**Что делает:** Безопасные `cast`-обёртки для приведения `pointer` к конкретным типам виджетов.

**Пример:**
```nim
let w: pointer = gtk_builder_get_object(builder, "myButton")
let btn = toGtkButton(w)  # вместо cast[GtkButton](w)
```

### `toPointer(w)` (template)

**Что делает:** Обратное преобразование любого GTK-типа в `pointer`.

### `makeCallback(name, body)` (template)

**Что делает:** Создаёт `cdecl`-процедуру без аргументов с оборачиванием тела в `try/except`. Для простых коллбэков без параметров.

**Пример:**
```nim
makeCallback(onQuit):
  g_application_quit(cast[GApplication](app))

discard g_signal_connect(quitButton, "clicked", cast[GCallback](onQuit), nil)
```

---

## 59. Работа со строками

### `toGtkString(s: string): cstring`

**Что делает:** Конвертирует Nim `string` в `cstring` для GTK. Возвращает `nil` для пустой строки (некоторые GTK-функции ожидают именно `nil`, а не `""`).

### `fromGtkString(s: cstring): string`

**Что делает:** Конвертирует `cstring` из GTK в Nim `string`. Безопасно обрабатывает `nil` → пустая строка.

### `freeGtkString(s: cstring)`

**Что делает:** Освобождает `cstring`, выделенную GTK через `g_free`. Использовать для строк, возвращаемых функциями без суффикса `_const`.

**Пример:**
```nim
let cText = gtk_label_get_text(label)
let nimText = fromGtkString(cText)
# cText НЕ надо освобождать — это внутренняя строка GTK
# Но для функций вроде g_file_get_path нужно:
let path = g_file_get_path(gfile)
let pathStr = fromGtkString(path)
freeGtkString(path)
```

---

## 60. Сигналы — удобные обёртки

### `connect(widget, signal, callback, data): gulong`

**Что делает:** Упрощённая обёртка над `g_signal_connect`. Эквивалентна ему, но с типизированной сигнатурой для Nim.

**Пример:**
```nim
let id = connect(button, "clicked", cast[GCallback](onClick))
```

---

### `disconnect(widget, handlerId)`

**Что делает:** Отсоединяет обработчик сигнала по его ID. Обёртка над `g_signal_handler_disconnect`.

**Пример:**
```nim
disconnect(spinButton, valueChangedId)
```

---

### `connectAfter(widget, signal, callback, data): gulong`

**Что делает:** Подключает обработчик, который вызывается **после** всех стандартных обработчиков GTK.

**Пример:**
```nim
let id = connectAfter(entry, "changed", cast[GCallback](onTextChanged))
```

---

## 61. Работа с boolean

### `toGboolean(b: bool): gboolean`

**Что делает:** Преобразует `bool` в `gboolean` (GTK-совместимый `int32`).

### `fromGboolean(gb: gboolean): bool`

**Что делает:** Обратное преобразование.

### `boolToGboolean` / `gbooleanToBool` (converter)

**Что делает:** Неявные преобразователи, позволяющие использовать `bool` там, где ожидается `gboolean`, и наоборот.

**Пример:**
```nim
# С конвертерами это работает автоматически:
gtk_widget_set_visible(widget, true)   # bool → gboolean
let isVisible: bool = gtk_widget_get_visible(widget)  # gboolean → bool
```

---

## 62. Виджет-утилиты (отступы, выравнивание, размер)

Итоговая сводка вспомогательных функций для работы с любым виджетом:

| Функция | Что делает |
|---|---|
| `setMargins(w, top, right, bottom, left)` | Отступы по сторонам |
| `setMargins(w, all)` | Одинаковые отступы со всех сторон |
| `setSizeHints(w, width, height)` | Минимальный запрашиваемый размер |
| `setExpand(w, horiz, vert)` | Расширение в Box/Grid |
| `setAlign(w, halign, valign)` | Выравнивание внутри ячейки |
| `addCssClass(w, ...)` | Добавить CSS-классы |
| `removeCssClass(w, ...)` | Убрать CSS-классы |

---

## 63. Дополнительные GTK-виджеты

### Expander (`gtk_expander_new`)

Разворачиваемая секция. Скрывает дочерний виджет и показывает его по клику на заголовок.

```nim
let exp = gtk_expander_new("Дополнительные настройки")
gtk_expander_set_child(exp, advancedBox)
gtk_expander_set_expanded(exp, FALSE)
```

---

### Calendar (`gtk_calendar_new`)

```nim
let cal = gtk_calendar_new()
gtk_calendar_mark_day(cal, 15)   # пометить 15-е число
gtk_calendar_select_day(cal, 1)  # выбрать 1-е
```

---

### Overlay (`gtk_overlay_new`)

Позволяет размещать виджеты поверх основного содержимого.

```nim
let overlay = gtk_overlay_new()
gtk_overlay_set_child(overlay, mainContent)
gtk_overlay_add_overlay(overlay, notificationBanner)  # поверх
```

---

### Fixed (`gtk_fixed_new`)

Контейнер с абсолютным позиционированием (пиксельные координаты).

```nim
let fixed = gtk_fixed_new()
gtk_fixed_put(fixed, button, 100.0, 50.0)
gtk_fixed_move(fixed, button, 120.0, 50.0)
```

---

### AspectFrame (`gtk_aspect_frame_new`)

Контейнер, сохраняющий заданное соотношение сторон дочернего виджета.

```nim
let af = gtk_aspect_frame_new(0.5, 0.5, 16.0/9.0, FALSE)
gtk_aspect_frame_set_child(af, videoWidget)
```

---

### LevelBar (`gtk_level_bar_new_for_interval`)

Индикаторная шкала с уровнями (аналог прогресс-бара с семантическими зонами).

```nim
let bar = gtk_level_bar_new_for_interval(0.0, 100.0)
gtk_level_bar_set_value(bar, 75.0)
```

---

### LinkButton (`gtk_link_button_new_with_label`)

Кнопка-гиперссылка.

```nim
let link = gtk_link_button_new_with_label("https://example.com", "Посетить сайт")
```

---

### ActionBar (`gtk_action_bar_new`)

Панель действий — горизонтальная полоса в нижней части окна.

```nim
let actionBar = gtk_action_bar_new()
gtk_action_bar_pack_start(actionBar, cancelBtn)
gtk_action_bar_set_center_widget(actionBar, progressBar)
gtk_action_bar_pack_end(actionBar, applyBtn)
```

---

### SearchBar (`gtk_search_bar_new`)

Строка поиска с анимированным показом/скрытием.

```nim
let searchBar = gtk_search_bar_new()
let searchEntry = gtk_search_entry_new()
gtk_search_bar_set_child(searchBar, searchEntry)
gtk_search_bar_set_show_close_button(searchBar, TRUE)
gtk_search_bar_set_search_mode(searchBar, TRUE)
```

---

### StatusBar (устаревший) / InfoBar (устаревший)

> ⚠️ Оба виджета устарели в GTK4 (доступны при отсутствии `GTK_DISABLE_DEPRECATED`).

```nim
when not defined(GTK_DISABLE_DEPRECATED):
  let sb = gtk_statusbar_new()
  let ctxId = gtk_statusbar_get_context_id(sb, "main")
  discard gtk_statusbar_push(sb, ctxId, "Готово")
```

---

## Приложение: Сводная таблица виджетов p2

| Тип | Категория | Статус |
|---|---|---|
| `GtkButton`, `GtkToggleButton` | Кнопки | Актуален |
| `GtkCheckButton`, `GtkSwitch` | Переключатели | Актуален |
| `GtkRadioButton` | Группы | Устарел (→ CheckButton + group) |
| `GtkEntry`, `GtkPasswordEntry`, `GtkSearchEntry` | Ввод текста | Актуален |
| `GtkSpinButton`, `GtkScale` | Числовой ввод | Актуален |
| `GtkProgressBar`, `GtkLevelBar` | Индикаторы | Актуален |
| `GtkListView`, `GtkColumnView`, `GtkGridView` | Списки | **GTK4 — рекомендуется** |
| `GtkTreeView`, `GtkListStore` | Списки | Устарел (→ ListView/ColumnView) |
| `GtkDropDown` | Выпадающий список | **GTK4 — рекомендуется** |
| `GtkComboBox`, `GtkComboBoxText` | Выпадающий список | Устарел |
| `GtkFlowBox` | Контейнер | Актуален |
| `GtkRevealer` | Анимация | Актуален |
| `GtkStack`, `GtkNotebook` | Страницы | Актуален |
| `GtkPicture` | Изображение | **GTK4 — рекомендуется** |
| `GtkImage` | Изображение | Актуален, но Picture предпочтительнее |
| `GtkVideo` | Видео | Актуален |
| `GtkStatusbar`, `GtkInfoBar` | Уведомления | Устарел |
| `GtkAlertDialog` | Диалоги | **GTK4 4.10+ — рекомендуется** |
| `GtkMessageDialog` | Диалоги | Устарел |
| `GtkInscription` | Текст в списках | **GTK4 4.8+** |
| `GtkCenterBox`, `GtkWindowHandle` | Компоновка | Актуален |

---

*Справочник сгенерирован на основе `libGTK4_p2.nim`.*
