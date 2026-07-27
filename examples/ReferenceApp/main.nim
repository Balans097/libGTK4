################################################################
##  main.nim — точка входа
##
##  Только: определение языка системы, создание GTK-приложения
##  и запуск главного цикла. Всё остальное — в других модулях:
##    i18n.nim     — локализация (EN/RU)
##    config.nim   — константы и CSS
##    docmodel.nim    — модель документа
##    fileio.nim   — чтение/запись файлов
##    dialogs.nim  — диалоговые окна
##    actions.nim  — обработчики действий
##    gui.nim      — построение виджетов и раскладки
##
##  Сборка:
##    nim c -d:release main.nim
################################################################

import libGTK4
import config
import i18n
import gui


proc onActivate(app: GtkApplication, userData: gpointer) {.cdecl.} =
  setupWindow(app)


proc main() =
  # Язык определяется один раз, до создания каких-либо виджетов —
  # к моменту первого buildMenuBar() tr() уже должен отвечать на
  # правильном языке.
  setLanguage(detectSystemLocale())

  let app = gtk_application_new(
    config.appId.cstring,
    G_APPLICATION_DEFAULT_FLAGS.gint)

  discard g_signal_connect(app, "activate", cast[GCallback](onActivate), nil)

  let status = g_application_run(cast[GApplication](app), 0, nil)
  g_object_unref(cast[gpointer](app))
  quit(status)


main()
