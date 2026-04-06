################################################################
##  actions.nim — логика приложения
##
##  Содержит:
##    – состояние документа (AppState)
##    – реальное чтение/запись файлов (std/os)
##    – диалоги открытия и сохранения (GtkFileChooserDialog)
##    – все обработчики действий (action callbacks)
##    – регистрацию GAction в приложении
##
##  Не импортирует gui.nim.
################################################################

import std/os
import libGTK4


# ============================================================================
# Состояние приложения
# ============================================================================

type
  AppState* = object
    app*:         GtkApplication  ## само GTK-приложение
    window*:      GtkWindow       ## главное окно
    textBuffer*:  GtkTextBuffer   ## буфер текстового редактора
    statusLabel*: GtkLabel        ## метка строки состояния
    isModified*:  bool            ## документ изменён?
    docTitle*:    string          ## отображаемое имя (basename)
    docPath*:     string          ## полный путь; "" — ещё не сохранён


var state*: AppState              ## глобальный синглтон состояния


# ============================================================================
# Вспомогательные процедуры — статус, заголовок
# ============================================================================

proc setStatus*(msg: string) =
  if state.statusLabel != nil:
    gtk_label_set_text(state.statusLabel, msg.cstring)


proc markModified*(modified: bool) =
  state.isModified = modified
  let star  = if modified: " *" else: ""
  let title = "GTK4 Demo — " & state.docTitle & star
  gtk_window_set_title(state.window, title.cstring)


# ============================================================================
# Работа с буфером
# ============================================================================

proc bufferText*(): string =
  ## Вернуть всё содержимое текстового буфера.
  var startIter, endIter: GtkTextIter
  gtk_text_buffer_get_start_iter(state.textBuffer, addr startIter)
  gtk_text_buffer_get_end_iter(state.textBuffer,   addr endIter)
  let raw = gtk_text_buffer_get_text(
    state.textBuffer, addr startIter, addr endIter, FALSE)
  result = if raw != nil: $raw else: ""


proc setBufferText*(text: string) =
  gtk_text_buffer_set_text(state.textBuffer, text.cstring, text.len.gint)


proc appendText*(text: string) =
  var iter: GtkTextIter
  gtk_text_buffer_get_end_iter(state.textBuffer, addr iter)
  gtk_text_buffer_insert(state.textBuffer, addr iter, text.cstring, -1)
  markModified(true)
  setStatus("Текст добавлен.")


proc clearText*() =
  setBufferText("")
  state.docTitle = "Без имени"
  state.docPath  = ""
  markModified(false)
  setStatus("Документ очищен.")


proc countWords*(): int =
  var count  = 0
  var inWord = false
  for ch in bufferText():
    if ch in {' ', '\n', '\t', '\r'}:
      inWord = false
    else:
      if not inWord:
        inc count
        inWord = true
  result = count


# ============================================================================
# Реальное чтение / запись файла
# ============================================================================

proc saveToPath*(path: string): bool =
  ## Записать буфер в файл. Возвращает true при успехе.
  try:
    writeFile(path, bufferText())
    result = true
  except IOError as e:
    showErrorDialog(state.window, "Ошибка записи", e.msg)
    result = false


proc loadFromPath*(path: string): bool =
  ## Прочитать файл в буфер. Возвращает true при успехе.
  try:
    let content = readFile(path)
    setBufferText(content)
    result = true
  except IOError as e:
    showErrorDialog(state.window, "Ошибка чтения", e.msg)
    result = false


# ============================================================================
# Диалог «Открыть файл»
# ============================================================================

