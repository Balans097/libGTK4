# nim c -d:release --app:gui GTKRawTest2.nim



import libGTK4



# ============================================================================
# ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
# ============================================================================
var
  statusbar: GtkStatusbar
  textView: GtkTextView
  entryField: GtkEntry
  progressBar: GtkProgressBar
  infoLabel: GtkLabel

# Изменение размера шрифтов
proc applyCss() =
  let cssProvider = gtk_css_provider_new()
  const cssData = staticRead("styles.css")
  gtk_css_provider_load_from_data(cssProvider, cstring(cssData), cssData.len.cint)
  gtk_style_context_add_provider_for_display(
    gdk_display_get_default(),
    cast[pointer](cssProvider),  # используем pointer вместо GtkStyleProvider
    GTK_STYLE_PROVIDER_PRIORITY_APPLICATION)



# ============================================================================
# ОБРАБОТЧИКИ КНОПОК ПАНЕЛИ ИНСТРУМЕНТОВ
# ============================================================================

proc onNewClicked(button: GtkButton, userData: pointer) =
  let ctx = gtk_statusbar_get_context_id(statusbar, "main")
  discard gtk_statusbar_push(statusbar, ctx, "Создан новый документ")
  let buffer = gtk_text_view_get_buffer(textView)
  gtk_text_buffer_set_text(buffer, "", 0)
  gtk_label_set_text(infoLabel, "Статус: новый документ создан")

proc onOpenClicked(button: GtkButton, userData: pointer) =
  let ctx = gtk_statusbar_get_context_id(statusbar, "main")
  discard gtk_statusbar_push(statusbar, ctx, "Открытие файла...")
  gtk_label_set_text(infoLabel, "Статус: выбран файл для открытия")

proc onSaveClicked(button: GtkButton, userData: pointer) =
  let ctx = gtk_statusbar_get_context_id(statusbar, "main")
  discard gtk_statusbar_push(statusbar, ctx, "Файл сохранен")
  gtk_label_set_text(infoLabel, "Статус: файл успешно сохранен")

# ============================================================================
# ОБРАБОТЧИКИ КНОПОК ЭЛЕМЕНТОВ УПРАВЛЕНИЯ
# ============================================================================

proc onPrimaryClicked(button: GtkButton, userData: pointer) =
  gtk_label_set_text(infoLabel, "Статус: нажата основная кнопка")
  var fraction = gtk_progress_bar_get_fraction(progressBar) + 0.1
  if fraction > 1.0:
    fraction = 0.0
  gtk_progress_bar_set_fraction(progressBar, fraction)
  let percent = $(int(fraction * 100)) & "%"
  gtk_progress_bar_set_text(progressBar, percent.cstring)

proc onSecondaryClicked(button: GtkButton, userData: pointer) =
  let text = gtk_editable_get_text(cast[pointer](entryField))
  let msg = "Статус: введен текст '" & $text & "'"
  gtk_label_set_text(infoLabel, msg.cstring)

proc onDestructiveClicked(button: GtkButton, userData: pointer) =
  gtk_label_set_text(infoLabel, "Статус: выполнено действие удаления")
  gtk_editable_set_text(cast[pointer](entryField), "")
  let buffer = gtk_text_view_get_buffer(textView)
  gtk_text_buffer_set_text(buffer, "", 0)
  gtk_progress_bar_set_fraction(progressBar, 0.0)
  gtk_progress_bar_set_text(progressBar, "0%")


# ============================================================================
# ДЕЙСТВИЯ МЕНЮ
# ============================================================================

proc newAction(action: GSimpleAction, param: pointer, userData: pointer) {.cdecl.} =
  let ctx = gtk_statusbar_get_context_id(statusbar, "main")
  discard gtk_statusbar_push(statusbar, ctx, "Действие: Новый")

proc openAction(action: GSimpleAction, param: pointer, userData: pointer) {.cdecl.} =
  let ctx = gtk_statusbar_get_context_id(statusbar, "main")
  discard gtk_statusbar_push(statusbar, ctx, "Действие: Открыть")

proc saveAction(action: GSimpleAction, param: pointer, userData: pointer) {.cdecl.} =
  let ctx = gtk_statusbar_get_context_id(statusbar, "main")
  discard gtk_statusbar_push(statusbar, ctx, "Действие: Сохранить")

proc aboutAction(action: GSimpleAction, param: pointer, userData: pointer) {.cdecl.} =
  let ctx = gtk_statusbar_get_context_id(statusbar, "main")
  discard gtk_statusbar_push(statusbar, ctx, "Показано окно 'О программе'")

proc quitAction(action: GSimpleAction, param: pointer, userData: pointer) {.cdecl.} =
  let app = cast[GApplication](userData)
  g_application_quit(app)

