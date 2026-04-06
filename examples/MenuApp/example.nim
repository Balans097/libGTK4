################################################################
##  example.nim — пример GTK4-приложения с меню из menu.json
##
##  Сборка:
##    nim c -r example.nim
##
##  Требования:
##    – libGTK4.nim и menuBuilder.nim в той же папке
##    – menu.json в той же папке (или передайте путь явно)
################################################################

import libGTK4
import menuBuilder


# ============================================================================
# Обработчики действий (actions)
# Каждый action из menu.json должен быть зарегистрирован здесь.
# ============================================================================

proc onActivate(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  let name = g_action_get_name(cast[GAction](action))
  echo "Действие: ", name


# ============================================================================
# Регистрация всех actions из menu.json
# ============================================================================

proc registerActions(app: GtkApplication) =
  ## Создаём GSimpleAction для каждого "app.*" из menu.json
  ## и добавляем в GActionMap приложения.
  let actionNames = [
    "createNewDocument",
    "openFileDialog",
    "saveCurrentDocument",
    "exportToPDF",
    "exportToCSV",
    "quitApplication",
    "undoAction",
    "redoAction",
    "openSettings",
    "openDocumentation",
    "showAboutDialog"
  ]

  for name in actionNames:
    let action = g_simple_action_new(name.cstring, nil)
    discard g_signal_connect(action, "activate", cast[GCallback](onActivate), nil)
    g_action_map_add_action(cast[GActionMap](app), cast[GAction](action))
    g_object_unref(cast[gpointer](action))

  # Сразу включаем/отключаем пункты согласно enabled в menu.json
  # (disabled: saveCurrentDocument, exportToCSV, redoAction)
  let actionMap = cast[GActionMap](app)

  for disabledName in ["saveCurrentDocument", "exportToCSV", "redoAction"]:
    let a = g_action_map_lookup_action(actionMap, disabledName.cstring)
    if a != nil:
      g_simple_action_set_enabled(cast[GSimpleAction](a), FALSE)


# ============================================================================
# Callback "activate" приложения
# ============================================================================

proc onAppActivate(appPtr: GtkApplication, userData: gpointer) {.cdecl.} =
  # 1. Регистрируем actions
  registerActions(appPtr)

  # 2. Создаём меню из JSON и устанавливаем его в приложение.
  #    GTK автоматически показывает menubar в окнах GtkApplicationWindow.
  discard createMenu(appPtr, "menu.json")

  # 3. Создаём главное окно
  let window = createAppWindow(appPtr, "Пример меню GTK4", 640, 480)

  # GtkApplicationWindow показывает menubar приложения автоматически.
  # Убеждаемся, что показ menubar включён (по умолчанию TRUE, но явно):
  #   gtk_application_window_set_show_menubar(window, TRUE)
  # Proc есть в расширенной части обёртки — вызываем через прямой импорт:
  proc gtk_application_window_set_show_menubar(w: GtkWindow, show: gboolean) {.importc, cdecl.}
  gtk_application_window_set_show_menubar(window, TRUE)

  # 4. Простой placeholder-виджет
  let label = createLabel("Меню загружено из menu.json.\nОткройте пункты вверху.")
  gtk_window_set_child(window, label)

  gtk_window_present(window)


# ============================================================================
# main
# ============================================================================

proc main() =
  let app = gtk_application_new("org.example.MenuDemo",
                                 G_APPLICATION_DEFAULT_FLAGS.gint)
  discard g_signal_connect(app, "activate", cast[GCallback](onAppActivate), nil)

  let status = g_application_run(cast[GApplication](app), 0, nil)
  g_object_unref(cast[gpointer](app))

  quit(status)

main()