proc runOpenDialog*() =
  let dlg = gtk_file_chooser_dialog_new(
    "Открыть файл",
    state.window,
    GTK_FILE_CHOOSER_ACTION_OPEN,
    "Отмена".cstring,   GTK_RESPONSE_CANCEL.gint,
    "Открыть".cstring,  GTK_RESPONSE_ACCEPT.gint,
    nil)
  gtk_window_set_modal(cast[GtkWindow](dlg), TRUE)

  proc onResponse(dialog: GtkFileChooserDialog,
                  responseId: gint,
                  userData: gpointer) {.cdecl.} =
    if responseId == GTK_RESPONSE_ACCEPT.gint:
      let gfile = gtk_file_chooser_get_file(cast[GtkFileChooser](dialog))
      if gfile != nil:
        let cpath = g_file_get_path(gfile)
        if cpath != nil:
          let fullPath = $cpath
          g_free(cast[gpointer](cpath))
          if loadFromPath(fullPath):
            state.docPath  = fullPath
            state.docTitle = extractFilename(fullPath)
            markModified(false)
            setStatus("Открыт: " & state.docTitle)
        g_object_unref(cast[gpointer](gfile))
    gtk_window_destroy(cast[GtkWindow](dialog))

  discard g_signal_connect(dlg, "response",
    cast[GCallback](onResponse), nil)
  gtk_window_present(cast[GtkWindow](dlg))


# ============================================================================
# Диалог «Сохранить как»
# ============================================================================

proc runSaveAsDialog*() =
  let dlg = gtk_file_chooser_dialog_new(
    "Сохранить как",
    state.window,
    GTK_FILE_CHOOSER_ACTION_SAVE,
    "Отмена".cstring,    GTK_RESPONSE_CANCEL.gint,
    "Сохранить".cstring, GTK_RESPONSE_ACCEPT.gint,
    nil)
  gtk_window_set_modal(cast[GtkWindow](dlg), TRUE)

  # Предложить текущее имя файла
  let suggested =
    if state.docTitle == "Без имени": "документ.txt"
    else: state.docTitle
  gtk_file_chooser_set_current_name(
    cast[GtkFileChooser](dlg), suggested.cstring)

  proc onResponse(dialog: GtkFileChooserDialog,
                  responseId: gint,
                  userData: gpointer) {.cdecl.} =
    if responseId == GTK_RESPONSE_ACCEPT.gint:
      let gfile = gtk_file_chooser_get_file(cast[GtkFileChooser](dialog))
      if gfile != nil:
        let cpath = g_file_get_path(gfile)
        if cpath != nil:
          let fullPath = $cpath
          g_free(cast[gpointer](cpath))
          if saveToPath(fullPath):
            state.docPath  = fullPath
            state.docTitle = extractFilename(fullPath)
            markModified(false)
            setStatus("Сохранён: " & state.docTitle)
        g_object_unref(cast[gpointer](gfile))
    gtk_window_destroy(cast[GtkWindow](dialog))

  discard g_signal_connect(dlg, "response",
    cast[GCallback](onResponse), nil)
  gtk_window_present(cast[GtkWindow](dlg))


# ============================================================================
# Обработчики действий
# ============================================================================