# ============================================================================
# СОЗДАНИЕ ИНТЕРФЕЙСА
# ============================================================================

proc onActivate(app: GtkApplication, userData: pointer) {.cdecl.} =
  # Применяем стиль к виджетам
  applyCss()

  # Создание главного окна
  let window = createAppWindow(app, "Эталонное GTK4-приложение на Nim", 1000, 600)
  
  # Главный контейнер
  let mainBox = createVBox()
  gtk_window_set_child(window, mainBox)
  
  # === МЕНЮ ===
  let menuButton = gtk_menu_button_new()
  gtk_menu_button_set_label(cast[GtkButton](menuButton), "≡ Меню")
  
  let auxButton = gtk_menu_button_new()
  gtk_menu_button_set_label(cast[GtkButton](auxButton), "≡ Дополнительно")
  
  let menu = g_menu_new()
  let menu2 = g_menu_new()
  
  # Секция "Файл"
  let fileMenu = g_menu_new()
  g_menu_append_section(menu, "Файл", cast[GMenuModel](fileMenu))
  g_menu_append(fileMenu, "Новый", "app.new")
  g_menu_append(fileMenu, "Открыть", "app.open")
  g_menu_append(fileMenu, "Сохранить", "app.save")
  
  # Секция "Правка"
  let editMenu = g_menu_new()
  g_menu_append(editMenu, "Копировать", "app.copy")
  g_menu_append(editMenu, "Вставить", "app.paste")
  g_menu_append_section(menu, "Правка", cast[GMenuModel](editMenu))
  
  # Секция "Помощь"
  let helpMenu = g_menu_new()
  g_menu_append(helpMenu, "О программе", "app.about")
  g_menu_append_section(menu, "Помощь", cast[GMenuModel](helpMenu))
  gtk_menu_button_set_menu_model(menuButton, menu)
  
  # Дополнительное меню
  g_menu_append(menu2, "Пункт меню 1", "app.new")
  g_menu_append(menu2, "Пункт меню 2", "app.open")
  g_menu_append(menu2, "Пункт меню 3", "app.save")
  g_menu_append(menu2, "Закрыть приложение", "app.quit")
  gtk_menu_button_set_menu_model(auxButton, menu2)


  # HeaderBar
  let headerBar = gtk_header_bar_new()
  gtk_header_bar_pack_start(headerBar, menuButton)
  gtk_header_bar_pack_start(headerBar, auxButton)
  gtk_window_set_titlebar(window, headerBar)
  
  # === ПАНЕЛЬ ИНСТРУМЕНТОВ ===
  let toolbar = createHBox(5)
  setMargins(toolbar, 5)
  
  let btnNew = createButton("📄 Новый", cast[GCallback](onNewClicked))
  let btnOpen = createButton("📂 Открыть", cast[GCallback](onOpenClicked))
  let btnSave = createButton("💾 Сохранить", cast[GCallback](onSaveClicked))
  
  addChildren(toolbar, btnNew, btnOpen, btnSave)
  gtk_box_append(mainBox, toolbar)
  
  # Разделитель
  gtk_box_append(mainBox, gtk_separator_new(GTK_ORIENTATION_HORIZONTAL))
  
  # === ВКЛАДКИ ===
  let notebook = createNotebook()
  gtk_widget_set_vexpand(notebook, true)
  gtk_box_append(mainBox, notebook)
  
  # Вкладка 1: Текстовый редактор
  textView = gtk_text_view_new()
  setMargins(textView, 10)
  let scrolledWindow = createScrolledWindow(textView)
  discard addTab(notebook, scrolledWindow, "Текстовый редактор")
  
  # Вкладка 2: Элементы управления
  let controlsBox = createVBox(10)
  setMargins(controlsBox, 10)
  
  # Текстовое поле
  let entryBox = createHBox(5)
  gtk_box_append(entryBox, createLabel("Текстовое поле:"))
  entryField = createEntry("Введите текст здесь...")
  gtk_widget_set_hexpand(entryField, true)
  gtk_box_append(entryBox, entryField)
  gtk_box_append(controlsBox, entryBox)
  
  # SpinButton
  let spinBox = createHBox(5)
  gtk_box_append(spinBox, createLabel("Число:"))
  let spinButton = createSpinButton(0, 100, 1)
  gtk_box_append(spinBox, spinButton)
  gtk_box_append(controlsBox, spinBox)
  
  # CheckButton
  let checkButton = createCheckButton("Включить опцию")
  gtk_box_append(controlsBox, checkButton)
  
  # Switch
  let switchBox = createHBox(5)
  gtk_box_append(switchBox, createLabel("Переключатель:"))
  let switch = createSwitch()
  gtk_box_append(switchBox, switch)
  gtk_box_append(controlsBox, switchBox)
  
  # ComboBox
  let comboBox = createHBox(5)
  gtk_box_append(comboBox, createLabel("Выбор:"))
  let combo = gtk_combo_box_text_new()
  gtk_combo_box_text_append_text(combo, "Вариант 1")
  gtk_combo_box_text_append_text(combo, "Вариант 2")
  gtk_combo_box_text_append_text(combo, "Вариант 3")
  gtk_combo_box_set_active(cast[GtkComboBox](combo), 0)
  gtk_box_append(comboBox, combo)
  gtk_box_append(controlsBox, comboBox)
  
  # ProgressBar
  let progressBox = createVBox(5)
  gtk_box_append(progressBox, createLabel("Прогресс:"))
  progressBar = createProgressBar(0.65, true)
  gtk_progress_bar_set_text(progressBar, "65%")
  gtk_box_append(progressBox, progressBar)
  gtk_box_append(controlsBox, progressBox)
  
  # Scale
  let scaleBox = createVBox(5)
  gtk_box_append(scaleBox, createLabel("Слайдер:"))
  let scale = createScale(0, 100, 1, 50)
  gtk_scale_set_draw_value(scale, true)
  gtk_box_append(scaleBox, scale)
  gtk_box_append(controlsBox, scaleBox)
  
  # Кнопки
  let buttonBox = createHBox(5)
  
  let btnPrimary = createButton("Основная", cast[GCallback](onPrimaryClicked))
  addCssClass(btnPrimary, "suggested-action")
  gtk_widget_set_hexpand(btnPrimary, true)
  gtk_box_append(buttonBox, btnPrimary)
  
  let btnSecondary = createButton("Обычная", cast[GCallback](onSecondaryClicked))
  gtk_widget_set_hexpand(btnSecondary, true)
  gtk_box_append(buttonBox, btnSecondary)
  
  let btnDestructive = createButton("Удалить", cast[GCallback](onDestructiveClicked))
  # removeCssClass(btnDestructive)
  addCssClass(btnDestructive, "destructive-action")
  gtk_widget_set_hexpand(btnDestructive, true)
  gtk_box_append(buttonBox, btnDestructive)
  
  gtk_box_append(controlsBox, buttonBox)
  
  # Label
  infoLabel = createLabel("Статус: готов к работе")
  gtk_widget_set_margin_top(infoLabel, 10)
  gtk_box_append(controlsBox, infoLabel)

  discard addTab(notebook, controlsBox, "Элементы управления")


  # === СТРОКА СОСТОЯНИЯ ===
  statusbar = gtk_statusbar_new()
  let contextId = gtk_statusbar_get_context_id(statusbar, "main")
  discard gtk_statusbar_push(statusbar, contextId, "Готов | GTK4 через обёртку libGTK4.nim")
  gtk_box_append(mainBox, statusbar)


  # === ДЕЙСТВИЯ ПРИЛОЖЕНИЯ ===
  let actNew = g_simple_action_new("new", nil)
  discard connect(actNew, "activate", cast[GCallback](newAction))
  g_action_map_add_action(cast[GActionMap](app), actNew)

  let actOpen = g_simple_action_new("open", nil)
  discard connect(actOpen, "activate", cast[GCallback](openAction))
  g_action_map_add_action(cast[GActionMap](app), actOpen)

  let actSave = g_simple_action_new("save", nil)
  discard connect(actSave, "activate", cast[GCallback](saveAction))
  g_action_map_add_action(cast[GActionMap](app), actSave)

  let actCopy = g_simple_action_new("copy", nil)
  g_action_map_add_action(cast[GActionMap](app), actCopy)

  let actPaste = g_simple_action_new("paste", nil)
  g_action_map_add_action(cast[GActionMap](app), actPaste)

  let actAbout = g_simple_action_new("about", nil)
  discard connect(actAbout, "activate", cast[GCallback](aboutAction))
  g_action_map_add_action(cast[GActionMap](app), actAbout)

  let actQuit = g_simple_action_new("quit", nil)
  discard connect(actQuit, "activate", cast[GCallback](quitAction), cast[pointer](app))
  g_action_map_add_action(cast[GActionMap](app), actQuit)

  gtk_window_present(window)


# ============================================================================
# ГЛАВНАЯ ФУНКЦИЯ
# ============================================================================

proc main() =
  let app = gtk_application_new("org.example.gtk4nim", G_APPLICATION_DEFAULT_FLAGS)
  discard connect(app, "activate", cast[GCallback](onActivate))
  let status = g_application_run(cast[GApplication](app), 0, nil)
  quit(status)

main()







# nim c -d:release GTKRawTest2.nim


