################################################################
##  gui.nim — построение интерфейса
##
##  Содержит:
##    – buildMenuBar  — формирует GMenu для строки меню
##    – buildEditor   — текстовый редактор с прокруткой
##    – buildStatusBar— нижняя строка состояния
##    – buildMainLayout — полная компоновка окна
##    – setupWindow   — инициализация главного окна
##
##  Не содержит логики — только GTK-виджеты и их компоновка.
##  Связь с логикой — через AppState из actions.nim.
################################################################

import libGTK4
import actions


# ============================================================================
# CSS — внешний вид
# ============================================================================

const appCSS = """
window {
  background-color: #f5f5f5;
}
.statusbar {
  background-color: #e8e8e8;
  border-top: 1px solid #c0c0c0;
  padding: 2px 8px;
  font-size: 0.85em;
  color: #444444;
}
.editor {
  font-family: monospace;
  font-size: 12pt;
  padding: 4px;
}
.toolbar-sep {
  margin: 0 4px;
  color: #aaaaaa;
}
"""


# ============================================================================
# Строка меню (GMenu model)
# ============================================================================

proc buildMenuBar*(app: GtkApplication): GMenu =
  ## Строит полную модель GMenu и устанавливает её как menubar приложения.
  let menuBar = g_menu_new()

  # ── Файл ──────────────────────────────────────────────────────────────────
  let fileMenu = g_menu_new()

  let itemNew  = g_menu_item_new("Создать",   "app.new")
  let itemOpen = g_menu_item_new("Открыть…",  "app.open")
  let itemSave = g_menu_item_new("Сохранить", "app.save")
  g_menu_append_item(fileMenu, itemNew)
  g_menu_append_item(fileMenu, itemOpen)
  g_object_unref(cast[gpointer](itemNew))
  g_object_unref(cast[gpointer](itemOpen))

  # Секция с Сохранить / Сохранить как (визуальный разделитель через section)
  let saveSection = g_menu_new()
  g_menu_append_item(saveSection, itemSave)
  g_object_unref(cast[gpointer](itemSave))
  g_menu_append(saveSection, "Сохранить как…", "app.saveAs")
  g_menu_append_section(fileMenu, nil, cast[GMenuModel](saveSection))
  g_object_unref(cast[gpointer](saveSection))

  # Подменю Экспорт
  let exportMenu = g_menu_new()
  g_menu_append(exportMenu, "Экспорт в PDF",  "app.dummy")
  g_menu_append(exportMenu, "Экспорт в HTML", "app.dummy")
  let itemExport = g_menu_item_new_submenu("Экспорт", cast[GMenuModel](exportMenu))
  g_menu_append_item(fileMenu, itemExport)
  g_object_unref(cast[gpointer](itemExport))
  g_object_unref(cast[gpointer](exportMenu))

  # Секция с Выход
  let quitSection = g_menu_new()
  g_menu_append(quitSection, "Выход", "app.quit")
  g_menu_append_section(fileMenu, nil, cast[GMenuModel](quitSection))
  g_object_unref(cast[gpointer](quitSection))

  g_menu_append_submenu(menuBar, "Файл", cast[GMenuModel](fileMenu))
  g_object_unref(cast[gpointer](fileMenu))

  # ── Правка ────────────────────────────────────────────────────────────────
  let editMenu = g_menu_new()

  let undoSection = g_menu_new()
  g_menu_append(undoSection, "Отменить",  "app.undo")
  g_menu_append(undoSection, "Повторить", "app.redo")
  g_menu_append_section(editMenu, nil, cast[GMenuModel](undoSection))
  g_object_unref(cast[gpointer](undoSection))

  let selSection = g_menu_new()
  g_menu_append(selSection, "Выделить всё", "app.selectAll")
  g_menu_append_section(editMenu, nil, cast[GMenuModel](selSection))
  g_object_unref(cast[gpointer](selSection))

  g_menu_append_submenu(menuBar, "Правка", cast[GMenuModel](editMenu))
  g_object_unref(cast[gpointer](editMenu))

  # ── Инструменты ───────────────────────────────────────────────────────────
  let toolsMenu = g_menu_new()
  g_menu_append(toolsMenu, "Подсчёт слов",         "app.wordCount")
  g_menu_append(toolsMenu, "Вставить демо-строку", "app.insertDemo")
  g_menu_append_submenu(menuBar, "Инструменты", cast[GMenuModel](toolsMenu))
  g_object_unref(cast[gpointer](toolsMenu))

  # ── Справка ───────────────────────────────────────────────────────────────
  let helpMenu = g_menu_new()
  g_menu_append(helpMenu, "Документация", "app.docs")
  let aboutSection = g_menu_new()
  g_menu_append(aboutSection, "О программе", "app.about")
  g_menu_append_section(helpMenu, nil, cast[GMenuModel](aboutSection))
  g_object_unref(cast[gpointer](aboutSection))
  g_menu_append_submenu(menuBar, "Справка", cast[GMenuModel](helpMenu))
  g_object_unref(cast[gpointer](helpMenu))

  gtk_application_set_menubar(app, cast[GMenuModel](menuBar))
  result = menuBar


