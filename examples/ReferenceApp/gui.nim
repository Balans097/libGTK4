################################################################
##  gui.nim — построение интерфейса
##
##  Строит виджеты и раскладку: меню, текстовый редактор,
##  статусбар, главное окно. Логику (что происходит по действию)
##  этот модуль не содержит — она подключается через
##  actions.registerActions; здесь только "из чего состоит экран".
##
##  Подписи меню и виджетов берутся через i18n.tr() — этот модуль
##  ничего не хардкодит на конкретном языке.
################################################################

import libGTK4
import config
import i18n
import docmodel
import actions


# ============================================================================
# Меню
#
# Модель меню (GMenu) собирается отдельно от виджета. Сам виджет —
# GtkPopoverMenuBar — встраивается в раскладку окна как обычный
# дочерний виджет (buildMainLayout), а не через "автоматическое" меню
# окна (gtk_application_set_menubar + show-menubar). Это осознанный
# выбор: у второго варианта на практике оказалось ненадёжным
# обновление уже показанного окна при подмене модели — а виджет,
# которым владеем мы сами, можно физически удалить и вставить заново
# (см. rebuildMenuBar), и тогда обновление гарантированно видно.
# ============================================================================

proc buildMenuModel(): GMenu =
  let menuBar = g_menu_new()

  # ── Файл ──
  let fileMenu = g_menu_new()
  g_menu_append(fileMenu, tr("menu.file.new").cstring,    "app.new")
  g_menu_append(fileMenu, tr("menu.file.open").cstring,   "app.open")
  g_menu_append(fileMenu, tr("menu.file.save").cstring,   "app.save")
  g_menu_append(fileMenu, tr("menu.file.saveAs").cstring, "app.saveAs")

  let exportMenu = g_menu_new()
  g_menu_append(exportMenu, tr("menu.file.exportPdf").cstring,  "app.saveAs")
  g_menu_append(exportMenu, tr("menu.file.exportHtml").cstring, "app.saveAs")
  g_menu_append_submenu(fileMenu, tr("menu.file.export").cstring, cast[GMenuModel](exportMenu))
  g_object_unref(cast[gpointer](exportMenu))

  g_menu_append(fileMenu, tr("menu.file.quit").cstring, "app.quit")
  g_menu_append_submenu(menuBar, tr("menu.file").cstring, cast[GMenuModel](fileMenu))
  g_object_unref(cast[gpointer](fileMenu))

  # ── Правка ──
  let editMenu = g_menu_new()
  g_menu_append(editMenu, tr("menu.edit.selectAll").cstring, "app.selectAll")
  g_menu_append_submenu(menuBar, tr("menu.edit").cstring, cast[GMenuModel](editMenu))
  g_object_unref(cast[gpointer](editMenu))

  # ── Инструменты ──
  let toolsMenu = g_menu_new()
  g_menu_append(toolsMenu, tr("menu.tools.wordCount").cstring,  "app.wordCount")
  g_menu_append(toolsMenu, tr("menu.tools.insertDemo").cstring, "app.insertDemo")
  g_menu_append_submenu(menuBar, tr("menu.tools").cstring, cast[GMenuModel](toolsMenu))
  g_object_unref(cast[gpointer](toolsMenu))

  # ── Настройки (язык) ──
  #
  # Оба пункта — один и тот же action "app.language", разный target
  # ("en"/"ru"). Пока target пункта совпадает с текущим состоянием
  # действия, GTK показывает его отмеченным — вручную рисовать
  # галочку не нужно.
  let settingsMenu = g_menu_new()

  let itemEN = g_menu_item_new(tr("menu.settings.langEn").cstring, nil)
  g_menu_item_set_action_and_target_value(
    itemEN, "app.language".cstring, g_variant_new_string("en".cstring))
  g_menu_append_item(settingsMenu, itemEN)
  g_object_unref(cast[gpointer](itemEN))

  let itemRU = g_menu_item_new(tr("menu.settings.langRu").cstring, nil)
  g_menu_item_set_action_and_target_value(
    itemRU, "app.language".cstring, g_variant_new_string("ru".cstring))
  g_menu_append_item(settingsMenu, itemRU)
  g_object_unref(cast[gpointer](itemRU))

  g_menu_append_submenu(menuBar, tr("menu.settings").cstring, cast[GMenuModel](settingsMenu))
  g_object_unref(cast[gpointer](settingsMenu))

  # ── Справка ──
  let helpMenu = g_menu_new()
  g_menu_append(helpMenu, tr("menu.help.docs").cstring,  "app.docs")
  g_menu_append(helpMenu, tr("menu.help.about").cstring, "app.about")
  g_menu_append_submenu(menuBar, tr("menu.help").cstring, cast[GMenuModel](helpMenu))
  g_object_unref(cast[gpointer](helpMenu))

  result = menuBar