proc onNew(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  if state.isModified:
    showInfoDialog(state.window,
      "Несохранённые изменения",
      "Документ изменён и не сохранён.\nИзменения будут потеряны.")
  clearText()
  setStatus("Новый документ создан.")


proc onOpen(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  runOpenDialog()


proc onSave(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  ## Если путь известен — сразу записать, иначе показать «Сохранить как».
  if state.docPath == "":
    runSaveAsDialog()
  else:
    if saveToPath(state.docPath):
      markModified(false)
      setStatus("Сохранён: " & state.docTitle)


proc onSaveAs(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  runSaveAsDialog()


proc onQuit(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  if state.isModified:
    showInfoDialog(state.window,
      "Несохранённые изменения",
      "Документ изменён и не сохранён.")
  g_application_quit(cast[GApplication](state.app))


proc onUndo(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  setStatus("Отмена последнего действия.")


proc onRedo(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  setStatus("Повтор последнего действия.")


proc onSelectAll(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  var startIter, endIter: GtkTextIter
  gtk_text_buffer_get_start_iter(state.textBuffer, addr startIter)
  gtk_text_buffer_get_end_iter(state.textBuffer,   addr endIter)
  gtk_text_buffer_select_range(state.textBuffer, addr startIter, addr endIter)
  setStatus("Весь текст выделен.")


proc onWordCount(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  let n = countWords()
  showInfoDialog(state.window, "Подсчёт слов", "Слов в документе: " & $n)
  setStatus("Слов: " & $n)


proc onInsertDemo(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  appendText("\nДемонстрационная строка № " & $countWords() & ".\n")


proc onAbout(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  let dlg = gtk_about_dialog_new()
  gtk_about_dialog_set_program_name(dlg, "GTK4 Demo")
  gtk_about_dialog_set_version(dlg, "1.0")
  gtk_about_dialog_set_comments(dlg,
    "Демонстрационное приложение\nна Nim + GTK4")
  var authors = ["Nim Developer".cstring, nil.cstring]
  gtk_about_dialog_set_authors(dlg, addr authors[0])
  gtk_window_set_transient_for(cast[GtkWindow](dlg), state.window)
  gtk_window_set_modal(cast[GtkWindow](dlg), TRUE)
  # GtkAboutDialog в GTK4 — GtkWindow, сигнала "response" нет.
  proc onClose(w: GtkWindow, ud: gpointer): gboolean {.cdecl.} =
    gtk_window_destroy(w)
    result = TRUE
  discard g_signal_connect(dlg, "close-request",
    cast[GCallback](onClose), nil)
  gtk_window_present(cast[GtkWindow](dlg))
  setStatus("О программе.")


proc onDocs(action: GSimpleAction, param: GVariant, userData: gpointer) {.cdecl.} =
  showInfoDialog(state.window, "Документация",
    "Документация доступна на:\nhttps://docs.gtk.org/gtk4/")
  setStatus("Открыта документация.")


# ============================================================================
# Регистрация действий в приложении
# ============================================================================

type
  ActionDef = object
    name*:     string
    callback*: proc(a: GSimpleAction, p: GVariant, u: gpointer) {.cdecl.}
    accel*:    string

const actionDefs: array[13, ActionDef] = [
  ActionDef(name: "new",        callback: onNew,        accel: "<Primary>n"),
  ActionDef(name: "open",       callback: onOpen,       accel: "<Primary>o"),
  ActionDef(name: "save",       callback: onSave,       accel: "<Primary>s"),
  ActionDef(name: "saveAs",     callback: onSaveAs,     accel: "<Primary><Shift>s"),
  ActionDef(name: "quit",       callback: onQuit,       accel: "<Primary>q"),
  ActionDef(name: "undo",       callback: onUndo,       accel: "<Primary>z"),
  ActionDef(name: "redo",       callback: onRedo,       accel: "<Primary>y"),
  ActionDef(name: "selectAll",  callback: onSelectAll,  accel: "<Primary>a"),
  ActionDef(name: "wordCount",  callback: onWordCount,  accel: "F5"),
  ActionDef(name: "insertDemo", callback: onInsertDemo, accel: ""),
  ActionDef(name: "about",      callback: onAbout,      accel: ""),
  ActionDef(name: "docs",       callback: onDocs,       accel: "F1"),
  ActionDef(name: "dummy",      callback: nil,          accel: ""),
]


proc registerActions*(app: GtkApplication) =
  for ad in actionDefs:
    if ad.callback == nil:
      continue
    let action = g_simple_action_new(ad.name.cstring, nil)
    discard g_signal_connect(action, "activate",
      cast[GCallback](ad.callback), nil)
    g_action_map_add_action(cast[GActionMap](app), cast[GAction](action))
    g_object_unref(cast[gpointer](action))

    if ad.accel != "":
      let detailedName = "app." & ad.name
      var accelArr: array[2, cstring]
      accelArr[0] = ad.accel.cstring
      accelArr[1] = nil
      gtk_application_set_accels_for_action(
        app, detailedName.cstring, addr accelArr[0])