# ============================================================================
# Текстовый редактор
# ============================================================================

proc buildEditor*(): GtkScrolledWindow =
  ## Возвращает GtkScrolledWindow с GtkTextView внутри.
  ## Также заполняет state.textBuffer.
  let tv = gtk_text_view_new()
  gtk_text_view_set_editable(tv, TRUE)
  gtk_text_view_set_monospace(tv, TRUE)
  gtk_text_view_set_wrap_mode(tv, PANGO_WRAP_WORD_CHAR)
  gtk_widget_set_margin_start(tv, 6)
  gtk_widget_set_margin_end(tv, 6)
  gtk_widget_set_margin_top(tv, 6)
  gtk_widget_set_margin_bottom(tv, 6)
  gtk_widget_add_css_class(tv, "editor")

  state.textBuffer = gtk_text_view_get_buffer(tv)

  # Подключаем сигнал изменения буфера → статус
  proc onChanged(buf: GtkTextBuffer, userData: gpointer) {.cdecl.} =
    markModified(true)
    setStatus("Редактирование…")

  discard g_signal_connect(state.textBuffer, "changed",
    cast[GCallback](onChanged), nil)

  let scroll = gtk_scrolled_window_new()
  gtk_scrolled_window_set_policy(scroll,
    GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
  gtk_scrolled_window_set_child(scroll, tv)
  gtk_widget_set_hexpand(scroll, TRUE)
  gtk_widget_set_vexpand(scroll, TRUE)

  result = scroll


# ============================================================================
# Строка состояния
# ============================================================================

proc buildStatusBar*(): GtkBox =
  ## Возвращает горизонтальный GtkBox, имитирующий строку состояния.
  ## Заполняет state.statusLabel.
  let bar = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0)
  gtk_widget_add_css_class(bar, "statusbar")

  let lbl = gtk_label_new("Готово.")
  gtk_label_set_xalign(lbl, 0.0.cfloat)
  gtk_widget_set_hexpand(lbl, TRUE)
  gtk_box_append(bar, lbl)

  # Правая часть — подсказка по горячим клавишам
  let hint = gtk_label_new("F1 — справка  F5 — слова  Ctrl+S — сохранить")
  gtk_label_set_xalign(hint, 1.0.cfloat)
  gtk_widget_set_margin_end(hint, 4)
  gtk_box_append(bar, hint)

  state.statusLabel = lbl
  result = bar


# ============================================================================
# Компоновка главного окна
# ============================================================================

proc buildMainLayout*(): GtkBox =
  ## Собирает вертикальный GtkBox: редактор + строка состояния.
  let root = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0)

  let editor    = buildEditor()
  let statusBar = buildStatusBar()

  gtk_box_append(root, cast[GtkWidget](editor))
  gtk_box_append(root, cast[GtkWidget](statusBar))

  result = root


# ============================================================================
# Инициализация окна
# ============================================================================

proc setupWindow*(app: GtkApplication) =
  ## Создаёт главное окно, меню, вкладывает компоновку, показывает окно.
  discard loadCssFromString(appCSS)

  # Регистрируем все action-ы ДО построения меню
  registerActions(app)

  # Строим меню и устанавливаем в приложение
  let menu = buildMenuBar(app)
  g_object_unref(cast[gpointer](menu))

  # Окно
  let win = createAppWindow(app, "GTK4 Demo — Без имени", 860, 560)
  state.window = win
  state.docTitle = "Без имени"
  state.app = app

  # Показываем menubar (GtkApplicationWindow показывает его автоматически,
  # но явный вызов гарантирует поведение на всех DE)
  gtk_application_window_set_show_menubar(cast[pointer](win), TRUE)

  # Компоновка
  let layout = buildMainLayout()
  gtk_window_set_child(win, cast[GtkWidget](layout))

  gtk_window_present(win)
  setStatus("Готово. Добро пожаловать в GTK4 Demo.")
