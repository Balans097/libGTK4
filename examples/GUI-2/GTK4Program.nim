################################################################
##  GTK4Program.nim — точка входа
##
##  Только инициализация GTK-приложения и запуск главного цикла.
##  Вся GUI — в gui.nim, вся логика — в actions.nim.
##
##  Сборка:
##    nim c -d:release GTK4Program.nim
################################################################

import libGTK4
import gui


proc onActivate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  setupWindow(app)


proc main() =
  let app = gtk_application_new(
    "org.example.GTK4Demo",
    G_APPLICATION_DEFAULT_FLAGS.gint)

  discard g_signal_connect(app, "activate",
    cast[GCallback](onActivate), nil)

  let status = g_application_run(cast[GApplication](app), 0, nil)
  g_object_unref(cast[gpointer](app))
  quit(status)

main()