proc buildMenuBarWidget(): GtkWidget =
  ## Собрать модель меню и обернуть её в виджет GtkPopoverMenuBar.
  ## Виджет держит собственную ссылку на модель, поэтому нашу можно
  ## сразу освободить.
  let model = buildMenuModel()
  result = cast[GtkWidget](gtk_popover_menu_bar_new_from_model(cast[pointer](model)))
  g_object_unref(cast[gpointer](model))


proc rebuildMenuBar*() =
  ## Пересобрать виджет меню на текущем языке и заменить им старый
  ## прямо в раскладке — вызывается из actions.switchLanguage через
  ## хук onLanguageChanged.
  let newWidget = buildMenuBarWidget()
  gtk_box_insert_child_after(state.mainBox, newWidget, state.menuBarWidget)
  gtk_box_remove(state.mainBox, state.menuBarWidget)
  state.menuBarWidget = newWidget


# ============================================================================
# Текстовый редактор
# ============================================================================

proc buildEditor(): GtkWidget =
  let scrolled = gtk_scrolled_window_new()
  let view     = gtk_text_view_new()
  gtk_widget_add_css_class(view, "editor")
  gtk_text_view_set_wrap_mode(cast[GtkTextView](view), PANGO_WRAP_WORD)

  state.textBuffer = gtk_text_view_get_buffer(cast[GtkTextView](view))

  proc onChanged(buf: GtkTextBuffer, userData: gpointer) {.cdecl.} =
    markModified(true)
    setStatus(tr("status.editing"))

  discard g_signal_connect(state.textBuffer, "changed", cast[GCallback](onChanged), nil)

  gtk_scrolled_window_set_child(cast[GtkScrolledWindow](scrolled), view)
  gtk_widget_set_vexpand(scrolled, TRUE)
  result = scrolled


# ============================================================================
# Статусбар
# ============================================================================

proc buildStatusBar(): GtkWidget =
  let bar = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0)
  gtk_widget_add_css_class(bar, "statusbar")

  let lbl = gtk_label_new(tr("app.welcome").cstring)
  gtk_label_set_xalign(cast[GtkLabel](lbl), 0.0.cfloat)
  gtk_widget_set_hexpand(lbl, TRUE)
  gtk_box_append(cast[GtkBox](bar), lbl)

  let hint = gtk_label_new(tr("status.hint").cstring)
  gtk_label_set_xalign(cast[GtkLabel](hint), 1.0.cfloat)
  gtk_widget_set_margin_end(hint, 4)
  gtk_box_append(cast[GtkBox](bar), hint)

  state.statusLabel = cast[GtkLabel](lbl)
  state.hintLabel   = cast[GtkLabel](hint)
  result = bar


# ============================================================================
# Компоновка главного окна
# ============================================================================

proc buildMainLayout(): GtkWidget =
  let box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0)
  state.mainBox = box

  state.menuBarWidget = buildMenuBarWidget()
  gtk_box_append(box, state.menuBarWidget)

  gtk_box_append(box, buildEditor())
  gtk_box_append(box, buildStatusBar())
  result = box


# ============================================================================
# Инициализация окна приложения
# ============================================================================

proc setupWindow*(app: GtkApplication) =
  discard loadCssFromString(appCSS)

  state.app = app
  registerActions(app)

  # Хук на смену языка: actions.nim не импортирует gui.nim (иначе был
  # бы цикл), поэтому он лишь дёргает этот хук через переменную-указатель
  # на процедуру, а саму пересборку меню делает gui.rebuildMenuBar.
  onLanguageChanged = rebuildMenuBar

  let win = createAppWindow(
    app,
    tr("app.title") & " — " & tr("app.title.untitled"),
    windowDefaultWidth,
    windowDefaultHeight)

  state.window   = win
  state.docTitle = tr("app.title.untitled")

  gtk_window_set_child(win, buildMainLayout())
  gtk_window_present(win)

  setStatus(tr("app.welcome"))
